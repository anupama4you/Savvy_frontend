import getQuotingData from "@salesforce/apex/quoteRacvCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import save from "@salesforce/apex/quoteRacvCalcController.save";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations"; // this line commented by nk

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let allTableRatesData = { 'Diamond Plus': null, 'Diamond': null, 'Sapphire': null, 'Ruby': null, 'Emerald': null };
let rates3List = [];
let riskGradeOptionsData = [];
// all table types defined
let formattedTableData = [];

const TABLE_DATA_COLUMNS = [
    { label: "0 - 3 years", fieldName: "comm1" },
    { label: "% NAF", fieldName: "comm2" },
    { label: "4 - 7 years", fieldName: "comm3" },
    { label: "% NAF", fieldName: "rate1" },
    { label: "7 years", fieldName: "rate2" },
    { label: "% NAF", fieldName: "rate3" },
];

const LENDER_QUOTING = "Racv";

const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["loanProduct", "Loan_Product__c"],
    ["price", "Vehicle_Price__c"],
    ["vehicleType", "Goods_type__c"],
    ["carAge", "Vehicle_Age__c"],
    ["vehCon", "Vehicle_Condition__c"],
    ["deposit", "Deposit__c"],
    ["tradeIn", "Trade_In__c"],
    ["payoutOn", "Payout_On__c"],
    ["applicationFee", "Application_Fee__c"],
    ["dof", "DOF__c"],
    ["ppsr", "PPSR__c"],
    ["residual", "Residual_Value__c"],
    ["clientRate", "Client_Rate__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["term", "Term__c"],
    ["paymentType", "Payment__c"],
    ["registrationFee", "Registration_Fee__c"],
    ["loanTypeDetail", "Loan_Facility_Type__c"],
    ["securedUnsecured", "Category_Type__c"],
    ["loanPurpose", "Loan_Purpose__c"],
    ["applicationId", "Application__c"],
    ["privateSales", "Private_Sales__c"],
    ["category", "Category_Type__c"],
    ["applicationId", "Application__c"],
    ["netDeposit", "Net_Deposit__c"],
    ["baseRate", "Base_Rate__c"],
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
    ["Id", "Id"], ...QUOTING_FIELDS
]);

const RATE_SETTING_NAMES = ["Racv_Rates__c"];

const SETTING_FIELDS = new Map([
    ["monthlyFee", "Monthly_Fee__c"],
    ["ppsr", "PPSR__c"],
    ["applicationFee", "Application_Fee__c"],
    ["registrationFee", "Registration_Fee__c"]
]);

const BASE_RATE_FIELDS = [
    "customerProfile",
    "loanTypeDetail",
    "vehicleType",
    "propertyOwner",
    "creditScore",
    "carAge"
];

const DOF_CALC_FIELDS = [
    "price",
    "deposit",
    "tradeIn",
    "payoutOn"
];

const calculate = (quote) =>
    new Promise((resolve, reject) => {
        console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
        let res = {
            commissions: QuoteCommons.resetResults(),
            messages: QuoteCommons.resetMessage()
        };
        console.log(`Calculating repayments...`, JSON.stringify(res, null, 2));
        // Validate quote
        res.messages = Validations.validate(quote, res.messages, false);
        console.log(`Calculating repayments...`, JSON.stringify(res, null, 2));
        if (res.messages && res.messages.errors.length > 0) {
            reject(res);
        } else {
            console.log('quote::', quote)
                // Prepare params
            const profile = quote.securedUnsecured === "Secured" ? "Secured" : "Unsecured";
            // new total calculated amount
            const totalAmount = calcNetRealtimeNaf(quote);
            // commRate is constant for eastimated Commission
            const commR = 2.25;
            const p = {
                lender: LENDER_QUOTING,
                productLoanType: quote.loanProduct,
                customerProfile: profile,
                privateSales: quote.privateSales,
                totalAmount: totalAmount,
                totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                clientRate: quote.clientRate,
                baseRate: quote.baseRate,
                paymentType: quote.paymentType,
                term: quote.term,
                dof: quote.dof,
                monthlyFee: quote.monthlyFee,
                residualValue: quote.residual,
                registrationFee: quote.registrationFee,
                loanTypeDetail: quote.loanTypeDetail,
                carPrice: quote.price,
                commRate: commR
            };

            // Calculate
            console.log(`@@param:`, JSON.stringify(p, null, 2));
            calculateRepayments({
                    param: p
                })
                .then((data) => {
                    console.log(`@@SF:`, JSON.stringify(data, null, 2));

                    // Mapping
                    res.commissions = QuoteCommons.mapCommissionSObjectToLwc(data);
                    console.log(JSON.stringify(res.commissions, null, 2));
                    // Validate the result of commissions
                    res.messages = Validations.validatePostCalculation(res.commissions, res.messages);
                    resolve(res);
                })
                .catch((error) => {
                    res.messages.errors.push({ field: "calculation", message: error });
                    reject(res);
                });
        }
    });

