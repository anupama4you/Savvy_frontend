import getQuotingData from "@salesforce/apex/QuoteFinanceOneCommController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteFinanceOneCommController.getBaseRates";
import getCommissionCalc from "@salesforce/apex/QuoteFinanceOneCommController.getCommission";
import getRiskFeeCalc from "@salesforce/apex/QuoteFinanceOneCommController.getRiskFeeCalc";
import getGoodsSubTypes from "@salesforce/apex/QuoteFinanceOneCommController.getGoodsSubTypes";
import getDofCalcu from "@salesforce/apex/QuoteFinanceOneCommController.getDofCalcu";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import getFinanceOneRate from "@salesforce/apex/QuoteFinanceOneCommController.getFinanceOneRate";
import getApplicationFeeCalc from "@salesforce/apex/QuoteFinanceOneCommController.getApplicationFeeCalc";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteFinanceOneCommController.save";

import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
//let goodsSubTypesList = [];
let goodsSubTypeCarlist = [];
let goodsSubTypeMotorBikelist = [];
let goodsSubTypeBoatlist = [];
let goodsSubTypeCaravanlist = [];

let tableRateDataColumns = [
  { label: "Category", fieldName: "Category__c", fixedWidth: 140, hideDefaultActions: true },
  { label: "Product - Base Rate", fieldName: "Product_Base_Rate__c", fixedWidth: 200, hideDefaultActions: true },
  { label: "Base Rate", fieldName: "Base_Rate__c", fixedWidth: 130, hideDefaultActions: true },
  { label: "Max Rate", fieldName: "Max_Rate__c", fixedWidth: 130, hideDefaultActions: true },
  { label: "Interest Rate", fieldName: "Interest_Rate__c", fixedWidth: 400, hideDefaultActions: true },
  { label: "Term", fieldName: "Term__c", fixedWidth: 140, hideDefaultActions: true },
  { label: "Maximum Amount", fieldName: "Maximun_Amount__c", fixedWidth: 200, hideDefaultActions: true }
];

const LENDER_QUOTING = "Finance One Commercial";

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
  ["brokerage", "Brokerage__c"],
  ["rateOption", "Rate_Options__c"],
  ["commission", "Extra_Value_1__c"]
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
  "brokerage",
  "loanProduct",
  "loanTypeDetail",
  "rateOption"
];

const COMM_FIELDS = [
  "netDeposit",
  "brokerage",
  "price",
  "deposit",
  "tradeIn",
  "payoutOn"
];

const RISK_FEE_FIELDS = [
  "netDeposit",
  "brokerage",
  "price",
  "loanTypeDetail"
];

const DOF_Calc_Fields = [
  "netDeposit",
  "price"
];

const APPFEE_Calc_Fields = [
  "loanProduct",
  "loanTypeDetail",
  "netDeposit"
];

//return asset age options 
const goodsSubTypeOptions = () => {
  let p = ['Motor Vehicle',
    'Motorbike',
    'Watercraft',
    'Recreational Asset'
  ];
  getGoodsSubTypes({ goodTypes: p })
    .then((res) => {

      if (res.length !== 0 && res !== null) {
        for (let key in res) {
          //mapData.push({value:data[key], key:key});
          if (key !== null && key === 'Car') {
            let mapData = [];
            res[key].forEach(function (item) {
              mapData.push({ label: item.label, value: item.value })
            });
            goodsSubTypeCarlist = mapData;

          }

          if (key !== null && key === 'Motorbike') {
            let mapData = [];
            res[key].forEach(function (item) {
              mapData.push({ label: item.label, value: item.value })
            });
            goodsSubTypeMotorBikelist = mapData;

          }

          if (key !== null && key === 'Boat') {
            let mapData = [];
            res[key].forEach(function (item) {
              mapData.push({ label: item.label, value: item.value })
            });
            goodsSubTypeBoatlist = mapData;

          }

          if (key !== null && key === 'Caravan') {
            let mapData = [];
            res[key].forEach(function (item) {
              mapData.push({ label: item.label, value: item.value })
            });
            goodsSubTypeCaravanlist = mapData;

          }
        }
      }
    })
    .catch(error => {
      console.log(error);
      this.error = error;
    });
  //return null;
};

//return term months
const getTerms = () => {
  let r = [];
  const terms = CommonOptions.terms(12, 84);
  terms.forEach(function (item) {
    r.push({ label: item.label.toString(), value: item.value })
  });
  return r;
}

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  loanProducts: CommonOptions.businessLoanProducts,
  goodTypes: [
    { label: "Car", value: "Car" },
    { label: "Motorbike", value: "Motorbike" },
    { label: "Boat", value: "Boat" },
    { label: "Caravan", value: "Caravan" },
    { label: "Truck", value: "Truck" },
    { label: "Equipment", value: "Equipment" }
  ],
  loanTypeDetails: [
    { label: "Platinum", value: "Platinum" },
    { label: "Gold", value: "Gold" },
    { label: "Silver", value: "Silver" }

  ],
  terms: getTerms(),
  propertyOwners: [
    { label: "--None--", value: "" },
    { label: "Yes", value: "Y" },
    { label: "No", value: "N" },
  ],
  rateOptions: CommonOptions.yesNo,
  paymentTypes: CommonOptions.paymentTypes
};

