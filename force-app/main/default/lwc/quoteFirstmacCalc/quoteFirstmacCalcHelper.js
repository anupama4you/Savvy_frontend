import getQuotingData from "@salesforce/apex/QuoteFirstmacController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuotePepperMVController.save";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
//import { Validations } from "./quoteValidations"; CLA TO DO

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let tableRateDataColumns = [
  { label: "Category", fieldName: "Category__c", fixedWidth: 140 },
  { label: "Home Owner", fieldName: "Home_Owner__c", fixedWidth: 170 },
  { label: "Rate", fieldName: "Rate__c", fixedWidth: 130 },
  { label: "Base Rate", fieldName: "Value__c", fixedWidth: 130 },
  { label: "Max Rate", fieldName: "Max_Rate__c", fixedWidth: 130 },
  { label: "Vehicle Year", fieldName: "Vehicle_Year__c", fixedWidth: 160 },
  { label: "Rate Type", fieldName: "Rate_Type__c", fixedWidth: 140 } 
];

const LENDER_QUOTING = "Firstmac";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["residual", "Residual_Value__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  //["category", ""], TO DO
  //["homeOwner", ""], CLA TO DO - check IF has field Application_Quoting__c
  //["loanTypeRD", ""], TO DO
  //["interestType", ""], TO DO
  //["vehicleYear", ""], TO DO
  ["paymentType", "Payment__c"],
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
  ["maxRate", "Manual_Max_Rate__c"]
]);

const RATE_SETTING_NAMES = ["FirstmacRate__c"];

const SETTING_FIELDS = new Map([
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  //["brokerage", "Brokerage_Base__c"], 
  ["monthlyFee", "Monthly_Fee__c"]
]);

const BASE_RATE_FIELDS = [
  "customerProfile",
  "clientTier", 
  "assetAge",
  "assetType",
  "privateSales"
];

const currentYear = (new Date()).getFullYear();

//return vehicle year
const getVehicleYear = () => {
    let r = [];
    
    for (let i = 0; i < 13; i++) {
      let res = currentYear - i;
      r.push({ label: res.toString(), value: res.toString()});  
    }
    return r;
};

//return term months
const getTerms = () => {
  let r = [];
  const terms = CommonOptions.terms(36, 72);
  terms.forEach(function (item) {
  r.push({ label: item.label.toString(), value: item.value})
  });
  return r;
}

const calcOptions = {
    loanTypes: CommonOptions.loanTypes,
    loanProducts: [{ label: "Consumer Loan", value: "Consumer Loan" }],
    terms: getTerms(),
    categories: [
        { label: "Standard", value: "Standard" },
        { label: "Edge", value: "Edge" }
    ],
    homeOwners: CommonOptions.yesNo,
    loanTypeRDs: [
        { label: "New Green Car", value: "New Green Car" },
        { label: "Prime Special Rate", value: "Prime Special Rate" },
        { label: "New and used < 5 years", value: "New and used < 5 years" },
        { label: "Used 6-7 years", value: "Used 6-7 years" },
        { label: "Used 8-12 years", value: "Used 8-12 years" }
    ],
    interestTypes: [
        { label: "Fixed", value: "Fixed" },
        { label: "Variable", value: "Variable" }
    ],
    vehicleYears: getVehicleYear(),
    paymentTypes: CommonOptions.paymentTypes 
};

const reset = (recordId) => {
  console.log('==> helper reset');
  let r = {
    oppId: recordId,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    price: null,
    deposit: null,
    tradeIn: null,
    payoutOn: null,
    netDeposit: 0.0,
    applicationFee: null, //TO DO LENDER SETTINGS
    dof: null, //TO DO LENDER SETTINGS
    residual: 0.0,
    monthlyFee: null, //TO FO lender settings
    term: 60,
    category: null,
    homeOwner: "N",
    loanTypeRD: null,
    interestType:null,
    vehicleYear:null,
    paymentType: "Arrears",
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: null,
    commissions: QuoteCommons.resetResults(),
    
  };
  r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
  console.log(`==> helper reset return r `, JSON.stringify(r));
  return r;
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
    console.log(`==> helper shoot here before controller callout `);
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
        console.log(`==> helper shoot here data `, JSON.stringify(data));
        console.log(`==> helper shoot here quoteData `, JSON.stringify(quoteData) );
        // Settings
        lenderSettings = quoteData.settings; 
        //console.log(`quoteData:`, JSON.stringify(quoteData, null, 10));
        //console.log(`quoted.rateSettings:`, JSON.stringify(quoteData.rateSettings));
        // Rate Settings
        if (quoteData.rateSettings) {
          tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
        }
        //console.log(`@@data:`, JSON.stringify(data, null, 2));
        resolve(data);

      })
      .catch((error) => reject(error));
});

const getTableRatesData = () => {
  return tableRatesData;
};

export const CalHelper = {
    options: calcOptions,
    //calculate: calculate, 
    load: loadData,
    reset: reset, 
    //baseRates: getMyBaseRates, 
    BASE_RATE_FIELDS: BASE_RATE_FIELDS, 
    lenderSettings: lenderSettings,
    getTableRatesData: getTableRatesData,
    tableRateDataColumns: tableRateDataColumns,
    getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    /*saveQuote: saveQuote,
    sendEmail: sendEmail*/
};