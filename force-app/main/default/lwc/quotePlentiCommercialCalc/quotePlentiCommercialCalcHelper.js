import getQuotingData from "@salesforce/apex/QuoteManager.getQuotingData";
import getBaseRatesManual from "@salesforce/apex/QuoteManager.getBaseRatesManual";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuotePlentiCommController.save";
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
let tableRateDataColumns = [
  { label: "Profile", fieldName: "Profile__c", type: "text" },
  { label: "Tier", fieldName: "Tier__c", type: "text" },
  { label: "(2022 - 2021)", fieldName: "Rate1__c", type: "text" },
  { label: "(2020 - 2019)", fieldName: "Rate2__c", type: "text" },
  { label: "(2018 - 2015)", fieldName: "Rate3__c", type: "text" },
  { label: "(2014 - 2010)", fieldName: "Rate4__c", type: "text" }
];

const LENDER_QUOTING = "Plenti Commercial";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["assetType", "Goods_type__c"],
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
  ["lvr", "LTV__c"],
  ["paymentType", "Payment__c"],
  ["clientRate", "Client_Rate__c"],
  ["applicationId", "Application__c"],
  ["privateSales", "Private_Sales__c"],
  ["clientTier", "Client_Tier__c"],
  ["customerProfile", "Customer_Profile__c"],
  ["vehicleCondition", "Vehicle_Condition__c"],
  ["greenCar", "Green_Car__c"],
  ["vehicleYear", "Vehicle_Age__c"],
  ["leaseAgreement", "Lease_Agreement__c"],
  ["brokeragePer", "Brokerage__c"],
  ["baseRateManual", "Extra_Value_1__c"],
  ["abnLength", "ABN__c"],
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["privateSales", "Private_Sales__c"],
  ["clientTier", "Client_Tier__c"],
  ["baseRate", "Base_Rate__c"],
  ["maxRate", "Manual_Max_Rate__c"]
]);

const RATE_SETTING_NAMES = ["RateSetterRate__c"];

const SETTING_FIELDS = new Map([
  ["monthlyFee", "Monthly_Fee__c"],
  ["ppsr", "PPSR__c"],
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "Max_DOF__c"]
]);

const BASE_RATE_FIELDS = [
  "assetType",
  "clientTier",
  "vehicleYear",
  "customerProfile",
  "vehicleCondition",
  "greenCar",
  "term",
  "brokeragePer",
  "baseRateManual"
];

const getBaseAmountPmtInclBrokerageCalc = (quote) => {
  let naf = QuoteCommons.calcNetRealtimeNaf(quote);
  let brokerage = quote.brokeragePer > 0 ? quote.brokeragePer : 0;
  console.log('get PMT...', naf + (naf * (brokerage / 100)));
  return naf + (naf * (brokerage / 100));
};

const CALC_FEES_FIELDS = [
  "privateSales"
];

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
      const p = {
        lender: LENDER_QUOTING,
        amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        // totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        // totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
        clientRate: quote.clientRate,
        baseRate: quote.baseRateManual > 0 ? quote.baseRateManual : quote.baseRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residual,
        customerProfile: quote.customerProfile,
        clientTier: quote.clientTier,
        productLoanType: quote.loanProduct,
        vehicleYear: quote.vehicleYear,
        privateSales: quote.privateSales,
        goodsType: quote.assetType,
        amountBaseComm: quote.price - QuoteCommons.calcNetDeposit(quote),
        commRate: quote.commRate,
        brokeragePer: quote.brokeragePer
      };
      // Calculate
      console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
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
          // Validate for results
          res.messages = Validations.validatePostCalculation(res.commissions, res.messages);
          resolve(res);
        })
        .catch((error) => {
          let errMsg = res.messages.errors;
          if (!errMsg) {
            errMsg = new Array();
          }
          errMsg.push(["calculation", error]);
          res.messages.errors = errMsg;
          reject(res);
        });
    }
  });

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
const getTerms = (min, max, interval) => {
  let r = [];
  for (let i = min; i < max + interval;) {
    r.push({ label: i.toString(), value: i });
    i += interval;
  }
  return r;
};

