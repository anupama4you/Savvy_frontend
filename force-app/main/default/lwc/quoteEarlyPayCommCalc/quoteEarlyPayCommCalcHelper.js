import getQuotingData from "@salesforce/apex/QuoteEarlyPayCommCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteEarlyPayCommCalcController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import { QuoteCommons, CommonOptions, FinancialUtilities as fu } from "c/quoteCommons";
import { Validations } from "./quoteValidations";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteEarlyPayCommCalcController.save";

// Default settings
let lenderSettings = {};
const LENDER_QUOTING = "Early Pay Commercial";
const FINANCE_150K = 150000;
const FINANCE_500K = 500000;

const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["assetType", "Goods_type__c"],
    ["price", "Vehicle_Price__c"],
    ["deposit", "Deposit__c"],
    ["tradeIn", "Trade_In__c"],
    ["payoutOn", "Payout_On__c"],
    ["netDeposit", "Net_Deposit__c"],
    ["applicationFee", "Application_Fee__c"],
    ["ppsr", "PPSR__c"],
    ["term", "Term__c"],
    ["paymentType", "Payment__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["directorSoleTraderScore", "Extra_Label_3__c"],
    ["atoDebt", "Condition__c"],
    ["residualValue", "Residual_Value__c"],
    ["adverseCredit", "Extra_Label_2__c"],
    // ["adverseCredit", "Adverse_Credit_File__c"],
    ["abnGst", "Extra_Label_1__c"],
    ["assetAge", "Vehicle_Age__c"],
    ["customerProfile", "Customer_Profile__c"],
    ["brokerage", "Brokerage__c"],
    ["baseRate", "Base_Rate__c"],
    ["clientRate", "Client_Rate__c"],
    ["residualValuePercentage", "Residual_Value_Percentage__c"]
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
    ...QUOTING_FIELDS,
    ["Id", "Id"],
    ["naf", "NAF__c"]
]);

const RATE_SETTING_NAMES = ["gacTier1"];

const SETTING_FIELDS = new Map([
    ["applicationFee", "Application_Fee__c"],
    ["maxApplicationFee", "Application_Fee__c"],
    ["maxBrokStage1", "Max_Brokerage__c"],
]);

const RESIDUAL_VALUE_FIELDS = [
    "residualValue",
    "residualValuePercentage",
    "typeValue",
    "price",
    "deposit",
    "tradeIn",
    "payoutOn"
];

const CLIENT_RATE_FIELDS = [
    "brokerage",
];

const BASE_RATE_FIELDS = [
    "assetAge",
    "term",
    "assetType",
    "atoDebt",
    "customerProfile",
    "directorSoleTraderScore",
    "abnGst",
    "brokerage",
    "price",
    "deposit",
    "tradeIn",
    "payoutOn",
    "applicationFee",
    "ppsr",
    "residualValue",
    "residualValuePercentage",
    "paymentType"
];

// lessEqual to <= 
// greaterEqual to >=
const BASE_RATE_AMENDEMENTS = [
    { field: "assetType", value: "Secondary/Tertiary Assets", additionalRate: 1, condition: "equal" },
    { field: "term", value: "36", additionalRate: 1, condition: "lessEqual" },
    { field: "atoDebt", value: "Y", additionalRate: 1, condition: "equal" },
    { field: "adverseCredit", value: "Paid Defaults/Judgments/Bankrupt - Non Property", additionalRate: 3, condition: "equal" },
    // { field: "adverseCredit", value: "PNP", additionalRate: 3, condition: "equal" },
];

