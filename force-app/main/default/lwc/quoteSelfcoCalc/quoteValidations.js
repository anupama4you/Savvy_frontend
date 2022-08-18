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

  const baseRate = quote["baseRate"];
  const maxRate = quote["maxRate"];
  const MAX_BROKERAGE = 8.0;

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.assetAge & quote.assetType",
    quote.assetAge, quote.assetType
  );
  if (parseInt(quote.assetAge) > 15 && quote.assetType === 'Tier 1 - Auto') {
    errorList.push({
      field: "assetType",
      message: "Auto max 15 at term end"
    });
  } else if (parseInt(quote.assetAge) > 25 && quote.assetType === 'Trucks/Medical equip') {
    errorList.push({
      field: "assetType",
      message: "Trucks/Trailers max 25 at term end"
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 32 ~ validate ~ quote.baseRate",
    quote.baseRate
  );
  if (quote.baseRate === null || quote.baseRate === 0.0) {
    errorList.push({
      field: "baseRate",
      message: "Base Rate cannot be Zero."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 32 ~ validate ~ quote.term",
    quote.term
  );
  if (quote.term === null || quote.term == 0) {
    errorList.push({
      field: "term",
      message: "Please choose an appropriate term."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 54 ~ validate ~ quote.clientRate",
    quote.clientRate
  );
  if (quote.clientRate === null || quote.clientRate == 0) {
    errorList.push({
      field: "clientRate",
      message: "Client Rate is not updated as the calculator does not contain relevant info."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 54 ~ validate ~ quote.price",
    quote.price
  );
  if (quote.price === null || quote.price == 0) {
    errorList.push({
      field: "price",
      message: "Cost of Goods is not updated as the calculator does not contain relevant info."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 76 ~ validate ~ quote.dof",
    quote.dof
  );
  if (quote.dof === null || quote.dof == 0) {
    errorList.push({
      field: "dof",
      message: "DOF is not updated as the calculator does not contain relevant info."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 76 ~ validate ~ quote.applicationFee",
    quote.applicationFee
  );
  if (quote.applicationFee === null || quote.applicationFee == 0) {
    errorList.push({
      field: "applicationFee",
      message: "Application Fee is not updated as the calculator does not contain relevant info."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 76 ~ validate ~ quote.ppsr",
    quote.ppsr
  );
  if (quote.ppsr === null || quote.ppsr == 0) {
    errorList.push({
      field: "ppsr",
      message: "PPSR is not updated as the calculator does not contain relevant info."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 32 ~ validate ~ quote.privateSales",
    quote.privateSales
  );
  if (!quote.privateSales) {
    errorList.push({
      field: "privateSales",
      message: "Please choose a Private Sale option."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 76 ~ validate ~ quote.abnLength",
    quote.abnLength
  );
  if (quote.abnLength === '< 2 years') {
    errorList.push({
      field: "abnLength",
      message: "ABN must be registered for 2 years."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 87 ~ validate ~ quote.gstLength",
    quote.gstLength
  );
  if (quote.gstLength != '< 2 years' && quote.gstLength != '> 2 years') {
    errorList.push({
      field: "gstLength",
      message: "Please choose a GST Length"
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 87 ~ validate ~ quote.realtimeNaf",
    quote.realtimeNaf
  );
  if (quote.brokeragePercentage > MAX_BROKERAGE) {
    errorList.push({
      field: "realtimeNaf",
      message: `Brokerage cannot be greater than ${MAX_BROKERAGE.toFixed(2)}%`
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 132 ~ validate ~ quote.residualValue",
    quote.residualValue
  );
  if (quote.residualValue > 0 && quote.term > 60) {
    errorList.push({
      field: "residualValue",
      message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
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

  if (quote.monthlyPayment === null || quote.monthlyPayment === 0) {
    warningList.push({
      field: "monthlyPayment",
      message: `Payment is not updated as the calculator does not contain relevant info.`
    });
  }

  if (quote.commission === null || quote.commission === 0) {
    warningList.push({
      field: "commission",
      message: `Estimated Commission is not updated as the calculator does not contain relevant info.`
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