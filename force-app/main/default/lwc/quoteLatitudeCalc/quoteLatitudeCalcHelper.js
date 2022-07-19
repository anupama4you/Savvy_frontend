import getQuotingData from "@salesforce/apex/quoteLatitudeCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let allTableRatesData = { 'Diamond Plus': null, 'Diamond': null, 'Sapphire': null, 'Ruby': null, 'Emerald': null };
let rates3List = [];
let riskGradeOptionsData = [];
// all table types defined
let formattedTableData = [];

const TABLE_DATA_COLUMNS = [
  { label: "0 - 3 years", fieldName: "comm1" },
  { label: "% NAF", fieldName: "comm2" },
  { label: "4 - 7 years", fieldName: "comm3" },
  { label: "% NAF", fieldName: "rate1" },
  { label: "7 years", fieldName: "rate2" },
  { label: "% NAF", fieldName: "rate3" },
];

const LENDER_QUOTING = "Latitude";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["price", "Vehicle_Price__c"],
  ["vehicleType", "Goods_type__c"],
  ["carAge", "Vehicle_Age__c"],
  ["vehCon", "Vehicle_Condition__c"],
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
]);

const RATE_SETTING_NAMES = ["LatitudeRatesv3__c"];

const SETTING_FIELDS = new Map([
  ["monthlyFee", "Monthly_Fee__c"],
  ["ppsr", "PPSR__c"],
  ["applicationFee", "Application_Fee__c"],
  ["registrationFee", "Registration_Fee__c"]
]);

