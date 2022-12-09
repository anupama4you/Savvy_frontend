import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteEarlyPayCommCalcHelper";

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
    const MAX_NON_PROPERTY_OWNER = 150000;
    const MAX_VEHICLE_PROPERTY_OWNER = 500000;
    const MAX_SECONDARY_ASSET_OWNER = 250000;
    const EMPTY = "";
    const ZERO = 0;
    const LESS_450 = "< 450";
    const LESS_2YEARS = "< 2 years";
    const NO = "N";
    const YES = "Y";
    const VEHICLE = "Vehicles";
    const SEC_ASSET = "Secondary/Tertiary Assets";


    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 18 ~ validate ~ quote", JSON.stringify(quote, null, 2));
    const naf = CalHelper.getNetRealtimeNaf(quote);

    const { price, netDeposit, customerProfile, assetType, assetAge,
        directorSoleTraderScore, abnGst, brokerage, maxBrokerage, clientRate,
        baseRate, applicationFee, maxApplicationFee } = quote;

    const priceLessNAF = price - netDeposit;

    if (price === ZERO || price === EMPTY) {
        errorList.push({
            field: "price",
            message: `Please enter the asset price`
        });
    }
    // if (assetAge === EMPTY) {
    //     errorList.push({
    //         field: "assetAge",
    //         message: `Please choose an Asset Age option`
    //     });
    // }
    if (clientRate === EMPTY || clientRate <= ZERO) {
        warningList.push({
            field: "clientRate",
            message: `Client Rate should be greater than zero.`
        });
    }
    if (baseRate === EMPTY || baseRate <= ZERO) {
        errorList.push({
            field: "baseRate",
            message: `Base Rate should be greater than zero.`
        });
    }

    if (customerProfile === NO && priceLessNAF > MAX_NON_PROPERTY_OWNER) {
        warningList.push({
            field: "price",
            message: `Bank statements required max $150K non property owner`
        });
    }
    if (customerProfile === YES && assetType === VEHICLE && priceLessNAF > MAX_VEHICLE_PROPERTY_OWNER) {
        warningList.push({
            field: "price",
            message: `Bank statements required max $500K for vehicles - property owner`
        });
    }
    if (customerProfile === YES && assetType === SEC_ASSET && priceLessNAF > MAX_SECONDARY_ASSET_OWNER) {
        warningList.push({
            field: "price",
            message: `Bank statements required max $250K for secondary assets - property owner`
        });
    }

    if (directorSoleTraderScore === EMPTY) {
        errorList.push({
            field: "directorSoleTraderScore",
            message: "Please choose a Director/Sole Trader Score option."
        });
    }

    if (directorSoleTraderScore === LESS_450) {
        errorList.push({
            field: "directorSoleTraderScore",
            message: `Minimum score of 450 required`
        });
    }

    if (abnGst === LESS_2YEARS) {
        warningList.push({
            field: "abnGst",
            message: `Min 2 years ABN/GST required`
        });
    }

    if (customerProfile === NO) {
        warningList.push({
            field: "customerProfile",
            message: `Non property owners require 20% deposit`
        });
    }

    if (brokerage > maxBrokerage && naf < MAX_NON_PROPERTY_OWNER) {
        warningList.push({
            field: "brokerage",
            message: `Max brokerage of ${maxBrokerage}% for finance < $150K`
        });
    }
    if (brokerage > maxBrokerage && naf >= MAX_NON_PROPERTY_OWNER) {
        warningList.push({
            field: "brokerage",
            message: `Max brokerage of ${maxBrokerage}% for finance up to $150K - $500K`
        });
    }

    const baseRates = CalHelper.options.baseRates(quote);
    console.log('baseRates: ', JSON.stringify(baseRates, null, 2));

    if (baseRate === baseRates[0].value) {
        warningList.push({
            field: "baseRate",
            message: `This interest rate applies to NAF $150K - $500K`
        });
    }

    if (baseRate === baseRates[1].value) {
        warningList.push({
            field: "baseRate",
            message: `This interest rate applies to NAF < $150K`
        });
    }

    if (applicationFee > maxApplicationFee) {
        warningList.push({
            field: "applicationFee",
            message: "Max Application Fee exceed."
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

    r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
    r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
    return r;
};

const Validations = {
    validate: validate,
    validatePostCalculation: validatePostCalculation
};

export { Validations };