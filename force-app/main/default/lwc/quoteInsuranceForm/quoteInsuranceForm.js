import { LightningElement, api, track, wire } from "lwc";
import { InsuranceHelper } from "./quoteInsuranceFormHelper";

export default class QuoteInsuranceForm extends LightningElement {
  isDisplayInput = true;
  isDisplayLPIInput = true;
  isReadOnly = false;
  isLPIReadOnly = false;
  value = null;
  @track insuranceForm;
  @track isCalculateGAPBusy = false;
  @api quoteForm;
  @api oppId;

  connectedCallback() {
    this.reset();
    console.log("opp-id  >>> ", this.oppId);
    console.log("quote form >>>  ", JSON.stringify(this.quoteForm, null, 2));
  }

  get mvOptions() {
    return InsuranceHelper.getMVOptions().typeOptions;
  }

  get mvProductOptions() {
    return this.insuranceForm.mvType
      ? InsuranceHelper.getMVOptions().productOptions
      : InsuranceHelper.noneOption;
  }

  get shortfallOptions() {
    return InsuranceHelper.getShortfallOptions().typeOptions;
  }

  get shortfallProductOptions() {
    const types = this.insuranceForm.shortfallType;
    if (!types) return InsuranceHelper.noneOption;
    return types.includes("Eric")
      ? InsuranceHelper.getShortfallOptions().productOptions.Eric
      : types.includes("Liberty")
      ? InsuranceHelper.getShortfallOptions().productOptions.Liberty
      : InsuranceHelper.noneOption;
  }

  get LPIOptions() {
    return InsuranceHelper.getLPIOptions().typeOptions;
  }
  get warrantyOptions() {
    return InsuranceHelper.getWarrantyOptions().typeOptions;
  }
  get warrantyProductOptions() {
    const types = this.insuranceForm.warrantyType;
    if (!types) return InsuranceHelper.noneOption;
    return types.includes("Eric")
      ? InsuranceHelper.getWarrantyOptions().productOptions.Eric
      : InsuranceHelper.getWarrantyOptions().productOptions.Integrity;
  }

  get LPIProductOptions() {
    const types = this.insuranceForm.LPIType;

    if (!types) return InsuranceHelper.noneOption;
    return types.includes("Eric")
      ? InsuranceHelper.getLPIOptions().productOptions.Eric
      : types.includes("Liberty")
      ? InsuranceHelper.getLPIOptions().productOptions.Liberty
      : InsuranceHelper.noneOption;
  }

  get LPITerms() {
    // const types = this.insuranceForm.LPIType;
    // if (types && types.includes("Liberty"))
    //   return InsuranceHelper.getLPIOptions().termOptions.Liberty;
    return InsuranceHelper.getLPIOptions().termOptions;
  }

  get loanTypeOptions() {
    return [
      { label: "--None--", value: null },
      { label: "Eric", value: "Eric" }
    ];
  }

  get pbmOptions() {
    return InsuranceHelper.getPBMOptions();
  }

  getMVPayment({ mvRetailPrice, mvTerm, mvPBM }) {
    return InsuranceHelper.getInsurancePayment(mvRetailPrice, mvTerm, mvPBM);
  }

  getGAPPayment({ shortfallRetailPrice, shortfallTerm, shortfallPBM }) {
    return InsuranceHelper.getInsurancePayment(
      shortfallRetailPrice,
      shortfallTerm,
      shortfallPBM
    );
  }

  getLPIPayment({ LPIRetailPrice, LPITerm, LPIPBM }) {
    return InsuranceHelper.getInsurancePayment(LPIRetailPrice, LPITerm, LPIPBM);
  }

  reset() {
    this.insuranceForm = InsuranceHelper.reset();
  }

