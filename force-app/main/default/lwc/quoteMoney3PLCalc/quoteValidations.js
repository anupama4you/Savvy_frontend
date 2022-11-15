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
  //     message: "The Loan Purpose is neccessary for any approval."
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

  let termA = 0;
  let termB = 0;
  let loanAmountA = 0.0;
  let loanAmountB = 0.0;
  if (quote.customerProfile === "Secured") {
    if (quote.customerGrading === "Bronze") {
      termA = 24;
      termB = 48;
      loanAmountA = 2000.0;
      loanAmountB = 10000.0;
    } else {
      termA = 24;
      termB = 60;
      loanAmountA = 8001.0;
      loanAmountB = 50000.0;
    }
  } else if (quote.customerProfile == "Unsecured") {
    if (quote.customerGrading == "Mini PL") {
      termA = 12;
      termB = 24;
      loanAmountA = 2000.0;
      loanAmountB = 5000.0;
    } else {
      termA = 24;
      termB = 36;
      loanAmountA = 5001.0;
      loanAmountB = 12000.0;
    }
  }
  let purchasePrice = 0;
  if (quote.price != null && netDeposit != null && netDeposit != undefined) {
    purchasePrice = quote.price - netDeposit;
  }

  if(quote.customerProfile == "Unsecured") {
    if(purchasePrice > 10000) {
      warningList.push({
        field: "price",
        message: "Loan amount for Unsecured cannot exceed $10,000."
      });
    }
  } else if(quote.customerProfile == "Secured") {
    if(quote.customerGrading == "Platinum") {
      if(purchasePrice > 30000) {
        warningList.push({
          field: "price",
          message: "Maximum loan amount for Platinum is $30,000."
        });
      }
    }
    if(quote.customerGrading == "Gold") {
      if(purchasePrice > 30000) {
        warningList.push({
          field: "price",
          message: "Maximum loan amount for Gold is $30,000."
        });
      }
    }
    if(quote.customerGrading == "Silver") {
      if(purchasePrice > 20000) {
        warningList.push({
          field: "price",
          message: "Maximum loan amount for Silver is $20,000."
        });
      }
    }
    if(quote.customerGrading == "Bronze") {
      if(purchasePrice > 15000) {
        warningList.push({
          field: "price",
          message: "Maximum loan amount for Bronze is $15,000."
        });
      }
    }
  }

  // terms and principal loan amoount validations
  if(quote.term == 24){
    if(purchasePrice < 2000 || purchasePrice > 5000){
      warningList.push({
        field: "price",
        message: "Max term 3 years for loans < = $10K"
      });
    }
  }
  if(quote.customerProfile === "Unsecured") {
    if(quote.term > 36) {
      if(purchasePrice < 5001 || purchasePrice > 10000){
        warningList.push({
          field: "price",
          message: "Max term 3 years for loans < = $10K"
        });
      }
    }
  } else if (quote.customerProfile === "Secured") {
    if(quote.term > 36) {
      if(purchasePrice < 5001 || purchasePrice > 7999){
        warningList.push({
          field: "price",
          message: "Max term 3 years for loans < $8K"
        });
      }
    } else if(quote.term > 48) {
      if(purchasePrice < 8000 || purchasePrice > 19999){
        warningList.push({
          field: "price",
          message: "Max term 4 years for loans < $20K"
        });
      }
    } else if(quote.term > 60) {
      if(purchasePrice < 20000 || purchasePrice > 30000){
        warningList.push({
          field: "price",
          message: "Max term 5 years for loans < $30K"
        });
      }
    }
  }

  // if (quote.term == null || quote.term == 0) {
  //   errorList.push({
  //     field: "term",
  //     message: "Please choose an appropriate term."
  //   });
  // } else if (termA > 0 && (quote.term < termA || quote.term > termB)) {
  //   errorList.push({
  //     field: "term",
  //     message:
  //       "Term should be " +
  //       termA +
  //       " to " +
  //       termB +
  //       " months for " +
  //       quote.customerProfile +
  //       " / " +
  //       quote.customerGrading
  //   });
  // } else if (
  //   quote.customerProfile == "Secured" &&
  //   quote.customerGrading != "Bronze" &&
  //   quote.price != null
  // ) {
  //   if (purchasePrice >= 8000 && purchasePrice < 12000) {
  //     warningList.push({
  //       field: "term",
  //       message: "3 year max term for this purchase price. $" + quote.price
  //     });
  //   } else if (purchasePrice >= 12000 && purchasePrice < 16000) {
  //     warningList.push({
  //       field: "term",
  //       message: "4 year max term for this purchase price. $" + quote.price
  //     });
  //   }
  // }
  // if (
  //   loanAmountA > 0 &&
  //   (QuoteCommons.calcTotalAmount(quote) < loanAmountA ||
  //     QuoteCommons.calcTotalAmount(quote) > loanAmountB)
  // ) {
  //   warningList.push({
  //     field: "price",
  //     message:
  //       "Car Price/Loan Amount should be $" +
  //       loanAmountA +
  //       " to $" +
  //       loanAmountB +
  //       " for " +
  //       quote.customerProfile +
  //       " / " +
  //       quote.customerGrading
  //   });
  // }

  // loanAmountA = 0.0;
  // loanAmountB = 0.0;
  // if (quote.term == 24) {
  //   loanAmountA = 2001.0;
  //   loanAmountB = 6000.0;
  // } else if (quote.term == 36) {
  //   loanAmountA = 6000.0;
  //   loanAmountB = 12000.0;
  // } else if (quote.term == 48) {
  //   loanAmountA = 12000.0;
  //   loanAmountB = 16000.0;
  // } else if (quote.term >= 60) {
  //   loanAmountA = 16000.0;
  //   loanAmountB = null;
  // }

  // if (
  //   loanAmountA > 0 &&
  //   (NAF <= loanAmountA || (loanAmountB != null && NAF >= loanAmountB))
  // ) {
  //   if (loanAmountB != null) {
  //     warningList.push({
  //       field: "",
  //       message:
  //         "NAF should be between $" +
  //         loanAmountA +
  //         " and $" +
  //         (loanAmountB - 1) +
  //         " for a " +
  //         quote.term +
  //         " months term"
  //     });
  //   } else {
  //     warningList.push({
  //       field: "",
  //       message:
  //         "NAF should be between $" +
  //         loanAmountA +
  //         " for a " +
  //         quote.term +
  //         " months term"
  //     });
  //   }
  // }

  // if (quote.residual > 0 && quote.term > 60) {
  //   errorList.push({
  //     field: "residual",
  //     message:
  //       "You cannot have a balloon or residual payment when the loan term is > 5 years."
  //   });
  // }
  // if (
  //   quote.customerProfile == "Unsecured" &&
  //   purchasePrice <= 8000 &&
  //   quote.term > 24
  // ) {
  //   errorList.push({
  //     field: "customerProfile",
  //     message: "Loan amount of $8,000 or less maximum term 24 month"
  //   });
  // }

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