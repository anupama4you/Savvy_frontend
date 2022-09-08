import getQuotingData from "@salesforce/apex/QuoteGeneralController.getQuotingData";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteGeneralController.save";
import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};

const LENDER_QUOTING = "General";

const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["loanProduct", "Loan_Product__c"],
    ["price", "Vehicle_Price__c"],
    ["deposit", "Deposit__c"],
    ["tradeIn", "Trade_In__c"],
    ["payoutOn", "Payout_On__c"],
    ["applicationFee", "Application_Fee__c"],
    ["dof", "DOF__c"],
    ["ppsr", "PPSR__c"],
    ["ppsrLabel1", "Extra_Label_1__c"],
    ["ppsrLabel2", "Extra_Label_2__c"],
    ["ppsrLabel3", "Extra_Label_3__c"],
    ["ppsrLabel4", "Extra_Label_4__c"],
    ["ppsr1", "Extra_Value_1__c"],
    ["ppsr2", "Extra_Value_2__c"],
    ["ppsr3", "Extra_Value_3__c"],
    ["ppsr4", "Extra_Value_4__c"],
    ["residual", "Residual_Value__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["term", "Term__c"],
    ["paymentType", "Payment__c"],
    ["brokeragePercentage", "Brokerage__c"],
    ["baseRate", "Base_Rate__c"],
    ["clientRate", "Client_Rate__c"],
    ["netDeposit", "Net_Deposit__c"],

]);

const FIELDS_MAPPING_FOR_APEX = new Map([
    ...QUOTING_FIELDS,
    ["Id", "Id"],
]);

const SETTING_FIELDS = new Map([
    ["applicationFee", "Application_Fee__c"],
]);

const BASE_RATE_FIELDS = [
    "customerProfile",
    "assetAge",
];

const totalAmountWithPpsr = (quote) => {
    let total = QuoteCommons.calcTotalAmount(quote);
    const { ppsr1, ppsr2, ppsr3, ppsr4 } = quote;
    total += (ppsr1 + ppsr2 + ppsr3 + ppsr4);
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
            let profile = "COMMERCIAL";
            const p = {
                lender: LENDER_QUOTING,
                totalAmount: totalAmountWithPpsr(quote),
                totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                clientRate: quote.clientRate,
                paymentType: quote.paymentType,
                term: quote.term,
                dof: quote.dof,
                monthlyFee: quote.monthlyFee,
                residualValue: quote.residual,
                customerProfile: profile,
                productLoanType: quote.loanProduct,
                vehicleYear: quote.assetAge,
                brokeragePer: quote.brokeragePercentage,
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
    loanTypes: CommonOptions.loanTypes,
    loanProducts: [
        { label: "Consumer Loan", value: "Consumer Loan" },
        ...CommonOptions.businessLoanProducts,
    ],
    terms: [
        { label: "6", value: 6 },
        { label: "9", value: 9 },
        { label: "12", value: 12 },
        { label: "18", value: 18 },
        ...CommonOptions.terms(24, 96)],
    paymentTypes: CommonOptions.paymentTypes,
};

// Reset
const reset = () => {
    let r = {
        loanType: calcOptions.loanTypes[0].value,
        loanProduct: calcOptions.loanProducts[0].value,
        price: null,
        deposit: null,
        tradeIn: null,
        payoutOn: null,
        applicationFee: 0.0,
        dof: 0.0,
        ppsr: 0.0,
        ppsrLabel1: null,
        ppsrLabel2: null,
        ppsrLabel3: null,
        ppsrLabel4: null,
        ppsr1: 0.0,
        ppsr2: 0.0,
        ppsr3: 0.0,
        ppsr4: 0.0,
        residual: 0.0,
        monthlyFee: 0.0,
        maxDof: null,
        term: 60,
        paymentType: "Arrears",
        baseRate: 5.05,
        clientRate: 5.04,
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
        console.log('recordId: ', recordId);
        getQuotingData({
            param: {
                oppId: recordId,
                fields: fields,
                calcName: LENDER_QUOTING,
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
                resolve(data);
            })
            .catch((error) => reject(error));
    });

const saveQuote = (approvalType, param, recordId) =>
    new Promise((resolve, reject) => {
        if (approvalType && param && recordId) {
            console.log(`HELPER SAVE ${JSON.stringify(param, null, 2)}`);
            param.clientRate = parseFloat(param.clientRate).toFixed(2);
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
    const { ppsr1, ppsr2, ppsr3, ppsr4 } = quote;
    naf += ppsr1 + ppsr2 + ppsr3 + ppsr4;
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
    quote.residual && (fv = quote.residual);
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

export const CalHelper = {
    options: calcOptions,
    calculate: calculate,
    load: loadData,
    reset: reset,
    BASE_RATE_FIELDS: BASE_RATE_FIELDS,
    lenderSettings: lenderSettings,
    getNetRealtimeNaf: nafIncludePpsr,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    saveQuote: saveQuote,
    sendEmail: sendEmail,
    clientRate: getClientRateCalc,
};