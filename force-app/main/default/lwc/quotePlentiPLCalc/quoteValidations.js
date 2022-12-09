import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quotePlentiPLCalcHelper";

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
  const NAF = CalHelper.getNetRealtimeNaf(quote);

  console.log("NAF===>" + NAF);

  if (quote.price === null || quote.price == 0) {
    errorList.push({
      field: "price",
      message: "Loan amount cannot be Zero."
    });
  } else if (NAF > 45000) {
    warningList.push({
      field: "",
      message: "NAF should not over come $45.000. Current value: $" + NAF
    });
  }
  if (quote.applicationFee === null || quote.applicationFee == 0) {
    errorList.push({
      field: "applicationFee",
      message: "Application Fee cannot be Zero."
    });
  }
  if (quote.dof == null || quote.dof == 0) {
    errorList.push({
      field: "dof",
      message: "DOF cannot be Zero."
    });
  } else if (quote.dof > quote.maxDof) {
    errorList.push({
      field: "dof",
      message:
        "Max DOF is 10% of the Loan Amount or $" +
        quote.maxDof +
        ". Please adjust."
    });
  }
  if (quote.clientRate == null || quote.clientRate == 0) {
    errorList.push({
      field: "clientRate",
      message: "Client Rate cannot be Zero."
    });
  }
  if (quote.residual > 0 && quote.term > 60) {
    errorList.push({
      field: "term",
      message:
        "You cannot have a balloon or residual payment when the loan term is > 5 years."
    });
  }
  if (quote.purposeType == "" || quote.purposeType == null) {
    errorList.push({
      field: "purposeType",
      message: "Please select a Loan Purpose option"
    });
  }
  if (
    quote.purposeType == "Other" &&
    (quote.loanPurpose == null || quote.loanPurpose == "")
  ) {
    errorList.push({
      field: "loanPurpose",
      message: "The Loan Purpose needs to be inserted into the quoting tool"
    });
  }
  if (
    quote.purposeType == "Other" &&
    quote.loanPurpose != null &&
    quote.loanPurpose != "" &&
    quote.loanPurpose.length > 40
  ) {
    warningList.push({
      field: "loanPurpose",
      message: "Loan Purpose is long, please include no more than 40 characters"
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

  if (quote.commission < 0.0) {
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