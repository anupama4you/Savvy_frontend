import getQuotingData from "@salesforce/apex/QuoteGroupAndGeneralCalcController.getQuotingData";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteGroupAndGeneralCalcController.save";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRateDataColumnsReq = [
  { label: "Requirement", fieldName: "Requirement__c" },
];
let tableRateDataColumnsDesc = [
  { label: "Description", fieldName: "Description__c" },
];
const productNames = ['NEW START', 'COMMERCIAL WAIVER ( ASSET BACKED )', 'COMMERCIAL WAIVER (NON ASSET BACKED)', 'REPLACEMENT', 'HIGH USE VEHICLE (COURIER, UBER, DELIVERY, LIMO)', 'HIGH USE VEHICLE (COURIER, UBER, DELIVERY, LIMO)']
let tableRatesData = [];

const LENDER_QUOTING = "Group and General";

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
  ["residualPer", "Residual_Value_Percentage__c"],
  ["residualValue", "Residual_Value__c"],
  ["clientRate", "Client_Rate__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["paymentType", "Payment__c"],
  ["applicationId", "Application__c"],
  ["clientTier", "Client_Tier__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["privateSales", "Private_Sales__c"],
  ["loanTypeDetail", "Loan_Facility_Type__c"],
  ["loanPurpose", "Loan_Purpose__c"],
  ["brokeragePercentage", "Brokerage__c"],
  ["baseRate", "Base_Rate__c"],
  ["payment", "Extra_Value_1__c"],
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["baseRate", "Base_Rate__c"],
  ["maxRate", "Manual_Max_Rate__c"],
  ["maxDof", "Max_DOF__c"],
  ["realtimeNaf", "NAF__c"],
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

const RATE_SETTING_NAMES = ["gagRateList1", "gagRateList2", "gagRateList3", "gagRateList4", "gagRateList5", "gagRateList6"];

const SETTING_FIELDS = new Map([
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["ppsr", "PPSR__c"],
  ["monthlyFee", "Monthly_Fee__c"]
]);

const BASE_RATE_FIELDS = [
  "residualValue",
  "paymentType",
  "baseRate",
  "term"
];

const MAX_DOF_FIELDS = [
  "price",
  "deposit",
  "tradeIn",
  "payoutOn",
  "applicationFee",
  "dof",
  "ppsr"
];

const calculate = (quote) =>
  new Promise((resolve, reject) => {
    console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
    let res = {
      commissions: QuoteCommons.resetResults(),
      messages: QuoteCommons.resetMessage()
    };
    // Validate quote
    // res.messages = Validations.validate(quote, res.messages);
    if (res.messages && res.messages.errors.length > 0) {
      reject(res);
    } else {
      // Prepare params
      const p = {
        lender: LENDER_QUOTING,
        productLoanType: quote.loanProduct,
        clientTier: quote.clientTier,
        vehicleYear: quote.assetAge,
        goodsType: quote.assetType,
        privateSales: quote.privateSales,
        totalAmount: QuoteCommons.calcNetRealtimeNaf(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
        clientRate: quote.clientRate,
        baseRate: quote.baseRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residualValue,
        brokeragePer: quote.brokeragePercentage,
        amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
        amountBaseComm: getBaseAmountPmtCalc(quote),
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

const termOptions = (min, max) => {
  let r = [];
  for (let i = min; i <= max;) {
    r.push({ label: i.toString(), value: i.toString() });
    i += 12;
  }
  return r;
};

const calcOptions = {
  loanTypes: [
    { label: "Chattel Mortgage", value: "Chattel Mortgage" },
    { label: "Replacement loan", value: "Replacement loan" },
    { label: "Courier/Uber", value: "Courier/Uber" },
  ],
  paymentTypes: [
    { label: "Advance", value: "Advance" },
  ],
  loanProducts: CommonOptions.fullLoanProducts,
  privateSales: [{ label: "-- None --", value: null }, ...CommonOptions.yesNo],
  assetTypes: [
    { label: "Cars/Vans/Utes", value: "Cars/Vans/Utes" },
    { label: "Trucks/Trailers", value: "Trucks/Trailers" },
    { label: "Yellow goods", value: "Yellow goods" },
  ],
  clientTiers: [
    { label: "A", value: "A" },
    { label: "B", value: "B" },
    { label: "C", value: "C" }
  ],
  vehicleAges: [
    { label: "New", value: "New" },
    { label: "Used 0-5 years", value: "Used 0-5 years" },
    { label: "Used 6-9 years", value: "Used 6-9 years" },
    { label: "Used 10+ years", value: "Used 10+ years" }
  ],
  securityOptions: [
    { label: "Secured", value: "Secured" },
    { label: "Unsecured", value: "Unsecured" }
  ],
  abnLengths: [
    { label: "< 2 years", value: "< 2 years" },
    { label: "> 2 years", value: "> 2 years" }
  ],
  propertyOwners: CommonOptions.yesNo,
  gsts: CommonOptions.yesNo,
  typeValues: [
    { label: "Percentage", value: "Percentage" },
    { label: "Value", value: "Value" },
  ],
  terms: termOptions(0, 60)
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
    applicationFee: null,
    maxApplicationFee: null,
    dof: 0.0,
    maxDof: null,
    ppsr: null,
    residualValue: 0.0,
    term: '0',
    brokeragePercentage: 8,
    monthlyFee: null,
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: null,
    privateSales: "N",
    paymentType: "Advance",
    loanTypeDetail: "Secured",
    clientTier: calcOptions.clientTiers[0].value,
    assetAge: calcOptions.vehicleAges[0].value,
    commissions: QuoteCommons.resetResults(),
    typeValue: "Value",
    abnLength: calcOptions.abnLengths[0].value,
    gst: calcOptions.gsts[1].value,
    customerProfile: calcOptions.propertyOwners[1].value,
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
          generateTableData(quoteData.rateSettings);
        }
        console.log(`@@data:`, JSON.stringify(data, null, 2));
        resolve(data);
      })
      .catch((error) => reject(error));
  });

const generateTableData = (data) => {
  console.log(`@@Table-Data:`, JSON.stringify(data, null, 2));
  let index = 0;
  productNames.forEach(product => {
    // last dataset column name is different
    if (index == 5)
      tableRatesData.push({ 'title': product, 'data': data[`${RATE_SETTING_NAMES[index]}`], 'col': tableRateDataColumnsDesc })
    else
      tableRatesData.push({ 'title': product, 'data': data[`${RATE_SETTING_NAMES[index]}`], 'col': tableRateDataColumnsReq })
    index++;
  })
  console.log(`@@ordered-data:`, JSON.stringify(tableRatesData, null, 2))
}

const getResidualValue = (quote) => {
  const res = ((quote.price - QuoteCommons.calcNetDeposit(quote)) * quote.residualPer) / 100;
  return res.toFixed(2);
};

const getResidualPercentage = (quote) => {
  const res = (quote.residualValue / (quote.price - QuoteCommons.calcNetDeposit(quote))) * 100;
  return res.toFixed(2);
  // return (quote.residualValue / (quote.price - QuoteCommons.calcNetDeposit(quote))) * 100;
};

const getBaseAmountPmtCalc = (param, per) => {
  let r = 0;
  param.price && (r += param.price);
  r += QuoteCommons.calcTotalInsuranceType(param);
  r -= QuoteCommons.calcNetDeposit(param);
  return r;
};

const getBaseAmountPmtInclBrokerageCalc = (param) => {
  const naf = QuoteCommons.calcNetRealtimeNaf(param);
  let r = 0;
  if (param.brokeragePercentage) {
    r = (naf + naf * (param.brokeragePercentage / 100));
  }
  return r;
};

//  r == 0.1 means fu.rate2() return the default value. It is the reset value.
const getClientRateCalc = (quote) => {
  // let r = 0;
  const term = parseInt(quote.term);
  const naf = QuoteCommons.calcNetRealtimeNaf(quote);
  let fv = 0;
  quote.residualValue && (fv = quote.residualValue);
  const amuntPmt = getBaseAmountPmtInclBrokerageCalc(quote);
  let type = 0;
  if (quote.paymentType === "Advance") {
    type = 1;
  }
  const pmt = fu.pmt2((quote.baseRate / 100 / 12),
    term,
    (amuntPmt * -1),
    fv,
    type
  );
  const r = fu.rate2(
    term,
    (pmt * -1.0),
    naf,
    (fv * -1),
    type
  );
  if (r == 0.1) {
    return quote.baseRate;
  }
  let res = (r * 12 * 100).toFixed(2);
  return res;
};

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
  clientRates: getClientRateCalc,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  MAX_DOF_FIELDS: MAX_DOF_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  RESIDUAL_VALUE_FIELDS: RESIDUAL_VALUE_FIELDS,
  getResiVal: getResidualValue,
  getResiPer: getResidualPercentage,
  saveQuote: saveQuote,
  sendEmail: sendEmail
};