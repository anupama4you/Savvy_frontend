import getQuotingData from "@salesforce/apex/QuoteController.getQuotingData";//TBC not used
import save from "@salesforce/apex/QuoteMoneyPlaceController.save";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// only hard code in Macquarie Consumer
let tableRatesData = [];
const tableRateDataColumns = [
  { label: "Product", fieldName: "Product", type: "text" },
  { label: "Consumer Profile", fieldName: "Profile", type: "text" },
  { label: "Manufacture Year", fieldName: "Year", type: "text" },
  { label: "LVR < 90", fieldName: "R1", type: "text" },
  { label: "90 ≤ LVR ≤ 110", fieldName: "R2", type: "text" },
  { label: "110 < LVR ≤ 130", fieldName: "R3", type: "text" }
];


const LENDER_QUOTING = "Macquarie Consumer";

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
  ["clientRate", "Client_Rate__c"],
  ["loanPurpose", "Loan_Purpose__c"],
  ["applicationId", "Application__c"]
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

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([["Id", "Id"], ...QUOTING_FIELDS]);

// setting fields refer to the DEFAULT VALUES that showing on th page you open
const SETTING_FIELDS = new Map([
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "DOF__c"],
  ["monthlyFee", "Monthly_Fee__c"]
]);

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: [
    { label: "Consumer Loan", value: "Consumer Loan"}
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
          // Validate for results
          res.messages = Validations.validate(res.commissions, res.messages);
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
const reset = (recordId, appQuoteId = null) => {
  return {
    oppId: recordId,
    Id: appQuoteId,
    quoteName: LENDER_QUOTING,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    price: null,
    applicationFee: null,
    maxDof: 0.0,
    dof: 0.0,
    residual: 0.0,
    term: 60,
    monthlyFee: 0.0,
    clientRate: 0.0,
    paymentType: calcOptions.paymentTypes[0].value,
    commissions: QuoteCommons.resetResults(),
    loanPurpose: "",
    assetType: calcOptions.assetTypes[0].value,
    profile: "",
    clientTier: "",
    vehicleCondition: "",
    greenCar: "",
    vehicleBuildDate: "",
    leaseAgreement: "",
    privateSale: "No",
    plentiAPIUser: ""
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
        console.log(
          `@@ quoteData in loadData function: ${JSON.stringify(
            quoteData,
            null,
            2
          )}`
        );
        // Mapping Quote's fields
        let data = QuoteCommons.mapSObjectToLwc({
          calcName: LENDER_QUOTING,
          defaultData: reset(recordId),
          quoteData: quoteData,
          settingFields: SETTING_FIELDS,
          quotingFields: QUOTING_FIELDS
        });

        // Rate Setting
        /*tableRatesData = [
          {
            profile: "a",
            tier: "$5,000 - $19,999"
          }
        ];*/
        console.log(`@@data in loadData:`, JSON.stringify(data, null, 2));
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

/**
 * -- Lee
 * @param {String} approvalType - string and what type of the button
 * @param {Object} param - quote form
 * @param {Id} recordId - recordId
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
          reject(`error in saveApproval ${approvalType}: `, error.messages);
        });
    } else {
      reject(
        new Error(
          `Something Wrong, appType: ${approvalType}, param: ${JSON.stringify(
            param,
            null,
            2
          )}, param: ${recordId}`
        )
      );
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
  tableRateDataColumns: tableRateDataColumns,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  calculate: calculate,
  load: loadData,
  reset: reset,
  handleMaxDOF: handleMaxDOF,
  getTableRatesData: getTableRatesData,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
  RESIDUAL_VALUE_FIELDS: RESIDUAL_VALUE_FIELDS
};