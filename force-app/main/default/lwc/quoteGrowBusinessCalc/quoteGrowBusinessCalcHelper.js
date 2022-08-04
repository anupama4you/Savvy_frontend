import getQuotingData from "@salesforce/apex/QuoteGrowBusiController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteGrowBusiController.save";
import getProtectedPercentaje from "@salesforce/apex/QuoteGrowBusiController.getProtectedPercentaje";

import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
const LENDER_QUOTING = "Grow Business Loan";

const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["price", "Vehicle_Price__c"],
    ["applicationFee", "Application_Fee__c"],
    ["term", "Term__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["equifaxScore", "Credit_Score__c"],
    ["abnLength", "Extra_Label_1__c"],
    ["gstLength", "Extra_Label_2__c"],
    ["propertyOwner", "Customer_Profile__c"],
    ["brokeragePercentage", "Brokerage__c"],
    ["baseRate", "Base_Rate__c"],
    ["clientRate", "Client_Rate__c"],
    ["paymentType", "Payment__c"],
    ["repaymentType", "Payment__c"],
    ["dof", "DOF__c"],
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
    ["baseRate", "Default_Base_Rate__c"],
    ["deBaseRate", "Default_Base_Rate__c"],
    ["brokeragePercentage", "Max_Brokerage__c"],
    ["maxBrokPercentage", "Max_Brokerage__c"],
]);

const BASE_RATE_FIELDS = [
    "customerProfile",
    "assetType",
];

const getBaseAmountPmtInclBrokerageCalc = (param) => {
    const naf = netRealTimeNaf(param);
    let r = 0;
    if (param.brokeragePercentage) {
        r = (naf + naf * (param.brokeragePercentage / 100));
    }
    return r;
};
// This method is from
// QuotingCalculation.cls public static Decimal getClientRateCalculation(CalcParam param, Integer scale)
const getClientRateCalc = (param) => {
    const naf = netRealTimeNaf(param);
    const amountBasePmt = getBaseAmountPmtInclBrokerageCalc(param);

    const residualValue = 0;
    let type = 0;
    if (param.repaymentType === "Advance") {
        type = 1;
    }
    const pmt = fu.pmt2((param.baseRate / 100 / 12),
        param.term,
        (amountBasePmt * -1),
        residualValue,
        type
    );
    const r = fu.rate2(
        param.term,
        (pmt * -1.0),
        naf,
        (residualValue * -1),
        type
    );
    return (r * 12 * 100).toFixed(2);
};

const getBaseAmountPmtCalc = (param, per) => {
    let r = 0;
    param.price && (r += param.price);
    r += QuoteCommons.calcTotalInsuranceType(param);
    return r;
};

const getProjctetedPer = (price) =>
    new Promise((resolve, reject) => {
        getProtectedPercentaje({ carPrice: price })
            .then((data) => {
                resolve(data);
            })
            .catch((error) => {
                reject(error);
            });
    });

// check the old controller * calculateRepayments *
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
            let profile = "Grow Business Loan";
            const p = {
                lender: LENDER_QUOTING,
                // totalAmount: QuoteCommons.calcTotalAmount(quote),
                // * NOW confused about the total amount and NAF, NAF  = total +- insurance *
                //  CHECK `quoteCommon.js` calcTotalInsuranceType() and calcNetRealtimeNaf();
                // NAF AND Total amount all uses the NAF to calculate.
                totalAmount: netRealTimeNaf(quote),
                totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                baseRate: quote.baseRate,
                clientRate: quote.clientRate,
                repaymentType: quote.repaymentType,
                paymentType: quote.paymentType,
                term: quote.term,
                dof: quote.dof,
                netDep: quote.netDeposit,
                monthlyFee: quote.monthlyFee,
                customerProfile: profile,
                goodsType: quote.assetType,
                brokeragePer: quote.brokeragePercentage,
                amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
                amountBaseComm: getBaseAmountPmtCalc(quote, quote.projPer),
            };

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
        { label: "Term Loan", value: "Term Loan" },
    ],
    abnLengths: [
        { label: "< 2 years", value: "< 2 years" },
        { label: "> 2 years", value: "> 2 years" },
    ],
    gstLengths: [
        { label: "NO GST", value: "NO GST" },
        { label: "< 2 years", value: "< 2 years" },
        { label: "> 2 years", value: "> 2 years" },
    ],
    propOwns: [
        { label: "No", value: "N" },
        { label: "Yes", value: "Y" },
    ],
    terms: CommonOptions.terms(12, 72)
};

// Reset
const reset = () => {
    let r = {
        loanType: calcOptions.loanTypes[0].value,
        price: null,
        applicationFee: null,
        term: 36,
        monthlyFee: null,
        equifaxScore: null,
        abnLength: calcOptions.abnLengths[0].value,
        gstLength: calcOptions.gstLengths[0].value,
        propertyOwner: calcOptions.propOwns[0].value,
        maxApplicationFee: null,
        maxBrokPercentage: null,
        repaymentType: "Advance",
        paymentType: "Advance",
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
                    // tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
                }
                data.validSetting = lenderSettings;
                resolve(data);
            })
            .catch((error) => reject(error));
    });

// Get Base Rates
const getMyBaseRates = (quote) =>
    new Promise((resolve, reject) => {
        let profile = "COMMERCIAL";
        const p = {
            lender: LENDER_QUOTING,
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
    return QuoteCommons.calcNetRealtimeNaf(quoteForm);
    // return QuoteCommons.calcNetRealtimeNaf(quoteForm) + quoteForm.riskFee;
};

export const CalHelper = {
    options: calcOptions,
    calculate: calculate,
    load: loadData,
    reset: reset,
    baseRates: getMyBaseRates,
    BASE_RATE_FIELDS: BASE_RATE_FIELDS,
    lenderSettings: lenderSettings,
    // * NOW confused about the total amount and NAF, NAF  = total +- insurance *
    //  CHECK `quoteCommon.js` calcTotalInsuranceType() and calcNetRealtimeNaf();
    // NAF AND Total amount all uses the NAF to calculate.
    getNetRealtimeNaf: netRealTimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    saveQuote: saveQuote,
    sendEmail: sendEmail,
    getClientRateCalc: getClientRateCalc,
    getProjctetedPer: getProjctetedPer
};