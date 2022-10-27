import getQuotingData from "@salesforce/apex/QuoteAFSCommercialController.getQuotingData";
import calculateRepayments from "@salesforce/apex/QuoteAFSCommercialController.calculateRepayments";
import getAFSRates from "@salesforce/apex/QuoteAFSCommercialController.getAFSRates";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteAFSCommercialController.save";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};

const LENDER_QUOTING = "AFS Commercial";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["netDeposit", "Net_Deposit__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["rrfee", "Registration_Fee__c"],
  ["residual", "Residual_Value__c"],
  ["term", "Term__c"],
  ["carAge", "Vehicle_Age__c"],
  ["residency", "Residency__c"],
  ["paymentType", "Payment__c"],
  ["gst", "GST__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["clientRate", "Client_Rate__c"]
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["privateSales", "Private_Sales__c"],
  ["clientTier", "Client_Tier__c"],
  ["baseRate", "Base_Rate__c"],
  ["maxRate", "Manual_Max_Rate__c"]
]);

const RATE_SETTING_NAMES = ["GreenLightRates__c"];

const SETTING_FIELDS = new Map([
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["rrfee", "Registration_Fee__c"],
  ["monthlyFee", "Monthly_Fee__c"]
]);

const getNetRealtimeNaf = (quote) => {
  let r = QuoteCommons.calcNetRealtimeNaf(quote);
  r += quote.rrfee;
  return r;
};

const calculate = (quote) =>
  new Promise((resolve, reject) => {
    let res = {
      commissions: QuoteCommons.resetResults(),
      messages: QuoteCommons.resetMessage()
    };

    // Prepare params
    const p = {
      lender: LENDER_QUOTING,
      productLoanType: quote.loanProduct,
      clientTier: quote.clientTier,
      goodsType: quote.assetType,
      privateSales: quote.privateSales,
      totalAmount: getNetRealtimeNaf(quote),
      totalInsurance: QuoteCommons.calcTotalInsuranceType(quote, "Q"),
      totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
      clientRate: quote.clientRate,
      paymentType: quote.paymentType,
      term: quote.term,
      dof: quote.dof,
      monthlyFee: quote.monthlyFee,
      residualValue: quote.residual,
      assetAge: quote.carAge,
      gst: quote.gst
    };

    getAFSRates({
      param: p
    })
      .then((afsRates) => {
        // Validate quote

        res.messages = Validations.validate(
          quote,
          res.messages,
          getNetRealtimeNaf(quote),
          afsRates
        );
        if (res.messages && res.messages.errors.length > 0) {
          reject(res);
        } else {
          // Calculate
          calculateRepayments({
            param: p,
            insuranceParam: quote.insurance
          })
            .then((data) => {
              // Mapping
              res.commissions = QuoteCommons.mapCommissionSObjectToLwc(
                data.commissions,
                quote.insurance,
                data.calResults
              );

              // Validate the result of commissions
              res.messages = Validations.validatePostCalculation(
                res.commissions,
                res.messages
              );
              resolve(res);
            })
            .catch((error) => {
              res.messages.errors.push({
                field: "calculation",
                message: error
              });
              reject(res);
            });
        }
      })
      .catch((error) => {
        res.messages.errors.push({ field: "calculation", message: error });
        reject(res);
      });
  });

//return term months
const getTerms = () => {
  let r = [];
  const terms = CommonOptions.terms(12, 72);
  terms.forEach(function (item) {
    r.push({ label: item.label.toString(), value: item.value });
  });
  return r;
};

const noneOpt = [{ label: "-- None --", value: null }];
const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  loanProducts: CommonOptions.fullLoanProducts,
  terms: getTerms(),
  carAges: [
    { label: "New - 6 years old", value: "New - 6 years old" },
    { label: "Used 7 years+", value: "Used 7 years+" }
  ],
  residencies: [
    ...noneOpt,
    { label: "Home Buyer", value: "Home Buyer" },
    { label: "Non-Home Buyer", value: "Non-Home Buyer" }
  ],
  paymentTypes: CommonOptions.paymentTypes,
  gst: [
    ...noneOpt,
    { label: "Registered", value: "Registered" },
    { label: "Not Registered", value: "Not Registered" }
  ]
};

const reset = (recordId) => {
  let r = {
    oppId: recordId,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    price: null,
    deposit: null,
    tradeIn: null,
    payoutOn: null,
    netDeposit: 0.0,
    maxDof: null,
    residual: 0.0,
    term: 60,
    carAge: "New - 6 years old",
    paymentType: "Arrears",
    clientRate: null,
    residency: null,
    gst: null,
    commissions: QuoteCommons.resetResults(),
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
        resolve(data);
      })
      .catch((error) => reject(error));
  });

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
  getNetRealtimeNaf: getNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail
};