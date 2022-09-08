import getQuotingData from "@salesforce/apex/QuotePepperMVController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
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
let tableRatesData = [];
let tableRateDataColumns = [
  { label: "Product", fieldName: "Product__c" },
  { label: "Tier", fieldName: "Tier__c", fixedWidth: 70 },
  { label: "New", fieldName: "Rate0__c", fixedWidth: 80 },
  { label: "Used 0-5 years", fieldName: "Rate1__c", fixedWidth: 140 },
  { label: "Used 6-9 years", fieldName: "Rate2__c", fixedWidth: 140 },
  { label: "Used 10+ years", fieldName: "Rate3__c", fixedWidth: 140 }
];

const LENDER_QUOTING = "Branded Consumer";

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
  ["ppsr", "PPSR__c"],
  ["clientRate", "Client_Rate__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["paymentType", "Payment__c"],
  ["applicationId", "Application__c"]
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["privateSales", "Private_Sales__c"],
  ["propertyOwner", "Client_Tier__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["baseRate", "Base_Rate__c"],
  ["maxRate", "Manual_Max_Rate__c"]
]);

const RATE_SETTING_NAMES = ["PepperRate__c"];

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
  "privateSales"
];

const createVehicleAge = (min, max) => {
  let opts = [];
  for (let index = min; index < max + 1; index++) {
    opts.push({ label: `${index}`, value: `${index}` });
  }
  return opts;
};

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: CommonOptions.fullLoanProducts,
  privateSales: CommonOptions.yesNo,
  propertyOwnerOptions: CommonOptions.yesNo,
  assetConditions: [
    { label: "New", value: "New" },
    { label: "Demo", value: "Demo" },
    { label: "Used", value: "Used" }
  ],
  creditScores: [
    { label: "4 Stars", value: "4 Stars" },
    { label: "3 Stars", value: "3 Stars" },
    { label: "2 Stars", value: "2 Stars" },
    { label: "1 Star", value: "1 Star" }
  ],
  assetTypes: [
    { label: "Car", value: "Car" },
    { label: "Motorbikes", value: "Motorbikes" },
    { label: "Caravan", value: "Caravan" },
    { label: "Motorhomes", value: "Motorhomes" }
  ],
  vehicleAges: createVehicleAge(0, 13),
  terms: CommonOptions.terms(12, 96)
};

// Reset
const reset = (recordId) => {
  let r = {
    oppId: recordId,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    assetType: calcOptions.assetTypes[0].value,
    price: null,
    deposit: null,
    netDeposit: 0.0,
    tradeIn: null,
    payoutOn: null,
    applicationFee: 395.0,
    maxApplicationFee: null,
    dof: null,
    maxDof: null,
    ppsr: 6.0,
    term: 60,
    monthlyFee: null,
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: null,
    creditScore: calcOptions.creditScores[0].value,
    privateSales: "Y",
    paymentType: "Arrears",
    assetCondition: calcOptions.assetConditions[0].value,
    propertyOwner: CommonOptions.yesNo[0].value,
    assetAge: calcOptions.vehicleAges[0].value,
    commissions: QuoteCommons.resetResults(),
    insurance: { integrity: {} }
  };
  //   r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
  return r;
};

// Load Data
const loadData = (recordId) =>
  new Promise((resolve, reject) => {
    //  const fields = Array.from(QUOTING_FIELDS.values());
    const fields = [
      ...QUOTING_FIELDS.values(),
      ...QuoteCommons.COMMISSION_FIELDS.values(),
      ...QuoteCommons.INSURANCE_FIELDS.values()
    ];
    console.log(`@@fields:`, JSON.stringify(fields, null, 2));
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

        // Rate Settings
        if (quoteData.rateSettings) {
          tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
        }
        console.log(`@@data:`, JSON.stringify(data, null, 2));
        resolve(data);
      })
      .catch((error) => reject(error));
  });

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
      const profile = quote.assetType === "Caravan" ? "CARAVAN" : "MV";
      const p = {
        lender: LENDER_QUOTING,
        productLoanType: quote.loanProduct,
        customerProfile: profile,
        clientTier: quote.propertyOwner,
        vehicleYear: quote.assetAge,
        goodsType: quote.assetType,
        privateSales: quote.privateSales,
        totalAmount: QuoteCommons.calcNetRealtimeNaf(quote),
        // totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
        clientRate: quote.clientRate,
        baseRate: quote.baseRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee
      };

      // Calculate
      console.log(`@@param:`, JSON.stringify(p, null, 2));
      calculateRepayments({
        param: p
      })
        .then((data) => {
          console.log(`@@SF:`, JSON.stringify(data, null, 2));
          // Mapping
          res.commissions = QuoteCommons.mapCommissionSObjectToLwc(
            data,
            quote.insurance
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

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const condition =
      quote.assetCondition === "New" || quote.assetCondition === "Demo"
        ? "New/Demo"
        : "Used";
    const p = {
      lender: LENDER_QUOTING,
      creditScore: quote.creditScore,
      customerProfile:
        quote.propertyOwner === "Y" ? "Asset Backed" : "Non Asset Backed",
      condition: condition,
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

const getTableRatesData = () => {
  return tableRatesData;
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