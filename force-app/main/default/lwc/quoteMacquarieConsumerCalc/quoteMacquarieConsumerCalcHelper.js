import getQuotingData from "@salesforce/apex/QuoteManager.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteManager.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteManager.save";
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
  { label: "Product", fieldName: "Product__c", type: "text" },
  { label: "Consumer Profile", fieldName: "Profile__c", type: "text" },
  { label: "Manufacture Year", fieldName: "Year__c", type: "text" },
  { label: "LVR < 90", fieldName: "R1__c", type: "text" },
  { label: "90 ≤ LVR ≤ 110", fieldName: "R2__c", type: "text" },
  { label: "110 < LVR ≤ 130", fieldName: "R3__c", type: "text" }
];

const LENDER_QUOTING = "Macquarie Consumer";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["assetType", "Goods_type__c"],
  ["assetYear", "Vehicle_Age__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["netDeposit", "Net_Deposit__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["ltv", "LTV__c"],
  ["paymentType", "Payment__c"],
  ["clientRate", "Client_Rate__c"],
  ["applicationId", "Application__c"],
  ["clientTier", "Client_Tier__c"],
  ["goodsType", "Goods_type__c"],
  ["goodsSubType", "Goods_sub_type__c"],
  ["loanFrequency", "Loan_Frequency__c"],
  ["residualPer", "Residual_Value_Percentage__c"],
  ["residualValue", "Residual_Value__c"],
  ["brokeragePer", "Brokerage__c"],
  ["propertyOwner", "Customer_Profile__c"],
  ["privateSales", "Private_Sales__c"],
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
  ["clientTier", "Client_Tier__c"],
  ["baseRate", "Base_Rate__c"],
  ["maxRate", "Manual_Max_Rate__c"]
]);

const RATE_SETTING_NAMES = ["MacquarieConsumerRatesv2__c"];

const SETTING_FIELDS = new Map([

  ["monthlyFee", "Monthly_Fee__c"],
  ["ppsr", "PPSR__c"],
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "Max_DOF__c"],
  //["brokeragePer", "Brokerage_Base__c"]
]);

const BASE_RATE_FIELDS = [
  "propertyOwner",
  "ltv",
  "term",
  "privateSales",
  "price",
  "goodsType",
  "assetYear",
  "loanType"
];

const CALC_FEES_FIELDS = [
  "price",
  "deposit",
  "tradeIn",
  "payoutOn",
  "applicationFee",
  "dof",
  "ppsr"
];

const getBaseAmountPmtInclBrokerageCalc = (quote) => {

  let r = QuoteCommons.calcNetRealtimeNaf(quote);
  if (quote.brokeragePer != null && quote.brokeragePer != 0) {
    r += ((quote.price - QuoteCommons.calcNetDeposit(quote)) * quote.brokeragePer / 100);
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
    console.log(
      `!@@ quote form in calculateHelper ${JSON.stringify(quote, null, 2)}`
    );
    res.messages = Validations.validate(quote, res.messages);
    console.log(
      `!@@ res.message in calculateHelper ${JSON.stringify(
        res.messages.errors,
        null,
        2
      )}`
    );
    if (res.messages && res.messages.errors.length > 0) {
      reject(res);
    } else {
      // Prepare params
      const p = {

        lender: LENDER_QUOTING,
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceIncome(quote),
        clientRate: quote.clientRate,
        baseRate: quote.baseRate,
        paymentType: quote.paymentType,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        clientTier: quote.clientTier,
        amountBaseComm: quote.price - QuoteCommons.calcNetDeposit(quote),
        amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
        commRate: quote.commRate,
        customerProfile: quote.propertyOwner,
        ltv: quote.ltv.toString(),
        term: quote.term,
        privateSales: quote.privateSales,
        totalAmount: QuoteCommons.calcNetRealtimeNaf(quote),
        goodsType: quote.goodsType,
        vehicleYear: quote.assetYear,
        productLoanType: quote.loanProduct,
        residualValue: quote.residualValue,
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
/*const calculate = (quote) =>
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
      //const profile = quote.assetType === "Caravan" ? "CARAVAN" : "MV";
      const p = {
        lender: LENDER_QUOTING,
        productLoanType: quote.loanProduct,
        customerProfile: null,
        clientTier: quote.clientTier,
        vehicleYear: quote.assetAge,
        goodsType: quote.assetType,
        privateSales: quote.privateSales,
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        clientRate: quote.clientRate,
        baseRate: quote.baseRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residual
      };

      // Calculate
      //console.log(`@@param:`, JSON.stringify(p, null, 2));
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
*/
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

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: [
    { label: "Consumer Loan", value: "Consumer Loan" }
  ],
  terms: CommonOptions.terms(12, 84),
  assetTypes: CommonOptions.assetTypes,
  profiles: CommonOptions.profiles,
  clientTiers: CommonOptions.clientTiers,
  vehicleConditions: CommonOptions.vehicleConditions,
  greenCars: CommonOptions.yesNo,
  vehicleBuildDates: CommonOptions.vehicleBuildDates(2022, 2009),
  leaseAgreements: CommonOptions.yesNo,
  privateSales: CommonOptions.yesNo,
  propertyOwners: CommonOptions.yesNo,
  plentiAPIUsers: CommonOptions.apiUsers,
  typeValues: [
    { label: "Percentage", value: "Percentage" },
    { label: "Value", value: "Value" },
  ],
};


const reset = (recordId) => {
  let r = {
    oppId: recordId,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    assetType: calcOptions.assetTypes[0].value,
    goodsType: "Motor Vehicle",
    price: null,
    deposit: null,
    netDeposit: 0.0,
    tradeIn: null,
    payoutOn: null,
    applicationFee: null,
    maxApplicationFee: null,
    dof: null,
    maxDof: 0.0,
    ppsr: null,
    residual: 0.0,
    monthlyFee: null,
    term: 60,
    customerProfile: null,
    clientTier: null,
    vehicleCondition: null,
    greenCar: null,
    vehicleBuildDate: null,
    leaseAgreement: null,
    privateSales: 'N',
    propertyOwner: 'N',
    paymentType: "Arrears",
    maxRate: 0.0,
    baseRate: 0.0,
    clientRate: null,
    commissions: QuoteCommons.resetResults(),
    brokeragePer: 0,
    typeValue: "Value",
    ltv: 0,
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
          tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
          console.log('tableRatesData==>' + JSON.stringify(tableRatesData));
        }
        //console.log(`@@data:`, JSON.stringify(data, null, 2));
        data.typeValue = "Value";
        resolve(data);

      })
      .catch((error) => { console.log('error==>' + error.toString()); reject(error) });
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

    console.log('==> getMyBaseRates params quote ', JSON.stringify(quote));
    const p = {
      lender: LENDER_QUOTING,
      customerProfile: quote.propertyOwner,
      ltv: quote.ltv.toString(),
      term: quote.term,
      privateSales: quote.privateSales,
      totalAmount: QuoteCommons.calcNetRealtimeNaf(quote),
      goodsType: quote.goodsType,
      vehicleYear: quote.assetYear,
      //brokeragePer: quote.brokerage,
      productLoanType: quote.loanProduct
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
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  CALC_FEES_FIELDS: CALC_FEES_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  tableRateDataColumns: tableRateDataColumns,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
  RESIDUAL_VALUE_FIELDS: RESIDUAL_VALUE_FIELDS,
  getResiVal: getResidualValue,
  getResiPer: getResidualPercentage
};