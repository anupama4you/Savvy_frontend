import { QuoteCommons } from "c/quoteCommons";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
    console.log('quote for Validation is: ', JSON.stringify(quote, null, 2));
    const r =
        typeof messages == "undefined" || messages == null
            ? QuoteCommons.resetMessage()
            : messages;
    let errorList = r.errors;
    let warningList = r.warnings;

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 20 ~ validate ~ quote.price",
        quote.price
    );
    if (quote.price === null || !(quote.price > 0.0)) {
        errorList.push({
            field: "price",
            message: "Car Price cannot be Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 31 ~ validate ~ quote.baseRate",
        quote.baseRate
    );
    if (quote.baseRate === null || quote.baseRate === 0.0) {
        errorList.push({
            field: "baseRate",
            message: "Base Rate cannot be Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 42 ~ validate ~ quote.brokeragePercentage",
        quote.brokeragePercentage
    );
    if (quote.brokeragePercentage > 8) {
        errorList.push({
            field: "brokeragePercentage",
            message: "Brokerage cannot be greater than 8%."
        });
    }

    const ppsrObjs = [
        { label: "ppsrLabel1", value: "ppsr1", index: "first" },
        { label: "ppsrLabel2", value: "ppsr2", index: "second" },
        { label: "ppsrLabel3", value: "ppsr3", index: "third" },
        { label: "ppsrLabel4", value: "ppsr4", index: "fourth" },
    ];

    ppsrObjs.forEach(ppsrObj => {
        console.log(
            `🚀 ~ file: quoteValidations.js ~ line 61 ~ validate ~ quote.ppsr`,
            ppsrObj.value
        );
        if (!quote[`${ppsrObj.label}`] && quote[`${ppsrObj.value}`] > 0) {
            errorList.push({
                field: `${ppsrObj.value}`,
                message: `Please fill a description for the ${ppsrObj.index} detail which its value is ${quote[ppsrObj.value]} `,
            });
        }
    });

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 73 ~ validate ~ quote.residual",
        quote.residual
    );
    if (quote.residual > 0 && quote.term > 60) {
        errorList.push({
            field: "residual",
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

    r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
    r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
    return r;
};

const Validations = {
    validate: validate,
    validatePostCalculation: validatePostCalculation
};

export { Validations };