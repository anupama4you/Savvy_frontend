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

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote", quote);

  if (quote.price === null || !(quote.price > 0.0)) {
    errorList.push({
      field: "price",
      message: "Loan Amount should not be Zero."
    });
  }
  if (quote.applicationFee === null || !(quote.applicationFee > 0.0)) {
    errorList.push({
      field: "applicationFee",
      message: "Application Fee cannot be Zero."
    });
  } else if(quote.applicationFee > quote.maxApplicationFee) {
    errorList.push({
      field: "applicationFee",
      message: `Max Application Fee exceed. Max value $${quote.maxApplicationFee}.`
    });
  }
  if (quote.dof === null || !(quote.dof > 0.0)) {
    errorList.push({
      field: "dof",
      message: "DOF cannot be Zero."
    });
  } else if(quote.dof > quote.maxDof) {
    errorList.push({
      field: "dof",
      message: `Max DOF Fee exceed. Max value $${quote.maxDof}.`
    });
  }
  if (quote.creditScore === null || !(quote.creditScore > 0.0)) {
    errorList.push({
      field: "creditScore",
      message: "Credit Score should be filled."
    });
  }
  if (quote.clientRate === null || !(quote.clientRate > 0.0)) {
    errorList.push({
      field: "clientRate",
      message: "Client Rate should not be zero."
    });
  } else if (quote.clientRate < quote.baseRate) {
    warningList.push({
      field: "clientRate",
      message: `Client Rate should not be below base rate.`
    });
  }
  if (quote.baseRate === 0.00) {
    warningList.push({
      field: "baseRate",
      message: "Base Rate cannot be Zero."
    });
  }
  if (quote.residualValue > 0 || Number(quote.term) > 60) {
    errorList.push({
      field: "residualValue",
      message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
    });
  }
  if (quote.loanPurpose === null || quote.loanPurpose === '') {
    warningList.push({
      field: "loanPurpose",
      message: "The Loan Purpose is neccessary for any approval."
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