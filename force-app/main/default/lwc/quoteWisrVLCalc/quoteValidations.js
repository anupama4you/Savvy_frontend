import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteWisrVLCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
  const r =
    typeof messages == "undefined" || messages == null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 18 ~ validate ~ quote", quote);

  if (quote.price === null || !(quote.price > 0.0)) {
    errorList.push({
      field: "price",
      message: "Vehicle Price cannot be Zero."
    });
  }

  if (quote.naf === null || quote.naf < 5000 || quote.naf > 8000) {
    warningList.push({
      field: "naf",
      message: "Loan amount should be between $5,000 and $80,000."
    });
  }

  if (quote.applicationFee === null || !(quote.applicationFee > 0.0)) {
    errorList.push({
      field: "applicationFee",
      message: "Application Fee should not be Zero."
    });
  } else if(quote.applicationFee > quote.maxApplicationFee) {
    errorList.push({
      field: "applicationFee",
      message: `Max Application Fee exceed. Max value $${quote.maxApplicationFee}.`
    });
  }
  if (quote.dof === null || !(quote.dof > 0.0)) {
    errorList.push({
      field: "dof",
      message: "DOF should not be Zero."
    });
  } else if(quote.dof > quote.maxDof) {
    errorList.push({
      field: "dof",
      message: `Max DOF Fee exceed. Max value $${quote.maxDof}.`
    });
  }
  if (quote.creditScore === null || !(quote.creditScore > 0.0)) {
    errorList.push({
      field: "creditScore",
      message: "Credit Score should be filled."
    });
  }
  if (quote.clientRate === null || !(quote.clientRate > 0.0)) {
    errorList.push({
      field: "clientRate",
      message: "Client Rate should not be zero."
    });
  } else if (quote.clientRate < quote.baseRate) {
    warningList.push({
      field: "clientRate",
      message: `Client Rate should not be below base rate: ${quote.baseRate}%.`
    });
  } else if (quote.clientRate > quote.maxRate) {
    warningList.push({
      field: "clientRate",
      message: `Client Rate should not be above of max rate: ${quote.maxRate}%.`
    });
  }
  if (quote.term === 84 && quote.creditScore < 640) {
    warningList.push({
      field: "term",
      message: "7 year terms only for scores >= 640."
    });
  }
  let naf = CalHelper.getNetRealtimeNaf(quote);
  if (naf < 5000) {
    warningList.push({
      field: "naf",
      message: `Min NAF should be $5,000.`
    });
  } else if (naf > 80000) {
    warningList.push({
      field: "naf",
      message: `Max NAF with WISR $80,000.`
    });
  }
  if (quote.creditscore === null || quote.creditscore < 450) {
    errorList.push({
      field: "creditScore",
      message: "Credit score should be >= 450."
    });
  }
  if (quote.vehicleYear === null || quote.vehicleYear === 0) {
    errorList.push({
      field: "vehicleYear",
      message: "Vehicle Year is required."
    });
  } else {
    let today = new Date();
    let year = today.getFullYear();
    let a = year - quote.vehicleYear + Number(quote.term)/12;
    if (a > 15) {
      errorList.push({
        field: "vehicleYear",
        message: `Vehicle can not be older than 15 years at term end, (current ${a} years).`
      });
    }
  }
  if (quote.lvr === null || !(quote.lvr > 0.0)) {
    errorList.push({
      field: "lvr",
      message: "LVR is required."
    });
  } else if (quote.lvr >150) {
    errorList.push({
      field: "lvr",
      message: "Max LVR should be 150%."
    });
  }

  r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
  r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
  return r;
};

const validatePostCalculation = (quote, messages) => {
  const r =
    typeof messages == "undefined" || messages == null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

  if (quote.commission === null || !(quote.commission > 0.0)) {
    warningList.push({
      field: "Commissions and Repayments",
      message: `The commission is below zero. Please make adjustment to make sure commission is above zero.`
    });
  }

  r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
  r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
  return r;
};

const Validations = {
  validate: validate,
  validatePostCalculation: validatePostCalculation
};

export { Validations };