  /**
   * -- lee
   * @param {*} changedValue - the selected value
   * @param {String} rowType - String of type [mv, shortfall, LPI, warranty]
   */
  rowHandler(changedValue, rowType) {
    try {
      const isERIC = changedValue ? changedValue.includes("Eric") : false;
      const isLIBERTY = changedValue ? changedValue.includes("Liberty") : false;
      const isSUNCORP = changedValue ? changedValue.includes("Suncorp") : false;
      this.fieldsValueReset(rowType);
      switch (rowType) {
        case "mv":
          console.log(`going to switch ... rowtype: ${rowType}`);
          //   this.insuranceForm.mvTerm = null && "12";
          break;
        case "shortfall":
          this.isDisplayInput = isERIC || changedValue === null;
          this.isReadOnly = isERIC;
          this.insuranceForm.shortfallTerm = isLIBERTY ? "36" : "12";
          break;
        case "LPI":
          this.isDisplayLPIInput = isERIC || changedValue === null;
          this.isLPIReadOnly = isERIC;
          this.insuranceForm.LPITerm = isLIBERTY ? "(Long Term)" : null;
          break;
        default:
          break;
      }
    } catch (error) {
      console.error(error);
    }
  }

  fieldsValueReset(rowType) {
    try {
      const insuranceF = { ...this.insuranceForm };
      for (const [key, value] of Object.entries(this.insuranceForm)) {
        if (key.includes(rowType) && InsuranceHelper.RESET_FIELDS.includes(key))
          insuranceF[key] = null;
      }
      this.insuranceForm = insuranceF;
    } catch (error) {
      console.error(error);
    }
  }

  // calculating retail price and commission and payment
  handleCalculatingGAP() {
    if (
      this.insuranceForm.shortfallType &&
      this.insuranceForm.shortfallProduct &&
      this.insuranceForm.shortfallType.includes("Liberty")
    ) {
      this.isCalculateGAPBusy = true;
      InsuranceHelper.calculateGAP(this.insuranceForm, this.oppId)
        .then((data) => {
          console.log(
            "data from handleCalculatingGAP",
            JSON.stringify(data, null, 2)
          );
          this.insuranceForm.shortfallRetailPrice = data["gap"];
          this.insuranceForm.shortfallCommission = data["gapIncome"];
          this.insuranceForm.shortfallPayment = this.getGAPPayment(
            this.insuranceForm
          );
        })
        .catch((error) => {
          console.error(error);
        })
        .finally(() => {
          this.isCalculateGAPBusy = false;
        });
    } else {
      this.insuranceForm.shortfallPayment = this.getGAPPayment(
        this.insuranceForm
      );
    }
  }

  // calculating for LPI
  handleCalculatingLPI() {
    this.insuranceForm.LPIPayment = this.getLPIPayment(this.insuranceForm);
  }

  handleFieldChange(event) {
    const fldName = event.target.name;
    const changedValue = event.detail.value;
    const rowType = fldName.includes("mv")
      ? "mv"
      : fldName.includes("shortfall")
      ? "shortfall"
      : fldName.includes("LPI")
      ? "LPI"
      : "warranty";
    console.log(
      `Changing value for: ${fldName}...  value: ${changedValue} .... rowType: ${rowType}`
    );
    this.insuranceForm[`${fldName}`] = changedValue;

    // changing the type of insurance product
    if (fldName.includes("Type")) this.rowHandler(changedValue, rowType);
    // calculate payment
    this.handlePaymentCalculating(rowType);
    console.log(
      "handleFieldChange: quote form >>>  ",
      JSON.stringify(this.quoteForm, null, 2)
    );
    console.log(
      "insurance form     >>> ",
      JSON.stringify(this.insuranceForm, null, 2)
    );
  }

  handlePaymentCalculating(rowType) {
    switch (rowType) {
      case "mv":
        this.insuranceForm.mvPayment = this.getMVPayment(this.insuranceForm);
        break;
      case "shortfall":
        this.handleCalculatingGAP();
        break;
      case "LPI":
        this.handleCalculatingLPI();
        break;
      case "warranty":
        break;
      default:
        break;
    }
  }
}