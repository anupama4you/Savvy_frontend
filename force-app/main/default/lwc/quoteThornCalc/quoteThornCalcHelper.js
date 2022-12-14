import getQuotingData from "@salesforce/apex/QuoteThornCalcController.getQuotingData";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteThornCalcController.save";

// Default settings
let lenderSettings = {};
let gacTier1 = [], gacTier2 = [], gacTier3 = [], gacAdd = [];
let tableRateDataColumns1 = [
  { label: "Asset age", fieldName: "Asset_age__c", fixedWidth: 300 },
  { label: "Asset backed", fieldName: "Asset_backed__c", fixedWidth: 300 },
  { label: "Non Asset backed", fieldName: "Non_Asset_backed__c", fixedWidth: 300 },
];

let tableRateDataColumns2 = [
  { label: "Additional rate", fieldName: "Additional_rate__c", fixedWidth: 300 },
  { label: "Condition", fieldName: "Condition__c", fixedWidth: 400 },
];

const LENDER_QUOTING = "Thorn";

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
  ["term", "Term__c"],
  ["paymentType", "Payment__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["creditScore", "Credit_Score__c"],
  ["directorSoleTraderScore", "Extra_Label_3__c"],
  ["condition", "Condition__c"],
  ["residualValue", "Residual_Value__c"],
  ["adverseCredit", "Adverse_Credit_File__c"],
  ["abnLength", "Extra_Label_1__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["customerProfile", "Customer_Profile__c"],
  ["privateSales", "Private_Sales__c"],
  ["brokeragePercentage", "Brokerage__c"],
  ["baseRate", "Base_Rate__c"],
  ["manualBaseRate", "Manual_Max_Rate__c"],
  ["clientRate", "Client_Rate__c"],
  ["residualValuePercentage", "Residual_Value_Percentage__c"],
  ["rateOption", "Rate_Options__c"],
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["naf", "NAF__c"],
  ["netDeposit", "Net_Deposit__c"]
]);

const RATE_SETTING_NAMES = ["gacTier1", "gacTier2", "gacTier3", "gacAdd"];

