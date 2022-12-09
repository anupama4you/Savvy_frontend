import { QuoteCommons } from "c/quoteCommons";

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

  const baseRate = quote["baseRate"];
  const maxRate = quote["maxRate"];

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.propertyOwner",
    quote.propertyOwner
  );
  if (quote.propertyOwner === 'N' && quote.realtimeNaf > 100000) {
    errorList.push({
      field: "propertyOwner",
      message: "Max $100K for non property owner."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 32 ~ validate ~ quote.baseRate",
    quote.baseRate
  );
  if (quote.baseRate === null || quote.baseRate === 0.0) {
    errorList.push({
      field: "baseRate",
      message: "Base Rate cannot be Zero."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 32 ~ validate ~ quote.term",
    quote.term
  );
  if (quote.term === null || quote.term == 0) {
    errorList.push({
      field: "term",
      message: "Please choose an appropriate term."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 32 ~ validate ~ quote.privateSales",
    quote.privateSales
  );
  if (!quote.privateSales) {
    errorList.push({
      field: "privateSales",
      message: "Please choose a Private Sale option."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 65 ~ validate ~ quote.equifaxScore",
    quote.equifaxScore
  );
  if (quote.equifaxScore === null || quote.equifaxScore < 600) {
    errorList.push({
      field: "equifaxScore",
      message: "Minimum 600 guarantor credit score - check with lender."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 76 ~ validate ~ quote.abnLength",
    quote.abnLength
  );
  if (quote.abnLength === '< 2 years') {
    errorList.push({
      field: "abnLength",
      message: "ABN must be registered for 2 years."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 87 ~ validate ~ quote.gstLength",
    quote.gstLength
  );
  if (quote.gstLength != '< 2 years' && quote.gstLength != '> 2 years') {
    errorList.push({
      field: "gstLength",
      message: "Must be GST registered."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 87 ~ validate ~ quote.realtimeNaf",
    quote.realtimeNaf
  );
  if (quote.brokeragePercentage > 8 && quote.realtimeNaf <= 25000) {
    errorList.push({
      field: "realtimeNaf",
      message: "Brokerage cannot exceed 8%"
    });
  }
  else if (quote.brokeragePercentage > 7 && quote.realtimeNaf <= 75000 && quote.realtimeNaf >= 25000) {
    errorList.push({
      field: "realtimeNaf",
      message: "Brokerage cannot exceed 7%"
    });
  }
  else if (quote.brokeragePercentage > 6 && quote.realtimeNaf <= 150000 && quote.realtimeNaf >= 75000) {
    errorList.push({
      field: "realtimeNaf",
      message: "Brokerage cannot exceed 6%"
    });
  }
  else if (quote.brokeragePercentage > 5 && quote.realtimeNaf <= 250000 && quote.realtimeNaf >= 150000) {
    errorList.push({
      field: "realtimeNaf",
      message: "Brokerage cannot exceed 5%"
    });
  }
  else if (quote.brokeragePercentage > 4 && quote.realtimeNaf >= 250000) {
    errorList.push({
      field: "realtimeNaf",
      message: "Brokerage cannot exceed 4%"
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 132 ~ validate ~ quote.residualValue",
    quote.residualValue
  );
  if (quote.residualValue > 0 && quote.term > 60) {
    errorList.push({
      field: "residualValue",
      message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
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

  if (quote.monthlyPayment === null || quote.monthlyPayment === 0) {
    warningList.push({
      field: "monthlyPayment",
      message: `Payment is not updated as the calculator does not contain relevant info.`
    });
  }

  if (quote.commission === null || quote.commission === 0) {
    warningList.push({
      field: "commission",
      message: `Estimated Commission is not updated as the calculator does not contain relevant info.`
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