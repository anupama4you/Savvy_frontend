import { FinancialUtilities } from "./financialUtilities";
// QuoteCommons for Quoting Tool Calculators

const COMMISSION_FIELDS = new Map([
  ["commission", "Commission_Estimation__c"],
  ["insurances", "Commission_Insurance_Income__c"],
  ["dof", "Commission_DOF__c"],
  ["totalCommissionGSTExc", "Commission_Total_GST_Exc__c"],
  ["totalCommissionGSTInc", "Commission_Total_GST_Inc__c"],
  ["rental", "Rental__c"],
  ["monthlyPayment", "Repayment_Monthly__c"],
  ["fortnightlyPayment", "Repayment_Fortnightly__c"],
  ["weeklyPayment", "Repayment_Weekly__c"],
  ["naf", "NAF__c"]
]);

const COMMISSION_CALCULATION_FIELDS = new Map([
  ["commission", "Estimated_Commission__c"],
  ["insurances", "Insurance_Income__c"],
  ["dof", "DOF__c"],
  ["totalCommissionGSTExc", "Total_Commission__c"],
  ["totalCommissionGSTInc", "Total_Commission_Gst__c"],
  ["rental", "Rental__c"],
  ["monthlyPayment", "Monthly_Payment__c"],
  ["fortnightlyPayment", "Fortnightly_Payment__c"],
  ["weeklyPayment", "Weekly_Payment__c"],
  ["naf", "NAF__c"]
]);

const INSURANCE_FIELDS = new Map([
  // SHORTFALL
  ["shortfallProduct", "Insurance_GAP_Type__c"],
  ["shortfallType", "Insurance_Shortfall_Options__c"],
  ["shortfallRetailPrice", "Insurance_GAP_Retail_Price__c"],
  ["shortfallPBM", "Insurance_GAP_PayType__c"],
  ["shortfallTerm", "Insurance_GAP_Term__c"],
  ["isshortfallAccept", "Insurance_GAP_Acceptance__c"],
  ["shortfallCommission", "Insurance_GAP_Income__c"],
  // LPI
  ["LPIProduct", "Insurance_AIC_Type__c"],
  ["LPIRetailPrice", "Insurance_AIC_Retail_Price__c"],
  ["LPICommission", "Insurance_AIC_Income__c"],
  ["isLPIAccept", "Insurance_AIC_Acceptance__c"],
  ["LPITerm", "Insurance_AIC_Term__c"],
  ["LPIPBM", "Insurance_AIC_PayType__c"],
  ["LPIType", "Insurance_LPI_Options__c"],
  // MV
  ["mvType", "Insurance_MV_Options__c"],
  ["mvProduct", "Insurance_MV_Type__c"],
  ["mvRetailPrice", "Insurance_MV_Retail_Price__c"],
  ["mvCommission", "Insurance_MV_Income__c"],
  ["ismvAccept", "Insurance_MV_Acceptance__c"],
  // INTEGRITY & WARRANTY
  ["warrantyType", "Insurance_Warranty_Options__c"],
  ["typeRetail", "Insurance_NWC_Is_Manually_Value__c"],
  // INTEGRITY
  ["integrity.warrantyRetailPrice", "Insurance_NWC_Retail_Price__c"],
  ["integrity.warrantyCommission", "Insurance_NWC_Income__c"],
  ["integrity.category", "Insurance_NWC_Plan__c"],
  ["integrity.term", "Insurance_NWC_Term__c"],
  ["integrity.type", "Insurance_NWC_TypeP__c"],
  ["warrantyPayment", "Insurance_NWC_Cost__c"],
  ["isIntegrityAccept", "Insurance_NWC_Acceptance__c"],
  ["integrity.warrantyPBM", "Insurance_NWC_PayType__c"],
  //  WARRANTY
  ["warrantyProduct", "Insurance_Warranty_Type__c"],
  ["warrantyRetailPrice", "Insurance_Warranty_Retail_Price__c"],
  ["warrantyCommission", "Insurance_Warranty_Income__c"],
  ["iswarrantyAccept", "Insurance_Warranty_Acceptance__c"],
  ["warrantyTerm", "Insurance_Warranty_Term__c"],
  ["warrantyPBM", "Insurance_Warranty_PayType__c"]
]);

