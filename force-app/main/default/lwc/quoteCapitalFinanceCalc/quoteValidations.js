import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteCapitalFinanceCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
    const S_TICKET = "Small Ticket";
    const MAX_VALUE_SMALL_TICKET = 55000;
    const NO = "N";
    const MAX_BROKERAGE = 8;

    console.log('quote for Validation is: ', JSON.stringify(quote, null, 2));
    const r =
        typeof messages == "undefined" || messages == null
            ? QuoteCommons.resetMessage()
            : messages;
    let errorList = r.errors;
    let warningList = r.warnings;
    const realTimeNaf = CalHelper.getNetRealtimeNaf(quote);

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 26 ~ validate ~ quote.loanType",
        quote.loanType
    );
    if (quote.loanType === S_TICKET && realTimeNaf > MAX_VALUE_SMALL_TICKET) {
        errorList.push({
            field: "loanType",
            message: `Small ticket only for <$${MAX_VALUE_SMALL_TICKET} NAF`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 37 ~ validate ~ quote.propertyOwner",
        quote.propertyOwner
    );
    if (quote.propertyOwner === NO) {
        errorList.push({
            field: "propertyOwner",
            message: `Non property owner by exception - check with lender`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 48 ~ validate ~ quote.baseRate",
        quote.baseRate
    );
    if (quote.baseRate === null || quote.baseRate === 0.0) {
        errorList.push({
            field: "baseRate",
            message: `Base Rate cannot be Zero.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 59 ~ validate ~ quote.baseRate",
        quote.term
    );
    if (quote.term === null || quote.term === 0) {
        errorList.push({
            field: "term",
            message: `Please choose an appropriate term.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 70 ~ validate ~ quote.baseRate",
        quote.brokeragePercentage
    );
    if (quote.brokeragePercentage > MAX_BROKERAGE) {
        errorList.push({
            field: "brokeragePercentage",
            message: `Max ${MAX_BROKERAGE}% brokerage`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 81 ~ validate ~ quote.baseRate",
        quote.abnLength
    );
    if (quote.abnLength === '< 2 years') {
        errorList.push({
            field: "abnLength",
            message: `ABN length min 2 years required`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 92 ~ validate ~ quote.baseRate",
        quote.gstLength
    );
    if (quote.gstLength !== "> 1 day") {
        errorList.push({
            field: "gstLength",
            message: `Must be GST registered`
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

    r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
    r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
    return r;
};

const Validations = {
    validate: validate,
    validatePostCalculation: validatePostCalculation
};

export { Validations };