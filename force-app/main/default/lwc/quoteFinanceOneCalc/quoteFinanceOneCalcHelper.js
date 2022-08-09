import getQuotingData from "@salesforce/apex/QuoteFinanceOneController.getQuotingData";
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
  { label: "Product - Base Rate", fieldName: "Product_Base_Rate__c", fixedWidth: 200 },
  { label: "Base Rate", fieldName: "Base_Rate__c", fixedWidth: 130 },
  { label: "Max Rate", fieldName: "Max_Rate__c", fixedWidth: 130 },
  { label: "Interest Rate", fieldName: "Interest_Rate__c", fixedWidth: 400 },
  { label: "Term", fieldName: "Term__c", fixedWidth: 140 },
  { label: "Maximum Amount", fieldName: "Maximun_Amount__c", fixedWidth: 200 } 
];

const LENDER_QUOTING = "Finance One";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  //["goodsSubType", ""],TO DO 
  //["goodsSubType", ""], TO DO
  //["loanTypeDetail", ""], TO DO
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  //["netDeposit", "Net_Deposit__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["dof", "DOF__c"],
  //["maxDof", ""],
  ["ppsr", "PPSR__c"],
  ["residual", "Residual_Value__c"],
  ["term", "Term__c"],
  //["propertyOwner", ""], CLA TO DO - check IF has field Application_Quoting__c
  ["paymentType", "Payment__c"],
  //["riskFee", ""], CLA TO DO - check IF has field Application_Quoting__c
  //["calcRiskFee", ""], CLA TO DO - check IF has field Application_Quoting__c
  ["monthlyFee", "Monthly_Fee__c"],
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

const RATE_SETTING_NAMES = ["FinanceOneRates__c"];

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
  const terms = CommonOptions.terms(12, 84);
  terms.forEach(function (item) {
  r.push({ label: item.label.toString(), value: item.value})
  });
  return r;
}

const calcOptions = {
    loanTypes: CommonOptions.loanTypes,
    loanProducts: [{ label: "Consumer Loan", value: "Consumer Loan" }],
    goodTypes: [
      { label: "Car", value: "Car" },
      { label: "Motorbike", value: "Motorbike" },
      { label: "Boat", value: "Boat" },
      { label: "Caravan", value: "Caravan" },
      { label: "Truck", value: "Truck" },
      { label: "Equipment", value: "Equipment" }
    ],
    goodsSubTypes: [ //TO DO after load data values base on loanType
      { label: "Option 1", value: "Option 1" },
      { label: "Option 2", value: "Option 2" }
    ],
    loanTypeDetails: [//TO DO after load data values base on loanType 
      { label: "Platinum", value: "Platinum" },
      { label: "Gold", value: "Gold" },
      { label: "Silver", value: "Silver" } 

    ],
    terms: getTerms(),
    propertyOwners: CommonOptions.yesNo,
    paymentTypes: CommonOptions.paymentTypes 
};

const reset = (recordId) => {
  console.log('==> helper reset');
  let r = {
    oppId: recordId,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    goodType: calcOptions.goodTypes[0].value,
    goodsSubType: null, //TO DO
    loanTypeDetail:"Gold",
    price: null,
    deposit: null,
    tradeIn: null,
    payoutOn: null,
    netDeposit: 0.0,
    applicationFee: null, //TO DO LENDER SETTINGS
    dof: null, //TO DO LENDER SETTINGS
    maxDof: null,
    ppsr: null, //TO DO LENDER SETTINGS
    residual: 0.0,
    term: 60,
    propertyOwner:null,
    carAge: "New - 6 years old",
    residency: null,
    paymentType: "Arrears",
    monthlyFee: null, //TO FO lender settings
    //gst: null,
    riskFee: null,//TO DO LENDER SETTINGS
    calcRiskFee:0.0,
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