import getQuotingData from "@salesforce/apex/QuoteLibertyLeisureCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import save from "@salesforce/apex/QuoteLibertyLeisureCalcController.save";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let applicationFee = 0.0;
let lenderSettings = {};
let tableRatesData = [];
// API Responses
let apiResponses = {};
let riskGradeOptionsData = [];
let TABLE_DATA_COLUMNS = [
  { label: "Vehicle Age", fieldName: "Vehicle_Age__c" },
  { label: "AAA", fieldName: "Rate__c1" },
  { label: "AA", fieldName: "Rate__c2" },
  { label: "A+", fieldName: "Rate__c3" },
];

const LENDER_QUOTING = "Liberty Leisure";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["assetType", "Goods_type__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["eqfee", "Risk_Fee__c"],
  ["residualValue", "Residual_Value__c"],
  ["term", "Term__c"],
  ["propertyOwner", "Customer_Profile__c"],
  ["riskGrade", "Client_Tier__c"],
  ["vehicleAge", "Vehicle_Age__c"],
  ["creditScore", "Vedascore__c"],
  ["enquiries", "Enquiries__c"],
  ["ltv", "LTV__c"],
  ["paymentType", "Payment__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["clientRate", "Client_Rate__c"],
  ["loanPurpose", "Loan_Purpose__c"],
  ["applicationId", "Application__c"],
  ["netDeposit", "Net_Deposit__c"],
  ["baseRate", "Base_Rate__c"],
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([...QUOTING_FIELDS, ["Id", "Id"]]);

const RATE_SETTING_NAMES = ["LibertyRates__c"];

const SETTING_FIELDS = new Map([
  // ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["registrationFee", "Registration_Fee__c"]
]);

const BASE_RATE_FIELDS = [
  "loanProduct",
  "riskGrade",
  "vehicleAge",
  "residualValue",
  "assetType"
];

const DOF_CALC_FIELDS = [
  "applicationFee"
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
    // Additional variables needed for validations
    const settings = lenderSettings;
    res.messages = Validations.validate(quote, settings, res.messages, false);
    console.log(`Calculating repayments...`, JSON.stringify(res, null, 2));
    if (res.messages && res.messages.errors.length > 0) {
      reject(res);
    } else {
      console.log('quote::', quote)
      // Prepare params
      const profile = quote.securedUnsecured === "Secured" ? "Secured" : "Unsecured";
      // new total calculated amount
      const totalAmount = calcTotalAmount(quote);
      // commRate is constant for eastimated Commission
      const commR = 2.25;
      const p = {
        lender: LENDER_QUOTING,
        productLoanType: quote.loanProduct,
        customerProfile: profile,
        totalAmount: totalAmount,
        // totalInsurance: QuoteCommons.calcTotalInsuranceIncome(quote),
        clientRate: quote.clientRate,
        baseRate: quote.baseRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residualValue,
        loanTypeDetail: quote.loanType,
        carPrice: quote.price,
        vehicleYear: quote.vehicleAge,
        clientTier: quote.riskGrade,
        commRate: commR
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

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: [
    { label: "Consumer Loan", value: "Consumer Loan" },
  ],
  propertyOwners: CommonOptions.yesNo,
  riskGrades: [
    { label: "AAA", value: "AAA" },
    { label: "AA", value: "AA" },
    { label: "A+", value: "A+" },
  ],
  vehicleAges: [
    { label: "New", value: "New" },
    { label: "Used 0-4 years", value: "0-4 years" },
    { label: "Used 5-9 years", value: "5-9 years" },
    { label: "Used 10+ years", value: "10+ years" }
  ],
  vehicleTypes: [
    { label: "Caravan", value: "Caravan" },
  ],
  securedUnsecured: [
    { label: "Secured", value: "Secured" },
    { label: "Unsecured", value: "Unsecured" }
  ],
  terms: CommonOptions.terms(12, 84)
};

// Reset
const reset = (recordId, appQuoteId = null) => {
  let r = {
    oppId: recordId,
    Id: appQuoteId,
    name: LENDER_QUOTING,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    assetType: calcOptions.vehicleTypes[0].value,
    riskGrade: calcOptions.riskGrades[0].value,
    vehicleAge: calcOptions.vehicleAges[0].value,
    price: null,
    deposit: null,
    tradeIn: null,
    payoutOn: null,
    applicationFee: null,
    maxApplicationFee: null,
    dof: null,
    maxDof: null,
    ppsr: null,
    eqfee: 0.0,
    residualValue: null,
    term: 60,
    monthlyFee: 0,
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: null,
    creditScore: null,
    ltv: null,
    propertyOwner: "N",
    paymentType: "Arrears",
    commissions: QuoteCommons.resetResults(),
    registrationFee: 3.4,
    loanTypeDetail: "AAA",
    securedUnsecured: "Secured",
    netDepsoit: 0.0,
    realtimeNaf: 0.0,
    commissions: QuoteCommons.resetResults(),
    insurance: { integrity: {} }
  };
  r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
  r.applicationFee = r.maxApplicationFee = applicationFee;
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
        // Settings
        lenderSettings = quoteData.settings;
        applicationFee =
          lenderSettings.Application_Fee__c + lenderSettings.DOF__c;
        let qd = reset(recordId);
        qd.applicationFee = applicationFee;
        console.log(`@@appFee:`, qd.applicationFee);

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
          mapTableData();
        }

        // API  responses
        apiResponses = quoteData.apiResponses;

        console.log("TableData:::", JSON.stringify(tableRatesData, null, 2));

        console.log(
          "lenderSettings:::",
          JSON.stringify(lenderSettings, null, 2)
        );

        console.log(`@@data:`, JSON.stringify(data, null, 2));
        data["lenderApplicationFee"] = lenderSettings.Application_Fee__c;
        data["maxApplicationFee"] = applicationFee;
        if (!data.Id) data["applicationFee"] = applicationFee;

        resolve(data);
      })
      .catch((error) => reject(error));
  });

