import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteAPFCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
    console.log('quote in VALIDATION is: ', JSON.stringify(quote, null, 2));
    const {
        price, customerGrading, applicationFee, maxAppFeeDynamic,
        dof, maxDofFeeDynamic, clientRate, defaultBaseRate,
        loanTypeDetail, monthlyFee, maxMonthlyFee, ppsr, maxPpsr
    } = quote;


    const CENTRE_LINK = "Centrelink only";
    const STANDARD_PAYG = "Standard PAYG";
    const MAX_NAF_CENTRE_LINK = 10000;
    const MAX_NAF_STAND_PAYG = 25000;
    const MIN_LOAN_AMOUNT = 5000;

    const r =
        typeof messages == "undefined" || messages == null
            ? QuoteCommons.resetMessage()
            : messages;
    let errorList = r.errors;
    let warningList = r.warnings;

    const naf = CalHelper.getNetRealtimeNaf(quote);
    const loanAmount = CalHelper.getLoadAmount(quote);
    console.log('naf: ', naf);

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 36 ~ validate ~ quote.price",
        quote.price
    );
    if (price === null || price === 0) {
        errorList.push({
            field: "price",
            message: "Car Price cannot be Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 47 ~ validate ~ quote.customerGrading",
        quote.customerGrading
    );
    if (customerGrading === null) {
        errorList.push({
            field: "customerGrading",
            message: "Customer Grading should be selected."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 58 ~ validate ~ quote.applicationFee",
        quote.applicationFee
    );
    if (applicationFee === null || applicationFee === 0) {
        errorList.push({
            field: "applicationFee",
            message: "Application Fee cannot be Zero."
        });
    }
    if (applicationFee > maxAppFeeDynamic) {
        errorList.push({
            field: "applicationFee",
            message: "Max Application Fee exceed."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 75 ~ validate ~ quote.dof",
        quote.dof
    );
    if (dof === null || dof === 0) {
        errorList.push({
            field: "dof",
            message: "DOF cannot be Zero."
        });
    }
    if (dof > maxDofFeeDynamic) {
        errorList.push({
            field: "dof",
            message: "Max. DOF exceed."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 92 ~ validate ~ quote.clientRate",
        quote.clientRate
    );
    if (clientRate === null || clientRate === 0) {
        errorList.push({
            field: "clientRate",
            message: "Client Rate cannot be Zero."
        });
    }
    if (clientRate > defaultBaseRate) {
        errorList.push({
            field: "clientRate",
            message: `Client Rate cannot be greater than ${defaultBaseRate}%`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 109 ~ validate ~ quote.loanTypeDetail",
        quote.loanTypeDetail
    );
    if (loanTypeDetail === CENTRE_LINK && naf > MAX_NAF_CENTRE_LINK) {
        warningList.push({
            field: "loanTypeDetail",
            message: `Max $${MAX_NAF_CENTRE_LINK} Plus fees and add ons for centrelink only`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 120 ~ validate ~ quote.loanTypeDetail",
        quote.loanTypeDetail
    );
    if (loanTypeDetail === STANDARD_PAYG && naf > MAX_NAF_STAND_PAYG) {
        warningList.push({
            field: "loanTypeDetail",
            message: `Max $${MAX_NAF_STAND_PAYG} Plus fees and add ons`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 131 ~ validate ~ loanAmount",
        loanAmount
    );
    if (loanAmount < MIN_LOAN_AMOUNT) {
        warningList.push({
            field: "price",
            message: `Minimum loan amount is $${MIN_LOAN_AMOUNT}`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 142 ~ validate ~ quote.monthlyFee",
        quote.monthlyFee
    );
    if (monthlyFee > maxMonthlyFee) {
        errorList.push({
            field: "monthlyFee",
            message: `Monthly Fee cannot be greater than $${maxMonthlyFee}`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 153 ~ validate ~ quote.ppsr",
        quote.ppsr
    );
    if (ppsr > maxPpsr) {
        errorList.push({
            field: "ppsr",
            message: `PPSR Fee cannot be greater than $${maxPpsr}`
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

    // if (quote.commission === null || !(quote.commission > 0.0)) {
    //     warningList.push({
    //         field: "Commissions and Repayments",
    //         message: `The commission is below zero. Please make adjustment to make sure commission is above zero.`
    //     });
    // }

    if (quote.monthlyPayment === null || quote.monthlyPayment === 0) {
        warningList.push({
            field: "monthlyPayment",
            message: `Payment is not updated as the calculator does not contain relevant info.`
        });
    }

    if (quote.commission === null || quote.commission === 0) {
        warningList.push({
            field: "commission",
            message: `Estimated Commission is not updated as the calculator does not contain relevant info.`
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