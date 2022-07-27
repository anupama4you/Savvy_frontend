import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteLibertyLeisureCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, settings, messages, isApproval) => {
  const r =
    typeof messages == "undefined" || messages == null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

  const baseRate = quote["baseRate"];
  const maxDofRate = CalHelper.getDOF(quote);

  console.log(`@@validation:`, JSON.stringify(quote, null, 2));

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 24 ~ validate ~ quote.baseRate",
    quote.baseRate
  );
  if (quote.baseRate === null || quote.baseRate === 0 || quote.baseRate < 0) {
    errorList.push({
      field: "baseRate",
      message: "Base Rate cannot be Zero."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 35 ~ validate ~ quote.clientRate",
    quote.clientRate
  );
  if (quote.clientRate === null || quote.clientRate == 0.0) {
    errorList.push({
      field: "clientRate",
      message: "Client Rate should not be zero."
    });
  } else if (quote.baseRate && quote.clientRate) {
    if (quote.clientRate < quote.baseRate) {
      errorList.push({
        field: "clientRate",
        message: "Client rate can not be below of the base rate."
      });
    } else if (quote.clientRate > quote.maxRate) {
      errorList.push({
        field: "clientRate",
        message: `Client rate can not be greater of ${quote.maxRate}%.`
      });
    }
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
    errorList.push({
      field: "applicationFee",
      message: `DOF is less than maximum $${settings.DOF__c.toFixed(2)}`
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 24 ~ validate ~ quote.term",
    quote.term
  );
  if (quote.term === null || quote.term === 0) {
    errorList.push({
      field: "term",
      message: `Please choose an appropriate term.`
    });
  } else if (quote.term > 84 && ('AAA' === quote.riskGrade) || 'AA' === quote.riskGrade) {
    errorList.push({
      field: "riskGrade",
      message: `Maximum term is 84 months (7 years) for ${quote.riskGrade} tier - refer to Liberty`
    });
  } else if (quote.term > 60 && ('AAA' === quote.riskGrade) || 'AA' === quote.riskGrade) {
    errorList.push({
      field: "riskGrade",
      message: `Maximum term is 60 months (5 years) for ${quote.riskGrade} tier - refer to Liberty`
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 24 ~ validate ~ quote.term",
    quote.term
  );
  if ('AAA' === quote.riskGrade) {
    if (!quote.creditScore) {
      errorList.push({
        field: "riskGrade",
        message: "Credit Score value is required."
      });
    } else if (!Number.isInteger(quote.creditScore)) {
      errorList.push({
        field: "creditScore",
        message: "Credit Score should be an integer number."
      });
    }
    if (!quote.enquiries) {
      errorList.push({
        field: "enquiries",
        message: "# of enquiries is required."
      });
    } else if (!Number.isInteger(quote.enquiries)) {
      errorList.push({
        field: "enquiries",
        message: "# of enquiries should be an integer number."
      });
    }
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 24 ~ validate ~ quote.vehicleAge",
    quote.vehicleAge
  );
  if (!quote.vehicleAge) {
    errorList.push({
      field: "vehicleAge",
      message: "Vehicle Age selection is required."
    });
  }

  console.log(
    "🚀 ~ file: quoteValidations.js ~ line 24 ~ validate ~ quote.ltv",
    quote.ltv
  );
  if (!quote.ltv) {
    errorList.push({
      field: "ltv",
      message: "LTV value is required."
    });
  } else {
    const ltvLimit = 150;
    if (quote.realtimeNaf < 10000) {
      if ('AA' === quote.riskGrade) {
        ltvLimit = 120;
      }else if ('A+' === quote.riskGrade) {
        ltvLimit = 90;
      }
    }
    if (this.ltv > ltvLimit) {
      warningList.push({
        field: "ltvLimit",
        message: `Maximum value for LTV is ${ltvLimit}%.`
      });
    }
  }

    console.log(
      "🚀 ~ file: quoteValidations.js ~ line 24 ~ validate ~ quote.realtimeNaf",
      quote.realtimeNaf
    );
    if (quote.realtimeNaf < 5000) {
      errorList.push({
        field: "realtimeNaf",
        message: "The minimum Loan Amount is $5,000"
      });
    }

    let vehicleAgeYear = 0;
    let percentageResidual = 0.0;

    vehicleAgeYear = getVehicleAgeToYear();
    if (vehicleAgeYear != null) {
      vehicleAgeYear = Date.Today().year() - vehicleAgeYear;
    }

    console.log(
      "🚀 ~ file: quoteValidations.js ~ line 24 ~ validate ~ testttt",
      quote.riskGrade, quote.residualValue, quote.netDeposit
    );

    if (!('AAA' === quote.riskGrade) || ('AA' === quote.riskGrade) && (quote.residualValue != null && quote.residualValue > 0)) {
      warningList.push({
        field: "residualValue",
        message: "Residuals are not available for risk grades A,B,C. Refer to your bdm"
      });
      // r = false;
    } else if (quote.residualValue != null) {
      const vp = quote.price - quote.netDeposit;
      if (vp > 0) {
        percentageResidual = (quote.residualValue / (quote.price - quote.netDeposit)) * 100.0;
        percentageResidual = percentageResidual.toFixed(2);
      }
    }

    if (vehicleAgeYear != null) {
      const totalAge = (quote.term / 12) + vehicleAgeYear;
      if (totalAge > 8 && quote.residualValue != null && quote.residualValue > 0) {
        warningList.push({
          field: "residualValue",
          message: "Maximum vehicle age at end adding Term and Vehicle Age should be 8 years"
        });
      } else if (totalAge > (20 * 12)) {
        warningList.push({
          field: "residualValue",
          message: "Maximum vehicle age at end adding Term and Vehicle Age should be 20 years"
        });
      }
    }

    if (vehicleAgeYear != null && percentageResidual != null) {
      if ((quote.term == (3 * 12) || quote.term == (4 * 12) || quote.term == (5 * 12)) && 'AAA' === quote.riskGrade
        && vehicleAgeYear <= 5 && percentageResidual > 30) {
        warningList.push({
          field: "percentageResidual",
          message: `Maximum value for Residual Value and ${quote.riskGrade} tier is 30%`
        });
      } else if (quote.term == (3 * 12) && 'AA' === quote.riskGrade && vehicleAgeYear <= 2 && percentageResidual > 50) {
        warningList.push({
          field: "percentageResidual",
          message: `Maximum value for Residual Value and ${quote.riskGrade} tier is 50%`
        });
      } else if (quote.term == (3 * 12) && 'AA' === quote.riskGrade && vehicleAgeYear <= 5 && percentageResidual > 30) {
        warningList.push({
          field: "percentageResidual",
          message: `Maximum value for Residual Value and ${quote.riskGrade} tier is 30%`
        });
      } else if (quote.term == (4 * 12) && 'AA' === quote.riskGrade && vehicleAgeYear <= 2 && percentageResidual > 40) {
        warningList.push({
          field: "percentageResidual",
          message: `Maximum value for Residual Value and ${quote.riskGrade} tier is 40%`
        });
      } else if (quote.term == (4 * 12) && 'AA' === quote.riskGrade && vehicleAgeYear <= 5 && percentageResidual > 20) {
        warningList.push({
          field: "percentageResidual",
          message: `Maximum value for Residual Value and ${quote.riskGrade} tier is 20%`
        });
      } else if (quote.term == (5 * 12) && 'AA' === quote.riskGrade && vehicleAgeYear <= 2 && percentageResidual > 30) {
        warningList.push({
          field: "percentageResidual",
          message: `Maximum value for Residual Value and ${quote.riskGrade} tier is 30%`
        });
      } else if (quote.term == (5 * 12) && 'AA' === quote.riskGrade && vehicleAgeYear <= 5 && percentageResidual > 0) {
        warningList.push({
          field: "percentageResidual",
          message: `Maximum value for Residual Value and ${quote.riskGrade} tier is 0%`
        });
      }
    }

    console.log(
      "🚀 ~ file: quoteValidations.js ~ line 24 ~ validate ~ quote.propertyOwner",
      quote.propertyOwner
    );
    if ('N' === quote.propertyOwner && 'AAA' === quote.riskGrade) {
      errorList.push({
        field: "propertyOwner",
        message: `${quote.riskGrade} tier unavalible for Non-home owner`
      });
    }

    if (quote.price == null || quote.price == 0.0) {
      errorList.push({
        field: "price",
        message: `Vehicle price is required`
      });
    }
    else if ('Caravan' === quote.assetType && 'Y' !== quote.propertyOwner && quote.price > 0 && (quote.netDeposit / quote.price) < 0.25) {
      warningList.push({
        field: "percentageResidual",
        message: `Non property owners may require a 25% deposit. Check with your lender`
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

    r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
    r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
    return r;
  };

  const getVehicleAgeToYear = () => {
    // TODO: pending Asset Details validation
    return null;
  }

  const Validations = {
    validate: validate,
    validatePostCalculation: validatePostCalculation
  };

  export { Validations };