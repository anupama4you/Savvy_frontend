import { QuoteCommons } from "c/quoteCommons";
// import { CalHelper } from "./quotePepperCommCalcHelper";
import { CalHelper } from "./quoteAzoraCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
    // console.log(`*v*: ${JSON.stringify(quote, null, 2)}`);
    const r =
        typeof messages == "undefined" || messages == null
            ? QuoteCommons.resetMessage()
            : messages;
    let errorList = r.errors;
    let warningList = r.warnings;

    const setting = quote.validSetting;

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 23 ~ validate ~ quote.applicationFee",
        quote.applicationFee
    );
    if (quote.applicationFee > quote.maxApplicationFee) {
        warningList.push({
            field: "applicationFee",
            message: `Application Fee should not be greater than $${quote.maxApplicationFee}.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 34 ~ validate ~ quote.monthlyFee",
        quote.monthlyFee
    );
    if (quote.monthlyFee != setting.Monthly_Fee__c) {
        warningList.push({
            field: "monthlyFee",
            message: "Monthly Fee should be $15."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 45 ~ validate ~ quote.riskFee",
        quote.riskFee
    );

    const creditValids = ['832 - 1200', '725 - 832', '621 - 725', '509 - 621'];
    if (creditValids.includes(quote.creditScore) && quote.riskFee !== 0) {
        warningList.push({
            field: "riskFee",
            message: `Risk Fee should be Zero.`,
        });
    } else if (quote.riskFee > quote.riskFeeTotal) {
        warningList.push({
            field: "riskFee",
            message: `Risk Fee should not be greater than ${quote.riskFeeTotal}`,
        });
    }

    const minLoan = quote.price - quote.deposit;

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 65 ~ validate ~ Loan",
        minLoan
    );
    if (minLoan < 7500 || minLoan > quote.maxLoan) {
        warningList.push({
            field: "minLoan",
            message: `Loan amount should be between $7500 and ${quote.maxLoan}`,
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 76 ~ validate ~ quote.dof ",
        quote.dof
    );
    if (quote.dof > quote.maxDof) {
        warningList.push({
            field: "dof",
            message: `DOF hould not be greater than ${quote.maxDof}`,
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 87 ~ validate ~ quote.applicationFee",
        quote.applicationFee
    );
    if (quote.applicationFee < 0) {
        errorList.push({
            field: "applicationFee",
            message: "Application Fee should not be below Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 98 ~ validate ~ quote.dof",
        quote.dof
    );
    if (quote.dof < 0) {
        errorList.push({
            field: "dof",
            message: "DOF should not be below Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 109 ~ validate ~ quote.monthlyFee",
        quote.monthlyFee
    );
    if (quote.monthlyFee < 0) {
        errorList.push({
            field: "monthlyFee",
            message: "Monthly Fee should not be below Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 120 ~ validate ~ quote.riskFee",
        quote.riskFee
    );
    if (quote.riskFee < 0) {
        errorList.push({
            field: "riskFee",
            message: `Risk Fee should not be below Zero.`,
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