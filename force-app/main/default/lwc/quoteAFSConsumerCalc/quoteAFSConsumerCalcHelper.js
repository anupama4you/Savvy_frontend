import getQuotingData from "@salesforce/apex/QuoteAFSConsumerController.getQuotingData";
import getApplications from "@salesforce/apex/QuoteAFSConsumerController.getApplications";
import getBaseRates from "@salesforce/apex/QuoteAFSConsumerController.getBaseRates";
// import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import calculateRepayments from "@salesforce/apex/QuoteAFSConsumerController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteAFSConsumerController.save";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let applicationValue = [];

let tableRateDataColumns = [
  {
    label: "Asset Type",
    fieldName: "Asset_Type__c",
    fixedWidth: 100,
    hideDefaultActions: true
  },
  {
    label: "Condition",
    fieldName: "Condition__c",
    fixedWidth: 100,
    hideDefaultActions: true
  },
  {
    label: "Risk Grade",
    fieldName: "Risk_Grade__c",
    fixedWidth: 100,
    hideDefaultActions: true
  },
  {
    label: "% Base Rate",
    fieldName: "Base_Rate__c",
    fixedWidth: 100,
    hideDefaultActions: true
  },
  {
    label: "% Commission",
    fieldName: "Comm__c",
    fixedWidth: 100,
    hideDefaultActions: true
  }
];

const LENDER_QUOTING = "AFS Consumer";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["assetType", "Goods_type__c"],
  ["assetCondition", "Vehicle_Condition__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["netDeposit", "Net_Deposit__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["rrfee", "Registration_Fee__c"],
  ["residual", "Residual_Value__c"],
  ["term", "Term__c"],
  ["residency", "Residency__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["lvr", "LTV__c"],
  ["creditImpaired", "Bankrupt__c"],
  ["payDayEnquiries", "Pay_Day_Enquiries__c"],
  ["imports", "Has_Imports__c"],
  ["odometerReading", "Vehicles_Profile__c"],
  ["privateSales", "Private_Sales__c"],
  ["paymentType", "Payment__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["clientRate", "Client_Rate__c"]
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["privateSales", "Private_Sales__c"],
  ["clientTier", "Client_Tier__c"],
  ["baseRate", "Base_Rate__c"]
]);

const RATE_SETTING_NAMES = ["AFSRateV2__c"];

const SETTING_FIELDS = new Map([
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["rrfee", "Registration_Fee__c"],
  ["monthlyFee", "Monthly_Fee__c"]
]);

const BASE_RATE_FIELDS = [
  "loanProduct",
  "assetType",
  "residency",
  "assetAge",
  "employmentStats",
  "creditImpaired",
  "payDayEnquiries",
  "imports",
  "odometerReading",
  "assetCondition",
  "privateSales"
];

const getNetRealtimeNaf = (quote) => {
  let r = QuoteCommons.calcNetRealtimeNaf(quote);
  r += quote.rrfee;
  return r;
};

//return term months
const getTerms = () => {
  let r = [];
  const terms = CommonOptions.terms(12, 84);
  terms.forEach(function (item) {
    r.push({ label: item.label.toString(), value: item.value });
  });
  return r;
};

//return asset age options
const assetAgeOptions = (quote) => {
  var opt = [];
  let result = [...noneOpt];

  if (quote.assetCondition === "New/Demo") {
    opt.push("N/A");
  } else {
    if (quote.residency === "Property Owner") {
      opt.push("0-3 years");
      opt.push("4-5 years");
      opt.push("6-10 years");
      opt.push("11+ years");
      if (quote.assetType === "Car") {
        opt.push("Classic");
      }
    } else if (quote.residency === "Renting") {
      opt.push("0-5 years");
      opt.push("6-10 years");
      opt.push("11-20 years");
      opt.push("21+ years");
    } else {
      opt.push("0-3 years");
      opt.push("4-7 years");
      opt.push("8-10 years");
      opt.push("11-20 years");
      opt.push("21+ years");
    }
  }

  if (opt.length !== 0) {
    opt.forEach(function (rec) {
      result.push({ label: rec, value: rec });
    });
  }

  return result;
};

const noneOpt = [{ label: "-- None --", value: null }];

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  loanProducts: [
    ...noneOpt,
    { label: "Consumer Loan", value: "Consumer Loan" },
    { label: "Gold Club - Non-Property", value: "Gold Club - Non-Property" },
    // { label: "Chattel Mortgage-Full-Doc", value: "Chattel Mortgage-Full-Doc" },
    // { label: "Chattel Mortgage-Low-Doc", value: "Chattel Mortgage-Low-Doc" }
  ],
  assetTypes: [
    ...noneOpt,
    { label: "Car", value: "Car" },
    { label: "Bikes / Scooters", value: "Bikes / Scooters" },
    {
      label: "Boats / Personal Watercraft",
      value: "Boats / Personal Watercraft"
    },
    { label: "Caravans / Motorhomes", value: "Caravans / Motorhomes" }
  ],
  assetConditions: [
    ...noneOpt,
    { label: "New/Demo", value: "New/Demo" },
    { label: "Used", value: "Used" }
  ],
  terms: getTerms(),
  residency: [
    ...noneOpt,
    { label: "Property Owner", value: "Property Owner" },
    { label: "Renting", value: "Renting" },
    { label: "Living With Parents", value: "Living With Parents" },
    { label: "Employer Accommodation", value: "Employer Accommodation" },
    { label: "Boarding/Other", value: "Boarding/Other" }
  ],
  employmentStats: [...noneOpt, ...CommonOptions.yesNo],
  creditImpaireds: [...noneOpt, ...CommonOptions.yesNo],
  payDayEnqs: [
    ...noneOpt,
    { label: "Within last six months", value: "Within last six months" },
    { label: "Over 6 months ago", value: "Over 6 months ago" }
  ],
  imports: [...noneOpt, ...CommonOptions.yesNo],
  odometers: [
    ...noneOpt,
    { label: "<200,000", value: "<200,000" },
    { label: ">200,000", value: ">200,000" }
  ],
  privateSales: CommonOptions.yesNo,
  paymentTypes: CommonOptions.paymentTypes
};

