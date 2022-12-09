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

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.clientRate",
    quote.clientRate
  );
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
  } else if (quote.applicationFee === null || quote.applicationFee === 0) {
    warningList.push({
      field: "applicationFee",
      message: `Application Fee is not updated as the calculator does not contain relevant info.`
    });
  } else if (quote.ppsr === null || quote.ppsr === 0) {
    warningList.push({
      field: "ppsr",
      message: `PPSR is not updated as the calculator does not contain relevant info.`
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.propertyOwner",
    quote.propertyOwner
  );
  const assetAge = parseInt(new Date().getFullYear()) - parseInt(quote.assetYear)
  const years = quote.term / 12;
  if (quote.propertyOwner === "Y") {
    if (18 < assetAge + years) {
      warningList.push({
        field: "assetYear",
        message: `maximum age of car is 13 years for property owners`
      });
    }
    if (13 < assetAge - years) {
      warningList.push({
        field: "assetYear",
        message: `maximum age of car is 13 years for property owners`
      });
    }
  } else {
    if (13 < assetAge + years) {
      errorList.push({
        field: "assetYear",
        message: `Car cannot exceed 13 years at term end for non-property owners`
      });
    }
  }

  // Car Age 
  if (quote.assetCondition === "New" || quote.assetCondition === "Demo" && parseInt(quote.assetYear) < 2022) {
    warningList.push({
      field: "",
      message: "Please check Asset Condition vs Car Age"
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.price",
    quote.price
  );
  if (quote.propertyOwner === "Y") {
    if (quote.productType === "Lite") {
      if (quote.price > 40000) {
        warningList.push({
          field: "price",
          message: 'Property owner Maximum car price (excl fees) $40,000'
        });
      }
    } else if (quote.productType === "Express") {
      if (quote.price > 100000) {
        warningList.push({
          field: "price",
          message: 'Property owner Maximum finance (excl fees) $100,000'
        });
      }
    }
  } else {
    if (quote.productType === "Lite") {
      if (quote.price > 40000) {
        warningList.push({
          field: "price",
          message: 'Non-Property owner Maximum finance (excl fees) $40,000'
        });
      }
      const deposit = (100 * quote.deposit) / quote.price
      if (deposit <= 10) {
        warningList.push({
          field: "price",
          message: 'Non-Property owner 10% deposit required'
        });
      }
      warningList.push({
        field: "price",
        message: 'Credit reference may be required'
      });
    } else if (quote.productType === "Express") {
      if (quote.price > 100000) {
        warningList.push({
          field: "price",
          message: 'Non-Property owner Maximum finance (excl fees) $100,000'
        });
      }
      const deposit = (100 * quote.deposit) / quote.price
      if (deposit <= 20) {
        warningList.push({
          field: "price",
          message: '20% deposit required'
        });
      }
      warningList.push({
        field: "price",
        message: 'Credit reference may be required'
      });
    }
  }

  // ABN/GST
  if (quote.gst === "" || quote.gst === null) {
    errorList.push({
      field: "gst",
      message: "ABN/GST is required"
    });
  }

  if (quote.gst === "ABN/GST > 3 years") {
    warningList.push({
      field: "gst",
      message: "Non-Property owner Maximum finance (excl fees) $100,000"
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