import getQuotingData from "@salesforce/apex/QuoteAFSCommercialController.getQuotingData";
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

const LENDER_QUOTING = "AFS Commercial";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["netDeposit", "Net_Deposit__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  //["rrfee", ""], TO DO check IF has field Application_Quoting__c
  ["residual", "Residual_Value__c"],
  ["term", "Term__c"],
  //["carAge", ""], CLA TO DO - check IF has field Application_Quoting__c
  //["residency", ""], CLA TO DO - check IF has field Application_Quoting__c
  ["paymentType", "Payment__c"],
  //["gst", ""], CLA TO DO - check IF has field Application_Quoting__c
  ["monthlyFee", "Monthly_Fee__c"],
  ["clientRate", "Client_Rate__c"]
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

const RATE_SETTING_NAMES = ["GreenLightRates__c"];

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


//return term months
const getTerms = () => {
  let r = [];
  const terms = CommonOptions.terms(12, 72);
  terms.forEach(function (item) {
  r.push({ label: item.label.toString(), value: item.value})
  });
  return r;
}

const calcOptions = {
    loanTypes: CommonOptions.loanTypes,
    loanProducts: CommonOptions.fullLoanProducts,
    terms: getTerms(),
    carAges: [
      { label: "New - 6 years old", value: "New - 6 years old" },
      { label: "Used 7 years+", value: "Used 7 years+" }
    ],
    residency: [
        { label: "Home Buyer", value: "Home Buyer" },
        { label: "Non-Home Buyer", value: "Non-Home Buyer" }
    ],
    paymentTypes: CommonOptions.paymentTypes,
    gst: [
        { label: "Registered", value: "Registered" },
        { label: "Not Registered", value: "Not Registered" }
    ],
    
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
    //applicationFee: null, TO DO LENDER SETTINGS
    //dof: null, TO DO LENDER SETTINGS
    maxDof: null,
    //ppsr: null, TO DO LENDER SETTINGS
    //rrfee:null, TO DO LENDER SETTINGS
    residual: 0.0,
    term: 60,
    carAge: "New - 6 years old",
    residency: null,
    paymentType: "Arrears",
    gst: null,
    //monthlyFee: null, TO DO LENDER SETTINGS
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
        
        //console.log(`@@data:`, JSON.stringify(data, null, 2));
        resolve(data);

      })
      .catch((error) => reject(error));
});

export const CalHelper = {
    options: calcOptions,
    //calculate: calculate, 
    load: loadData,
    reset: reset,
    //baseRates: getMyBaseRates, 
    BASE_RATE_FIELDS: BASE_RATE_FIELDS, 
    //lenderSettings: lenderSettings,
    //getTableRatesData: getTableRatesData,
    //tableRateDataColumns: tableRateDataColumns, 
    getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    /*saveQuote: saveQuote,
    sendEmail: sendEmail*/
};