const SETTING_FIELDS = new Map([
  ["price", "Vehicle_Price__c"],
  ["dof", "DOF__c"],
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["applicationFeePrivate", "Application_Fee_Private__c"],
  ["ppsr", "PPSR__c"],
  ["residualValue", "Residual_Value__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["maxBrokerage", "Max_Brokerage__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["term", "Term__c"],
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
  "paymentType",
  "term",
  "manualBaseRate",
  "price",
  "deposit",
  "tradeIn",
  "payoutOn",
  "rateOption"
];

const BASE_RATE_FIELDS = [
  "manualBaseRate", 
  "rateOption",
  "brokeragePercentage",
  "price"
];

const getBaseAmountPmtInclBrokerageCalc = (quote) => {
  let naf = QuoteCommons.calcNetRealtimeNaf(quote);
  let brokerage = quote.brokeragePercentage > 0? quote.brokeragePercentage : 0;
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
    console.log('ling 130', res.messages);
    if (res.messages && res.messages.errors.length > 0) {
      reject(res);
      console.log('ling 133', res);
    } else {
      // Prepare params
      const p = {
        lender: LENDER_QUOTING,
        baseRate: quote.baseRate,
        amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
        term: quote.term,
        residualValue: quote.residualValue,
        paymentType: quote.paymentType,
        brokeragePer: quote.brokeragePercentage,
        amountBaseComm: quote.price - QuoteCommons.calcNetDeposit(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
      };

      // Calculate
      console.log(`@@param:`, JSON.stringify(p, null, 2));
      calculateRepayments({
        param: p
      })
        .then((data) => {
          console.log(`@@SF...calculate line 159:`, JSON.stringify(data, null, 2));
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

  const createTerms = () => {
    let r = [];
    for (let i = 0; i <= 84; i+=12) {
      r.push({ label: i.toString(), value: i.toString() });
    }
    return r;
  };
  

  const calcOptions = {
    loanTypes: [
      { label: "Fast Start", value: "Fast Start" },
      { label: "Standard", value: "Standard" },
    ],
    paymentTypes: CommonOptions.paymentTypes,
    propertyOwnerTypes: CommonOptions.yesNo, 
    assetTypes: [
      { label: "Primary", value: "Primary" },
      { label: "Secondary", value: "Secondary" },
      { label: "Tertiary", value: "Tertiary" },
    ],
    terms: createTerms(),
    assetAges: createAssetAges(),
    abnTypes: [
      { label: "ABN/GST > 2 years", value: "ABN/GST > 2 years" },
      { label: "ABN 2 years +/GST < 2 years", value: "ABN 2 years +/GST < 2 years" },
      { label: "ABN < 2 years /GST 1 day +", value: "ABN < 2 years /GST 1 day +" },
    ],
    privateSales: [
      { label: "--None--", value: "" },
      { label: "Yes", value: "Y" },
      { label: "No", value: "N" }
    ],
    typeValues: [
      { label: "Percentage", value: "Percentage" },
      { label: "Value", value: "Value" },
    ],
    creditScores: [
      { label: "--None--", value: "" },
      { label: "> 500", value: "> 500" },
      { label: "< 500", value: "< 500" }
    ],
    directorSoleTraderScores: [
      { label: "--None--", value: "" },
      { label: "> 600", value: "> 600" },
      { label: "< 600", value: "< 600" }
    ],
    paidDefaults: [
      { label: "--None--", value: "" },
      { label: "Pd Telco <$1K", value: "Pd Telco <$1K" },
      { label: "Oth Default <$5K", value: "Oth Default <$5K" }
    ],
    conditions: [
      { label: "--None--", value: "" },
      { label: "New", value: "New" },
      { label: "Used", value: "Used" }
    ],
    adverseCredits: [
      { label: "--None--", value: "" },
      { label: "Yes", value: "Y" },
      { label: "No", value: "N" }
    ],
    gstLengths: [
      { label: "No GST", value: "" },
      { label: "< 2 years", value: "< 2 years" },
      { label: "> 2 years", value: "> 2 years" }
    ]
  };

// Reset
const reset = (recordId) => {
  let r = {
    oppId: recordId,
    quoteName: LENDER_QUOTING,
    loanType: calcOptions.loanTypes[0].value,
    assetType: calcOptions.assetTypes[0].value,
    price: 0,
    deposit: 0,
    tradeIn: 0,
    payoutOn: 0,
    applicationFee: 0,
    dof: 0,
    ppsr: 0,
    term: calcOptions.terms[0].value,
    paymentType: "Advance",
    monthlyFee: 0,
    creditScore: "",
    directorSoleTraderScore: "",
    paidDefault: "",
    condition: "",
    residualValue: 0,
    typeValue: calcOptions.typeValues[1].value,
    residualValuePercentage: null,
    adverseCredit: "",
    abnLength: calcOptions.abnTypes[0].value,
    gstLength: calcOptions.gstLengths[0].value,
    assetAge: calcOptions.assetAges[0].value,
    customerProfile: calcOptions.propertyOwnerTypes[1].value,
    privateSales: "",
    brokeragePercentage: 0,
    baseRate: 0.0,
    manualBaseRate: 0.0,
    clientRate: 0,
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
        console.log(`Helper line 308...@@SF:`, JSON.stringify(quoteData, null, 2));
        // Mapping Quote's fields
        let data = QuoteCommons.mapSObjectToLwc({
          calcName: LENDER_QUOTING,
          defaultData: reset(recordId),
          quoteData: quoteData,
          settingFields: SETTING_FIELDS,
          quotingFields: QUOTING_FIELDS
        });

        // Defaults
        if (data.paidDefault === undefined || data.paidDefault === null) {
          data.paidDefault = "";
        }
        
        // Settings
        lenderSettings = quoteData.settings;

        // Rate Settings
        if (quoteData.rateSettings) {
          gacTier1 = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
          gacTier2 = quoteData.rateSettings[`${RATE_SETTING_NAMES[1]}`];
          gacTier3 = quoteData.rateSettings[`${RATE_SETTING_NAMES[2]}`];
          gacAdd = quoteData.rateSettings[`${RATE_SETTING_NAMES[3]}`];
        }
        resolve(data);
      })
      .catch((error) => reject(error));
  });

const getTableRatesData1 = () => {
  return gacTier1;
}

const getTableRatesData2 = () => {
  return gacTier2;
}

const getTableRatesData3 = () => {
  return gacTier3;
}

const getTableRatesData4 = () => {
  return gacAdd;
}

const getResidualValue = (quote) => {
  return ((quote.price - QuoteCommons.calcNetDeposit(quote)) * quote.residualValuePercentage) / 100;
}

const getResidualPercentage = (quote) => {
  let percentage = (quote.residualValue / (quote.price - QuoteCommons.calcNetDeposit(quote))) * 100;
  return percentage.toFixed(2);
}

// Get Base Rates
const getMyBaseRates = (quote) => {
  let baseRate = 0.0;
  baseRate += quote.manualBaseRate ? parseFloat(quote.manualBaseRate) : 0.0;
  baseRate += quote.rateOption ? parseFloat(quote.rateOption) : 0.0;
   
  if (quote.price <= 50000 && quote.brokeragePercentage > 5) {
    baseRate += 0.5 * (quote.brokeragePercentage - 5)   
  } else if (quote.price > 50000 && quote.brokeragePercentage > 4) {
    baseRate += 0.5 * (quote.brokeragePercentage - 4)
  }
  return baseRate;
}

// get baseRates
const getBaseRateAmount = (quote) => {
  let baseRate = 0.0;
  baseRate += quote.baseRate ? quote.baseRate : 0.0;
  baseRate += quote.rateOption ? parseFloat(quote.rateOption) : 0.0;
  return baseRate;
}

// This method is from
// QuotingCalculation.cls public static Decimal getClientRateCalculation(CalcParam param, Integer scale)
const getClientRateCalc = (param) => {
  const naf = QuoteCommons.calcNetRealtimeNaf(param);
  const amountBasePmt = getBaseAmountPmtInclBrokerageCalc(param);

  const residualValue = 0;
  let type = 0;
  if (param.paymentType === "Advance") {
    type = 1;
  }
  const pmt = fu.pmt2((param.baseRate / 100 / 12),
    param.term,
    (amountBasePmt * -1),
    residualValue,
    type
  );
  let r = fu.rate2(
    param.term,
    (pmt * -1.0),
    naf,
    (residualValue * -1),
    type
  );
  return (r * 12 * 100).toFixed(2);
};


// get max Brokerage
const getMaxBrokerage = (quote) => {
  let loanAmount = QuoteCommons.calcNetRealtimeNaf(quote);
  if (loanAmount < 50001) {
    return 8;
  } else {
    return 6;
  }
}

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
      // RateOption integer value to String
      param.rateOption = param.rateOption.toString();
      param.manualBaseRate = param.manualBaseRate.toString();
      console.log('param@@', JSON.stringify(param, null, 2))
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
  getTableRatesData3: getTableRatesData3,
  getTableRatesData4: getTableRatesData4,
  tableRateDataColumns1: tableRateDataColumns1,
  tableRateDataColumns2: tableRateDataColumns2,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
  getResidualValue: getResidualValue,
  getResidualPercentage: getResidualPercentage,
  getClientRateCalc: getClientRateCalc,
  getBaseRateAmount: getBaseRateAmount,
  getMaxBrokerage: getMaxBrokerage
};