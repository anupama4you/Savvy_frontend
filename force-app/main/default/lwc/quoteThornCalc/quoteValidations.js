import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteThornCalcHelper";

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

  // NAF
  if (quote.loanType === "Fast Start" && naf > 100000) {
    warningList.push({
      field: "propertyOwner",
      message: `Max of $100,000 NAF is allowed.`
    });
  }

  // ABN/GST
  if (quote.loanType === "Standard" && quote.abnLength === "ABN 2 years +/GST < 2 years" || quote.abnLength === "ABN < 2 years /GST 1 day +") {
    errorList.push({
      field: "abnLength",
      message: `Must be ABN/GST > 2 years for this product`
    });
  } else if (quote.loanType === "Fast Start" && quote.abnLength === "ABN/GST > 2 years"){
    errorList.push({
      field: "abnLength",
      message: `ABN/GST > 2 years qualifies for Standard product`
    });
  }

  // Property Owner
  if (quote.customerProfile === "N") {
    warningList.push({
      field: "propertyOwner",
      message: `Non property owners may require 20% deposit`
    });
  }

  // Brokerage
  if (quote.price >= 10000 && quote.price <= 50000 && quote.brokeragePercentage > 8) {
    warningList.push({
      field: "brokeragePercentage",
      message: "Maximum 8% for loans $10,000- $50,000"
    });
  } else if (quote.price >= 50001 && quote.price <= 1000000 && quote.brokeragePercentage > 6) {
    warningList.push({
      field: "brokeragePercentage",
      message: "Maximum 6% for loans $50,001- $1,000,000"
    });
  }

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

  if (quote.residualValue > 0) {
    warningList.push({
      field: "residualValue",
      message: `Balloon is calculated on car price less any deposit or trade in.`
    });
    if(quote.term > 60) {
      errorList.push({
        field: "residualValue",
        message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
      });
    }
  }
 
  if ("" === quote.directorSoleTraderScore) {
    errorList.push({
      field: "directorSoleTraderScore",
      message: "Please choose a Director/Sole Trader Score option."
    });
  }

  if (quote.clientRate <= 0) {
    warningList.push({
      field: "clientRate",
      message: "Client Rate should be greater than zero."
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