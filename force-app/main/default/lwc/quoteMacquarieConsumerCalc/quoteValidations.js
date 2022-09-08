import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteMacquarieConsumerCalcHelper";

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

    if (quote.assetYear == "" || quote.assetYear == null) {
        errorList.push({
            field: "assetYear",
            message: "Please select an Asset Year."
        });
    }
    if (baseRate == null || baseRate == 0) {
        errorList.push({
            field: "baseRate",
            message: "Base Rate cannot be Zero."
        });
    }
    if(quote.dof > quote.maxDof){
        warningList.push({
            field: "dof",
            message: "Max DOF is 8% of NAF."
        });
    }
    if (quote.term == null || quote.term == 0) {
        errorList.push({
            field: "term",
            message: "Please choose an appropriate term."
        });
    }
    if (quote.brokeragePer > 8) {
        errorList.push({
            field: "brokeragePer",
            message: "Maximum Brokerage is 8.00%"
        });
    }
    if(quote.goodsType == "MOTOV" && quote.goodsSubType == "MOTOV_CARS_-_OTHER_CARS_AU"){
        /*
        if (this.opp.Application_AssetDetail__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please save a Asset Detail - LTV before quoting.'));
            //r = false;
        }*/
    }
    if (quote.ltv != null && quote.ltv > 130) {
        errorList.push({
            field: "ltv",
            message: "LTV should be max. 130%"
        });
    }
    /*
    if (!isInsuranceValidationOK()) {
            r = false;   
        }
    */
    if(quote.loanType == "Consumer Loan" && quote.residualValue != null && quote.residualValue > 0){
        let assetAge = 0;
        if (quote.assetYear != null && quote.assetYear != "") {
            assetAge = Datetime.now().year() - quote.assetYear;
        }
        let a = (quote.term / 12) + assetAge;
        if (a > 8) {
            warningList.push({
                field: "assetYear",
                message: "Balloons at the discretion of Macquarie."
              });
        }
    }
    if(quote.goodsType == 'LIFES' && quote.privateSales == "Y" && quote.goodsSubType == "LIFES_MOTORCYCLES_&_SCOOTERS_AU"){
        errorList.push({
            field: "",
            message: "No private sales on Motorcycles & Scooters."
        });
    }
    if(quote.residualValue > 0 && quote.term > 60){
        warningList.push({
            field: "assetYear",
            message: "Balloons at the discretion of Macquarie."
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

const Validations = {
    validate: validate,
    validatePostCalculation: validatePostCalculation
};

export { Validations };