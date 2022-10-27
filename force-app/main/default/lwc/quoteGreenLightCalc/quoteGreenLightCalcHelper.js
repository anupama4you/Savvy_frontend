import getQuotingData from "@salesforce/apex/QuoteGreenLightController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteGreenLightController.getBaseRates";
import getCalcFees from "@salesforce/apex/QuoteGreenLightController.getFees";
import getGreenlightRates from "@salesforce/apex/QuoteGreenLightController.getGreenlight";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteGreenLightController.save";
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
  {
    label: "Asset Type",
    fieldName: "Asset_Type__c",
    fixedWidth: 110,
    hideDefaultActions: true
  },
  {
    label: "Tier",
    fieldName: "Tier__c",
    fixedWidth: 110,
    hideDefaultActions: true
  },
  {
    label: "LVR",
    fieldName: "LVR__c",
    fixedWidth: 70,
    hideDefaultActions: true
  },
  {
    label: "Vehicle Age",
    fieldName: "Vehicle_Age__c",
    fixedWidth: 110,
    hideDefaultActions: true
  },
  {
    label: "Base Rate",
    fieldName: "Base_Rate__c",
    fixedWidth: 100,
    hideDefaultActions: true
  },
  {
    label: "Max Rate",
    fieldName: "Max_Rate__c",
    fixedWidth: 110,
    hideDefaultActions: true
  },
  {
    label: "Brokerage Max",
    fieldName: "Brokerage_Max__c",
    fixedWidth: 110,
    hideDefaultActions: true
  },
  {
    label: "DOF Max",
    fieldName: "DOF_Max__c",
    fixedWidth: 80,
    hideDefaultActions: true
  },
  {
    label: "Max LTV",
    fieldName: "Max_LTV__c",
    fixedWidth: 80,
    hideDefaultActions: true
  },
  {
    label: "Minimum Deposit",
    fieldName: "Minimum_Deposit__c",
    fixedWidth: 130,
    hideDefaultActions: true
  },
  {
    label: "Min Loan Value",
    fieldName: "Min_Loan_Value__c",
    fixedWidth: 120,
    hideDefaultActions: true
  },
  {
    label: "Max Loan Value",
    fieldName: "Max_Loan_Value__c",
    fixedWidth: 120,
    hideDefaultActions: true
  },
  {
    label: "Max Loan Term",
    fieldName: "Max_Loan_Term__c",
    fixedWidth: 120,
    hideDefaultActions: true
  }
];

const LENDER_QUOTING = "Green Light";

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
  ["clientTier", "Client_Tier__c"],
  ["brokerage", "Brokerage__c"]
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["privateSales", "Private_Sales__c"],
  ["clientTier", "Client_Tier__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["baseRate", "Base_Rate__c"],
  ["maxRate", "Manual_Max_Rate__c"]
]);

const RATE_SETTING_NAMES = ["GreenLightRates__c"];

const SETTING_FIELDS = new Map([
  ["monthlyFee", "Monthly_Fee__c"],
  ["ppsr", "PPSR__c"],
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "DOF__c"]
]);

const BASE_RATE_FIELDS = ["clientTier", "vehicleYear", "assetType", "lvr"];

const CALC_FEES_FIELDS = ["price", "deposit", "tradeIn", "payoutOn"];

// calculate NAF commission
const getNafCommission = (quote) => {
  let r = 0.0;
  r += quote.price;
  r -= QuoteCommons.calcNetDeposit(quote);
  return r;
}

