import getQuotingData from "@salesforce/apex/QuoteBOQCommController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteBOQCommController.save";

import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
const LENDER_QUOTING = "BOQ Commercial";

const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["loanProduct", "Loan_Product__c"],
    // ["riskGrade", "Client_Tier__c"],
    ["assetType", "Goods_type__c"],
    ["loanFrequency", "Loan_Frequency__c"],
    // ["assetCondition", "Vehicle_Condition__c"],
    ["price", "Vehicle_Price__c"],
    ["deposit", "Deposit__c"],
    ["tradeIn", "Trade_In__c"],
    ["payoutOn", "Payout_On__c"],
    ["applicationFee", "Application_Fee__c"],
    ["dof", "DOF__c"],
    ["ppsr", "PPSR__c"],
    ["residualValue", "Residual_Value__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["term", "Term__c"],
    ["assetAge", "Vehicle_Age__c"],
    ["propOwner", "Customer_Profile__c"],
    ["privateSales", "Private_Sales__c"],
    ["paymentType", "Payment__c"],
    ["brokeragePercentage", "Brokerage__c"],
    ["baseRate", "Base_Rate__c"],
    ["clientRate", "Client_Rate__c"],
    // ["maxBrokerage", "Brokerage__c"],
    ["netDeposit", "Net_Deposit__c"],
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
    ...QUOTING_FIELDS,
    ["Id", "Id"],
    ["privateSales", "Private_Sales__c"],
    ["netDeposit", "Net_Deposit__c"],
    // ["assetAge", "Vehicle_Age__c"],
    // ["maxRate", "Manual_Max_Rate__c"],
    // ["maxBrokerage", "Max_Brokerage__c"],

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
    ["monthlyFee", "Monthly_Fee__c"],
    ["maxBrokerage", "Max_Brokerage__c"],
]);

const RESIDUAL_VALUE_FIELDS = [
    "residualValue",
    "residualPer",
    "typeValue",
    "price",
    "deposit",
    "tradeIn",
    "payoutOn"
];

const BASE_RATE_FIELDS = [
    "customerProfile",
    "clientTier",
    "assetAge",
    "assetType",
    "privateSales"
];

// const getBaseAmountPmtInclBrokerageCalc = (param) => {
//     const naf = netRealTimeNaf(param);
//     let r = 0;
//     if (param.brokeragePercentage) {
//         r = (naf + naf * (param.brokeragePercentage / 100));
//     }
//     return r;
// };

const calVehiclePrice = (quote) => {
    let r = quote.price;
    r -= QuoteCommons.calcNetDeposit(quote);
    return r;
};

// const getBaseCommRate = (quote) => {
//     // Gold, 8.95, 
//     const { riskGrade, baseRate, rateSettings } = quote;
//     const ratesAttr = rateMapping[riskGrade];
//     const rateObj = rateSettings[ratesAttr].find(rate => rate.CustomerInterestRate__c == baseRate);
//     const baseCommRate = rateObj.BaseCommisionRate__c;
//     return baseCommRate;
// };

const getBaseAmountPmtCalc = (param, per) => {
    // console.log('##CALCULATE: ', JSON.stringify(param, null, 2));
    // console.log(`AAAAA`);
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
                residualValue: quote.residualValue,
                brokeragePer: quote.brokeragePercentage,
                amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
                amountBaseComm: getBaseAmountPmtCalc(quote),
                vehiclePrice: calVehiclePrice(quote),
                // commRate: getBaseCommRate(quote),
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
    loanProducts: CommonOptions.businessLoanProducts,
    assetTypes: [
        { label: "Cars/Trucks", value: "Cars/Trucks" },
        { label: "Earthmoving", value: "Earthmoving" },
        { label: "Construction", value: "Construction" },
        { label: "Agricultural", value: "Agricultural" },
        { label: "Industrial Plant and Equipment", value: "Industrial Plant and Equipment" },
    ],
    loanFrequencies: [
        { label: "Monthly", value: "MONTHLY" },
    ],
    terms: CommonOptions.terms(24, 96),
    propOwners: [...CommonOptions.yesNo].reverse(),
    vehicleAges: [
        { label: "New/Demo", value: "New" },
        { label: "1-3 years", value: "Used" },
    ],
    privateSales: CommonOptions.yesNo,
    paymentTypes: CommonOptions.paymentTypes,
    typeValues: [
        { label: "Percentage", value: "Percentage" },
        { label: "Value", value: "Value" },
    ],
};

