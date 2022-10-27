import getQuotingData from "@salesforce/apex/QuoteAffordableCLCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import { QuoteCommons, CommonOptions } from "c/quoteCommons";
import { Validations } from "./quoteValidations";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteAffordableCLCalcController.save";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let aclUpfrontLoanFees = [];
let tableRateDataColumns = [
  { label: "Credit Score", fieldName: "Profile__c", fixedWidth: 300 },
  { label: "Base Rate", fieldName: "Rate_1__c", fixedWidth: 300 },
  { label: "Max Rate", fieldName: "Rate_2__c", fixedWidth: 300 },
];

const LENDER_QUOTING = "Affordable";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["creditScore", "Credit_Score__c"],
  ["vehicleYear", "Vehicle_Age__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["netDeposit", "Net_Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["residualValue", "Residual_Value__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["repayment", "Loan_Frequency__c"],
  ["paymentType", "Payment__c"],
  ["baseRate", "Base_Rate__c"],
  ["maxRate", "Manual_Max_Rate__c"],
  ["clientRate", "Client_Rate__c"],
  ["riskFee", "Risk_Fee__c"],
  ["commissionType", "Commission_Type__c"],
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["vehicleYear", "Vehicle_Age__c"],
]);

const RATE_SETTING_NAMES = ["Rate Table", "Upfront Loan Fees"];

const SETTING_FIELDS = new Map([
  ["dof", "DOF__c"],
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["maxDof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["monthlyFee", "Monthly_Fee__c"],
]);


const RATES_AND_FEES_FIELDS = [
  "creditScore",
  "vehicleYear",
  "term",
  "clientRate",
  "price",
  "deposit",
  "tradeIn",
  "payoutOn",
  "dof"
];

const getTotalAmount = (quote) => {
  return QuoteCommons.calcNetRealtimeNaf(quote) + quote.riskFee;
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
    console.log('ling 73', res.messages);
    if (res.messages && res.messages.errors.length > 0) {
      reject(res);
      console.log('ling 76', res);
    } else {
      let affordableFees = getAffordableFees(quote.clientRate);
      // Prepare params
      const p = {
        lender: LENDER_QUOTING,
        totalAmount: QuoteCommons.calcTotalAmount(quote) + quote.riskFee,
        totalInsurance: QuoteCommons.calcTotalInsuranceIncome(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
        clientRate: quote.clientRate,
        term: quote.term,
        residualValue: quote.residualValue,
        commRate: affordableFees.Comm__c,
        baseRate: quote.baseRate,
        amountBaseComm: quote.price - QuoteCommons.calcNetDeposit(quote),
        commType: quote.commissionType,
        commPayable: quote.commissionPayable,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        paymentType: quote.paymentType,
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
          res.messages = Validations.validatePostCalculation(res.commissions, res.messages);
          resolve(res);
        })
        .catch((error) => {
          res.messages.errors.push({ field: "calculation", message: error });
          reject(res);
        });
    }
  });

const createVehicleYears = () => {
  let r = [];
  let today = new Date();
  let year = today.getFullYear();
  r.push({ label: "--None--", value: "" });
  for (let i = year; i >= (year - 15); i--) {
    r.push({ label: i.toString(), value: i.toString() });
  }
  return r;
};

const createClientRateOptions = (quote) => {
  let r = [];
  r.push({ label: "--None--", value: "" });
  if (quote.baseRate > 0 && quote.maxRate) {
    let baseRate = Number(quote.baseRate);
    let maxRate = Number(quote.maxRate);
    for (let i = baseRate; i <= maxRate; i += 0.25) {
      r.push({ label: i, value: i });
    }
  }
  return r;
};

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: CommonOptions.fullLoanProducts,
  terms: [
    { label: "--None--", value: "" },
    { label: 24, value: 24 },
    { label: 36, value: 36 },
    { label: 48, value: 48 },
    { label: 60, value: 60 },
  ],
  vehicleYears: createVehicleYears(),
  commissionTypes: [
    { label: "Calculated", value: "Calculated" },
    { label: "Manual", value: "Manual" },
  ],
  repaymentTypes: [
    { label: "--None--", value: "" },
    { label: "Weekly", value: "Weekly" },
    { label: "Fortnightly", value: "Fortnightly" },
  ],
  creditScores: [
    { label: "--None--", value: "" },
    { label: "500+", value: "500+" },
    { label: "400-499", value: "400-499" },
    { label: "300-399", value: "300-399" },
  ]
};

