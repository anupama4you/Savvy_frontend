import { QuoteCommons } from "c/quoteCommons";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @param {Object} application - application record
 * @returns
 */

const validate = (quote, messages, application) => {
  const r =
    typeof messages == "undefined" || messages == null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

  //required validation
  if (quote.loanProduct === null) {
    errorList.push({
      field: "loanProduct",
      message: "Loan Product is required."
    });
  }

  if (quote.assetCondition === null) {
    errorList.push({
      field: "assetCondition",
      message: "Asset Condition is required."
    });
  }

  if (quote.residency === null) {
    errorList.push({
      field: "residency",
      message: "Residency is required."
    });
  }

  if (quote.assetAge === null) {
    errorList.push({
      field: "assetAge",
      message: "Asset Age is required."
    });
  }

  if (quote.employmentStats === null) {
    errorList.push({
      field: "employmentStats",
      message: "Casual <12 months or Contract is required."
    });
  }

  if (quote.creditImpaired === null) {
    errorList.push({
      field: "creditImpaired",
      message: "Credit Impaired is required."
    });
  }

  if (!quote.imports) {
    errorList.push({
      field: "imports",
      message: "Imports is required."
    });
  }

  if (quote.odometerReading === null) {
    errorList.push({
      field: "odometerReading",
      message: "Odometer Reading is required."
    });
  }

  if (quote.privateSales === null) {
    errorList.push({
      field: "privateSales",
      message: "Private Sales is required."
    });
  }

  if (quote.loanProduct !== null && quote.residency !== null) {
    if (quote.loanProduct === "Gold Club - Non-Property") {
      if (quote.residency === "Property Owner") {
        errorList.push({
          field: "residency",
          message: "This product is for non-property owners only."
        });
      }

      if (application.length !== 0 && application != null) {
        if (
          application.length === 2 &&
          application[1] !== null &&
          application[1] !== "Full Time"
        ) {
          errorList.push({
            message: "This product is not suitable for casual employees"
          });
        }
      } else {
        errorList.push({
          message: "Application is required."
        });
      }

      if (
        quote.assetType === "Car" &&
        quote.assetCondition === "Used" &&
        quote.assetAge != null &&
        quote.assetAge !== "0-3 years"
      ) {
        errorList.push({
          message: "Only cars 0-3 years old qualify for this product"
        });
      }
    }
  }

  if (quote.price === null || quote.price === 0.0) {
    errorList.push({
      field: "price",
      message: "Car Price cannot be Zero."
    });
  }

  if (quote.applicationFee === null || quote.applicationFee === 0.0) {
    errorList.push({
      field: "applicationFee",
      message: "Application Fee cannot be Zero."
    });
  }

  if (quote.dof === null || quote.dof === 0.0) {
    errorList.push({
      field: "dof",
      message: "DOF cannot be Zero."
    });
  } else if (quote.dof > 990) {
    errorList.push({
      field: "dof",
      message: "DOF cannot be more than $990."
    });
  }

  if (quote.payDayEnquiries === "Within last six months") {
    errorList.push({
      field: "payDayEnquiries",
      message: "Pay Day Enquiries Within last six months is outside guidelines."
    });
  } else {
    if (quote.clientRate == null || quote.clientRate === 0.0) {
      errorList.push({
        field: "clientRate",
        message: "Client Rate cannot be Zero."
      });
    } else {
      let minRate = quote.baseRate;
      let maxRate = quote.baseRate + 2;

      if (quote.clientRate < minRate) {
        errorList.push({
          field: "clientRate",
          message: `The minimun Client Rate should be ${minRate}%, please check your value and try again.`
        });
      }
      if (quote.clientRate > maxRate) {
        errorList.push({
          field: "clientRate",
          message: `The maximun Client Rate should be ${maxRate}%, please check your value and try again.`
        });
      }
    }
  }

  if (quote.term === null || quote.term === 0) {
    errorList.push({
      field: "term",
      message: "Please choose an appropriate term."
    });
  }

  if (quote.residual > 0 && quote.term > 60) {
    errorList.push({
      field: "residual",
      message:
        "You cannot have a balloon or residual payment when the loan term is > 5 years."
    });
  }

  if (quote.assetType === null) {
    errorList.push({
      field: "assetType",
      message: "Please select an Asset Type."
    });
  } else if (quote.term > 60) {
    if (quote.assetType === "Leisure") {
      if (quote.residency !== "Property Owner") {
        errorList.push({
          field: "term",
          message:
            "Only Property Owners are allowed for more than 5 years terms"
        });
      }
    }
  }

  if (quote.assetType === "Bikes / Scooters" && quote.term > 60) {
    warningList.push({
      message: "Warning: Max term on bikes is 5 years"
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

  if (quote.commission <= 0) {
    warningList.push({
      message:
        "The commission is below zero. Please make adjustment to make sure commission is above zero."
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