import getQuotingData from "@salesforce/apex/QuoteBrandedConsumerController.getQuotingData";
import getCreditScore from "@salesforce/apex/QuoteBrandedConsumerController.getCreditScore";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteBrandedConsumerController.save";
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
  { label: "Vehicle Condition", fieldName: "Condition__c" },
  { label: "Profile", fieldName: "Profile__c" },
  { label: "Ranking", fieldName: "Credit_Score__c" },
  { label: "Credit Score", fieldName: "Credit__c" },
  { label: "Min Rate", fieldName: "Rate__c" },
  { label: "Max Rate", fieldName: "Rate2__c" }
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
  ["applicationId", "Application__c"],
  ["assetCondition", "Vehicle_Condition__c"],
  ["privateSales", "Private_Sales__c"],
  ["propertyOwner", "Client_Tier__c"],
  ["assetAge", "Vehicle_Age__c"]
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["baseRate", "Base_Rate__c"],
  ["maxRate", "Manual_Max_Rate__c"]
]);

const RATE_SETTING_NAMES = ["Branded_Consumer_Rate__c"];

const SETTING_FIELDS = new Map([
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["monthlyFee", "Monthly_Fee__c"]
]);

const BASE_RATE_FIELDS = ["propertyOwner", "assetCondition", "creditScore"];

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
    privateSales: "Y",
    paymentType: "Arrears",
    creditScore: null,
    assetCondition: calcOptions.assetConditions[0].value,
    propertyOwner: CommonOptions.yesNo[0].value,
    assetAge: calcOptions.vehicleAges[0].value,
    commissions: QuoteCommons.resetResults(),
    insurance: { integrity: {} }
  };
  //   r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
  return r;
};

const rankingMapper = (rank) => {
  let credit = "Less than 450";
  if (rank === "4 Stars") {
    credit = "751 - 1,200";
  } else if (rank === "3 Stars") {
    credit = "551 - 750";
  } else if (rank === "2 Stars") {
    credit = "451 - 550";
  }
  return credit;
};

const tableRatesHandler = (rates) => {
  let result = [];
  result = rates.map((rate) => {
    rate.Rate2__c = rate.Rate__c + 2;
    rate.Credit__c = rankingMapper(rate.Credit_Score__c);
    return rate;
  });
  //   console.log("table rate handler >> ", JSON.stringify(rates, null, 2));
  return result;
};

// Load Data
const loadData = (recordId) =>
  new Promise((resolve, reject) => {
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
          tableRatesData = tableRatesHandler(
            quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`]
          );
        }
        console.log(`@@data:`, JSON.stringify(data, null, 2));
        resolve(data);
      })
      .catch((error) => reject(error));
  });

const calculate = (quote) =>
  new Promise((resolve, reject) => {
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
      const condition =
        quote.assetCondition === "New" || quote.assetCondition === "Demo"
          ? "New/Demo"
          : "Used";
      const p = {
        lender: LENDER_QUOTING,
        customerProfile:
          quote.propertyOwner === "Y" ? "Asset Backed" : "Non Asset Backed",
        condition: condition,
        productLoanType: quote.loanProduct,
        clientTier: quote.propertyOwner,
        vehicleYear: quote.assetAge,
        goodsType: quote.assetType,
        privateSales: quote.privateSales,
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceIncome(quote),
        // totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
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

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const condition =
      quote.assetCondition === "New" || quote.assetCondition === "Demo"
        ? "New/Demo"
        : "Used";
    const p = {
      lender: LENDER_QUOTING,
      vedascore: quote.creditScore,
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

const getCreditScoreValue = async (oppId) => {
  const creditScore = await getCreditScore({
    oppId: oppId
  });
  return creditScore;
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
      reject(new Error("QUOTE OR RECORD_ID EMPTY in SaveQuoting function"));
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
  getCreditScore: getCreditScoreValue,
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