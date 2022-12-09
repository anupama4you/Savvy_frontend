import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteUMELoansCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
    const ZERO = 0;
    const MIN_MONTHLY_FEE = 10;
    const MAX_NAF = 30000;
    const NAF = CalHelper.getNetRealtimeNaf(quote);

    console.log('quote for Validation is: ', JSON.stringify(quote, null, 2));
    const r =
        typeof messages == "undefined" || messages == null
            ? QuoteCommons.resetMessage()
            : messages;
    let errorList = r.errors;
    let warningList = r.warnings;

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 25 ~ validate ~ quote.price",
        quote.price
    );
    if (quote.price == ZERO || quote.price == null) {
        errorList.push({
            field: "price",
            message: `Car Price cannot be Zero.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 36 ~ validate ~ quote.applicationFee",
        quote.applicationFee
    );
    if (quote.applicationFee == ZERO || quote.applicationFee == null) {
        errorList.push({
            field: "applicationFee",
            message: `Application Fee cannot be Zero.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 47 ~ validate ~ quote.applicationFee",
        quote.applicationFee
    );
    if (quote.applicationFee > quote.maxApplicationFee) {
        errorList.push({
            field: "applicationFee",
            message: `Max Application Fee exceed.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 58 ~ validate ~ quote.dof",
        quote.dof
    );
    if (quote.dof == ZERO || quote.dof == null) {
        errorList.push({
            field: "dof",
            message: `DOF cannot be Zero.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 69 ~ validate ~ quote.dof",
        quote.dof
    );
    if (quote.dof > quote.maxDof) {
        warningList.push({
            field: "dof",
            message: `DOF is the slower of 11% of car price or $1795`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 80 ~ validate ~ quote.clientRate",
        quote.clientRate
    );
    if (quote.clientRate == ZERO || quote.clientRate == null) {
        errorList.push({
            field: "clientRate",
            message: `Client Rate cannot be Zero.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 91 ~ validate ~ quote.clientRate",
        quote.loanType
    );
    if (quote.clientRate > quote.defaultClientRate) {
        errorList.push({
            field: "clientRate",
            message: `Client Rate cannot be greater than ${quote.defaultClientRate}%`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 102 ~ validate ~ quote.monthlyFee",
        quote.monthlyFee
    );
    if (quote.monthlyFee < MIN_MONTHLY_FEE || quote.monthlyFee > quote.maxMonthlyFee) {
        errorList.push({
            field: "monthlyFee",
            message: `Monthly Fee should be between $${MIN_MONTHLY_FEE} and $${quote.maxMonthlyFee}`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 113 ~ validate ~ quote.ppsr",
        quote.ppsr
    );
    if (quote.ppsr > quote.maxPpsr) {
        errorList.push({
            field: "ppsr",
            message: `PPSR cannot be greater than ${quote.maxPpsr}`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 124 ~ validate ~ NAF",
        NAF
    );
    if (NAF > MAX_NAF) {
        warningList.push({
            field: "NAF",
            message: `Max NAF ${MAX_NAF} please refer to lender `
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