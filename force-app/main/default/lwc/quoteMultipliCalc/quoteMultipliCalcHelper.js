import getQuotingData from "@salesforce/apex/QuoteMultipliCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteMultipliCalcController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import { QuoteCommons, CommonOptions } from "c/quoteCommons";
import { Validations } from "./quoteValidations";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteMultipliCalcController.save";

// Default settings
let lenderSettings = {};

const LENDER_QUOTING = "Multipli";

//         r += param.brokeragePer > 4 ? (param.brokeragePer - 4) / 2 : 0;
const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["assetType", "Goods_type__c"],
    ["price", "Vehicle_Price__c"],
    ["deposit", "Deposit__c"],
    ["tradeIn", "Trade_In__c"],
    ["payoutOn", "Payout_On__c"],
    ["applicationFee", "Application_Fee__c"],
    ["dof", "DOF__c"],
    // ["ppsr", "PPSR__c"],
    ["netDeposit", "Net_Deposit__c"],
    ["term", "Term__c"],
    ["paymentType", "Payment__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["creditScore", "Credit_Score__c"],
    ["directorSoleTraderScore", "Extra_Label_3__c"],
    ["paidDefault", "Extra_Label_4__c"],
    ["condition", "Condition__c"],
    ["residualValue", "Residual_Value__c"],
    ["adverseCredit", "Adverse_Credit_File__c"],
    ["abnLength", "Extra_Label_1__c"],
    ["gstLength", "Extra_Label_2__c"],
    ["assetAge", "Vehicle_Age__c"],
    ["customerProfile", "Customer_Profile__c"],
    ["privateSales", "Private_Sales__c"],
    ["brokerage", "Brokerage__c"],
    ["baseRateManual", "Extra_Value_1__c"],
    ["baseRate", "Base_Rate__c"],
    ["clientRate", "Client_Rate__c"],
    ["addOnRate", "Rate_Options__c"],
    ["residualValuePercentage", "Residual_Value_Percentage__c"]
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
    ...QUOTING_FIELDS,
    ["Id", "Id"],
    ["naf", "NAF__c"]
]);

