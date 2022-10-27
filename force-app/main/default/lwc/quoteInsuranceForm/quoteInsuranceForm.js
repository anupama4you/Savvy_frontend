import { LightningElement, api, track, wire } from "lwc";
import { InsuranceHelper } from "./quoteInsuranceFormHelper";
import { QuoteCommons } from "c/quoteCommons";
import { NavigationMixin, CurrentPageReference } from "lightning/navigation";

export default class QuoteInsuranceForm extends NavigationMixin(LightningElement) {
  isMvReadOnly = false;
  isLPIReadOnly = false;
  isWarrantyReadOnly = false;
  isShortfallReadOnly = false;
  isDisplayInput = true;
  isDisplayLPIInput = true;
  isDisplayWarrantyInput = true;
  isDisplayIntegrityInput = true;
  isDisplayIntegrityOpts = false;
  isDisplayAssetType = "label-hidden";
  isEnableAccept = true;
  isReadOnly = false;
  isSent = false;
  typeRetail = [];
  typeOfAsset = "";
  quoteNaf;
  customerChoiceStatus = "None";

  @track insuranceForm;
  @track isCalculateGAPBusy = false;
  @track isCalculateLPIBusy = false;
  @track isCalculateWarrantyBusy = false;

  @api isQuoteCalculated = false;
  @api recordId;
  @api quoteForm;

  @api resetPressed() {
    this.reset();
    console.log(
      "insurance form     >>> ",
      JSON.stringify(this.insuranceForm, null, 2)
    );
  }

  connectedCallback() {
    this.reset();
    InsuranceHelper.load(this.recordId)
      .then((data) => {
        this.typeOfAsset = `Asset: ${data.typeOfAsset}`;
      })
      .then(() => {
        this.getPresentationStatus(this.quoteForm.Id);
      })
      .catch((error) => {
        console.error(error);
      })
      .finally(() => {});
  }

  get cusChoiceStatus() {
    return this.customerChoiceStatus;
  }

  get disablePresentationButton() {
    return !this.isQuoteCalculated;
  }
  get disableAcceptButton() {
    return !this.isEnableAccept;
  }
  get options() {
    return [{ label: "Retail price manually", value: "Yes" }];
  }

  get mvOptions() {
    return InsuranceHelper.getMVOptions().typeOptions;
  }

  get assetType() {
    return this.typeOfAsset;
  }

  get mvAcceptCSS() {
    return this.insuranceForm.ismvAccept
      ? "accept inTableText"
      : this.insuranceForm.ismvDecline
      ? "decline inTableText"
      : "";
  }

  get shortfallAcceptCSS() {
    return this.insuranceForm.isshortfallAccept
      ? "accept inTableText"
      : this.insuranceForm.isshortfallDecline
      ? "decline inTableText"
      : "";
  }

  get LPIAcceptCSS() {
    return this.insuranceForm.isLPIAccept
      ? "accept inTableText"
      : this.insuranceForm.isLPIDecline
      ? "decline inTableText"
      : "";
  }