const calcOptions = {
    loanTypes: CommonOptions.loanTypes,
    paymentTypes: CommonOptions.paymentTypes,
    loanProducts: CommonOptions.consumerLoanProducts,
    privateSales: CommonOptions.yesNo,
    vehicleAges: [
        { label: "0", value: "0" },
        { label: "1", value: "1" },
        { label: "2", value: "2" },
        { label: "3", value: "3" },
        { label: "4", value: "4" },
        { label: "5", value: "5" },
        { label: "6", value: "6" },
        { label: "7", value: "7" },
        { label: "8", value: "8" },
        { label: "9", value: "9" },
        { label: "10", value: "10" },
        { label: "11", value: "11" },
        { label: "12", value: "12" },
        { label: "13", value: "13" },
        { label: "14", value: "14" },
        { label: "15", value: "15" },
        { label: "16", value: "16" },
        { label: "17", value: "17" },
        { label: "18", value: "18" },
        { label: "19", value: "19" },
        { label: "20+", value: "20" }

    ],
    propertyOwnerOpt: [
        { label: "--None--", value: "" },
        { label: "Yes", value: "Yes" },
        { label: "No", value: "No" }
    ],
    creditScoreOpt: [
        { label: "832+", value: "832+" },
        { label: "725-831", value: "725-831" },
        { label: "621-724", value: "621-724" },
        { label: "509-620", value: "509-620" },
        { label: "400-508", value: "400-508" }
    ],
    securedUnsecured: [
        { label: "Secured", value: "Secured" },
        { label: "Unsecured", value: "Unsecured" }
    ],
    vehicleTypes: [
        { label: "--None--", value: "" },
        { label: "Car", value: "CAR" },
        { label: "Motorbike", value: "MOTORBIKE" },
        { label: "Boats (or Personal Watercraft)", value: "BOAT" },
        { label: "Caravan", value: "CARAVAN" }
    ],
    classes: [
        { label: "--None--", value: "" },
        { label: "Borrower Type 1", value: "Borrower Type 1" },
        { label: "Borrower Type 2", value: "Borrower Type 2" },
        { label: "Borrower Type 3", value: "Borrower Type 3" }
    ],
    vehicleConditions: [
        { label: "--None--", value: "" },
        { label: "New", value: "NEW" },
        { label: "Demo", value: "DEMO" },
        { label: "Used", value: "USED" }
    ],
    terms: CommonOptions.terms(12, 84)
};

// Reset
const reset = (recordId) => {
    let r = {
        oppId: recordId,
        quoteName: LENDER_QUOTING,
        loanType: calcOptions.loanTypes[0].value,
        loanProduct: calcOptions.loanProducts[0].value,
        category: null,
        vehicleType: calcOptions.vehicleTypes[0].value,
        carAge: calcOptions.vehicleAges[0].value,
        vehCon: '',
        monthlyFee: null,
        ppsr: null,
        applicationFee: null,
        registrationFee: null,
        baseRate: 0.0,
        maxRate: 0.0,
        clientRate: 0.0,
        price: null,
        deposit: null,
        tradeIn: null,
        payoutOn: null,
        maxApplicationFee: null,
        dof: null,
        maxDof: null,
        residual: null,
        term: calcOptions.terms[0].value,
        privateSales: calcOptions.privateSales[1].value,
        paymentType: calcOptions.paymentTypes[0].value,
        loanTypeDetail: calcOptions.classes[0].value,
        commissions: QuoteCommons.resetResults(),
        registrationFee: 3.40
    };
    r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
    return r;
};

