import getQuotingData from "@salesforce/apex/QuoteLibertyCommercialController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateAllRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuoteLibertyCommercialController.save";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let applicationFee = 0.0;
let lenderSettings = {};
// API Responses
let apiResponses = {};
let tableRatesData = [];
let tableRateDataColumns = [
  { label: "Vehicle Age", fieldName: "Vehicle_Age__c", fixedWidth: 140 },
  { label: "AAA", fieldName: "AAA", fixedWidth: 80 },
  { label: "AA", fieldName: "AA", fixedWidth: 80 },
  { label: "A", fieldName: "A", fixedWidth: 80 },
  { label: "B", fieldName: "B", fixedWidth: 80 },
  { label: "C", fieldName: "C", fixedWidth: 80 }
];

const LENDER_QUOTING = "Liberty Commercial";

const QUOTING_FIELDS = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["assetType", "Goods_type__c"],
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["tradeIn", "Trade_In__c"],
  ["payoutOn", "Payout_On__c"],
  ["netDeposit", "Net_Deposit__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["eqFee", "Risk_Fee__c"],
  ["residual", "Residual_Value__c"],
  ["term", "Term__c"],
  ["propertyOwner", "Customer_Profile__c"],
  ["assetAge", "Vehicle_Age__c"],
  ["vehicleYear", "Vehicles_Profile__c"],
  ["creditScore", "Credit_Score__c"],
  ["abnLength", "ABN__c"],
  ["gstLength", "GST__c"],
  ["ltv", "LTV__c"],
  ["paymentType", "Payment__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["riskGrade", "Client_Tier__c"],
  ["baseRate", "Base_Rate__c"],
  ["clientRate", "Client_Rate__c"],
  ["applicationId", "Application__c"]
]);

const FIELDS_MAPPING_FOR_APEX = new Map([...QUOTING_FIELDS, ["Id", "Id"]]);

const RATE_SETTING_NAMES = ["LibertyRates__c"];

const SETTING_FIELDS = new Map([
  ["applicationFee", "Application_Fee__c"],
  ["maxApplicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["maxDof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["maxRate", "Manual_Max_Rate__c"],
]);

const BASE_RATE_FIELDS = [
  "customerProfile",
  "loanProduct",
  "assetAge",
  "assetType",
  "residual"
];

const RISK_GRADE_FIELDS = [
  "abnLength",
  "gstLength",
  "propertyOwner",
  "creditScore",
  ...BASE_RATE_FIELDS
];

const calculate = (quote) =>
  new Promise((resolve, reject) => {
    console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
    let res = {
      commissions: QuoteCommons.resetResults(),
      messages: QuoteCommons.resetMessage()
    };
    // Validate quote
    const vParams = {
      naf: calcNetRealtimeNaf(quote)
    };
    res.messages = Validations.validate(
      quote,
      res.messages,
      lenderSettings,
      vParams
    );
    if (res.messages && res.messages.errors.length > 0) {
      console.log(`res.message === ${JSON.stringify(res, null, 2)}`);
      reject(res);
    } else {
      // Prepare params
      const p = {
        lender: LENDER_QUOTING,
        productLoanType: quote.loanProduct,
        clientTier: quote.riskGrade,
        vehicleYear: quote.assetAge,
        goodsType: quote.assetType,
        privateSales: quote.privateSales,
        totalAmount: calcTotalAmount(quote),
        // totalInsurance: QuoteCommons.calcTotalInsuranceIncome(quote),
        clientRate: quote.clientRate,
        baseRate: quote.baseRate,
        paymentType: quote.paymentType,
        term: quote.term,
        dof: quote.dof,
        monthlyFee: quote.monthlyFee,
        residualValue: quote.residual
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
          res.messages = Validations.validatePostCalculation(
            res.commissions,
            res.messages
          );
          resolve(res);
        })
        .catch((error) => {
          res.messages.errors.push({ field: "calculation", message: error });
          reject(res);
        });
    }
  });

