import getQuotingData from "@salesforce/apex/QuoteFinanceOneController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import getRiskFeeCalc from "@salesforce/apex/QuoteFinanceOneController.getRiskFeeCalc";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import getGoodsSubTypes from "@salesforce/apex/QuoteFinanceOneCommController.getGoodsSubTypes";
import getDofCalcu from "@salesforce/apex/QuoteFinanceOneController.getDofCalcu";
import getFinanceOneRate from "@salesforce/apex/QuoteFinanceOneCommController.getFinanceOneRate";
import getApplicationFeeCalc from "@salesforce/apex/QuoteFinanceOneCommController.getApplicationFeeCalc";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteFinanceOneController.save";

import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";

import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let goodsSubTypeCarlist = [];
let goodsSubTypeMotorBikelist = [];
let goodsSubTypeBoatlist = [];
let goodsSubTypeCaravanlist = [];
let tableRateDataColumns = [
  { label: "Premium Plus", fieldName: "col1Rate", hideDefaultActions: true },
  { label: "Premium", fieldName: "col2Rate", hideDefaultActions: true },
  { label: "Standard", fieldName: "col3Rate", hideDefaultActions: true },
  { label: "Lite", fieldName: "col4Rate", hideDefaultActions: true },
];

const LENDER_QUOTING = "C1 Finance";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["goodType", "Goods_type__c"],
  ["goodsSubType", "Goods_sub_type__c"],
  ["loanTypeDetail", "Loan_Facility_Type__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["residual", "Residual_Value__c"],
  ["term", "Term__c"],
  ["propertyOwner", "Customer_Profile__c"],
  ["paymentType", "Payment__c"],
  ["riskFee", "Risk_Fee__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["clientRate", "Client_Rate__c"],
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["privateSales", "Private_Sales__c"],
  ["clientTier", "Client_Tier__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["baseRate", "Base_Rate__c"],
  ["maxRate", "Manual_Max_Rate__c"],
  ["netDeposit", "Net_Deposit__c"]
]);

const RATE_SETTING_NAMES = ["FinanceOneRates__c"];

const SETTING_FIELDS = new Map([
  ["applicationFee", "Application_Fee__c"],
  ["ppsr", "PPSR__c"],
  ["brokerage", "Max_Brokerage__c"],
  ["monthlyFee", "Monthly_Fee__c"]
]);

const BASE_RATE_FIELDS = [
  "loanProduct",
  "loanTypeDetail"
];

const RISK_FEE_FIELDS = [
  "price",
  "deposit",
  "tradeIn",
  "payoutOn",
  "productLoanType",
  "loanTypeDetail",
  "dof",
  "term"
];

const DOF_Calc_Fields = [
  "price",
  "deposit",
  "tradeIn",
  "payoutOn",
];

const APPFEE_Calc_Fields = [
  "loanProduct",
  "loanTypeDetail",
  "price",
  "netDeposit"
];

//Get total naf calculations
const getNetRealtimeNaf = (quote) => {
  let naf = QuoteCommons.calcTotalAmount(quote);
  return naf;
};

// Asset age options
const assetAgeOptions = (min, max) => {
  let r = [];
  for (let i = min; i <= max;) {
    r.push({ label: i.toString(), value: i.toString() });
    i++;
  }
  return r;
};

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  loanProducts: [{ label: "Consumer Loan", value: "Consumer Loan" }],
  goodTypes: [
    { label: "Car", value: "Car" },
    { label: "Motorbike", value: "Motorbike" },
    { label: "Caravan", value: "Caravan" },
  ],
  loanTypeDetails: [
    { label: "Premium +", value: "Premium Plus" },
    { label: "Premium", value: "Premium" },
    { label: "Standard", value: "Standard" },
    { label: "Lite", value: "Lite" }
  ],
  terms: CommonOptions.terms(24, 60),
  propertyOwners: [
    { label: "--None--", value: "" },
    { label: "Yes", value: "Y" },
    { label: "No", value: "N" },
  ],
  vehicleAges: assetAgeOptions(0, 15),
  privateSales: [{ label: "-- None --", value: null }, ...CommonOptions.yesNo],
  paymentTypes: CommonOptions.paymentTypes
};

const reset = (recordId) => {
  let r = {
    oppId: recordId,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    goodType: calcOptions.goodTypes[0].value,
    loanTypeDetail: "Premium Plus",
    price: null,
    deposit: null,
    tradeIn: null,
    payoutOn: null,
    netDeposit: 0.0,
    dof: 0.0,
    maxDof: 1395,
    ppsr: 0.0,
    residual: 0.0,
    term: 60,
    propertyOwner: '',
    carAge: "New - 6 years old",
    residency: null,
    paymentType: "Arrears",
    baseRate: 0.0,
    maxRate: 0.0,
    riskFee: 0.0,
    calcRiskFee: 0.0,
    clientRate: 0.0,
    privateSales: "N",
    assetAge: calcOptions.vehicleAges[0].value,
    commissions: QuoteCommons.resetResults(),
    insurance: { integrity: {} }
  };
  r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
  return r;
};

// Get Base Rates
const getMyBaseRates = (quote) => {
  if (quote.loanTypeDetail === "Premium Plus") {
    return 19.99;
  } else if (quote.loanTypeDetail === "Premium") {
    return 24.99;
  } else if (quote.loanTypeDetail === "Standard") {
    return 27.99;
  } else if (quote.loanTypeDetail === "Lite") {
    return 29.99;
  } else {
    return 0.0;
  }
}

