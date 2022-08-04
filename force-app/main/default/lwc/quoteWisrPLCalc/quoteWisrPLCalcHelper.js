import getQuotingData from "@salesforce/apex/QuoteWisrPLCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import { QuoteCommons, CommonOptions } from "c/quoteCommons";
import { Validations } from "./quoteValidations";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteWisrPLCalcController.save";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let tableFeesData = [];
let tableRateDataColumns = [
  { label: "Vedascore Start", fieldName: "Vedascore_Start__c", fixedWidth: 140 },
  { label: "Vedascore End", fieldName: "Vedascore_End__c", fixedWidth: 140 },
  { label: "36 Months", fieldName: "Term_A__c", fixedWidth: 110 },
  { label: "60 Months", fieldName: "Term_B__c", fixedWidth: 110 },
  { label: "84 Months", fieldName: "Term_C__c", fixedWidth: 110 },
];

let tableFeeDataColumns = [
  { label: "Loan Min", fieldName: "Loan_Min__c", fixedWidth: 110 },
  { label: "Loan Max", fieldName: "Loan_Max__c", fixedWidth: 110 },
  { label: "Loan Fee", fieldName: "Loan_Fee__c", fixedWidth: 110 },
  { label: "Max. DOF", fieldName: "DOF_Max__c", fixedWidth: 110 },
];

const LENDER_QUOTING = "Wisr";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["price", "Vehicle_Price__c"],
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["residual", "Residual_Value__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["creditScore", "Vedascore__c"],
  ["paymentType", "Payment__c"],
  ["loanPurpose", "Loan_Purpose__c"]
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["clientRate", "Client_Rate__c"],
]);

const RATE_SETTING_NAMES = ["Rate Table", "Fee Table"];

const SETTING_FIELDS = new Map([
  ["dof", "DOF__c"],
  ["maxDof", "Max_DOF__c"],
  ["residual", "Residual_Value__c"],
  ["monthlyFee", "Monthly_Fee__c"],
]);

const BASE_RATE_FIELDS = [
  "creditScore"
];

const APPLICATION_FEE_DOF_FIELDS = [
  "price"
];

const calculate = (quote) =>
  new Promise((resolve, reject) => {
    console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
    let res = {
      commissions: QuoteCommons.resetResults(),
      messages: QuoteCommons.resetMessage()
    };
    // Validate quote
    res.messages = Validations.validate(quote, res.messages);
    console.log('ling 73', res.messages);
    if (res.messages && res.messages.errors.length > 0) {
      reject(res);
      console.log('ling 76', res);
    } else {
      // Prepare params
      const p = {
        lender: LENDER_QUOTING,
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
        loanType: quote.loanType,
        productLoanType: quote.loanProduct,
        vehiclePrice: quote.price,
        applicationFee: quote.applicationFee,
        dof: quote.dof,
        residualValue: quote.residual,
        monthlyFee: quote.monthlyFee,
        term: Number(quote.term),
        vedascore: quote.creditScore,
        paymentType: quote.paymentType,
        baseRate: quote.baseRate,
        clientRate: quote.clientRate,
        amountBaseComm: quote.price
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
          res.messages = Validations.validatePostCalculation(res.commissions, res.messages);
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
  privateSales: CommonOptions.yesNo,
  terms: [
    { label: "36", value: "36" },
    { label: "60", value: "60" },
    { label: "84", value: "84" }
  ]
};

// Reset
const reset = (recordId) => {
  let r = {
    oppId : recordId,
    quoteName : LENDER_QUOTING,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    price: null,
    applicationFee: null,
    maxApplicationFee: 0,
    dof: null,
    maxDof: null,
    residual: null,
    monthlyFee: null,
    term: "60",
    creditScore: 0,
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: 0,
    paymentType: "Arrears",
    loanPurpose: '',
    commissions: QuoteCommons.resetResults()
  };
  console.log('Helper reset...');
  console.log('obj:::', r, 'lenderSettings:::', lenderSettings, 'SETTING_FIELDS:::', SETTING_FIELDS);
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
    console.log('oppId', recordId,
      'fields', fields,
      'calcName', LENDER_QUOTING,
      'rateSettings', RATE_SETTING_NAMES);
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

        // Rate Settings
        if (quoteData.rateSettings) {
          tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
          tableFeesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[1]}`];
        }
        console.log(`@@table rates data:`, tableRatesData);
        console.log(`@@table fees data:`, tableFeesData);
        resolve(data);
      })
      .catch((error) => reject(error));
  });

// Get Max Fees
const getMyMaxFees = (quote) => {
  let r = {maxApplicationFee:0, maxDof: 0};
  let topAmount = quote.price;
  let baseComm = QuoteCommons.calcNetRealtimeNaf(quote);
  if (topAmount > 50000) {
    topAmount = 50000.0;
  }
  if(tableFeesData.length>0) {
    tableFeesData.forEach(a => {
      if (topAmount >= a.Loan_Min__c && topAmount <= a.Loan_Max__c) {
        r.maxApplicationFee = a.Loan_Fee__c;
      }
      if (baseComm >= a.Loan_Min__c && baseComm <= a.Loan_Max__c) {
        r.maxDof = a.DOF_Max__c;
      }
    });
  }
  return r;
};

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const p = {
      lender: LENDER_QUOTING,
      totalAmount: QuoteCommons.calcTotalAmount(quote),
      totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
      clientRate: quote.clientRate,
      baseRate: quote.baseRate,
      paymentType: quote.paymentType,
      term: Number(quote.term),
      dof: quote.dof,
      monthlyFee: quote.monthlyFee,
      residualValue: quote.residual,
      loanType: quote.loanType,
      productLoanType: quote.loanProduct,
      vedascore: quote.creditScore,
      vehiclePrice: quote.price,
      applicationFee: quote.applicationFee,
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

const getTableFeesData = () => {
  return tableFeesData;
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
  maxFees: getMyMaxFees,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  APPLICATION_FEE_DOF_FIELDS: APPLICATION_FEE_DOF_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  getTableFeesData: getTableFeesData,
  tableRateDataColumns: tableRateDataColumns,
  tableFeeDataColumns: tableFeeDataColumns,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail
};