const BASE_RATE_FIELDS = [
  "customerProfile",
  "loanTypeDetail",
  "carAge",
  "vehicleType"
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
    { label: "0", value: "0" },
    { label: "1", value: "1" },
    { label: "2", value: "2" },
    { label: "3", value: "3" },
    { label: "4", value: "4" },
    { label: "5", value: "5" },
    { label: "6", value: "6" },
    { label: "7", value: "7" },
    { label: "8", value: "8" },
    { label: "9", value: "9" },
    { label: "10", value: "10" },
    { label: "11", value: "11" },
    { label: "12", value: "12" },
    { label: "13", value: "13" },
    { label: "14", value: "14" },
    { label: "15+", value: "15" }
  ],
  securedUnsecured: [
    { label: "Secured", value: "Secured" },
    { label: "Unsecured", value: "Unsecured" }
  ],
  vehicleTypes: [
    { label: "--None--", value: "" },
    { label: "Car", value: "CAR" },
    { label: "Car (Van Light Commercial)", value: "VAN_LIGHT_COMMERCIAL" },
    { label: "Car (Minibus)", value: "MINIBUS" },
    { label: "Car (Utility)", value: "UTILITY" },
    { label: "Car (Station Wagon or 4WD)", value: "STATION_WAGON_OR_4WD" },
    { label: "Motorbike", value: "MOTORBIKE" },
    { label: "Boats (or Personal Watercraft)", value: "BOAT" },
    { label: "Caravan", value: "CARAVAN" },
    { label: "Motorhome", value: "MOTORHOME" },
    { label: "Camper Trailer", value: "TRAILER" }
  ],
  classes: [
    { label: "Diamond Plus", value: "Diamond Plus" },
    { label: "Diamond", value: "Diamond" },
    { label: "Sapphire", value: "Sapphire" },
    { label: "Ruby", value: "Ruby" },
    { label: "Emerald", value: "Emerald" }
  ],
  vehicleConditions: [
    { label: "--None--", value: "" },
    { label: "New", value: "NEW" },
    { label: "Demo", value: "DEMO" },
    { label: "Used", value: "USED" }
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
    vehicleType: calcOptions.vehicleTypes[0].value,
    carAge: calcOptions.vehicleAges[0].value,
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
    dof: null,
    maxDof: null,
    residual: null,
    term: calcOptions.terms[0].value,
    privateSales: calcOptions.privateSales[1].value,
    paymentType: calcOptions.paymentTypes[0].value,
    loanTypeDetail: calcOptions.classes[0].value,
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
    const profile = quote.category;
    const p = {
      lender: LENDER_QUOTING,
      customerProfile: profile,
      loanTypeDetail: quote.loanTypeDetail,
      goodsType: quote.category,
      carAge: quote.carAge,
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

// Get Single table out using #category and #class
const getSingleTable = (category, class_) => {

  let fieldsList = { "comm1": [], "comm2": [], "comm3": [], "rate1": [], "rate2": [], "rate3": [] }

  if (category) {
    // devide the data into categories
    tableRatesData.forEach((obj, key, map) => {

      if (obj.Category__c === category) {
        if (obj.Class__c === class_) {
          console.log(`getSingleTable...`, JSON.stringify(obj, null, 2));

          if (obj.Asset_Age__c == '0 - 3 years') {
            fieldsList.comm1.push(obj.Rate__c);
            fieldsList.comm2.push(obj.Comm__c);
          } else if (obj.Asset_Age__c == '4 - 7 years') {
            fieldsList.comm3.push(obj.Rate__c);
            fieldsList.rate1.push(obj.Comm__c);
          } else if (obj.Asset_Age__c == '> 7 years') {
            fieldsList.rate2.push(obj.Rate__c);
            fieldsList.rate3.push(obj.Comm__c);
          }
        }
      }
    });

    console.log(`fieldsList...`, JSON.stringify(fieldsList, null, 2));

    const singleTable = [];

    for (let j = 0; j < 9; j++) {

      const row = {
        "comm1": Object.values(fieldsList)[0][j],
        "comm2": Object.values(fieldsList)[1][j],
        "comm3": Object.values(fieldsList)[2][j],
        "rate1": Object.values(fieldsList)[3][j],
        "rate2": Object.values(fieldsList)[4][j],
        "rate3": Object.values(fieldsList)[5][j],
      }
      singleTable.push(row);
    }
    return singleTable;
  } else {
    return [];
  }
};

// Get all tables data
const getAllTableData = (category) => {
  // empty the array
  formattedTableData.splice(0, formattedTableData.length);
  // diamond plus
  formattedTableData.push({ data: getSingleTable(category, calcOptions.classes[0].value), colName: calcOptions.classes[0].value });
  // diamond 
  formattedTableData.push({ data: getSingleTable(category, calcOptions.classes[1].value), colName: calcOptions.classes[1].value });
  // Sapphire
  formattedTableData.push({ data: getSingleTable(category, calcOptions.classes[2].value), colName: calcOptions.classes[2].value });
  // Ruby
  formattedTableData.push({ data: getSingleTable(category, calcOptions.classes[3].value), colName: calcOptions.classes[3].value });
  // Emerald
  formattedTableData.push({ data: getSingleTable(category, calcOptions.classes[4].value), colName: calcOptions.classes[4].value });
  return formattedTableData;
};

// custom calculations for NAF generations
const calcNetRealtimeNaf = (quote) => {
  let netRealtimeNaf = QuoteCommons.calcNetRealtimeNaf(quote);
  console.log('realtimeNAF::', netRealtimeNaf);
  let r = quote.registrationFee + netRealtimeNaf;
  return r;
}

const calcDOF = (quote) => {
  quote.dof = 0;
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
  return r.toFixed(2);
}

export const CalHelper = {
  options: calcOptions,
  calculate: calculate,
  load: loadData,
  reset: reset,
  baseRates: getMyBaseRates,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  lenderSettings: lenderSettings,
  getSingleTable: getSingleTable,
  TABLE_DATA_COLUMNS: TABLE_DATA_COLUMNS,
  getNetRealtimeNaf: calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  getQuoteFees: getQuoteFees,
  getDOF: calcDOF,
  DOF_CALC_FIELDS: DOF_CALC_FIELDS,
  getAllTableData: getAllTableData
};