const createTermOptions = (min, max) => {
  let r = [];
  for (let i = min; i <= max; ) {
    r.push({ label: i, value: i });
    i += 12;
  }
  return r;
};

const createNumberDESCOptions = (max, min) => {
  let r = [];
  for (let i = max; i > min; ) {
    r.push({ label: i, value: i });
    i -= 1;
  }
  return r;
};

const CommonOptions = {
  loanTypes: [
    { label: "Purchase", value: "Purchase" },
    { label: "Refinance", value: "Refinance" },
    { label: "Sale & Lease Back", value: "Sale & Lease Back" }
  ],
  consumerLoanProducts: [{ label: "Consumer Loan", value: "Consumer Loan" }],
  businessLoanProducts: [
    { label: "Chattel Mortgage-Full-Doc", value: "Chattel Mortgage-Full-Doc" },
    { label: "Chattel Mortgage-Low-Doc", value: "Chattel Mortgage-Low-Doc" },
    { label: "Car Lease-Full-Doc", value: "Car Lease-Full-Doc" },
    { label: "Car Lease-Low-Doc", value: "Car Lease-Low-Doc" }
  ],
  fullLoanProducts: [
    { label: "Consumer Loan", value: "Consumer Loan" },
    { label: "Chattel Mortgage-Full-Doc", value: "Chattel Mortgage-Full-Doc" },
    { label: "Chattel Mortgage-Low-Doc", value: "Chattel Mortgage-Low-Doc" },
    { label: "Car Lease-Full-Doc", value: "Car Lease-Full-Doc" },
    { label: "Car Lease-Low-Doc", value: "Car Lease-Low-Doc" }
  ],

  // fullLoanProducts: [...consumerLoanProducts, ...businessLoanProducts],

  paymentTypes: [
    { label: "Arrears", value: "Arrears" },
    { label: "Advance", value: "Advance" }
  ],
  yesNo: [
    { label: "Yes", value: "Y" },
    { label: "No", value: "N" }
  ],
  terms: createTermOptions,
  profiles: [
    { label: "Property Owner", value: "Property Owner" },
    { label: "Non Property Owner", value: "Non Property Owner" }
  ],
  clientTiers: [
    { label: "Tier 1", value: "Tier 1" },
    { label: "Tier 2", value: "Tier 2" },
    { label: "Tier 3", value: "Tier 3" }
  ],
  assetTypes: [
    { label: "Car", value: "Car" },
    { label: "Caravan", value: "Caravan" }
  ],
  vehicleConditions: [
    { label: "New", value: "New" },
    { label: "Demo", value: "Demo" },
    { label: "Used", value: "Used" }
  ],
  vehicleBuildDates: createNumberDESCOptions,
  apiUsers: [{ label: "Savvy Admin", value: "Savvy Admin" }]
};

const resetResults = () => {
  return {
    commission: 0.0,
    dof: 0.0,
    insurances: 0.0,
    totalCommissionGSTExc: 0.0,
    totalCommissionGSTInc: 0.0,
    naf: 0.0,
    rental: 0.0,
    monthlyPayment: 0.0,
    fortnightlyPayment: 0.0,
    weeklyPayment: 0.0,
    comprehensive: { monthly: 0, fortnightly: 0, weekly: 0, isMvAccept: false },
    calResults: []
  };
};

