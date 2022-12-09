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

  const MAX_BROKERAGE = 4.0;

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.baseRate",
    quote.baseRate
  );
  if (quote.baseRate === null || quote.baseRate === 0.0) {
    errorList.push({
      field: "baseRate",
      message: "Base Rate cannot be Zero."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 31 ~ validate ~ quote.brokeragePercentage",
    quote.brokeragePercentage
  );
  if (quote.brokeragePercentage > MAX_BROKERAGE) {
    errorList.push({
      field: "brokeragePercentage",
      message: `Brokerage cannot be greater than ${MAX_BROKERAGE.toFixed(2)}%`
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 42 ~ validate ~ quote.equifaxScore",
    quote.equifaxScore
  );
  if (quote.equifaxScore && quote.equifaxScore < 500) {
    errorList.push({
      field: "equifaxScore",
      message: "Score less than 500 does not qualify"
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 52 ~ validate ~ quote.residualValue",
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