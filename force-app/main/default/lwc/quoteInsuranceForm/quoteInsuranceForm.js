import { LightningElement, api, track, wire } from "lwc";
import { InsuranceHelper } from "./quoteInsuranceFormHelper";

export default class QuoteInsuranceForm extends LightningElement {
  isDisplayInput = true;
  isDisplayLPIInput = true;
  isDisplayWarrantyInput = true;
  isDisplayIntegrityOpts = false;
  isDisplayIntegrityInput = true;
  isDisplayAssetType = "label-hidden";
  isReadOnly = false;
  isLPIReadOnly = false;
  retailPriceManually = false;
  isTypeRetail = "";
  typeOfAsset = "";
  @api insuranceIncome;
  @track insuranceForm;
  @track isCalculateGAPBusy = false;
  @track isCalculateLPIBusy = false;
  @track isCalculateWarrantyBusy = false;
  @api recordId;
  @api quoteForm;
  connectedCallback() {
    this.reset();
    console.log("quote form >>>  ", JSON.stringify(this.quoteForm, null, 2));
    InsuranceHelper.load(this.recordId)
      .then((data) => {
        this.typeOfAsset = `Asset: ${data}`;
      })
      .catch((error) => {
        console.error(error);
      });
  }

  get options() {
    return [{ label: "Retail price manually", value: "Yes" }];
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
    return InsuranceHelper.getLPIOptions().termOptions;
  }

  get warrantyOptions() {
    return InsuranceHelper.getWarrantyOptions().typeOptions;
  }
  get warrantyProductEricOptions() {
    const types = this.insuranceForm.warrantyType;
    if (!types) return InsuranceHelper.noneOption;
    return InsuranceHelper.getWarrantyOptions().productOptions.Eric;
  }

  get warrantyProductIntegrityOptions() {
    const integrityType =
      InsuranceHelper.getWarrantyOptions().productOptions.Integrity;
    return this.typeOfAsset.includes("Car")
      ? integrityType.ProductType.Car
      : integrityType.ProductType.Other;
  }
  get warrantyProductIntegrityCategoryOptions() {
    const integrityType = this.insuranceForm.integrity.type;
    if (!integrityType) return InsuranceHelper.noneOption;
    switch (integrityType) {
      case "Integrity Endurance":
        return InsuranceHelper.getWarrantyOptions().productOptions.Integrity
          .Category.Endurance;
      case "Integrity Absolute":
        return InsuranceHelper.getWarrantyOptions().productOptions.Integrity
          .Category.Absolute;
      default:
        return InsuranceHelper.getWarrantyOptions().productOptions.Integrity
          .Category.Integrity;
    }
  }
  get warrantyProductIntegrityTermOptions() {
    const integrityType = this.insuranceForm.integrity.type;
    const integrityCategory = this.insuranceForm.integrity.category;
    if (!integrityType || !integrityCategory) return InsuranceHelper.noneOption;
    switch (integrityType) {
      case "Integrity Endurance":
        return InsuranceHelper.getWarrantyOptions().productOptions.Integrity
          .Term.Endurance;
      case "Integrity Absolute":
        return InsuranceHelper.getWarrantyOptions().productOptions.Integrity
          .Term.Absolute;
      default:
        return InsuranceHelper.getWarrantyOptions().productOptions.Integrity
          .Term.Integrity;
    }
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
    const term = LPITerm === "(Long Term)" ? this.quoteForm.term : LPITerm;
    return InsuranceHelper.getInsurancePayment(LPIRetailPrice, term, LPIPBM);
  }

