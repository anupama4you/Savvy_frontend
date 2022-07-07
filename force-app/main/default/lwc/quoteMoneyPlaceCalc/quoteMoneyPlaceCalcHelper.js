import getQuotingData from "@salesforce/apex/QuoteController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

let lenderSettings = {};
// data table

// only hard code in Money Place
let tableRatesData = [];
const tableRateDataColumns = [
  {
    label: "Loan Amount",
    fieldName: "loanAmount",
    type: "text"
  },
  { label: "Fee Cap", fieldName: "feeCap", type: "text" }
];

const LENDER_QUOTING = "Money Place";
const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["price", "Vehicle_Price__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["residual", "Residual_Value__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["paymentType", "Payment__c"],
  ["clientRate", "Client_Rate__c"]
]);
// setting fields refer to the DEFAULT VALUES that showing on th page you open
const SETTING_FIELDS = new Map([
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["monthlyFee", "Monthly_Fee__c"]
]);
const RATE_SETTING_NAMES = [""]; // ---> need to be modified to related sObject
const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: CommonOptions.fullLoanProducts,
  terms: CommonOptions.terms(12, 84)
};

/**
 *
 * @param {object} quote
 * @returns Returns list of calculation results
 */
const calculate = (quote) =>
  new Promise((resolve, reject) => {
    let res = {
      commissions: QuoteCommons.resetResults(),
      messages: QuoteCommons.resetMessage()
    };
    // Validate quote
    res.messages = Validations.validate(quote);
    if (res.messages && res.messages.errors.length > 0) {
      reject(res);
    } else {
      // Prepare params
      const p = {
        lender: LENDER_QUOTING,
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
        clientRate: quote.clientRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residual,
        amountBaseComm: quote.price
      };

      // Calculate
      console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
      console.log(`@@param:`, JSON.stringify(p, null, 2));
      calculateRepayments({
        param: p
      })
        .then((data) => {
          console.log(`@@SF:`, JSON.stringify(data, null, 2));
          // Mapping
          res.commissions = QuoteCommons.mapCommissionSObjectToLwc(data);
          res.messages = Validations.validate(res.commissions);
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

// Reset the values to default
const reset = () => {
  return {
    loanType: "Purchase",
    loanProduct: "Consumer Loan",
    price: null,
    applicationFee: null,
    maxDof: 0.0,
    dof: 0.0,
    ppsr: 0.0,
    residual: 0.0,
    term: 60,
    monthlyFee: 0.0,
    clientRate: 0.0,
    paymentType: "Arrears",
    commissions: QuoteCommons.resetResults(),
    loanPurpose: ""
  };
};

// Load Data
const loadData = (recordId) =>
  new Promise((resolve, reject) => {
    //  const fields = Array.from(QUOTING_FIELDS.values());
    const fields = [
      ...QUOTING_FIELDS.values(),
      ...QuoteCommons.COMMISSION_FIELDS.values()
    ];
    console.log(`@@fields:`, JSON.stringify(fields, null, 2));
    getQuotingData({
      param: { oppId: recordId, fields: fields, calcName: LENDER_QUOTING }
    })
      .then((quoteData) => {
        console.log(`@@SF:`, JSON.stringify(quoteData, null, 2));
        // Mapping Quote's fields
        let data = QuoteCommons.mapSObjectToLwc({
          calcName: LENDER_QUOTING,
          defaultData: reset(),
          quoteData: quoteData,
          settingFields: SETTING_FIELDS,
          quotingFields: QUOTING_FIELDS
        });

        // Settings
        lenderSettings = quoteData.settings;
        // Rate Setting
        tableRatesData = [
          {
            id: "a",
            loanAmount: "$5,000 - $19,999",
            feeCap: "10% of loan amount up to 990$"
          },
          {
            id: "b",
            loanAmount: "$20,000 - $39,999",
            feeCap: "$1,690"
          },
          {
            id: "b",
            loanAmount: "$40,000 - $80,000",
            feeCap: "$1,990"
          }
        ];
        console.log(`@@data:`, JSON.stringify(data, null, 2));
        resolve(data);
      })
      .catch((error) => reject(error));
  });

/**
 * @param {number} value - value of input price/amount
 * @returns max dof for two decimal format
 */
const handleMaxDOF = (value) => {
  let r = 0.0;
  let v = value; //
  if (v < 0) {
    r = 0.0;
  } else if (v < 20000) {
    r = v * 0.1 > 990.0 ? 990.0 : v * 0.1;
  } else if (v < 40000) {
    r = 1690.0;
  } else {
    r = 1990.0;
  }
  return parseFloat(r.toFixed(2));
};

const getTableRatesData = () => {
  return tableRatesData;
};

const saveQuoting = () => {
  console.log("save quoting");
};

const savePreApproval = () => {
  console.log("savePreApproval");
};
const saveAmendment = () => {
  console.log("saveAmendment");
};
const saveFormalApproval = () => {
  console.log("saveFormalApproval");
};
export const CalHelper = {
  options: calcOptions,
  tableRateDataColumns: tableRateDataColumns,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  calculate: calculate,
  load: loadData,
  reset: reset,
  handleMaxDOF: handleMaxDOF,
  getTableRatesData: getTableRatesData,
  saveQuoting: saveQuoting
};