const calculate = (quote) =>
  new Promise((resolve, reject) => {
    let res = {
      commissions: QuoteCommons.resetResults(),
      messages: QuoteCommons.resetMessage()
    };

    let nafCommission = getNafCommission(quote);

    // Prepare params
    const p = {
      lender: LENDER_QUOTING,
      productLoanType: quote.loanProduct,
      clientTier: quote.clientTier,
      vehicleYear: quote.vehicleYear,
      goodsType: quote.assetType,
      assetType: quote.assetType,
      privateSales: quote.privateSales,
      totalAmount: QuoteCommons.calcTotalAmount(quote),
      totalInsurance: QuoteCommons.calcTotalInsuranceIncome(quote),
      totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
      clientRate: quote.clientRate,
      baseRate: quote.baseRate,
      paymentType: quote.paymentType,
      term: quote.term,
      dof: quote.dof,
      monthlyFee: quote.monthlyFee,
      residualValue: quote.residual,
      ltv: quote.lvr,
      maxRate: quote.maxRate,
      brokeragePer: quote.brokerage,
      netDeposit: quote.netDeposit,
      vehiclePrice: quote.price,
      amountBaseComm: nafCommission
    };

    getGreenlightRates({
      param: p
    })
      .then((glRates) => {
        // Validate quote
        res.messages = Validations.validate(quote, res.messages, glRates);
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

const currentYear = new Date().getFullYear();

//return vehicle year
const getVehicleYear = () => {
  let r = [];

  for (let i = 0; i < 20; i++) {
    let res = currentYear - i;
    r.push({ label: res.toString(), value: res.toString() });
  }
  return r;
};

//return term months
const getTerms = () => {
  let r = [];
  const terms = CommonOptions.terms(12, 84);
  terms.forEach(function (item) {
    r.push({ label: item.label.toString(), value: item.value });
  });
  return r;
};

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: CommonOptions.fullLoanProducts,
  assetTypes: [
    { label: "Car", value: "Car" },
    { label: "Motorcycle", value: "Motorcycle" }
  ],
  clientTiers: [
    { label: "Platinum", value: "Platinum" },
    { label: "Gold", value: "Gold" },
    { label: "Silver", value: "Silver" },
    { label: "Bronze", value: "Bronze" },
    { label: "Budget Loan", value: "Budget Loan" }
  ],
  terms: getTerms(),
  lvr: [
    { label: "-- None --", value: null },
    { label: "<=90%", value: "<=90%" },
    { label: ">90-100%", value: ">90-100%" },
    { label: ">100-130%", value: ">100-130%" }
  ],
  yearList: getVehicleYear()
};

const reset = (recordId) => {
  let r = {
    oppId: recordId,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    assetType: calcOptions.assetTypes[0].value,
    vehicleYear: currentYear.toString(),
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
    term: 60,
    monthlyFee: null,
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: null,
    paymentType: "Arrears",
    clientTier: "Platinum",
    lvr: null,
    brokerage: 5,
    commissions: QuoteCommons.resetResults(),
    insurance: { integrity: {} },
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

        // Rate Settings
        if (quoteData.rateSettings) {
          tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
        }

        resolve(data);
      })
      .catch((error) => reject(error));
  });

// Get Base Rates
const getMyBaseRates = (quote, resetBP) =>
  new Promise((resolve, reject) => {
    const p = {
      lender: LENDER_QUOTING,
      productLoanType: quote.loanProduct,
      clientTier: quote.clientTier,
      vehicleYear: quote.vehicleYear,
      assetType: quote.assetType,
      ltv: quote.lvr,
      hasMaxRate: true,
      brokeragePer: quote.brokerage,
      clientRate: quote.clientRate
    };

    getBaseRates({
      param: p,
      resetBrokerage: resetBP
    })
      .then((rates) => {
        resolve(rates);
      })
      .catch((error) => reject(error));
  });

//get fees calculations
const calcFees = (quote) =>
  new Promise((resolve, reject) => {
    const dofVal = lenderSettings.DOF__c ? lenderSettings.DOF__c : 0;
    const appFeeVal = lenderSettings.Application_Fee__c
      ? lenderSettings.Application_Fee__c
      : 0;

    const p = {
      netDeposit: quote.netDeposit,
      vehiclePrice: quote.price
    };
    const l = {
      dof: dofVal,
      applicationFee: appFeeVal
    };

    getCalcFees({
      param: p,
      lenderSettings: l,
      onlyMax: false
    })
      .then((fees) => {
        resolve(fees);
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
  sendEmail: sendEmail
};