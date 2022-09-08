import getQuotingData from "@salesforce/apex/QuoteCapitalFinanceController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteCapitalFinanceController.save";
import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData1 = [];
let tableRatesData2 = [];
let tableRatesData3 = [];

const tableRateDataColumns = [
    { label: "Amount (Inc. GST)", fieldName: "Amount_Inc_GST__c", fixedWidth: 400 },
    { label: "24 - 60 months", fieldName: "Term_24_60_months__c", fixedWidth: 400 },
];
const tableRateDataColumns2 = [
    { label: "Amount (Inc. GST)", fieldName: "Amount_Inc_GST__c", fixedWidth: 400 },
    { label: "24 - 60 months", fieldName: "Term_24_60_months__c", fixedWidth: 400 },
];
const tableRateDataColumns3 = [
    { label: "Amount (Inc. GST)", fieldName: "Amount_Inc_GST__c", fixedWidth: 200 },
    { label: "New Primary", fieldName: "New_Primary__c", fixedWidth: 200 },
    { label: "Used Primary > 4 years old", fieldName: "Used_Primary_4_years_old__c", fixedWidth: 300 },
    { label: "Used Primary > 6 years old", fieldName: "Used_Primary_6_years_old__c", fixedWidth: 300 },
    { label: "New Secondary", fieldName: "New_Secondary__c", fixedWidth: 200 },
    { label: "New Tertiary", fieldName: "New_Tertiary__c", fixedWidth: 200 },
];
const tables = {
    tableRateDataColumns1: tableRateDataColumns,
    tableRateDataColumns2: tableRateDataColumns2,
    tableRateDataColumns3: tableRateDataColumns3,
};

const LENDER_QUOTING = "Capital Finance";

const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["assetType", "Goods_type__c"],
    ["price", "Vehicle_Price__c"],
    ["deposit", "Deposit__c"],
    ["tradeIn", "Trade_In__c"],
    ["payoutOn", "Payout_On__c"],
    ["applicationFee", "Application_Fee__c"],
    ["ppsr", "PPSR__c"],
    ["residualPer", "Residual_Value_Percentage__c"],
    ["residualValue", "Residual_Value__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["term", "Term__c"],
    ["paymentType", "Payment__c"],
    ["interestRate", "Client_Rate__c"],
    ["abnLength", "Extra_Label_1__c"],
    ["gstLength", "Extra_Label_2__c"],
    ["assetAge", "Vehicle_Age__c"],
    ["propertyOwner", "Customer_Profile__c"],
    ["privateSale", "Private_Sales__c"],
    ["brokeragePercentage", "Brokerage__c"],
    ["baseRate", "Base_Rate__c"],
    // ["clientRate", "Client_Rate__c"],
    ["netDeposit", "Net_Deposit__c"],
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
    ...QUOTING_FIELDS,
    ["Id", "Id"],
]);

const RATE_SETTING_NAMES = [
    "Motor Vehicles",
    "Primary Assets",
    "Small Ticket"
];

const SETTING_FIELDS = new Map([
]);

const BASE_RATE_FIELDS = [
    "customerProfile",
    "assetType",
    "assetAge",
    "price",
    "term",
];

const totalAmountWithPpsr = (quote) => {
    let total = QuoteCommons.calcTotalAmount(quote);
    return total;
};

const getBaseAmountPmtCalc = (param, per) => {
    let r = 0;
    param.price && (r += param.price);
    r += QuoteCommons.calcTotalInsuranceType(param);
    r -= QuoteCommons.calcNetDeposit(param);
    return r;
};

const calculate = (quote) =>
    new Promise((resolve, reject) => {
        console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
        let res = {
            commissions: QuoteCommons.resetResults(),
            messages: QuoteCommons.resetMessage()
        };
        // Validate quote
        res.messages = Validations.validate(quote, res.messages);
        if (res.messages && res.messages.errors.length > 0) {
            reject(res);
        } else {
            // Prepare params
            let profile = "COMMERCIAL";
            const p = {
                lender: LENDER_QUOTING,
                goodsType: quote.assetType,
                totalAmount: totalAmountWithPpsr(quote),
                totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                baseRate: quote.baseRate,
                paymentType: quote.paymentType,
                term: quote.term,
                // dof: quote.dof,
                monthlyFee: quote.monthlyFee,
                residualValue: quote.residualValue,
                customerProfile: profile,
                vehicleYear: quote.assetAge,
                brokeragePer: quote.brokeragePercentage,
                amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
                amountBaseComm: getBaseAmountPmtCalc(quote, quote.projPer),
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
                    res.netDeposit = QuoteCommons.calcNetDeposit(quote);
                    resolve(res);
                })
                .catch((error) => {
                    res.messages.errors.push({ field: "calculation", message: error });
                    reject(res);
                });
        }
    });

