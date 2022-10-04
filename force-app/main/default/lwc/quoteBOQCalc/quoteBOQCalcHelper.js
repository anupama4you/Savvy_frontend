import getQuotingData from "@salesforce/apex/QuoteBOQController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteBOQController.save";

import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let tableRatesData2 = [];
let tableRatesData3 = [];
const CUSTOMER_RATE = "CustomerInterestRate__c";
const BASE_RATE = "BaseCommisionRate__c";

let tableRateDataColumns = [
    { label: "% Customer Interest Rate", fieldName: "CustomerInterestRate__c", fixedWidth: 230 },
    { label: "% Base Commission Rate", fieldName: "BaseCommisionRate__c", fixedWidth: 230 },
];

const LENDER_QUOTING = "BOQ";

const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["loanProduct", "Loan_Product__c"],
    ["riskGrade", "Client_Tier__c"],
    ["assetType", "Goods_type__c"],
    ["assetCondition", "Vehicle_Condition__c"],
    ["price", "Vehicle_Price__c"],
    ["deposit", "Deposit__c"],
    ["tradeIn", "Trade_In__c"],
    ["payoutOn", "Payout_On__c"],
    ["applicationFee", "Application_Fee__c"],
    ["dof", "DOF__c"],
    ["ppsr", "PPSR__c"],
    ["residual", "Residual_Value__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["term", "Term__c"],
    ["resiStatus", "Residency__c"],
    ["assetAge", "Vehicle_Age__c"],
    ["privateSales", "Private_Sales__c"],
    ["paymentType", "Payment__c"],
    ["baseRate", "Base_Rate__c"],
    ["clientRate", "Client_Rate__c"],
    ["netDeposit", "Net_Deposit__c"],
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
    ...QUOTING_FIELDS,
    ["Id", "Id"],
    ["privateSales", "Private_Sales__c"],
    // ["clientTier", "Client_Tier__c"],
    ["assetAge", "Vehicle_Age__c"],
    // ["baseRate", "Base_Rate__c"],
    ["maxRate", "Manual_Max_Rate__c"]
]);

const RATE_SETTING_NAMES = ["PlatPlus", "Plat", "Gold"];

const rateMapping = {
    "Platinum Plus": "PlatPlus",
    "Platinum": "Plat",
    "Gold": "Gold"
};

const SETTING_FIELDS = new Map([
    ["applicationFee", "Application_Fee__c"],
    ["maxApplicationFee", "Application_Fee__c"],
    ["dof", "DOF__c"],
    ["maxDof", "DOF__c"],
    ["ppsr", "PPSR__c"],
    ["monthlyFee", "Monthly_Fee__c"]
]);

const BASE_RATE_FIELDS = [
    "customerProfile",
    "clientTier",
    "assetAge",
    "assetType",
    "privateSales"
];

const calVehiclePrice = (quote) => {
    let r = quote.price;
    r -= QuoteCommons.calcNetDeposit(quote);
    return r;
};