const createVehicleYearOptions = () => {
  let opts = [{ label: "-- None --", value: null }];
  try {
    let currentYear = new Date().getFullYear();
    for (let i = currentYear; i >= currentYear - 20; i--) {
      opts.push({ label: `${i}`, value: `${i}` });
    }
  } catch (error) {
    console.error(error);
  }
  return opts;
};

/**
 *  Lee - formatting the data for table
 * @param {Array} ratesData - each element is object
 * @returns array of usable data
 */
const formatTableData = (ratesData) => {
  try {
    let rates = [
      { Vehicle_Age__c: "New" },
      { Vehicle_Age__c: "0-4 years" },
      { Vehicle_Age__c: "5-9 years" },
      { Vehicle_Age__c: "10+ years" }
    ];
    ratesData.map((item) => {
      if (item.Vehicle_Age__c === "New") {
        let obj = rates.find((o) => o.Vehicle_Age__c === "New");
        if (item.Tier__c === "AAA") obj.AAA = item.Rate__c;
        if (item.Tier__c === "AA") obj.AA = item.Rate__c;
        if (item.Tier__c === "A") obj.A = item.Rate__c;
        if (item.Tier__c === "B") obj.B = item.Rate__c;
        if (item.Tier__c === "C") obj.C = item.Rate__c;
      } else if (item.Vehicle_Age__c === "0-4 years") {
        let obj = rates.find((o) => o.Vehicle_Age__c === "0-4 years");
        if (item.Tier__c === "AAA") obj.AAA = item.Rate__c;
        if (item.Tier__c === "AA") obj.AA = item.Rate__c;
        if (item.Tier__c === "A") obj.A = item.Rate__c;
        if (item.Tier__c === "B") obj.B = item.Rate__c;
        if (item.Tier__c === "C") obj.C = item.Rate__c;
      } else if (item.Vehicle_Age__c === "5-9 years") {
        let obj = rates.find((o) => o.Vehicle_Age__c === "5-9 years");
        if (item.Tier__c === "AAA") obj.AAA = item.Rate__c;
        if (item.Tier__c === "AA") obj.AA = item.Rate__c;
        if (item.Tier__c === "A") obj.A = item.Rate__c;
        if (item.Tier__c === "B") obj.B = item.Rate__c;
        if (item.Tier__c === "C") obj.C = item.Rate__c;
      } else {
        let obj = rates.find((o) => o.Vehicle_Age__c === "10+ years");
        if (item.Tier__c === "AAA") obj.AAA = item.Rate__c;
        if (item.Tier__c === "AA") obj.AA = item.Rate__c;
        if (item.Tier__c === "A") obj.A = item.Rate__c;
        if (item.Tier__c === "B") obj.B = item.Rate__c;
        if (item.Tier__c === "C") obj.C = item.Rate__c;
      }
    });
    return rates;
  } catch (error) {
    console.error(error);
  }
};

const calcOptions = {
  loanTypes: CommonOptions.loanTypes,
  paymentTypes: CommonOptions.paymentTypes,
  loanProducts: CommonOptions.businessLoanProducts,
  propertyOwner: CommonOptions.yesNo,
  assetTypes: [
    { label: "Car/Light commercial", value: "Car/Light commercial" }
  ],
  clientTiers: [
    { label: "A", value: "A" },
    { label: "B", value: "B" },
    { label: "C", value: "C" }
  ],
  vehicleAges: [
    { label: "New", value: "New" },
    { label: "0-4 years", value: "0-4 years" },
    { label: "5-9 years", value: "5-9 years" },
    { label: "10+ years", value: "10+ years" }
  ],
  creditScore: [
    { label: "-- None --", value: null },
    { label: "400+", value: "400+" },
    { label: "500+", value: "500+" },
    { label: "600+", value: "600+" },
    { label: "750+", value: "750+" }
  ],
  abnLength: [
    { label: "-- None --", value: null },
    { label: ">12 mths", value: ">12 mths" },
    { label: ">24 mths", value: ">24 mths" },
    { label: ">36 mths", value: ">36 mths" }
  ],
  gstLength: [
    { label: "-- None --", value: null },
    { label: "No GST", value: "No GST" },
    { label: ">12 mths", value: ">12 mths" },
    { label: ">24 mths", value: ">24 mths" },
    { label: ">36 mths", value: ">36 mths" }
  ],
  terms: CommonOptions.terms(12, 84),
  vehicleYear: createVehicleYearOptions()
};

