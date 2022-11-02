import getQuotingData from "@salesforce/apex/QuoteMoney3Controller.getQuotingData";
import profileOnChangeAction from "@salesforce/apex/QuoteMoney3Controller.profileOnChangeAction";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteMoney3Controller.save";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
// API Responses
let apiResponses = {};

const LENDER_QUOTING = "Money3 PL";

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
  ["paymentType", "Payment__c"],
  ["clientRate", "Client_Rate__c"],
  ["applicationId", "Application__c"],
  ["clientTier", "Client_Tier__c"],
  ["customerProfile", "Customer_Profile__c"],
  ["customerGrading", "Category_Type__c"],
  ["riskFee", "Risk_Fee__c"],
  ["loanPurpose", "Loan_Purpose__c"]
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["clientTier", "Client_Tier__c"],
  ["baseRate", "Base_Rate__c"],
  ["maxRate", "Manual_Max_Rate__c"]
]);

const RATE_SETTING_NAMES = ["Money3"];

const SETTING_FIELDS = new Map([
  ["monthlyFee", "Monthly_Fee__c"],
  ["ppsr", "PPSR__c"],
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "Max_DOF__c"]
]);

const BASE_RATE_FIELDS = ["customerGrading"];

const CALC_FEES_FIELDS = [
  "price",
  "deposit",
  "tradeIn",
  "payoutOn",
  "customerProfile",
  "customerGrading"
];

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
        // totalAmount: calculateRealTimeNaf(quote),
        totalAmount: calculateTotalAmount(quote),
        // totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceIncome(quote),
        clientRate: quote.clientRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residual,
        customerProfile: quote.customerProfile,
        riskGrade: quote.customerGrading,
        amountBaseComm: quote.price - QuoteCommons.calcNetDeposit(quote)
      };
      // Calculate
      console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
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
          // Validate for results
          res.messages = Validations.validatePostCalculation(
            res.commissions,
            res.messages
          );
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

//return term months
const getTerms = (min, max, interval) => {
  let r = [];
  for (let i = min; i < max + interval;) {
    r.push({ label: i.toString(), value: i });
    i += interval;
  }
  return r;
};

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: [{ label: "Consumer Loan", value: "Consumer Loan" }],
  assetTypes: [
    { label: "Car", value: "Car" },
    { label: "Caravan", value: "Caravan" }
  ],
  terms: CommonOptions.terms(24, 72),
  customerProfiles: [
    { label: "-- None --", value: null },
    { label: "Unsecured", value: "Unsecured" },
    { label: "Secured", value: "Secured" }
  ],
  vehicleConditions: [
    { label: "New", value: "new" },
    { label: "Demo", value: "demo" },
    { label: "Used", value: "used" }
  ],
  greenCars: CommonOptions.yesNo,
  // vehicleYears: getVehicleYear(),
  leaseAgreements: CommonOptions.yesNo,
  privateSales: CommonOptions.yesNo,
  customerGradings: [
    { label: "-- None --", value: null },
    { label: "Platinum 600+", value: "Platinum" },
    { label: "Gold 550+", value: "Gold" },
    { label: "Silver 500+", value: "Silver" },
    { label: "Bronze 100-499", value: "Bronze" }
  ],
  noneOption: [{ label: "-- None --", value: null }]
};

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
    maxDof: 0.0,
    ppsr: null,
    residual: 0.0,
    monthlyFee: null,
    term: 60,
    customerProfile: null,
    clientTier: null,
    vehicleCondition: null,
    greenCar: null,
    vehicleBuildDate: null,
    leaseAgreement: null,
    privateSales: "N",
    paymentType: "Arrears",
    maxRate: 0.0,
    baseRate: 0.0,
    clientRate: null,
    commissions: QuoteCommons.resetResults(),
    // brokerage: 5,
    riskFee: null,
    riskFeeTotal: 0.0,
    customerGrading: calcOptions.customerGradings[0].value,
    loanPurpose: "",
    // include insurance object if the calculator has the part
    insurance: { integrity: {} }
  };
  r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
  r.maxDof = 0.0;
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

        console.log(`@@data:`, JSON.stringify(data, null, 2));
        // Settings
        lenderSettings = quoteData.settings;
        // API  responses
        apiResponses = quoteData.apiResponses;
        // TODO: remove hard code value
        data.maxDof = 0.0;
        resolve(data);
      })
      .catch((error) => reject(error));
  });

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const p = {
      lender: LENDER_QUOTING,
      riskGrade: quote.customerGrading,
      customerProfile: quote.customerProfile
    };
    getBaseRates({
      param: p
    })
      .then((rates) => {
        console.log("rates >> ", JSON.stringify(rates));
        resolve(rates);
      })
      .catch((error) => reject(error));
  });

  const getApiResponses = () => {
    return apiResponses;
  };