// Reset
const reset = () => {
    let r = {
        loanType: calcOptions.loanTypes[0].value,
        loanProduct: calcOptions.loanProducts[0].value,
        assetType: null,
        loanFrequency: null,
        price: null,
        deposit: null,
        netDeposit: 0.0,
        tradeIn: null,
        payoutOn: null,
        applicationFee: null,
        maxApplicationFee: null,
        dof: null,
        ppsr: null,
        residualValue: 0.0,
        monthlyFee: null,
        maxDof: null,
        maxBrokerage: null,
        term: 60,
        assetAge: null,
        propOwner: "N",
        privateSales: "N",
        paymentType: "Advance",
        baseRate: 0.0,
        maxRate: 0.0,
        clientRate: null,
        brokeragePercentage: 4.0,
        commissions: QuoteCommons.resetResults(),
        typeValue: "Value",
    };
    r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
    return r;
};

// ReferenceError: nafIncludePpsr is not defined
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
                // rateSettings: RATE_SETTING_NAMES
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
                data.rateSettings = quoteData.rateSettings;
                data.typeValue = "Value";
                resolve(data);
            })
            .catch((error) => reject(error));
    });

const getBaseAmountPmtInclBrokerageCalc = (param) => {
    const naf = QuoteCommons.calcNetRealtimeNaf(param);
    let r = 0;
    if (param.brokeragePercentage) {
        r = (naf + naf * (param.brokeragePercentage / 100));
    }
    return r;
};

// Get Base Rates
const getMyBaseRates = (quote) =>
    new Promise((resolve, reject) => {
        const profile = "LEISURE";
        const p = {
            lender: LENDER_QUOTING,
            customerProfile: quote.propOwner,
            term: quote.term,
            privateSales: quote.privateSales,
            totalAmount: QuoteCommons.calcTotalAmount(quote),
            goodsType: quote.assetType,
            vehicleYear: quote.assetAge,
            brokeragePer: quote.brokeragePercentage,
            productLoanType: quote.loanProduct,
            clientTier: quote.clientTier,
            hasMaxRate: true,
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

const getResidualValue = (quote) => {
    // const res = ((quote.price - QuoteCommons.calcNetDeposit(quote)) * quote.residualPer) / 100;
    const res = quote.price * quote.residualPer / 100;
    return parseFloat(res.toFixed(2));
};

const getResidualPercentage = (quote) => {
    const res = (quote.residualValue / (quote.price)) * 100;
    return parseFloat(res.toFixed(2));
    // return (quote.residualValue / (quote.price - QuoteCommons.calcNetDeposit(quote))) * 100;
};

//  r == 0.1 means fu.rate2() return the default value. It is the reset value.
const getClientRateCalc = (quote) => {
    const { residualValue, residualPer } = quote;
    // console.log('PARAM in clientRate ', JSON.stringify(quote, null, 2));
    console.log('PARAM in clientRate ', residualValue);
    console.log('PARAM in clientRate ', residualPer);
    // let r = 0;
    const term = parseInt(quote.term);
    const naf = QuoteCommons.calcNetRealtimeNaf(quote);
    let fv = 0;
    quote.residualValue && (fv = quote.residualValue);
    const amuntPmt = getBaseAmountPmtInclBrokerageCalc(quote);
    console.log('amuntPmt: ', amuntPmt);
    let type = 0;
    if (quote.paymentType === "Advance") {
        type = 1;
    }
    const pmt = fu.pmt2((quote.baseRate / 100 / 12),
        term,
        (amuntPmt * -1),
        fv,
        type
    );
    const r = fu.rate2(
        term,
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
    calculate: calculate,
    load: loadData,
    reset: reset,
    baseRates: getMyBaseRates,
    BASE_RATE_FIELDS: BASE_RATE_FIELDS,
    RESIDUAL_VALUE_FIELDS: RESIDUAL_VALUE_FIELDS,
    lenderSettings: lenderSettings,
    getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    getClientRateCalc: getClientRateCalc,
    saveQuote: saveQuote,
    sendEmail: sendEmail,
    getResiVal: getResidualValue,
    getResiPer: getResidualPercentage,
};