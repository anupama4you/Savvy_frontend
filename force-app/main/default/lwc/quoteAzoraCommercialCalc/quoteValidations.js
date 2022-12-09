import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteAzoraCommercialCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} rate - finance one rates
 * @param {Object} lender - lender 
 * @param {Object} naf - total naf
 * @param {Object} messages - old messages object
 * @returns
 */

const validate = (quote, messages) => {
    console.log('quote in validation is: ', JSON.stringify(quote, null, 2));
    const r =
        typeof messages == "undefined" || messages == null
            ? QuoteCommons.resetMessage()
            : messages;
    let errorList = r.errors;
    let warningList = r.warnings;
    const { maxBrok, brokerage, loanTypeDetail, abn, gst, maxApplicationFee, applicationFee, price } = quote;
    // asset price
    const nafComm = CalHelper.getNafComm(quote);

    if (applicationFee > maxApplicationFee) {
        warningList.push({
            field: "applicationFee",
            message: "Max Application Fee exceed."
        });
    }

    if (price === '' || price === null) {
        errorList.push({
            field: "price",
            message: "Price cannot be empty"
        });
    }

    if (quote.clientRate == null || quote.clientRate === 0.0) {
        errorList.push({
            field: "clientRate",
            message: "Client Rate cannot be Zero."
        });
    }
    if (quote.brokerage == null || quote.brokerage === 0.0) {
        errorList.push({
            field: "brokerage",
            message: "Brokerage cannot be Zero."
        });
    }
    if (quote.brokerage < 0.0) {
        errorList.push({
            field: "brokerage",
            message: "Brokerage should not be below Zero."
        });
    }
    if (quote.baseRate === null || quote.baseRate === 0.0 || quote.baseRate < 0) {
        errorList.push({
            field: "baseRate",
            message: "Base Rate cannot be Zero."
        });
    }
    if (quote.term === null || quote.term === 0) {
        errorList.push({
            field: "term",
            message: "Please choose an appropriate term."
        });
    }
    if (quote.residual > 0 && quote.term > 60) {
        errorList.push({
            field: "term",
            message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
        });
    }
    // extra validation
    if (brokerage > maxBrok) {
        warningList.push({
            field: "brokerage",
            message: "Max borkerage exceeded"
        });
    }
    if (loanTypeDetail === "Adverse") {
        if (abn !== "> 4 years") {
            warningList.push({
                field: "abn",
                message: "Min 4 year ABN for Adverse product"
            });
        }
        if (gst === null || gst === "No GST" || gst === "> 6 months") {
            warningList.push({
                field: "gst",
                message: "Min 12 month GST registration required (24 month for financial defaults) for Adverse product"
            });
        }
        if ((gst === null || gst === "No GST") && nafComm > 30000) {
            warningList.push({
                field: "price",
                message: "Max $30,000 for < 6 months GST"
            });
        }
    }
    if (loanTypeDetail === "Streamline") {
        if (abn === "> 24 months" && (gst === null || gst === "No GST") && nafComm > 30000) {
            warningList.push({
                field: "price",
                message: "Max $30,000 for < 6 months GST"
            });
        }
        if (abn === "> 24 months" && gst === "> 6 months" && nafComm > 50000) {
            warningList.push({
                field: "price",
                message: "GST length maximum loan $50,000"
            });
        }
        if (abn === "> 4 years" && gst !== "> 24 months") {
            warningList.push({
                field: "gst",
                message: "This ABN/GST requires 24 months for car purchases"
            });
        }
    }
    if (loanTypeDetail === "Kickstart") {
        if (abn === "6 months - 24 months" && (gst === null || gst === "No GST") && nafComm > 30000) {
            warningList.push({
                field: "price",
                message: "Max $30,000 for < 6 months GST"
            });
        }
        if (abn === "> 24 months" && gst === "> 6 months" && nafComm > 50000) {
            warningList.push({
                field: "price",
                message: "GST length maximum loan $50,000"
            });
        }
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

    if (quote.commission <= 0) {
        warningList.push({
            message: "The commission is below zero. Please make adjustment to make sure commission is above zero."
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