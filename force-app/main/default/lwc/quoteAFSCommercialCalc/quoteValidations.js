import { QuoteCommons } from "c/quoteCommons";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} afsRates - afs rates
 * @param {Object} messages - old messages object
 * @param {Object} nafVal - total naf
 * @returns
 */

const validate = (quote, messages, nafVal, afsRates) => {
  const r =
    typeof messages == "undefined" || messages == null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

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

  if (!quote.gst) {
    errorList.push({
      field: "gst",
      messages: "GST is required."
    });
  }

  if (!quote.residency) {
    errorList.push({
      field: "residency",
      messages: "Residency is required."
    });
  }

  if (quote.clientRate == null || quote.clientRate === 0.0) {
    errorList.push({
      field: "clientRate",
      message: "Client Rate cannot be Zero."
    });
  } else {
    //TO DO min and max client rate
    if (afsRates.length !== 0 && afsRates !== null) {
      let minRate = 0.0;
      let maxRate = 0.0;
      let afsRateSize = afsRates.length - 1;

      if (quote.gst === "Not Registered") {
        minRate = afsRates[3].rate !== null ? afsRates[3].rate : 0.0;
        maxRate =
          afsRates[afsRateSize].rate != null ? afsRates[afsRateSize].rate : 0.0;
      } else if (
        quote.residency === "Home Buyer" ||
        (quote.residency === "Non-Home Buyer" &&
          quote.carAge === "Used 7 years+")
      ) {
        minRate = afsRates[0].rate !== null ? afsRates[0].rate : 0.0;
        maxRate =
          afsRates[afsRateSize].rate != null ? afsRates[afsRateSize].rate : 0.0;
      } else {
        minRate = afsRates[6].rate !== null ? afsRates[6].rate : 0.0;
        maxRate =
          afsRates[afsRateSize].rate != null ? afsRates[afsRateSize].rate : 0.0;
      }

      if (quote.clientRate < minRate) {
        errorList.push({
          field: "clientRate",
          message: `The minimun Client Rate for ${quote.carAge} is ${minRate}%, please check your value and try again.`
        });
      }

      if (quote.clientRate > maxRate && quote.gst !== "Registered") {
        errorList.push({
          field: "clientRate",
          message: `The maximun Client Rate for ${quote.carAge} is ${maxRate}%, please check your value and try again.`
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

  if (quote.residual > 0 && quote.price != null) {
    let cp = quote.price - quote.netDeposit;
    if (cp !== 0) {
      let pb = (quote.residual / cp) * 100;
      if (quote.term === 12 && pb > 60.0) {
        errorList.push({
          message: `Balloon should not exceed 60% of vehicle price for 12 months term. Current value [ ${pb} %]`
        });
      } else if (quote.term === 24 && pb > 55.0) {
        errorList.push({
          message: `Balloon should not exceed 55% of vehicle price for 24 months term. Current value [ ${pb} %]`
        });
      } else if (quote.term === 36 && pb > 50.0) {
        errorList.push({
          message: `Balloon should not exceed 50% of vehicle price for 36 months term. Current value [ ${pb} %]`
        });
      } else if (quote.term === 48 && pb > 40.0) {
        errorList.push({
          message: `Balloon should not exceed 40% of vehicle price for 48 months term. Current value [ ${pb} %]`
        });
      } else if (quote.term === 60 && pb > 30.0) {
        errorList.push({
          message: `Balloon should not exceed 30% of vehicle price for 60 months term. Current value [ ${pb} %]`
        });
      }
    }
  }

  if (quote.residency === "Home Buyer" && nafVal > 75000) {
    warningList.push({
      field: "residency",
      message: "Max NAF of $75,000"
    });
  } else if (quote.residency === "Non-Home Buyer" && nafVal > 50000) {
    warningList.push({
      message: "Max NAF of $50,000"
    });
  }

  if (quote.gst === "Not Registered" && nafVal > 35000) {
    warningList.push({
      message: "max NAF $35K for non GST registered"
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