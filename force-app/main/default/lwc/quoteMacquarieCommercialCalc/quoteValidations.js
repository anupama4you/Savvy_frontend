import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteMacquarieCommercialCalcHelper";

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

    if (quote.clientRate > 14.75) {
        errorList.push({
            field: "clientRate",
            message: "Client Rate cannot be larger than 14.75%."
        });
    }

    if (quote.term > 60) {
        errorList.push({
            field: "term",
            message: "Term cannot be longer than five years."
        });
    }
    if (NAF < 10000) {
        errorList.push({
            field: "",
            message: "Financed Amount cannot be less than $10,000."
        });
    }
    if (quote.clientRate == null || quote.clientRate == 0) {
        errorList.push({
            field: "clientRate",
            message: "Client Rate cannot be Zero."
        });
    }
    if (baseRate == null || baseRate == 0) {
        errorList.push({
            field: "baseRate",
            message: "Base Rate cannot be Zero."
        });
    }
    if (quote.term == null || quote.term == 0) {
        errorList.push({
            field: "term",
            message: "Please choose an appropriate term."
        });
    }
    if (quote.assetYear == "" || quote.assetYear == null) {
        errorList.push({
            field: "assetYear",
            message: "Please choose an Asset Year option."
        });
    }
    if (quote.privateSales == "" || quote.privateSales == null) {
        errorList.push({
            field: "privateSales",
            message: "Please choose a Private Sale option."
        });
    }
    if (quote.brokeragePer > 4) {
        errorList.push({
            field: "brokeragePer",
            message: "Brokerage cannot be greater than 4%"
        });
    }
    if (quote.residualValue > 0 && quote.term > 60) {
        warningList/errorList.push({
            field: "term",
            message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
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