import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteBOQCommercialCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
    const { clientRate, term, baseRate, assetAge, privateSales, propOwner, brokeragePercentage, residualValue, maxBrokerage } = quote;
    const ZERO = 0;
    const MAX_CLIENT_RATE = 14.75;
    const MAX_TERM = 60;
    const MIN_NAF = 10000;
    const YES = 'Y';
    const NO = 'N';
    const realtimeNaf = CalHelper.getNetRealtimeNaf(quote);

    console.log('quote for Validation is: ', JSON.stringify(quote, null, 2));
    const r =
        typeof messages == "undefined" || messages == null
            ? QuoteCommons.resetMessage()
            : messages;
    let errorList = r.errors;
    let warningList = r.warnings;

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 29 ~ validate ~ quote.clientRate",
        clientRate
    );
    if (clientRate > MAX_CLIENT_RATE) {
        errorList.push({
            field: "clientRate",
            message: `Client Rate cannot be larger than ${MAX_CLIENT_RATE}%`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 40 ~ validate ~ quote.term",
        term
    );
    if (term > MAX_TERM) {
        errorList.push({
            field: "clientRate",
            message: `Term cannot be longer than five years.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 51 ~ validate ~ realtimeNaf",
        realtimeNaf
    );
    if (realtimeNaf < MIN_NAF) {
        errorList.push({
            field: "realtimeNaf",
            message: `Financed Amount cannot be less than $${MIN_NAF}`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 62 ~ validate ~ quote.clientRate",
        clientRate
    );
    if (clientRate === null || clientRate === ZERO) {
        errorList.push({
            field: "clientRate",
            message: `Client Rate cannot be Zero.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 73 ~ validate ~ quote.baseRate",
        baseRate
    );
    if (baseRate === null || baseRate === ZERO) {
        errorList.push({
            field: "baseRate",
            message: `base Rate cannot be Zero.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 84 ~ validate ~ quote.assetAge",
        assetAge
    );
    if (assetAge === null) {
        errorList.push({
            field: "assetAge",
            message: `Please choose an Asset Year option.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 95 ~ validate ~ quote.privateSales",
        privateSales
    );
    if (privateSales === null) {
        errorList.push({
            field: "privateSales",
            message: `Please choose a Private Sale option.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 106 ~ validate ~ quote.privateSales",
        privateSales
    );
    if (privateSales === YES) {
        errorList.push({
            field: "privateSales",
            message: `Dealer transactions only`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 117 ~ validate ~ quote.propOwner",
        propOwner
    );
    if (propOwner === NO) {
        warningList.push({
            field: "propOwner",
            message: `20% deposit required for low doc non property owner`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 128 ~ validate ~ quote.brokeragePercentage",
        brokeragePercentage
    );
    if (brokeragePercentage > maxBrokerage) {
        errorList.push({
            field: "brokeragePercentage",
            message: `Brokerage cannot be greater than ${brokeragePercentage}%`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 139 ~ validate ~ quote.residualValue",
        residualValue
    );
    if (residualValue > ZERO && term > MAX_TERM) {
        errorList.push({
            field: "residualValue",
            message: `You cannot have a balloon or residual payment when the loan term is > 5 years.`
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