const getBaseCommRate = (quote) => {
    // Gold, 8.95, 
    const { riskGrade, baseRate, rateSettings } = quote;
    const ratesAttr = rateMapping[riskGrade];
    const rateObj = rateSettings[ratesAttr].find(rate => rate.CustomerInterestRate__c == baseRate);
    const baseCommRate = rateObj.BaseCommisionRate__c;
    return baseCommRate;
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
            // let profile = "COMMERCIAL";
            const p = {
                lender: LENDER_QUOTING,
                totalAmount: QuoteCommons.calcTotalAmount(quote),
                totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                clientRate: quote.clientRate,
                baseRate: quote.baseRate,
                paymentType: quote.paymentType,
                term: quote.term,
                dof: quote.dof,
                monthlyFee: quote.monthlyFee,
                residualValue: quote.residual,
                vehiclePrice: calVehiclePrice(quote),
                commRate: getBaseCommRate(quote),
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

const assetAgeMaker = (start, end) => {
    const ages = [];
    for (let i = start; i <= end; ++i) {
        ages.push({ label: i.toString(), value: i.toString() });
    }
    return ages;
};

/**
 * Author: Rick
 * @param {number} gap  
 * @param {number} decimal MUST BE Integer,
 * decimal = 2, means 0.01, decimal = 4 means 0.0001
 * @returns 
 */
const makeGap = (gap, decimal) => {
    const makeRate = (start, end) => {
        const rates = [];
        const times = Math.pow(10, decimal);
        for (let i = start * times; i <= end * times; i += (gap * times)) {
            const t = (i / times).toFixed(decimal);
            rates.push({ label: t, value: parseFloat(t) });
        }
        return rates;
    };
    return makeRate;
};
const rateGapDot10 = makeGap(0.1, 2);

const calcOptions = {
    loanTypes: CommonOptions.loanTypes,
    loanProducts: [
        { label: "Consumer Loan", value: "Consumer Loan" },
        ...CommonOptions.businessLoanProducts,
    ],
    riskGrades: [
        { label: "Platinum Plus", value: "Platinum Plus" },
        { label: "Platinum", value: "Platinum" },
        { label: "Gold", value: "Gold" },
    ],
    assetTypes: [
        { label: "Marine", value: "Marine" },
        { label: "Caravans", value: "Caravans" },
        { label: "Motorhome", value: "Motorhome" },
        { label: "Campertrailer", value: "Campertrailer" },
    ],
    assetConditions: [
        { label: "New", value: "New" },
        { label: "Used", value: "Used" },
    ],
    terms: CommonOptions.terms(24, 96),
    resiStatus: [
        { label: "Owner", value: "Owner" },
        { label: "Buyer", value: "Buyer" },
        { label: "Renter", value: "Renter" },
        { label: "Boarder", value: "Boarder" },
        { label: "Living with Parents", value: "Living with Parents" },
    ],
    vehicleAges: [
        ...assetAgeMaker(0, 14),
        { label: "15+", value: "15+" },
    ],
    privateSales: CommonOptions.yesNo,
    paymentTypes: CommonOptions.paymentTypes,
    platinumPlusRates: rateGapDot10(4.98, 6.98),
    platinumRates: rateGapDot10(5.98, 7.98),
    goldRates: rateGapDot10(8.95, 10.95),
};

const baseRateMapping = () => {
    const mapping = {};
    mapping[calcOptions.riskGrades[0].value] = calcOptions.platinumPlusRates;
    mapping[calcOptions.riskGrades[1].value] = calcOptions.platinumRates;
    mapping[calcOptions.riskGrades[2].value] = calcOptions.goldRates;
    return mapping;
};

// Reset
const reset = () => {
    let r = {
        loanType: calcOptions.loanTypes[0].value,
        loanProduct: calcOptions.loanProducts[0].value,
        riskGrade: calcOptions.riskGrades[0].value,
        assetType: calcOptions.assetTypes[0].value,
        assetCondition: calcOptions.assetConditions[0].value,
        price: null,
        deposit: null,
        netDeposit: 0.0,
        tradeIn: null,
        payoutOn: null,
        applicationFee: null,
        maxApplicationFee: null,
        dof: null,
        ppsr: null,
        residual: 0.0,
        monthlyFee: null,
        maxDof: null,
        term: 24,
        resiStatus: calcOptions.resiStatus[0].value,
        assetAge: calcOptions.vehicleAges[0].value,
        privateSales: null,
        paymentType: "Arrears",
        baseRate: 0.0,
        maxRate: 0.0,
        clientRate: null,
        commissions: QuoteCommons.resetResults()
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
                    quotingFields: QUOTING_FIELDS,
                });
                // Settings
                lenderSettings = quoteData.settings;
                // Rate Settings
                if (quoteData.rateSettings) {
                    tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
                    tableRatesData2 = quoteData.rateSettings[`${RATE_SETTING_NAMES[1]}`];
                    tableRatesData3 = quoteData.rateSettings[`${RATE_SETTING_NAMES[2]}`];
                }
                data.rateSettings = quoteData.rateSettings;
                resolve(data);
            })
            .catch((error) => reject(error));
    });

/**
 * 
 * @param {*} rates 
 * @param {*} customerRate 
 * @param {*} baseRate 
 * @returns 
 */
const rateToTwoDecimals = (rates, customerRate, baseRate) => {
    return rates.map(rate => {
        const res = {};
        res[`${customerRate}`] = rate[`${customerRate}`].toFixed(2);
        res[`${baseRate}`] = rate[`${baseRate}`].toFixed(2);
        return res;
    });
};

const getTableRatesData = () => {
    return rateToTwoDecimals(tableRatesData, CUSTOMER_RATE, BASE_RATE);
};

const getTableRatesData2 = () => {
    return rateToTwoDecimals(tableRatesData2, CUSTOMER_RATE, BASE_RATE);
};

const getTableRatesData3 = () => {
    return rateToTwoDecimals(tableRatesData3, CUSTOMER_RATE, BASE_RATE);
};

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

export const CalHelper = {
    options: calcOptions,
    baseRateMapping: baseRateMapping(),
    calculate: calculate,
    load: loadData,
    reset: reset,
    BASE_RATE_FIELDS: BASE_RATE_FIELDS,
    lenderSettings: lenderSettings,
    getTableRatesData: getTableRatesData,
    getTableRatesData2: getTableRatesData2,
    getTableRatesData3: getTableRatesData3,
    tableRateDataColumns: tableRateDataColumns,
    getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    saveQuote: saveQuote,
    sendEmail: sendEmail,
};