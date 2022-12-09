import getQuotingData from "@salesforce/apex/QuoteUMELoansController.getQuotingData";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteUMELoansController.save";
import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};

const LENDER_QUOTING = "UME Loans";

const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["loanProduct", "Loan_Product__c"],
    ["price", "Vehicle_Price__c"],
    ["deposit", "Deposit__c"],
    ["tradeIn", "Trade_In__c"],
    ["payoutOn", "Payout_On__c"],
    ["applicationFee", "Application_Fee__c"],
    ["ppsr", "PPSR__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["term", "Term__c"],
    ["paymentType", "Payment__c"],
    ["dof", "DOF__c"],
    ["residual", "Residual_Value__c"],
    ["clientRate", "Client_Rate__c"],
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
    ["maxApplicationFee", "Application_Fee__c"],
    ["ppsr", "PPSR__c"],
    ["maxPpsr", "PPSR__c"],
    ["defaultClientRate", "Default_Base_Rate__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["maxMonthlyFee", "Monthly_Fee__c"],
    ["maxDof", "Max_DOF__c"],
]);

const DOF_SETTING_NAMES = [
    "price",
    "deposit",
    "tradeIn",
    "payoutOn",
];

const totalAmountWithPpsr = (quote) => {
    let total = QuoteCommons.calcTotalAmount(quote);
    return total;
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
                goodsType: quote.assetType,
                totalAmount: totalAmountWithPpsr(quote),
                // totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                // totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
                clientRate: quote.clientRate,
                paymentType: quote.paymentType,
                term: quote.term,
                dof: quote.dof,
                monthlyFee: quote.monthlyFee,
                residualValue: quote.residual,
            };
            // Calculate
            console.log(`@@param:`, JSON.stringify(p, null, 2));
            calculateRepayments({
                param: p,
                insuranceParam: quote.insurance
            })
                .then((data) => {
                    console.log(`@@SF:`, JSON.stringify(data, null, 2));
                    // Mapping
                    res.commissions = QuoteCommons.mapCommissionSObjectToLwc(
                        data.commissions,
                        quote.insurance,
                        data.calResults
                    );
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
    loanTypes: CommonOptions.loanTypes,
    loanProducts: [
        { label: "Consumer Loan", value: "Consumer Loan" },
    ],
    terms: CommonOptions.terms(12, 72),
    paymentTypes: CommonOptions.paymentTypes,
};

// Reset
const reset = (recordId) => {
    let r = {
        oppId: recordId,
        name: LENDER_QUOTING,
        loanType: calcOptions.loanTypes[0].value,
        loanProduct: calcOptions.loanProducts[0].value,
        price: null,
        deposit: null,
        tradeIn: null,
        payoutOn: null,
        applicationFee: 1295,
        ppsr: 0.0,
        residualValue: 0.0,
        monthlyFee: 0.0,
        maxDof: null,
        term: 60,
        paymentType: "Arrears",
        clientRate: 29.9,
        commissions: QuoteCommons.resetResults(),
        insurance: { integrity: {} }
    };
    r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
    return r;
};

// Load Data
const loadData = (recordId) =>
    new Promise((resolve, reject) => {
        const fields = [
            ...QUOTING_FIELDS.values(),
            ...QuoteCommons.COMMISSION_FIELDS.values(),
            ...QuoteCommons.INSURANCE_FIELDS.values()
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
                    defaultData: reset(recordId),
                    quoteData: quoteData,
                    settingFields: SETTING_FIELDS,
                    quotingFields: QUOTING_FIELDS
                });
                // Settings
                lenderSettings = quoteData.settings;
                // Rate Settings
                data.typeValue = "Value";
                resolve(data);
            })
            .catch((error) => reject(error));
    });

const saveQuote = (approvalType, param, recordId) =>
    new Promise((resolve, reject) => {
        if (approvalType && param && recordId) {
            // const clientRate = getClientRateCalc(param);
            console.log(`HELPER SAVE ${JSON.stringify(param, null, 2)}`);
            save({
                param: QuoteCommons.mapLWCToSObject(
                    param,
                    recordId,
                    LENDER_QUOTING,
                    FIELDS_MAPPING_FOR_APEX
                ),
                approvalType: approvalType
                // clientRate: clientRate
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

export const CalHelper = {
    options: calcOptions,
    calculate: calculate,
    load: loadData,
    reset: reset,
    DOF_SETTING_NAMES: DOF_SETTING_NAMES,
    lenderSettings: lenderSettings,
    getNetRealtimeNaf: nafIncludePpsr,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    saveQuote: saveQuote,
    sendEmail: sendEmail,
};