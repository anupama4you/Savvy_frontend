import { QuoteCommons } from "c/quoteCommons";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} glRate - green lights rate 
 * @param {Object} messages - old messages object
 * @returns
 */

 const validate = (quote, messages, glRate) => {
    
    const r =
    typeof messages == "undefined" || messages == null
        ? QuoteCommons.resetMessage()
        : messages;
    let errorList = r.errors;
    let warningList = r.warnings;

    const baseRate = quote["baseRate"];
    const maxRate = quote["maxRate"];

    //get term years
    const termYears = (quote.term == null ? 0.00 : quote.term/12);

    //get vehicle age
    const currentYear = (new Date()).getFullYear();
    let age = currentYear - quote.vehicleYear;
    if(quote.term != null){
        age += (quote.term/12);
    }

    //get naf validation
    let nafValidation = 0;
    if (quote.price != null){
        nafValidation += quote.price;
    } 
    nafValidation -= quote.netDeposit;
    
    if (quote.price === null || quote.price === 0.0) {
        errorList.push({
            field: "price",
            message: "Vehicle Price cannot be Zero."
        });
    }

    if (quote.applicationFee === null || quote.applicationFee === 0.0) {
        errorList.push({
            field: "applicationFee",
            message: "Application Fee cannot be Zero."
        });
    }else if (quote.applicationFee > quote.maxApplicationFee) {
        warningList.push({
            field: "applicationFee",
            message: "Max Application Fee exceed."
        });
    }

    if (quote.dof === null || quote.dof === 0.0) {
        errorList.push({
            field: "dof",
            message: "DOF cannot be Zero."
        });
    }else if (quote.dof > quote.maxDof) {
        warningList.push({
            field: "applicationFee",
            message: "Max. DOF exceed."
        });
    }

    if (quote.brokerage === null || quote.brokerage === 0.0) {
        warningList.push({
            field: "brokerage",
            message: "Brokerage (%) is zero."
        });
    }

    if (quote.clientRate === null || quote.clientRate === 0.0) {
        errorList.push({
            field: "clientRate",
            message: "Client rate cannot be Zero."
        });
    }else if (quote.clientRate < baseRate) {
        warningList.push({
            field: "clientRate",
            message: "Client rate should not be below Base Rate."
        });
    }  else if (quote.clientRate > maxRate) {
        warningList.push({
            field: "clientRate",
            message: "Client rate should not be over Max Rate."
        });
    }

    if (quote.term === null || quote.term === 0.0) {
        errorList.push({
            field: "term",
            message: "Please choose an appropriate term."
        });
    }else if (quote.term > 60) {
        errorList.push({
            field: "term",
            message: "Please choose an appropriate term (60 max)."
        });
    }

    if (quote.term > 48 && quote.assetType === "Motorcycle") {
        errorList.push({
            field: "term",
            message: "Max term is 4 years for Motorcycle loans."
        });
    }

    if (quote.assetType === "Car" && quote.lvr === null) { 
        errorList.push({
            field: "lvr",
            message: "Please select a LVR option."
        });
    }

    if (quote.residual > 0 && quote.term > 60) {
        errorList.push({
            field: "residual",
            message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
        });
    }

    if (quote.assetType === "Car" && age > 20) {
        warningList.push({
            field: "vehicleYear",
            message: `Car age maximum 20 years end of term - at Greenlight\`s discretion, current age: ${age} years`
        });   

    }else if (quote.assetType === 'Motorcycle' && age > 12) {
        warningList.push({
            field: "vehicleYear",
            message: `Motorcycle age maximum 12 years end of term, current age: ${age} years`
        });  
    }

    if(glRate.length !== 0 && glRate !== null){
        
        let rateMaxDOF = glRate[0].DOF_Max__c;
        let rateMinDeposit = glRate[0].Minimum_Deposit__c;
        let rateMinLoanVal = glRate[0].Min_Loan_Value__c;
        let rateMaxLoanVal = glRate[0].Max_Loan_Value__c;
        let rateMaxLoanTerm = glRate[0].Max_Loan_Term__c;
        let rateBaseRate = glRate[0].Base_Rate__c;

        if(rateMaxDOF != null && quote.dof > rateMaxDOF) {
            warningList.push({
                field: "dof",
                message: `DOF should not be greater than $ ${rateMaxDOF} for ${quote.clientTier} tier`
            });  
        }

        if(rateMinDeposit !== null && rateMinDeposit > 0 && quote.netDeposit < rateMinDeposit) {
            warningList.push({
                field: "netDeposit",
                message: `The minimum deposit is $ ${rateMinDeposit} for ${quote.clientTier} tier`
            });  
        }

        if(rateMinLoanVal !== null && nafValidation < rateMinLoanVal) {
            warningList.push({
                message: `The minimum NAF (excluding fees & charges) is $ ${rateMinLoanVal} for ${quote.clientTier} tier`
            });  
        }
        
        if(rateMaxLoanVal !== null && nafValidation > rateMaxLoanVal) {
            warningList.push({
                message: `The maximum NAF (excluding fees & charges) is $ ${rateMaxLoanVal} for ${quote.clientTier} tier`
            });  
        }

        if(rateMaxLoanTerm !== null && termYears > rateMaxLoanTerm) {
            warningList.push({
                message: `The maximum Loan Term is ${rateMaxLoanTerm} years for ${quote.clientTier} tier`
            });  
        }
        
        if(rateBaseRate !== null && baseRate == null || baseRate < rateBaseRate) {
            errorList.push({
                field: "baseRate",
                message: `Base Rate is lower than the recommended rate: ${rateBaseRate} for ${quote.clientTier} tier`
            });  
        }
    }

    r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
    r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
    return r;

 }

 const validatePostCalculation = (quote, messages) => {
   const r =
      typeof messages == "undefined" || messages == null
        ? QuoteCommons.resetMessage()
        : messages;
    let errorList = r.errors;
    let warningList = r.warnings;
  
    r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
    r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
    return r;
  };

 const Validations = {
    validate: validate,
    validatePostCalculation: validatePostCalculation
  };
  
  export { Validations };