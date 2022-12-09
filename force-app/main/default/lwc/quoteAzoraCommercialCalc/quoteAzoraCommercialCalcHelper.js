import getQuotingData from "@salesforce/apex/QuoteAzoraCommController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteAzoraCommController.getBaseRates";
import getCommissionCalc from "@salesforce/apex/QuoteAzoraCommController.getCommission";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import getFinanceOneRate from "@salesforce/apex/QuoteAzoraCommController.getFinanceOneRate";
import getApplicationFeeCalc from "@salesforce/apex/QuoteAzoraCommController.getApplicationFeeCalc";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteAzoraCommController.save";

import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData = [];

let tableRateDataColumns = [
    { label: "Loan Type", fieldName: "Loan_Type__c", fixedWidth: 300 },
    { label: "Rate", fieldName: "Rate__c", fixedWidth: 300 },
];

const LENDER_QUOTING = "Azora Commercial";

const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["loanProduct", "Loan_Product__c"],
    ["goodType", "Goods_type__c"],
    ["loanTypeDetail", "Loan_Facility_Type__c"],
    ["price", "Vehicle_Price__c"],
    ["deposit", "Deposit__c"],
    ["tradeIn", "Trade_In__c"],
    ["payoutOn", "Payout_On__c"],
    ["applicationFee", "Application_Fee__c"],
    ["dof", "DOF__c"],
    ["ppsr", "PPSR__c"],
    ["residual", "Residual_Value__c"],
    ["term", "Term__c"],
    ["privateSales", "Private_Sales__c"],
    ["paymentType", "Payment__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["abn", "Extra_Label_1__c"],
    ["gst", "GST__c"],
    ["brokerage", "Brokerage__c"],
    ["baseRateManual", "Extra_Value_1__c"],
    ["addOnRate", "Rate_Options__c"],
    ["clientRate", "Client_Rate__c"],
    ["netDeposit", "Net_Deposit__c"]
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
    ...QUOTING_FIELDS,
    ["Id", "Id"],
    ["privateSales", "Private_Sales__c"],
    ["clientTier", "Client_Tier__c"],
    ["assetAge", "Vehicle_Age__c"],
    ["baseRate", "Base_Rate__c"],
    ["netDeposit", "Net_Deposit__c"]
]);

const RATE_SETTING_NAMES = ["Azora_Commercial_Rates__c"];

const SETTING_FIELDS = new Map([
    ["applicationFee", "Application_Fee__c"],
    ["appFeeDefault", "Application_Fee__c"],
    ["appFeePrevDefault", "Application_Fee_Private__c"],
    ["monthlyFee", "Monthly_Fee__c"]
]);

const BROKERAGE_RANGE = [
    { min: 0, max: 35000, rate: 10 },
    { min: 35001, max: 50000, rate: 8 },
    { min: 50001, max: 85000, rate: 7 },
];

const BASE_RATE_FIELDS = [
    "price",
    "deposit",
    "tradeIn",
    "payoutOn",
];

const COMM_FIELDS = [
    "netDeposit",
    "brokerage",
    "price",
    "deposit",
    "tradeIn",
    "payoutOn"
];

const APPFEE_Calc_Fields = [
    "loanProduct",
    "loanTypeDetail",
    "netDeposit"
];

//return term months
const getTerms = () => {
    let r = [];
    const terms = CommonOptions.terms(12, 84);
    terms.forEach(function (item) {
        r.push({ label: item.label.toString(), value: item.value });
    });
    return r;
};

const calcOptions = {
    loanTypes: CommonOptions.loanTypes,
    loanProducts: CommonOptions.businessLoanProducts.filter(obj => obj.value.includes("Low-Doc")),
    goodTypes: [
        { label: "Category A", value: "Category A" },
        { label: "Category B", value: "Category B" },
        { label: "Category C", value: "Category C" },
    ],
    loanTypeDetails: [
        { label: "Adverse", value: "Adverse" },
        { label: "Streamline", value: "Streamline" },
        { label: "Kickstart", value: "Kickstart" },
    ],
    terms: getTerms(),
    propertyOwners: [
        { label: "--None--", value: "" },
        { label: "Yes", value: "Y" },
        { label: "No", value: "N" },
    ],
    abns: [
        { label: "6 months - 24 months", value: "6 months - 24 months" },
        { label: "> 24 months", value: "> 24 months" },
        { label: "> 4 years", value: "> 4 years" },
    ],
    gsts: [
        { label: "--None--", value: "" },
        { label: "No GST", value: "No GST" },
        { label: "> 6 months", value: "> 6 months" },
        { label: "> 12 months", value: "> 12 months" },
        { label: "> 24 months", value: "> 24 months" },
    ],
    paymentTypes: CommonOptions.paymentTypes
};

