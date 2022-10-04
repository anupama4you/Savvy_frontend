import getQuotingData from "@salesforce/apex/QuoteAzoraController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteAzoraController.save";
import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let creditScoreData = [];

let tableRateDataColumns = [
    { label: "Credit Score", fieldName: "Credit_Score__c", fixedWidth: 150 },
    { label: "Max Loan", fieldName: "Max_Loan__c", fixedWidth: 150 },
    { label: "Rate", fieldName: "Rate__c", fixedWidth: 150 },
    { label: "Risk Fee", fieldName: "Risk_Fee__c", fixedWidth: 150 },
];

const LENDER_QUOTING = "Azora Consumer";

const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["loanProduct", "Loan_Product__c"],
    // ["creditScore", "Loan_Facility_Type__c"],
    ["price", "Vehicle_Price__c"],
    ["deposit", "Deposit__c"],
    ["tradeIn", "Trade_In__c"],
    ["payoutOn", "Payout_On__c"],
    ["applicationFee", "Application_Fee__c"],
    ["dof", "DOF__c"],
    ["ppsr", "PPSR__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["term", "Term__c"],
    ["riskFee", "Risk_Fee__c"],
    ["clientRate", "Client_Rate__c"],
    ["repaymentType", "Payment__c"]
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
    ...QUOTING_FIELDS,
    ["Id", "Id"],
    ["netDeposit", "Net_Deposit__c"],
]);

const RATE_SETTING_NAMES = ["Azora_Rates__c"];

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
    "assetType",
];

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
            let profile = "Azora Consumer";
            const p = {
                lender: LENDER_QUOTING,
                // totalAmount: QuoteCommons.calcTotalAmount(quote),
                // * NOW confused about the total amount and NAF, NAF  = total +- insurance *
                //  CHECK `quoteCommon.js` calcTotalInsuranceType() and calcNetRealtimeNaf();
                // NAF AND Total amount all uses the NAF to calculate.
                totalAmount: netRealTimeNaf(quote),
                totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                riskFeeBase: quote.riskFee,
                clientRate: quote.clientRate,
                repaymentType: quote.repaymentType,
                term: quote.term,
                dof: quote.dof,
                netDep: quote.netDeposit,
                monthlyFee: quote.monthlyFee,
                customerProfile: profile,
                productLoanType: quote.loanProduct,
                goodsType: quote.assetType,
            };

            // Calculate
            console.log(`@@Cal:`, JSON.stringify(p, null, 2));
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
    loanTypes: [
        { label: "Purchase", value: "Purchase" },
        { label: "Refinance", value: "Refinance" },
    ],
    loanProducts: CommonOptions.consumerLoanProducts,
    creditScores: creditScoreData,
    repaymentTypes: [
        { label: "Monthly", value: "Monthly" },
        { label: "Weekly", value: "Weekly" },
        { label: "Fortnightly", value: "Fortnightly" },
    ],
    terms: CommonOptions.terms(36, 96)
};

// Reset
const reset = () => {
    let r = {
        loanType: calcOptions.loanTypes[0].value,
        loanProduct: calcOptions.loanProducts[0].value,
        creditScore: calcOptions.creditScores.length !== 0 ? calcOptions.creditScores[0].value : null,
        price: null,
        deposit: null,
        tradeIn: null,
        payoutOn: null,
        applicationFee: null,
        maxApplicationFee: null,
        dof: null,
        ppsr: null,
        monthlyFee: null,
        maxDof: null,
        term: 60,
        repaymentType: "Monthly",
        riskFee: 0.0,
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
                    quotingFields: QUOTING_FIELDS
                });
                // Settings
                lenderSettings = quoteData.settings;
                // Rate Settings
                if (quoteData.rateSettings) {
                    tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
                    creditScoreData = getCreditScores(tableRatesData);
                    calcOptions.creditScores = getCreditScores(tableRatesData);
                }
                data.score = creditScoreData;
                data.validSetting = lenderSettings;
                resolve(data);
            })
            .catch((error) => reject(error));
    });

const getCreditScores = (ratesData) => {
    const credits = ratesData.map(data => {
        return { label: data.Credit_Score__c, value: data.Credit_Score__c };
    });
    return credits;
};

// Get Base Rates
const getMyBaseRates = (quote) =>
    new Promise((resolve, reject) => {
        let profile = "COMMERCIAL";
        Object.is(quote.assetType, "Other-Primary Assets") && (profile = "OTHER - Primary");
        Object.is(quote.assetType, "Other-Secondary & Tertiary Assets") && (profile = "OTHER - 2nd & 3rd");
        const p = {
            lender: LENDER_QUOTING,
            productLoanType: quote.loanProduct,
            customerProfile: profile,
            goodsType: quote.assetType,
            hasMaxRate: true
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

const getTableRatesData = () => {
    return tableRatesData;
};

const saveQuote = (approvalType, param, recordId) =>
    new Promise((resolve, reject) => {
        if (approvalType && param && recordId) {

            console.log('**savequote: ', JSON.stringify(param, null, 2));
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

const netRealTimeNaf = (quoteForm) => {
    return QuoteCommons.calcNetRealtimeNaf(quoteForm) + quoteForm.riskFee;
};

export const CalHelper = {
    options: calcOptions,
    calculate: calculate,
    load: loadData,
    reset: reset,
    baseRates: getMyBaseRates,
    BASE_RATE_FIELDS: BASE_RATE_FIELDS,
    lenderSettings: lenderSettings,
    getTableRatesData: getTableRatesData,
    tableRateDataColumns: tableRateDataColumns,
    // * NOW confused about the total amount and NAF, NAF  = total +- insurance *
    //  CHECK `quoteCommon.js` calcTotalInsuranceType() and calcNetRealtimeNaf();
    // NAF AND Total amount all uses the NAF to calculate.
    getNetRealtimeNaf: netRealTimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    saveQuote: saveQuote,
    sendEmail: sendEmail,
};