import loadData from "@salesforce/apex/QuoteInsuranceController.loadData";
import calculateGAP from "@salesforce/apex/QuoteInsuranceController.calculateGAP";
import calculateLPI from "@salesforce/apex/QuoteInsuranceController.calculateLPI";
import calculateNWC from "@salesforce/apex/QuoteInsuranceController.calculateNWC";
import getPresentationStatus from "@salesforce/apex/QuoteInsuranceController.getPresentationStatus";
import { QuoteCommons } from "c/quoteCommons";
import { Validations } from "./quoteInsuranceFormValidation";

const RESET_FIELDS = [
  "mvRetailPrice",
  "mvProduct",
  "mvCommission",
  "mvPayment",
  "shortfallRetailPrice",
  "shortfallProduct",
  "shortfallCommission",
  "shortfallPayment",
  "shortfallTerm",
  "LPIRetailPrice",
  "LPIProduct",
  "LPICommission",
  "LPIPayment",
  "LPITerm",
  "warrantyRetailPrice",
  "warrantyProduct",
  "warrantyCommission",
  "warrantyPayment"
];
const QUOTING_FIELDS = new Map([
  ["price", "Vehicle_Price__c"],
  ["deposit", "Deposit__c"],
  ["netDeposit", "Net_Deposit__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["term", "Term__c"]
]);

const noneOption = [{ label: "-- None --", value: null }];

const getPBMOptions = () => {
  return [
    ...noneOption,
    { label: "Financed", value: "Financed" },
    { label: "PBM", value: "PBM" }
  ];
};

const getMVOptions = () => {
  return {
    typeOptions: [
      ...noneOption,
      { label: "Eric MV", value: "Eric MV" },
      { label: "Suncorp", value: "Suncorp" }
    ],
    productOptions: [
      ...noneOption,
      { label: "Comprehensive", value: "Comprehensive" }
    ]
  };
};

const getShortfallOptions = () => {
  return {
    typeOptions: [
      ...noneOption,
      { label: "Eric - Shortfall (EPI)", value: "Eric EPI" },
      { label: "Liberty - Shortfall (VEI)", value: "Liberty VEI" }
    ],
    productOptions: {
      Eric: [{ label: "(not applicable)", value: null }],
      Liberty: [
        ...noneOption,
        { label: "Option 1 $20K", value: "Option 1 $20K" },
        { label: "Option 2 $15K", value: "Option 2 $15K" },
        { label: "Option 3 $7.5K", value: "Option 3 $7.5K" }
      ]
    }
  };
};

const getLPIOptions = () => {
  return {
    typeOptions: [
      ...noneOption,
      {
        label: "Eric - Loan Protection (FPI)",
        value: "Eric FPI"
      },
      {
        label: "Liberty - Loan Protection (LFI)",
        value: "Liberty LFI"
      }
    ],
    productOptions: {
      Eric: [
        ...noneOption,
        { label: "Disability", value: "Disability" },
        { label: "Disability/Unemployment", value: "Disability/Unemployment" }
      ],
      Liberty: [
        ...noneOption,
        { label: "Disability Only", value: "Disability Only" },
        {
          label: "Disability & Unemployment",
          value: "Disability & Unemployment"
        }
      ]
    },
    termOptions: [
      ...noneOption,
      ...QuoteCommons.createTermOptions(12, 48).map((item) => {
        item.label = item.label.toString();
        item.value = item.value.toString();
        return item;
      })
    ]
  };
};

const getWarrantyOptions = () => {
  return {
    typeOptions: [
      ...noneOption,
      {
        label: "Eric Warranty",
        value: "Eric Warranty"
      },
      {
        label: "Integrity",
        value: "Integrity"
      }
    ],
    productOptions: {
      Eric: [
        ...noneOption,
        { label: "4 Star Plan A", value: "4 Star Plan A" },
        { label: "4 Star Plan B", value: "4 Star Plan B" },
        { label: "5 Star Plan A", value: "5 Star Plan A" },
        { label: "5 Star Plan B", value: "5 Star Plan B" }
      ],
      Integrity: {
        ProductType: {
          Car: [
            ...noneOption,
            { label: "Integrity Endurance", value: "Integrity Endurance" },
            { label: "Integrity Absolute", value: "Integrity Absolute" },
            { label: "Integrity", value: "Integrity" }
          ],
          Other: [...noneOption, { label: "Integrity", value: "Integrity" }]
        },
        Category: {
          Integrity: [
            ...noneOption,
            { label: "E", value: "E" },
            { label: "D", value: "D" },
            { label: "C", value: "C" },
            { label: "B", value: "B" },
            { label: "A", value: "A" }
          ],
          Endurance: [
            ...noneOption,
            { label: "Option 4 - $7K", value: "Option 4 - $7K" },
            { label: "Option 3 - $5K", value: "Option 3 - $5K" },
            { label: "Option 2 - $3K", value: "Option 2 - $3K" },
            { label: "Option 1 - $2K", value: "Option 1 - $2K" }
          ],
          Absolute: createAbsoluteOpts(4, 3)
        },
        Term: {
          Integrity: [
            ...noneOption,
            { label: "12", value: "12" },
            { label: "36", value: "36" },
            { label: "60", value: "60" }
          ],
          Endurance: [
            ...noneOption,
            { label: "12", value: "12" },
            { label: "36", value: "36" },
            { label: "60", value: "60" }
          ],
          Absolute: [
            ...noneOption,
            { label: "12", value: "12" },
            { label: "24", value: "24" },
            { label: "36", value: "36" },
            { label: "48", value: "48" },
            { label: "60", value: "60" }
          ]
        }
      }
    }
  };
};

const reset = () => {
  return QuoteCommons.resetInsurance();
};

/**
 * This function is only used for integrity absolute options only
 * @param {number} level
 * @param {number} value
 * @returns options
 */
const createAbsoluteOpts = (level, value) => {
  let opts = [...noneOption];
  for (let i = level; i > 0; i--) {
    for (let j = value; j > 0; j--) {
      opts.push({ label: `Level ${i} - (${j})`, value: `Level ${i} - (${j})` });
    }
  }
  return opts;
};

/**
 * calculate Shortfall/GAP fee
 * -- lee
 * @param {*} insuranceForm
 */
const calculatingGAP = ({ shortfallType, shortfallProduct }, oppId) =>
  new Promise((resolve, reject) => {
    if (
      shortfallType &&
      shortfallType.includes("Liberty") &&
      shortfallProduct
    ) {
      console.log(shortfallProduct);
      calculateGAP({
        oppId: oppId,
        option: shortfallProduct
      })
        .then((data) => {
          resolve(data);
        })
        .catch((error) => {
          reject(error);
        });
    }
  });

const gettingPresentationStatus = (appQuoteId) =>
  new Promise((resolve, reject) => {
    if (appQuoteId)
      getPresentationStatus({ appQuoteId: appQuoteId })
        .then((data) => {
          console.log("presentation status >> " + data);
          switch (data) {
            case "SENT":
              data = "Sent";
              break;
            case "DECI":
              data = "Deciding Product";
              break;
            case "DECL":
              data = "Declaring";
              break;
            case "SECO":
              data = "Selecting Comprehensive";
              break;
            case "FIIN":
              data = "Filling Health Information";
              break;
            case "FINI":
              data = "Finished";
              break;
            default:
              data = "None";
              break;
          }
          if (data) resolve(data);
        })
        .catch((error) => {
          console.error(error);
          reject(error);
        });
  });

/**
 * calculate LPI fee
 * -- lee
 * @param {*} insuranceForm
 * @param {*} quoteForm
 */
const calculatingLPI = (
  {
    LPIType,
    LPIProduct,
    LPITerm,
    warrantyRetailPrice,
    iswarrantyAccept,
    isIntegrityAccept
  },
  quoteForm
) =>
  new Promise((resolve, reject) => {
    console.log("LPITERM --> " + LPITerm);
    const term = LPITerm === "(Long Term)" ? quoteForm.term : LPITerm;
    if (LPIType && LPIType.includes("Liberty") && LPIProduct) {
      console.log(
        "calculating ... LPI >> ",
        QuoteCommons.mapLWCToSObject(
          quoteForm,
          quoteForm.oppId,
          null,
          QUOTING_FIELDS
        )
      );

      console.log("LPITERM --> " + term + "  type of term --> " + typeof term);
      calculateLPI({
        oppId: quoteForm.oppId,
        term: parseFloat(term),
        cciLevel: LPIProduct,
        data: QuoteCommons.mapLWCToSObject(
          quoteForm,
          quoteForm.oppId,
          null,
          QUOTING_FIELDS
        ).data,
        warrantyRetailPrice: warrantyRetailPrice,
        iswarrantyAccept: iswarrantyAccept || isIntegrityAccept
      })
        .then((data) => {
          resolve(data);
        })
        .catch((error) => {
          reject(error);
        });
    }
  });

/**
 * calculate NWC
 * -- lee
 * @param {*} insuranceForm
 * @param {*} quoteForm
 */
const calculatingNWC = ({ integrity }, quoteForm) =>
  new Promise((resolve, reject) => {
    if (integrity.type && integrity.term && integrity.category) {
      console.log(
        "calculating ... NWC >> ",
        QuoteCommons.mapLWCToSObject(
          quoteForm,
          quoteForm.oppId,
          null,
          QUOTING_FIELDS
        )
      );

      calculateNWC({
        category: integrity.category,
        term: integrity.term,
        type: integrity.type,
        data: QuoteCommons.mapLWCToSObject(
          quoteForm,
          quoteForm.oppId,
          null,
          QUOTING_FIELDS
        ).data
      })
        .then((data) => {
          resolve(data);
        })
        .catch((error) => {
          reject(error);
        });
    }
  });

// loading the type of asset
const load = (oppId) =>
  new Promise((resolve, reject) => {
    if (oppId) {
      try {
        loadData({ oppId: oppId })
          .then((data) => {
            console.log("data >> ", JSON.stringify(data, null, 2));
            if (data) resolve(data);
          })
          .catch((error) => {
            reject(error);
          });
      } catch (error) {
        console.error(error);
      }
    }
  });

const sendPresentation = (insuranceForm, quoteForm) =>
  new Promise((resolve, reject) => {
    let messages = QuoteCommons.resetMessage();
    messages = { ...Validations.validate(insuranceForm, quoteForm) };
    // console.log("insurance form >> ", JSON.stringify(insuranceForm, null, 2));
    // console.log("quote form >> ", JSON.stringify(quoteForm, null, 2));
    console.log(
      "mapping quote form >>",
      JSON.stringify(
        QuoteCommons.mapLWCToSObject(
          insuranceForm,
          null,
          null,
          QuoteCommons.INSURANCE_FIELDS
        ),
        null,
        2
      )
    );
    if (messages.errors.length > 0) {
      console.log("error messages >> ", messages);
      reject(messages);
    } else {
      resolve(messages);
    }
  });

// reset insurance form when press [Send Presentation] button
const resetInsuranceAccept = (insuranceForm) => {
  insuranceForm.isLPIAccept = false;
  insuranceForm.ismvAccept = false;
  insuranceForm.isshortfallAccept = false;
  insuranceForm.iswarrantyAccept = false;
  insuranceForm.isIntegrityAccept = false;
  insuranceForm.isLPIDecline = false;
  insuranceForm.ismvDecline = false;
  insuranceForm.isshortfallDecline = false;
  insuranceForm.iswarrantyDecline = false;
  insuranceForm.isIntegrityDecline = false;
  return insuranceForm;
};

export const InsuranceHelper = {
  RESET_FIELDS: RESET_FIELDS,
  getMVOptions: getMVOptions,
  noneOption: noneOption,
  getShortfallOptions: getShortfallOptions,
  getLPIOptions: getLPIOptions,
  getWarrantyOptions: getWarrantyOptions,
  getPBMOptions: getPBMOptions,
  reset: reset,
  calculateGAP: calculatingGAP,
  calculatingLPI: calculatingLPI,
  calculatingNWC: calculatingNWC,
  load: load,
  gettingPresentationStatus: gettingPresentationStatus,
  sendPresentation: sendPresentation,
  resetInsuranceAccept: resetInsuranceAccept
};