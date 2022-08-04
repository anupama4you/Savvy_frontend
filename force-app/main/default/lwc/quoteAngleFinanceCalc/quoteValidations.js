import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteAngleFinanceCalcHelper";

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

  if (quote.baseRate === null || !(quote.baseRate > 0.0)) {
    errorList.push({
      field: "baseRate",
      message: "Base Rate cannot be Zero."
    });
  }
  if ("" === quote.privateSales) {
    errorList.push({
      field: "privateSales",
      message: "Please choose a Private Sale option."
    });
  }
  let MAX_BROKERAGE = 7.0;
  if (quote.brokeragePercentage > MAX_BROKERAGE) {
    errorList.push({
      field: "brokeragePercentage",
      message: `Brokerage cannot be greater than ${MAX_BROKERAGE}.`
    });
  }
  if (quote.creditScore === "" || quote.creditScore < 550) {
    errorList.push({
      field: "creditScore",
      message: "Mimimum 550 equifax score - check with lender."
    });
  }
  if (quote.residualValue > 0 && quote.term > 60) {
    errorList.push({
      field: "residualValue",
      message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
    });
  }
  if ('ABN 2+' === quote.abnLength) {
    if('MV & Primary' !== quote.assetType) {
      warningList.push({
        field: "assetType",
        message: `Only MV & primary available for this profile.`
      });
    }
    if((Number(quote.assetAge) + Number(quote.term)/12) > 15) {
      warningList.push({
        field: "assetAge",
        message: `Cars no older than 15 years for this ABN.`
      });
    }
    if((Number(quote.assetAge) + Number(quote.term)/12) > 20) {
      warningList.push({
        field: "assetAge",
        message: `Max 20 years at term end.`
      });
    }
  }
  if('MV & Primary' !== quote.assetType && Number(quote.assetAge) > 5) {
    warningList.push({
      field: "assetAge",
      message: `Max age of 5 years for this asset class.`
    });
  }
  if("N" === quote.propertyOwner && quote.deposit < quote.price*0.2) {
    warningList.push({
      field: "deposit",
      message: `20% deposit required for non property owners.`
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