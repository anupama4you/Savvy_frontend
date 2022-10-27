import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quotePepperLeisureCalcHelper";

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

  if (quote.term === null || quote.term === 0) {
    errorList.push({
      field: "term",
      message: "Please select an appropriate term."
    });
  }

  if (quote.clientTier === null || quote.clientTier.length === 0) {
    errorList.push({
      field: "clientTier",
      message: "Please select a tier for your client."
    });
  }

  if (quote.assetType === 'Motorbike' && quote.assetSubtype === '--N/A--') {
    errorList.push({
      field: "assetSubtype",
      message: 'Please select an Asset Subtype option'
    });
  }

  if (quote.residual > 0 && quote.term > 60) {
    errorList.push({
      field: "residual",
      message: 'You cannot have a balloon or residual payment when the loan term is > 5 years.'
    });
  }

  const NAF = CalHelper.getNetRealtimeNaf(quote);
  let maxNaf = 50000;
  
  if (quote.clientTier !== 'C') {
    maxNaf = 100000;
  }
  if (quote.assetType === 'Boat' && quote.privateSales === 'Y' && NAF > maxNaf) {
    warningList.push({
      field: "NAF",
      message: `Normally max NAF of $${maxNaf} for Private sale assets - refer to Pepper`
    });
  }

  if (
    (quote.assetType === 'Boat'
      || (quote.assetType === 'Motorbike' && (quote.assetSubtype === 'Off-Road' || (quote.assetSubtype === 'ATV')))
    ) && quote.clientTier === 'C'
  ) {
    errorList.push({
      field: "AssetType && clientTier",
      message: 'Leisure (except road bikes) not allowed for Tier C'
    });
  }

  if (quote.privateSales === 'Y' && NAF > maxNaf) {
    warningList.push({
      field: "privateSales",
      message: `Private sales max. NAF should be $${maxNaf}`
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

  r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
  r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
  return r;
};

const Validations = {
  validate: validate,
  validatePostCalculation: validatePostCalculation
};

export { Validations };