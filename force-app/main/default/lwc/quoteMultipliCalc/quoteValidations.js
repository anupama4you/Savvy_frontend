import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteMultipliCalcHelper";

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


    const VALIDATION_TABLE = [
        {
            condiNum: 1,
            name: "loanType",
            value: "Multipli 600",
            info: "Minimum 2 year ABN and GST",
            list: warningList,
            field: "loanType"
        },
        {
            condiNum: 1,
            name: "loanType",
            value: "1 Day ABN",
            info: "Must be registered for GST",
            list: warningList,
            field: "loanType"
        },
        {
            condiNum: 1,
            name: "assetType",
            value: "Equipment",
            info: "Only New euqipment accepted",
            list: warningList,
            field: "assetType"
        },
        {
            condiNum: 1,
            name: "assetType",
            value: "Equipment",
            info: "Residual payments only on New Assets",
            list: warningList,
            field: "assetType"
        },
        {
            condiNum: 1,
            name: "assetType",
            value: "Wheels Used",
            info: "Residual payments only on New Assets",
            list: warningList,
            field: "assetType"
        },
        {
            condiNum: 3,
            name1: "loanType",
            value1: "Multipli 600",
            name2: "customerProfile",
            value2: "N",
            name3: "creditScore",
            value3: "< 600",
            info: "Minimum credit score is 600 - check with lender",
            list: warningList,
            field: "loanType"
        },
        {
            condiNum: 3,
            name1: "loanType",
            value1: "Multipli 600",
            name2: "customerProfile",
            value2: "N",
            name3: "creditScore",
            value3: "600 - 629",
            info: "20% deposit required for non property with this credit score",
            list: warningList,
            field: "loanType"
        },
        {
            condiNum: 3,
            name1: "loanType",
            value1: "Multipli 600",
            name2: "customerProfile",
            value2: "N",
            name3: "creditScore",
            value3: "630 - 749",
            info: "10% deposit required for non property with this credit score",
            list: warningList,
            field: "loanType"
        },
        {
            condiNum: 3,
            name1: "loanType",
            value1: "Multipli 600",
            name2: "customerProfile",
            value2: "N",
            name3: "creditScore",
            value3: "750 +",
            info: "There is no deposit required for non property with this credit score",
            list: warningList,
            field: "loanType"
        },
        {
            condiNum: 2,
            name1: "loanType",
            value1: "1 Day ABN",
            name2: "customerProfile",
            value2: "N",
            info: "30% deposit required for non property with this credit score",
            list: warningList,
            field: "customerProfile"
        },
        {
            condiNum: 2,
            name1: "loanType",
            value1: "1 Day ABN",
            name2: "customerProfile",
            value2: "Y",
            info: "20% deposit required for non property with this credit score",
            list: warningList,
            field: "customerProfile"
        },

    ];


    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 18 ~ validate ~ quote", JSON.stringify(quote, null, 2));
    const naf = CalHelper.getNetRealtimeNaf(quote);
    const { price, residualValue, term, assetAge, loanType, assetType, privateSales } = quote;

    if (residualValue > price * 0.3) {
        warningList.push({
            field: "residualValue",
            message: `Max 30% residual over 5 years`
        });
    }
    const carYear = parseInt(term) / 12 + parseInt(assetAge);
    if (carYear > 20) {
        warningList.push({
            field: "residualValue",
            message: `Max age of car is 20 years at term end`
        });
    }
    if (loanType === "Multipli 600" && naf > 150000) {
        warningList.push({
            field: "price",
            message: `Maximum NAF OF $150,000 `
        });
    }
    if (loanType === "1 Day ABN" && naf > 150000) {
        warningList.push({
            field: "price",
            message: `Maximum NAF OF $150,000 `
        });
    }
    if (assetType === "Equipment" && naf > 75000) {
        warningList.push({
            field: "price",
            message: `Maximum NAF OF $75,000 `
        });
    }
    if (privateSales === null || privateSales === '') {
        errorList.push({
            field: "privateSales",
            message: `privateSales cannot be empty`
        });
    }


    VALIDATION_TABLE.forEach(o => {
        if (o.condiNum == 1 && quote[o.name] === o.value) {
            o.list.push({
                field: o.field,
                message: o.info
            });
        }
        if (o.condiNum == 2 &&
            quote[o.name1] === o.value1 &&
            quote[o.name2] === o.value2) {
            o.list.push({
                field: o.field,
                message: o.info
            });
        }
        if (o.condiNum == 3 &&
            quote[o.name1] === o.value1 &&
            quote[o.name2] === o.value2 &&
            quote[o.name3] === o.value3) {
            o.list.push({
                field: o.field,
                message: o.info
            });
        }
    });

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

    r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
    r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
    return r;
};

const Validations = {
    validate: validate,
    validatePostCalculation: validatePostCalculation
};

export { Validations };