const mapSObjectToLwc = ({
  calcName,
  defaultData,
  quoteData,
  settingFields,
  quotingFields
}) => {
  try {
    // Default values
    let r = defaultData;
    // Default from Settings
    // console.log(`@@settings...`);
    settingFields.forEach((value, key, map) => {
      r[`${key}`] = quoteData.settings[`${value}`];
      // console.log(`{${key}: ${value}} | `, quoteData.settings[`${value}`]);
    });
    if (quoteData.data) {
      // Validate same calculator
      r["Id"] = quoteData.data["Id"];
      if (calcName === quoteData.data.Name) {
        // Set Finance Detail Values
        quotingFields.forEach((value, key, map) => {
          r[`${key}`] = quoteData.data[`${value}`];
          // console.log(`{${key}: ${value}} | `, quoteData.data[`${value}`]);
          if (typeof quoteData.data[`${value}`] == "undefined")
            r[`${key}`] = null;
        });
        // Set Commission Calculations
        COMMISSION_FIELDS.forEach((value, key, map) => {
          r.commissions[`${key}`] = quoteData.data[`${value}`];
        });
      }

      r.insurance = { ...resetInsurance() };
      // insurance fields mapping
      INSURANCE_FIELDS.forEach((value, key) => {
        // console.log(`{${key}: ${value}} | `, quoteData.data[`${value}`]);
        if (quoteData.data[`${value}`] && key) {
          if (
            quoteData.data[`${value}`] === "U" ||
            quoteData.data[`${value}`] === "A"
          ) {
            r.insurance[`${key}`] =
              quoteData.data[`${value}`] === "U" ? false : true;
          } else if (quoteData.data[`${value}`] === "D") {
            if (key.includes("warranty"))
              r.insurance["iswarrantyDecline"] = true;
            if (key.includes("mv")) r.insurance["ismvDecline"] = true;
            if (key.includes("LPI")) r.insurance["isLPIDecline"] = true;
            if (key.includes("shortfall"))
              r.insurance["isshortfallDecline"] = true;
            // if (key.includes("Integrity"))
            //   r.insurance["isIntegrityDecline"] = true;
          } else if (key.startsWith("integrity.")) {
            let k = key.slice(key.indexOf(".") + 1, key.length);
            if (
              key.includes("term") ||
              key.includes("type") ||
              key.includes("category")
            ) {
              r.insurance.integrity[`${k}`] = quoteData.data[`${value}`];
            } else {
              r.insurance[`${k}`] = quoteData.data[`${value}`];
            }
          } else {
            r.insurance[`${key}`] = quoteData.data[`${value}`];
          }
          r.insurance.typeRetail = quoteData.data[
            "Insurance_NWC_Is_Manually_Value__c"
          ]
            ? ["Yes"]
            : [];
          if (r.insurance.LPIType === "Liberty LFI") {
            r.insurance.LPITerm = "(Loan Term)";
          }
        }
      });
      // Insurance settings
      r.insurance.isOnlyPayByTheMonth =
        quoteData.settings &&
        quoteData.settings.InsPayTypeOptions__c === "OnlyPayByTheMonth";
      
      // Integrity acceptance
      if (
        quoteData.data.Insurance_Warranty_Options__c === "Integrity" &&
        quoteData.data.Insurance_NWC_Acceptance__c === "A"
      ) {
        r.insurance.iswarrantyAccept = true;
      }
    }
    if (quoteData.opp) {
      r[`opp`] = quoteData.opp;
    }
    return r;
  } catch (error) {
    console.error(error);
  }
};

const mapDataToLwc = (obj, data, DataFields, insurance) => {
  let r = obj;
  if (data && DataFields) {
    DataFields.forEach((value, key, map) => {
      r[`${key}`] = data[`${value}`];
      // console.log(`{${key}: ${value}} | `, data[`${value}`]);
    });
  }
  if (insurance) {
    r.comprehensive.weekly = insurance.mvRetailPrice / 52;
    r.comprehensive.fortnightly = insurance.mvRetailPrice / 26;
    r.comprehensive.monthly = insurance.mvRetailPrice / 12;
    r.comprehensive.isMvAccept = insurance.ismvAccept;
  }
  return r;
};

const mapCommissionSObjectToLwc = (data, insurance, results) => {
  let comms = mapDataToLwc(
    resetResults(),
    data,
    COMMISSION_CALCULATION_FIELDS,
    insurance
  );
  comms.calResults = results? results : [];
  return comms;
  // console.log("🚀 ~ file: QuoteCommons.js ~ line 107 ~ mapCommissionSObjectToLwc ~ data", JSON.stringify(data));
  // let r = resetResults();
  // if (data) {
  //   COMMISSION_CALCULATION_FIELDS.forEach((value, key, map) => {
  //     r[`${key}`] = data[`${value}`];
  //     console.log(`{${key}: ${value}} | `, data[`${value}`]);
  //   });
  // }
  // return r;
};

const VALIDATION_OPTIONS = {
  ERROR: "ERROR",
  WARNING: "WARNING",
  INFO: "INFO",
  CONFIRM: "CONFIRM"
};

