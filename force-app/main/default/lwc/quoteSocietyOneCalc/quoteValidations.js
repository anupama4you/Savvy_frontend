import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteSocietyOneCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
    const SECURED = 'Secured';
    const UNSECURED = 'Unsecured';
    console.log('quote for Validation is: ', JSON.stringify(quote, null, 2));
    const r =
        typeof messages == "undefined" || messages == null
            ? QuoteCommons.resetMessage()
            : messages;
    let errorList = r.errors;
    let warningList = r.warnings;
    const naf = CalHelper.getNetRealtimeNaf(quote);

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 22 ~ validate ~ quote.price",
        quote.price
    );
    if (quote.price === null || !(quote.price > 0.0)) {
        errorList.push({
            field: "price",
            message: "Loan amount cannot be Zero."
        });
    }
    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 33 ~ validate ~ naf",
        naf
    );
    if (quote.security === SECURED && naf > 70000) {
        warningList.push({
            field: "naf",
            message: "Warning: Max NAF of $70K"
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 44 ~ validate ~ naf",
        naf
    );
    if (quote.security === UNSECURED && naf > 50000) {
        warningList.push({
            field: "naf",
            message: "Warning: Max NAF of $50K"
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 55 ~ validate ~ quote.applicationFee",
        quote.applicationFee
    );
    if (quote.applicationFee === null || quote.applicationFee === 0.0) {
        errorList.push({
            field: "applicationFee",
            message: "Application Fee cannot be Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 66 ~ validate ~ quote.applicationFee",
        quote.applicationFee
    );
    if (quote.applicationFee > quote.maxApplicationFee) {
        errorList.push({
            field: "applicationFee ",
            message: "Max Application Fee exceed."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 35 ~ validate ~ quote.dof",
        quote.dof
    );
    if (quote.dof === null || quote.dof === 0.0) {
        errorList.push({
            field: "dof ",
            message: "DOF cannot be Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 88 ~ validate ~ quote.dof",
        quote.dof
    );
    if (quote.dof > quote.maxDof) {
        errorList.push({
            field: "applicationFee ",
            message: "Max DOF exceed."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 99 ~ validate ~ quote.clientRate",
        quote.clientRate
    );
    if (quote.clientRate === null || quote.clientRate === 0.0) {
        errorList.push({
            field: "clientRate ",
            message: "Client Rate cannot be Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 110 ~ validate ~ quote.residual",
        quote.residual
    );
    if (quote.residual > 0 && quote.term > 60) {
        errorList.push({
            field: "residual ",
            message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 121 ~ validate ~ quote.security",
        quote.security
    );
    if (quote.security === UNSECURED && quote.term > 60) {
        warningList.push({
            field: "term ",
            message: "Warning: Max loan term 5 years for unsecured"
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