// calculate NAF commission
const getNafCommission = (quote) => {
  let r = 0.0;
  r += quote.price;
  r -= QuoteCommons.calcNetDeposit(quote);
  return r;
}

// Get Risk Fee Calculations
// const getRiskCalc = (quote) =>
//   new Promise((resolve, reject) => {
//     const p = {
//       totalInsurance: QuoteCommons.calcTotalInsuranceType(quote, "Q"),
//       vehiclePrice: quote.price,
//       netDeposit: quote.netDeposit,
//       loanTypeDetail: quote.loanTypeDetail,
//       productLoanType: quote.loanProduct,
//       dof: quote.dof
//     };

//     getRiskFeeCalc({
//       param: p
//     })
//       .then((riskFee) => {
//         resolve(riskFee);
//       })
//       .catch((error) => reject(error));
//   });

// Get DOF and Max DOF Calculations
const getDOFCalc = (quote, isFullCalc) => {
  let amount = 0.0;
  amount += quote.price > 0 ? quote.price : 0.0;
  amount -= QuoteCommons.calcNetDeposit(quote);

  console.log('TotalAmount@@', amount);

  let dof = (amount * 10) / 100;
  if (dof > 1395) {
    return 1395.0;
  } else {
    return dof;
  }
}

// Get Application Fee Calculations
const getAppFeeCalc = (quote) =>
  new Promise((resolve, reject) => {
    const p = {
      productLoanType: quote.loanProduct,
      loanTypeDetail: quote.loanTypeDetail,
      vehiclePrice: quote.price,
      netDeposit: quote.netDeposit
    };
    getApplicationFeeCalc({
      param: p
    })
      .then((appFee) => {
        resolve(appFee);
      })
      .catch((error) => reject(error));
  });

const getRiskCalc = (quote) => {
  let riskFee = 0.0;
  let amount = 0.0;
  amount += quote.price > 0 ? quote.price : 0.0;
  amount -= QuoteCommons.calcNetDeposit(quote);
  // term months to years
  let years = quote.term / 12

  if (quote.loanTypeDetail === "Premium Plus") {
    if (years === 2 || years === 3) {
      riskFee = 7.0;
    } else if (years === 4) {
      riskFee = 7.50;
    } else if (years === 5) {
      riskFee = 9.0;
    }
  } else if (quote.loanTypeDetail === "Premium") {
    if (years === 2) {
      riskFee = 7.75;
    } else if (years === 3) {
      riskFee = 8.0;
    } else if (years === 4) {
      riskFee = 8.5;
    } else if (years === 5) {
      riskFee = 9.0;
    }
  } else if (quote.loanTypeDetail === "Standard") {
    if (years === 2) {
      riskFee = 8.25;
    } else if (years === 3) {
      riskFee = 8.5;
    } else if (years === 4) {
      riskFee = 8.75;
    }
  } else if (quote.loanTypeDetail === "Lite") {
    if (years === 2) {
      riskFee = 9;
    } else if (years === 3) {
      riskFee = 9;
    }
  }
  return (riskFee * amount) / 100;
}

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
        // if (quoteData.rateSettings) {
        //   tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
        // }

        resolve(data);

      })
      .catch((error) => reject(error));
  });

const getTableRatesData = () => {
  const data = [{
    col1Rate : 19.99,
    col2Rate : 24.99,
    col3Rate : 27.99,
    col4Rate : 29.99
  }]
  return data;
};

//Calculate Repayment
const calculate = (quote) =>
  new Promise((resolve, reject) => {

    let res = {
      commissions: QuoteCommons.resetResults(),
      messages: QuoteCommons.resetMessage()
    };
    let nafCalculations = getNetRealtimeNaf(quote);
    let nafCommission = getNafCommission(quote);
    // Prepare params
    const p = {
      lender: LENDER_QUOTING,
      productLoanType: quote.loanProduct,
      loanTypeDetail: quote.loanTypeDetail,
      totalAmount: nafCalculations,
      totalInsurance: QuoteCommons.calcTotalInsuranceIncome(quote),
      clientRate: quote.clientRate,
      baseRate: quote.baseRate,
      paymentType: quote.paymentType,
      term: quote.term,
      dof: quote.dof,
      monthlyFee: quote.monthlyFee,
      residualValue: quote.residual,
      netDeposit: quote.netDeposit,
      vehiclePrice: quote.price,
      nafCommission: nafCommission
    };

    console.log('tobeCalculated>>', JSON.stringify(p, null, 2))

    getFinanceOneRate({
      param: p
    })
      .then((financeOneRates) => {
        // Validate quote

        res.messages = Validations.validate(quote, financeOneRates, lenderSettings, nafCalculations, res.messages);
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
              res.messages.errors.push({ field: "calculation", message: error });
              reject(res);
            });
        }

      })
      .catch((error) => {
        res.messages.errors.push({ field: "calculation", message: error });
        reject(res);
      });
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
  baseRates: getMyBaseRates,
  getRiskCalc: getRiskCalc,
  getAppFeeCalc: getAppFeeCalc,
  getDOFCalc: getDOFCalc,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  RISK_FEE_FIELDS: RISK_FEE_FIELDS,
  DOF_Calc_Fields: DOF_Calc_Fields,
  APPFEE_Calc_Fields: APPFEE_Calc_Fields,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  tableRateDataColumns: tableRateDataColumns,
  getNetRealtimeNaf: getNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail
};