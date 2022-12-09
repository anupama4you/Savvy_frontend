import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteRacvCalcHelper"; // this line commented by nk

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages, isApproval) => {
    const r =
        typeof messages == "undefined" || messages == null ?
        QuoteCommons.resetMessage() :
        messages;
    let errorList = r.errors;
    let warningList = r.warnings;

    console.log(`@@validation:`, JSON.stringify(quote, null, 2));

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 24 ~ validate ~ quote.vehCon",
        quote.vehCon
    );
    if (!quote.vehCon) {
        errorList.push({
            field: "vehCon",
            message: "Please select Vehicle Condition."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 35 ~ validate ~ quote.price",
        quote.price
    );
    if (quote.price === null || quote.price === 0) {
        errorList.push({
            field: "price",
            message: "Vehicle Price cannot be Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 46 ~ validate ~ quote.applicationFee",
        quote.applicationFee
    );
    if (quote.applicationFee === null || quote.applicationFee === 0) {
        errorList.push({
            field: "applicationFee",
            message: "Application Fee cannot be Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 57 ~ validate ~ quote.dof",
        quote.dof
    );
    if (quote.dof === null || quote.dof === 0) {
        errorList.push({
            field: "dof",
            message: "DOF should not be Zero."
        });
    } else if (quote.dof > quote.maxDof) {
        errorList.push({
            field: "DOF",
            message: `Max DOF exceeded: ${quote.maxDof === null? 0: quote.maxDof }`
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 73 ~ validate ~ quote.ppsr",
        quote.ppsr
    );
    if (quote.ppsr === null || quote.ppsr == 0.0) {
        errorList.push({
            field: "ppsr",
            message: "PPSR should not be Zero."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 84 ~ validate ~ quote.clientRate",
        quote.clientRate
    );
    if (quote.clientRate === null || quote.clientRate == 0.0) {
        errorList.push({
            field: "clientRate",
            message: "Client Rate should not be zero."
        });
    } 

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 100 ~ validate ~ quote.term",
        quote.term
    );
    if ('MOTORBIKE' === quote.vehicleType) {
        if (quote.term > 60) {
            errorList.push({
                field: "term",
                message: `Motorbikes max. term is 5 years.`
            });
        }

    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 111 ~ validate ~ quote.residualValue",
        quote.residualValue
    );
    if (quote.residualValue > 0 && quote.term > 60) {
        errorList.push({
            field: "residualValue",
            message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
        });
    }

    console.log(
        "🚀 ~ file: quoteValidations.js ~ line 122 ~ validate ~ quote.vehicleType",
        quote.vehicleType
    );
    if (!quote.vehicleType) {
        errorList.push({
            field: "vehicleType",
            message: "Please select Vehicle Type."
        });
    }

    let years = parseFloat(quote.term) / 12;
    const vehicleAge = parseFloat(quote.carAge) + years;

    // Vehicle age
    if ((quote.vehicleType === 'CAR/CARAVAN<3YRS' || quote.vehicleType === 'CAR/CARAVAN>3YRS') && vehicleAge > 20) {
        warningList.push({
            field: "vehicleAge",
            message: "Car exceeds maximum of 20 years at term end."
        });
    }

    // loan amount
    const purchasePrice = quote.price - quote.netDeposit;
    // Borrower Type
    if (quote.loanTypeDetail === "Borrower Type 3") {
        if (purchasePrice > 40000) {
            warningList.push({
                field: "price",
                message: " Maximum loan $40,000."
            });
        }
        warningList.push({
            field: "",
            message: "Cannot split Living expenses or Fixed liabilities"
        });
        warningList.push({
            field: "",
            message: "maximum 50% of annual income for first time lends"
        });
        warningList.push({
            field: "",
            message: "Bank statements required upfront"
        });
    } else if (quote.loanTypeDetail === "Borrower Type 2") {
        if (purchasePrice > 80000) {
            warningList.push({
                field: "price",
                message: "Maximum loan $80,000"
            });
        }
        warningList.push({
            field: "",
            message: "LVR guide around 110%"
        });
        warningList.push({
            field: "",
            message: " maximum 50% of annual income for first time lends"
        });
    } else if (quote.loanTypeDetail === "Borrower Type 1") {
        warningList.push({
            field: "",
            message: "LVR guide around 120%"
        });
    }
   
    r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
    r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
    return r;
};

const validatePostCalculation = (quote, messages) => {
    const r =
        typeof messages == "undefined" || messages == null ?
        QuoteCommons.resetMessage() :
        messages;
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