// Load Data
const loadData = (recordId) =>
    new Promise((resolve, reject) => {
        //  const fields = Array.from(QUOTING_FIELDS.values());
        const fields = [
            ...QUOTING_FIELDS.values(),
            ...QuoteCommons.COMMISSION_FIELDS.values()
        ];
        console.log(`@@fields:`, JSON.stringify(fields, null, 2));
        getQuotingData({
                param: {
                    oppId: recordId,
                    fields: fields,
                    calcName: LENDER_QUOTING,
                    rateSettings: RATE_SETTING_NAMES
                }
            })
            .then((quoteData) => {
                console.log('@@SF:', JSON.stringify(quoteData, null, 2));
                // Mapping Quote's fields
                let data = QuoteCommons.mapSObjectToLwc({
                    calcName: LENDER_QUOTING,
                    defaultData: reset(recordId),
                    quoteData: quoteData,
                    settingFields: SETTING_FIELDS,
                    quotingFields: QUOTING_FIELDS
                });

                // Settings
                lenderSettings = quoteData.settings;

                console.log('quoteData Racv-->>', quoteData);
                console.log('quoteData.rateSettings:::', JSON.stringify(quoteData.rateSettings, null, 2));
                console.log('lenderSettings Racv:::', JSON.stringify(lenderSettings, null, 2));

                // Rate Settings
                if (quoteData.rateSettings) {
                    tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];

                     console.log(`@@tableData:`, JSON.stringify(tableRatesData, null, 2));

                }
                console.log('tableRatesData-->>',tableRatesData);
                console.log(`@@data:`, JSON.stringify(data, null, 2));
                resolve(data);
            })
            .catch((error) => reject(error));
    });

// Get Base Rates
const getMyBaseRates = (quote) =>
    new Promise((resolve, reject) => {
        console.log(`quote inserted...`, JSON.stringify(quote, null, 2));
        const profile = quote.category;
        const p = {
            lender: LENDER_QUOTING,
            customerProfile: profile,
            loanTypeDetail: quote.loanTypeDetail,
            goodsType: quote.category,
            propertyOwner: quote.propertyOwner,
            creditScore: quote.creditScore,
            hasMaxRate: true,
            carAge: quote.carAge
        };
        console.log(`getMyBaseRates...`, JSON.stringify(p, null, 2));
        getBaseRates({
                param: p
            })
            .then((rates) => {
                console.log(`@@SF:`, JSON.stringify(rates, null, 2));
                resolve(rates);
            })
            .catch((error) => reject(error));
    });

// Get Quote Fees
const getQuoteFees = (quote) => {
    if ('Secured' === quote.securedUnsecured) {
        quote.ppsr = lenderSettings.PPSR__c;
        quote.registrationFee = lenderSettings.Registration_Fee__c;
    } else if ('Unsecured' === quote.securedUnsecured) {
        quote.ppsr = 0.00;
        quote.registrationFee = 0.00;
    }
    return quote;
}

// Get Single table out using #category and #class
const getSingleTable = (category, class_) => {

    let fieldsList = { "score": [], "loanAmount": [], "hg3": [], "hl3": [], "nhg3": [], "nhl3": [] }

    if (category) {
        // devide the data into categories
        tableRatesData.forEach((obj, key, map) => {

            if (obj.Asset_Type__c === category) {
                    console.log(`getSingleTable...`, JSON.stringify(obj, null, 2));

                    if (obj.Asset_Age__c == '0 - 3 years') {
                        fieldsList.comm1.push(obj.Rate__c);
                        fieldsList.comm2.push(obj.Comm__c);
                    } else if (obj.Asset_Age__c == '4 - 7 years') {
                        fieldsList.comm3.push(obj.Rate__c);
                        fieldsList.rate1.push(obj.Comm__c);
                    } else if (obj.Asset_Age__c == '> 7 years') {
                        fieldsList.rate2.push(obj.Rate__c);
                        fieldsList.rate3.push(obj.Comm__c);
                    }
            }
        });

        console.log(`fieldsList...`, JSON.stringify(fieldsList, null, 2));

        const singleTable = [];

        for (let j = 0; j < 9; j++) {

            const row = {
                "comm1": Object.values(fieldsList)[0][j],
                "comm2": Object.values(fieldsList)[1][j],
                "comm3": Object.values(fieldsList)[2][j],
                "rate1": Object.values(fieldsList)[3][j],
                "rate2": Object.values(fieldsList)[4][j],
                "rate3": Object.values(fieldsList)[5][j],
            }
            singleTable.push(row);
        }
        return singleTable;
    } else {
        return [];
    }
};

