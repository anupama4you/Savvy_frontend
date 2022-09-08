import getQuotingData from "@salesforce/apex/QuoteWestpacController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteWestpacController.save";
import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};

const LENDER_QUOTING = "Westpac";

const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["loanProduct", "Loan_Product__c"],
    ["assetType", "Goods_type__c"],
    ["loanFrequency", "Loan_Frequency__c"],
    ["price", "Vehicle_Price__c"],
    ["deposit", "Deposit__c"],
    ["tradeIn", "Trade_In__c"],
    ["payoutOn", "Payout_On__c"],
    ["applicationFee", "Application_Fee__c"],
    ["dof", "DOF__c"],
    ["residualValue", "Residual_Value__c"],
    ["residualPer", "Residual_Value_Percentage__c"],
    ["ppsr", "PPSR__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["term", "Term__c"],
    ["clientRate", "Client_Rate__c"],
    ["paymentType", "Payment__c"],
    ["assetAge", "Vehicle_Age__c"],
    ["propertyOwner", "Customer_Profile__c"],
    ["privateSales", "Private_Sales__c"],
    ["baseRate", "Base_Rate__c"],
    ["brokeragePercentage", "Brokerage__c"],
    ["netDeposit", "Net_Deposit__c"],
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
    ...QUOTING_FIELDS,
    ["Id", "Id"],
    ["clientTier", "Client_Tier__c"],
    ["maxRate", "Manual_Max_Rate__c"]
]);


const RATE_SETTING_NAMES = ["PepperRate__c", "PepperRate__c_2", "PepperRate__c_3"];

const SETTING_FIELDS = new Map([
    ["applicationFee", "Application_Fee__c"],
    ["maxApplicationFee", "Application_Fee__c"],
    ["dof", "DOF__c"],
    ["maxDof", "DOF__c"],
    // ["ppsr", "PPSR__c"],
    // ["monthlyFee", "Monthly_Fee__c"]
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

const getBaseAmountPmtInclBrokerageCalc = (param) => {
    const naf = netRealTimeNaf(param);
    let r = 0;
    if (param.brokeragePercentage) {
        r = (naf + naf * (param.brokeragePercentage / 100));
    }
    return r;
};

const getClientRateCalc = (param) => {
    const naf = netRealTimeNaf(param);
    const amountBasePmt = getBaseAmountPmtInclBrokerageCalc(param);

    const residualValue = param.residualValue;
    let type = 0;
    // make sure the 'paymentType' or 'repaymentType'
    if (param.paymentType === "Advance") {
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
    let res = (r * 12 * 100).toFixed(2);

    if (param.baseRate == 0) {
        return 0;
    }
    if (param.brokeragePercentage == 0) {
        return param.baseRate;
    }
    return res;
    // return (r * 12 * 100).toFixed(2);
};

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
            let profile = "Westpac";
            const p = {
                lender: LENDER_QUOTING,
                totalAmount: QuoteCommons.calcTotalAmount(quote),
                totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                baseRate: quote.baseRate,
                paymentType: quote.paymentType,
                term: quote.term,
                dof: quote.dof,
                monthlyFee: quote.monthlyFee,
                residualValue: quote.residualValue,
                brokeragePer: quote.brokeragePercentage,
                amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
                amountBaseComm: getBaseAmountPmtCalc(quote, quote.projPer),
            };
            if (p.residualValue > 0) {
                p.term--;
            }

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
    privateSales: CommonOptions.yesNo,
    paymentTypes: CommonOptions.paymentTypes,
    loanProducts: [
        { label: "Chattel Mortgage-Full-Doc", value: "Chattel Mortgage-Full-Doc" },
        { label: "Chattel Mortgage-Low-Doc", value: "Chattel Mortgage-Low-Doc" },
        { label: "Finance Lease", value: "Finance Lease" },
        { label: "Novated Lease", value: "Novated Lease" },
    ],
    assetTypes: [
        { label: "Motor vehicle and transport", value: "Motor vehicle and transport" },
        { label: "Agricultural", value: "Agricultural" },
        { label: "Yellow goods", value: "Yellow goods" },
        { label: "Other", value: "Other" },
    ],
    loanFrequencies: [
        { label: "Monthly", value: "MONTHLY" },
    ],
    loanFrequencies2: [
        { label: "Fortnightly", value: "FORTNIGHTLY" },
        { label: "Monthly", value: "MONTHLY" },
    ],
    clientTiers: [
        { label: "A", value: "A" },
        { label: "B", value: "B" },
        { label: "C", value: "C" }
    ],
    assetYears: [
        { label: "2022", value: "2022" },
        { label: "2021", value: "2021" },
        { label: "2020", value: "2020" },
        { label: "2019", value: "2019" },
        { label: "2018 or older", value: "2018 or older" },
    ],
    propertyOwners: CommonOptions.yesNo,
    typeValues: [
        { label: "Percentage", value: "Percentage" },
        { label: "Value", value: "Value" },
    ],
    vehicleAges: [
        { label: "New", value: "New" },
        { label: "Used 0-5 years", value: "Used 0-5 years" },
        { label: "Used 6+ years", value: "Used 6+ years" },
    ],
    terms: CommonOptions.terms(24, 72),

};

const productToFrequency = {
    'Chattel Mortgage-Full-Doc': 'loanFrequencies',
    'Chattel Mortgage-Low-Doc': 'loanFrequencies',
    'Finance Lease': 'loanFrequencies2',
    'Novated Lease': 'loanFrequencies2',
};

const monthlyProduct = [
    'Chattel Mortgage-Full-Doc', 'Chattel Mortgage-Low-Doc',
];

// Reset
const reset = () => {
    let r = {
        loanType: calcOptions.loanTypes[0].value,
        loanProduct: calcOptions.loanProducts[0].value,
        loanFrequency: calcOptions.loanFrequencies[0].value,
        assetType: calcOptions.assetTypes[0].value,
        price: null,
        deposit: null,
        tradeIn: null,
        payoutOn: null,
        applicationFee: null,
        maxApplicationFee: null,
        dof: null,
        residualValue: 0.0,
        residualPer: 0.0,
        ppsr: null,
        monthlyFee: null,
        maxDof: null,
        term: 60,
        clientTier: calcOptions.clientTiers[0].value,
        assetAge: calcOptions.assetYears[0].value,
        propertyOwner: calcOptions.propertyOwners[0].value,
        // assetAge: calcOptions.vehicleAges[0].value,
        privateSales: "N",
        paymentType: "Arrears",
        baseRate: 0.0,
        maxRate: 0.0,
        clientRate: null,
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
                }
                data.typeValue = "Value";
                resolve(data);
            })
            .catch((error) => reject(error));
    });

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
        let profile = "Westpac";
        const p = {
            lender: LENDER_QUOTING,
            productLoanType: quote.loanProduct,
            customerProfile: profile,
            clientTier: quote.clientTier,
            vehicleYear: quote.assetAge,
            goodsType: quote.assetType,
            privateSales: quote.privateSales,
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
            console.log(`@@SAVING: ${JSON.stringify(param, null, 2)}`);
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

const netDepositVal = (quoteForm) => {
    return QuoteCommons.calcNetDeposit(quoteForm);
};

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
    saveQuote: saveQuote,
    sendEmail: sendEmail,
    prodMap: productToFrequency,
    monPro: monthlyProduct,
    getClientRateCalc: getClientRateCalc,
    getResiVal: getResidualValue,
    getResiPer: getResidualPercentage,

};