import getQuotingData from "@salesforce/apex/QuoteBrandedCommercialCalcController.getQuotingData";
//import getDefaultBrokerage from "@salesforce/apex/QuoteGreenLightController.getDefaultBrokeragePercentage";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import getCalcFees from "@salesforce/apex/QuoteManager.getFees";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
//import getRateSetterRate from "@salesforce/apex/QuoteManager.getRateSetterRate";
import save from "@salesforce/apex/QuoteBrandedCommercialCalcController.save";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let gstOptions;
let tableRateDataColumns = [
  { label: "", fieldName: "Col_1", type: "text" },
  { label: "36 Months", fieldName: "Col_2", type: "text" },
  { label: "48 Months", fieldName: "Col_3", type: "text" },
  { label: "60 Months", fieldName: "Col_4", type: "text" },
];

const LENDER_QUOTING = "Branded Commercial";

// - TODO: need to map more fields
const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["goodsType", "Goods_type__c"],
  ["assetYear", "Vehicle_Age__c"],
  ["productType", "Loan_Facility_Type__c"],
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
  ["gst", "GST__c"],
  ["residualPer", "Residual_Value_Percentage__c"],
  ["residualValue", "Residual_Value__c"],
  ["ltv", "LTV__c"],
  ["brokeragePer", "Brokerage__c"],
  ["propertyOwner", "Customer_Profile__c"],
  ["privateSales", "Private_Sales__c"],
  ["assetCondition", "Vehicle_Condition__c"],
]);

const RESIDUAL_VALUE_FIELDS = [
  "residualValue",
  "residualPer",
  "typeValue",
  "price",
  "deposit",
  "tradeIn",
  "payoutOn"
];

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["privateSales", "Private_Sales__c"],
  ["baseRate", "Base_Rate__c"]
]);

const RATE_SETTING_NAMES = ["Branded_Commercial_Rate__c"];

const SETTING_FIELDS = new Map([
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["monthlyFee", "Monthly_Fee__c"]
]);

const BASE_RATE_FIELDS = [
  "propertyOwner",
  "assetCondition"
];

const CALC_FEES_FIELDS = [
  "price",
  "deposit",
  "tradeIn",
  "payoutOn",
  "applicationFee",
  "dof",
  "ppsr",
  "residualValue"
];

const CLIENT_RATE_FIELDS = [
  "brokeragePercentage",
  "baseRate",
  "term",
  "paymentType"
];

const getBaseAmountPmtInclBrokerageCalc = (quote) => {

  let r = QuoteCommons.calcNetRealtimeNaf(quote);
  if (quote.brokeragePer != null && quote.brokeragePer != 0) {
    r += (r * (quote.brokeragePer / 100));
  }
  console.log('getBaseAmountPmtInclBrokerageCalc==>' + r);
  return r;
}

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
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        // totalInsurance: QuoteCommons.calcTotalInsuranceIncome(quote),
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
}

// dynamic dates generation
const getAssetYears = () => {
  const currentYear = new Date().getFullYear();
  let r = [];
  for (let i = (currentYear - 13); i <= currentYear; i++) {
    r.push({ label: i.toString(), value: i.toString() });
  }
  return r;
}

