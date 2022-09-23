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

    const baseRate = quote["baseRate"];
    const maxRate = quote["maxRate"];

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

    if (quote.applicationFee === null || quote.applicationFee === 0) {
      warningList.push({
        field: "applicationFee",
        message: `Application Fee is not updated as the calculator does not contain relevant info.`
      });
    }

    if (quote.ppsr === null || quote.ppsr === 0) {
      warningList.push({
        field: "ppsr",
        message: `PPSR is not updated as the calculator does not contain relevant info.`
      });
    }

    if (quote.term === 72 || quote.term === 84) {
      warningList.push({
        field: "term",
        message: "Servicing will be calculated using a 5 year term."
      });
    }

    if (quote.privateSales === "Y") {
      warningList.push({
        field: "privateSales",
        message: "Max $100K for private sales."
      });
    }

    if (quote.assetType === "Motorhomes" || quote.assetType === "Caravan") {
      warningList.push({
        field: "assetType",
        message: "Equifax 1.1 score min 550 for this asset class"
      });
      if (quote.privateSales === "Y")
        errorList.push({
          field: "privateSales",
          message: "Caravan/Motorhome not available for private sale"
        });
      if (quote.propertyOwner === "N")
        errorList.push({
          field: "propertyOwner",
          message: "This asset type only available to property owner"
        });
    }

    if (quote.assetType === "Motorbikes") {
      if (quote.privateSales === "Y") {
        errorList.push({
          field: "privateSales",
          message: "Motorbike not available for private sale"
        });
      }
      if (quote.term > 60) {
        errorList.push({
          field: "term",
          message: "Maximum 60 month term for motorbikes"
        });
      }
      if (QuoteCommons.calcNetRealtimeNaf(quote) > 25000) {
        warningList.push({
          field: "",
          message: "Asset backed or min 20% deposit required"
        });
      }
    }

    // Asset backed
    if (
      quote.propertyOwner === "Y" &&
      quote.term / 12 + parseInt(quote.assetAge) > 18
    ) {
      warningList.push({
        field: "",
        message: "Max age of car at term end is 18 years for asset backed"
      });
    }

    if (
      quote.propertyOwner === "N" &&
      quote.term / 12 + parseInt(quote.assetAge) > 13
    ) {
      warningList.push({
        field: "",
        message:
          "Max age of vehicle at term end for non-property owners is 13 years"
      });
    }

    if (quote.applicationFee > 395) {
      errorList.push({
        field: "applicationFee",
        message: "Application Fee cannot exceed the max fee: $395.00"
      });
    }

    if (quote.dof > 990) {
      errorList.push({
        field: "dof",
        message: "DOF cannot exceed the max dof: $990.00"
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