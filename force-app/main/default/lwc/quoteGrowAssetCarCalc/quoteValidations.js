import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteGrowAssetCarCalcHelper";

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
  if ('Full Doc' === quote.loanType) {
    if(naf > 150000 && quote.propertyOwner === 'N'){
      warningList.push({
        field: "propertyOwner",
        message: `Max of $150,000 NAF is allowed for Property owner.`
      });
    }else if(naf > 100000 && quote.propertyOwner === 'Y'){
      warningList.push({
        field: "propertyOwner",
        message: `Max of $100,000 NAF is allowed for Non-Property owner.`
      });
    }
  }
  if(naf*0.2 > quote.deposit && quote.propertyOwner === 'N') {
    warningList.push({
      field: "deposit",
      message: `Non property owners require 20% deposit.`
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
  } else if('Tier 3 - Specialised' === quote.assetType && (quote.term === "72" || quote.term === "84")) {
    warningList.push({
      field: "term",
      message: `Max age of vehicle 15 years at term end.`
    });
  }
  if ("" === quote.privateSales) {
    errorList.push({
      field: "privateSales",
      message: "Please choose a Private Sale option."
    });
  }
  let MAX_BROKERAGE = quote.maxBrokerage;
  if (quote.brokeragePercentage > MAX_BROKERAGE) {
    errorList.push({
      field: "brokeragePercentage",
      message: `Brokerage cannot be greater than ${MAX_BROKERAGE}%.`
    });
  }
  if ('< 2 years' === quote.abnLength) {
    errorList.push({
      field: "abnLength",
      message: `ABN length cannot be < 2 years.`
    });
  }
  if("" === quote.gstLength) {
    errorList.push({
      field: "gstLength",
      message: `Please choose a GST Length.`
    });
  } else if('Low Doc' === quote.loanType && '< 2 years' === quote.gstLength) {
    errorList.push({
      field: "loanType",
      message: `GST length < 2 years. Change to easy doc.`
    });
  } else if('Easy Doc' === quote.loanType && '> 2 years' === quote.gstLength) {
    errorList.push({
      field: "loanType",
      message: 'GST length > 2 years. Change to low doc.'
    });
  }
  if('Low Doc' === quote.loanType && '> 12 months' === quote.abnLength) {
    errorList.push({
      field: "loanType",
      message: 'ABN length < 2 years. Change to easy doc.'
    });
  } else if('Easy Doc' === quote.loanType && '> 24 months' === quote.abnLength) {
    errorList.push({
      field: "loanType",
      message: 'ABN length > 2 years. Change to low doc.'
    });
  }
  if((quote.assetType.includes('Trucks') || quote.assetType.includes('Trailers')) && Number(quote.assetAge) > 25){
    errorList.push({
      field: "assetAge",
      message: 'Age of asset limit exceeded.'
    });
  }else if(Number(quote.assetAge) > 15){
    errorList.push({
      field: "assetAge",
      message: 'Age of asset limit exceeded.'
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
  if("N" === quote.propertyOwner && 'Easy Doc' === quote.loanType) {
    warningList.push({
      field: "loanType",
      message: `Max Loan $150,000.`
    });
  } else if ('Easy Doc' === quote.loanType) {
    if ('Tier 1 - Cars' === quote.assetType && naf > 180000) {
      warningList.push({
        field: "price",
        message: `Max Loan $180,000.`
      });
    } else if (naf > 250000) {
      warningList.push({
        field: "price",
        message: `Max Loan $250,000.`
      });
    }
  }
  if ("" === quote.creditScore) {
    errorList.push({
      field: "creditScore",
      message: "Please choose a Company Score option."
    });
  }
  if ("" === quote.directorSoleTraderScore) {
    errorList.push({
      field: "directorSoleTraderScore",
      message: "Please choose a Director/Sole Trader Score option."
    });
  }
  if ("Tier 3 - Specialised" === quote.assetType && "" === quote.condition) {
    errorList.push({
      field: "condition",
      message: "Please choose a Condition option."
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