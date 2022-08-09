import getQuotingData from "@salesforce/apex/QuoteShiftAssetCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteShiftAssetCalcController.save";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let assetRates1Columns = [
  { label: "Type of Asset", fieldName: "Type_of_Asset__c" },
  { label: "Age of Asset", fieldName: "Age_of_Asset__c" },
  { label: "Property Backed", fieldName: "Property_Backed__c" },
  { label: "Non Property Backed", fieldName: "Non_Property_Backed__c" }
];
let assetRates2Columns = [
  { label: "Type of Asset", fieldName: "Type_of_Asset__c" },
  { label: "Age of Asset", fieldName: "Age_of_Asset__c" },
  { label: "Property Backed", fieldName: "Property_Backed__c" },
  { label: "Non Property Backed", fieldName: "Non_Property_Backed__c" }
];
let addOnsListColumns = [
  { label: "Add-ons", fieldName: "Add_ons__c" },
  { label: "Description", fieldName: "Description__c" }
];
let commissionListColumns = [
  { label: "Loan Amount", fieldName: "Loan_Amount__c" },
  { label: "Maximum commission (Inc) GST", fieldName: "Maximum_commission_Inc_GST__c" }
];

const LENDER_QUOTING = "Shift Asset";

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
  ["residualValuePercentage", "Residual_Value_Percentage__c"],
  ["residualValue", "Residual_Value__c"],
  ["clientRate", "Client_Rate__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["paymentType", "Payment__c"],
  ["applicationId", "Application__c"],
  ["abnLength", "Extra_Label_1__c"],
  ["gstLength", "Extra_Label_2__c"],
  ["brokeragePercentage", "Brokerage__c"],
  ["equifaxScore", "Credit_Score__c"],
  ["propertyOwner", "Customer_Profile__c"],
  ["privateSales", "Private_Sales__c"],
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["clientTier", "Client_Tier__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["baseRate", "Base_Rate__c"],
  ["maxRate", "Manual_Max_Rate__c"]
]);

const RATE_SETTING_NAMES = ["ASSET_RATE_1", "ASSET_RATE_2", "ADD_ONS_LIST", "COMMISSION_LIST"];

const SETTING_FIELDS = new Map([
  ["price", "Vehicle_Price__c"],
  ["dof", "DOF__c"],
  ["applicationFee", "Application_Fee__c"],
  ["applicationFeePrivate", "Application_Fee_Private__c"],
  ["ppsr", "PPSR__c"],
  ["residualValue", "Residual_Value__c"],
  ["monthlyFee", "Monthly_Fee__c"],
]);

const RESIDUAL_VALUE_FIELDS = [
  "residualValue",
  "residualValuePercentage",
  "typeValue",
  "price",
  "deposit",
  "tradeIn",
  "payoutOn"
];

const CLIENT_RATE_FIELDS = [
  "brokeragePercentage",
];

const BASE_RATE_FIELDS = [
  "price",
  "deposit",
  "tradeIn",
  "payoutOn",
  "assetAge",
  "abnLength",
  "assetType",
  "customerProfile",
  "abnLength",
  "assetType",
  "assetAge",
  "propertyOwner",
  "brokeragePercentage",
  "privateSales",
  "loanType"
];