// Reset
const reset = (recordId) => {
  let r = {
    oppId: recordId,
    quoteName: LENDER_QUOTING,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    price: 0,
    applicationFee: 0,
    maxApplicationFee: 0,
    dof: 0,
    maxDof: 0,
    residualValue: 0,
    monthlyFee: 0,
    term: 60,
    creditScore: "",
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: "",
    paymentType: "Arrears",
    vehicleYear: "",
    repayment: "",
    commissionType: "Calculated",
    riskFeeTotal: 0,
    commissions: QuoteCommons.resetResults(),
    insurance: { integrity: {} }
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
      ...QuoteCommons.COMMISSION_FIELDS.values(),
      ...QuoteCommons.INSURANCE_FIELDS.values()
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
          aclUpfrontLoanFees = quoteData.rateSettings[`${RATE_SETTING_NAMES[1]}`];
          console.log('Helper line 256...', aclUpfrontLoanFees);
        }
        resolve(data);
      })
      .catch((error) => reject(error));
  });

// Get NAF for Affordable
const getNaf = (quote) => {
  return quote.price + quote.dof - QuoteCommons.calcNetDeposit(quote);
}
// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const p = {
      lender: LENDER_QUOTING,
      creditScore: quote.creditScore,
      vehicleYear: quote.vehicleYear,
      term: quote.term,
      hasMaxRate: true
    };
    console.log(`getMyBaseRates...`, JSON.stringify(p, null, 2));
    getBaseRates({
      param: p
    })
      .then((rates) => {
        console.log(`@@SF:`, JSON.stringify(rates, null, 2));
        console.log('calcRiskFee...');
        let myRate = (quote.clientRate === 0 || quote.clientRate === "") ? rates.maxRate : quote.clientRate;
        let riskFeeTotal = 0, maxApplicationFee = quote.maxApplicationFee, applicationFee = quote.applicationFee;
        let affordableFees = getAffordableFees(myRate);
        if (affordableFees.Establishment_Fee__c > 0 && affordableFees.Establishment_Fee__c != quote.maxApplicationFee) {
          maxApplicationFee = affordableFees.Establishment_Fee__c;
          if (quote.applicationFee === "" || quote.applicationFee === 0 || quote.applicationFee > maxApplicationFee) {
            applicationFee = maxApplicationFee;
          }
        }
        console.log('line 295', getNaf(quote));
        if (quote.term !== "") {
          riskFeeTotal = (myRate / 100 * affordableFees.Risk_Fee_Interest_Rate_Of_NAF__c / 100) * (quote.term / 12) * getNaf(quote);
        }
        resolve({
          maxRate: rates.maxRate,
          baseRate: rates.baseRate,
          maxApplicationFee: maxApplicationFee,
          applicationFee: applicationFee,
          riskFeeTotal: riskFeeTotal.toFixed(2)
        });
      })
      .catch((error) => reject(error));
  });

const getTableRatesData = () => {
  return tableRatesData;
};

const getAclUpfrontLoanFees = () => {
  return aclUpfrontLoanFees;
};

const getAffordableFees = (rate) => {
  let affordableFees = {};
  if (aclUpfrontLoanFees.length > 0) {
    aclUpfrontLoanFees.forEach(x => {
      if (rate >= x.Min_Interest_Rate__c && rate <= x.Max_Interest_Rate__c) {
        affordableFees = x;
      }
    });
  }
  return affordableFees;
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
  RATES_AND_FEES_FIELDS: RATES_AND_FEES_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  getAclUpfrontLoanFees: getAclUpfrontLoanFees,
  createClientRateOptions: createClientRateOptions,
  tableRateDataColumns: tableRateDataColumns,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
  getTotalAmount: getTotalAmount
};