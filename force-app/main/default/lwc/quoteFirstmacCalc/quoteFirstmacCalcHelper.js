import getQuotingData from "@salesforce/apex/QuoteFirstmacController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteFirstmacController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteFirstmacController.save";
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
  { label: "Category", fieldName: "Category__c", fixedWidth: 140, hideDefaultActions: true },
  { label: "Home Owner", fieldName: "Home_Owner__c", fixedWidth: 170, hideDefaultActions: true },
  { label: "Rate", fieldName: "Rate__c", fixedWidth: 130, hideDefaultActions: true },
  { label: "Base Rate", fieldName: "Value__c", fixedWidth: 130, hideDefaultActions: true },
  { label: "Max Rate", fieldName: "Max_Rate__c", fixedWidth: 130, hideDefaultActions: true },
  { label: "Vehicle Year", fieldName: "Vehicle_Year__c", fixedWidth: 160, hideDefaultActions: true },
  { label: "Rate Type", fieldName: "Rate_Type__c", fixedWidth: 140, hideDefaultActions: true }
];

const LENDER_QUOTING = "Firstmac";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["netDeposit", "Net_Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["residual", "Residual_Value__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["category", "Category_Type__c"],
  ["homeOwner", "Residency__c"],
  ["loanTypeRD", "Loan_Facility_Type__c"],
  ["interestType", "Customer_Profile__c"],
  ["vehicleYear", "Vehicle_Age__c"],
  ["paymentType", "Payment__c"],
  ["clientRate", "Client_Rate__c"],
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["privateSales", "Private_Sales__c"],
  ["clientTier", "Client_Tier__c"],
  ["baseRate", "Base_Rate__c"],
]);

const RATE_SETTING_NAMES = ["FirstmacRate__c"];

const SETTING_FIELDS = new Map([
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["monthlyFee", "Monthly_Fee__c"]
]);

const BASE_RATE_FIELDS = [
  "category",
  "homeOwner",
  "loanTypeRD",
  "interestType"
];

const currentYear = (new Date()).getFullYear();

//return vehicle year
const getVehicleYear = () => {
  let r = [];
  for (let i = 0; i < 13; i++) {
    let res = currentYear - i;
    r.push({ label: res.toString(), value: res.toString() });
  }
  return r;
};

//return term months
const getTerms = () => {
  let r = [];
  const terms = CommonOptions.terms(36, 72);
  terms.forEach(function (item) {
    r.push({ label: item.label.toString(), value: item.value });
  });
  return r;
};

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  loanProducts: [{ label: "Consumer Loan", value: "Consumer Loan" }],
  terms: getTerms(),
  categories: [
    { label: "Standard", value: "Standard" },
    { label: "Edge", value: "Edge" }
  ],
  homeOwners: CommonOptions.yesNo,
  loanTypeRDs: [
    { label: "New Green Car", value: "New Green Car" },
    { label: "New / Demo", value: "New / Demo" },
    { label: "Used < 3 years", value: "Used < 3 years" },
    { label: "Used 4-5 years", value: "Used 4-5 years" },
    { label: "Used 6-7 years", value: "Used 6-7 years" },
    { label: "Used 8-12 years", value: "Used 8-12 years" }
  ],
  interestTypes: [
    { label: "Fixed", value: "Fixed" },
    { label: "Variable", value: "Variable" }
  ],
  vehicleYears: getVehicleYear(),
  paymentTypes: CommonOptions.paymentTypes
};

const reset = (recordId) => {
  console.log('==> helper reset');
  let r = {
    oppId: recordId,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    price: 0.0,
    deposit: 0.0,
    tradeIn: 0.0,
    payoutOn: 0.0,
    netDeposit: 0.0,
    residual: 0.0,
    term: 60,
    category: null,
    homeOwner: "N",
    loanTypeRD: null,
    interestType: "Fixed",
    vehicleYear: null,
    paymentType: "Arrears",
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: 0.0,
    commissions: QuoteCommons.resetResults(),

  };
  r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
  return r;
};

// Get Base Rates
const getMyBaseRates = (quote, resetBP) =>
  new Promise((resolve, reject) => {

    const p = {
      lender: LENDER_QUOTING,
      hasMaxRate: true,
      customerProfile: quote.category,
      residency: quote.homeOwner,
      loanTypeDetail: quote.loanTypeRD,
      interestType: quote.interestType
    };

    getBaseRates({
      param: p,
      resetBrokerage: resetBP
    })
      .then((rates) => {
        resolve(rates);
      })
      .catch((error) => reject(error));
  });

// Load Data
const loadData = (recordId) =>
  new Promise((resolve, reject) => {
    //  const fields = Array.from(QUOTING_FIELDS.values());
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
        console.log('quoteData***: ', JSON.stringify(quoteData, null, 2));
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

        console.log('data***: ', JSON.stringify(data, null, 2));
        resolve(data);

      })
      .catch((error) => reject(error));
  });

const getTableRatesData = () => {
  return tableRatesData;
};

const calculate = (quote) =>
  new Promise((resolve, reject) => {

    let res = {
      commissions: QuoteCommons.resetResults(),
      messages: QuoteCommons.resetMessage()
    };

    let naf = QuoteCommons.calcNetRealtimeNaf(quote);
    // Validate quote
    res.messages = Validations.validate(quote, naf, res.messages);
    if (res.messages && res.messages.errors.length > 0) {

      reject(res);
    } else {

      // Prepare params
      const p = {
        lender: LENDER_QUOTING,
        totalAmount: naf,
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
        baseRate: quote.baseRate,
        maxRate: quote.maxRate,
        clientRate: quote.clientRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residual
      };

      // Calculate
      calculateRepayments({
        param: p
      })
        .then((data) => {

          // Mapping
          res.commissions = QuoteCommons.mapCommissionSObjectToLwc(
            data,
            quote.insurance
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

export const CalHelper = {
  options: calcOptions,
  calculate: calculate,
  load: loadData,
  reset: reset,
  baseRates: getMyBaseRates,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  tableRateDataColumns: tableRateDataColumns,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail
};