const getBaseAmountPmtInclBrokerageCalc = (quote) => {
    let naf = QuoteCommons.calcNetRealtimeNaf(quote);
    let broker = quote.brokerage > 0 ? quote.brokerage : 0;
    console.log('get PMT...', naf + naf * broker / 100);
    return naf + (naf * broker) / 100;
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
            console.log('ling 133', res);
        } else {
            // Prepare params
            const p = {
                lender: LENDER_QUOTING,
                baseRate: quote.baseRate,
                amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
                totalAmount: QuoteCommons.calcTotalAmount(quote),
                totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
                term: quote.term,
                residualValue: quote.residualValue,
                paymentType: quote.paymentType,
                brokeragePer: quote.brokerage,
                amountBaseComm: quote.price - QuoteCommons.calcNetDeposit(quote),
                totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
                monthlyFee: quote.monthlyFee,
            };
            // Calculate
            console.log(`@@param:`, JSON.stringify(p, null, 2));
            calculateRepayments({
                param: p
            })
                .then((data) => {
                    console.log(`@@SF...calculate line 159:`, JSON.stringify(data, null, 2));
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

const createAssetAges = () => {
    let r = [];
    for (let i = 1; i < 20; i++) {
        r.push({ label: i.toString(), value: i.toString() });
    }
    return r;
};


const baesRates = (quote) => {
    return modifyBaseRate(quote, calcOptions.defaultBaseRates, BASE_RATE_AMENDEMENTS);
};

/**
 * Rick --- Don't change this calculate method, only change the BASE_RATE_AMENDEMENTS or base rate when rates or condition changes.
 * @param {Object} quote    
 * @param {array} defaultRates  Default base rate on calcOptions
 * @param {array} amendments    BASE_RATE_AMENDEMENTS
 * @returns {array} 
 */
const modifyBaseRate = (quote, defaultRates, amendments) => {
    let modifedRates = JSON.parse(JSON.stringify(defaultRates));
    amendments.forEach(o => {
        if (o.condition === "equal" && quote[o.field] === o.value) {
            modifyHelper(modifedRates)(o.additionalRate);
        }
        if (o.condition === "lessEqual" && quote[o.field] <= o.value) {
            modifyHelper(modifedRates)(o.additionalRate);
        }
        if (o.condition === "greaterEqual" && quote[o.field] >= o.value) {
            modifyHelper(modifedRates)(o.additionalRate);
        }
    });
    return modifedRates;
};

const modifyHelper = (array) => {
    return (num) => {
        return array.map(e => {
            const modifiedObj = e;
            modifiedObj.label = (parseFloat(e.label) + num).toString();
            modifiedObj.value = parseFloat((e.value + num).toFixed(2));
            // modifiedObj.value = (parseFloat(e.value) + num).toString();
            return modifiedObj;
        });
    };
};

const calcOptions = {
    loanTypes: [
        { label: "Full Doc", value: "Full Doc" },
        { label: "Low Doc", value: "Low Doc" },
        { label: "Easy Doc", value: "Easy Doc" },
    ],
    paymentTypes: CommonOptions.paymentTypes,
    propertyOwnerTypes: [
        { label: "--None--", value: "" },
        ...CommonOptions.yesNo
    ],
    assetTypes: [
        { label: "Vehicles", value: "Vehicles" },
        { label: "Secondary/Tertiary Assets", value: "Secondary/Tertiary Assets" },
    ],
    terms: CommonOptions.terms(12, 60),
    assetAges: [
        { label: "No age limit", value: "No age limit" },
        ...createAssetAges()],
    abnGsts: [
        { label: "< 2 years", value: "< 2 years" },
        { label: "> 2 years", value: "> 2 years" },
    ],
    typeValues: [
        { label: "Percentage", value: "Percentage" },
        { label: "Value", value: "Value" },
    ],
    directorSoleTraderScores: [
        { label: "< 450", value: "< 450" },
        { label: "> 450", value: "> 450" },
    ],
    atoDebts: [
        { label: "--None--", value: "" },
        { label: "Yes", value: "Y" },
        { label: "No", value: "N" }
    ],
    adverseCredits: [
        { label: "--None--", value: "" },
        // { label: "Paid Defaults/Judgments/Bankrupt - Property owner", value: "PP" },
        // { label: "Paid Defaults/Judgments/Bankrupt - Non Property", value: "PNP" },
        // { label: "Unpaid defaults/judgments/Bankrupt", value: "NP" },
        { label: "Paid Defaults/Judgments/Bankrupt - Property owner", value: "Paid Defaults/Judgments/Bankrupt - Property owner" },
        { label: "Paid Defaults/Judgments/Bankrupt - Non Property", value: "Paid Defaults/Judgments/Bankrupt - Non Property" },
        { label: "Unpaid defaults/judgments/Bankrupt", value: "Unpaid defaults/judgments/Bankrupt" },
    ],
    defaultBaseRates: [
        { label: "12.5", value: 12.5 },
        { label: "13.5", value: 13.5 },
    ],
    baseRates: baesRates,
};

// Reset
const reset = (recordId) => {
    let r = {
        oppId: recordId,
        quoteName: LENDER_QUOTING,
        loanType: calcOptions.loanTypes[0].value,
        assetType: calcOptions.assetTypes[0].value,
        price: 0,
        deposit: 0,
        tradeIn: 0,
        payoutOn: 0,
        applicationFee: 0,
        ppsr: 0,
        term: 60,
        paymentType: "Advance",
        monthlyFee: 0,
        directorSoleTraderScore: "",
        atoDebt: "",
        residualValue: 0,
        typeValue: calcOptions.typeValues[1].value,
        residualValuePercentage: null,
        adverseCredit: "",
        abnGst: calcOptions.abnGsts[0].value,
        assetAge: "",
        customerProfile: calcOptions.propertyOwnerTypes[0].value,
        brokerage: 0,
        maxBrokStage2: 3,
        baseRate: 0.0,
        clientRate: 0,
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
        console.log('oppId', recordId,
            'fields', fields,
            'calcName', LENDER_QUOTING,
            'rateSettings', RATE_SETTING_NAMES);
        // console.log(`@@fields:`, JSON.stringify(fields, null, 2));
        getQuotingData({
            param: {
                oppId: recordId,
                fields: fields,
                calcName: LENDER_QUOTING,
                rateSettings: RATE_SETTING_NAMES
            }
        })
            .then((quoteData) => {
                console.log(`Helper line 308...@@SF:`, JSON.stringify(quoteData, null, 2));
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
                resolve(data);
            })
            .catch((error) => reject(error));
    });

const getResidualValue = (quote) => {
    return ((quote.price - QuoteCommons.calcNetDeposit(quote)) * quote.residualValuePercentage) / 100;
};

const getResidualPercentage = (quote) => {
    let percentage = (quote.residualValue / (quote.price - QuoteCommons.calcNetDeposit(quote))) * 100;
    return percentage.toFixed(2);
};

const getClientRateCalc = (param) => {
    const naf = QuoteCommons.calcNetRealtimeNaf(param);
    const amountBasePmt = getBaseAmountPmtInclBrokerageCalc(param);
    const { baseRate } = param;

    const residualValue = 0;
    let type = 0;
    if (param.paymentType === "Advance") {
        type = 1;
    }
    const pmt = fu.pmt2((baseRate / 100 / 12),
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
    if (baseRate == 0) {
        r = 0;
    }
    return (r * 12 * 100).toFixed(2);
};

/**
 * -- Lee
 * @param {String} approvalType - type of approval
 * @param {Object} quote - quoting form
 * @param {Id} recordId - recordId
 * @returns
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
    FINANCE_150K: FINANCE_150K,
    FINANCE_500K: FINANCE_500K,
    BASE_RATE_FIELDS: BASE_RATE_FIELDS,
    RESIDUAL_VALUE_FIELDS: RESIDUAL_VALUE_FIELDS,
    CLIENT_RATE_FIELDS: CLIENT_RATE_FIELDS,
    BASE_RATE_AMENDEMENTS: BASE_RATE_AMENDEMENTS,
    lenderSettings: lenderSettings,
    getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    saveQuote: saveQuote,
    sendEmail: sendEmail,
    getResidualValue: getResidualValue,
    getResidualPercentage: getResidualPercentage,
    getClientRateCalc: getClientRateCalc,
};