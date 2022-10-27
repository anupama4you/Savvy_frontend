import getQuotingData from "@salesforce/apex/QuotePepperMVController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuotePepperMVController.save";
import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};

const LENDER_QUOTING = "APF";

const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["loanProduct", "Loan_Product__c"],
    ["profile", "Customer_Profile__c"],
    ["loanTypeDetail", "Loan_Facility_Type__c"],
    ["customerGrading", "Category_Type__c"],
    ["price", "Vehicle_Price__c"],
    ["deposit", "Deposit__c"],
    ["netDeposit", "Net_Deposit__c"],
    ["tradeIn", "Trade_In__c"],
    ["payoutOn", "Payout_On__c"],
    ["applicationFee", "Application_Fee__c"],
    ["dof", "DOF__c"],
    ["ppsr", "PPSR__c"],
    ["residual", "Residual_Value__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["term", "Term__c"],
    ["paymentType", "Payment__c"],
    ["clientRate", "Client_Rate__c"],
    ["commission", "Bonus_Commission__c"],
    ["applicationId", "Application__c"],
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
    ...QUOTING_FIELDS,
    ["Id", "Id"],
    ["baseRate", "Base_Rate__c"],
    ["maxRate", "Manual_Max_Rate__c"]
]);

const RATE_SETTING_NAMES = ["PepperRate__c"];

const SETTING_FIELDS = new Map([
    ["applicationFee", "Application_Fee__c"],
    ["maxApplicationFee", "Application_Fee__c"],
    ["dof", "Max_DOF__c"],
    ["maxDof", "Max_DOF__c"],
    ["ppsr", "PPSR__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["clientRate", "Default_Base_Rate__c"],
]);

const BASE_RATE_FIELDS = [
    "customerProfile",
];

const MAX_APP_DOF_FIELDS = [
    "price", "deposit", "tradeIn", "payoutOn",
];

const calculate = (quote) =>
    new Promise((resolve, reject) => {
        console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
        let res = {
            commissions: QuoteCommons.resetResults(),
            messages: QuoteCommons.resetMessage()
        };
        // Validate quote
        // res.messages = Validations.validate(quote, res.messages);
        if (res.messages && res.messages.errors.length > 0) {
            reject(res);
        } else {
            // Prepare params
            const p = {
                lender: LENDER_QUOTING,
                productLoanType: quote.loanProduct,
                totalAmount: QuoteCommons.calcTotalAmount(quote),
                // totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                // totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
                clientRate: quote.clientRate,
                paymentType: quote.paymentType,
                term: quote.term,
                dof: quote.dof,
                monthlyFee: quote.monthlyFee,
                residualValue: quote.residual,
                customerProfile: quote.profile,
                riskGrade: quote.customerGrading,
                amountBaseComm: quote.commission,
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
    });

const calcOptions = {
    loanTypes: CommonOptions.loanTypes,
    loanProducts: CommonOptions.fullLoanProducts,
    profiles: [{ label: "Asset Finance", value: "Asset Finance" }],
    loanTypeDetails: [
        { label: "Centrelink only", value: "Centrelink only" },
        { label: "Standard PAYG", value: "Standard PAYG" }
    ],
    customerGradings: [
        { label: "--None--", value: null },
        { label: "Platinum", value: "Platinum" },
        { label: "Gold", value: "Gold" },
        { label: "Silver", value: "Silver" },
        { label: "Bronze", value: "Bronze" },
        { label: "Micro Motor", value: "Micro Motor" },
    ],
    terms: [
        { label: "48", value: 48 },
        { label: "54", value: 54 },
        { label: "60", value: 60 },
    ],
    paymentTypes: CommonOptions.paymentTypes,
};

const reset = (recordId) => {
    let r = {
        oppId: recordId,
        loanType: calcOptions.loanTypes[0].value,
        loanProduct: calcOptions.loanProducts[0].value,
        profile: calcOptions.profiles[0].value,
        loanTypeDetail: calcOptions.loanTypeDetails[0].value,
        customerGrading: calcOptions.customerGradings[0].value,
        price: null,
        deposit: null,
        netDeposit: 0.0,
        // create the dynamic max application and dof fee at the initial stage
        maxAppFeeDynamic: 0,
        maxDofFeeDynamic: 0,
        tradeIn: null,
        payoutOn: null,
        applicationFee: null,
        maxApplicationFee: null,
        dof: null,
        maxDof: null,
        ppsr: null,
        residual: 0.0,
        term: 60,
        monthlyFee: null,
        baseRate: 0.0,
        maxRate: 0.0,
        clientRate: null,
        paymentType: "Arrears",
        commissions: QuoteCommons.resetResults(),
        insurance: { integrity: {} }
    };
    r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
    return r;
};

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
                console.log(`@@SF:`, JSON.stringify(quoteData, null, 2));
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
                console.log(`@@data:`, JSON.stringify(data, null, 2));
                resolve(data);
            })
            .catch((error) => reject(error));
    });

// Get Base Rates
const getMyBaseRates = (quote) =>
    new Promise((resolve, reject) => {
        const p = {
            lender: LENDER_QUOTING,
            productLoanType: quote.loanProduct,
            customerProfile: profile,
            hasMaxRate: true
        };
        console.log(`getMyBaseRates...`, JSON.stringify(p, null, 2));
        getBaseRates({
            param: p
        })
            .then((rates) => {
                console.log(`@@SF:`, JSON.stringify(rates, null, 2));
                resolve(rates);
            })
            .catch((error) => reject(error));
    });

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
            const p = QuoteCommons.mapLWCToSObject(
                param,
                recordId,
                LENDER_QUOTING,
                FIELDS_MAPPING_FOR_APEX
            );
            console.log(`@@save-param:`, JSON.stringify(p, null, 2));
            save({
                param: p,
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
 *  -- Rick
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
    // baseRates: getMyBaseRates,
    BASE_RATE_FIELDS: BASE_RATE_FIELDS,
    MAX_APP_DOF_FIELDS: MAX_APP_DOF_FIELDS,
    lenderSettings: lenderSettings,
    getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    saveQuote: saveQuote,
    sendEmail: sendEmail,
};