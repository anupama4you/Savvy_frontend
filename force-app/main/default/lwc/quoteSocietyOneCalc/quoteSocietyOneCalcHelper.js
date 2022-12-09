import getQuotingData from "@salesforce/apex/QuoteSocietyOneController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteSocietyOneController.save";
import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};

const LENDER_QUOTING = "Society One";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["purposeType", "Purpose_Type__c"],
  ["price", "Vehicle_Price__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["residual", "Residual_Value__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["security", "Loan_Facility_Type__c"],
  ["clientTier", "Client_Tier__c"],
  ["paymentType", "Payment__c"],
  ["clientRate", "Client_Rate__c"],
  ["loanPurpose", "Loan_Purpose__c"]
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
    ...QUOTING_FIELDS,
    ["Id", "Id"],
]);


const RATE_SETTING_NAMES = ["PepperRate__c", "PepperRate__c_2", "PepperRate__c_3"];

const SETTING_FIELDS = new Map([
    ["applicationFee", "Application_Fee__c"],
    ["maxApplicationFee", "Application_Fee__c"],
    ["dof", "Max_DOF__c"],
    ["maxDof", "Max_DOF__c"],
]);

const BASE_RATE_FIELDS = [
    "customerProfile",
    "clientTier",
    "assetAge",
    "purposeType",
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
            // Prepare params
            let profile = "COMMERCIAL";
            Object.is(quote.purposeType, "Other-Primary Assets") && (profile = "OTHER - Primary");
            Object.is(quote.purposeType, "Other-Secondary & Tertiary Assets") && (profile = "OTHER - 2nd & 3rd");
            const p = {
                lender: LENDER_QUOTING,
                totalAmount: QuoteCommons.calcTotalAmount(quote),
                totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                clientRate: quote.clientRate,
                paymentType: quote.paymentType,
                term: quote.term,
                dof: quote.dof,
                monthlyFee: quote.monthlyFee,
                residualValue: quote.residual,
                customerProfile: profile,
                clientTier: quote.clientTier,
                productLoanType: quote.loanProduct,
                vehicleYear: quote.assetAge,
                goodsType: quote.purposeType,
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
    loanProducts: [
        { label: "Customer Loan", value: "Customer Loan" },
        ...CommonOptions.businessLoanProducts
    ],
    purposeTypes: [
        { label: "Debt Consolidation", value: "Debt Consolidation" },
        { label: "Car", value: "Car" },
        { label: "Motorbike", value: "Motorbike" },
        { label: "Boat", value: "Boat" },
        { label: "Business", value: "Business" },
        { label: "Funeral Expenses", value: "Funeral Expenses" },
        { label: "Investment", value: "Investment" },
        { label: "Home Improvement", value: "Home Improvement" },
        { label: "Holiday", value: "Holiday" },
        { label: "Medical Dental", value: "Medical Dental" },
        { label: "Moving Costs", value: "Moving Costs" },
        { label: "Pay Bills", value: "Pay Bills" },
        { label: "Payoff Loan", value: "Payoff Loan" },
        { label: "Professional Service Fees", value: "Professional Service Fees" },
        { label: "Rental Bond", value: "Rental Bond" },
        { label: "Repairs", value: "Repairs" },
        { label: "Solar Battery", value: "Solar Battery" },
        { label: "Wedding", value: "Wedding" },
        { label: "Other", value: "Other" },
    ],
    terms: [
        { label: "6", value: 6 },
        { label: "9", value: 9 },
        { label: "12", value: 12 },
        { label: "18", value: 18 },
        ...CommonOptions.terms(24, 96)],
    securities: [
        { label: "Secured", value: "Secured" },
        { label: "Unsecured", value: "Unsecured" },
    ],
    clientTiers: [
        { label: "Tier 1", value: "Tier 1" },
        { label: "Tier 2", value: "Tier 2" },
        { label: "Tier 3", value: "Tier 3" },
        { label: "Tier 4", value: "Tier 4" },
    ],
    paymentTypes: CommonOptions.paymentTypes,
};

// Reset
const reset = () => {
    let r = {
        loanType: calcOptions.loanTypes[0].value,
        loanProduct: calcOptions.loanProducts[0].value,
        purposeType: calcOptions.purposeTypes[0].value,
        security: calcOptions.securities[0].value,
        price: null,
        applicationFee: null,
        maxApplicationFee: null,
        dof: null,
        residual: 0.0,
        monthlyFee: null,
        maxDof: null,
        term: 60,
        clientTier: calcOptions.clientTiers[0].value,
        paymentType: "Arrears",
        clientRate: null,
        loanPurpose: null,
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
                resolve(data);
            })
            .catch((error) => reject(error));
    });

// Get Base Rates
const getMyBaseRates = (quote) =>
    new Promise((resolve, reject) => {
        let profile = "COMMERCIAL";
        Object.is(quote.purposeType, "Other-Primary Assets") && (profile = "OTHER - Primary");
        Object.is(quote.purposeType, "Other-Secondary & Tertiary Assets") && (profile = "OTHER - 2nd & 3rd");
        const p = {
            lender: LENDER_QUOTING,
            productLoanType: quote.loanProduct,
            customerProfile: profile,
            clientTier: quote.clientTier,
            vehicleYear: quote.assetAge,
            goodsType: quote.purposeType,
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
    lenderSettings: lenderSettings,
    getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    saveQuote: saveQuote,
    sendEmail: sendEmail,
};