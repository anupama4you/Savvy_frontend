import getQuotingData from "@salesforce/apex/QuoteAmmfCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import save from "@salesforce/apex/QuoteAmmfCalcController.save";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let realtimeNaf = 0.0;
// all table types defined
let formattedTableData = [];

const TABLE_DATA_COLUMNS = [
  { label: "Customer Profile", fieldName: "Profile__c", cellAttributes: { alignment: 'left' }},
  { label: "Under $35,000+", fieldName: "Rate_1__c", cellAttributes: { alignment: 'center' } },
  { label: "Over $35,000", fieldName: "Rate_2__c", cellAttributes: { alignment: 'center' } },
  { label: "$500,000 - $999,999", fieldName: "Rate_3__c", cellAttributes: { alignment: 'center' } },
];

const LENDER_QUOTING = "Yamaha Marine";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["loanTypeDetail", "Loan_Facility_Type__c"],
  ["assetType", "Goods_type__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["residual", "Residual_Value__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["privateSales", "Private_Sales__c"],
  ["assetAge", "Customer_Profile__c"],
  ["paymentType", "Payment__c"],
  ["maxRate", "Base_Rate__c"],
  ["baseRate", "Base_Rate__c"],
  ["clientRate", "Client_Rate__c"],
  ["realtimeNaf", "NAF__c"],
  ["netDeposit", "Net_Deposit__c"],
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([["Id", "Id"], ...QUOTING_FIELDS]);

const RATE_SETTING_NAMES = ["YamahaRatesV2__c"];

const SETTING_FIELDS = new Map([
  ["monthlyFee", "Monthly_Fee__c"],
  ["ppsr", "PPSR__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "DOF__c"],
]);

const BASE_RATE_FIELDS = [
  "loanTypeDetail",
  "assetAge",
  "privateSales",
  "dof",
  "price",
  "ppsr",
  "netDeposit",
  "applicationFee",
  "deposit",
  "tradeIn",
  "payoutOn"
];

const DOF_CALC_FIELDS = [
  "dof"
];

const calculate = (quote) =>
  new Promise((resolve, reject) => {
    console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
    let res = {
      commissions: QuoteCommons.resetResults(),
      messages: QuoteCommons.resetMessage()
    };
    console.log(`Calculating repayments...`, JSON.stringify(res, null, 2));
    // Validate quote
    res.messages = Validations.validate(quote, res.messages, false);
    console.log(`Calculating repayments...`, JSON.stringify(res, null, 2));
    if (res.messages && res.messages.errors.length > 0) {
      reject(res);
    } else {
      console.log('quote::', quote)
      // new total calculated amount
      const totalAmount = calcNetRealtimeNaf(quote);
      // commRate is constant for eastimated Commission
      const commR = getYamahaCommission(quote);
      const p = {
        lender: LENDER_QUOTING,
        productLoanType: quote.loanProduct,
        customerProfile: quote.assetAge,
        privateSales: quote.privateSales,
        totalAmount: totalAmount,
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        clientRate: quote.clientRate,
        baseRate: quote.baseRate,
        maxRate: quote.maxRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residual,
        registrationFee: quote.registrationFee,
        loanTypeDetail: quote.loanTypeDetail,
        carPrice: quote.price,
        commRate: commR
      };

      // Calculate
      console.log(`@@param:`, JSON.stringify(p, null, 2));
      calculateRepayments({
        param: p
      })
        .then((data) => {
          console.log(`@@SF:`, JSON.stringify(data, null, 2));

          // Mapping
          res.commissions = QuoteCommons.mapCommissionSObjectToLwc(data);
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

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: CommonOptions.fullLoanProducts,
  loanTypeDetails1: [
    { label: "--None--", value: "" },
    { label: "Prime Plus", value: "Prime Plus" },
    { label: "Prime", value: "Prime" },
    { label: "Standard", value: "Standard" },
    { label: "Limited", value: "Limited" }
  ],
  loanTypeDetails2: [
    { label: "--None--", value: "" },
    { label: "Commercial", value: "Commercial" }
  ],
  privateSales: CommonOptions.yesNo,
  vehicleAges: [
    { label: "New", value: "New" },
    { label: "Used", value: "Used" }
  ],
  assetTypes: [
    { label: "--None--", value: "" },
    { label: "Motorcycle", value: "Motorcycle" },
    { label: "Boat", value: "Boat" },
    { label: "JetSki", value: "JetSki" }
  ],
  terms: CommonOptions.terms(12, 84)
};

// Reset
const reset = (recordId) => {
  let r = {
    oppId: recordId,
    quoteName: LENDER_QUOTING,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    category: null,
    assetType: calcOptions.assetTypes[0].value,
    assetAge: calcOptions.vehicleAges[0].value,
    vehCon: '',
    monthlyFee: null,
    ppsr: null,
    applicationFee: null,
    registrationFee: null,
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: 0.0,
    price: null,
    deposit: null,
    tradeIn: null,
    payoutOn: null,
    maxApplicationFee: null,
    dof: 0.0,
    maxDof: null,
    residual: null,
    term: calcOptions.terms[4].value,
    privateSales: calcOptions.privateSales[1].value,
    paymentType: calcOptions.paymentTypes[0].value,
    loanTypeDetail: calcOptions.loanTypeDetails1[0].value,
    commissions: QuoteCommons.resetResults(),
    registrationFee: 3.40
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
      ...QuoteCommons.COMMISSION_FIELDS.values()
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

        console.log('lenderSettings:::', JSON.stringify(lenderSettings, null, 2))

        // Rate Settings
        if (quoteData.rateSettings) {
          tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
          // console.log(`@@tableData:`, JSON.stringify(tableRatesData, null, 2));
        }
        console.log(`@@data:`, JSON.stringify(data, null, 2));
        resolve(data);
      })
      .catch((error) => reject(error));
  });

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    console.log(`quote inserted...`, JSON.stringify(quote, null, 2));
    const p = {
      lender: LENDER_QUOTING,
      customerProfile: quote.assetAge,
      loanTypeDetail: quote.loanTypeDetail,
      totalAmount: calcNetRealtimeNaf(quote),
      privateSales: quote.privateSales,
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

// Get Quote Fees
const getQuoteFees = (quote) => {
  if ('Secured' === quote.securedUnsecured) {
    quote.ppsr = lenderSettings.PPSR__c;
    quote.registrationFee = lenderSettings.Registration_Fee__c;
  } else if ('Unsecured' === quote.securedUnsecured) {
    quote.ppsr = 0.00;
    quote.registrationFee = 0.00;
  }
  return quote;
}


// Get all tables data
const getAllTableData = () => {
  console.log(`@@tableData:`, JSON.stringify(tableRatesData, null, 2));
  let row = [];
  tableRatesData.forEach((obj, index, map) => {
    calcOptions.loanTypeDetails1.forEach((profile, index, map) => {
      if (profile.value === obj['Profile__c']) {
        row.push({
          'Profile__c': profile.value,
          'Rate_1__c': `${(obj['Rate_1__c'] - 2).toFixed(2)}% - ${obj['Rate_1__c']}%`,
          'Rate_2__c': `${(obj['Rate_2__c'] - 2).toFixed(2)}% - ${obj['Rate_2__c']}%`,
          'Rate_3__c': `${(obj['Rate_3__c'] - 2).toFixed(2)}% - ${obj['Rate_3__c']}%`,
        })
      } 
    })
    if (obj['Profile__c'] === 'Commercial') {
      row.push({
        'Profile__c': 'Commercial',
        'Rate_1__c': `${obj['Rate_1__c']}%`,
        'Rate_2__c': `${obj['Rate_2__c']}%`
      })
    }
  });
  console.log(`@@table:`, JSON.stringify(row, null, 2));
  return row;
};

// custom calculations for NAF generations
const calcNetRealtimeNaf = (quote) => {
  let realtimeNaf = QuoteCommons.calcNetRealtimeNaf(quote);
  return realtimeNaf;
}

// Yamaha Commission Rate 
const getYamahaCommission = (quote) => {
  let r = 0.0;
  if (quote.maxRate != null && quote.baseRate != null && quote.clientRate != null) {
    if ('Commercial' === quote.loanTypeDetail) {
      r = 5.0;
    } else {
      r = 5.0;
      let d =
        (Math.abs(quote.maxRate - quote.baseRate) -
        Math.abs(quote.clientRate - quote.baseRate)) * 100;
      let f = 1.0;
      if (d >= 1 && d <= 20) {
        f = 0.9;
      } else if (d >= 21 && d <= 40) {
        f = 0.8;
      } else if (d >= 41 && d <= 60) {
        f = 0.7;
      } else if (d >= 61 && d <= 80) {
        f = 0.6;
      } else if (d >= 81 && d <= 100) {
        f = 0.5;
      } else if (d >= 101 && d <= 120) {
        f = 0.4;
      } else if (d >= 121 && d <= 140) {
        f = 0.3;
      } else if (d >= 141 && d <= 160) {
        f = 0.2;
      } else if (d >= 161 && d <= 180) {
        f = 0.1;
      } else if (d >= 181) {
        f = 0.0;
      }
      r *= f;
    }
  }
  return r;
}

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
  calculate: calculate,
  load: loadData,
  reset: reset,
  baseRates: getMyBaseRates,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  lenderSettings: lenderSettings,
  TABLE_DATA_COLUMNS: TABLE_DATA_COLUMNS,
  getNetRealtimeNaf: calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  getQuoteFees: getQuoteFees,
  DOF_CALC_FIELDS: DOF_CALC_FIELDS,
  getAllTableData: getAllTableData,
  saveQuote: saveQuote,
  sendEmail: sendEmail
};