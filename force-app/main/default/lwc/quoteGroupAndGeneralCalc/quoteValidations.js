import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteGroupAndGeneralCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages, param) => {
  const r =
    typeof messages == "undefined" || messages == null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

  // const baseRate = quote["baseRate"];
  // const maxRate = 16.5;

  let naf = param.naf > 0? param.naf : 0.0;
  
  if (quote.loanType === "Replacement loan") {
    warningList.push({
      field: "loanType",
      message:
        "A rated ref required.  Must be gst reg.  140% of old payment max"
    });
  }

  if (quote.loanType === "Courier/Uber") {
    warningList.push({
      field: "loanType",
      message: "Max 48 month term.  Max 90% lend.  New demo only"
    });
  }

  if (quote.abnLength === "< 2 years") {
    warningList.push({
      field: "deposit",
      message: "Deposit of up to 20% may be required"
    });
  }

  if (quote.customerProfile === "N") {
    warningList.push({
      field: "customerProfile",
      message: "No property may require 20% deposit"
    });
  }



  if (quote.price === null || quote.price === 0.0) {
    errorList.push({
      field: "price",
      message: "Asset price cannot be Zero."
    });
  }

  // if (quote.applicationFee < 0.0) {
  //   errorList.push({
  //     field: "applicationFee",
  //     message: "Application Fee cannot be below Zero."
  //   });
  // }

  // console.log(
  //   "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.clientRate",
  //   quote.clientRate
  // );
  if (quote.clientRate === null || !(quote.clientRate > 0.0)) {
    errorList.push({
      field: "clientRate",
      message: "Client Rate should not be zero."
    });
  } else if (quote.clientRate < quote.baseRate) {
    warningList.push({
      field: "clientRate",
      message: `Client Rate should not be below base rate`
    });
  }
  
  if (quote.term === undefined || quote.term === null || Number(quote.term) === 0) {
    errorList.push({
      field: "term",
      message: `Please choose an appropriate term.`
    });
  }

  const max_brokerage =
    param && param.lenderSettings && param.lenderSettings.Max_Brokerage__c > 0 ? param.lenderSettings.Max_Brokerage__c : 8.0;

  if (
    max_brokerage > 0 &&
    quote.brokeragePercentage > max_brokerage
  ) {
    errorList.push({
      field: "brokeragePercentage",
      message: `Brokerage cannot be greater than ${max_brokerage}%`
    });
  }

  if(quote.gst === 'N') {
    warningList.push({
      field: "gst",
      message: `Up to 20% deposit may be required for Non GST reg`
    });
    warningList.push({
      field: "gst",
      message: `Non GST Max lend $35K and no older than 5 years`
    });
  }

  if (quote.residual > 0 && Number(quote.term) > 60) {
    errorList.push({
      field: "residual",
      message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
    });
  }
  console.log(`validations done!`);
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