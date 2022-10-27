import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteWestpacCalcHelper";

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
    const MAX_BROKERAGE = 3.00;

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 24 ~ validate ~ quote.loanProduct",
        quote.loanProduct
    );
    if ('Novated Lease' === quote.loanProduct) {
        warningList.push({
            field: "loanProduct",
            message: "Residuals must adhere to ATO guidelines. Check you have the correct residual."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 35 ~ validate ~ NAF",
        NAF
    );
    if (NAF < 10000) {
        errorList.push({
            field: "price",
            message: "Financed Amount cannot be less than $10,000."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 46 ~ validate ~ quote.clientRate",
        quote.clientRate
    );
    if (quote.clientRate == null || quote.clientRate <= 0.0) {
        errorList.push({
            field: "clientRate",
            message: "Client Rate cannot be Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 57 ~ validate ~ quote.baseRate",
        quote.baseRate
    );
    if (quote.baseRate <= 0.0) {
        errorList.push({
            field: "baseRate",
            message: "Base Rate should be greater than zero"
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 68 ~ validate ~ quote.brokeragePercentage",
        quote.brokeragePercentage
    );
    if (quote.brokeragePercentage > MAX_BROKERAGE) {
        warningList.push({
            field: "brokeragePercentage",
            message: "Standard brokerage is 3%. For max 4% refer to lender"
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 79 ~ validate ~ quote.residualValue",
        quote.residualValue
    );
    if (quote.residualValue < 0) {
        errorList.push({
            field: "residualValue",
            message: "Residual value should be greater than or equal to zero"
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