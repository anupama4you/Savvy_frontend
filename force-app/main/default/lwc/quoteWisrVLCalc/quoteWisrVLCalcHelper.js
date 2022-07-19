import getQuotingData from "@salesforce/apex/QuoteWisrVLCalcController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import { QuoteCommons, CommonOptions } from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let tableRateDataColumns = [
  { label: "Profile", fieldName: "Profile__c", fixedWidth: 360 },
  { label: "Credit Score Start", fieldName: "Credit_Score_Start__c", fixedWidth: 160 },
  { label: "Credit Score End", fieldName: "Credit_Score_End__c", fixedWidth: 160 },
  { label: "0 - 1 yrs", fieldName: "Rate_1__c", fixedWidth: 120 },
  { label: "2 - 3 yrs", fieldName: "Rate_2__c", fixedWidth: 120 },
  { label: "4 - 7 yrs", fieldName: "Rate_3__c", fixedWidth: 120 },
  { label: "8 - 12 yrs", fieldName: "Rate_4__c", fixedWidth: 120 },
  { label: "Comparison Rate", fieldName: "Comparison_Rate__c", fixedWidth: 160 },
];

const LENDER_QUOTING = "Wisr VL";

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
  ["monthlyFee", "Monthly_Fee__c"],
  ["term", "Term__c"],
  ["creditScore", "Credit_Score__c"],
  ["profile", "Customer_Profile__c"],
  ["paymentType", "Payment__c"],
  ["lvr", "LTV__c"],
  ["privateSales", "Private_Sales__c"],
]);

const RATE_SETTING_NAMES = ["Rate Table"];

const SETTING_FIELDS = new Map([
  ["dof", "DOF__c"],
  ["applicationFee", "Application_Fee__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["ppsr", "PPSR__c"],
]);

const BASE_RATE_FIELDS = [
  "creditScore"
];

const APPLICATION_FEE_DOF_FIELDS = [
  "price"
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
    console.log('ling 73', res.messages);
    if (res.messages && res.messages.errors.length > 0) {
      reject(res);
      console.log('ling 76', res);
    } else {
      // Prepare params
      const p = {
        lender: LENDER_QUOTING,
        totalAmount: QuoteCommons.calcTotalAmount(quote),
        totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
        totalInsuranceIncome: QuoteCommons.calcTotalInsuranceType(quote),
        loanType: quote.loanType,
        productLoanType: quote.loanProduct,
        vehiclePrice: quote.price,
        applicationFee: quote.applicationFee,
        dof: quote.dof,
        residualValue: quote.residual,
        monthlyFee: quote.monthlyFee,
        term: Number(quote.term),
        vedascore: quote.creditScore,
        paymentType: quote.paymentType,
        baseRate: quote.baseRate,
        clientRate: quote.clientRate,
        amountBaseComm: quote.price
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

  const createVehicleYears = () => {
    let r = [];
    let today = new Date();
    let year = today.getFullYear();
    r.push({ label: "--None--", value: "" });
    for (let i = year; i >= (year-15); i--) {
      r.push({ label: i.toString(), value: i.toString() });
    }
    return r;
  };

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: CommonOptions.fullLoanProducts,
  privateSales: CommonOptions.yesNo,
  terms: [
    { label: "36", value: "36" },
    { label: "60", value: "60" },
    { label: "84", value: "84" }
  ],
  vehicleAges: [
    { label: "New", value: "New" },
    { label: "Used 0-5 years", value: "Used 0-5 years" },
    { label: "Used 6-9 years", value: "Used 6-9 years" },
    { label: "Used 10+ years", value: "Used 10+ years" }
  ],
  profiles: [
    { label: "--None--", value: "" },
    { label: "Renter, Boarder, Living at home with parents", value: "Renter, Boarder, Living at home with parents" },
    { label: "Home owner", value: "Home owner" },
  ],
  vehicleYears: createVehicleYears(),
  clientRates: [{ label: "--None--", value: "" },]
};

// Reset
const reset = (recordId) => {
  let r = {
    oppId : recordId,
    quoteName : LENDER_QUOTING,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    price: null,
    applicationFee: null,
    maxApplicationFee: 0,
    dof: null,
    maxDof: null,
    residual: null,
    monthlyFee: null,
    term: "60",
    creditScore: 0,
    profile: "",
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: "",
    paymentType: "Arrears",
    loanPurpose: '',
    privateSales: "N",
    vehicleYear: ""
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
          tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
        }
        console.log(`@@table rates data:`, tableRatesData);
        resolve(data);
      })
      .catch((error) => reject(error));
  });

const getWisrVLMaxAppFee = (naf) => { 
  let r = 0.0;
  if (naf < 10000) {
    r = 495.0;
  } else if (naf < 20000) {
    r = 520.0;
  } else if (naf < 25000) {
    r = 555.0;
  } else if (naf < 30000) {
    r = 575.0;
  } else if (naf < 35000) {
    r = 630.0;
  } else if (naf < 40000) {
    r = 735.0;
  } else if (naf < 45000) {
    r = 840.0;
  } else if (naf < 50000) {
    r = 945.0;
  } else {
    r = 990.0;
  }
  return r;
};

// Wiser VL - fees 
const getWisrVLMaxDOF = (baseAmount) =>  { 
  // amount -> asset proice - net deposit
  let r = 0.0;
  if (baseAmount >= 50000) {
    r = 1990.0;
  } else if (baseAmount >= 40000) {
    r = 1500.0;
  } else if (baseAmount >= 30000) {
    r = 1250.0;
  } else if (baseAmount >= 20000) {
    r = 990.0;
  } else if (baseAmount >= 10000) {
    r = 900.0;
  } else if (baseAmount >= 7500) {
    r = 750.0;
  } else if (baseAmount >= 5000) {
    r = 500.0;
  }
  return r;
}

const getBaseAmountForDOF = (price, naf) => {
  return price? Number(price) - Number(naf) : 0;
}

// Get Max Fees
const getMyMaxFees = (quote) => {
  let r = {
    maxApplicationFee: getWisrVLMaxAppFee(QuoteCommons.calcNetRealtimeNaf(quote)), 
    maxDof: getWisrVLMaxDOF(getBaseAmountForDOF(quote.price, QuoteCommons.calcNetRealtimeNaf(quote)))
  };
  return r;
};

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const p = {
      lender: LENDER_QUOTING,
      totalAmount: QuoteCommons.calcTotalAmount(quote),
      totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
      clientRate: quote.clientRate===""? 0 : quote.clientRate,
      baseRate: quote.baseRate,
      paymentType: quote.paymentType,
      term: Number(quote.term),
      dof: quote.dof,
      monthlyFee: quote.monthlyFee,
      loanType: quote.loanType,
      productLoanType: quote.loanProduct,
      vedascore: quote.creditScore,
      vehiclePrice: quote.price,
      applicationFee: quote.applicationFee,
      vehicleYear: quote.vehicleYear,
      ltv: quote.lvr,
      privateSales: quote.privateSales,
      customerProfile: quote.profile
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

const getTableRatesData = () => {
  return tableRatesData;
};

export const CalHelper = {
  options: calcOptions,
  calculate: calculate,
  load: loadData,
  reset: reset,
  baseRates: getMyBaseRates,
  maxFees: getMyMaxFees,
  BASE_RATE_FIELDS: BASE_RATE_FIELDS,
  APPLICATION_FEE_DOF_FIELDS: APPLICATION_FEE_DOF_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  tableRateDataColumns: tableRateDataColumns,
  getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
  getNetDeposit: QuoteCommons.calcNetDeposit
};