const reset = (recordId) => {
  let r = {
    oppId: recordId,
    name: LENDER_QUOTING,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    goodType: calcOptions.goodTypes[0].value,
    goodsSubType: '',
    loanTypeDetail: "Gold",
    price: null,
    deposit: null,
    tradeIn: null,
    payoutOn: null,
    dof: 0.0,
    maxDof: 0.0,
    residual: 0.0,
    term: 60,
    propertyOwner: '',
    residency: null,
    paymentType: "Arrears",
    baseRate: 0.0,
    maxRate: 0.0,
    riskFee: 0.0,
    calcRiskFee: 0.0,
    brokerage: 0.0,
    clientRate: 0.0,
    commission: 0.0,
    rateOption: 'N',
    commissions: QuoteCommons.resetResults(),
    insurance: { integrity: {} }
  };
  r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
  return r;
};

// Load Data
const loadData = (recordId) =>
  new Promise((resolve, reject) => {
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

const getTableRatesData = () => {
  return tableRatesData;
};

const getGoodsSubTypeOptions = (goodsType) => {
  let result = [];
  if (goodsType === 'Car') {
    result = goodsSubTypeCarlist;
  } else if (goodsType === 'Motorbike') {
    result = goodsSubTypeMotorBikelist;
  } else if (goodsType === 'Boat') {
    result = goodsSubTypeBoatlist;
  } else if (goodsType === 'Caravan') {
    result = goodsSubTypeCaravanlist;
  } 
  result.unshift({ label: "--None--", value: "" });
  return result;
};

// calculate NAF commission
const getNafCommission = (quote) => {
  let r = 0.0;
  r += quote.price;
  r -= QuoteCommons.calcNetDeposit(quote);
  return r;
}

//Get total naf calculations
const calcTotalAmount = (quote) => {
  let r = QuoteCommons.calcTotalAmount(quote);
  r += quote.riskFee > 0 ? quote.riskFee : 0;
  r += quote.commission > 0 ? quote.commission : 0;
  return r;
};

//Get total naf calculations
const getNetRealtimeNaf = (quote) => {
  let r = QuoteCommons.calcNetRealtimeNaf(quote);
  r += quote.riskFee > 0 ? quote.riskFee : 0;
  r += quote.commission > 0 ? quote.commission : 0;
  return r;
};

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {

    const p = {
      lender: LENDER_QUOTING,
      productLoanType: quote.loanProduct,
      loanTypeDetail: quote.loanTypeDetail,
      brokeragePer: quote.brokerage,
      hasMaxRate: true,
      interestType: quote.rateOption
    };

    getBaseRates({
      param: p
    })
      .then((rates) => {

        resolve(rates);
      })
      .catch((error) => reject(error));
  });

// Get Commission Calculations
const getFOCommission = (quote) =>
  new Promise((resolve, reject) => {
    const p = {
      netDeposit: quote.netDeposit,
      brokeragePer: quote.brokerage,
      vehiclePrice: quote.price
    };

    getCommissionCalc({
      param: p
    })
      .then((comm) => {
        resolve(comm);
      })
      .catch((error) => reject(error));
  });

// Get Risk Fee Calculations
const getRiskCalc = (quote) =>
  new Promise((resolve, reject) => {
    const p = {
      netDeposit: quote.netDeposit,
      brokeragePer: quote.brokerage,
      vehiclePrice: quote.price,
      loanTypeDetail: quote.loanTypeDetail
    };

    getRiskFeeCalc({
      param: p
    })
      .then((riskFee) => {
        resolve(riskFee);
      })
      .catch((error) => reject(error));
  });

// Get DOF and Max DOF Calculations
const getDOFCalc = (quote, isFullCalc) =>
  new Promise((resolve, reject) => {
    const p = {
      totalInsurance: QuoteCommons.calcTotalInsuranceType(quote, "Q"),
      vehiclePrice: quote.price,
      netDeposit: quote.netDeposit
    };

    getDofCalcu({
      param: p,
      fullCalc: isFullCalc
    })
      .then((dofs) => {
        resolve(dofs);
      })
      .catch((error) => reject(error));
  });

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
      totalAmount: calcTotalAmount(quote),
      // totalInsurance: QuoteCommons.calcTotalInsuranceIncome(quote),
      // totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
      clientRate: quote.clientRate,
      baseRate: quote.baseRate,
      paymentType: quote.paymentType,
      term: quote.term,
      dof: quote.dof,
      monthlyFee: quote.monthlyFee,
      residualValue: quote.residual,
      brokeragePer: quote.brokerage,
      netDeposit: quote.netDeposit,
      vehiclePrice: quote.price,
      nafCommission: nafCommission
    };

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
  getFOCommission: getFOCommission,
  getRiskCalc: getRiskCalc,
  getAppFeeCalc: getAppFeeCalc,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  COMM_FIELDS: COMM_FIELDS,
  RISK_FEE_FIELDS: RISK_FEE_FIELDS,
  DOF_Calc_Fields: DOF_Calc_Fields,
  APPFEE_Calc_Fields: APPFEE_Calc_Fields,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  getDOFCalc: getDOFCalc,
  tableRateDataColumns: tableRateDataColumns,
  getNetRealtimeNaf: getNetRealtimeNaf,
  goodsSubTypeOptions: goodsSubTypeOptions,
  getGoodsSubTypeOptions: getGoodsSubTypeOptions,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail
};