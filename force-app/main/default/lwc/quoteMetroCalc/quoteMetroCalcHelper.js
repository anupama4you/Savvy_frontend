import getQuotingData from "@salesforce/apex/QuoteMetroController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteMetroController.save";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let applicationFee = 0.0;
let baseR = 0.0;
let planOpts = [];
let lenderSettings = {};
let tableRatesData = {};
let tableRateDataColumnsForPlanOptions = [
  { label: "Plan", fieldName: "Name" },
  { label: "Application Fee", fieldName: "Application_Fee__c" },
  { label: "DOF", fieldName: "DOF__c" },
  { label: "Brokerage", fieldName: "Brokerage__c" },
  { label: "Extra Fee", fieldName: "Extra_Rate__c" }
];
let tableRateDataColumns = [
  { label: "Description", fieldName: "Description__c" },
  { label: "60 Months", fieldName: "X60_Months__c" },
  { label: "48 Months", fieldName: "X48_Months__c" },
  { label: "36 Months", fieldName: "X36_Months__c" },
  { label: "24 Months", fieldName: "X24_Months__c" }
];

const LENDER_QUOTING = "Metro";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["assetType", "Loan_Facility_Type__c"],
  ["planOptions", "Client_Tier__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["netDeposit", "Net_Deposit__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["residual", "Residual_Value__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["vehicleCondition", "Condition__c"],
  ["greenCar", "Green_Car__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["privateSales", "Private_Sales__c"],
  ["salesBacksPurchased", "Sale_Backs_Purchased__c"],
  ["paymentType", "Payment__c"],
  ["brokerage", "Brokerage__c"],
  ["baseRate", "Base_Rate__c"],
  ["clientRate", "Client_Rate__c"],
  ["applicationId", "Application__c"]
]);

const FIELDS_MAPPING_FOR_APEX = new Map([...QUOTING_FIELDS, ["Id", "Id"]]);

const RATE_SETTING_NAMES = [
  "MetroPlanOption__c",
  "PassengerAndCommercialRates",
  "HeavyCommercialRates",
  "WhelledPlantEquipmentRates"
];

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
  "assetType",
  "loanType",
  // naf
  "price",
  "applicationFee",
  "dof",
  "ppsr",
  "netDeposit",
  "deposit",
  // - end naf
  "term",
  "assetAge",
  "brokerage",
  "privateSales",
  "salesBacksPurchased",
  "planOptions",
  "vehicleCondition",
  "greenCar",
  "residual"
];

const RISK_GRADE_FIELDS = ["propertyOwner", "creditScore", ...BASE_RATE_FIELDS];