  getWarrantyPayment({ warrantyRetailPrice, warrantyTerm, warrantyPBM }) {
    return InsuranceHelper.getInsurancePayment(
      warrantyRetailPrice,
      warrantyTerm,
      warrantyPBM
    );
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
      const isINTEGRITY = changedValue
        ? changedValue.includes("Integrity")
        : false;
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
        case "warranty":
          this.isDisplayIntegrityOpts = isINTEGRITY;
          this.isDisplayAssetType = isINTEGRITY ? "" : "label-hidden";
          this.isDisplayIntegrityInput = !this.isDisplayIntegrityOpts;
          this.insuranceForm.warrantyPBM = isINTEGRITY ? "Financed" : null;
          this.insuranceForm.warrantyRetailPrice = isINTEGRITY ? 0.0 : null;
          this.insuranceForm.warrantyCommission = isINTEGRITY ? 0.0 : null;
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
      InsuranceHelper.calculateGAP(this.insuranceForm, this.recordId)
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
  handleCalculatingLPI(quoteForm) {
    if (
      this.insuranceForm.LPIType &&
      this.insuranceForm.LPIProduct &&
      this.insuranceForm.LPIType.includes("Liberty")
    ) {
      this.isCalculateLPIBusy = true;
      InsuranceHelper.calculatingLPI(this.insuranceForm, quoteForm)
        .then((data) => {
          this.insuranceForm.LPIRetailPrice = data["cci"];
          this.insuranceForm.LPICommission = data["cciIncome"];
          this.insuranceForm.LPIPayment = this.getLPIPayment(
            this.insuranceForm
          );
        })
        .catch((error) => {
          console.error(error);
        })
        .finally(() => {
          this.isCalculateLPIBusy = false;
        });
    } else {
      this.insuranceForm.LPIPayment = this.getLPIPayment(this.insuranceForm);
    }
  }

  // calculating for Warranty
  handleCalculatingWarranty() {
    if (
      this.insuranceForm.integrity.type &&
      this.insuranceForm.integrity.term &&
      this.insuranceForm.integrity.category
    ) {
      this.isCalculateWarrantyBusy = true;
      InsuranceHelper.calculatingNWC(this.insuranceForm, this.quoteForm)
        .then((data) => {
          console.log(
            "calculate warranty (nwc)   >>> ",
            JSON.stringify(data, null, 2)
          );
          this.insuranceForm.warrantyRetailPrice = data["retailPrice"];
          this.insuranceForm.warrantyCommission = data["commission"];
        })
        .catch((error) => {
          console.error(error);
        })
        .finally(() => {
          this.isCalculateWarrantyBusy = false;
        });
    } else {
      this.insuranceForm.warrantyPayment = this.getWarrantyPayment(
        this.insuranceForm
      );
    }
  }

  handleFieldChange(event) {
    try {
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

      // changing the type of insurance product
      if (fldName.includes("Type")) this.rowHandler(changedValue, rowType);
      if (fldName === "integrity type")
        this.insuranceForm.integrity.category =
          this.insuranceForm.integrity.term = null;

      if (fldName.includes("integrity")) {
        if (fldName.includes("type"))
          this.insuranceForm.integrity.type = changedValue;
        if (fldName.includes("category"))
          this.insuranceForm.integrity.category = changedValue;
        if (fldName.includes("term"))
          this.insuranceForm.integrity.term = changedValue;
      } else {
        this.insuranceForm[`${fldName}`] = changedValue;
      }

      if (fldName === "typeRetail") {
        this.isDisplayIntegrityInput =
          this.isDisplayIntegrityOpts &&
          this.insuranceForm.typeRetail[0] === "Yes";
        console.log(
          "this.isDisplayIntegrityInput >>> ",
          this.isDisplayIntegrityInput
        );
      }

      // calculate payment
      this.handlePaymentCalculating(fldName, rowType, changedValue);
      // console.log(
      //   "handleFieldChange: quote form >>>  ",
      //   JSON.stringify(this.quoteForm, null, 2)
      // );
      console.log(
        "insurance form     >>> ",
        JSON.stringify(this.insuranceForm, null, 2)
      );
    } catch (error) {
      console.error(error);
    }
  }

  handlePaymentCalculating(fldName, rowType, changedValue) {
    switch (rowType) {
      case "mv":
        this.insuranceForm.mvPayment = this.getMVPayment(this.insuranceForm);
        break;
      case "shortfall":
        this.handleCalculatingGAP();
        break;
      case "LPI":
        this.handleCalculatingLPI(this.quoteForm);
        break;
      case "warranty":
        if (
          this.isDisplayIntegrityInput &&
          this.insuranceForm.warrantyType === "Integrity"
        ) {
          if (fldName === "warrantyRetailPrice")
            this.insuranceForm.warrantyRetailPrice = changedValue;
          if (fldName === "warrantyCommission")
            this.insuranceForm.warrantyCommission = changedValue;
        } else {
          this.handleCalculatingWarranty();
        }
        break;
      default:
        break;
    }
  }

  handleAccept(event) {
    console.log(event.target.value);
    const acceptType = event.target.value;
    this.insuranceIncome = 100;
    switch (acceptType) {
      case "shortfall-accept":
        this.dispatchEvent(
          new CustomEvent("acceptinsurance", {
            detail: this.insuranceIncome
          })
        );
        break;
      case "LPI-accept":
        break;
      case "warranty-accept":
        break;
      default:
        break;
    }
  }

  handleDecline(event) {
    console.log(event.target.value);
    const declineType = event.target.value;
    switch (declineType) {
      case "shortfall-accept":
        this.insuranceIncome = 100;
        break;
      case "LPI-accept":
        break;
      case "warranty-accept":
        break;
      default:
        break;
    }
  }
}