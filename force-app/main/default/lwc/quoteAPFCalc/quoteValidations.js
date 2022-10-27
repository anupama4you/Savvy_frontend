import { QuoteCommons } from "c/quoteCommons";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
    const {
        price, customerGrading, applicationFee, maxApplicationFee,
        clientRate, term, baseRate, assetAge, privateSales,
        propOwner, brokeragePercentage, residualValue, maxBrokerage
    } = quote;

    const CENTRE_LINK = "Centrelink only";
    const STANDARD_PAYG = "Standard PAYG";


    const r =
        typeof messages == "undefined" || messages == null
            ? QuoteCommons.resetMessage()
            : messages;
    let errorList = r.errors;
    let warningList = r.warnings;

    const naf = CalHelper.getNetRealtimeNaf(quote);
    console.log('naf: ', naf);

    // const baseRate = quote["baseRate"];
    // const maxRate = quote["maxRate"];



    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.price",
        quote.price
    );
    if (price === null || price === 0) {
        errorList.push({
            field: "price",
            message: "Car Price cannot be Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.customerGrading",
        quote.customerGrading
    );
    if (customerGrading === null) {
        errorList.push({
            field: "customerGrading",
            message: "Customer Grading should be selected."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.applicationFee",
        quote.applicationFee
    );
    if (applicationFee === null || applicationFee === 0) {
        errorList.push({
            field: "applicationFee",
            message: "Application Fee cannot be Zero."
        });
    }
    if (applicationFee > maxApplicationFee) {
        errorList.push({
            field: "applicationFee",
            message: "Max Application Fee exceed."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.dof",
        quote.dof
    );
    if (dof === null || dof === 0) {
        errorList.push({
            field: "dof",
            message: "DOF cannot be Zero."
        });
    }
    if (dof > maxDof) {
        errorList.push({
            field: "dof",
            message: "Max. DOF exceed."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.clientRate",
        quote.clientRate
    );
    if (clientRate === null || clientRate === 0) {
        errorList.push({
            field: "clientRate",
            message: "Customer Grading should be selected."
        });
    }
    // if (clientRate > Default_Base_Rate__c ) {
    //     errorList.push({
    //         field: "clientRate",
    //         message: "Customer Grading should be selected."
    //     });
    // }


    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.loanTypeDetail",
        quote.loanTypeDetail
    );
    if (loanTypeDetail === CENTRE_LINK && naf > MAX_NAF_CENTRE_LINK) {
        warningList.push({
            field: "loanTypeDetail",
            message: `Max $${MAX_NAF_CENTRE_LINK} Plus fees and add ons for centrelink only`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.loanTypeDetail",
        quote.loanTypeDetail
    );
    if (loanTypeDetail === STANDARD_PAYG && naf > MAX_NAF_STAND_PAYG) {
        warningList.push({
            field: "loanTypeDetail",
            message: `Max $${MAX_NAF_STAND_PAYG} Plus fees and add ons`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 17 ~ validate ~ quote.price",
        quote.price
    );
    if (naf > MIN_NAF) {
        warningList.push({
            field: "price",
            message: `Minimum loan amount is $${MIN_NAF}`
        });
    }


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
    // } else if (quote.applicationFee === null || quote.applicationFee === 0) {
    //     warningList.push({
    //         field: "applicationFee",
    //         message: `Application Fee is not updated as the calculator does not contain relevant info.`
    //     });
    // } else if (quote.ppsr === null || quote.ppsr === 0) {
    //     warningList.push({
    //         field: "ppsr",
    //         message: `PPSR is not updated as the calculator does not contain relevant info.`
    //     });
    // }

    // if (
    //     quote.clientTier === "C" &&
    //     quote.opp &&
    //     quote.opp.ApplicationServicing__r &&
    //     quote.opp.ApplicationServicing__r.Is_Splitting_Expenses__c === true
    // ) {
    //     warningList.push({
    //         field: "clientTier",
    //         message: `Pepper cannot split expenses with Tier C`
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