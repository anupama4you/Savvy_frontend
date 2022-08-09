import { QuoteCommons } from "c/quoteCommons";

/**
 * @param {Object} quote - quote form OR commissions result
 * @param {Object} messages - old messages object
 * @returns
 */
const validate = (quote, messages) => {
  console.log(messages);
  const r =
    typeof messages == "undefined" || messages == null
      ? QuoteCommons.resetMessage()
      : messages;
  let errorList = r.errors;
  let warningList = r.warnings;

  for (const fieldName in quote) {
    const element = quote[fieldName];
    switch (fieldName) {
      // case "loanType":
      //   break;
      // case "loanProduct":
      //   break;
      case "price":
        if (element <= 0 || element === null)
          errorList.push({
            field: "price",
            message: "Loan Amount cannot be ZERO"
          });
        break;
      case "dof":
        if (element <= 0 || element === null)
          errorList.push({
            field: "dof",
            message: "DOF  cannot be ZERO"
          });
        break;
      case "applicationFee":
        if (element <= 0 || element === null)
          errorList.push({
            field: "applicationFee",
            message: "Application Fee cannot be ZERO"
          });
        break;
      // case "residual":
      //   if (element < 0 || element === null)
      //     errorList.push({
      //       field: "residual",
      //       message: "Residual must be a POSITIVE number and cannot be ZERO"
      //     });
      //   break;
      // case "monthlyFee":
      //   if (element < 0 || element === null)
      //     errorList.push({
      //       field: "monthlyFee",
      //       message: "Monthly Fee must be a POSITIVE number and cannot be ZERO"
      //     });
      //   break;
      case "clientRate":
        if (element <= 0 || element === null)
          errorList.push({
            field: "clientRate",
            message: "Client Rate must be a POSITIVE number and cannot be ZERO"
          });
        break;
      case "loanPurpose":
        console.log(
          `loanPurpose is : ${element}, the type is : ${typeof element}`
        );
        if (element == "" || element === null || element.length === 0) {
          warningList.push({
            field: "loanPurpose",
            message: "The Loan Purpose is neccessary for any approval"
          });
        }
        break;
      default:
        break;
    }
  }
  r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
  r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
  return r;
};

const Validations = {
  validate: validate
};

export { Validations };