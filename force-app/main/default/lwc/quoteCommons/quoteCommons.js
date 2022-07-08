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

const createTermOptions = (min, max) => {
  let r = [];
  for (let i = min; i < max; ) {
    r.push({ label: i, value: i });
    i += 12;
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
  terms: createTermOptions
};

const resetResults = () => {
  return {
    commission: null,
    dof: null,
    insurances: null,
    totalCommissionGSTExc: null,
    totalCommissionGSTInc: null,
    naf: null,
    rental: null,
    monthlyPayment: null,
    fortnightlyPayment: null,
    weeklyPayment: null
  };
};

const mapSObjectToLwc = ({
  calcName,
  defaultData,
  quoteData,
  settingFields,
  quotingFields
}) => {
  // Default values
  let r = defaultData;
  // Default from Settings
  console.log(`@@settings...`);
  settingFields.forEach((value, key, map) => {
    r[`${key}`] = quoteData.settings[`${value}`];
    console.log(`{${key}: ${value}} | `, quoteData.settings[`${value}`]);
  });
  if (quoteData.data) {
    // Validate same calculator
    if (calcName === quoteData.data.Name) {
      r["Id"] = quoteData.data["Id"];
      // Set Finance Detail Values
      quotingFields.forEach((value, key, map) => {
        r[`${key}`] = quoteData.data[`${value}`];
        console.log(`{${key}: ${value}} | `, quoteData.data[`${value}`]);
        if (typeof quoteData.data[`${value}`] == "undefined")
          r[`${key}`] = null;
      });
      // Set Commission Calculations
      COMMISSION_FIELDS.forEach((value, key, map) => {
        r.commissions[`${key}`] = quoteData.data[`${value}`];
        // console.log(`{${key}: ${value}} | `, quoteData[`${value}`]);
      });
    }
  }
  return r;
};

const mapDataToLwc = (obj, data, DataFields) => {
  let r = obj;
  if (data && DataFields) {
    DataFields.forEach((value, key, map) => {
      r[`${key}`] = data[`${value}`];
      console.log(`{${key}: ${value}} | `, data[`${value}`]);
    });
  }
  return r;
};

const mapCommissionSObjectToLwc = (data) => {
  return mapDataToLwc(resetResults(), data, COMMISSION_CALCULATION_FIELDS);
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

    r += quote.applicationFee > 0 ? quote.applicationFee : r;
    r += quote.dof > 0 ? quote.dof : 0.0;
    r += quote.ppsr > 0 ? quote.ppsr : 0.0;
  }
  return r;
};

const calcTotalInsuranceType = (quote) => {
  let r = 0.0;
  // TODO: implementation is still pending
  return r;
};

const calcNetRealtimeNaf = (quote) => {
  let r = calcTotalAmount(quote);
  r += calcTotalInsuranceType(quote);
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
    inputFields.push(field);
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
 * @returns new Mapping Object for server
 */
const mapLWCToSObject = (quoteForm, oppId, LENDER_QUOTING) => {
  let obj = { data: {}, results: { commissions: {} } };
  console.log(`@@quote form : ${JSON.stringify(quoteForm, null, 2)}`);
  for (const [key, value] of QUOTE_FIELDS_MAPPING) {
    obj.data[value] = quoteForm[key];
  }
  obj.data["Opportunity__c"] = oppId;
  obj.data["Name"] = LENDER_QUOTING;
  for (const [key, value] of COMMISSION_FIELDS) {
    obj.results["commissions"][value] = quoteForm["commissions"][key];
    obj.data[value] = quoteForm["commissions"][key];
  }
  console.log(`@@obj mapping --- ${JSON.stringify(obj, null, 2)}`);
  return obj;
};

// - TODO: need to map more fields
const QUOTE_FIELDS_MAPPING = new Map([
  ["loanType", "Loan_Type__c"],
  ["loanProduct", "Loan_Product__c"],
  ["price", "Vehicle_Price__c"],
  ["applicationFee", "Application_Fee__c"],
  ["dof", "DOF__c"],
  ["ppsr", "PPSR__c"],
  ["residual", "Residual_Value__c"],
  ["term", "Term__c"],
  ["monthlyFee", "Monthly_Fee__c"],
  ["clientRate", "Client_Rate__c"],
  ["paymentType", "Payment__c"],
  ["loanPurpose", "Loan_Purpose__c"],
  ["Id", "Id"]
]);

const QuoteCommons = {
  resetResults: resetResults,
  COMMISSION_FIELDS: COMMISSION_FIELDS,
  VALIDATION_OPTIONS: VALIDATION_OPTIONS,
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
  mapLWCToSObject: mapLWCToSObject
};

export { QuoteCommons, CommonOptions, FinancialUtilities, VALIDATION_OPTIONS };