const calcNetDeposit = (quote) => {
  let r = 0.0;
  if (quote) {
    r += quote.deposit > 0.0 ? quote.deposit : 0;
    r += quote.tradeIn > 0.0 ? quote.tradeIn : 0;
    r -= quote.payoutOn > 0.0 ? quote.payoutOn : 0;
  }
  return r;
};

const calcTotalAmount = (quote) => {
  let r = 0.0;
  if (quote) {
    r += quote.price > 0 ? quote.price : 0.0;
    r -= calcNetDeposit(quote);

    r += quote.applicationFee > 0 ? quote.applicationFee : 0.0;
    r += quote.dof > 0 ? quote.dof : 0.0;
    r += quote.ppsr > 0 ? quote.ppsr : 0.0;
  }
  return r;
};
// public static final String INS_PROD_GAP = 'GAP';
// public static final String INS_PROD_WARR = 'WRR';
// public static final String INS_PROD_NWC = 'NWC';
// public static final String INS_PROD_CCI = 'CCI';
// CALC_QUOTING = 'Q'
// implementing - lee
// calculate retail price field
const calcTotalInsuranceType = (quote, calcType = "Q") => {
  let r = 0.0;
  try {
    if (quote.insurance) {
      // focusing on CalculateType 'Q'
      switch (calcType) {
        case "Q":
          // shortfall
          if (
            quote.insurance.isshortfallAccept &&
            quote.insurance.shortfallPBM === "Financed"
          ) {
            r += parseFloat(
              quote.insurance.shortfallRetailPrice
                ? quote.insurance.shortfallRetailPrice
                : 0.0
            );
            console.log("shortfall >> ", r);
          }
          // warranty
          if (
            (quote.insurance.iswarrantyAccept &&
              quote.insurance.warrantyPBM === "Financed") ||
            quote.insurance.isIntegrityAccept
          ) {
            r += parseFloat(
              quote.insurance.warrantyRetailPrice
                ? quote.insurance.warrantyRetailPrice
                : 0.0
            );
            console.log("warranty >> ", r);
          }
          // LPI
          if (
            quote.insurance.isLPIAccept &&
            quote.insurance.LPIPBM === "Financed"
          ) {
            r += parseFloat(
              quote.insurance.LPIRetailPrice
                ? quote.insurance.LPIRetailPrice
                : 0.0
            );
            console.log("lpi >> ", r);
          }
          // mv
          if (
            quote.insurance.ismvAccept &&
            quote.insurance.mvPBM === "Financed"
          )
            r += parseFloat(
              quote.insurance.mvRetailPrice
                ? quote.insurance.mvRetailPrice
                : 0.0
            );
          break;
        case "GAP":
          break;
        case "WRR":
          break;
        case "NWC":
          break;
        case "CCI":
          break;
        default:
          break;
      }
    }

    return r;
  } catch (error) {
    console.error(error);
  }
};

// calculate commission part of Insurance
const calcTotalInsuranceIncome = (quote) => {
  let r = 0.0;
  try {
    // focusing on CalculateType 'Q'
    if (quote.insurance) {
      // shortfall
      if (quote.insurance.isshortfallAccept) {
        r += parseFloat(
          quote.insurance.shortfallCommission
            ? quote.insurance.shortfallCommission
            : 0.0
        );
      }
      // warranty
      if (quote.insurance.iswarrantyAccept)
        r += parseFloat(
          quote.insurance.warrantyCommission
            ? quote.insurance.warrantyCommission
            : 0.0
        );
      // LPI
      if (quote.insurance.isLPIAccept)
        r += parseFloat(
          quote.insurance.LPICommission ? quote.insurance.LPICommission : 0.0
        );
    }
    return r;
  } catch (error) {
    console.error(error);
  }
};

const calcNetRealtimeNaf = (quote) => {
  let r = calcTotalAmount(quote);
  r += calcTotalInsuranceType(quote, "Q");
  return r;
};

/** --- Lee
 * handle error message clear
 * @param {Object} obj - passing 'this' to the function, for getting template[this.template]
 */
