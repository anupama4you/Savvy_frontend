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

    // client rate
    if (quote.clientRate === null || !(quote.clientRate > 0.0)) {
      errorList.push({
        field: "clientRate",
        message: "Client Rate cannot be zero."
      });
    }

    // price
    if (quote.price === null || quote.price === 0)
      errorList.push({
        field: "price",
        message: "Car Price cannot be Zero."
      });

    // dof
    if (quote.dof === null || quote.dof === 0) {
      errorList.push({
        field: "dof",
        message: "DOF cannot be Zero."
      });
    } else if (quote.dof > quote.maxDof) {
      errorList.push({
        field: "dof",
        message: `DOF should not exceed ${quote.maxDof}.`
      });
    }

    // applicationFee
    if (quote.applicationFee === null || quote.applicationFee === 0) {
      errorList.push({
        field: "applicationFee",
        message: "Application Fee cannot be Zero."
      });
    } else if (quote.applicationFee > quote.maxApplicationFee) {
      errorList.push({
        field: "applicationFee",
        message: `Application Fee should not exceed ${quote.maxApplicationFee}.`
      });
    }

    // brokerage
    if (quote.brokerage === null || quote.brokerage === 0) {
      errorList.push({
        field: "brokerage",
        message: "Brokerage Fee cannot be Zero."
      });
    } else if (quote.brokerage > 8) {
      errorList.push({
        field: "brokerage",
        message: "Brokerage cannot be greater than 8%"
      });
    }

    // base rate
    if (quote.baseRate === null || quote.baseRate === 0)
      errorList.push({
        field: "baseRate",
        message: "Base Rate cannot be zero."
      });

    if (quote.vehicleCondition === "Used" && quote.greenCar === "Y")
      errorList.push({
        field: "vehicleCondition",
        message:
          "Used condition and green car should not be selected at the same time."
      });

    if (
      quote.assetType === "Passenger and Commercial Vehicles" ||
      quote.assetType === "Wheeled Plant & Equipment"
    ) {
      // price
      if (QuoteCommons.calcNetRealtimeNaf(quote) < 5000)
        errorList.push({
          field: "",
          message: "NAF must be over $5,000, please check your information."
        });
    } else {
      if (QuoteCommons.calcNetRealtimeNaf(quote) < 10000)
        errorList.push({
          field: "",
          message: "NAF must be over $10,000, please check your information."
        });
    }

    /// ----- warning
    if (quote.vehicleCondition === "Used" && quote.assetAge === 0) {
      warningList.push({
        field: "assetAge",
        message: "You are quoting a Used vehicle - pls check car age"
      });
    } else if (quote.vehicleCondition === "New/Demo" && quote.assetAge > 0) {
      warningList.push({
        field: "assetAge",
        message: "You are quoting New/Demo - pls check car age"
      });
    }

    r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
    r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
    return r;
  } catch (error) {
    console.error(error);
  }
};

const validatePostCalculation = (quote, messages) => {
  try {
    const r =
      typeof messages == "undefined" || messages == null
        ? QuoteCommons.resetMessage()
        : messages;
    let errorList = r.errors;
    let warningList = r.warnings;
    console.log("post validation ...     >> ", JSON.stringify(r, null, 2));
    if (quote.commission === null || !(quote.commission > 0.0)) {
      warningList.push({
        field: "Commissions and Repayments",
        message: `The commission is below zero. Please make adjustment to make sure commission is above zero.`
      });
    }

    r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
    r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
    return r;
  } catch (error) {
    console.log(error);
  }
};

const Validations = {
  validate: validate,
  validatePostCalculation: validatePostCalculation
};

export { Validations };