const calcOptions = {
  loanTypes: [
    { label: "Purchase", value: "Purchase" },
    { label: "Refinance", value: "Refinance" }
  ],
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: [
    { label: "Chattel Mortgage-Full-Doc", value: "Chattel Mortgage-Full-Doc" },
    { label: "Chattel Mortgage-Low-Doc", value: "Chattel Mortgage-Low-Doc" },
    { label: "Car Lease-Full-Doc", value: "Car Lease-Full-Doc" },
    { label: "Car Lease-Low-Doc", value: "Car Lease-Low-Doc" },
  ],
  assetTypes: [
    { label: "Car", value: "Car" },
    { label: "Caravan", value: "Caravan" }
  ],
  terms: [
    { label: '36', value: 36 },
    { label: '60', value: 60 },
    { label: '84', value: 84 }
  ],
  customerProfiles: [
    { label: "Property Owner", value: "Property Owner" },
    { label: "Non Property Owner", value: "Non Property Owner" }
  ],
  clientTiers: [
    { label: "Tier 1", value: "Tier 1" },
    { label: "Tier 2", value: "Tier 2" },
    { label: "Tier 3", value: "Tier 3" }
  ],
  vehicleConditions: [
    { label: "New", value: "new" },
    { label: "Demo", value: "demo" },
    { label: "Used", value: "used" }],
  greenCars: CommonOptions.yesNo,
  vehicleYears: getVehicleYear(),
  privateSales: CommonOptions.yesNo,
  plentiAPIUsers: CommonOptions.apiUsers,
  abnLengths: [
    { label: "ABN/GST > 2 years", value: "> 2 years" },
    { label: "ABN >2 yrs />1 year", value: "> 2 yrs / >1 year" },
    { label: "ABN >1 yr/Unreg >1 yr", value: "> 1 yr / Unreg > 1 yr" }]
};


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
    applicationFee: null,
    maxApplicationFee: null,
    dof: null,
    maxDof: null,
    ppsr: null,
    residual: 0.0,
    monthlyFee: null,
    term: 60,
    customerProfile: null,
    clientTier: null,
    vehicleCondition: null,
    greenCar: null,
    vehicleYear: null,
    privateSales: 'N',
    paymentType: "Arrears",
    maxRate: 0.0,
    abnLength: calcOptions.abnLengths[0].value,
    baseRate: 0.0,
    clientRate: 0.0,
    commissions: QuoteCommons.resetResults(),
    brokeragePer: 1,
    baseRateManual: 0.0,
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
        // API  responses
        apiResponses = quoteData.apiResponses;
        // Rate Settings
        if (quoteData.rateSettings) {
          tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
          console.log("tableRatesData==>" + JSON.stringify(tableRatesData));
        }
        // Validate for results
        data.messages = Validations.validatePostLoading(data);

        resolve(data);
      })
      .catch((error) => reject(error));
  });

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    console.log('==> getMyBaseRates params quote ', JSON.stringify(quote));
    const p = {
      lender: LENDER_QUOTING,
      assetType: quote.assetType,
      clientTier: quote.clientTier,
      vehicleYear: quote.vehicleYear,
      customerProfile: quote.customerProfile,
      condition: quote.vehicleCondition,
      greenCar: quote.greenCar,
      term: quote.term,
      brokeragePer: quote.brokeragePer,
      totalAmount: QuoteCommons.calcNetRealtimeNaf(quote),
      residualValue: quote.residual,
      paymentType: quote.paymentType,
      baseRate:
        quote.baseRateManual > 0 ? quote.baseRateManual : quote.baseRate,
      amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote)
    };
    console.log('==> getMyBaseRates param ', JSON.stringify(p, null, 2));
    getBaseRatesManual({
      param: p,
      baseRateManual: quote.baseRateManual
    })
      .then((rates) => {
        console.log('==> getMyBaseRates rates ', JSON.stringify(rates));
        resolve(rates);
      })
      .catch((error) => reject(error));
  });

  const getApiResponses = () => {
    return apiResponses;
  };

//get fees calculations
const calcFees = (quote) => {
  if (quote.privateSales == 'Y') {
    return lenderSettings.Application_Fee_Private__c;
  } else {
    return lenderSettings.Application_Fee__c;
  }
};


const getTableRatesData = () => {
  return tableRatesData;
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
  baseRates: getMyBaseRates,
  calcFees,
  calcFees,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  CALC_FEES_FIELDS: CALC_FEES_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  tableRateDataColumns: tableRateDataColumns,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
  getApiResponses: getApiResponses
};