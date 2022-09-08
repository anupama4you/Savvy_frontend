import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quotePlentiCommercialCalcHelper";

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
    const NAF = CalHelper.getNetRealtimeNaf(quote);

    console.log('NAF===>'+NAF);

    /* Plenti TO DO: to be added
    if (this.Opp.Application__c != null && this.Opp.Application__r.No_of_People__c != null && 2 == this.Opp.Application__r.No_of_People__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Joined applications are not allowed by Plenti'));
            // r = false;
        }

        isInsuranceValidationOK
    */

    if(NAF === null || NAF < 5000){
      errorList.push({
        field: "",
        message: "Minimum loan amount should be $10,000"
      });
    }

    if(NAF > 125000){
      warningList.push({
        field: "",
        message: "Warning Max loan amount is $125K"
      });
    }

    if(quote.price === null || quote.price == 0){
      errorList.push({
        field: "price",
        message: "Car Price cannot be Zero."
      });
    }

    if(quote.applicationFee === null || quote.applicationFee == 0){
      errorList.push({
        field: "applicationFee",
        message: "Application Fee cannot be Zero."
      });
    }else if (quote.applicationFee < quote.maxApplicationFee) { 
      warningList.push({
        field: "applicationFee",
        message: "Application Fee below suggested value. $" +quote.maxApplicationFee
      });
      
    }else if (quote.applicationFee > quote.maxApplicationFee) { 
      warningList.push({
        field: "applicationFee",
        message: "Application Fee over suggested value. $" +quote.maxApplicationFee
      });
      
    }

    if(quote.dof == null || quote.dof == 0){
        errorList.push({
            field: "dof",
            message: "DOF cannot be Zero."
        });
    }else if (quote.dof > 2500){
        errorList.push({
            field: "dof",
            message: "Max DOF allowed is $2,500"
        });

    }
    if(baseRate == null || baseRate == 0){
        errorList.push({
            field: "",
            message: "Base Rate could not be estimated, please check Profile, Client Tier and Vehicle Build Date values."
        });
    }

    if (quote.clientRate == null || quote.clientRate == 0) {
        errorList.push({
            field: "clientRate",
            message: "Client Rate cannot be Zero."
        });
    } else if (quote.clientRate < quote.baseRateManual && quote.baseRateManual > 0) {
        warningList.push({
            field: "clientRate",
            message: 'Client rate should not be below of manual rate: ' + quote.baseRateManual + '%'
        });
    } else if (quote.clientRate < baseRate ) {
        warningList.push({
            field: "clientRate",
            message: 'Client rate should not be below of base rate: ' + baseRate + '%'
        });
    } 

    if ((quote.customerProfile == "") || quote.customerProfile == null) {
        errorList.push({
            field: "customerProfile",
            message: "Please select a Profile option."
        });
    }
    if ((quote.clientTier == "") || quote.clientTier == null) {
        errorList.push({
            field: "clientTier",
            message: "Please select a Client Tier option."
        });
    }
    if(quote.abnLength == "> 2 years" && quote.clientTier != "Tier 1"){
        warningList.push({
            field: "abnLength",
            message: "Warning: ABN length should be Tier 1"
        });
    }
    if(quote.abnLength == "> 2 yrs / >1 year" ){
        if( NAF > 100000){
            warningList.push({
                field: "",
                message: "Warning: Max NAF $100K"
            });
        }
        if(quote.clientTier != "Tier 2"){
            warningList.push({
                field: "abnLength",
                message: "Warning: ABN length should be Tier 2"
            });
        }
        
    }
    if(quote.abnLength == "> 1 yr / Unreg > 1 yr" ){
        if(quote.clientTier != "Tier 3"){
            warningList.push({
                field: "abnLength",
                message: "Warning: ABN length should be Tier 3"
            });
        }
    }
    if ((quote.vehicleCondition == "") || quote.vehicleCondition == null) {
        errorList.push({
            field: "vehicleCondition",
            message: "Please select a Vehicle Condition option."
        });
    } else {
      if ((quote.vehicleYear  == "") || quote.vehicleYear == null) {
        let a = Datetime.now().year() - quote.vehicleYear;

        if ((quote.vehicleCondition == "new") && a > 1 && (quote.assetType == "Car")) {
            errorList.push({
                field: "vehicleCondition",
                message: "Vehicle Build Date should be <= 12 months for New vehicles [Car]."
            });
        } else if ((quote.vehicleCondition  == "new") && a > 2 && (quote.assetType  == "Caravan")) {
            errorList.push({
                field: "vehicleCondition",
                message: "Vehicle Build Date should be <= 12 months for New vehicles [Caravan]."
            });
        } else if ((quote.vehicleCondition == "demo") && a > 2) {
            errorList.push({
                field: "vehicleCondition",
                message: "Vehicle Build Date should be <= 24 months for Demo vehicles."
            });
        } else if (a + term/12 > 15 && (quote.assetType == "Car")) {
            errorList.push({
                field: "vehicleCondition",
                message: "Cars cannot be older than 15 years old at term end"
            });
        }
      }
    }
    if ((quote.vehicleYear == "") || quote.vehicleYear == null) {
        errorList.push({
            field: "vehicleYear",
            message: "Please select a Vehicle Build Date year."
        });
    }

    if (quote.residual > 0) {
        if ((quote.clientTier == "Tier 3")) {
            errorList.push({
                field: "residual",
                message: "Balloon or residual payment is not allowed with this lender."
            });
        } else if ((quote.vehicleYear != null || quote.vehicleYear != "")) {
          let today = new Date();
          let year = today.getFullYear();
          let yrs = year - quote.vehicleYear;
          if (yrs >= 6) {
            warningList.push({
                field: "vehicleYear",
                message: "Balloon or residual not allowed. Cars must be less than six years old at start of loan (5 years old or less)"
              });
            }
          yrs = (quote.term/12).toFixed();
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
    if ((quote.assetType == "Caravan") && !(quote.customerProfile == "Property Owner")) {
        errorList.push({
            field: "assetType",
            message: "Must be a property owner to qualify for Caravan assets"
        });
    }
    if ((quote.assetType == "Caravan") && !(quote.vehicleCondition == "new")) {
        errorList.push({
            field: "assetType",
            message: "Caravan assets is only available for new vehicles, please check Vehicle Condition."
        });
    }
    if ((quote.assetType == "Caravan") && !(quote.privateSales == "N")) {
        errorList.push({
            field: "assetType",
            message: "Caravan assets not available for Private Sales"
        });
    }

    if ((quote.greenCar == "" || quote.greenCar == null)) {
        errorList.push({
            field: "leaseAgreement",
            message: "Please select a Green car option"
        });
    }
    if(quote.customerProfile == "Property Owner"){
        warningList.push({
            field: "customerProfile",
            message: "Warning: LVR Dealer 150%, Private 130%, Tier 3 130%"
        });
    }
    if(quote.clientTier == "Tier 3" && quote.term == 84){
        warningList.push({
            field: "term",
            message: "Warning: 7 years not available for Tier 3"
        });
    }
    if(quote.baseRateManual > 0 && quote.baseRateManual < quote.baseRate){
        warningList.push({
            field: "baseRateManual",
            message: "Manual rate is below of base rate: " + quote.baseRate + "%"
        });
    }
    if(quote.customerProfile == "Non Property Owner"){
        if(quote.abnLength == "> 2 yrs / >1 year" && NAF > 40000){
            warningList.push({
                field: "",
                message: "Warning: Max NAF $40K"
            });
        }else if(quote.abnLength == "> 1 yr / Unreg > 1 yr" && NAF > 30000){
            warningList.push({
                field: "",
                message: "Warning: Max NAF $30K"
            });
        }
        if(quote.privateSales == 'Y'){
            warningList.push({
                field: "privateSales",
                message: "90% LVR private"
            });
        }else if(QuoteCommons.calcNetDeposit(quote) < quote.price * 0.20){
            warningList.push({
                field: "",
                message: "Non property require 20% for dealer"
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