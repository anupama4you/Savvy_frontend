import getQuotingData from "@salesforce/apex/QuoteManager.getQuotingData";
//import getDefaultBrokerage from "@salesforce/apex/QuoteGreenLightController.getDefaultBrokeragePercentage";
import getBaseRates from "@salesforce/apex/QuoteManager.getBaseRates";
import getCalcFees from "@salesforce/apex/QuoteManager.getFees";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
//import getRateSetterRate from "@salesforce/apex/QuoteManager.getRateSetterRate";
import save from "@salesforce/apex/QuotePlentiPLController.save";
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
  { label: "Name", fieldName: "Name", type: "text" },
  { label: "Rate", fieldName: "Rate__c", type: "text" },
  { label: "Type", fieldName: "Type__c", type: "text" }
];

let tableRatesData2 = [];
const tableRateDataColumns2 = [
  {
    label: "Min",
    fieldName: "Min__c",
    type: "currency",
    typeAttributes: { minimumFractionDigits: 2, maximumFractionDigits: 2 }
  },
  {
    label: "Max",
    fieldName: "Max__c",
    type: "currency",
    typeAttributes: { minimumFractionDigits: 2, maximumFractionDigits: 2 }
  },
  {
    label: "6",
    fieldName: "X6__c",
    type: "currency",
    typeAttributes: { minimumFractionDigits: 2, maximumFractionDigits: 2 }
  },
  {
    label: "9",
    fieldName: "X9__c",
    type: "currency",
    typeAttributes: { minimumFractionDigits: 2, maximumFractionDigits: 2 }
  },
  {
    label: "12",
    fieldName: "X12__c",
    type: "currency",
    typeAttributes: { minimumFractionDigits: 2, maximumFractionDigits: 2 }
  },
  {
    label: "18",
    fieldName: "X18__c",
    type: "currency",
    typeAttributes: { minimumFractionDigits: 2, maximumFractionDigits: 2 }
  },
  {
    label: "24",
    fieldName: "X24__c",
    type: "currency",
    typeAttributes: { minimumFractionDigits: 2, maximumFractionDigits: 2 }
  },
  {
    label: "36",
    fieldName: "X36__c",
    type: "currency",
    typeAttributes: { minimumFractionDigits: 2, maximumFractionDigits: 2 }
  },
  {
    label: "48",
    fieldName: "X48__c",
    type: "currency",
    typeAttributes: { minimumFractionDigits: 2, maximumFractionDigits: 2 }
  },
  {
    label: "60",
    fieldName: "X60__c",
    type: "currency",
    typeAttributes: { minimumFractionDigits: 2, maximumFractionDigits: 2 }
  }
];

const LENDER_QUOTING = "RateSetter PL";

// - TODO: need to map more fields
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
  ["purposeType", "Purpose_Type__c"],
  ["loanPurpose", "Loan_Purpose__c"],
  ["additionalDetails", "Customer_Profile__c"],
  ["security", "Loan_Facility_Type__c"],
  ["riskFee", "Risk_Fee__c"]
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["privateSales", "Private_Sales__c"],
  ["clientTier", "Client_Tier__c"],
  ["baseRate", "Base_Rate__c"]
]);

const RATE_SETTING_NAMES = ["RateSetterPLRates__c", "RateSetterPLAppfee__c"];

const SETTING_FIELDS = new Map([
  ["monthlyFee", "Monthly_Fee__c"],
  ["ppsr", "PPSR__c"],
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "Max_DOF__c"]
]);

const BASE_RATE_FIELDS = [
  "assetType",
  "leaseAgreement",
  "clientTier",
  "vehicleYear",
  "customerProfile",
  "vehicleCondition",
  "greenCar",
  "term"
];

const CALC_FEES_FIELDS = [
  "price"
  /*"privateSales"
  "price", 
  "deposit",
  "tradeIn",
  "payoutOn"*/
];

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
    maxApplicationFee: 0.0,
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
    brokerage: 5,
    purposeType: "",
    security: calcOptions.securitys[1].value,
    additionalDetails: calcOptions.additionalDetails[0].value,
    riskFee: 0.0,
    loanPurpose: ""
  };
  r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
  return r;
};

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
        totalAmount: QuoteCommons.calcTotalAmount(quote) + quote.riskFee,
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
        clientRate: quote.clientRate,
        baseRate: quote.baseRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residual,
        customerProfile: quote.customerProfile,
        clientTier: quote.clientTier,
        productLoanType: quote.loanProduct,
        vehicleYear: quote.vehicleYear,
        privateSales: quote.privateSales,
        goodsType: quote.assetType,
        amountBaseComm: quote.price - QuoteCommons.calcNetDeposit(quote),
        commRate: quote.commRate
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

const currentYear = new Date().getFullYear();

//return vehicle year
const getVehicleYear = () => {
  let r = [];

  for (let i = 0; i < 13; i++) {
    let res = currentYear - i;
    r.push({ label: res.toString(), value: res.toString() });
  }
  return r;
};