const reset = (recordId) => {
    let r = {
        oppId: recordId,
        loanType: calcOptions.loanTypes[0].value,
        loanProduct: calcOptions.loanProducts[0].value,
        goodType: calcOptions.goodTypes[0].value,
        loanTypeDetail: calcOptions.loanTypeDetails[0].value,
        price: null,
        deposit: null,
        tradeIn: null,
        payoutOn: null,
        applicationFee: null,
        dof: 0,
        ppsr: 0,
        residual: 0.0,
        term: 60,
        privateSales: '',
        paymentType: "Arrears",
        abn: calcOptions.abns[0].value,
        gst: calcOptions.gsts[0].value,
        brokerage: 0.0,
        baseRate: 0.0,
        baseRateManual: 0.0,
        addOnRate: 0.0,
        clientRate: 0.0,
        commision: 0.0,
        commissions: QuoteCommons.resetResults(),
        insurance: { integrity: {} },
        baseRates: getRates(tableRatesData),
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

        getQuotingData({
            param: {
                oppId: recordId,
                fields: fields,
                calcName: LENDER_QUOTING,
                rateSettings: RATE_SETTING_NAMES
            }
        })
            .then((quoteData) => {
                console.log('Loading Data: ', JSON.stringify(quoteData, null, 2));
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
                if (quoteData.rateSettings) {
                    tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
                }
                // add base rates to data.
                data.baseRates = getRates(quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`]);
                resolve(data);
            })
            .catch((error) => reject(error));

    });

const getRates = (rates) => {
    return rates.map(({ Loan_Type__c, Rate__c }) => ({ [Loan_Type__c]: Rate__c }));
};

const getTableRatesData = () => {
    return tableRatesData;
};

// calculate NAF commission
const getNafCommission = (quote) => {
    let r = 0.0;
    r += quote.price;
    r -= QuoteCommons.calcNetDeposit(quote);
    return r;
};

//Get total naf calculations
const getNetRealtimeNaf = (quote) => {
    let naf = QuoteCommons.calcTotalAmount(quote);
    let total = naf + quote.commission;
    return total;
};

// Get Base Rates
const getMyBaseRates = (quote) =>
    new Promise((resolve, reject) => {
        const p = {
            lender: LENDER_QUOTING,
            productLoanType: quote.loanProduct,
            loanTypeDetail: quote.loanTypeDetail,
            brokeragePer: quote.brokerage,
            hasMaxRate: true,
            // interestType: quote.rateOption
        };

        getBaseRates({
            param: p
        })
            .then((rates) => {

                resolve(rates);
            })
            .catch((error) => reject(error));
    });

// Get Commission Calculations
const getFOCommission = (quote) =>
    new Promise((resolve, reject) => {
        const p = {
            netDeposit: quote.netDeposit,
            brokeragePer: quote.brokerage,
            vehiclePrice: quote.price
        };
        getCommissionCalc({
            param: p
        })
            .then((comm) => {
                resolve(comm);
            })
            .catch((error) => reject(error));
    });

// Get Application Fee Calculations
const getAppFeeCalc = (quote) =>
    new Promise((resolve, reject) => {
        const p = {
            productLoanType: quote.loanProduct,
            loanTypeDetail: quote.loanTypeDetail,
            vehiclePrice: quote.price,
            netDeposit: quote.netDeposit
        };
        getApplicationFeeCalc({
            param: p
        })
            .then((appFee) => {
                resolve(appFee);
            })
            .catch((error) => reject(error));
    });

//Calculate Repayment
const calculate = (quote) =>
    new Promise((resolve, reject) => {
        let res = {
            commissions: QuoteCommons.resetResults(),
            messages: QuoteCommons.resetMessage()
        };
        let nafCalculations = getNetRealtimeNaf(quote);
        let nafCommission = getNafCommission(quote);
        // Prepare params
        const p = {
            lender: LENDER_QUOTING,
            productLoanType: quote.loanProduct,
            loanTypeDetail: quote.loanTypeDetail,
            totalAmount: nafCalculations,
            totalInsurance: QuoteCommons.calcTotalInsuranceIncome(quote),
            totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
            clientRate: quote.clientRate,
            baseRate: quote.baseRate,
            paymentType: quote.paymentType,
            term: quote.term,
            dof: 0.0,
            monthlyFee: quote.monthlyFee,
            residualValue: quote.residual,
            brokeragePer: quote.brokerage,
            netDeposit: quote.netDeposit,
            vehiclePrice: quote.price,
            nafCommission: nafCommission,
        };

        getFinanceOneRate({
            param: p
        })
            .then((financeOneRates) => {
                // Validate quote
                res.messages = Validations.validate(quote, res.messages);
                if (res.messages && res.messages.errors.length > 0) {
                    reject(res);
                } else {
                    // Calculate
                    console.log('calculateRepayments: ', JSON.stringify(p, null, 2));
                    calculateRepayments({
                        param: p,
                        insuranceParam: quote.insurance
                    })
                        .then((data) => {
                            // Mapping
                            res.commissions = QuoteCommons.mapCommissionSObjectToLwc(
                                data.commissions,
                                quote.insurance,
                                data.calResults
                            );
                            // Validate the result of commissions
                            res.messages = Validations.validatePostCalculation(
                                res.commissions,
                                res.messages
                            );
                            resolve(res);
                        })
                        .catch((error) => {
                            res.messages.errors.push({ field: "calculation", message: error });
                            reject(res);
                        });
                }
            })
            .catch((error) => {
                res.messages.errors.push({ field: "calculation", message: error });
                reject(res);
            });
    });

const getBaseAmountPmtInclBrokerageCalc = (quote) => {

    let r = QuoteCommons.calcNetRealtimeNaf(quote);
    if (quote.brokerage != null && quote.brokerage != 0) {
        r += (r * (quote.brokerage / 100));
    }
    console.log('getBaseAmountPmtInclBrokerageCalc==>' + r);
    return r;
};


const getClientRateCalc = (param) => {
    const naf = QuoteCommons.calcNetRealtimeNaf(param);
    const amountBasePmt = getBaseAmountPmtInclBrokerageCalc(param);
    const { baseRate, baseRateManual } = param;
    const base = baseRateManual === 0 ? baseRate : baseRateManual;

    const residualValue = 0;
    let type = 0;
    if (param.paymentType === "Advance") {
        type = 1;
    }
    const pmt = fu.pmt2((base / 100 / 12),
        param.term,
        (amountBasePmt * -1),
        residualValue,
        type
    );
    let r = fu.rate2(
        param.term,
        (pmt * -1.0),
        naf,
        (residualValue * -1),
        type
    );
    if (base == 0) {
        r = 0;
    }
    return (r * 12 * 100).toFixed(2);
};

/**
* -- Lee
* @param {String} approvalType - type of approval
* @param {Object} param - quoting form
* @param {Id} recordId - recordId
* @returns
*/
const saveQuote = (approvalType, param, recordId) =>
    new Promise((resolve, reject) => {
        if (approvalType && param && recordId) {
            param.addOnRate += '';
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
            param.addOnRate += '';
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
    getFOCommission: getFOCommission,
    getNafComm: getNafCommission,
    getAppFeeCalc: getAppFeeCalc,
    BASE_RATE_FIELDS: BASE_RATE_FIELDS,
    COMM_FIELDS: COMM_FIELDS,
    APPFEE_Calc_Fields: APPFEE_Calc_Fields,
    lenderSettings: lenderSettings,
    getTableRatesData: getTableRatesData,
    tableRateDataColumns: tableRateDataColumns,
    BROKERAGE_RANGE: BROKERAGE_RANGE,
    getNetRealtimeNaf: getNetRealtimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    saveQuote: saveQuote,
    sendEmail: sendEmail,
    getClientRateCalc: getClientRateCalc,
};