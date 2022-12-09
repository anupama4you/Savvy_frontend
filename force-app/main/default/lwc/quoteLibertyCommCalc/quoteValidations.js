import { QuoteCommons } from "c/quoteCommons";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages, settings, params) => {
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
    const naf = params && params.naf > 0 ? params.naf : 0;

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
    if (naf <= 5000) {
      errorList.push({
        field: "price",
        message: "The minimum Loan Amount is $5,000."
      });
    }

    const lenderAppFee = settings.Application_Fee__c;
    const maxAppFee = lenderAppFee + settings.DOF__c;

    console.log(
      "🚀 ~ file: quoteValidations.js ~ line 24 ~ validate ~ quote.applicationFee",
      quote.applicationFee
    );
    if (quote.applicationFee === null || quote.applicationFee < lenderAppFee) {
      errorList.push({
        field: "applicationFee",
        message: `Application fee cannot fall below $${lenderAppFee.toFixed(2)}`
      });
    } else if (quote.applicationFee > maxAppFee) {
      errorList.push({
        field: "applicationFee",
        message: `The application fee cannot exceed $${maxAppFee.toFixed(2)}`
      });
    }

    if (quote.dof === null || quote.dof < settings.DOF__c) {
      warningList.push({
        field: "applicationFee",
        message: `DOF is less than maximum $${settings.DOF__c.toFixed(2)}`
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

    //LTV
    if (
      quote.ltv === undefined ||
      quote.ltv === null
    ) {
      errorList.push({
        field: "ltv",
        message: `LTV value is required.`
      });
    } else {
      let ltvLimit = undefined;
      let creditHistory = undefined;
      let maximumLoan = 50000;

      if ("AAA" === quote.riskGrade) {
        ltvLimit = 120;
        maximumLoan = 100000;
        creditHistory = "Warning: No adverse allowed";
      } else if ("AA" === quote.riskGrade) {
        ltvLimit = 150;
        maximumLoan = 100000;
        creditHistory = "Warning: No adverse allowed";
      } else if ("A" === quote.riskGrade && "N" === quote.propertyOwner) {
        ltvLimit = 100;
        creditHistory = "Warning: No adverse and confirmable credit required.";
        maximumLoan = 80000;
      } else if ("A" === quote.riskGrade && "Y" === quote.propertyOwner) {
        ltvLimit = 150;
        creditHistory = "Warning: Non financial defaults> 12 months and < $1000";
        maximumLoan = 80000;
      } else if ("B" === quote.riskGrade && "Y" === quote.propertyOwner) {
        ltvLimit = 120;
      } else if ("B" === quote.riskGrade && "N" === quote.propertyOwner) {
        ltvLimit = 90;
      } else if ("C" === quote.riskGrade && "Y" === quote.propertyOwner) {
        ltvLimit = 100;
      } else if ("C" === quote.riskGrade && "N" === quote.propertyOwner) {
        ltvLimit = 80;
        maximumLoan = 35000;
      }

      if ("No GST" === quote.gstLength) {
        maximumLoan = 35000;
      }

      if (quote.ltv > ltvLimit) {
        warningList.push({
          field: "ltv",
          message: `Maximum value for LTV is ${ltvLimit}%.`
        });
      }
      if (creditHistory) {
        warningList.push({
          field: "creditHistory",
          message: creditHistory
        });
      }
      
      if (quote.riskGrade && quote.riskGrade !== null && naf > maximumLoan) {
        warningList.push({
          field: "maximumLoan",
          message: `The maximum loan amount is $${maximumLoan}`
        });
      }

    }

    // residual value
    if (
      quote.residual &&
      (riskGrade === "A" || riskGrade === "B" || riskGrade === "C")
    ) {
      warningList.push({
        field: "residual",
        message:
          "Residuals are not available for risk grades A,B,C. Refer to your bdm"
      });
    }

    if ("N" === quote.propertyOwner && "AAA" === quote.riskGrade) {
      errorList.push({
        field: "riskGrade",
        message: `${quote.riskGrade} risk grade unavailable for Non-home owner`
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

  r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
  r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
  return r;
};

const Validations = {
  validate: validate,
  validatePostCalculation: validatePostCalculation
};

export { Validations };