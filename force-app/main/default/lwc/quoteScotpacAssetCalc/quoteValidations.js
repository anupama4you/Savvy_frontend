import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteScotpacCalcHelper";

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

  if ('Fast Doc' === quote.loanType) {
    console.log('validations@@', quote.customerProfile, quote.creditScore)
    if (quote.customerProfile === 'Y' && quote.creditScore === "< 500" || quote.directorSoleTraderScore === "< 500") {
      warningList.push({
        field: "customerProfile",
        message: `Min score is 550 for Fast Doc. No minimum for Full Doc.`
      });
    } else if (quote.customerProfile === 'N') {
      if (quote.creditScore === "< 622" || quote.directorSoleTraderScore === "< 622") {
        warningList.push({
          field: "customerProfile",
          message: `Score too low for non property owner - refer to lender`
        });
      } else if (quote.creditScore === "623 - 749" || quote.directorSoleTraderScore === "623 - 749") {
        warningList.push({
          field: "customerProfile",
          message: `10% required for this credit score for non property owner`
        });
      } else if (quote.creditScore === "> 750" || quote.directorSoleTraderScore === "> 750") {
        warningList.push({
          field: "customerProfile",
          message: ` No deposit is required for this credit score for non property owner`
        });
      }

    }
  }

  // Age of asset
  if (quote.assetAge > 10) {
    warningList.push({
      field: "assetAge",
      message: `Max age of asset 20 years at term end`
    });
  }

  // if (naf * 0.2 > quote.deposit && quote.customerProfile === 'N') {
  //   warningList.push({
  //     field: "deposit",
  //     message: `Non property owners require 20% deposit.`
  //   });
  // }

  // BaseRate
  if (quote.baseRate === null || !(quote.baseRate > 0.0)) {
    errorList.push({
      field: "baseRate",
      message: "Base Rate cannot be Zero."
    });
  }

  // Term
  if (quote.term === "0") {
    errorList.push({
      field: "term",
      message: "Please choose an appropriate term."
    });
  } 

  // Private Sales
  if ("" === quote.privateSales) {
    errorList.push({
      field: "privateSales",
      message: "Please choose a Private Sale option."
    });
  }

  // Brokerage
  let MAX_BROKERAGE = quote.maxBrokerage;
  if (quote.brokeragePercentage > MAX_BROKERAGE) {
    errorList.push({
      field: "brokeragePercentage",
      message: `Brokerage cannot be greater than ${MAX_BROKERAGE}%.`
    });
  }

  // ABN length
  if (quote.abnLength === "< 2 years") {
    warningList.push({
      field: "abnLength",
      message: `ABN must be min 2 years - please check with lender`
    });
  }

  // GST length
  if ("" === quote.gstLength) {
    errorList.push({
      field: "gstLength",
      message: `Please choose a GST Length.`
    });
  } else if ('Fast Doc' === quote.loanType && '< 2 years' === quote.gstLength) {
    warningList.push({
      field: "gstLength",
      message: ` GST must be min 2 years for Fast Doc. Start ups.`
    });
  } 

  // Asset age
  const years = quote.term/12;
  const assetAge = years + parseFloat(quote.assetAge);

  console.log('assetAge@@', assetAge)

  if (quote.assetType === "Primary - Cars Machinery" && assetAge > 20) {
    warningList.push({
      field: "assetAge",
      message: `Asset > 20 years at term end - refer to lender`
    });
  } else if (quote.assetType === "Secondary" && assetAge > 20) {
    warningList.push({
      field: "assetAge",
      message: `Refer to lender for age profile of secondary assets`
    });
  }

  // Rate Add On
  if(quote.rateOption > 4){
    warningList.push({
      field: "rateOption",
      message: `maximum rate Add On can be 4% including Capital raise and ABN`
    });
  }

  if (quote.residualValue > 0) {
    warningList.push({
      field: "residualValue",
      message: `Balloon is calculated on car price less any deposit or trade in.`
    });
    if (quote.term > 60) {
      errorList.push({
        field: "residualValue",
        message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
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