const handleHasErrorClassClear = (obj) => {
  const inputFields = obj.template.querySelectorAll("lightning-input");
  const comboboxFields = obj.template.querySelectorAll("lightning-combobox");
  if (inputFields && comboboxFields) {
    console.log(
      `@@total: inputs -> ${inputFields.length} , combobox -> ${comboboxFields.length}`
    );
    comboboxFields.forEach((field) => {
      try {
        field.setCustomValidity(" ");
        field.reportValidity();
        field.classList.remove("slds-has-error");
      } catch (error) {
        console.error(error);
      }
    });
    inputFields.forEach((field) => {
      try {
        field.setCustomValidity(" ");
        field.reportValidity();
        field.classList.remove("slds-has-error");
      } catch (error) {
        console.error(error);
      }
    });
  }
};

/** --- Lee
 * reset Custom Validity to ''
 * Note: if setting the message to '', will reset the message
 * @param {Object} obj - passing 'this' to the function, for getting template[this.template]
 */
const resetValidateFields = (obj) => {
  const inputFields = obj.template.querySelectorAll("lightning-input");
  const comboboxFields = obj.template.querySelectorAll("lightning-combobox");
  if (inputFields && comboboxFields) {
    comboboxFields.forEach((field) => {
      field.setCustomValidity("");
    });
    inputFields.forEach((field) => {
      field.setCustomValidity("");
    });
  }
};

/**
 * -- Lee
 * @param {Object} obj - simple passing [this] to the function, for getting fields from instance
 * @param {Array} messages - list of message object
 */
const fieldErrorHandler = (obj, messages) => {
  let inputFields = [];
  for (const msg of messages) {
    const field = obj.template.querySelector(`[data-id="${msg.field}-field"]`);
    if (field) inputFields.push(field);
  }
  inputFields.forEach((field) => {
    field.setCustomValidity(" ");
    field.reportValidity();
    field.classList.add("slds-has-error");
  });
};

/**
 * -- Lee
 * @returns return an empty object for clearing the old one
 */
const resetMessage = () => {
  return {
    errors: [],
    warnings: [],
    confirms: [],
    infos: []
  };
};

/**
 * -- Lee
 * avoid duplicated element in array
 * @param {[]} array
 * @returns {[]}
 */
const uniqueArray = (array) => {
  return array.filter(
    (value, index, self) =>
      index ===
      self.findIndex(
        (t) => t.field === value.field && t.message === value.message
      )
  );
};

/**
 * -- lee
 * @param {Object} quoteForm - quote form DATA
 * @param {Id} oppId - record id
 * @param {String} LENDER_QUOTING - constant value for each calculator
 * @param {Map} QUOTE_FIELDS_MAPPING - mapping for translate lwc -> apex
 * @returns new Mapping Object for server
 */