// Reset
const reset = (recordId) => {
  let r = {
    oppId: recordId,
    name: LENDER_QUOTING,
    loanType: calcOptions.loanTypes[0].value,
    loanProduct: calcOptions.loanProducts[0].value,
    assetType: calcOptions.assetTypes[0].value,
    price: null,
    deposit: null,
    tradeIn: null,
    payoutOn: null,
    netDeposit: 0.0,
    applicationFee: 0.0,
    maxApplicationFee: 0.0,
    dof: 0.0,
    ppsr: null,
    residual: null,
    term: 60,
    propertyOwner: calcOptions.propertyOwner[1].value,
    assetAge: calcOptions.vehicleAges[0].value,
    ltv: null,
    monthlyFee: null,
    baseRate: 0.0,
    maxRate: 0.0,
    clientRate: null,
    creditScore: null,
    abnLength: null,
    gstLength: null,
    riskGrade: null,
    vehicleYear: null,
    paymentType: "Arrears",
    commissions: QuoteCommons.resetResults(),
    insurance: { integrity: {} }
  };
  //   console.log("before mapping: " + JSON.stringify(r, null, 2));
  r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
  r.applicationFee = r.maxApplicationFee = applicationFee;
  return r;
};

// Load Data
const loadData = (recordId) =>
  new Promise((resolve, reject) => {
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

        // API  responses
        apiResponses = quoteData.apiResponses;

        // Rate Settings
        if (quoteData.rateSettings) {
          tableRatesData = formatTableData(
            quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`]
          );
        }
        console.log(
          `@@tableRatesData ${JSON.stringify(tableRatesData, null, 2)}`
        );
        console.log(`@@data:`, JSON.stringify(data, null, 2));
        
        data["maxApplicationFee"] = applicationFee;
        // if (lenderSettings.Name === LENDER_QUOTING) {
        //   data["applicationFee"] = applicationFee;
        // }

        resolve(data);
      })
      .catch((error) => reject(error));
  });

// Get Base Rates
const getMyBaseRates = (quote) =>
  new Promise((resolve, reject) => {
    const p = {
      lender: LENDER_QUOTING,
      productLoanType: quote.loanProduct,
      clientTier: quote.riskGrade,
      vehicleYear: quote.assetAge,
      goodsType: quote.assetType,
      residualValue: quote.residual,
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
  }

  // custom calculations for NAF generations
  const calcNetRealtimeNaf = (quote) => {
    let r = calcTotalAmount(quote);
    r += QuoteCommons.calcTotalInsuranceType(quote);
    return r;
  }

// custom calculations for NAF generations
// const calcNetRealtimeNaf = (quote) => {
//   let eqFee = 0;
//   let netRealtimeNaf = QuoteCommons.calcNetRealtimeNaf(quote) - quote.dof;
//   eqFee = calculateEQFee(quote, false);
//   return netRealtimeNaf + eqFee;
// };

// custom calculations for NAF calculations
const calcNetForCalculate = (quote) => {
  let eqFee = 0;
  let netRealtimeNaf = QuoteCommons.calcTotalAmount(quote) - quote.dof;
  eqFee = calculateEQFee(quote, false);
  return netRealtimeNaf + eqFee;
};

const calculateEQFee = (quote, excInsurances = false) => {
  try {
    let r = 0.0;
    let baseEqFee = getTotalAmountExcFees(quote);
    if (!excInsurances) {
      if (
        excInsurances !== true &&
        quote.insurance &&
        quote.insurance.iswarrantyAccept === true &&
        quote.insurance.warrantyRetailPrice > 0
      ) {
        baseEqFee += quote.insurance.warrantyRetailPrice;
      }
    }
    if ("A" === quote.riskGrade) {
      r = baseEqFee * 0.01;
    } else if ("B" === quote.riskGrade) {
      r = baseEqFee * 0.03;
    } else if ("C" === quote.riskGrade) {
      r = baseEqFee * 0.08;
    }
    return r;
  } catch (error) {
    console.error(error);
  }
};

const getTotalAmountExcFees = (quote) => {
  let r = 0.0;
  const netdeposit = QuoteCommons.calcNetDeposit(quote);
  if (quote.price != null) r += quote.price;
  if (netdeposit != null) r -= netdeposit;
  return r;
};

const getTableRatesData = () => {
  return tableRatesData;
};

/**
 * - lee
 * @param {Object} quote - quote form
 * @returns
 */
const calcDOF = (quote) => {
  return quote.applicationFee - lenderSettings.Application_Fee__c < 0
    ? 0.0
    : quote.applicationFee - lenderSettings.Application_Fee__c;
};

/**
 * - lee
 * calculate the risk grade
 * @param {String} abn - picklist contains '>'
 * @param {String} gst - picklist contains '>'
 * @param {String} creditScore - picklist contains '+'
 * @param {String} propertyOwner -'N' or 'Y'
 * @returns
 */
const getRiskGrade = (abn, gst, creditScore, propertyOwner) => {
  let riskGrade = "";
  try {
    const abnL = parseStringToNumber(abn);
    const gstL = parseStringToNumber(gst);
    const cScore = parseStringToNumber(creditScore);
    console.log(`abn: ${abnL}, gst:${gstL}, cred: ${cScore}`);
    if (abnL && (gstL === 0 || gstL) && cScore) {
      if ("Y" === propertyOwner) {
        if (abnL == 36 && gstL == 36 && cScore == 750) {
          riskGrade = "AAA";
        } else if (abnL >= 12 && gstL >= 12 && cScore >= 600) {
          riskGrade = "AA";
        } else if (abnL >= 12 && cScore >= 500) {
          riskGrade = "A";
        } else if (abnL >= 24 && cScore >= 400) {
          riskGrade = "B";
        } else if (abnL >= 12 && cScore >= 400) {
          riskGrade = "C";
        }
      } else {
        if (abnL >= 24 && gstL >= 24 && cScore >= 600) {
          riskGrade = "A";
        } else if (abnL >= 24 && cScore >= 500) {
          riskGrade = "B";
        } else if (abnL >= 12 && cScore >= 400) {
          riskGrade = "C";
        }
      }
    }
    return riskGrade;
  } catch (error) {
    console.error(error);
  }
};

/**
 * - lee
 * mapping gst/abn/credit score field
 * @param {String} str
 */
const parseStringToNumber = (str) => {
  try {
    if (!str) return;
    if (str === "No GST") return 0;
    if (str.includes("+")) return parseInt(str.substring(0, str.length - 1));
    if (str.includes(">"))
      return parseInt(str.slice(str.indexOf(">") + 1, str.indexOf(" ")));
  } catch (error) {
    console.error(error);
  }
};
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
  RISK_GRADE_FIELDS: RISK_GRADE_FIELDS,
  lenderSettings: lenderSettings,
  getTableRatesData: getTableRatesData,
  tableRateDataColumns: tableRateDataColumns,
  getNetDeposit: QuoteCommons.calcNetDeposit,
  saveQuote: saveQuote,
  sendEmail: sendEmail,
  getRiskGrade: getRiskGrade,
  getNetRealtimeNaf: calcNetRealtimeNaf,
  getRealtimeEqFee: calculateEQFee,
  getDOF: calcDOF,
  getApiResponses: getApiResponses
};