const calcOptions = {
    loanTypes: [
        ...CommonOptions.loanTypes,
        { label: "Novated Lease", value: "Novated Lease" },
        { label: "Small Ticket", value: "Small Ticket" },
    ],
    loanProducts: [
        { label: "MV < 4.5T", value: "MV < 4.5T" },
        { label: "Trucks/Agri/Yellow goods", value: "Trucks/Agri/Yellow goods" },
    ],
    assetTypes: [
        { label: "MV < 4.5T", value: "MV < 4.5T" },
        { label: "Trucks/Agri/Yellow goods", value: "Trucks/Agri/Yellow goods" },
    ],
    terms: CommonOptions.terms(0, 72),
    paymentTypes: CommonOptions.paymentTypes,
    abnLengths: [
        { label: "< 2 years", value: "< 2 years" },
        { label: "> 2 years", value: "> 2 years" },
    ],
    gstLengths: [
        { label: "No GST", value: "No GST" },
        { label: "> 1 day", value: "> 1 day" },
    ],
    assetAges: [
        { label: "New - 4 years", value: "New - 4 years" },
        { label: "> 4 years", value: "> 4 years" },
        { label: "> 6 years", value: "> 6 years" },
    ],
    propOwns: [
        { label: "No", value: "N" },
        { label: "Yes", value: "Y" },
    ],
    privateSales: [
        { label: "Yes", value: "Y" },
        { label: "No", value: "N" },
    ],
    typeValues: [
        { label: "Percentage", value: "Percentage" },
        { label: "Value", value: "Value" },
    ],
};

// Reset
const reset = () => {
    let r = {
        loanType: calcOptions.loanTypes[0].value,
        assetType: calcOptions.assetTypes[0].value,
        price: null,
        deposit: null,
        tradeIn: null,
        payoutOn: null,
        applicationFee: 8.0,
        // dof: 0.0,
        ppsr: 0.0,
        residualValue: 0.0,
        monthlyFee: 0.0,
        maxDof: null,
        term: 24,
        paymentType: "Advance",
        interestRate: 3.0,
        baseRate: 0.0,
        abnLength: calcOptions.abnLengths[0].value,
        gstLength: calcOptions.gstLengths[0].value,
        assetAge: calcOptions.assetAges[0].value,
        propertyOwner: calcOptions.propOwns[0].value,

        // clientRate: 5.04,
        commissions: QuoteCommons.resetResults(),
        typeValue: "Value",
    };
    r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
    return r;
};

// Load Data
const loadData = (recordId) =>
    new Promise((resolve, reject) => {
        const fields = [
            ...QUOTING_FIELDS.values(),
            ...QuoteCommons.COMMISSION_FIELDS.values()
        ];
        console.log('recordId: ', recordId);
        getQuotingData({
            param: {
                oppId: recordId,
                fields: fields,
                calcName: LENDER_QUOTING,
                rateSettings: RATE_SETTING_NAMES
            }
        })
            .then((quoteData) => {
                console.log(`@@SF Get Data:`, JSON.stringify(quoteData, null, 2));
                // Mapping Quote's fields
                let data = QuoteCommons.mapSObjectToLwc({
                    calcName: LENDER_QUOTING,
                    defaultData: reset(),
                    quoteData: quoteData,
                    settingFields: SETTING_FIELDS,
                    quotingFields: QUOTING_FIELDS
                });
                // Settings
                lenderSettings = quoteData.settings;
                // Rate Settings
                if (quoteData.rateSettings) {
                    tableRatesData1 = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
                    tableRatesData2 = quoteData.rateSettings[`${RATE_SETTING_NAMES[1]}`];
                    tableRatesData3 = quoteData.rateSettings[`${RATE_SETTING_NAMES[2]}`];
                }
                data.typeValue = "Value";
                resolve(data);
            })
            .catch((error) => reject(error));
    });