const mapLWCToSObject = (
  quoteForm,
  oppId,
  LENDER_QUOTING,
  QUOTE_FIELDS_MAPPING
) => {
  const includeInsurance = quoteForm.insurance ? true : false;
  console.log("🚀 ~ file: quoteCommons.js ~ line 544 ~ includeInsurance", includeInsurance);
  const isIntegrity = quoteForm.insurance?.warrantyType === "Integrity";
  const INTEGRITY_FIELDS = [
    "warrantyRetailPrice",
    "warrantyCommission",
    "warrantyPBM",
    "warrantyTerm"
  ];
  // console.log("include insurance >> " + includeInsurance);
  let obj = includeInsurance
    ? { data: {}, results: { commissions: {} }, calcResults: [], insurance: {} }
    : { data: {}, results: { commissions: {} }, calcResults: [] };
  // data
  console.log(`@@mapLWCToSObject-quote form : ${JSON.stringify(quoteForm, null, 2)}`);
  const FULL_FIELDS_MAPPING = includeInsurance
    ? [...QUOTE_FIELDS_MAPPING, ...INSURANCE_FIELDS]
    : [...QUOTE_FIELDS_MAPPING];
  try {
    for (const [key, value] of FULL_FIELDS_MAPPING) {
      // include insurance
      if (includeInsurance) {
        // console.log(``);
        //  --- insurance part ---
        if (key === "typeRetail") continue;
        if ([...INSURANCE_FIELDS.keys()].includes(key)) {
          // obj.insurance[value] = quoteForm.insurance[key];
          // key inside the insurance fields
          if (isIntegrity && key.startsWith("integrity.")) {
            // if (key.startsWith("integrity.")) {
              let k = key.slice(key.indexOf(".") + 1, key.length);
              if (INTEGRITY_FIELDS.includes(k)) {
                obj.insurance[value] = quoteForm.insurance[`${k}`];
              } else {
                obj.insurance[value] = quoteForm.insurance["integrity"][`${k}`]; // >> type, term, category
              }
            // } else if (!INTEGRITY_FIELDS.includes(key)) {
            //   console.log("key >> " + key + " |  value >> " + value);
            //   obj.insurance[value] = quoteForm.insurance[key];
            // }
          } else {
            if (
              key === "LPITerm" &&
              quoteForm.insurance[key] === "(Loan Term)"
            ) {
              obj.insurance[value] = `${quoteForm["term"]}` + "";
            } else {
              obj.insurance[value] = quoteForm.insurance[key];
            }
          }
        } else {
          obj.data[value] = quoteForm[key];
        }
        // if (key === "LPITerm") {
        //   console.log(
        //     `@@LPITerm:`,
        //     quoteForm.insurance[key],
        //     quoteForm["term"],
        //     value
        //   );
        // }
        // if (key === "LPITerm" && quoteForm.insurance[key] === '(Loan Term)') {
        //   obj.data[value] = `${quoteForm["term"]}` + "";
        //   console.log(`🚀 ~ file: quoteCommons.js ~ line 597 ~ obj.data[${value}]`, obj.data[value]);
        // } else {
        //   obj.data[value] = quoteForm[key];
        // }

        console.log(
          `[${key}]`,
          value,
          `: `,
          obj.data[value]
        );
        

        // mv
        if (
          quoteForm.insurance["ismvAccept"] ||
          quoteForm.insurance["ismvDecline"]
        ) {
          obj.insurance["Insurance_MV_Acceptance__c"] = quoteForm.insurance[
            "ismvAccept"
          ]
            ? "A"
            : "D";
        } else {
          obj.insurance["Insurance_MV_Acceptance__c"] = "U";
        }
        // shortfall/GAP
        if (
          quoteForm.insurance["isshortfallAccept"] ||
          quoteForm.insurance["isshortfallDecline"]
        ) {
          obj.insurance["Insurance_GAP_Acceptance__c"] = quoteForm.insurance[
            "isshortfallAccept"
          ]
            ? "A"
            : "D";
        } else {
          obj.insurance["Insurance_GAP_Acceptance__c"] = "U";
        }
        // LPI/AIC
        if (
          quoteForm.insurance["isLPIAccept"] ||
          quoteForm.insurance["isLPIDecline"]
        ) {
          obj.insurance["Insurance_AIC_Acceptance__c"] = quoteForm.insurance[
            "isLPIAccept"
          ]
            ? "A"
            : "D";
        } else {
          obj.insurance["Insurance_AIC_Acceptance__c"] = "U";
        }
        // Warranty
        if (
          quoteForm.insurance["iswarrantyAccept"] ||
          quoteForm.insurance["iswarrantyDecline"]
        ) {
          obj.insurance["Insurance_Warranty_Acceptance__c"] = quoteForm
            .insurance["iswarrantyAccept"]
            ? "A"
            : "D";
        } else {
          obj.insurance["Insurance_Warranty_Acceptance__c"] = "U";
        }
        // Integrity
        if (
          quoteForm.insurance["isIntegrityAccept"] ||
          quoteForm.insurance["isIntegrityDecline"]
        ) {
          obj.insurance["Insurance_NWC_Acceptance__c"] = quoteForm.insurance[
            "isIntegrityAccept"
          ]
            ? "A"
            : "D";
        } else {
          obj.insurance["Insurance_NWC_Acceptance__c"] = "U";
        }

        //  --- insurance part : end ---
      } else {
        obj.data[value] = quoteForm[key];
      }
    }
    obj.data["Opportunity__c"] = oppId;
    obj.data["Name"] = LENDER_QUOTING;
    // commissions
    for (const [key, value] of COMMISSION_FIELDS) {
      // obj.results["commissions"][value] = quoteForm["commissions"][key];
      obj.data[value] = quoteForm["commissions"][key];
    }
    // Calc Results
    obj.calcResults = quoteForm.commissions.calResults;
  } catch (error) {
    console.error(error);
  }

  if (includeInsurance) {
    obj.data["Insurance_NWC_Is_Manually_Value__c"] =
      quoteForm.insurance["typeRetail"] &&
      quoteForm.insurance["typeRetail"].length > 0;

    // raw insurances
    obj.rawInsuranceParam = quoteForm.insurance;
  }
  obj.data = { ...obj.data, ...obj.insurance };

  console.log(`@@obj mapping : ${JSON.stringify(obj, null, 2)}`);
  return obj;
};

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