  get warrantyAcceptCSS() {
    return this.insuranceForm.iswarrantyAccept ||
      this.insuranceForm.isIntegrityAccept
      ? "accept inTableText"
      : this.insuranceForm.iswarrantyDecline ||
        this.insuranceForm.isIntegrityDecline
      ? "decline inTableText"
      : "";
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

  get totalInsurancePrice() {
    console.log("total insurance price ... ");
    try {
      let {
        isshortfallAccept,
        iswarrantyAccept,
        isIntegrityAccept,
        isLPIAccept,
        warrantyRetailPrice,
        LPIRetailPrice,
        shortfallRetailPrice,
        shortfallPBM,
        warrantyPBM,
        LPIPBM
      } = this.insuranceForm;
      const isWarrantyFinanced = warrantyPBM === "Financed";
      const isLPIFinanced = LPIPBM === "Financed";
      const isShortfallFinanced = shortfallPBM === "Financed";

      return (
        (isShortfallFinanced
          ? isshortfallAccept
            ? parseInt(shortfallRetailPrice || 0)
            : 0
          : 0) +
        (isWarrantyFinanced
          ? iswarrantyAccept || isIntegrityAccept
            ? parseInt(warrantyRetailPrice || 0)
            : 0
          : 0) +
        (isLPIFinanced ? (isLPIAccept ? parseInt(LPIRetailPrice || 0) : 0) : 0)
      );
    } catch (error) {
      console.error(error);
    }
  }

  get totalInsuranceCommission() {
    let {
      isshortfallAccept,
      iswarrantyAccept,
      isIntegrityAccept,
      isLPIAccept,
      warrantyCommission,
      LPICommission,
      shortfallCommission
    } = this.insuranceForm;
    return (
      (isshortfallAccept ? parseInt(shortfallCommission || 0) : 0) +
      (iswarrantyAccept || isIntegrityAccept
        ? parseInt(warrantyCommission || 0)
        : 0) +
      (isLPIAccept ? parseInt(LPICommission || 0) : 0)
    );
  }
  get LPITerms() {
    return InsuranceHelper.getLPIOptions().termOptions;
  }

  get warrantyOptions() {
    return InsuranceHelper.getWarrantyOptions().typeOptions;
  }

  get pbmOptions() {
    return InsuranceHelper.getPBMOptions(this.isOnlyPayByTheMonth);
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

  getPresentationStatus(appQuoteId) {
    InsuranceHelper.gettingPresentationStatus(appQuoteId)
      .then((data) => {
        console.log("insurance data >> " + JSON.stringify(data));
        this.isSent = data !== "None" ? true : false;
        this.customerChoiceStatus = data;
      })
      .catch((error) => {
        console.error(error);
      })
      .finally(() => {
        this.loadSavedRecords();
      });
  }

  getMVPayment({ mvRetailPrice, mvTerm, mvPBM }) {
    return QuoteCommons.getInsurancePayment(mvRetailPrice, mvTerm, mvPBM);
  }

  getGAPPayment({ shortfallRetailPrice, shortfallTerm, shortfallPBM }) {
    return QuoteCommons.getInsurancePayment(
      shortfallRetailPrice,
      shortfallTerm,
      shortfallPBM
    );
  }

  getLPIPayment({ LPIRetailPrice, LPITerm, LPIPBM }) {
    const term = LPITerm === "(Loan Term)" ? this.quoteForm.term : LPITerm;
    return QuoteCommons.getInsurancePayment(LPIRetailPrice, term, LPIPBM);
  }

  getWarrantyPayment({ warrantyRetailPrice, warrantyTerm, warrantyPBM }) {
    return QuoteCommons.getInsurancePayment(
      warrantyRetailPrice,
      warrantyTerm,
      warrantyPBM
    );
  }

  loadSavedRecords() {
    // console.log(
    //   "quote form finally >>>  ",
    //   JSON.stringify(this.quoteForm, null, 2)
    // );
    this.quoteNaf = QuoteCommons.calcNetRealtimeNaf(this.quoteForm);
    this.insuranceForm = { ...this.quoteForm.insurance };
    this.insuranceForm.integrity = {
      ...this.quoteForm.insurance.integrity
    };
    this.typeRetail = [...this.insuranceForm.typeRetail];
    if (this.insuranceForm.LPIType) {
      this.isDisplayLPIInput =
        this.insuranceForm.LPIType === "Eric" ||
        (!this.insuranceForm.isLPIAccept && !this.insuranceForm.isLPIDecline);
      if (this.insuranceForm.LPIType.includes("Liberty")) {
        this.isDisplayLPIInput = false;
      }
    }
    if (this.insuranceForm.warrantyType) {
      this.isDisplayIntegrityOpts =
        this.insuranceForm.warrantyType === "Integrity";
    }
    if (this.insuranceForm.shortfallType) {
      this.isDisplayInput =
        this.insuranceForm.shortfallType === "Eric" ||
        (!this.insuranceForm.isshortfallAccept &&
          !this.insuranceForm.isshortfallDecline);
      if (this.insuranceForm.shortfallType.includes("Liberty")) {
        this.isDisplayInput = false;
      }
    }
    this.insuranceForm.LPIRetailPrice = this.insuranceForm.LPIRetailPrice
      ? parseFloat(this.insuranceForm.LPIRetailPrice)
      : this.insuranceForm.LPIRetailPrice;
    this.insuranceForm.LPICommission = this.insuranceForm.LPICommission
      ? parseFloat(this.insuranceForm.LPICommission)
      : this.insuranceForm.LPICommission;
    this.isDisplayIntegrityInput =
      !this.isDisplayIntegrityOpts ||
      (this.insuranceForm.typeRetail.length > 0 && this.isDisplayIntegrityOpts);
    this.isDisplayAssetType =
      this.insuranceForm.warrantyType === "Integrity" ? "" : "label-hidden";
    this.insuranceForm.shortfallPayment = this.getGAPPayment(
      this.insuranceForm
    );
    this.insuranceForm.LPIPayment = this.getLPIPayment(this.insuranceForm);
    this.insuranceForm.warrantyPayment = this.getWarrantyPayment(
      this.insuranceForm
    );
    this.insuranceForm.mvPayment = this.getMVPayment(this.insuranceForm);
    this.isMvReadOnly = this.insuranceForm.ismvAccept;
    this.isLPIReadOnly = this.insuranceForm.isLPIAccept;
    this.isWarrantyReadOnly =
      this.isSent ||
      this.insuranceForm.iswarrantyAccept ||
      this.insuranceForm.iswarrantyDecline ||
      this.insuranceForm.isIntegrityAccept ||
      this.insuranceForm.isIntegrityDecline;
    this.isShortfallReadOnly = this.insuranceForm.isshortfallAccept;
    if (this.isSent) {
      this.isMvReadOnly = true;
      this.isLPIReadOnly = true;
      this.isWarrantyReadOnly = true;
      this.isShortfallReadOnly = true;
    }
    this.dispatchEvent(
      new CustomEvent("handleloadinsurance", {
        detail: this.insuranceForm
      })
    );
  }

  reset() {
    this.insuranceForm = InsuranceHelper.reset();
    this.isMvReadOnly = false;
    this.isLPIReadOnly = false;
    this.isWarrantyReadOnly = false;
    this.isShortfallReadOnly = false;
    this.isDisplayInput = true;
    this.isDisplayLPIInput = true;
    this.isDisplayWarrantyInput = true;
    this.isDisplayIntegrityInput = true;
    this.isDisplayIntegrityOpts = false;
    this.isDisplayAssetType = "label-hidden";
    this.isEnableAccept = true;
    this.isReadOnly = false;
    this.typeRetail = [];
    this.isSent = false;
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
          console.log("shortfall --> ", this.insuranceForm.shortfallTerm);
          break;
        case "LPI":
          this.isDisplayLPIInput = isERIC || changedValue === null;
          this.insuranceForm.LPITerm = isLIBERTY ? "(Loan Term)" : null;
          console.log("LPI --> ", this.insuranceForm.LPITerm);
          break;
        case "warranty":
          this.isDisplayIntegrityOpts = isINTEGRITY;
          this.isDisplayAssetType = isINTEGRITY ? "" : "label-hidden";
          this.isDisplayIntegrityInput = !this.isDisplayIntegrityOpts;
          this.insuranceForm.warrantyPBM = isINTEGRITY ? "Financed" : null;
          this.insuranceForm.warrantyRetailPrice = isINTEGRITY ? 0.0 : null;
          this.insuranceForm.warrantyCommission = isINTEGRITY ? 0.0 : null;
          this.insuranceForm.integrity = isINTEGRITY
            ? this.insuranceForm.integrity
            : {
                type: null,
                term: null,
                category: null
              };
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
      // quoteForm.oppId = this.recordId;
      let q = { ...quoteForm };
      if (!q.oppId || q.oppId.length === 0) {
        q.oppId = this.recordId;
      }
      console.log("🚀 ~ file: quoteInsuranceForm.js ~ line 493 ~ QuoteInsuranceForm ~ handleCalculatingLPI ~ quoteForm", JSON.stringify(q));
      InsuranceHelper.calculatingLPI(this.insuranceForm, q)
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

    if (this.insuranceForm.warrantyType === "Integrity") {
      // Resetting values
      this.insuranceForm.warrantyRetailPrice = 0.0;
      this.insuranceForm.warrantyCommission = 0.0;
    }
    
    if (
      this.insuranceForm.integrity.type &&
      this.insuranceForm.integrity.term &&
      this.insuranceForm.integrity.category
    ) {
      this.isCalculateWarrantyBusy = true;

      let q = { ...this.quoteForm };
      if (!q.oppId || q.oppId.length === 0) {
        q.oppId = this.recordId;
      }

      InsuranceHelper.calculatingNWC(this.insuranceForm, q)
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
      if (fldName.includes("Type")) {
        this.rowHandler(changedValue, rowType);
        console.log(`go into rowhandler`);
      }
      if (fldName === "integrity type") {
        this.insuranceForm.integrity.category =
          this.insuranceForm.integrity.term = null;
      }

      if (fldName.includes("integrity")) {
        if (fldName.includes("type"))
          this.insuranceForm.integrity.type = changedValue;
        if (fldName.includes("category"))
          this.insuranceForm.integrity.category = changedValue;
        if (fldName.includes("term"))
          this.insuranceForm.integrity.term = changedValue;
      } else {
        if (fldName.includes("Price") || fldName.includes("Commission")) {
          this.insuranceForm[`${fldName}`] =
            changedValue.length > 0 ? Number(changedValue) : null;
        } else {
          this.insuranceForm[`${fldName}`] = changedValue;
        }
      }

      if (fldName === "typeRetail") {
        this.isDisplayIntegrityInput =
          this.isDisplayIntegrityOpts &&
          this.insuranceForm.typeRetail.length > 0;
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
      this.dispatchEvent(
        new CustomEvent("insurancechanged", {
          detail: this.insuranceForm
        })
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
        console.log("LPI...");
        this.handleCalculatingLPI(this.quoteForm);
        break;
      case "warranty":
        console.log("warranty...");
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

  // handle accept button
  handleAccept(event) {
    try {
      console.log(event.target.value);
      const acceptType = event.target.value;
      switch (acceptType) {
        case "shortfall-accept":
          if (this.insuranceForm.isshortfallDecline)
            this.insuranceForm.isshortfallDecline =
              !this.insuranceForm.isshortfallDecline;
          this.insuranceForm.isshortfallAccept =
            !this.insuranceForm.isshortfallAccept;
          this.isShortfallReadOnly =
            this.isSent ||
            this.insuranceForm.isshortfallDecline ||
            this.insuranceForm.isshortfallAccept;
          break;
        case "LPI-accept":
          if (this.insuranceForm.isLPIDecline)
            this.insuranceForm.isLPIDecline = !this.insuranceForm.isLPIDecline;
          this.insuranceForm.isLPIAccept = !this.insuranceForm.isLPIAccept;
          this.isLPIReadOnly =
            this.isSent ||
            this.insuranceForm.isLPIAccept ||
            this.insuranceForm.isLPIDecline;
          break;
        case "warranty-accept":
          if (this.insuranceForm.warrantyType === "Integrity") {
            if (this.insuranceForm.isIntegrityDecline)
              this.insuranceForm.isIntegrityDecline =
                !this.insuranceForm.isIntegrityDecline;
            this.insuranceForm.isIntegrityAccept =
              !this.insuranceForm.isIntegrityAccept;
          } else {
            if (this.insuranceForm.iswarrantyDecline)
              this.insuranceForm.iswarrantyDecline =
                !this.insuranceForm.iswarrantyDecline;
            this.insuranceForm.iswarrantyAccept =
              !this.insuranceForm.iswarrantyAccept;
          }
          this.isWarrantyReadOnly =
            this.isSent ||
            this.insuranceForm.iswarrantyAccept ||
            this.insuranceForm.iswarrantyDecline ||
            this.insuranceForm.isIntegrityAccept ||
            this.insuranceForm.isIntegrityDecline;
          this.handleCalculatingLPI(this.quoteForm);
          break;
        case "mv-accept":
          if (this.insuranceForm.ismvDecline)
            this.insuranceForm.ismvDecline = !this.insuranceForm.ismvDecline;
          this.insuranceForm.ismvAccept = !this.insuranceForm.ismvAccept;
          this.isMvReadOnly =
            this.isSent ||
            this.insuranceForm.ismvAccept ||
            this.insuranceForm.ismvDecline;
          break;
        default:
          break;
      }
      console.log(
        "insurance form     >>> ",
        JSON.stringify(this.insuranceForm, null, 2)
      );
      // this.insuranceIncome.retailPrice = this.totalInsurancePrice;
      // this.insuranceIncome.commission = this.totalInsuranceCommission;
      // console.log("totalInsuancePrice >> ", this.totalInsurancePrice);
      this.dispatchEvent(
        new CustomEvent("insurancechanged", {
          detail: this.insuranceForm
        })
      );
    } catch (error) {
      console.error(error);
    }
  }

  handleDecline(event) {
    try {
      console.log(event.target.value);
      const declineType = event.target.value;
      switch (declineType) {
        case "shortfall-decline":
          if (this.insuranceForm.isshortfallAccept)
            this.insuranceForm.isshortfallAccept =
              !this.insuranceForm.isshortfallAccept;
          this.insuranceForm.isshortfallDecline =
            !this.insuranceForm.isshortfallDecline;
          this.isShortfallReadOnly =
            this.isSent ||
            this.insuranceForm.isshortfallDecline ||
            this.insuranceForm.isshortfallAccept;
          break;
        case "LPI-decline":
          if (this.insuranceForm.isLPIAccept)
            this.insuranceForm.isLPIAccept = !this.insuranceForm.isLPIAccept;
          this.insuranceForm.isLPIDecline = !this.insuranceForm.isLPIDecline;
          this.isLPIReadOnly =
            this.isSent ||
            this.insuranceForm.isLPIAccept ||
            this.insuranceForm.isLPIDecline;
          break;
        case "warranty-decline":
          if (this.insuranceForm.warrantyType === "Integrity") {
            if (this.insuranceForm.isIntegrityAccept)
              this.insuranceForm.isIntegrityAccept =
                !this.insuranceForm.isIntegrityAccept;
            this.insuranceForm.isIntegrityDecline =
              !this.insuranceForm.isIntegrityDecline;
          } else {
            if (this.insuranceForm.iswarrantyAccept)
              this.insuranceForm.iswarrantyAccept =
                !this.insuranceForm.iswarrantyAccept;
            this.insuranceForm.iswarrantyDecline =
              !this.insuranceForm.iswarrantyDecline;
          }
          this.isWarrantyReadOnly =
            this.isSent ||
            this.insuranceForm.iswarrantyAccept ||
            this.insuranceForm.iswarrantyDecline ||
            this.insuranceForm.isIntegrityAccept ||
            this.insuranceForm.isIntegrityDecline;
          this.handleCalculatingLPI(this.quoteForm);
          break;

        case "mv-decline":
          if (this.insuranceForm.ismvAccept)
            this.insuranceForm.ismvAccept = !this.insuranceForm.ismvAccept;
          this.insuranceForm.ismvDecline = !this.insuranceForm.ismvDecline;
          this.isMvReadOnly =
            this.isSent ||
            this.insuranceForm.ismvAccept ||
            this.insuranceForm.ismvDecline;

          break;
        default:
          break;
      }
      console.log(
        "insurance form     >>> ",
        JSON.stringify(this.insuranceForm, null, 2)
      );
      // this.insuranceIncome.retailPrice = this.totalInsurancePrice;
      // this.insuranceIncome.commission = this.totalInsuranceCommission;
      // console.log("totalInsuancePrice >> ", this.totalInsurancePrice);
      // this.insuranceForm.insuranceIncome = this.insuranceIncome;
      this.dispatchEvent(
        new CustomEvent("insurancechanged", {
          detail: this.insuranceForm
        })
      );
    } catch (error) {
      console.error(error);
    }
  }

  handleReQuote() {
    console.log(`@@handleReQuote A: `, JSON.stringify(this.insuranceForm, null, 2));
    this.isSent = false;
    this.isMvReadOnly = false;
    this.isLPIReadOnly = false;
    this.isWarrantyReadOnly = false;
    this.isShortfallReadOnly = false;
    this.insuranceForm.ismvAccept = false;
    this.insuranceForm.ismvDecline = false;
    this.insuranceForm.isshortfallDecline = false;
    this.insuranceForm.isshortfallAccept = false;
    this.insuranceForm.isLPIDecline = false;
    this.insuranceForm.isLPIAccept = false;
    this.insuranceForm.iswarrantyDecline = false;
    this.insuranceForm.iswarrantyAccept = false;
    this.insuranceForm.isIntegrityAccept = false;
    this.insuranceForm.isIntegrityDecline = false;
    this.isQuoteCalculated = false;

    this.isDisplayInput = !this.insuranceForm.shortfallType.includes("Liberty");
    this.isDisplayLPIInput = !this.insuranceForm.LPIType.includes("Liberty");

    console.log(`@@handleReQuote B: `, JSON.stringify(this.insuranceForm, null, 2));

    this.insuranceForm.lastAction = 'RE-CREATE';

    this.dispatchEvent(
      new CustomEvent("handledisablebutton", {
        detail: false
      })
    );
    console.log(`@@insurancechanged...`);
    this.dispatchEvent(
      new CustomEvent("insurancechanged", {
        detail: this.insuranceForm
      })
    );
  }

  handleSendPresentation() {
    console.log("Sending Presentation to Customer... ");

    const messages = InsuranceHelper.validatePresentation(
      this.insuranceForm,
      this.quoteForm
    );
    if (messages && messages.errors.length > 0) {
      this.dispatchEvent(
        new CustomEvent("handleinsurancemessage", {
          detail: { ...messages }
        })
      );
      return;
    }

    // Change status
    this.isSent = true;
    this.isMvReadOnly = true;
    this.isLPIReadOnly = true;
    this.isWarrantyReadOnly = true;
    this.isShortfallReadOnly = true;

    this.insuranceForm = {
      ...InsuranceHelper.resetInsuranceAccept(this.insuranceForm)
    };

    this.customerChoiceStatus = 'Sent';

    this.dispatchEvent(
      new CustomEvent("handlepresentation", {
        detail: "Send"
      })
    );
  }

  handlePreviewPresentation() {
    console.log("Previewing Presentation ... ");
    this.dispatchEvent(
      new CustomEvent("handleinsurancemessage", {
        detail: { ...QuoteCommons.resetMessage() }
      })
    );
    this.dispatchEvent(
      new CustomEvent("handlepresentation", {
        detail: "Preview"
      })
    );
    this.loadQuotingUrl();
  }

  buildPageRef(pageName) {
    let myState = {
      recordId: this.recordId
    };
    return {
      type: "comm__namedPage",
      attributes: {
        name: pageName
      },
      state: myState
    };
  }

  loadQuotingUrl() {
    try {
      const pageRef = this.buildPageRef("Preview_Presentation__c");
      this[NavigationMixin.GenerateUrl](pageRef)
        .then((url) => {
          console.log("preview url >> " + url);
          window.open(url);
        })
        .catch((err) => {
          console.error(err);
        })
        .finally(() => {});
    } catch (error) {
      console.error(error);
    }
    // if (this.quoting) {
    //   const pageRef = this.buildPageRef("Preview_Presentation__c");
    //   this[NavigationMixin.GenerateUrl](pageRef)
    //     .then((url) => {
    //       this.previewUrl = url;
    //       // console.log(`this.quotingToolUrl 2: ${this.quotingToolUrl}`);
    //     })
    //     .catch((err) => console.log(err));
    // }
  }

  @api recalculateProducts() {
    console.log(`Insurance: recalculateProducts...`, this.quoteForm.price);
    this.handleCalculatingLPI(this.quoteForm);
  }

  get isOnlyPayByTheMonth() {
    return (
      this.quoteForm &&
      this.quoteForm.insurance &&
      this.quoteForm.insurance.isOnlyPayByTheMonth
    );
  }

  get mvLabelType() {
    return this.insuranceForm &&
      this.insuranceForm.mvType &&
      this.insuranceForm.mvType.length > 0
      ? this.insuranceForm.mvType
      : "MV [not selected]";
  }

  get shortfallLabelType() {
    return this.insuranceForm &&
      this.insuranceForm.shortfallType &&
      this.insuranceForm.shortfallType.length > 0
      ? this.insuranceForm.shortfallType
      : "Shortfall [not selected]";
  }

  get lpiLabelType() {
    return this.insuranceForm &&
      this.insuranceForm.LPIType &&
      this.insuranceForm.LPIType.length > 0
      ? this.insuranceForm.LPIType
      : "LPI [not selected]";
  }

  get warrantyLabelType() {
    return this.insuranceForm &&
      this.insuranceForm.warrantyType &&
      this.insuranceForm.warrantyType.length > 0
      ? this.insuranceForm.warrantyType
      : "Warranty [not selected]";
  }
}