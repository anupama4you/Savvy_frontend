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
    "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.price",
    quote.price
  );
  if (quote.price === null || quote.price === 0) {
    errorList.push({
      field: "price",
      message: "Car Price cannot be Zero."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.loanTypeDetail",
    quote.price
  );
  if (!quote.loanTypeDetail) {
    errorList.push({
      field: "loanTypeDetail",
      message: "Please select Type of Finance."
    });
  } else {
    if (quote.applicationFee > quote.maxApplicationFee) {
      warningList.push({
        field: "applicationFee",
        message: `Application Fee should not be greater than $${quote.applicationFeeMax}`
      });
    }
    if (quote.monthlyFee != quote.MonthlyFeeRate) {
      warningList.push({
        field: "monthlyFee",
        message: `Monthly Fee should be $${quote.MonthlyFeeRate}`
      });
    }
    if (quote.commission > 500) {
      warningList.push({
        field: "commission",
        message: `Bonus Comission should not be greater than $500.00`
      });
    }
    if ('Mid-Prime Finance Only' === quote.loanTypeDetail) {
      if (quote.clientRate < quote.baseRate) {
        errorList.push({
          field: "commission",
          message: `Client rate should not be below of base rate: ${quote.baseRate}%.`
        });
      }
      if (quote.dof != 0.0) {
        warningList.push({
          field: "dof",
          message: `DOF should be Zero`
        });
      }
    } else {
      if (quote.clientRate < quote.baseRate || quote.clientRate > quote.maxRate) {
        warningList.push({
          field: "clientRate",
          message: `Client rate should be between ${quote.baseRate}% and ${quote.maxRate}%.`
        });
      }
      if (quote.dof < quote.dofRate || quote.dof > quote.maxDof) {
        warningList.push({
          field: "clientRate",
          message: `DOF should be between ${quote.dofRate}% and ${quote.maxDof}%.`
        });
      }
      if ('Sub-Prime Finance Only' === quote.loanTypeDetail || 'Sub-Prime Lite (pensioners) Finance Only' === quote.loanTypeDetail) {
        if (quote.riskFee < quote.riskFeeRate || quote.riskFee > quote.maxRiskFee) {
          warningList.push({
            field: "riskFee",
            message: `Risk Fee should be between $${quote.riskFeeRate} and $${quote.maxRiskFee}`
          });
        }
      }
      if (quote.term == 60) {
        errorList.push({
          field: "term",
          message: `Term should be 36 or 48`
        });
      }
    }
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.realtimeNaf",
    quote.realtimeNaf
  );
  if (quote.realtimeNaf < quote.minLoanRate || quote.realtimeNaf > quote.maxLoanRate) {
    warningList.push({
      field: "realtimeNaf",
      message: `Loan amount should be between $${quote.minLoanRate} and $${quote.maxLoanRate}`
    });
  }
  if (quote.applicationFee < 0.0) {
    errorList.push({
      field: "applicationFee",
      message: `Application Fee should not be below Zero.`
    });
  }
  if (quote.commission < 0.0) {
    errorList.push({
      field: "commission",
      message: `Bonus Comission should not be below Zero.`
    });
  }
  if ('Sub-Prime Vend & Lend' === quote.loanTypeDetail || 'Sub-Prime Lite (pensioners) Vend & Lend' === quote.loanTypeDetail || 'Mid-Prime Finance Only' === quote.loanTypeDetail) {
    if (quote.riskFee != 0.0) {
      warningList.push({
        field: "riskFee",
        message: `Risk Fee should be Zero`
      });
    }
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.loanPurpose",
    quote.loanPurpose
  );
  if (!quote.loanPurpose) {
    warningList.push({
      field: "loanPurpose",
      message: "Loan Purpose could be neccessary"
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