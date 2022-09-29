import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteGroupAndGeneralCalcHelper";

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
  const maxRate = 16.5;

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 18 ~ validate ~ quote", quote);
  let naf = CalHelper.getNetRealtimeNaf(quote);

  if (quote.price === null || quote.price === 0.0) {
    errorList.push({
      field: "price",
      message: "Vehicle Price cannot be Zero."
    });
  }

  if (quote.applicationFee < 0.0) {
    errorList.push({
      field: "applicationFee",
      message: "Application Fee cannot be below Zero."
    });
  }

  if (quote.dof == null || quote.dof == 0.0) {
    errorList.push({
      field: "dof",
      message: "DOF cannot be Zero."
    });
  } else if (quote.dof > quote.maxDof) {
    warningList.push({
      field: "dof",
      message: `Max DOF allowed is $${quote.maxDof}`
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
  }

  if (quote.realtimeNaf <= 7999 && quote.term > 36) {
    warningList.push({
      field: "term",
      message: "Maximum loan term should be 36 for loans up to $7.9999."
    });
  } else if (quote.term == 84 && (quote.realtimeNaf < 8000 || quote.realtimeNaf > 40000)) {
    warningList.push({
      field: "term",
      message: `84 months for loans should be between $8.000 and $40.000.`
    });
  }

  if ('Secured' === quote.loanTypeDetail) {
    if(quote.realtimeNaf < 15000){
      warningList.push({
        field: "realtimeNaf",
        message: "Loan amount should be between $15.000 and $50.000 (Secured)"
      });
    }
  } else {
    if(quote.realtimeNaf < 5000 || quote.realtimeNaf > 40000){
      warningList.push({
        field: "realtimeNaf",
        message: "Loan amount should be between $5.000 and $40.000 (Unsecured)"
      });
    }
  }

  if (quote.residual > 0 && quote.term > 60) {
    errorList.push({
      field: "residual",
      message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
    });
  }

  if (!quote.loanPurpose) {
    warningList.push({
      field: "loanPurpose",
      message: "Loan Purpose could be neccessary"
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