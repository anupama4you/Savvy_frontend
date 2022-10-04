import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteBOQCalcHelper";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
    const ZERO = 0;
    const TWO = 2;
    const SEVEN = 7;
    const TEN = 10;
    const FIFTEEN = 15;
    const SIXTY = 60;
    const MIN_NAF_NEW_CAR = 1500;
    const MIN_NAF_USED_CAR = 4000;
    const MAX_NAF_PLAT_PLUS = 200000;
    const MAX_NAF_PLAT = 80000;
    const MAX_NAF_GOLD = 50000;
    const YES = 'Y';
    const CARAVANS = "Caravans";
    const CAMPER = "Campertrailer";
    const MOTOR = "Motorhome";
    const MARINE = "Marine";
    const NEW = 'New';
    const USED = 'Used';
    const OWNER = "Owner";
    const PLAT_PLUS = "Platinum Plus";
    const PLAT = "Platinum";
    const GOLD = "Gold";
    const MAX_NAF = 65000;
    const NAF = CalHelper.getNetRealtimeNaf(quote);

    const getNAFPercent = (quote, percent) => {
        return quote.price * percent / 100;
    };
    const get10PercentNAF = getNAFPercent(quote, 10);

    console.log('quote for Validation is: ', JSON.stringify(quote, null, 2));
    const r =
        typeof messages == "undefined" || messages == null
            ? QuoteCommons.resetMessage()
            : messages;
    let errorList = r.errors;
    let warningList = r.warnings;

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 50 ~ validate ~ quote.price",
        quote.price
    );
    if (quote.price == ZERO || quote.price == null) {
        errorList.push({
            field: "price",
            message: `Car Price cannot be Zero.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 61 ~ validate ~ quote.applicationFee",
        quote.applicationFee
    );
    if (quote.applicationFee == ZERO || quote.applicationFee == null) {
        errorList.push({
            field: "applicationFee",
            message: `Application Fee cannot be Zero.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 72 ~ validate ~ quote.applicationFee",
        quote.applicationFee
    );
    if (quote.applicationFee > quote.maxApplicationFee) {
        errorList.push({
            field: "applicationFee",
            message: `Max Application Fee exceed.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 83 ~ validate ~ quote.dof",
        quote.dof
    );
    if (quote.dof == ZERO || quote.dof == null) {
        errorList.push({
            field: "dof",
            message: `DOF cannot be Zero.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 94 ~ validate ~ quote.dof",
        quote.dof
    );
    if (quote.dof > quote.maxDof) {
        errorList.push({
            field: "dof",
            message: `DOF cannot be more than $${quote.maxDof}`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 105 ~ validate ~ quote.clientRate",
        quote.clientRate
    );
    if (quote.clientRate == ZERO || quote.clientRate == null) {
        errorList.push({
            field: "clientRate",
            message: `Client Rate cannot be Zero.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 116 ~ validate ~ quote.term",
        quote.term
    );
    if (quote.term > SIXTY && quote.residual > ZERO) {
        errorList.push({
            field: "term",
            message: `You cannot have a balloon or residual payment when the loan term is > 5 years.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 127 ~ validate ~ quote.privateSales",
        quote.privateSales
    );
    if (quote.privateSales == null) {
        errorList.push({
            field: "privateSales",
            message: `Please select a value for Private Sales`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 138 ~ validate ~ quote.assetType",
        quote.assetType
    );
    if (quote.privateSales == YES) {
        if (quote.assetType !== CARAVANS) {
            errorList.push({
                field: "assetType",
                message: `Private sales only available for Caravans`
            });
        }
        else if (quote.riskGrade === GOLD) {
            errorList.push({
                field: "riskGrade",
                message: `Private sale caravans for Platinum Plus and Platinum risk grades`
            });
        }
        if (quote.assetType === CARAVANS && NAF > MAX_NAF) {
            warningList.push({
                field: "assetType",
                message: `10% deposit required when NAF exceeds $${MAX_NAF}`
            });
        }
    }

    const { term, assetAge } = quote;
    const termToYears = term / 12;
    let carAge;
    assetAge === "15+" ? carAge = 15 : carAge = parseInt(assetAge);
    const totalYear = termToYears + carAge;

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 169 ~ validate ~ quote.assetType",
        quote.assetType
    );
    if ((quote.assetType === CARAVANS || quote.assetType === MARINE) && totalYear > FIFTEEN) {
        warningList.push({
            field: "assetType",
            message: `Caravans maximum age at end of term is ${FIFTEEN} years.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 180 ~ validate ~ quote.assetType",
        quote.assetType
    );
    if (quote.assetType === CAMPER && totalYear > SEVEN) {
        warningList.push({
            field: "assetType",
            message: `Camper trailer maximum age at end of term is ${SEVEN} years.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 191 ~ validate ~ quote.assetType",
        quote.assetType
    );
    if (quote.assetType === MOTOR && totalYear > TEN) {
        warningList.push({
            field: "assetType",
            message: `Motorhome maximum age at end of term is ${TEN} years.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 202 ~ validate ~ quote.assetCondition",
        quote.assetCondition
    );
    if (quote.assetCondition === NEW && NAF < MIN_NAF_NEW_CAR) {
        errorList.push({
            field: "assetCondition",
            message: `Amount Finaced must be greater than $${MIN_NAF_NEW_CAR}`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 213 ~ validate ~ quote.assetCondition",
        quote.assetCondition
    );
    if (quote.assetCondition === USED && NAF < MIN_NAF_USED_CAR) {
        errorList.push({
            field: "assetCondition",
            message: `Amount Finaced must be greater than $${MIN_NAF_USED_CAR}`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 224 ~ validate ~ quote.riskGrade",
        quote.riskGrade
    );
    if (quote.riskGrade === PLAT_PLUS && NAF > MAX_NAF_PLAT_PLUS) {
        warningList.push({
            field: "riskGrade",
            message: `Amount Finaced must be less than $${MAX_NAF_PLAT_PLUS}`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 235 ~ validate ~ quote.riskGrade",
        quote.riskGrade
    );
    if (quote.riskGrade === PLAT && NAF > MAX_NAF_PLAT) {
        warningList.push({
            field: "riskGrade",
            message: `Amount Finaced must be less than $${MAX_NAF_PLAT}`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 246 ~ validate ~ quote.riskGrade",
        quote.riskGrade
    );
    if (quote.riskGrade === GOLD && NAF > MAX_NAF_GOLD) {
        errorList.push({
            field: "riskGrade",
            message: `Amount Finaced must be less than $${MAX_NAF_GOLD}`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 257 ~ validate ~ quote.riskGrade",
        quote.riskGrade
    );
    if (quote.riskGrade === GOLD && quote.term > SIXTY) {
        errorList.push({
            field: "riskGrade",
            message: `Term must be less than ${SIXTY}.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 268 ~ validate ~ quote.assetCondition",
        quote.assetCondition
    );
    if (quote.assetCondition === NEW && totalYear > TWO) {
        warningList.push({
            field: "assetCondition",
            message: `New car must be less than ${TWO} years.`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 279 ~ validate ~ quote.assetType",
        quote.assetType
    );
    if (quote.assetType === CAMPER && totalYear > SEVEN) {
        warningList.push({
            field: "assetType",
            message: `Asset age must be less than ${SEVEN} years. Refer BOQ`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 290 ~ validate ~ quote.assetType",
        quote.assetType
    );
    if (quote.assetType === MOTOR && totalYear > TEN) {
        warningList.push({
            field: "assetType",
            message: `Asset age must be less than ${TEN} years. Refer BOQ`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 301 ~ validate ~ quote.assetType",
        quote.assetType
    );
    if ((quote.assetType === MARINE || quote.assetType === CARAVANS) && totalYear > FIFTEEN) {
        warningList.push({
            field: "assetType",
            message: `Asset age must be less than ${FIFTEEN} years. Refer BOQ'`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 312 ~ validate ~ quote.assetCondition",
        quote.assetCondition
    );
    if (quote.assetCondition === USED) {
        if (quote.riskGrade === GOLD && get10PercentNAF > quote.deposit) {
            warningList.push({
                field: "deposit",
                message: `Deposit must be ${TEN}% of Asset Price.`
            });
        }
        if ((quote.riskGrade === PLAT_PLUS || quote.riskGrade === PLAT) && quote.deposit > 0) {
            warningList.push({
                field: "deposit",
                message: `It's not necessary a Deposit.`
            });
        }
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 331 ~ validate ~ quote.resiStatus",
        quote.resiStatus
    );
    if (quote.resiStatus !== OWNER && quote.riskGrade === PLAT_PLUS) {
        warningList.push({
            field: "resiStatus",
            message: `Only property owners can be Platinum Plus.`
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