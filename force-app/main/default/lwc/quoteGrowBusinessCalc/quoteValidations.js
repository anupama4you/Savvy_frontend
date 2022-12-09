import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteGrowBusinessCalcHelper";
// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
    console.log(`*v*: ${JSON.stringify(quote, null, 2)}`);
    const r =
        typeof messages == "undefined" || messages == null
            ? QuoteCommons.resetMessage()
            : messages;
    let errorList = r.errors;
    let warningList = r.warnings;

    const setting = quote.validSetting;
    const NAF = CalHelper.getNetRealtimeNaf(quote);
    const EFS600 = 600;
    const EFS600NAF = 4999999;
    const EFS500 = 500;
    const EFS500NAF = 249999;
    const ABN2Y = '< 2 years';
    const GST2Y = '> 2 years';


    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 23 ~ validate ~ quote.price",
        quote.price
    );
    if (quote.price > 300000) {
        errorList.push({
            field: "applicatiopricenFee",
            message: `Max loan allowed is $300,000.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 23 ~ validate ~ quote.baseRate",
        quote.baseRate
    );
    if (quote.baseRate === 0 || quote.baseRate === null) {
        errorList.push({
            field: "baseRate",
            message: `Base Rate cannot be Zero.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 23 ~ validate ~ quote.brokeragePercentage",
        quote.brokeragePercentage
    );
    if (quote.brokeragePercentage > quote.maxBrokPercentage) {
        errorList.push({
            field: "brokeragePercentage",
            message: `Brokerage cannot be greater than ${quote.maxBrokPercentage}%`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 23 ~ validate ~ quote.equifaxScore",
        quote.equifaxScore
    );
    if ((quote.equifaxScore === null || quote.equifaxScore < EFS600) && NAF > EFS600NAF) {
        errorList.push({
            field: "equifaxScore",
            message: `Score less than 600 does not apply`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 23 ~ validate ~ quote.equifaxScore",
        quote.equifaxScore
    );
    if ((quote.equifaxScore === null || quote.equifaxScore < EFS500) && NAF > EFS500NAF) {
        errorList.push({
            field: "equifaxScore",
            message: `Score less than 500 does not apply`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 23 ~ validate ~ quote.abnLength",
        quote.abnLength
    );
    if (quote.abnLength === ABN2Y) {
        errorList.push({
            field: "abnLength",
            message: `ABN minimum is 2 years`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 23 ~ validate ~ quote.gstLength",
        quote.gstLength
    );
    if (quote.gstLength !== GST2Y) {
        errorList.push({
            field: "gstLength",
            message: `Must have 2 years GST registration`
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