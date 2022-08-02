import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteAmmfCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages, isApproval) => {
  const r =
    typeof messages == "undefined" || messages == null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

  console.log(`@@validation:`, JSON.stringify(quote, null, 2));

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.assetType",
    quote.assetType
  );
  if (!quote.assetType) {
    errorList.push({
      field: "assetType",
      message: "An Asset Type should be selected."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 32 ~ validate ~ quote.price",
    quote.price
  );
  if (!quote.price) {
    errorList.push({
      field: "price",
      message: "Car Price cannot be Zero."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 46 ~ validate ~ quote.applicationFee",
    quote.applicationFee
  );
  if (!quote.applicationFee) {
    errorList.push({
      field: "applicationFee",
      message: "Application Fee cannot be Zero."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 57 ~ validate ~ quote.dof",
    quote.dof
  );
  if (!quote.dof) {
    errorList.push({
      field: "dof",
      message: "DOF cannot be Zero."
    });
  } else if (quote.dof > quote.maxDof) {
    errorList.push({
      field: "DOF",
      message: `Max DOF exceeded: ${quote.maxDof === null ? 0 : quote.maxDof}`
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 70 ~ validate ~ quote.ppsr",
    quote.ppsr
  );
  if (!quote.ppsr) {
    errorList.push({
      field: "ppsr",
      message: "PPSR cannot be Zero."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 70 ~ validate ~ quote.baseRate",
    quote.baseRate
  );
  if (!quote.baseRate) {
    errorList.push({
      field: "baseRate",
      message: "Base Rate cannot be Zero."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 84 ~ validate ~ quote.baseRate",
    quote.clientRate
  );
  if (!quote.clientRate) {
    errorList.push({
      field: "clientRate",
      message: "Client Rate cannot be Zero."
    });
  } else if (quote.maxRate > 0 && (quote.clientRate > quote.maxRate)) {
    errorList.push({
      field: "clientRate",
      message: `Client Rate exceeds the max base rate (${quote.maxRate}%)`
    });
  }
  if (quote.baseRate > 0 && quote.clientRate > 0 && quote.clientRate < quote.baseRate) {
    errorList.push({
      field: "clientRate",
      message: `Client Rate cannot be below the base rate (${quote.baseRate}%)`
    });
  }

    console.log(
      "🚀 ~ file: quoteValidations.js ~ line 111 ~ validate ~ quote.term",
      quote.term
    );
    if (quote.term < 24 && quote.term > 84) {
      errorList.push({
        field: "term",
        message: "Term should be between 24 and 60 months (up to 84 for boat packages when NAF > 35K)"
      });
    } else if (quote.assetType && quote.term > 60) {
      if ('Boat' === quote.assetType) {
        errorList.push({
          field: "term",
          message: `The maximun term is 60 months for Asset Type ${quote.assetType}`
        });
      } else if (quote.realTimeNaf < 35000) {
        errorList.push({
          field: "term",
          message: `The maximun term is 60 months (up to 84 for boat packages when NAF > 35K)`
        });
      }
    }

    console.log(
      "🚀 ~ file: quoteValidations.js ~ line 136 ~ validate ~ quote.privateSales",
      quote.privateSales
    );
    if (quote.privateSales === 'Y' && quote.assetAge != 'Used') {
      warningList.push({
        field: "baseRate",
        message: "Asset Age should be \"Used\" for Private Sales"
      });
    }
    if (quote.assetType === 'Motorcycle' && quote.privateSales === 'Y') {
      errorList.push({
        field: "privateSales",
        message: "Private sales not available on motorcycles"
      });
    }
    if (quote.assetAge === 'Used' && quote.loanTypeDetail === 'Standard') {
      if (quote.price > 0) {
        const p = quote.netDeposit / quote.price * 100;
        if (p < 10) {
          warningList.push({
            field: "privateSales",
            message: `10% minimum deposit should be required. Current percentage: ${p.toFixed(2)}%`
          });
        }
      }
    }


    // Balloon validations
    if (quote.assetType && quote.residualValue > 0 && quote.carPrice > 0) {
      const b = quote.residualValue / (quote.price - quote.netDeposit) * 100;
      let maxB = 0.0;
      if ('New' === quote.assetAge) {
        if ('Boat' === quote.assetType) {
          if (quote.term == 24) {
            maxB = 50.0;
          } else if (quote.term == 36) {
            maxB = 45.0;
          } else if (quote.term == 48) {
            maxB = 40.0;
          } else if (quote.term == 60) {
            maxB = 35.0;
          }
        } else {
          if (quote.term == 24) {
            maxB = 45.0;
          } else if (quote.term == 36) {
            maxB = 40.0;
          } else if (quote.term == 48) {
            maxB = 35.0;
          } else if (quote.term == 60) {
            maxB = 25.0;
          }
        }
      } else if ('Boat' === quote.assetType) {
        if (quote.term == 24) {
          maxB = 40.0;
        } else if (quote.term == 36) {
          maxB = 35.0;
        } else if (quote.term == 48) {
          maxB = 30.0;
        } else if (quote.term == 60) {
          maxB = 25.0;
        }
      }
      if (b > maxB) {
        warningList.push({
          field: "privateSales",
          message: `Ballon should not be allowed for term ${quote.term} and ${quote.assetType}'s`
        });
      }}

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

  r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
  r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
  return r;
};

const Validations = {
  validate: validate,
  validatePostCalculation: validatePostCalculation
};

export { Validations };