// Map table data
const mapTableData = () => {

  // let grades = ['AAA', 'AA', 'A+']
  let finalObj = { 'New': [], '0-4 years': [], '5-9 years': [], '10+ years': [] }

  // categorization
  tableRatesData.forEach((obj, key, map) => {
    calcOptions.vehicleAges.forEach((age, age_key, map) => {
      calcOptions.riskGrades.forEach((grade, grade_key, map) => {

        if (obj['Vehicle_Age__c'] === age.value) {
          if (obj['Tier__c'] === grade.value) {
            finalObj[`${age.value}`].push(obj['Rate__c']);
          }
        }

      });
    });
  });

  let tableData = [];

  // Map into table format
  for (const property in finalObj) {
    tableData.push({
      'Vehicle_Age__c': property,
      'Rate__c1': finalObj[property][0],
      'Rate__c2': finalObj[property][1],
      'Rate__c3': finalObj[property][2]
    })
  }

  return tableData;
}

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const p = {
      lender: LENDER_QUOTING,
      productLoanType: quote.loanProduct,
      clientTier: quote.riskGrade,
      vehicleYear: quote.vehicleAge,
      residualValue: quote.residualValue,
      goodsType: quote.assetType,
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

  const getApiResponses = () => {
    return apiResponses;
  };

  const calcTotalAmount = (quote) => {
    let r = 0.0;
    if (quote) {
      r += quote.price > 0 ? quote.price : 0.0;
      r -= QuoteCommons.calcNetDeposit(quote);
      r += quote.applicationFee > 0 ? quote.applicationFee : 0.0;
      r += quote.ppsr > 0 ? quote.ppsr : 0.0;
    }
    let eqFee = calculateEQFee(quote, false);
    return r + eqFee;
  };

  // custom calculations for NAF generations
  const calcNetRealtimeNaf = (quote) => {
    let r = calcTotalAmount(quote);
    r += QuoteCommons.calcTotalInsuranceType(quote);
    return r;
  };

const calculateEQFee = (quote, excInsurances = false) => {
  let r = 0.0;
  let baseEqFee = getTotalAmountExcFees(quote);
  if (
    excInsurances !== true &&
    quote.insurance &&
    quote.insurance.iswarrantyAccept === true &&
    quote.insurance.warrantyRetailPrice > 0
  ) {
    baseEqFee += quote.insurance.warrantyRetailPrice;
  }
  if ("A+" === quote.riskGrade) {
    r = baseEqFee * 0.03;
  }
  return r;
};

const getTotalAmountExcFees = (quote) => {
  let r = quote.price > 0 ? quote.price : 0.0;
  r -= QuoteCommons.calcNetDeposit(quote);
  return r;
}

const calcDOF = (quote) => {
  return quote.applicationFee - lenderSettings.Application_Fee__c < 0
    ? 0.0
    : quote.applicationFee - lenderSettings.Application_Fee__c;
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
          reject(error);
          // reject(`error in saveApproval ${approvalType}: `, error.messages);
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
  tableRateDataColumns: TABLE_DATA_COLUMNS,
  getNetRealtimeNaf: calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  getDOF: calcDOF,
  getRealtimeEqFee: calculateEQFee,
  DOF_CALC_FIELDS: DOF_CALC_FIELDS,
  getTableRatesData: mapTableData,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
  getApiResponses: getApiResponses
};