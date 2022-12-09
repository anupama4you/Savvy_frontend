import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quotePlentiCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
  const r =
    typeof messages === "undefined" || messages === null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

  console.log('quote for VALIDATION::: ', JSON.stringify(quote, null, 2));
  const baseRate = quote["baseRate"];
  // const maxRate = quote["maxRate"];
  const NAF = CalHelper.getNetRealtimeNaf(quote);

  console.log('NAF===>' + NAF);

  const { residual, assetType } = quote;

  /* Plenti TO DO: to be added
  if (this.Opp.Application__c!==null && this.Opp.Application__r.No_of_People__c!==null && 2===this.Opp.Application__r.No_of_People__c) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Joined applications are not allowed by Plenti'));
          // r = false;
      }

      isInsuranceValidationOK
  */

  // const testDate = Datetime.now().year() - quote.vehicleYear;
  // console.log('testDate: ', testDate);

  if (NAF === null || NAF < 5000) {
    errorList.push({
      field: "",
      message: "Minimum loan amount should be $10,000"
    });
  }

  if (NAF >= 100000) {
    warningList.push({
      field: "",
      message: "Max Lend should be equal or less than $100,000"
    });
  }

  if (quote.price === null || quote.price === 0) {
    errorList.push({
      field: "price",
      message: "Price cannot be Zero."
    });
  }

  if (quote.applicationFee === null || quote.applicationFee === 0) {
    errorList.push({
      field: "applicationFee",
      message: "Application Fee cannot be Zero."
    });
  } else if (quote.applicationFee < quote.maxApplicationFee) {
    warningList.push({
      field: "applicationFee",
      message: "Application Fee below suggested value. $" + quote.maxApplicationFee
    });

  } else if (quote.applicationFee > quote.maxApplicationFee) {
    warningList.push({
      field: "applicationFee",
      message: "Application Fee over suggested value. $" + quote.maxApplicationFee
    });

  }

  if (quote.dof === null || quote.dof === 0) {
    errorList.push({
      field: "dof",
      message: "DOF cannot be Zero."
    });
  } else if (quote.dof > 2500) {
    errorList.push({
      field: "dof",
      message: "Max DOF allowed is $2,500"
    });

  }
  if (baseRate === null || baseRate === 0) {
    errorList.push({
      field: "",
      message: "Base Rate could not be estimated, please check Profile, Client Tier and Vehicle Build Date values."
    });
  }

  if ((quote.vehicleYear === "") || quote.vehicleYear === null) {
    console.log();
    errorList.push({
      field: "vehicleYear",
      message: "Please select a Vehicle Build Date year."
    });
  }

  if (quote.clientRate === null || quote.clientRate === 0) {
    errorList.push({
      field: "clientRate",
      message: "Client Rate cannot be Zero."
    });
  } else if (quote.clientRate < baseRate) {
    warningList.push({
      field: "clientRate",
      message: 'Client rate should not be below of base rate: ' + baseRate + '%'
    });
  } else if (quote.clientRate > (baseRate + 2) && baseRate > 0.0) {
    errorList.push({
      field: "clientRate",
      message: 'Client rate should not be above of max rate: ' + (baseRate + 2) + '%'
    });
  }

  if ((quote.customerProfile === "") || quote.customerProfile === null) {
    errorList.push({
      field: "customerProfile",
      message: "Please select a Profile option."
    });
  }
  if ((quote.clientTier === "") || quote.clientTier === null) {
    errorList.push({
      field: "clientTier",
      message: "Please select a Client Tier option."
    });
  }
  // if ((quote.vehicleYear === "") || quote.vehicleYear === null) {
  //   errorList.push({
  //     field: "vehicleYear",
  //     message: "Please select a vehicle Year option."
  //   });
  // }
  if ((quote.vehicleCondition === "") || quote.vehicleCondition === null) {
    errorList.push({
      field: "vehicleCondition",
      message: "Please select a Vehicle Condition option."
    });
  } else {
    if (quote.vehicleYear !== null) {
      // if ((quote.vehicleYear !== "") || quote.vehicleYear !== null) {
      // let a = Datetime.now().year() - quote.vehicleYear;
      let a = new Date().getFullYear() - quote.vehicleYear;
      if ((quote.vehicleCondition === "new") && a > 1 && (quote.assetType === "Car")) {
        errorList.push({
          field: "vehicleYear",
          message: "Vehicle Build Date should be <= 12 months for New vehicles [Car]."
        });
      }
      if ((quote.vehicleCondition === "new") && a > 1 && (quote.assetType === "Caravan")) {
        errorList.push({
          field: "vehicleYear",
          message: "Vehicle Build Date should be <= 12 months for New vehicles [Caravan]."
        });
      }
      if ((quote.vehicleCondition === "demo") && a > 2) {
        errorList.push({
          field: "vehicleYear",
          message: "Vehicle Build Date should be <= 24 months for Demo vehicles."
        });
      }
      if (a + quote.term / 12 > 15 && (quote.assetType === "Car")) {
        errorList.push({
          field: "vehicleYear",
          message: "Cars cannot be older than 15 years old at term end"
        });
      }
    }
  }

  if (quote.residual > 0) {
    if ((quote.clientTier === "Tier 3")) {
      errorList.push({
        field: "residual",
        message: "Balloon or residual payment is not allowed with this lender."
      });
    } else if ((quote.vehicleYear !== null || quote.vehicleYear !== "")) {
      let today = new Date();
      let year = today.getFullYear();
      let yrs = year - quote.vehicleYear;
      if (yrs >= 6 && assetType !== "Motorbikes") {
        warningList.push({
          field: "vehicleYear",
          message: "Balloon or residual not allowed. Cars must be less than six years old at start of loan (5 years old or less)"
        });
      }
      yrs = (quote.term / 12).toFixed();
      let maxDep = 50;
      if (yrs >= 5) {
        maxDep = 35;
      }
      /* Plenti TO DO: to be added
      if (quote.residual > (quote.getFinanceAmount(QuotingCalculation.CALC_QUOTING) * (maxDep/100.0))) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Balloon or residual exceeded, ' + yrs + ' years term max ' + maxDep + '% of the car price (less deposit or trade in)'));
      }*/
    }
  }
  if ((quote.assetType === "Caravan") && !(quote.customerProfile === "Property Owner")) {
    errorList.push({
      field: "assetType",
      message: "Must be a property owner to qualify for Caravan assets"
    });
  }
  if ((quote.assetType === "Caravan") && !(quote.vehicleCondition === "new")) {
    errorList.push({
      field: "assetType",
      message: "Caravan assets is only available for new vehicles, please check Vehicle Condition."
    });
  }
  if ((quote.assetType === "Caravan") && !(quote.privateSales === "N")) {
    errorList.push({
      field: "assetType",
      message: "Caravan assets not available for Private Sales"
    });
  }

  if ((quote.assetType === "Car") && (quote.leaseAgreement === "" || quote.leaseAgreement === null)) {
    errorList.push({
      field: "leaseAgreement",
      message: "Please select a value for Lease Agreement"
    });
  }

  if ((quote.greenCar === "" || quote.greenCar === null)) {
    errorList.push({
      field: "greenCar",
      message: "Please select a Green car option"
    });
  }

  if (
    quote.opp &&
    quote.opp.Application__c &&
    quote.opp.Application__r.No_of_People__c === 2
  ) {
    warningList.push({
      field: "clientTier",
      message: `Joined applications are not allowed by Plenti`
    });
  }

  if (assetType === "Motorbikes" && residual !== 0) {
    warningList.push({
      field: "assetType",
      message: `Ballons not available with Motorbikes`
    });
  }

  if (assetType === "Motorbikes" && NAF > 50000) {
    warningList.push({
      field: "assetType",
      message: `Max NAF $50K for motorbikes`
    });
  }

  // if (assetType === "Motorbikes") {
  //   warningList.push({
  //     field: "assetType",
  //     message: `Only credit files > 12 months and active credit in last 12 months considered`
  //   });
  // }

  r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
  r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
  return r;
};

const validatePostCalculation = (quote, messages) => {
  const r =
    typeof messages === "undefined" || messages === null
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

const validatePostLoading = (quote, messages) => {
  const r =
    typeof messages === "undefined" || messages === null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

  if (
    quote.opp &&
    quote.opp.Application__c &&
    quote.opp.Application__r.No_of_People__c === 2
  ) {
    warningList.push({
      field: "clientTier",
      message: `Joined applications are not allowed by Plenti`
    });
  }

  r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
  r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
  return r;
};

const Validations = {
  validate: validate,
  validatePostCalculation: validatePostCalculation,
  validatePostLoading: validatePostLoading
};

export { Validations };