// Get all tables data
const getAllTableData = (category) => {
    console.log('category-->'+category);
    console.log('calcOptions.classes[0].value-->'+calcOptions.classes[1].value);
    // empty the array
    console.log('tableRatesData-->>',tableRatesData);

    formattedTableData = [];
    tableRatesData.forEach((obj, key, map) => {

        if (obj.Asset_Type__c === category) {
                formattedTableData.push(obj);
        }
    });
    /*formattedTableData.splice(0, formattedTableData.length);
    // Borrower Type 1 
    formattedTableData.push({ data: getSingleTable(category, calcOptions.classes[1].value), colName: calcOptions.classes[1].value });
    // Borrower Type 2
    formattedTableData.push({ data: getSingleTable(category, calcOptions.classes[2].value), colName: calcOptions.classes[2].value });
    // Borrower Type 3
    formattedTableData.push({ data: getSingleTable(category, calcOptions.classes[3].value), colName: calcOptions.classes[3].value });    
    */
    return formattedTableData;
};

// custom calculations for NAF generations
const calcNetRealtimeNaf = (quote) => {
    console.log('variables', quote.price, quote.applicationFee, quote.dof, quote.ppsr, quote.registrationFee)
    let netRealtimeNaf = QuoteCommons.calcNetRealtimeNaf(quote);
    console.log('variables', netRealtimeNaf);
    let r = quote.registrationFee + netRealtimeNaf;
    return r;
}

const calcDOF = (quote) => {
    quote.dof = 0;
    let naf = QuoteCommons.calcNetRealtimeNaf(quote);
    console.log('CalcDOF::', QuoteCommons.calcNetRealtimeNaf(quote), quote.dof)
    let r = quote.registrationFee + naf;
    console.log('calcDOF', r)
    if (r > 20000) {
        r = 1650.00;
    } else if (r > 0) {
        r = r * 0.15;
        if (r >= 990) {
            r = 990.0;
        }
    } else {
        r = 0;
    }
    console.log('calcNetRealtimeDOF', r)
    return r;
}

/**
 * -- Lee
 * @param {String} approvalType - string and what type of the button
 * @param {Object} param - quote form
 * @param {Id} recordId - recordId
 */
const saveQuote = (approvalType, param, recordId) =>
    new Promise((resolve, reject) => {
        if (approvalType && param && recordId) {
            save({
                    param: QuoteCommons.mapLWCToSObject(
                        param,
                        recordId,
                        LENDER_QUOTING,
                        FIELDS_MAPPING_FOR_APEX
                    ),
                    approvalType: approvalType
                })
                .then((data) => {
                    resolve(data);
                })
                .catch((error) => {
                    reject(`error in saveApproval ${approvalType}: `, error.messages);
                });
        } else {
            reject(
                new Error(
                    `Something Wrong, appType: ${approvalType}, param: ${JSON.stringify(
            param,
            null,
            2
          )}, param: ${recordId}`
                )
            );
        }
    });

/**
 *  -- Lee
 * @param {Object} param - quote form
 * @param {Id}  recordId - record id
 * @returns
 */
const sendEmail = (param, recordId) =>
    new Promise((resolve, reject) => {
        if (param) {
            console.log(`@@param in sendEmail ${JSON.stringify(param, null, 2)}`);
            sendQuote({
                    param: QuoteCommons.mapLWCToSObject(
                        param,
                        recordId,
                        LENDER_QUOTING,
                        FIELDS_MAPPING_FOR_APEX
                    )
                })
                .then((data) => {
                    resolve(data);
                })
                .catch((error) => {
                    reject(error);
                });
        } else {
            reject(new Error(`Something wrong in sendEmail : param: ${param}`));
        }
    });


export const CalHelper = {
    options: calcOptions,
    calculate: calculate,
    load: loadData,
    reset: reset,
    baseRates: getMyBaseRates,
    BASE_RATE_FIELDS: BASE_RATE_FIELDS,
    lenderSettings: lenderSettings,
    getSingleTable: getSingleTable,
    TABLE_DATA_COLUMNS: TABLE_DATA_COLUMNS,
    getNetRealtimeNaf: calcNetRealtimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    getQuoteFees: getQuoteFees,
    getDOF: calcDOF,
    DOF_CALC_FIELDS: DOF_CALC_FIELDS,
    getAllTableData: getAllTableData,
    saveQuote: saveQuote,
    sendEmail: sendEmail
};