const SETTING_FIELDS = new Map([
    ["maxAppFee", "Application_Fee__c"],
    ["applicationFee", "Application_Fee__c"],
    ["baseRate", "Default_Base_Rate__c"],
    ["defaultBaseRate", "Default_Base_Rate__c"],
    ["maxBrok", "Max_Brokerage__c"],
    ["netDeposit", "Net_Deposit__c"]
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
    "condition",
    "customerProfile",
    "creditScore",
    "directorSoleTraderScore",
    "privateSales",
    "abnLength",
    "gstLength",
    "paidDefault",
    "brokerage",
    "price",
    "deposit",
    "tradeIn",
    "payoutOn",
    "applicationFee",
    "dof",
    // "ppsr",
    "residualValue",
    "residualValuePercentage",
    "paymentType",
    "baseRateManual"
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
        console.log('ling 130', res.messages);
        if (res.messages && res.messages.errors.length > 0) {
            reject(res);
            console.log('ling 133', res);
        } else {
            // Prepare params
            const p = {
                lender: LENDER_QUOTING,
                baseRate: quote.baseRateManual === 0 ? quote.baseRate : quote.baseRateManual,
                amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
                totalAmount: QuoteCommons.calcTotalAmount(quote) - quote.dof,
                totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
                term: quote.term,
                residualValue: quote.residualValue,
                paymentType: quote.paymentType,
                brokeragePer: quote.brokerage,
                amountBaseComm: quote.price - QuoteCommons.calcNetDeposit(quote),
                totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
                dof: quote.dof,
                monthlyFee: quote.monthlyFee,
            };

            // Calculate
            console.log(`@@ calculate param:`, JSON.stringify(p, null, 2));
            calculateRepayments({
                param: p
            })
                .then((data) => {
                    console.log(`@@ after...calculate line 159:`, JSON.stringify(data, null, 2));
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

const createTerms = () => {
    let r = [];
    for (let i = 36; i <= 60; i += 12) {
        r.push({ label: i.toString(), value: i.toString() });
    }
    return r;
};

const calcOptions = {
    loanTypes: [
        { label: "Multipli 600", value: "Multipli 600" },
        { label: "1 Day ABN", value: "1 Day ABN" },
        { label: "Full Doc", value: "Full Doc" },
    ],
    paymentTypes: CommonOptions.paymentTypes.filter(type => type.value.includes("Arrears")),
    propertyOwnerTypes: CommonOptions.yesNo,
    assetTypes: [
        { label: "Wheels New", value: "Wheels New" },
        { label: "Wheels Used", value: "Wheels Used" },
        { label: "Equipment", value: "Equipment" },
    ],
    terms: createTerms(),
    assetAges: createAssetAges(),
    privateSales: [
        { label: "--None--", value: "" },
        { label: "Yes", value: "Y" },
        { label: "No", value: "N" }
    ],
    typeValues: [
        { label: "Percentage", value: "Percentage" },
        { label: "Value", value: "Value" },
    ],
    creditScores: [
        { label: "< 600", value: "< 600" },
        { label: "600 - 629", value: "600 - 629" },
        { label: "630 - 749", value: "630 - 749" },
        { label: "750 +", value: "750 +" },
    ],
    conditions: [
        { label: "--None--", value: "" },
        { label: "New", value: "New" },
        { label: "Used", value: "Used" }
    ],
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
        dof: 0,
        // ppsr: 0,
        term: "60",
        // term: calcOptions.terms[0].value,
        paymentType: calcOptions.paymentTypes[0].value,
        monthlyFee: 0,
        creditScore: "",
        directorSoleTraderScore: "",
        paidDefault: "",
        condition: "",
        residualValue: 0,
        typeValue: calcOptions.typeValues[1].value,
        residualValuePercentage: null,
        adverseCredit: "",
        assetAge: calcOptions.assetAges[0].value,
        customerProfile: calcOptions.propertyOwnerTypes[1].value,
        privateSales: "",
        brokerage: 0,
        baseRate: 0.0,
        baseRateManual: 0.0,
        addOnRate: 0.0,
        clientRate: 0,
        commissions: QuoteCommons.resetResults()
    };
    console.log('Helper reset...');
    console.log('obj:::', r, 'lenderSettings:::', lenderSettings, 'SETTING_FIELDS:::', SETTING_FIELDS);
    r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
    return r;
};

// Load Data
const loadData = (recordId) =>
    new Promise((resolve, reject) => {
        //  const fields = Array.from(QUOTING_FIELDS.values());
        const fields = [
            ...QUOTING_FIELDS.values(),
            ...QuoteCommons.COMMISSION_FIELDS.values()
        ];
        console.log('oppId', recordId,
            'fields', fields,
            'calcName', LENDER_QUOTING
        );
        getQuotingData({
            param: {
                oppId: recordId,
                fields: fields,
                calcName: LENDER_QUOTING
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

                // Defaults
                if (data.paidDefault === undefined || data.paidDefault === null) {
                    data.paidDefault = "";
                }
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

// Get Base Rates
const getMyBaseRates = (quote) =>
    new Promise((resolve, reject) => {
        const p = {
            lender: LENDER_QUOTING,
            assetAge: quote.assetAge,
            term: parseInt(quote.term),
            assetType: quote.assetType,
            condition: quote.condition,
            customerProfile: quote.customerProfile,
            companyScore: quote.creditScore,
            directorSoleTraderScore: quote.directorSoleTraderScore,
            privateSales: quote.privateSales,
            abnLength: quote.abnLength,
            gstLength: quote.gstLength,
            paidDefault: quote.paidDefault,
            brokeragePer: quote.brokerage,
            hasMaxRate: false,
            residualValue: quote.residualValue ? quote.residualValue : 0,
            amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
            paymentType: quote.paymentType,
            price: quote.price,
            deposit: quote.deposit,
            tradeIn: quote.tradeIn,
            payoutOn: quote.payoutOn,
            applicationFee: quote.applicationFee,
            dof: quote.dof,
            // ppsr: quote.ppsr,
            totalAmount: QuoteCommons.calcTotalAmount(quote),
            totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
            defaultBaseRate: quote.defaultBaseRate
        };
        console.log(`getMyBaseRates...`, JSON.stringify(p, null, 2));
        getBaseRates({
            param: p,
            manualRate: quote.baseRateManual
        })
            .then((rates) => {
                console.log(`@@SF:`, JSON.stringify(rates, null, 2));
                resolve({
                    baseRate: rates.baseRate,
                    clientRate: rates.clientRate
                });
            })
            .catch((error) => reject(error));
    });


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
            param.addOnRate += '';
            save({
                param: QuoteCommons.mapLWCToSObject(
                    param,
                    recordId,
                    LENDER_QUOTING,
                    FIELDS_MAPPING_FOR_APEX
                ),
                approvalType: approvalType,
                manualRate: param.baseRateManual
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

const calcNetRealtimeNaf = (quote) => {
    return QuoteCommons.calcNetRealtimeNaf(quote) - quote.dof;
};

export const CalHelper = {
    options: calcOptions,
    calculate: calculate,
    load: loadData,
    baseRates: getMyBaseRates,
    reset: reset,
    BASE_RATE_FIELDS: BASE_RATE_FIELDS,
    RESIDUAL_VALUE_FIELDS: RESIDUAL_VALUE_FIELDS,
    CLIENT_RATE_FIELDS: CLIENT_RATE_FIELDS,
    lenderSettings: lenderSettings,
    getNetRealtimeNaf: calcNetRealtimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    saveQuote: saveQuote,
    sendEmail: sendEmail,
    getResidualValue: getResidualValue,
    getResidualPercentage: getResidualPercentage,
};