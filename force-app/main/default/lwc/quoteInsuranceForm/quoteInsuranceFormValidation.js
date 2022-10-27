import { QuoteCommons } from "c/quoteCommons";

/**
 *
 * @param {Object} insurance - insurance form
 * @param {Object} quote - quote form
 * @param {Object} messages - message object
 * @returns {Object} messages
 */
const validate = (insurance, quote) => {
  try {
    const r = QuoteCommons.resetMessage();
    let errorList = r.errors;
    let warningList = r.warnings;
    // if (!("applicationId" in quote)) {
    //   errorList.push({
    //     field: "insurance",
    //     message:
    //       "Insurance: Please create an Application before creating a Quote."
    //   });
    // }
    for (const fieldName in quote) {
      const element = quote[fieldName];
      switch (fieldName) {
        // case "loanType":
        //   break;
        // case "loanProduct":
        //   break;
        default:
          break;
      }
    }

    let hasProducts = false;
    for (const fieldName in insurance) {
      const element = insurance[fieldName];
      switch (fieldName) {
        case "mvType":
          if (element && element.length > 0) {
            hasProducts = true;
            if (
              !insurance.mvProduct ||
              !insurance.mvRetailPrice ||
              !insurance.mvCommission
            ) {
              errorList.push({
                field: "mv",
                message: `${element}, Please complete the Product, Retail Price and Commission fields.`
              });
            }
          }
          break;
        case "shortfallType":
          if (element && element.length > 0) {
            hasProducts = true;
            if (
              (!element.includes("Eric") && !insurance.shortfallProduct) ||
              !insurance.shortfallRetailPrice ||
              !insurance.shortfallCommission ||
              !insurance.shortfallPBM
            ) {
              errorList.push({
                field: "shortfall",
                message: `${element},  Please complete the Product, Retail Price, Commission fields and Financed/PBM.`
              });
            }
          }
          break;
        case "LPIType":
          if (element && element.length > 0) {
            hasProducts = true;
            if (
              !insurance.LPIProduct ||
              !insurance.LPIRetailPrice ||
              !insurance.LPICommission ||
              !insurance.LPIPBM
            ) {
              errorList.push({
                field: "LPI",
                message: `${element},  Please complete the Product, Retail Price, Commission fields and Financed/PBM.`
              });
            }

            if (element.includes("Eric")) {
              if (!insurance.LPITerm) {
                errorList.push({
                  field: "LPI",
                  message: `${element},  Please select a term.`
                });
              }
              // if (!insurance.LPIPBM) {
              //   errorList.push({
              //     field: "LPI",
              //     message: `${element},  Please select either Financed or PBM.`
              //   });
              // }
            }
          }
          break;

        case "warrantyType":
          if (element && element.length > 0) {
            hasProducts = true;
            if (element === "Integrity") {
              console.log("warranty type >>", element);
              if (!insurance.integrity.term) {
                console.log("warranty type >>", element);
                errorList.push({
                  field: "warranty",
                  message: `${element},  Please select a term.`
                });
              }
              if (
                element &&
                (
                  !insurance.integrity.type ||
                  !insurance.integrity.category ||
                  !insurance.warrantyPBM
                )
              ) {
                errorList.push({
                  field: "warranty",
                  message: `${element},  Please complete the Product, Retail Price, Commission and Financed/PBM fields.`
                });
              }
            } else {
              if (
                !insurance.warrantyProduct ||
                !insurance.warrantyRetailPrice ||
                !insurance.warrantyCommission ||
                !insurance.warrantyPBM
              ) {
                errorList.push({
                  field: "warranty",
                  message: `${element},  Please complete the Product, Retail Price, Commission and Financed/PBM fields.`
                });
              }
            }
          }
          break;

        default:
          break;
      }
    }

    if (!hasProducts) {
      errorList.push({
        field: "",
        message: `Please choose what Insurance Products are going to be presented.`
      });
    }

    r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
    r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
    console.log("r", r);
    return r;
  } catch (error) {
    console.error(error);
  }
};

const Validations = {
  validate: validate
};

export { Validations };