const getTableRatesData = () => {
    return tableRatesData1;
};
const getTableRatesData2 = () => {
    return tableRatesData2;
};
const getTableRatesData3 = () => {
    return tableRatesData3;
};

const getResidualValue = (quote) => {
    const res = ((quote.price - QuoteCommons.calcNetDeposit(quote)) * quote.residualPer) / 100;
    return res.toFixed(2);
};

const getResidualPercentage = (quote) => {
    const res = (quote.residualValue / (quote.price - QuoteCommons.calcNetDeposit(quote))) * 100;
    return res.toFixed(2);
    // return (quote.residualValue / (quote.price - QuoteCommons.calcNetDeposit(quote))) * 100;
};

// Get Base Rates
const getMyBaseRates = (quote) =>
    new Promise((resolve, reject) => {
        const profile = "LEISURE";
        const p = {
            lender: LENDER_QUOTING,
            assetType: quote.assetType,
            clientTier: quote.clientTier,
            vehicleYear: quote.vehicleYear,
            customerProfile: profile,
            privateSales: quote.privateSales,
            hasMaxRate: true,

            term: quote.term,
            brokeragePer: quote.brokeragePer,
            totalAmount: QuoteCommons.calcTotalAmount(quote),
            residualValue: quote.residual,
            paymentType: quote.paymentType,
            amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
            assetAge: quote.assetAge,
        };
        console.log(`getMyBaseRates...`, JSON.stringify(p, null, 2));
        getBaseRates({
            param: p
        })
            .then((rates) => {
                console.log(`@@SF BaseRate:`, JSON.stringify(rates, null, 2));
                resolve(rates);
            })
            .catch((error) => reject(error));
    });

const saveQuote = (approvalType, param, recordId) =>
    new Promise((resolve, reject) => {
        if (approvalType && param && recordId) {
            console.log(`HELPER SAVE ${JSON.stringify(param, null, 2)}`);
            // param.clientRate = parseFloat(param.clientRate).toFixed(2);
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
                    reject(error);
                });
        } else {
            reject(new Error("QUOTE OR RECORDID EMPTY in SaveQuoting function"));
        }
    });

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

const nafIncludePpsr = (quote) => {
    let naf = QuoteCommons.calcNetRealtimeNaf(quote);
    return naf;
};

const getBaseAmountPmtInclBrokerageCalc = (param) => {
    const naf = nafIncludePpsr(param);
    let r = 0;
    if (param.brokeragePercentage) {
        r = (naf + naf * (param.brokeragePercentage / 100));
    }
    return r;
};

//  r == 0.1 means fu.rate2() return the default value. It is the reset value.
const getClientRateCalc = (quote) => {
    // let r = 0;
    const naf = nafIncludePpsr(quote);
    let fv = 0;
    quote.residualValue && (fv = quote.residualValue);
    const amuntPmt = getBaseAmountPmtInclBrokerageCalc(quote);
    let type = 0;
    if (quote.paymentType === "Advance") {
        type = 1;
    }
    const pmt = fu.pmt2((quote.baseRate / 100 / 12),
        quote.term,
        (amuntPmt * -1),
        fv,
        type
    );
    const r = fu.rate2(
        quote.term,
        (pmt * -1.0),
        naf,
        (fv * -1),
        type
    );
    if (r == 0.1) {
        return quote.baseRate;
    }
    let res = (r * 12 * 100).toFixed(2);
    return res;
};

const tableDatas = {
    tableRatesData1: getTableRatesData,
    tableRatesData2: getTableRatesData2,
    tableRatesData3: getTableRatesData3,
};

export const CalHelper = {
    options: calcOptions,
    calculate: calculate,
    load: loadData,
    reset: reset,
    baseRates: getMyBaseRates,
    BASE_RATE_FIELDS: BASE_RATE_FIELDS,
    lenderSettings: lenderSettings,
    getNetRealtimeNaf: nafIncludePpsr,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    saveQuote: saveQuote,
    sendEmail: sendEmail,
    // clientRate: getClientRateCalc,
    tableRateDataColumns: tableRateDataColumns,
    tables: tables,
    tableDatas, tableDatas,
    getResiVal: getResidualValue,
    getResiPer: getResidualPercentage,
};