import getQuotingData from "@salesforce/apex/QuoteMorrisCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteMorrisCalcController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import { QuoteCommons, CommonOptions } from "c/quoteCommons";
import { Validations } from "./quoteValidations";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteMorrisCalcController.save";

// Default settings
let lenderSettings = {};

const LENDER_QUOTING = "Morris";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["assetType", "Goods_type__c"],
  ["productType", "Loan_Facility_Type__c"],
  ["abnLength", "Extra_Label_1__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["applicationFee", "Application_Fee__c"],
  ["ppsr", "PPSR__c"],
  ["term", "Term__c"],
  ["paymentType", "Payment__c"],
  ["gstLength", "Extra_Label_2__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["customerProfile", "Customer_Profile__c"],
  ["brokeragePercentage", "Brokerage__c"],
  ["baseRate", "Base_Rate__c"],
  ["clientRate", "Client_Rate__c"]
]);

// - TODO: need to map more fields
const FIELDS_MAPPING_FOR_APEX = new Map([
  ...QUOTING_FIELDS,
  ["Id", "Id"],
  ["naf", "NAF__c"]
]);

const SETTING_FIELDS = new Map([
  ["price", "Vehicle_Price__c"],
  ["dof", "DOF__c"],
  ["applicationFee", "Application_Fee__c"],
  ["applicationFeePrivate", "Application_Fee_Private__c"],
  ["ppsr", "PPSR__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["term", "Term__c"],
]);

const BASE_RATE_FIELDS = [
  "price",
  "deposit",
  "tradeIn",
  "payoutOn",
  "applicationFee",
  "ppsr",
  "term",
  "paymentType",
  "brokeragePercentage"
];

const calculate = (quote) =>
  new Promise((resolve, reject) => {
    console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
    let res = {
      commissions: QuoteCommons.resetResults(),
      messages: QuoteCommons.resetMessage()
    };
    // Validate quote
    res.messages = Validations.validate(quote, res.messages);
    console.log('ling 72', res.messages);
    if (res.messages && res.messages.errors.length > 0) {
      reject(res);
      console.log('ling 75', res);
    } else {
      // Prepare params
      const p = {
        lender: LENDER_QUOTING,
        baseRate: quote.baseRate,
        clientRate: quote.clientRate,
        amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
        term: quote.term,
        paymentType: quote.paymentType,
        brokeragePer: quote.brokeragePercentage,
        amountBaseComm: quote.price - QuoteCommons.calcNetDeposit(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
      };

      // Calculate
      console.log(`@@param:`, JSON.stringify(p, null, 2));
      calculateRepayments({
        param: p
      })
        .then((data) => {
          console.log(`@@SF...calculate line 98:`, JSON.stringify(data, null, 2));
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
    for (let i = 0; i <= 60; i+=12) {
      r.push({ label: i.toString(), value: i.toString() });
    }
    return r;
  };
  
  const calcOptions = {
    loanTypes: [
      { label: "Purchase", value: "Purchase" },
      { label: "Refinance", value: "Refinance" },
      { label: "Sale and Leaseback", value: "Sale and Leaseback" },
    ],
    assetTypes: [
      { label: "Motor Vehicle", value: "Motor Vehicle" },
      { label: "Trucks/Yellow/Buses/Trailers/Caravans", value: "Trucks/Yellow/Buses/Trailers/Caravans" },
    ],
    productTypes: [
      { label: "Streamline", value: "Streamline" },
      { label: "Primary or Premium", value: "Primary or Premium" }
    ],
    abnTypes: [
      { label: "> 12 months", value: "> 12 months" },
      { label: "< 12 months", value: "< 12 months" },
    ],
    terms: createTerms(),
    paymentTypes: [{ label: "Arrears", value: "Arrears" }],
    gstLengths: CommonOptions.yesNo,
    assetAges: createAssetAges(),
    propertyOwnerTypes: CommonOptions.yesNo,
  };

// Reset
const reset = (recordId) => {
  let r = {
    oppId : recordId,
    quoteName : LENDER_QUOTING,
    loanType: calcOptions.loanTypes[0].value,
    assetType: calcOptions.assetTypes[0].value,
    productType: calcOptions.productTypes[0].value,
    abnLength: calcOptions.abnTypes[0].value,
    price: 0,
    deposit: 0,
    tradeIn: 0,
    payoutOn: 0,
    applicationFee: 0,
    ppsr: 0,
    term: calcOptions.terms[0].value,
    paymentType: calcOptions.paymentTypes[0].value,
    gstLength: calcOptions.gstLengths[1].value,
    assetAge: calcOptions.assetAges[0].value,
    brokeragePercentage: 6,
    customerProfile: calcOptions.propertyOwnerTypes[1].value,
    baseRate: 0.0,
    clientRate: 0.0,
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
      'calcName', LENDER_QUOTING);
    // console.log(`@@fields:`, JSON.stringify(fields, null, 2));
    getQuotingData({
      param: {
        oppId: recordId,
        fields: fields,
        calcName: LENDER_QUOTING,
      }
    })
      .then((quoteData) => {
        console.log(`Helper line 205...@@SF:`, JSON.stringify(quoteData.data, null, 2));
        // Mapping Quote's fields
        let data = QuoteCommons.mapSObjectToLwc({
          calcName: LENDER_QUOTING,
          defaultData: reset(recordId),
          quoteData: quoteData,
          settingFields: SETTING_FIELDS,
          quotingFields: QUOTING_FIELDS
        });
        console.log(`Helper line 214...@@SF:`, JSON.stringify(data, null, 2));
        // Settings
        lenderSettings = quoteData.settings;
        resolve(data);
      })
      .catch((error) => reject(error));
  });

  const getBaseAmountPmtInclBrokerageCalc = (quote) => {
    let naf = QuoteCommons.calcNetRealtimeNaf(quote);
    let brokerage = quote.brokeragePercentage > 0? quote.brokeragePercentage : 0;
    console.log('get PMT...', naf + naf*brokerage/100);
    return naf + (naf*brokerage)/100;
  }

  // Get Base Rates
  const getMyBaseRates = (quote) =>
    new Promise((resolve, reject) => {
      const p = {
        lender: LENDER_QUOTING,
        assetAge: quote.assetAge,
        term: parseInt(quote.term),
        assetType: quote.assetType,
        customerProfile: quote.customerProfile,
        abnLength: quote.abnLength,
        gstLength: quote.gstLength,
        brokeragePer: quote.brokeragePercentage,
        hasMaxRate: false,
        amountBasePmt: getBaseAmountPmtInclBrokerageCalc(quote),
        paymentType: quote.paymentType,
        price: quote.price,
        deposit: quote.deposit,
        tradeIn: quote.tradeIn,
        payoutOn: quote.payoutOn,
        applicationFee: quote.applicationFee,
        ppsr: quote.ppsr,
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
      };
      console.log(`getMyBaseRates...`, JSON.stringify(p, null, 2));
      getBaseRates({
        param: p
      })
      .then((rates) => {
        console.log(`@@SF:`, JSON.stringify(rates, null, 2));
        resolve({
          baseRate: rates.baseRate,
          clientRate: rates.clientRate
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
  lenderSettings: lenderSettings,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
};