//return term months
const getTerms = (min, max, interval) => {
  let r = [];
  for (let i = min; i < max + interval; ) {
    r.push({ label: i.toString(), value: i });
    i += interval;
  }
  return r;
};

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: CommonOptions.fullLoanProducts,
  assetTypes: [
    { label: "Car", value: "Car" },
    { label: "Caravan", value: "Caravan" }
  ],
  terms: [
    { label: 6, value: 6 },
    { label: 9, value: 9 },
    { label: 12, value: 12 },
    { label: 18, value: 18 },
    { label: 24, value: 24 },
    { label: 36, value: 36 },
    { label: 48, value: 48 },
    { label: 60, value: 60 },
    { label: 72, value: 72 },
    { label: 84, value: 84 }
  ],
  customerProfiles: [
    { label: "Property Owner", value: "Property Owner" },
    { label: "Non Property Owner", value: "Non Property Owner" }
  ],
  clientTiers: [
    { label: "Tier 1", value: "Tier 1" },
    { label: "Tier 2", value: "Tier 2" },
    { label: "Tier 3", value: "Tier 3" }
  ],
  vehicleConditions: [
    { label: "New", value: "new" },
    { label: "Demo", value: "demo" },
    { label: "Used", value: "used" }
  ],
  greenCars: CommonOptions.yesNo,
  vehicleYears: getVehicleYear(),
  leaseAgreements: CommonOptions.yesNo,
  privateSales: CommonOptions.yesNo,
  plentiAPIUsers: CommonOptions.apiUsers,
  purposeTypes: [
    { label: "-- None --", value: "" },
    { label: "Debt Consolidation", value: "DebtConsolidation" },
    { label: "Car", value: "Car" },
    { label: "Motorbike", value: "Motorbike" },
    { label: "Boat", value: "Boat" },
    { label: "Business", value: "Business" },
    { label: "Funeral Expenses", value: "FuneralExpenses" },
    { label: "Investment", value: "Investment" },
    { label: "Home Improvement", value: "HomeImprovement" },
    { label: "Holiday", value: "Holiday" },
    { label: "Medical Dental", value: "MedicalDental" },
    { label: "Moving Costs", value: "MovingCosts" },
    { label: "Pay Bills", value: "PayBills" },
    { label: "Payoff Loan", value: "PayoffLoan" },
    { label: "Professional ServiceFees", value: "ProfessionalServiceFees" },
    { label: "Rental Bond", value: "RentalBond" },
    { label: "Repairs", value: "Repairs" },
    { label: "Solar Battery", value: "SolarBattery" },
    { label: "Wedding", value: "Wedding" },
    { label: "Other", value: "Other" }
  ],
  securitys: [
    { label: "Secured", value: "Secured" },
    { label: "Unsecured", value: "Unsecured" }
  ],
  additionalDetails: [
    { label: "N/A", value: "N/A" },
    { label: "Self Employed", value: "Self Employed" },
    { label: "Business Purpose", value: "Business Purpose" }
  ]
};

// Load Data
const loadData = (recordId) =>
  new Promise((resolve, reject) => {
    //console.log('helper recordId ', recordId);
    //  const fields = Array.from(QUOTING_FIELDS.values());
    const fields = [
      ...QUOTING_FIELDS.values(),
      ...QuoteCommons.COMMISSION_FIELDS.values()
    ];
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
        //console.log(`@@SF:`, JSON.stringify(quoteData, null, 2));
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
        //console.log(`quoteData:`, JSON.stringify(quoteData, null, 10));
        //console.log(`quoted.rateSettings:`, JSON.stringify(quoteData.rateSettings));
        // Rate Settings
        if (quoteData.rateSettings) {
          tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
          tableRatesData2 = quoteData.rateSettings[`${RATE_SETTING_NAMES[1]}`];
        }
        //console.log(`@@data:`, JSON.stringify(data, null, 2));
        resolve(data);
      })
      .catch((error) => reject(error));
  });

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    console.log("==> getMyBaseRates params quote ", JSON.stringify(quote));
    const p = {
      lender: LENDER_QUOTING,
      assetType: quote.assetType,
      hasImports: quote.leaseAgreement,
      clientTier: quote.clientTier,
      vehicleYear: quote.vehicleYear,
      customerProfile: quote.customerProfile,
      condition: quote.vehicleCondition,
      greenCar: quote.greenCar,
      term: quote.term
    };
    console.log("==> getMyBaseRates param ", JSON.stringify(p));
    getBaseRates({
      param: p
    })
      .then((rates) => {
        console.log("==> getMyBaseRates rates ", JSON.stringify(rates));
        resolve(rates);
      })
      .catch((error) => reject(error));
  });

//get fees calculations
const calcFees = (quote) =>
  new Promise((resolve, reject) => {
    const p = {
      vehiclePrice: quote.price,
      lender: LENDER_QUOTING
    };
    console.log("==> getFeesCalculations fees var", JSON.stringify(p));
    getCalcFees({
      param: p,
      lenderSettings: null,
      onlyMax: false
    })
      .then((fees) => {
        console.log("==> getFeesCalculations fees ", JSON.stringify(fees));
        resolve(fees);
      })
      .catch((error) => reject(error));
  }); /*
{
  if(quote.privateSales == 'Y'){
    return lenderSettings.Application_Fee_Private__c;
  }else{
    return lenderSettings.Application_Fee__c;
  }
}*/

const getTableRatesData = () => {
  return tableRatesData;
};

const getTableRatesData2 = () => {
  return tableRatesData2;
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
  calcFees,
  calcFees,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  CALC_FEES_FIELDS: CALC_FEES_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  getTableRatesData2: getTableRatesData2,
  tableRateDataColumns: tableRateDataColumns,
  tableRateDataColumns2: tableRateDataColumns2,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail
};