import getQuotingData from "@salesforce/apex/QuoteGrowAssetCarCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import { QuoteCommons, CommonOptions } from "c/quoteCommons";
import { Validations } from "./quoteValidations";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteGrowAssetCarCalcController.save";

// Default settings
let lenderSettings = {};
let AFRate1 = [], AFRate2 = [];
let AFRateCols1 = [
  { label: "Asset Type", fieldName: "Asset_type__c", fixedWidth: 300 },
  { label: "ABN", fieldName: "ABN__c", fixedWidth: 300 },
  { label: "Property Owner", fieldName: "Property_Owner__c", fixedWidth: 300 },
  { label: "Non Property Owner", fieldName: "Non_Property_Owner__c", fixedWidth: 300 },
];

let AFRateCols2 = [
  { label: "Asset Type", fieldName: "Asset_type__c", fixedWidth: 300 },
  { label: "ABN", fieldName: "ABN__c", fixedWidth: 300 },
  { label: "End of Term", fieldName: "End_of_Term__c", fixedWidth: 300 },
  { label: "Property Owner", fieldName: "Property_Owner__c", fixedWidth: 300 },
  { label: "Non Property Owner", fieldName: "Non_Property_Owner__c", fixedWidth: 300 },
];

const LENDER_QUOTING = "Grow Asset";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["assetType", "Goods_type__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["residualValue", "Residual_Value__c"],
  ["term", "Term__c"],
  ["paymentType", "Payment__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["creditScore", "Credit_Score__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["abnLength", "Extra_Label_1__c"],
  ["customerProfile", "Customer_Profile__c"],
  ["privateSales", "Private_Sales__c"],
  ["brokeragePercentage", "Brokerage__c"],
  ["baseRate", "Base_Rate__c"],
  ["clientRate", "Client_Rate__c"],
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["vehicleYear", "Vehicle_Age__c"],
]);

const RATE_SETTING_NAMES = ["AFRate1", "AFRate2"];

const SETTING_FIELDS = new Map([
  ["price", "Vehicle_Price__c"],
  ["dof", "DOF__c"],
  ["applicationFee", "Application_Fee__c"],
  ["applicationFeePrivate", "Application_Fee_Private__c"],
  ["ppsr", "PPSR__c"],
  ["residualValue", "Residual_Value__c"],
  ["monthlyFee", "Monthly_Fee__c"],
]);

const RESIDUAL_VALUE_FIELDS = [
  "residualValue",
  "residualValuePercentage",
  "typeValue",
  "price",
  "deposit",
  "tradeIn",
  "payoutOn"
];

const CLIENT_RATE_FIELDS = [
  "brokeragePercentage",
];

const BASE_RATE_FIELDS = [
  "assetAge",
  "abnLength",
  "assetType",
  "customerProfile",
];

const getBaseAmountPmtInclBrokerageCalc = (quote) => {
  let naf = QuoteCommons.calcNetRealtimeNaf(quote);
  let brokerage = quote.brokeragePercentage > 0? quote.brokeragePercentage : 0;
  console.log('get PMT...', naf + naf*brokerage/100);
  return naf + (naf*brokerage)/100;
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
      // Prepare params
      const p = {
        lender: LENDER_QUOTING,
        clientRate: quote.clientRate,
        amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
        term: quote.term,
        residualValue: quote.residualValue,
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
        paymentType: quote.paymentType,
        brokeragePer: quote.brokeragePercentage,
        amountBaseComm: quote.price - QuoteCommons.calcNetDeposit(quote),
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        baseRate: quote.baseRate,
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

  const createAssetAges = () => {
    let r = [];
    for (let i = 1; i < 20; i++) {
      r.push({ label: i.toString(), value: i.toString() });
    }
    return r;
  };

  const calcOptions = {
    loanTypes: CommonOptions.loanTypes,
    paymentTypes: CommonOptions.paymentTypes,
    propertyOwnerTypes: CommonOptions.yesNo, 
    assetTypes: [
      { label: "MV & Primary", value: "MV & Primary" },
      { label: "Secondary", value: "Secondary" },
      { label: "Tertiary", value: "Tertiary" },
    ],
    terms: [
      { label: 36, value: 36 },
      { label: 48, value: 48 },
      { label: 60, value: 60 },
    ],
    assetAges: createAssetAges(),
    abnTypes: [
      { label: "ABN 0-2", value: "ABN 0-2" },
      { label: "ABN 2+", value: "ABN 2+" },
      { label: "ABN no GST", value: "ABN no GST" },
    ],
    privateSales: [
      { label: "--None--", value: "" },
      { label: "Yes", value: "Y" },
      { label: "No", value: "N" }
    ],
    typeValues: [
      { label: "Percentage", value: "Percentage" },
      { label: "Value", value: "Value" },
    ]
  };

// Reset
const reset = (recordId) => {
  let r = {
    oppId : recordId,
    quoteName : LENDER_QUOTING,
    loanType: calcOptions.loanTypes[0].value,
    assetType: calcOptions.assetTypes[0].value,
    price: 0,
    deposit: 0,
    tradeIn: 0,
    payoutOn: 0,
    applicationFee: 0,
    dof: 0,
    ppsr: 0,
    residualValue: 0,
    term: 36,
    paymentType: "Advance",
    monthlyFee: 0,
    creditScore: "",
    assetAge: calcOptions.assetAges[0].value,
    customerProfile: calcOptions.propertyOwnerTypes[1].value,
    privateSales: "",
    brokeragePercentage: 6,
    baseRate: 0.0,
    abnLength: calcOptions.abnTypes[0].value,
    clientRate: "",
    commissions: QuoteCommons.resetResults()
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
      ...QuoteCommons.COMMISSION_FIELDS.values()
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
          AFRate1 = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
          AFRate2 = quoteData.rateSettings[`${RATE_SETTING_NAMES[1]}`];
          console.log('Helper line 269...', quoteData.rateSettings);
        }
        resolve(data);
      })
      .catch((error) => reject(error));
  });

const getTableRatesData1 = () => {
  return AFRate1;
}

const getTableRatesData2 = () => {
  return AFRate2;
}

const getResidualValue = (quote) => {
  return ((quote.price - QuoteCommons.calcNetDeposit(quote)) * quote.residualValuePercentage) / 100;
}

const getResidualPercentage = (quote) => {
  return (quote.residualValue / (quote.price - QuoteCommons.calcNetDeposit(quote))) * 100;
}

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const p = {
      lender: LENDER_QUOTING,
      abnLength: quote.abnLength,
      assetType: quote.assetType,
      assetAge: quote.assetAge,
      endOfTerm: quote.endOfTerm,
      customerProfile: quote.customerProfile,
      hasMaxRate: false
    };
    console.log(`getMyBaseRates...`, JSON.stringify(p, null, 2));
    getBaseRates({
      param: p
    })
      .then((rates) => {
        console.log(`@@SF:`, JSON.stringify(rates, null, 2));
        resolve({
          baseRate: rates.baseRate,
        });
      })
      .catch((error) => reject(error));
  });


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
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  RESIDUAL_VALUE_FIELDS: RESIDUAL_VALUE_FIELDS,
  CLIENT_RATE_FIELDS: CLIENT_RATE_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData1: getTableRatesData1,
  getTableRatesData2: getTableRatesData2,
  tableRateDataColumns1: AFRateCols1,
  tableRateDataColumns2: AFRateCols2,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
  getResidualValue: getResidualValue,
  getResidualPercentage: getResidualPercentage,
};