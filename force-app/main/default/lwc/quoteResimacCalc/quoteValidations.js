import { QuoteCommons } from "c/quoteCommons";
import { CalHelper, LESS_ONE_YEAR, GREATER_ONE_YEAR, GREATER_TWO_YEARS } from "./quoteResimacCalcHelper";

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
    console.log('errorList: ', JSON.stringify(errorList, null, 2));
    let warningList = r.warnings;
    // const { gst, abn, price } = quote;
    const { abnGst, price, applicationFee, maxApplicationFee } = quote;

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 18 ~ validate ~ quote", JSON.stringify(quote, null, 2));
    const naf = CalHelper.getNetRealtimeNaf(quote);

    if (applicationFee > maxApplicationFee) {
        warningList.push({
            field: "applicationFee",
            message: "Max Application Fee exceed."
        });
    }

    if (naf < 5000) {
        warningList.push({
            field: "price",
            message: `NAF less than $5000`
        });
    }

    if (naf > 250000) {
        warningList.push({
            field: "price",
            message: `NAF greater than $250000`
        });
    }

    // if ('Full Doc' === quote.loanType) {
    //     if (naf > 150000 && quote.propertyOwner === 'N') {
    //         warningList.push({
    //             field: "propertyOwner",
    //             message: `Max of $150,000 NAF is allowed for Property owner.`
    //         });
    //     } else if (naf > 100000 && quote.propertyOwner === 'Y') {
    //         warningList.push({
    //             field: "propertyOwner",
    //             message: `Max of $100,000 NAF is allowed for Non-Property owner.`
    //         });
    //     }
    // }

    if (quote.propertyOwner === 'N') {
        warningList.push({
            field: "propertyOwner",
            message: `Motor vehicles require 10% deposit Other assets 20%`
        });
    }

    if (quote.baseRate === null || !(quote.baseRate > 0.0)) {
        errorList.push({
            field: "baseRate",
            message: "Base Rate cannot be Zero."
        });
    }
    if (quote.term === "0") {
        errorList.push({
            field: "term",
            message: "Please choose an appropriate term."
        });
    } else if ('Tier 3 - Specialised' === quote.assetType && (quote.term === "72" || quote.term === "84")) {
        warningList.push({
            field: "term",
            message: `Max age of vehicle 15 years at term end.`
        });
    }
    if ("" === quote.privateSales) {
        errorList.push({
            field: "privateSales",
            message: "Please choose a Private Sale option."
        });
    }

    const MAX_BROKERAGE = quote.maxBrokeragePercentage;
    if (naf < 50000 && quote.brokeragePercentage > MAX_BROKERAGE) {
        warningList.push({
            field: "brokeragePercentage",
            message: `Warning Maximum of ${MAX_BROKERAGE}% brokerage for loans under 50K`
        });
    }
    if (naf > 50000 && quote.brokeragePercentage > MAX_BROKERAGE) {
        warningList.push({
            field: "brokeragePercentage",
            message: `Warning Maximum of ${MAX_BROKERAGE}% brokerage for loans over 50K`
        });
    }

    const vehicle_age = parseInt(quote.term) / 12 + parseInt(quote.assetAge);

    if (vehicle_age > 20) {
        warningList.push({
            field: "term",
            message: `Warning: Asset exceeds 20 years at term end. Please adjust term`
        });
    }

    if (quote.residualValue > 0) {
        warningList.push({
            field: "residualValue",
            message: `Balloon is calculated on car price less any deposit or trade in.`
        });
        if (quote.term > 60) {
            errorList.push({
                field: "residualValue",
                message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
            });
        }
    }
    if ("N" === quote.propertyOwner && 'Easy Doc' === quote.loanType) {
        warningList.push({
            field: "loanType",
            message: `Max Loan $150,000.`
        });
    } else if ('Easy Doc' === quote.loanType) {
        if ('Tier 1 - Cars' === quote.assetType && naf > 180000) {
            warningList.push({
                field: "price",
                message: `Max Loan $180,000.`
            });
        } else if (naf > 250000) {
            warningList.push({
                field: "price",
                message: `Max Loan $250,000.`
            });
        }
    }

    if (quote.clientRate <= 0) {
        warningList.push({
            field: "clientRate",
            message: "Client Rate should be greater than zero."
        });
    }

    if (abnGst === GREATER_TWO_YEARS) {
        warningList.push({
            field: "gst",
            message: "This fits Low Doc product, GST for 2 years required "
        });
    }

    if (abnGst === GREATER_ONE_YEAR) {
        warningList.push({
            field: "gst",
            message: "This fits Low Doc product, GST > 1 year is required "
        });
    }

    if (abnGst === LESS_ONE_YEAR) {
        warningList.push({
            field: "abnGst",
            message: "Minimum of 1 year ABN and GST required. Please refer to lender"
        });
    }

    if (price === '' || price === null) {
        errorList.push({
            field: "price",
            message: "Price cannot be empty"
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