// gst options changed according to the property owner
const getGstOptions = (quote) => {
  if (quote.propertyOwner === "Y") {
    return [
      { label: "--None--", value: "" },
      { label: "ABN/GST > 1 year", value: "ABN/GST > 1 year" },
      { label: "ABN/GST > 2 years", value: "ABN/GST > 2 years" }]
  } else {
    return [
      { label: "--None--", value: "" },
      { label: "ABN > 2 yrs/GST > 1year", value: "ABN > 2 yrs/GST > 1year" },
      { label: "ABN/GST > 3 years", value: "ABN/GST > 3 years" }]
  }
}

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: [
    { label: "Chattel Mortgage-Full-Doc", value: "Chattel Mortgage-Full-Doc" },
    { label: "Chattel Mortgage-Low-Doc", value: "Chattel Mortgage-Low-Doc" },
    { label: "Car Lease-Full-Doc", value: "Car Lease-Full-Doc" },
    { label: "Car Lease-Low-Doc", value: "Car Lease-Low-Doc" },
  ],
  goodsTypes: [
    { label: "Motor Vehicle", value: "Motor Vehicle" },
    { label: "Caravan", value: "Caravan" },
    { label: "Motorbikes", value: "Motorbikes" },
    { label: "Motorhomes", value: "Motorhomes" },
  ],
  abns: [
    { label: "> 1 year", value: "> 1 year" },
    { label: "> 2 year", value: "> 2 year" },
    { label: "> 3 year", value: "> 3 year" },
  ],
  assetConditions: [
    { label: "New", value: "New" },
    { label: "Demo", value: "Demo" },
    { label: "Used", value: "Used" }
  ],
  assetYears: getAssetYears(),
  terms: CommonOptions.terms(12, 60),
  profiles: CommonOptions.profiles,
  vehicleConditions: CommonOptions.vehicleConditions,
  privateSales: CommonOptions.yesNo,
  propertyOwners: CommonOptions.yesNo,
  typeValues: [
    { label: "Percentage", value: "Percentage" },
    { label: "Value", value: "Value" },
  ],
  productTypes: [
    { label: "Lite", value: "Lite" },
    { label: "Express", value: "Express" },
  ],
};


const reset = (recordId) => {
  let r = {
    oppId: recordId,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    goodsType: calcOptions.goodsTypes[0].value,
    price: null,
    deposit: null,
    netDeposit: 0.0,
    tradeIn: null,
    payoutOn: null,
    applicationFee: 395.0,
    maxApplicationFee: null,
    dof: null,
    maxDof: 0.0,
    ppsr: 6.0,
    residual: 0.0,
    monthlyFee: null,
    term: 60,
    customerProfile: null,
    vehicleCondition: null,
    privateSales: "N",
    propertyOwner: "N",
    paymentType: "Advance",
    assetCondition: calcOptions.assetConditions[0].value,
    assetYear: calcOptions.assetYears[0].value,
    maxRate: 0.0,
    baseRate: 0.0,
    clientRate: 0.0,
    commissions: QuoteCommons.resetResults(),
    brokeragePer: 4,
    typeValue: "Value",
    ltv: "0",
    gst: gstOptions ? gstOptions[0].value : "",
    insurance: { integrity: {} }
  };
  r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
  return r;
};

// Load Data
const loadData = (recordId) =>
  new Promise((resolve, reject) => {
    //console.log('helper recordId ', recordId);
    //  const fields = Array.from(QUOTING_FIELDS.values());
    const fields = [
      ...QUOTING_FIELDS.values(),
      ...QuoteCommons.COMMISSION_FIELDS.values(),
      ...QuoteCommons.INSURANCE_FIELDS.values()
    ];
    // console.log(`@@fields:`, JSON.stringify(fields, null, 2));
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
        //console.log(`quoteData:`, JSON.stringify(quoteData, null, 10));
        //console.log(`quoted.rateSettings:`, JSON.stringify(quoteData.rateSettings));
        // Rate Settings
        if (quoteData.rateSettings) {
          // tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
          // console.log('tableRatesData==>' + JSON.stringify(tableRatesData));
        }
        //console.log(`@@data:`, JSON.stringify(data, null, 2));
        // data.typeValue = "Value";
        resolve(data);

      })
      .catch((error) => reject(error));
  });

const getResidualValue = (quote) => {
  const res = ((quote.price - QuoteCommons.calcNetDeposit(quote)) * quote.residualPer) / 100;
  return res.toFixed(2);
};

