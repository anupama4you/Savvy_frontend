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
    "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.clientTier",
    quote.clientTier
  );
  if (quote.clientTier === null || quote.clientTier.length === 0) {
    errorList.push({
      field: "clientTier",
      message: "Please select a tier for your client."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.clientRate",
    quote.clientRate
  );
  if (quote.clientRate === null || !(quote.clientRate > 0.0)) {
    errorList.push({
      field: "clientRate",
      message: "Client Rate should not be zero."
    });
  } else if (quote.clientRate > maxRate) {
    errorList.push({
      field: "clientRate",
      message: `Client Rate cannot exceed the max rate: ${maxRate}%`
    });
  } else if (quote.clientRate < baseRate) {
    warningList.push({
      field: "clientRate",
      message: `Client Rate should not be below base rate`
    });
  } else if (quote.applicationFee === null || quote.applicationFee === 0) {
    warningList.push({
      field: "applicationFee",
      message: `Application Fee is not updated as the calculator does not contain relevant info.`
    });
  } else if (quote.ppsr === null || quote.ppsr === 0) {
    warningList.push({
      field: "ppsr",
      message: `PPSR is not updated as the calculator does not contain relevant info.`
    });
  }

  if (
    quote.clientTier === "C" &&
    quote.opp &&
    quote.opp.ApplicationServicing__r &&
    quote.opp.ApplicationServicing__r.Is_Splitting_Expenses__c === true
  ) {
    warningList.push({
      field: "clientTier",
      message: `Pepper cannot split expenses with Tier C`
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