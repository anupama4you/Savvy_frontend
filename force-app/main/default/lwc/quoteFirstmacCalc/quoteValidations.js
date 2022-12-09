import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteFirstmacCalcHelper";
// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} messages - old messages object
 * @param {Object} naf - total naf
 * @returns
 */
const validate = (quote, naf, messages) => {

  const r =
    typeof messages == "undefined" || messages == null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

  const baseRate = quote["baseRate"];
  const maxRate = quote["maxRate"];
  console.log('quote: ', JSON.stringify(quote, null, 2));

  if (quote.price === null || quote.price === 0.0) {
    errorList.push({
      field: "price",
      message: "Car Price cannot be Zero."
    });
  }

  if (quote.applicationFee === null || quote.applicationFee === 0.0) {
    errorList.push({
      field: "applicationFee",
      message: "Application Fee cannot be Zero."
    });
  }

  if (quote.dof === null || quote.dof === 0.0) {
    errorList.push({
      field: "dof",
      message: "DOF cannot be Zero."
    });
  }

  if (quote.term === null || quote.term === 0.0) {
    errorList.push({
      field: "term",
      message: "Please choose an appropriate term."
    });
  }

  if (quote.clientRate === null || quote.clientRate === 0.0) {
    errorList.push({
      field: "clientRate",
      message: "Client rate cannot be Zero."
    });
  } else if (quote.clientRate < baseRate) {
    errorList.push({
      field: "clientRate",
      message: `Client rate should not be below of base rate: ${baseRate}.`
    });
  } else if (quote.clientRate > maxRate && baseRate > 0.0) {
    errorList.push({
      field: "clientRate",
      message: `Client rate should not be above of max rate: ${maxRate}.`
    });
  }

  if (naf < 5000) {
    errorList.push({
      message: "Min NAF should be $5,000."
    });
  }

  if (quote.category === null) {
    errorList.push({
      field: "category",
      message: "Please select an option for category."
    });
  }

  if (quote.loanTypeRD === null) {
    errorList.push({
      field: "loanTypeRD",
      message: "Please select an option for Loan Type (Rate Detail)."
    });
  }

  if (quote.residual < 0) {
    errorList.push({
      field: "residual",
      message: "Residual value should be greater than or equal to zero."
    });
  } else {
    if (quote.interestType === null) {
      errorList.push({
        field: "interestType",
        message: "Please select an option for Interest Type."
      });
    } else if (quote.interestType === 'Variable' && quote.residual > 0) {
      errorList.push({
        message: "Balloon payments not available on variable rate loans."
      });
    }
  }

  if (quote.vehicleYear === null) {
    errorList.push({
      field: "vehicleYear",
      message: "Please select an option for Vehicle Year."
    });
  }

  let vy = quote.vehicleYear !== null ? quote.vehicleYear : 0;
  let cy = (new Date()).getFullYear();
  let va = cy - vy;

  if (quote.residual > 0 && vy > 0 && quote.interestType === 'Fixed') {
    let resPer = quote.residual / quote.price * 100.0;
    let comp = 0.0;

    let isNewUsed = false;
    if (vy === cy || vy === cy - 1) {
      isNewUsed = true;
    }

    if (
      quote.loanTypeRD === 'New Green Car' ||
      quote.loanTypeRD === 'New / Demo'
    ) {

      if (quote.term === 36) {
        comp = 50.0;
      } else if (quote.term === 48) {
        comp = 40.0;
      } else {
        comp = 30.0;
      }
    } else if (
      (quote.loanTypeRD === 'Used < 3 years' ||
        quote.loanTypeRD === 'Used 4 - 5 years')
      && va <= 4
    ) {
      if (quote.term === 36) {
        comp = 40.0;
      } else if (quote.term === 48) {
        comp = 30.0;
      } else {
        comp = 20.0;
      }
    } else {
      warningList.push({
        message: "Maximum balloon is only available for cars less than 4 years."
      });
    }
    if (resPer > comp && comp > 0) {
      comp = quote.price * comp / 100.0;
      errorList.push({
        field: "residual",
        message: `Maximum balloon or residual value should be $${comp}.`
      });
    }

  }

  if (quote.category === 'Edge' && quote.loanTypeRD === 'Used 8-12 years') {
    errorList.push({
      message: "Edge maximum age is 7 years."
    });
  }

  if (quote.category === 'Edge' && quote.vehicleYear !== null && va > 7) {
    errorList.push({
      message: "Edge maximum age is 7 years."
    });
  }

  if (va <= 7 && naf > 100000) {
    errorList.push({
      message: "$100,000 maximum NAF for Cars <= 7 years. Max NAF exceeded for age of car."
    });
  }

  if (va > 7 && naf > 50000) {
    errorList.push({
      message: "$50,000 maximum NAF for Cars +8 years. Max NAF exceeded for age of car."
    });
  }

  let ty = quote.term > 0 ? quote.term / 12 : 0;
  if ((va + ty) > 15) {
    warningList.push({
      message: "The maximum age of car at term end is 15 years."
    });
  }

  if ((quote.loanTypeRD === 'New Green Car' ||
    quote.loanTypeRD === 'New / Demo') && va >= 1) {
    errorList.push({
      message: `${quote.loanTypeRD} only available on ${cy} model cars.`
    });
  } else if (
    quote.loanTypeRD === 'Used < 3 years' &&
    va > 3
  ) {
    let yearMinusFive = cy - 3;
    errorList.push({
      message: `Vehicle Year for ${quote.loanTypeRD} should be between ${yearMinusFive} and ${cy}.`
    });
  } else if (
    quote.loanTypeRD === 'Used 4-5 years' &&
    (va < 4 || va > 5)
  ) {
    let yearMinusFive = cy - 5;
    errorList.push({
      message: `Vehicle Year for ${quote.loanTypeRD} should be between ${yearMinusFive} and ${cy}.`
    });
  } else if (
    quote.loanTypeRD === 'Used 6-7 years' &&
    (va < 6 || va > 7)
  ) {
    let yearMinusSeven = cy - 7;
    let yearMinusSix = cy - 6;
    errorList.push({
      message: `Vehicle Year for ${quote.loanTypeRD} should be between ${yearMinusSeven} and ${yearMinusSix}.`
    });
  } else if (
    quote.loanTypeRD === 'Used 8-12 years' &&
    (va < 8 || va > 12) &&
    quote.category === 'Standard'
  ) {
    let yearMinusTwelve = cy - 12;
    let yearMinusEight = cy - 8;
    errorList.push({
      message: `Vehicle Year for ${quote.loanTypeRD} should be between ${yearMinusTwelve} and ${yearMinusEight}.`
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

const validateSaving = (quote, saveType) => {
  const r = {};
  const confirmList = [];
  const infoList = [];
  const warningList = [];
  const errorList = [];
  const { insurance: { warrantyRetailPrice: warranty, iswarrantyAccept: wtAccpet }, } = quote;
  const pld = CalHelper.getPiceLessDeposit(quote);
  console.log('pld: ->->-> ', pld);
  const PRODUCT_UPDATES = ["pre_approval", "pre_approval_amendment", "formal_approval",];

  confirmList.push({
    field: "confirms",
    message: "Calculation saved successfully."
  });

  if (PRODUCT_UPDATES.includes(saveType)) {
    confirmList.push({
      field: "confirms",
      message: "Product updated successfully."
    });
  }

  if (wtAccpet && "formal_approval" === saveType && warranty > pld * 0.1) {
    warningList.push({
      field: "warranty",
      message: "Warranty can be max 10% of the car price"
    });
  }

  r.confirms = confirmList;
  r.infos = infoList;
  r.warnings = warningList;
  r.errors = errorList;
  return r;
};

const Validations = {
  validate: validate,
  validatePostCalculation: validatePostCalculation,
  validateSaving: validateSaving
};

export { Validations };