const getResidualPercentage = (quote) => {
  const res = (quote.residualValue / (quote.price - QuoteCommons.calcNetDeposit(quote))) * 100;
  return res.toFixed(2);
  // return (quote.residualValue / (quote.price - QuoteCommons.calcNetDeposit(quote))) * 100;
};

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const condition =
      quote.assetCondition === "New" || quote.assetCondition === "Demo"
        ? "New/Demo"
        : "Used";
    // maximum margin above base is 6.00%
    const commRate = 6;
    console.log('==> getMyBaseRates params quote ', JSON.stringify(quote, null, 2));
    const p = {
      lender: LENDER_QUOTING,
      customerProfile: quote.propertyOwner === "Y" ? "Asset Backed" : "Non Asset Backed",
      condition: condition,
      commRate: commRate,
      hasMaxRate: true
    };
    console.log('==> getMyBaseRates param ', JSON.stringify(p));
    getBaseRates({
      param: p
    })
      .then((rates) => {
        console.log('==> getMyBaseRates rates ', JSON.stringify(rates));
        resolve(rates);
      })
      .catch((error) => reject(error));
  });

// This method is from
// QuotingCalculation.cls public static Decimal getClientRateCalculation(CalcParam param, Integer scale)
const getClientRateCalc = (param) => {
  const naf = QuoteCommons.calcNetRealtimeNaf(param);
  const amountBasePmt = getBaseAmountPmtInclBrokerageCalc(param);

  const residualValue = 0;
  let type = 0;
  if (param.paymentType === "Advance") {
    type = 1;
  }
  const pmt = fu.pmt2((param.baseRate / 100 / 12),
    param.term,
    (amountBasePmt * -1),
    residualValue,
    type
  );
  let r = fu.rate2(
    param.term,
    (pmt * -1.0),
    naf,
    (residualValue * -1),
    type
  );
  if (param.baseRate == 0) {
    r = 0;
  }
  return (r * 12 * 100).toFixed(2);
};

//get fees calculations
const calcFees = (quote) =>/*
  new Promise((resolve, reject) => { //not used in plenti

    const dofVal = lenderSettings.DOF__c ? lenderSettings.DOF__c : 0;
    const appFeeVal = lenderSettings.Application_Fee__c ? lenderSettings.Application_Fee__c : 0;

    const p = {
      totalAmount: quote.netDeposit,
      vehiclePrice: quote.price
    };
    const l = {
      dof: dofVal,
      applicationFee: appFeeVal
    };

    console.log('==> getFeesCalculations param ', JSON.stringify(p));
    console.log('==> getFeesCalculations lender ', JSON.stringify(l));
    
    getCalcFees({
      param: p,
      lenderSettings: l,
      onlyMax: false
    })
      .then((fees) => {
        console.log('==> getFeesCalculations fees ', JSON.stringify(fees));
        resolve(fees);
      })
      .catch((error) => reject(error));
});*/ {
  return null;
}


const getTableRatesData = () => {
  let tableData = [];
  tableData.push({ 'Col_1': 'New to 2', 'Col_2': '50%', 'Col_3': '40%', 'Col_4': '30%' })
  tableData.push({ 'Col_1': '>2 to 5', 'Col_2': '30%', 'Col_3': '25%', 'Col_4': '20%' })
  tableData.push({ 'Col_1': '>5', 'Col_2': 'Nil', 'Col_3': 'Nil', 'Col_4': 'Nil' })
  return tableData;
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
      param.ltv = param.ltv.toString();
      save({
        param: QuoteCommons.mapLWCToSObject(
          param,
          recordId,
          LENDER_QUOTING,
          FIELDS_MAPPING_FOR_APEX
        ),
        approvalType: approvalType,
        lender: LENDER_QUOTING
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
  calcFees, calcFees,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  CALC_FEES_FIELDS: CALC_FEES_FIELDS,
  CLIENT_RATE_FIELDS: CLIENT_RATE_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  tableRateDataColumns: tableRateDataColumns,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
  RESIDUAL_VALUE_FIELDS: RESIDUAL_VALUE_FIELDS,
  getResiVal: getResidualValue,
  getResiPer: getResidualPercentage,
  getClientRateCalc: getClientRateCalc,
  getGstOptions: getGstOptions
};