import calculateGAP from "@salesforce/apex/QuoteInsuranceController.calculateGAP";
import { QuoteCommons } from "c/quoteCommons";

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
  "shortfallPBM",
  "LPIRetailPrice",
  "LPIProduct",
  "LPICommission",
  "LPIPayment",
  "LPITerm",
  "LPIPBM"
];

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
      { label: "Eric - Shortfall (EPI)", value: "Eric - Shortfall (EPI)" },
      { label: "Liberty - Shortfall (VEI)", value: "Liberty - Shortfall (VEI)" }
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
        value: "Eric - Loan Protection (FPI)"
      },
      {
        label: "Liberty - Loan Protection (LFI)",
        value: "Liberty - Loan Protection (LFI)"
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
        ProductType: [
          ...noneOption,
          { label: "Integrity", value: "integrity" }
        ],
        Category: [
          ...noneOption,
          { label: "E", value: "E" },
          { label: "D", value: "D" },
          { label: "C", value: "C" },
          { label: "B", value: "B" },
          { label: "A", value: "A" }
        ],
        Term: [
          ...noneOption,
          { label: "12", value: "12" },
          { label: "36", value: "36" },
          { label: "60", value: "60" }
        ]
      }
    }
  };
};

const reset = () => {
  return {
    mvType: null,
    mvProduct: null,
    mvRetailPrice: null,
    mvCommission: null,
    mvPayment: null,
    mvTerm: "12",
    mvPBM: "PBM",
    shortfallType: null,
    shortfallProduct: null,
    shortfallRetailPrice: null,
    shortfallCommission: null,
    shortfallPayment: null,
    shortfallTerm: "12",
    shortfallPBM: null,
    LPIType: null,
    LPIProduct: null,
    LPIRetailPrice: null,
    LPICommission: null,
    LPIPayment: null,
    LPITerm: null,
    LPIPBM: null,
    warrantyType: null,
    warrantyProduct: null,
    warrantyRetailPrice: null,
    warrantyCommission: null,
    warrantyPayment: null,
    warrantyTerm: "12",
    warrantyPBM: null
  };
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

/**
 * calculation of payment
 * -- lee
 * @param {Number} premium - Retail Price
 * @param {String} term - term (should parse to integer)
 * @param {String} payType - Financed/PBM
 * @returns
 */
const getInsurancePayment = (premium, term, payType) => {
  try {
    let r = null;
    if (premium && term && payType && "PBM" === payType) {
      r = ((premium / parseInt(term)) * 12) / 52;
    }
    return r;
  } catch (error) {
    console.error(error);
  }
};

export const InsuranceHelper = {
  RESET_FIELDS: RESET_FIELDS,
  getMVOptions: getMVOptions,
  noneOption: noneOption,
  getShortfallOptions: getShortfallOptions,
  getLPIOptions: getLPIOptions,
  getWarrantyOptions: getWarrantyOptions,
  getInsurancePayment: getInsurancePayment,
  getPBMOptions: getPBMOptions,
  reset: reset,
  calculateGAP: calculatingGAP
};