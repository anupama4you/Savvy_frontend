import getQuotingData from "@salesforce/apex/QuoteAFSConsumerController.getQuotingData";
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
  { label: "Asset Type", fieldName: "Asset_Type__c", fixedWidth: 130 },
  { label: "Condition", fieldName: "Condition__c", fixedWidth: 130},
  { label: "Risk Grade", fieldName: "Risk_Grade__c", fixedWidth: 130 },
  { label: "% Base Rate", fieldName: "Base_Rate__c", fixedWidth: 140 },
  { label: "% Commission", fieldName: "Comm__c", fixedWidth: 150 }
];

const LENDER_QUOTING = "AFS Consumer";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["assetType", "Goods_type__c"],
  //["assetCondition", "Goods_type__c"], TO DO Check if fields is existing in Application_Quoting__c
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
  //["residency", ""], CLA TO DO - check IF has field Application_Quoting__c
  //["assetAge", ""], CLA TO DO - check IF has field Application_Quoting__c
  //["lvr", "LVR"], CLA TO DO - Create Field in Application_Quoting__c
  //["employmentStats", ""], CLA TO DO - check IF has field Application_Quoting__c
  //["creditImpaired", ""], CLA TO DO - check IF has field Application_Quoting__c
  //["payDayEnquiries", ""], CLA TO DO - check IF has field Application_Quoting__c
  //["imports", ""], CLA TO DO - check IF has field Application_Quoting__c
  //["odometerReading", ""], CLA TO DO - check IF has field Application_Quoting__c
  //["privateSales", ""], CLA TO DO - check IF has field Application_Quoting__c
  ["paymentType", "Payment__c"],
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
    const terms = CommonOptions.terms(12, 84);
    terms.forEach(function (item) {
    r.push({ label: item.label.toString(), value: item.value})
    });
    return r;
}

//return asset age options - TO DO AFTER load data
/*const getAssetAgeOptions = (formValues) => {
    let r = [];
    
    //for (let i = 0; i < 20; i++) {
      //let res = currentYear - i;
      //r.push({ label: res.toString(), value: res.toString()});  
    //}

    console.log(formValues.);
    return r;
};*/


const calcOptions = {
    loanTypes: CommonOptions.loanTypes,
    loanProducts: [
        { label: "Consumer Loan", value: "Consumer Loan" },
        { label: "Gold Club - Non-Property", value: "Gold Club - Non-Property" },
        { label: "Chattel Mortgage-Full-Doc", value: "Chattel Mortgage-Full-Doc" },
        { label: "Chattel Mortgage-Low-Doc", value: "Chattel Mortgage-Low-Doc" },
    ],
    assetTypes: [
        { label: "Car", value: "Car" },
        { label: "Bikes / Scooters", value: "Bikes / Scooters" },
        { label: "Boats / Personal Watercraft", value: "Boats / Personal Watercraft" },
        { label: "Caravans / Motorhomes", value: "Caravans / Motorhomes" },
    ],
    assetConditions: [
        { label: "New/Demo", value: "New/Demo" },
        { label: "Used", value: "Used" }
    ],
    terms: getTerms(),
    residency: [
        { label: "Property Owner", value: "Property Owner" },
        { label: "Renting", value: "Renting" },
        { label: "Living With Parents", value: "Living With Parents" },
        { label: "Employer Accommodation", value: "Employer Accommodation" },
        { label: "Boarding/Other", value: "Boarding/Other" },
    ],
    assetAges: [
        { label: "0-3 years", value: "0-3 years" },
        { label: "4-7 years", value: "4-7 years" },
        { label: "8-10 years", value: "8-10 years" },
        { label: "11-20 years", value: "11-20 years" },
        { label: "21+ years", value: "21+ years" },
    ],
    employmentStats: CommonOptions.yesNo,
    creditImpaireds: CommonOptions.yesNo,
    payDayEnqs: [
        { label: "Within last six months", value: "Within last six months" },
        { label: "Over 6 months ago", value: "Over 6 months ago" }
    ],
    imports: CommonOptions.yesNo,
    odometers: [
        { label: "<200,000", value: "<200,000" },
        { label: ">200,000", value: ">200,000" }
    ],
    privateSales: CommonOptions.yesNo,
    paymentTypes: CommonOptions.paymentTypes   
};

const reset = (recordId) => {
    let r = {
      oppId: recordId,
      loanType: calcOptions.loanTypes[0].value,
      loanProduct: null,
      assetType:null, //TO DO add logic base on Application
      assetCondition:null,
      price: null,
      deposit: null,
      tradeIn: null,
      payoutOn: null,
      netDeposit: 0.0,
      applicationFee: null, 
      dof: null,
      ppsr: null, 
      rrfee:null,
      residual: 0.0,
      term: 60,
      residency: null,
      assetAge: null,
      lvr: null,
      employmentStats:null,
      creditImpaired:null,
      payDayEnquiries:null,
      paymentType: "Arrears",
      imports:null,
      odometerReading:null,
      privateSales:"N",
      monthlyFee: null,
      //maxRate:0.0,
      //baseRate:0.0,
      clientRate:null,
      commissions: QuoteCommons.resetResults(),
      
    };
    r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
    console.log(`==> helper reset return r `, JSON.stringify(r));
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
    
    getQuotingData({
      param: {
        oppId: recordId,
        fields: fields,
        calcName: LENDER_QUOTING,
        rateSettings: RATE_SETTING_NAMES
      }
    })
      .then((quoteData) => {

        let data = QuoteCommons.mapSObjectToLwc({
          calcName: LENDER_QUOTING,
          defaultData: reset(recordId), 
          quoteData: quoteData,
          settingFields: SETTING_FIELDS,
          quotingFields: QUOTING_FIELDS
        });
        
        // Settings
        lenderSettings = quoteData.settings; 
        
        resolve(data);

      })
      .catch((error) => reject(error));
});

const getTableRatesData = () => {
  return tableRatesData;
};

export const CalHelper = {
    options: calcOptions,
    //getAssetAge: getAssetAgeOptions - TO DO After load data
    //calculate: calculate, 
    load: loadData,
    reset: reset, 
    //baseRates: getMyBaseRates, 
    BASE_RATE_FIELDS: BASE_RATE_FIELDS, 
    //lenderSettings: lenderSettings,
    getTableRatesData: getTableRatesData,
    tableRateDataColumns: tableRateDataColumns, 
    getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    /*saveQuote: saveQuote,
    sendEmail: sendEmail*/
};