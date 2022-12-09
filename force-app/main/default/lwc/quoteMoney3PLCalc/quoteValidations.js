import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteMoney3PLCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
  console.log('triggerValidate:::')
  const r =
    typeof messages == "undefined" || messages == null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

  const baseRate = quote["baseRate"];
  const maxRate = quote["maxRate"];
  const netDeposit = quote["netDeposit"];
  const NAF = CalHelper.calculateRealTimeNaf(quote);
  console.log("quote for validation >> " + JSON.stringify(quote, null, 2));

  if (!quote.price || quote.price === 0) {
    errorList.push({
      field: "price",
      message: "Car Price cannot be Zero."
    });
  }
  if (!quote.customerProfile) {
    errorList.push({
      field: "customerProfile",
      message: "Profile should be selected."
    });
  }
  if (!quote.customerGrading) {
    errorList.push({
      field: "customerGrading",
      message: "Customer Grading should be selected."
    });
  } else if (quote.customerGrading == "Bronze") {
    warningList.push({
      field: "customerGrading",
      message: "Debt consolidation not available for Bronze Profile"
    });
  }
  if (!quote.applicationFee) {
    errorList.push({
      field: "applicationFee",
      message: "Application Fee cannot be Zero."
    });
  } else if (quote.applicationFee > quote.maxApplicationFee) {
    warningList.push({
      field: "applicationFee",
      message: "Max Application Fee exceed."
    });
  }
  if (!quote.dof) {
    errorList.push({
      field: "dof",
      message: "DOF cannot be Zero."
    });
  } else if (quote.dof > quote.maxDof) {
    warningList.push({
      field: "dof",
      message: "Max. DOF exceed."
    });
  }

  // if (!quote.loanPurpose && quote.customerProfile === "Unsecured") {
  //   warningList.push({
  //     field: "loanPurpose",
  //     message: "The Loan Purpose is necessary for any approval."
  //   });
  // }

  if (quote.riskFee == null) {
    errorList.push({
      field: "riskFee",
      message: "Risk Fee value required."
    });
  } else if (quote.riskFee > quote.riskFeeTotal) {
    warningList.push({
      field: "riskFee",
      message: "Calculated Risk Fee exceed."
    });
  }

  if (!quote.clientRate) {
    errorList.push({
      field: "clientRate",
      message: "Client Rate cannot be Zero."
    });
  } else if (quote.clientRate != baseRate) {
    if (baseRate == null || baseRate == undefined) {
      baseRate = 0;
    }
    let mes =
      "Money 3 standard rate for " +
      quote.customerProfile +
      "/" +
      quote.customerGrading +
      " is " +
      baseRate +
      "%";
    console.log(mes);
    warningList.push({
      field: "clientRate",
      message: mes
    });
  }

  let purchasePrice = 0;
  if (quote.price != null && netDeposit != null && netDeposit != undefined) {
    purchasePrice = quote.price - netDeposit;
  }

  if (quote.customerProfile === "Mini PL") {
    if (purchasePrice > 5000) {
      warningList.push({
        field: "price",
        message: "Loan amount for Mini PL cannot exceed $5,000."
      });
    }
  } else if (quote.customerProfile === "Unsecured") {
    if (purchasePrice > 10000) {
      warningList.push({
        field: "price",
        message: "Loan amount for Unsecured cannot exceed $10,000."
      });
    }
  } else if (quote.customerProfile === "Secured") {
    if (
      quote.customerGrading == "Platinum" ||
      quote.customerGrading === "Gold"
    ) {
      if (purchasePrice > 30000) {
        warningList.push({
          field: "price",
          message: `Maximum loan amount for ${quote.customerGrading} is $30,000.`
        });
      }
    }
    if (quote.customerGrading === "Silver") {
      if (purchasePrice > 20000) {
        warningList.push({
          field: "price",
          message: "Maximum loan amount for Silver is $20,000."
        });
      }
    }
    if (quote.customerGrading === "Bronze") {
      if (purchasePrice > 15000) {
        warningList.push({
          field: "price",
          message: "Maximum loan amount for Bronze is $15,000."
        });
      }
    }
  }

  // terms and principal loan amount validations
  if(quote.term === 24){
    if(purchasePrice < 2000 || purchasePrice > 5000){
      warningList.push({
        field: "price",
        message: "Max term 3 years for loans <= $10K"
      });
    }
  }
  
  if (
    quote.customerProfile === "Mini PL" || (
      purchasePrice <= 5000 &&
      quote.term > 24
    )
  ) {
    warningList.push({
      field: "price",
      message: "Max term 2 years for loans <= $5K"
    });
  } else if(quote.customerProfile === "Unsecured") {
    warningList.push({
      field: "price",
      message: "Max term 3 years for loans <= $10K"
    });
  } else if (quote.customerProfile === "Secured") {
    if (purchasePrice < 8000 && quote.term > 36) {
      warningList.push({
        field: "price",
        message: "Max term 3 years for loans < $8K"
      });
    } else if (purchasePrice < 20000 && quote.term > 48) {
      warningList.push({
        field: "price",
        message: "Max term 4 years for loans < $20K"
      });
    } else if (purchasePrice >= 20000 && purchasePrice < 30000) {
      warningList.push({
        field: "price",
        message: "Max term 5 years for loans < $30K"
      });
    }
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

  if (quote.commission === null || quote.commission < 0.0) {
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