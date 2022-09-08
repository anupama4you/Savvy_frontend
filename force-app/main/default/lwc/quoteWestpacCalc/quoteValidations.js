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
        "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.loanProduct",
        quote.loanProduct
    );
    if ('Novated Lease' === quote.loanProduct) {
        warningList.push({
            field: "loanProduct",
            message: "Residuals must adhere to ATO guidelines. Check you have the correct residual."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ NAF",
        NAF
    );
    if (NAF < 10000) {
        errorList.push({
            field: "loanProduct",
            message: "Financed Amount cannot be less than $10,000."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.clientRate",
        quote.clientRate
    );
    if (quote.clientRate == null || quote.clientRate <= 0.0) {
        errorList.push({
            field: "clientRate",
            message: "Client Rate cannot be Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.baseRate",
        quote.baseRate
    );
    if (quote.baseRate <= 0.0) {
        errorList.push({
            field: "baseRate",
            message: "Base Rate should be greater than zero"
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.brokeragePercentage",
        quote.brokeragePercentage
    );
    if (quote.brokeragePercentage > MAX_BROKERAGE) {
        warningList.push({
            field: "brokeragePercentage",
            message: "Standard brokerage is 3%. For max 4% refer to lender"
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.residualValue",
        quote.residualValue
    );
    if (quote.residualValue < 0) {
        errorList.push({
            field: "residualValue",
            message: "Residual value should be greater than or equal to zero"
        });
    }


    // console.log(
    //     "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.applicationFee",
    //     quote.applicationFee
    // );
    // if (quote.applicationFee > quote.maxApplicationFee) {
    //     errorList.push({
    //         field: "applicationFee",
    //         message: "Max Application Fee exceed."
    //     });
    // }


    // console.log(
    //     "🚀 ~ file: quoteValidations.js ~ line 21 ~ validate ~ quote.clientRate",
    //     quote.clientRate
    // );
    // if (quote.clientRate === null || !(quote.clientRate > 0.0)) {
    //     errorList.push({
    //         field: "clientRate",
    //         message: "Client Rate should not be zero."
    //     });
    // } else if (quote.clientRate > maxRate) {
    //     errorList.push({
    //         field: "clientRate",
    //         message: `Client Rate cannot exceed the max rate: ${maxRate}%`
    //     });
    // } else if (quote.clientRate < baseRate) {
    //     warningList.push({
    //         field: "clientRate",
    //         message: `Client Rate should not be below base rate`
    //     });
    // }

    // console.log(
    //     "🚀 ~ file: quoteValidations.js ~ line 42 ~ validate ~ quote.term",
    //     quote.term
    // );
    // if (quote.term === null || quote.term === 0) {
    //     errorList.push({
    //         field: "term",
    //         message: "Please select an appropriate term."
    //     });
    // }

    // console.log(
    //     "🚀 ~ file: quoteValidations.js ~ line 53 ~ validate ~ quote.clientTier",
    //     quote.clientTier
    // );
    // if (quote.clientTier === null || quote.clientTier.length === 0) {
    //     errorList.push({
    //         field: "clientTier",
    //         message: "Please select a tier for your client."
    //     });
    // }

    // console.log(
    //     "🚀 ~ file: quoteValidations.js ~ line 65 ~ validate ~ quote.residual",
    //     quote.residual
    // );
    // if (quote.residual > 0 && quote.term > 60) {
    //     errorList.push({
    //         field: "residual",
    //         message: 'You cannot have a balloon or residual payment when the loan term is > 5 years.'
    //     });
    // }

    // console.log(
    //     "🚀 ~ file: quoteValidations.js ~ line 76 ~ validate ~ quote.assetAge",
    //     quote.assetAge
    // );
    // if (quote.residual > 0 && !(quote.assetAge === "New" || quote.assetAge === "Used 0-5 years")) {
    //     warningList.push({
    //         field: "assetAge",
    //         message: `Residuals may not be available for assets > 5 years old`
    //     });
    // }



    // console.log(
    //     "🚀 ~ file: quoteValidations.js ~ line 89 ~ validate ~ quote.privateSales ~ quote.clientTier",
    //     quote.privateSales, quote.clientTier
    // );
    // if (quote.assetType === 'Caravan') {
    //     if (quote.privateSales === 'Y' && NAF > 100000) {
    //         warningList.push({
    //             field: "privateSales",
    //             message: 'Normally max NAF of $100,000 for Private sale assets - refer to Pepper'
    //         });
    //     };
    //     if (quote.clientTier === 'C') {
    //         warningList.push({
    //             field: "clientTier",
    //             message: 'Leisure assets not normally available for C risk grade'
    //         });
    //     }
    // }

    // console.log(
    //     "🚀 ~ file: quoteValidations.js ~ line 108 ~ validate ~ quote.privateSales",
    //     quote.privateSales
    // );
    // if (quote.privateSales === 'Y' && NAF > 75000) {
    //     warningList.push({
    //         field: "privateSales",
    //         message: 'Private sales max. NAF should be $75K'
    //     });
    // }

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