const getBaseAmountPmtInclBrokerageCalc = (quote) => {
  let naf = QuoteCommons.calcNetRealtimeNaf(quote);
  let brokerage = quote.brokeragePercentage > 0 ? quote.brokeragePercentage : 0;
  console.log('get PMT...', naf + naf * brokerage / 100);
  return naf + (naf * brokerage) / 100;
}

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
      const p = {
        lender: LENDER_QUOTING,
        amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
        term: quote.term,
        residualValue: quote.residualValue,
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
        paymentType: quote.paymentType,
        brokeragePer: quote.brokeragePercentage,
        amountBaseComm: quote.price - QuoteCommons.calcNetDeposit(quote),
        dof: lenderSettings.DOF_C,
        monthlyFee: quote.monthlyFee,
        baseRate: quote.baseRate,
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
  loanTypes: [
    { label: "Purchase", value: "Purchase" },
    { label: "Refinance", value: "Refinance" },
    { label: "Sale & Lease Back", value: "Sale & Lease Back" },
    { label: "Equity Raise", value: "Equity Raise" },
  ],
  paymentTypes: [
    { label: "Advance", value: "Advance" },
  ],
  loanProducts: CommonOptions.fullLoanProducts,
  privateSales: [
    { label: "--None--", value: "" },
    { label: "Yes", value: "Y" },
    { label: "No", value: "N" },
  ],
  propertyOwners: CommonOptions.yesNo,
  assetTypes: [
    { label: "Primary Assets", value: "Primary Assets" },
    { label: "Secondary Assets", value: "Secondary Assets" },
    { label: "Tertiary assets", value: "Tertiary assets" },
    { label: "Fitout Finance", value: "Fitout Finance" },
  ],
  clientTiers: [
    { label: "A", value: "A" },
    { label: "B", value: "B" },
    { label: "C", value: "C" }
  ],
  vehicleAges: [
    { label: "New to 4 years", value: "New to 4 years" },
    { label: "5 - 10 years", value: "5 - 10 years" },
    { label: "11+ years", value: "11+ years" },
    { label: "20+ years", value: "20+ years (age and term)" }
  ],
  typeValues: [
    { label: "Percentage", value: "Percentage" },
    { label: "Value", value: "Value" },
  ],
  AbnLengths: [
    { label: "< 2 years", value: "< 2 years" },
    { label: "> 2 years", value: "> 2 years" },
  ],
  GstLengths: [
    { label: "No GST", value: "" },
    { label: "< 2 years", value: "< 2 years" },
    { label: "> 2 years", value: "> 2 years" }
  ],
  terms: CommonOptions.terms(0, 60).map(({ label, value }) => ({ label: label.toString(), value: value.toString() })),
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
    dof: null,
    maxDof: null,
    ppsr: null,
    residual: 0.0,
    residualValue: 0.0,
    term: calcOptions.terms[0].value,
    monthlyFee: null,
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: null,
    brokeragePercentage: 6,
    privateSales: calcOptions.privateSales[0].value,
    paymentType: calcOptions.paymentTypes[0].value,
    clientTier: calcOptions.clientTiers[0].value,
    assetAge: calcOptions.vehicleAges[0].value,
    abnLength: calcOptions.AbnLengths[0].value,
    gstLength: calcOptions.GstLengths[0].value,
    propertyOwner: calcOptions.propertyOwners[1].value,
    commissions: QuoteCommons.resetResults()
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
      ...QuoteCommons.COMMISSION_FIELDS.values()
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
        // quoteData.Term__c = quoteData.Term__c.toString();
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
        // data, column names, table headings
        if (quoteData.rateSettings) {
          tableRatesData.push({ data: quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`], col: assetRates1Columns, name: 'Pricing, fees, and commission. Up to $250,000' });
          tableRatesData.push({ data: quoteData.rateSettings[`${RATE_SETTING_NAMES[1]}`], col: assetRates2Columns, name: 'Pricing, fees, and commission. Over $250,000' });
          tableRatesData.push({ data: quoteData.rateSettings[`${RATE_SETTING_NAMES[2]}`], col: addOnsListColumns, name: 'Add-Ons' });
          tableRatesData.push({ data: quoteData.rateSettings[`${RATE_SETTING_NAMES[3]}`], col: commissionListColumns, name: 'Commission (Inc GST)' });
          console.log(`@@data:`, JSON.stringify(tableRatesData, null, 2));
        }
        // console.log(`@@data:`, JSON.stringify(data, null, 2));
        resolve(data);
      })
      .catch((error) => reject(error));
  });

const getResidualValue = (quote) => {
  return ((quote.price - QuoteCommons.calcNetDeposit(quote)) * quote.residualValuePercentage) / 100;
}

const getResidualPercentage = (quote) => {
  return (quote.residualValue / (quote.price - QuoteCommons.calcNetDeposit(quote))) * 100;
}

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const p = {
      lender: LENDER_QUOTING,
      abnLength: quote.abnLength,
      assetType: quote.assetType,
      assetAge: quote.assetAge,
      totalAmount: QuoteCommons.calcNetRealtimeNaf(quote),
      customerProfile: quote.propertyOwner,
      brokeragePer: quote.brokeragePercentage,
      privateSales: quote.privateSales,
      loanType: quote.loanType,
      hasMaxRate: false
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
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  RESIDUAL_VALUE_FIELDS: RESIDUAL_VALUE_FIELDS,
  CLIENT_RATE_FIELDS: CLIENT_RATE_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
  assetRates1Columns: assetRates1Columns,
  assetRates2Columns: assetRates2Columns,
  addOnsListColumns: addOnsListColumns,
  commissionListColumns: commissionListColumns,
  getResidualValue: getResidualValue,
  getResidualPercentage: getResidualPercentage,
};