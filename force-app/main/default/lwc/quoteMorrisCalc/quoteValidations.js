import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteMorrisCalcHelper";

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
  let naf = CalHelper.getNetRealtimeNaf(quote);
  if (quote.baseRate === null || !(quote.baseRate > 0.0)) {
    errorList.push({
      field: "baseRate",
      message: "Base Rate cannot be Zero."
    });
  }
  if (quote.term === "0") {
    errorList.push({
      field: "term",
      message: "Please choose an appropriate term."
    });
  }
  let MAX_BROKERAGE = 8.0;
  if (quote.brokeragePercentage > MAX_BROKERAGE) {
    errorList.push({
      field: "brokeragePercentage",
      message: `Brokerage cannot be greater than ${MAX_BROKERAGE}%.`
    });
  }
  if ('< 12 months' === quote.abnLength && 'Streamline' === quote.productType) {
    errorList.push({
      field: "abnLength",
      message: `ABN must be registered for 12 months under streamline.`
    });
  }
  if('Y' !== quote.gstLength && 'Primary or Premium' === quote.productType) {
    errorList.push({
      field: "gstLength",
      message: `Under Primary or Premium GST registration is required.`
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