const calculate = (quote) =>
  new Promise((resolve, reject) => {
    console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
    let res = {
      commissions: QuoteCommons.resetResults(),
      messages: QuoteCommons.resetMessage()
    };
    // Validate quote
    res.messages = Validations.validate(quote, res.messages);
    console.log(res.messages);
    if (res.messages && res.messages.errors.length > 0) {
      console.log(`res.message === ${JSON.stringify(res, null, 2)}`);
      reject(res);
    } else {
      // Prepare params
      const p = {
        lender: LENDER_QUOTING,
        productLoanType: quote.loanProduct,
        privateSales: quote.privateSales,
        totalAmount: calcNetRealtimeNaf(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        clientRate: quote.clientRate,
        baseRate: quote.baseRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residual,
        brokeragePer: quote.brokerage
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
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: CommonOptions.fullLoanProducts,
  privateSales: [{ label: "-- None --", value: null }, ...CommonOptions.yesNo],
  assetTypes: [
    {
      label: "Passenger and Commercial Vehicles",
      value: "Passenger and Commercial Vehicles"
    },
    { label: "Heavy Commercial Vehicles", value: "Heavy Commercial Vehicles" },
    { label: "Wheeled Plant & Equipment", value: "Wheeled Plant & Equipment" }
  ],
  planOptions: [
    { label: "-- None --", value: null },
    { label: "Option 1", value: "Option 1" },
    { label: "Option 2", value: "Option 2" },
    { label: "Option 3", value: "Option 3" }
  ],
  vehicleCondition: [
    { label: "-- None --", value: null },
    { label: "New/Demo", value: "New/Demo" },
    { label: "Used", value: "Used" }
  ],
  greenCar: [{ label: "-- None --", value: null }, ...CommonOptions.yesNo],
  salesBacksPurchased: [
    { label: "-- None --", value: null },
    ...CommonOptions.yesNo
  ],
  terms: CommonOptions.terms(12, 72)
};

// Reset
const reset = (recordId) => {
  let r = {
    oppId: recordId,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    assetType: calcOptions.assetTypes[0].value,
    planOptions: calcOptions.planOptions[1].value,
    price: null,
    deposit: null,
    tradeIn: null,
    payoutOn: null,
    netDeposit: 0.0,
    applicationFee: 0.0,
    maxApplicationFee: 0.0,
    dof: 0.0,
    ppsr: 0.0,
    residual: null,
    monthlyFee: null,
    term: 60,
    vehicleCondition: null,
    greenCar: null,
    assetAge: 0,
    privateSales: calcOptions.privateSales[2].value,
    salesBacksPurchased: calcOptions.privateSales[2].value,
    paymentType: "Arrears",
    brokerage: 0.0,
    baseRate: 0.0,
    clientRate: 0.0,
    commissions: QuoteCommons.resetResults()
  };
  //   console.log("before mapping: " + JSON.stringify(r, null, 2));
  r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
  r.applicationFee = r.maxApplicationFee = applicationFee;
  return r;
};

// Load Data
const loadData = (recordId) =>
  new Promise((resolve, reject) => {
    try {
      const fields = [
        ...QUOTING_FIELDS.values(),
        ...QuoteCommons.COMMISSION_FIELDS.values()
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
            tableRatesData = quoteData.rateSettings;
            planOpts = tableRatesData["MetroPlanOption__c"];
          }
          const rates = resetLenderSetting(data.planOptions);
          data.applicationFee = data.maxApplicationFee = rates.applicationFee;
          data.dof = data.maxDof = rates.dof;
          data.assetAge = parseInt(data.assetAge);
          console.log(`@@data:`, JSON.stringify(data, null, 2));
          resolve(data);
        })
        .catch((error) => reject(error));
    } catch (error) {
      console.error(error);
    }
  });

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const p = {
      lender: LENDER_QUOTING,
      loanTypeDetail: quote.assetType,
      totalAmount: calcNetRealtimeNaf(quote),
      term: quote.term,
      carAge: quote.assetAge,
      brokeragePer: quote.brokerage,
      privateSales: quote.privateSales,
      saleBacksPurchased: quote.salesBacksPurchased,
      clientTier: quote.planOptions,
      condition: quote.vehicleCondition,
      greenCar: quote.greenCar,
      hasMaxRate: false
    };
    console.log(`getMyBaseRates...`, JSON.stringify(p, null, 2));

    // if (!isBaseRateParamsCompleted(p)) resolve({ baseRate: 0 });
    getBaseRates({
      param: p
    })
      .then((rates) => {
        baseR = rates.baseRate;
        rates.clientRate = calcClientRate(quote);
        console.log(`@@SF:`, JSON.stringify(rates, null, 2));
        resolve(rates);
      })
      .catch((error) => reject(error));
  });

// NAF
const calcNetRealtimeNaf = (quote) => QuoteCommons.calcNetRealtimeNaf(quote);

/**
 * - lee
 * calculate lender setting application fee and dof when select options
 * @param {String} selectedOption
 * @returns { applicationFee: number, dof: number }
 */
const resetLenderSetting = (selectedOption) => {
  let rates = { applicationFee: 0, dof: 0 };
  for (const opt of planOpts) {
    if (opt.Name === selectedOption) {
      rates.applicationFee = opt.Application_Fee__c;
      rates.dof = opt.DOF__c;
    }
  }
  console.log("reset lender setting", rates);
  return rates;
};

const getTableRatesData = () => {
  return tableRatesData;
};

/**
 * - lee -> Calculate client rate
 * @param {Object} quote
 * @returns {number}
 */
const calcClientRate = (quote) => {
  let clientRate = 0.0;
  try {
    const amuntPmt = getBaseAmountPmtInclBrokerageCalc(quote);
    const baseRate = baseR;
    const fv = quote.residual || 0.0;
    console.log(
      `baserate: ${JSON.stringify(baseRate, null, 2)}, amuntPmt : ${amuntPmt}`
    );
    if (quote.term > 0 && baseRate > 0 && amuntPmt > 0) {
      const type = "Advance" === quote.paymentType ? 1 : 0;
      const pmt = fu.pmt2(
        baseRate / 100 / 12,
        quote.term,
        amuntPmt * -1,
        fv,
        type
      );
      console.log("pmt          >> ", pmt);
      clientRate =
        fu.rate2(
          quote.term,
          pmt * -1,
          calcNetRealtimeNaf(quote),
          fv * -1,
          type
        ) *
        12 *
        100;
    }
    console.log("client rate:   >> ", clientRate);
  } catch (error) {
    console.error(error);
  }
  return Number.parseFloat(clientRate.toFixed(2));
};

const getBaseAmountPmtInclBrokerageCalc = (quote) => {
  let r = calcNetRealtimeNaf(quote);
  return quote.brokerage ? (r += ((r * quote.brokerage) / 100) * 1.025) : r;
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
    param.assetAge = param.assetAge.toString();
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
  calcClientRate: calcClientRate,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  RISK_GRADE_FIELDS: RISK_GRADE_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  tableRateDataColumns: tableRateDataColumns,
  tableRateDataColumnsForPlanOptions: tableRateDataColumnsForPlanOptions,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
  getNetRealtimeNaf: calcNetRealtimeNaf,
  resetLenderSetting: resetLenderSetting
};