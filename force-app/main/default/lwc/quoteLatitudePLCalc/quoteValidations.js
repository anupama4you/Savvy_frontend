import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteLatitudePLCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages, isApproval) => {
  const r =
    typeof messages == "undefined" || messages == null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

  const baseRate = quote["baseRate"];
  const maxDofRate = CalHelper.getDOF(quote);

  console.log(`@@validation:`, JSON.stringify(quote, null, 2));

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.price",
    quote.price
  );
  if (quote.price === null || quote.price === 0) {
    errorList.push({
      field: "price",
      message: "Finance amount should not be Zero."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 20 ~ validate ~ quote.dof",
    quote.dof
  );
  if (quote.dof === null || quote.dof === 0) {
    errorList.push({
      field: "dof",
      message: "DOF should not be Zero."
    });
  } else if (quote.dof > quote.maxDof) {
    errorList.push({
      field: "DOF",
      message: `Max DOF exceeded: ${quote.maxDof}%`
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 19 ~ validate ~ quote.ppsr",
    quote.ppsr
  );
  if (quote.ppsr === null) {
    warningList.push({
      field: "ppsr",
      message: "PPSR should not be zero."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 19 ~ validate ~ quote.registrationFee",
    quote.registrationFee
  );
  if (quote.registrationFee === null || quote.registrationFee === 0 ) {
    warningList.push({
      field: "registrationFee",
      message: "Registration/Research Fee should not be zero."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.clientRate",
    quote.clientRate
  );
  if (quote.clientRate === null || quote.clientRate == 0.0) {
    errorList.push({
      field: "clientRate",
      message: "Client Rate should not be zero."
    });
  } else if (quote.baseRate > quote.clientRate) {
    errorList.push({
      field: "clientRate",
      message: `Client Rate should not be below base rate`
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 19 ~ validate ~ quote.residual",
    quote.residual
  );
  if (quote.residual > 0 && quote.term > 60) {
    errorList.push({
      field: "residual",
      message: "You should not have a balloon or residual payment when the loan term is > 5 years"
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 19 ~ validate ~ quote.loanPurpose",
    quote.loanPurpose
  );
  if (!quote.loanPurpose) {
    const msg = isApproval ? 'The Loan Purpose needs to be inserted into the quoting tool' 
    : 'The Loan Purpose is necessary for any approval';
    warningList.push({
      field: "loanPurpose",
      message: msg
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