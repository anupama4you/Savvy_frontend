import getQuotingData from "@salesforce/apex/QuoteCarStartFinanceCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteCarStartFinanceCalcController.save";
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
  { label: "Type Of Finance", fieldName: "Type_of_Finance__c", fixedWidth: 300 },
  { label: "Base Rate", fieldName: "Rate__c" },
  { label: "Rate Max", fieldName: "Rate_Max__c" },
  { label: "App Fee", fieldName: "App_Fee__c", type: 'currency', cellAttributes: { alignment: 'left' } },
  { label: "Dof", fieldName: "Dof__c", type: 'currency', cellAttributes: { alignment: 'left' } },
  { label: "Dof Max", fieldName: "Dof_Max__c", type: 'currency', cellAttributes: { alignment: 'left' } },
  { label: "Max Loan", fieldName: "Max_Loan__c", type: 'currency', cellAttributes: { alignment: 'left' } },
  { label: "Min Loan", fieldName: "Min_Loan__c", type: 'currency', cellAttributes: { alignment: 'left' } },
  { label: "Monthly Fee", fieldName: "Monthly_Fee__c", type: 'currency', cellAttributes: { alignment: 'left' } },
  { label: "Risk Fee", fieldName: "Risk_Fee__c", type: 'currency', cellAttributes: { alignment: 'left' } },
  { label: "Risk Fee Max", fieldName: "Risk_Fee_Max__c", type: 'currency', cellAttributes: { alignment: 'left' } },
];

const LENDER_QUOTING = "CarStart";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["netDeposit", "Net_Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["residual", "Residual_Value__c"],
  ["clientRate", "Client_Rate__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["paymentType", "Payment__c"],
  ["applicationId", "Application__c"],
  ["riskFee", "Risk_Fee__c"],
  ["commission", "Bonus_Commission__c"],
  ["loanTypeDetail", "Loan_Facility_Type__c"],
  ["loanPurpose", "Loan_Purpose__c"],
  ["baseRate", "Base_Rate__c"],
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["maxRate", "Manual_Max_Rate__c"]
]);

const RATE_SETTING_NAMES = ["CarStartFinanceRate__c"];

const SETTING_FIELDS = new Map([
  ["maxApplicationFee", "Application_Fee__c"],
  ["maxDof", "DOF__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["ppsr", "PPSR__c"]
]);

const BASE_RATE_FIELDS = [
  "customerProfile",
  "clientTier",
  "assetAge",
  "assetType",
  "privateSales",
  "loanTypeDetail"
];

const getTotalAmount = (quote) => {
  let r = QuoteCommons.calcTotalAmount(quote);
  r += quote.riskFee > 0 ? quote.riskFee : 0.0;
  return r;
};

const calcNetRealtimeNaf = (quote) => {
  let r = getTotalAmount(quote);
  r += QuoteCommons.calcTotalInsuranceType(quote);
  return r;
};

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
      const profile = quote.assetType === "Caravan" ? "CARAVAN" : "MV";
      const p = {
        lender: LENDER_QUOTING,
        productLoanType: quote.loanProduct,
        customerProfile: profile,
        clientTier: quote.clientTier,
        vehicleYear: quote.assetAge,
        goodsType: quote.assetType,
        privateSales: quote.privateSales,
        totalAmount: getTotalAmount(quote),
        // totalInsurance: QuoteCommons.calcTotalInsuranceIncome(quote),
        clientRate: quote.clientRate,
        baseRate: quote.baseRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residual,
        amountBaseComm: quote.commission
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

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: CommonOptions.fullLoanProducts,
  privateSales: CommonOptions.yesNo,
  assetTypes: [
    { label: "Car", value: "Car" },
    { label: "Caravan", value: "Caravan" }
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
  loanTypeDetailOptions: [
    { label: "--None--", value: "" },
    { label: "Mid-Prime Finance Only", value: "Mid-Prime Finance Only" },
    { label: "Sub-Prime Finance Only", value: "Sub-Prime Finance Only" },
    { label: "Sub-Prime Vend & Lend", value: "Sub-Prime Vend & Lend" },
    { label: "Sub-Prime Lite (pensioners) Finance Only", value: "Sub-Prime Lite (pensioners) Finance Only" },
    { label: "Sub-Prime Lite (pensioners) Vend & Lend", value: "Sub-Prime Lite (pensioners) Vend & Lend" }
  ],
  terms: CommonOptions.terms(36, 72)
};

// Reset
const reset = (recordId) => {
  let r = {
    oppId: recordId,
    name: LENDER_QUOTING,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    assetType: calcOptions.assetTypes[0].value,
    loanTypeDetail: calcOptions.loanTypeDetailOptions[0].value,
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
    riskFee: null,
    residual: 0.0,
    term: 60,
    monthlyFee: null,
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: null,
    privateSales: "N",
    paymentType: "Arrears",
    clientTier: calcOptions.clientTiers[0].value,
    assetAge: calcOptions.vehicleAges[0].value,
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
          tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
        }
        console.log(`@@data:`, JSON.stringify(tableRatesData, null, 2));
        resolve(data);
      })
      .catch((error) => reject(error));
  });

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const profile = quote.assetType === "Caravan" ? "CARAVAN" : "MV";
    const p = {
      lender: LENDER_QUOTING,
      productLoanType: quote.loanProduct,
      customerProfile: profile,
      loanTypeDetail: quote.loanTypeDetail,
      hasMaxRate: true
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
  baseRates: getMyBaseRates,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  tableRateDataColumns: tableRateDataColumns,
  getNetRealtimeNaf: calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail
};