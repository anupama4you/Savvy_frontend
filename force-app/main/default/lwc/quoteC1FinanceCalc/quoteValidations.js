import { QuoteCommons } from "c/quoteCommons";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} rate - finance one rates
 * @param {Object} lender - lender 
 * @param {Object} naf - total naf 
 * @param {Object} messages - old messages object
 * @returns
 */

const validate = (quote, rate, lender, naf, messages) => {

  const r =
    typeof messages == "undefined" || messages == null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

  if (quote.clientRate == null || quote.clientRate === 0.0) {
    errorList.push({
      field: "clientRate",
      message: "Client Rate cannot be Zero."
    });
  }

  if (quote.baseRate === null || quote.baseRate === 0.0 || quote.baseRate < 0) {
    errorList.push({
      field: "baseRate",
      message: "Base Rate cannot be Zero."
    });
  }

  if (quote.residual > 0 && quote.term > 60) {
    errorList.push({
      field: "residual",
      message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
    });
  }

  if (quote.riskFee > quote.calcRiskFee) {
    warningList.push({
      message: "Risk fee is greater than the Risk fee calculated."
    });                        
  } else if (quote.riskFee < quote.calcRiskFee) {
    warningList.push({
      message: "Risk fee is lower than the Risk fee calculated."
    });                        
  }

  // Client Rate
  if (quote.baseRate != quote.clientRate) {
    errorList.push({
      field: "clientRate",
      message: "Client rate should be equal to BaseRate."
    });
  }

  // DOF
  if (quote.dof > quote.maxDof) {
    errorList.push({
      field: "dof",
      message: "DOF can't exceed max DOF"
    });
  }

  const loanType = quote.loanTypeDetail;
  const assetAge = quote.assetAge;
  let AssetAgeCompared = 0;
  let loanAmountLow = 0;
  let loanAmountHigh = 0;
  let maxLoanAmount = 0;
  let isIgnored = true;

  if (loanType === "Premium Plus") {
    AssetAgeCompared = 5;
    loanAmountLow = 15000;
    loanAmountHigh = 35000;
    if (quote.goodType === "Car") {
    } else if (quote.goodType === "Motorbike") {
      maxLoanAmount = 15000;
    } else if (quote.goodType === "Caravan") {
      maxLoanAmount = 20000;
    }
  } else if (loanType === "Premium") {
    loanAmountLow = 10000;
    loanAmountHigh = 35000;
    if (quote.goodType === "Car") {
      AssetAgeCompared = 11;
    } else if (quote.goodType === "Motorbike") {
      AssetAgeCompared = 11;
      maxLoanAmount = 15000;
    } else if (quote.goodType === "Caravan") {
      AssetAgeCompared = 8;
      maxLoanAmount = 20000;
    }
  } else if (loanType === "Standard") {
    loanAmountLow = 10000;
    loanAmountHigh = 30000;
    if (quote.goodType === "Car") {
      AssetAgeCompared = 11;
    } else if (quote.goodType === "Motorbike") {
      AssetAgeCompared = 11;
      maxLoanAmount = 10000;
    } else if (quote.goodType === "Caravan") {
      AssetAgeCompared = 8;
      maxLoanAmount = 20000;
    }
  } else if (loanType === "Lite") {
    loanAmountLow = 8000;
    loanAmountHigh = 20000;
    if (quote.goodType === "Car") {
      AssetAgeCompared = 11;
    } else if (quote.goodType === "Motorbike") {
      isIgnored = false;
      warningList.push({
        field: "",
        message: "Bikes cannot be funded on Lite product"
      });
    } else if (quote.goodType === "Caravan") {
      isIgnored = false;
      warningList.push({
        field: "",
        message: "Caravans cannot be funded on Lite product"
      });
    }
  }

  // Asset age 
  if (assetAge > AssetAgeCompared) {
    if (isIgnored) {
      warningList.push({
        field: "goodType",
        message: `${quote.goodType} too old for this profile`
      });
    }
  }

  // Loan amount range
  if (quote.price < loanAmountLow || quote.price > loanAmountHigh) {
    warningList.push({
      field: "price",
      message: "Outside min/max loan"
    });
  }

  // Loan amount max
  if (quote.goodType === "Motorbike" || quote.goodType === "Caravan" ) {
   if (quote.price > maxLoanAmount) {
    warningList.push({
      field: "price",
      message: `Loan amount exceeds product parameters without dual security`
    });
   }
  }

  // Private sales
  if (loanType === "Premium Plus" || loanType === "Premium") {
    if (quote.privateSales == "Y"){
      warningList.push({
        field: "privateSales",
        message: `Private sales not available for this risk profile`
      });
    }
  }

  // max terms
  if (quote.goodType === "Motorbike" || quote.goodType === "Caravan") {
    if (quote.term > 36){
      warningList.push({
        field: "term",
        message: `Max term for ${quote.goodType} is 36 months`
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

  if (quote.commission <= 0) {
    warningList.push({
      message: "The commission is below zero. Please make adjustment to make sure commission is above zero."
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