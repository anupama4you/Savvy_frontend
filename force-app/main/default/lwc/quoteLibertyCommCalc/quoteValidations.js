import { QuoteCommons } from "c/quoteCommons";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
  try {
    const r =
      typeof messages == "undefined" || messages == null
        ? QuoteCommons.resetMessage()
        : messages;
    let errorList = r.errors;
    let warningList = r.warnings;
    const currentYear = new Date().getFullYear();
    const baseRate = quote["baseRate"];
    const maxRate = quote["maxRate"];
    const assetAge = quote["assetAge"];
    const riskGrade = quote["riskGrade"];

    // client rate
    if (quote.clientRate === null || !(quote.clientRate > 0.0)) {
      errorList.push({
        field: "clientRate",
        message: "Client Rate cannot be zero."
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

    // base rate
    if (quote.baseRate === null || quote.baseRate === 0)
      errorList.push({
        field: "baseRate",
        message: "Base Rate cannot be zero."
      });

    // credit score
    if (quote.creditScore === null || quote.creditScore === 0)
      errorList.push({
        field: "creditScore",
        message: "Credit Score is required."
      });

    // ABN
    if (quote.abnLength === null || quote.abnLength === 0)
      errorList.push({
        field: "abnLength",
        message: "ABN Length is required"
      });

    // GST
    if (quote.gstLength === null || quote.gstLength === 0)
      errorList.push({
        field: "gstLength",
        message: "GST Length is required"
      });

    // price
    if (quote.price <= 5000) {
      errorList.push({
        field: "price",
        message: "The minimum Loan Amount is $5,000."
      });
    }

    // dof
    if (quote.dof < 1450) {
      warningList.push({
        field: "dof",
        message: "DOF is less than maximum $1,450"
      });
    }

    // Vehicle year
    if (!quote.vehicleYear) {
      errorList.push({
        field: "vehicleYear",
        message: "Vehicle Year is required."
      });
    } else {
      // new
      if (assetAge === "New" && quote.vehicleYear !== `${currentYear}`)
        errorList.push({
          field: "vehicleYear",
          message: `Vehicle Year should be ${currentYear}`
        });
      // 0-4 years
      if (
        assetAge === "0-4 years" &&
        (quote.vehicleYear === `${currentYear}` ||
          quote.vehicleYear < `${currentYear - 4}`)
      )
        errorList.push({
          field: "vehicleYear",
          message: "Vehicle Year should be less than 4 years"
        });
      // 5-9 years
      if (
        assetAge === "5-9 years" &&
        (quote.vehicleYear > `${currentYear - 5}` ||
          quote.vehicleYear < `${currentYear - 9}`)
      )
        errorList.push({
          field: "vehicleYear",
          message: `Vehicle Year should be between ${currentYear - 9} and ${
            currentYear - 5
          }`
        });
      // 10+ years
      if (assetAge === "10+ years" && quote.vehicleYear > `${currentYear - 10}`)
        errorList.push({
          field: "vehicleYear",
          message: "Vehicle Year shouldn't be less than 10 years"
        });
    }

    // residual value
    if (
      quote.residual &&
      (riskGrade === "A" || riskGrade === "B" || riskGrade === "C")
    )
      warningList.push({
        field: "residual",
        message:
          "Residuals are not available for risk grades A,B,C. Refer to your bdm"
      });

    r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
    r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
    return r;
  } catch (error) {
    console.error(error);
  }
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