import getQuotingData from "@salesforce/apex/QuoteLatitudePLCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import save from "@salesforce/apex/QuoteLatitudePLCalcController.save";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import {
  QuoteCommons,
  CommonOptions
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let tableRateDataColumns = [
  { label: "Risk Grade", fieldName: "Risk_Grade__c" },
  {
    label: "Secured", fieldName: "Secured__c", cellAttributes: {
      alignment: 'left'
    }
  },
  {
    label: "Unsecured", fieldName: "Unsecured__c", cellAttributes: {
      alignment: 'left'
    }
  },
];

const LENDER_QUOTING = "Latitude Personal Loan";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
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
  ["registrationFee", "Registration_Fee__c"],
  ["loanTypeDetail", "Loan_Facility_Type__c"],
  ["securedUnsecured", "Category_Type__c"],
  ["loanPurpose", "Loan_Purpose__c"],
  ["applicationId", "Application__c"],
  ["netDeposit", "Net_Deposit__c"],
  ["baseRate", "Base_Rate__c"],
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([["Id", "Id"], ...QUOTING_FIELDS]);

const RATE_SETTING_NAMES = ["LatitudePersonalRates__c"];

const SETTING_FIELDS = new Map([
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["maxDof", "Max_DOF__c"],
  ["ppsr", "PPSR__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["registrationFee", "Registration_Fee__c"]
]);

const BASE_RATE_FIELDS = [
  "customerProfile",
  "loanTypeDetail",
  "securedUnsecured"
];

const DOF_CALC_FIELDS = [
  "price",
  "deposit",
  "tradeIn",
  "payoutOn"
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
      // Prepare params
      const profile = quote.securedUnsecured === "Secured" ? "Secured" : "Unsecured";
      // new total calculated amount
      const totalAmount = calcNetRealtimeNaf(quote);
      // commRate is constant for eastimated Commission
      const commR = 2.25;
      const p = {
        lender: LENDER_QUOTING,
        productLoanType: quote.loanProduct,
        customerProfile: profile,
        privateSales: quote.privateSales,
        totalAmount: totalAmount,
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        clientRate: quote.clientRate,
        baseRate: quote.baseRate,
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
  securedUnsecured: [
    { label: "Secured", value: "Secured" },
    { label: "Unsecured", value: "Unsecured" }
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
    price: null,
    deposit: null,
    tradeIn: null,
    payoutOn: null,
    applicationFee: null,
    maxApplicationFee: null,
    dof: null,
    maxDof: null,
    ppsr: null,
    residual: null,
    term: 60,
    monthlyFee: null,
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: null,
    privateSales: "N",
    paymentType: "Arrears",
    commissions: QuoteCommons.resetResults(),
    registrationFee: 3.40,
    loanTypeDetail: "AAA",
    securedUnsecured: "Secured"
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
        }
        console.log(`@@data:`, JSON.stringify(data, null, 2));
        resolve(data);
      })
      .catch((error) => reject(error));
  });

const getRiskGradeOptions = () => {
  let riskGradeOptions = []
  if (tableRatesData) {
    for (const [key, obj] of Object.entries(tableRatesData)) {
      riskGradeOptions.push({ label: obj['Risk_Grade__c'], value: obj['Risk_Grade__c'] });
    }
  }
  return riskGradeOptions;
};

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const profile = quote.securedUnsecured === "Secured" ? "Secured" : "Unsecured";
    const p = {
      lender: LENDER_QUOTING,
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

const getTableRatesData = () => {
  console.log('table Data::', tableRatesData)

  return tableRatesData;
};

// custom calculations for NAF generations
const calcNetRealtimeNaf = (quote) => {
  let netRealtimeNaf = QuoteCommons.calcNetRealtimeNaf(quote);
  let r = quote.registrationFee + netRealtimeNaf;
  return r;
}

const calcDOF = (quote) => {
  let naf = QuoteCommons.calcNetRealtimeNaf(quote);
  let r = quote.registrationFee + naf;
  console.log('calcDOF', r)
  if (r > 20000) {
    r = 1650.00;
  } else if (r > 0) {
    r = r * 0.15;
    if (r >= 990) {
      r = 990.0;
    }
  } else {
    r = 0;
  }
  console.log('calcNetRealtimeDOF', r)
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
      console.log('test before save:::', QuoteCommons.mapLWCToSObject(
        param,
        recordId,
        LENDER_QUOTING,
        FIELDS_MAPPING_FOR_APEX
      ));
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
  getTableRatesData: getTableRatesData,
  tableRateDataColumns: tableRateDataColumns,
  getNetRealtimeNaf: calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  getQuoteFees: getQuoteFees,
  getRiskGradeOptions: getRiskGradeOptions,
  getDOF: calcDOF,
  DOF_CALC_FIELDS: DOF_CALC_FIELDS,
  saveQuote: saveQuote,
  sendEmail: sendEmail
};