const resetInsurance = () => {
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
    warrantyPBM: null,
    integrity: {
      type: null,
      term: null,
      category: null
    },
    typeRetail: [],
    ismvAccept: false,
    // ismvDecline: false,
    isshortfallAccept: false,
    // isshortfallDecline: false,
    iswarrantyAccept: false,
    // iswarrantyDecline: false,
    isLPIAccept: false,
    // isLPIDecline: false,
    // isIntegrityAccept: false,
    // isIntegrityDecline: false
    isOnlyPayByTheMonth: false,
    lastAction: null
  };
};
/**
 * Lee - 14/09/2022
 * @param {object} quoteForm - quoteForm
 * @returns - commission with comprehensive part
 */
const handleComprehensive = (quoteForm) => {
  try {
    let cms = { ...quoteForm.commissions };
    cms.comprehensive.isMvAccept = quoteForm.insurance.ismvAccept;
    if (quoteForm.insurance.ismvAccept) {
      cms.comprehensive.weekly = quoteForm.insurance.mvRetailPrice / 52;
      cms.comprehensive.fortnightly = quoteForm.insurance.mvRetailPrice / 26;
      cms.comprehensive.monthly = quoteForm.insurance.mvRetailPrice / 12;
    } else {
      cms.comprehensive.weekly = 0;
      cms.comprehensive.fortnightly = 0;
      cms.comprehensive.monthly = 0;
    }
    return cms;
  } catch (error) {
    console.error(error);
  }
};

const calculateInsurances = (comp, fieldName, extraFields) => {
  console.log(
    "🚀 ~ file: quoteCommons.js ~ line 792 ~ calculateInsurances ~ calculateInsurances",
    calculateInsurances
  );
  if (comp) {
    let nafFields = [
      "price",
      "deposit",
      "tradeIn",
      "payoutOn",
      "applicationFee",
      "dof",
      "ppsr",
      "riskFee"
    ];
    if (extraFields && Array.isArray(extraFields) && extraFields.length > 0) {
      nafFields = [...nafFields, ...extraFields];
    }
    const ins = comp.template.querySelectorAll("c-quote-insurance-form");
    ins.forEach((a) => {
      a.isQuoteCalculated = false;
      if (nafFields.includes(fieldName)) {
        a.recalculateProducts();
      }
    });
    
  }
}

const QuoteCommons = {
  resetResults: resetResults,
  COMMISSION_FIELDS: COMMISSION_FIELDS,
  VALIDATION_OPTIONS: VALIDATION_OPTIONS,
  INSURANCE_FIELDS: INSURANCE_FIELDS,
  mapSObjectToLwc: mapSObjectToLwc,
  mapCommissionSObjectToLwc: mapCommissionSObjectToLwc,
  mapDataToLwc: mapDataToLwc,
  calcTotalAmount: calcTotalAmount,
  calcTotalInsuranceType: calcTotalInsuranceType,
  calcNetRealtimeNaf: calcNetRealtimeNaf,
  calcNetDeposit: calcNetDeposit,
  handleHasErrorClassClear: handleHasErrorClassClear,
  resetValidateFields: resetValidateFields,
  fieldErrorHandler: fieldErrorHandler,
  resetMessage: resetMessage,
  uniqueArray: uniqueArray,
  mapLWCToSObject: mapLWCToSObject,
  createTermOptions: createTermOptions,
  calcTotalInsuranceIncome: calcTotalInsuranceIncome,
  getInsurancePayment: getInsurancePayment,
  resetInsurance: resetInsurance,
  handleComprehensive: handleComprehensive,
  calculateInsurances: calculateInsurances
};

export { QuoteCommons, CommonOptions, FinancialUtilities, VALIDATION_OPTIONS };