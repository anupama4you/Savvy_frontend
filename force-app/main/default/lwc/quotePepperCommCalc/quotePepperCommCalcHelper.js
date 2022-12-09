import getQuotingData from "@salesforce/apex/QuotePepperCommController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuotePepperCommController.save";
import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
// API Responses
let apiResponses = {};
// Rates
let tableRatesData = [];
let tableRatesData2 = [];
let tableRatesData3 = [];

let tableRateDataColumns = [
    { label: "Tier", fieldName: "Tier__c", fixedWidth: 70 },
    { label: "New", fieldName: "Rate0__c", fixedWidth: 80 },
    { label: "Used 0-5 years", fieldName: "Rate1__c", fixedWidth: 140 },
    { label: "Used 6+ years", fieldName: "Rate2__c", fixedWidth: 140 },
];
let tableRateDataColumns2 = [
    { label: "Tier", fieldName: "Tier__c", fixedWidth: 70 },
    { label: "New and Demo", fieldName: "Rate0__c", fixedWidth: 140 },
    { label: "Used all ages", fieldName: "Rate1__c", fixedWidth: 140 },
];
let tableRateDataColumns3 = [
    { label: "Tier", fieldName: "Tier__c", fixedWidth: 70 },
    { label: "New and Used all ages", fieldName: "Rate0__c", fixedWidth: 180 },
];
const LENDER_QUOTING = "Pepper Commercial";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["assetType", "Goods_type__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["netDeposit", "Net_Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["residual", "Residual_Value__c"],
  ["ppsr", "PPSR__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["clientRate", "Client_Rate__c"],
  ["paymentType", "Payment__c"],
  ["privateSales", "Private_Sales__c"],
  ["clientTier", "Client_Tier__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["baseRate", "Base_Rate__c"],
  ["maxRate", "Manual_Max_Rate__c"]
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
    ...QUOTING_FIELDS,
    ["Id", "Id"],    
]);


const RATE_SETTING_NAMES = ["PepperRate__c", "PepperRate__c_2", "PepperRate__c_3"];

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
    "clientTier",
    "assetAge",
    "assetType",
    "privateSales",
    "term"
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
            Object.is(quote.assetType, "Other-Primary Assets") && (profile = "OTHER - Primary");
            Object.is(quote.assetType, "Other-Secondary & Tertiary Assets") && (profile = "OTHER - 2nd & 3rd");
            const p = {
                lender: LENDER_QUOTING,
                totalAmount: QuoteCommons.calcTotalAmount(quote),
                // totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
                clientRate: quote.clientRate,
                baseRate: quote.baseRate,
                paymentType: quote.paymentType,
                term: quote.term,
                dof: quote.dof,
                monthlyFee: quote.monthlyFee,
                residualValue: quote.residual,
                customerProfile: profile,
                clientTier: quote.clientTier,
                productLoanType: quote.loanProduct,
                vehicleYear: quote.assetAge,
                privateSales: quote.privateSales,
                goodsType: quote.assetType,
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
    paymentTypes: CommonOptions.paymentTypes,
    loanProducts: CommonOptions.businessLoanProducts,
    privateSales: CommonOptions.yesNo,
    assetTypes: [
        { label: "Car", value: "Car" },
        { label: "Caravan", value: "Caravan" },
        { label: "Wheels & Tracks", value: "Wheels & Tracks" },
        { label: "Other-Primary Assets", value: "Other-Primary Assets" },
        { label: "Other-Secondary & Tertiary Assets", value: "Other-Secondary & Tertiary Assets" },
    ],
    clientTiers: [
        { label: "A", value: "A" },
        { label: "B", value: "B" },
        { label: "C", value: "C" }
    ],
    vehicleAges: [
        { label: "New", value: "New" },
        { label: "Used 0-5 years", value: "Used 0-5 years" },
        { label: "Used 6+ years", value: "Used 6+ years" },
    ],
    terms: CommonOptions.terms(12, 84)
};

// Reset
const reset = () => {
    let r = {
        loanType: calcOptions.loanTypes[0].value,
        loanProduct: calcOptions.loanProducts[0].value,
        assetType: calcOptions.assetTypes[0].value,
        price: null,
        deposit: null,
        tradeIn: null,
        payoutOn: null,
        applicationFee: null,
        maxApplicationFee: null,
        dof: null,
        residual: 0.0,
        ppsr: null,
        monthlyFee: null,
        maxDof: null,
        term: 60,
        clientTier: calcOptions.clientTiers[0].value,
        assetAge: calcOptions.vehicleAges[0].value,
        privateSales: "N",
        paymentType: "Arrears",
        baseRate: 0.0,
        maxRate: 0.0,
        clientRate: null,
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

              // API  responses
              apiResponses = quoteData.apiResponses;

              // Rate Settings
              if (quoteData.rateSettings) {
                tableRatesData =
                  quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
                tableRatesData2 =
                  quoteData.rateSettings[`${RATE_SETTING_NAMES[1]}`];
                tableRatesData3 =
                  quoteData.rateSettings[`${RATE_SETTING_NAMES[2]}`];
              }
              resolve(data);
            })
            .catch((error) => reject(error));
    });

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
          clientTier: quote.clientTier,
          vehicleYear: quote.assetAge,
          goodsType: quote.assetType,
          privateSales: quote.privateSales,
          hasMaxRate: true,
          term: quote.term
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

const getTableRatesData2 = () => {
    return tableRatesData2;
};

const getTableRatesData3 = () => {
    return tableRatesData3;
};

const getApiResponses = () => {
  return apiResponses;
};

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
  getTableRatesData: getTableRatesData,
  getTableRatesData2: getTableRatesData2,
  getTableRatesData3: getTableRatesData3,
  tableRateDataColumns: tableRateDataColumns,
  tableRateDataColumns2: tableRateDataColumns2,
  tableRateDataColumns3: tableRateDataColumns3,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
  getApiResponses: getApiResponses
};