const calculateParams = (quote, recordId) =>
  new Promise((resolve, reject) => {
    const params = QuoteCommons.mapLWCToSObject(
      quote,
      recordId,
      LENDER_QUOTING,
      FIELDS_MAPPING_FOR_APEX
    );
    params.data.NAF__c = calculateRealTimeNaf(quote);
    console.log("@params >> " + JSON.stringify(params, null, 2));
    profileOnChangeAction({
      quote: params,
      riskFeeBase: calcRiskFeeBase(quote) // riskFeeBase = getLoanAmount
    })
      .then((data) => {
        console.log("calculate params >> " + JSON.stringify(data, null, 2));
        resolve(data);
      })
      .catch((error) => {
        console.error(error);
        reject(error);
      });
  });

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

// re-write calculate total amount
const calculateRealTimeNaf = (quote) => {
  // const naf =
  //   QuoteCommons.calcNetRealtimeNaf(quote) +
  //   (quote.riskFee ? parseFloat(quote.riskFee) : 0);
  // console.log("naf >> " + naf);
  return (
    QuoteCommons.calcNetRealtimeNaf(quote) +
    (quote.riskFee ? parseFloat(quote.riskFee) : 0)
  );
};

const calculateTotalAmount = (quote) => {
  return (
    QuoteCommons.calcTotalAmount(quote) +
    (quote.riskFee ? parseFloat(quote.riskFee) : 0)
  );
};

// calculate money 3 risk fee
const getMoney3RiskFee = (quote) => {
  try {
    let r = 0.0;
    const rfBase = calcRiskFeeBase(quote);
    if (
      quote != null && 
      quote.customerProfile !== "Secured" &&
      rfBase > 12000
    ) {
      let rfRate = 0.0;
      if ("Platinum" === quote.customerGrading) {
        rfRate = 2.0;
      } else if ("Gold" === quote.customerGrading) {
        rfRate = 3.0;
      } else if ("Silver" === quote.customerGrading) {
        rfRate = 4.0;
      } else if ("Bronze" === quote.customerGrading) {
        rfRate = 4.5;
      }
      r = (rfBase * rfRate) / 100.0;
      r = (r > 995.0)? 995.0 : r;
    }
    return Number(r.toFixed(2));
  } catch (error) {
    console.error(error);
  }
};

const calcRiskFeeBase = (quote) => {
  try {
    let r = 0.0;
    r +=
      (quote.price ? quote.price : 0) -
      (quote.customerProfile === "Personal Finance" ? 0 : quote.netDeposit);
    return r;
  } catch (error) {
    console.error(error);
  }
};

const monthlyFeeCalc = (quote) => {
  return quote && quote.term >= 36? lenderSettings.Monthly_Fee__c : 0.0;
}

const renderTerms = (quote) => {
  try {
    let terms = getTerms(36, 60, 12);
    if (!quote) return terms;
    if (quote.customerProfile === "Personal Finance") {
      terms = getTerms(24, 36, 12);
    }
    if (
      quote.customerGrading === "Mini PL" &&
      quote.customerProfile === "Personal Finance"
    ) {
      terms = getTerms(12, 24, 12);
    }
    if (quote.customerGrading === "Secured") {
      terms = getTerms(24, 36, 12);
    }
    return terms;
  } catch (error) {
    console.error(error);
  }
};

export const CalHelper = {
  options: calcOptions,
  calculate: calculate,
  load: loadData,
  reset: reset,
  calculateParams: calculateParams,
  baseRates: getMyBaseRates,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  CALC_FEES_FIELDS: CALC_FEES_FIELDS,
  lenderSettings: lenderSettings,
  calculateRealTimeNaf: calculateRealTimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  getMoney3RiskFee: getMoney3RiskFee,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
  renderTerms: renderTerms,
  getApiResponses: getApiResponses,
  monthlyFeeCalc: monthlyFeeCalc
};