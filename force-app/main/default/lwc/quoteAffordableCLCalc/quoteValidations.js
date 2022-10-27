import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteAffordableCLCalcHelper";

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

  if (quote.price === null || !(quote.price > 0.0)) {
    errorList.push({
      field: "price",
      message: "Vehicle Price cannot be Zero."
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
  if ((quote.riskFee === "" || !(quote.riskFee > 0.0)) && quote.clientRate >= 10.00) {
    errorList.push({
      field: "riskFee",
      message: "Risk Fee should be entered."
    });
  } else if(quote.riskFeeTotal > 0 && quote.riskFee < quote.riskFeeTotal) {
    warningList.push({
      field: "riskFee",
      message: `Risk fee is below that the calculated fee $${quote.riskFeeTotal}.`
    });
  }
  if(quote.riskFeeTotal > 0 && quote.riskFee > quote.riskFeeTotal){
    warningList.push({
      field: "riskFee",
      message: `Risk fee should not be greater than Risk fee calculated $${quote.riskFeeTotal}.`
    });
  } else if (quote.clientRate < 10 && quote.riskFee > quote.riskFeeTotal) {
    warningList.push({
      field: "riskFee",
      message: `Not Risk fee calculated for client rates below 9.99%.`
    });
  }
  if (quote.clientRate === "" || quote.clientRate === 0.0) {
    errorList.push({
      field: "clientRate",
      message: `Client Rate can not be Zero.`
    });
  } else if(quote.clientRate > quote.maxRate || quote.clientRate < quote.baseRate){
    warningList.push({
      field: "clientRate",
      message: `Please check client rate - out of the range.`
    });
  }
  if (quote.creditScore === "") {
    errorList.push({
      field: "creditScore",
      message: "Please select an option for Credit Score."
    });
  }
  if (quote.term === "") {
    errorList.push({
      field: "term",
      message: "Please choose an appropriate term."
    });
  } else if(quote.vehicleYear !== "") {
    let today = new Date();
    let year = today.getFullYear();
    let carAge = Number(year) - Number(quote.vehicleYear) + Number(quote.term/12);
    if(carAge>20) {
      errorList.push({
        field: "vehicleYear",
        message: "The age of car combined with the term should not exceed 20 years."
      });
    }
  }
  if (quote.vehicleYear === "") {
    errorList.push({
      field: "vehicleYear",
      message: "Please select an appropriated value for Year."
    });
  }
  if('Manual' === quote.commType && (quote.commPayable === "" || quote.commPayable === 0.00)) {
    errorList.push({
      field: "commPayable",
      message: "Estimated Commission should not be zero, please adjust your Commision Payable amount."
    });
  }
  if (CalHelper.getNetRealtimeNaf(quote) < 7000) {
    warningList.push({
      field: "naf",
      message: `Min NAF should be $5,000.`
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