// Get Application
const getApplicationRecord = (oppId) =>
  new Promise((resolve, reject) => {
    getApplications({
      opportunityId: oppId
    })
      .then((app) => {
        if (app.length !== 0) {
          let toa =
            typeof app.typeOfAsset === "undefined" ? "" : app.typeOfAsset;
          let moe =
            typeof app.modeOfEmployment === "undefined"
              ? ""
              : app.modeOfEmployment;

          applicationValue = [toa, moe];
        }

        resolve(app);
      })
      .catch((error) => reject(error));
  });

//get application type
const getApplicationType = () => {
  if (applicationValue.length !== 0 && applicationValue !== null) {
    let typeOfAsset = applicationValue[0];
    if (typeOfAsset === "Car") {
      return "Car";
    } else if (
      typeOfAsset === "Bike" ||
      typeOfAsset === "Caravan" ||
      typeOfAsset === "JetSki" ||
      typeOfAsset === "Boat"
    ) {
      return "Leisure";
    }
  }
  return null;
};

const reset = (recordId) => {
  getApplicationRecord(recordId);
  let r = {
    oppId: recordId,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[1].value,
    assetType: getApplicationType(),
    assetCondition: null,
    price: null,
    deposit: null,
    tradeIn: null,
    payoutOn: null,
    netDeposit: 0.0,
    applicationFee: null,
    dof: null,
    ppsr: null,
    rrfee: null,
    residual: 0.0,
    term: 60,
    residency: null,
    assetAge: null,
    lvr: null,
    employmentStats: calcOptions.employmentStats[2].value,
    creditImpaired: null,
    payDayEnquiries: null,
    paymentType: "Arrears",
    imports: null,
    odometerReading: null,
    privateSales: "N",
    monthlyFee: null,
    maxRate: 0.0,
    baseRate: 0.0,
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
    //  const fields = Array.from(QUOTING_FIELDS.values());
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

        resolve(data);
      })
      .catch((error) => reject(error));
  });

const getTableRatesData = (planType, assetType) => {
  let res = [];
  if (tableRatesData != null) {
    tableRatesData.forEach(function (rec) {
      if (rec.Plan__c === planType && rec.Asset_Type__c === assetType) {
        res.push(rec);
      }
    });
    //res = tableRatesData.find(rec => rec.Plan__c === planType && rec.Asset_Type__c === assetType);
  }
  return res;
};

const totalAmount = (quote) => {
  return QuoteCommons.calcTotalAmount(quote) + (quote.rrfee ? quote.rrfee : 0);
}

const calculate = (quote) =>
  new Promise((resolve, reject) => {
    let res = {
      commissions: QuoteCommons.resetResults(),
      messages: QuoteCommons.resetMessage()
    };

    console.log('data before Controller: ', JSON.stringify(quote, null, 2));

    // Validate quote
    res.messages = Validations.validate(quote, res.messages, applicationValue);
    if (res.messages && res.messages.errors.length > 0) {
      reject(res);
    } else {
      // Prepare params
      const p = {
        lender: LENDER_QUOTING,
        totalAmount: totalAmount(quote),
        // totalAmount: QuoteCommons.calcTotalAmount(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
        clientRate: quote.clientRate,
        baseRate: quote.baseRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residual,
        residency: quote.residency,
        condition: quote.assetCondition,
        vehicleYear: quote.assetAge,
        assetType: quote.assetType,
        productLoanType: quote.loanProduct,
        netDeposit: quote.netDeposit,
        vehiclePrice: quote.price
      };

      // Calculate
      calculateRepayments({
        param: p,
        insuranceParam: quote.insurance
      })
        .then((data) => {
          console.log('data after Controller: ', JSON.stringify(data, null, 2));
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
  });

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    console.log(`@@getMyBaseRates:`, JSON.stringify(quote, null, 2));
    const p = {
      lender: LENDER_QUOTING,
      productLoanType: quote.loanProduct,
      clientTier: quote.clientTier,
      vehicleYear: quote.assetAge,
      assetType: quote.assetType,
      ltv: quote.lvr,
      hasMaxRate: true,
      clientRate: quote.clientRate,
      condition: quote.assetCondition,
      residency: quote.residency,
      vehiclePrice: quote.price,
      bankrupt: quote.creditImpaired,
      riskGrade: quote.payDayEnquiries,
      hasImports: quote.imports,
      vehiclesProfile: quote.odometerReading,
      term: quote.term,
      privateSales: quote.privateSales,
      customerProfile: quote.employmentStats,
      netDeposit: quote.netDeposit
    };

    getBaseRates({
      param: p
    })
      .then((rates) => {
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
      save({
        param: QuoteCommons.mapLWCToSObject(
          param,
          recordId,
          LENDER_QUOTING,
          FIELDS_MAPPING_FOR_APEX
        ),
        approvalType: approvalType,
        casual: param.employmentStats
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
  assetAgeOptions: assetAgeOptions,
  calculate: calculate,
  load: loadData,
  reset: reset,
  baseRates: getMyBaseRates,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  getTableRatesData: getTableRatesData,
  tableRateDataColumns: tableRateDataColumns,
  getNetRealtimeNaf: getNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail
};