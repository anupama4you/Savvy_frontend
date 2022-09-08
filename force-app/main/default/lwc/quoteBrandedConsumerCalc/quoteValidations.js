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
  }

  if (quote.applicationFee === null || quote.applicationFee === 0) {
    warningList.push({
      field: "applicationFee",
      message: `Application Fee is not updated as the calculator does not contain relevant info.`
    });
  }

  if (quote.ppsr === null || quote.ppsr === 0) {
    warningList.push({
      field: "ppsr",
      message: `PPSR is not updated as the calculator does not contain relevant info.`
    });
  }

  if (quote.term === 72 || quote.term === 84) {
    warningList.push({
      field: "term",
      message: "Servicing will be calculated using a 5 year term."
    });
  }

  if (quote.privateSale === "Y") {
    warningList.push({
      field: "privateSale",
      message: "Max $100K for private sales."
    });
  }

  if (quote.assetType === "Motorhomes" || quote.assetType === "Caravan") {
    warningList.push({
      field: "assetType",
      message: "Equifax 1.1 score min 550 for this asset class"
    });
    if (quote.privateSale === "Y")
      errorList.push({
        field: "privateSale",
        messages: "Caravan/Motorhome not available for private sale"
      });
    // if(quote.)
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