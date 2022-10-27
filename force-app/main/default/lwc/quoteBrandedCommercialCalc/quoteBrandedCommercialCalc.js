import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteBrandedCommercialCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/BrandedLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteBrandedConsumerCalc extends LightningElement {
  tableRatesCols = CalHelper.tableRateDataColumns;
  isBusy;
  isBaseRateBusy;
  isCalculated = false;
  @api recordId; // Opportunity Id
  @track messageObj = QuoteCommons.resetMessage();
  @track quoteForm;
  @track resDisable = { per: true, val: false };
  @track gstOptions = [];
  // Rate Settings
  @track tableRates;
  @wire(getRecord, { recordId: "$recordId", fields })
  opp;
  // -

  // --- Insurance ---

  // --- Insurance: end ---

  connectedCallback() {
    console.log(`connectedCallback... ${this.opp.data}`);
    this.isBusy = true;
    this.reset();
    CalHelper.load(this.recordId)
      .then((data) => {
        console.log(`Data loaded!` + data);
        this.quoteForm = data;
        this.tableRates = CalHelper.getTableRatesData();
      })
      .catch((error) => {
        console.error(JSON.stringify(error, null, 2));
        displayToast(this, "Loading...", error, "error");
      })
      .finally(() => {
        this.isBusy = false;
        this.baseRateCalc();
        this.productTypeChange();
        this.gstChange();
      });
  }

  // lifecycle hook - after rendering all components(child+parent), will triggered
  renderedCallback() {
    QuoteCommons.resetValidateFields(this);
  }

  get logoUrl() {
    return LENDER_LOGO;
  }

  // Combobox options
  get loanTypeOptions() {
    return CalHelper.options.loanTypes;
  }

  get assetConditionOptions() {
    return CalHelper.options.assetConditions;
  }

  get goodsTypeOptions() {
    return CalHelper.options.goodsTypes;
  }

  get loanProductOptions() {
    return CalHelper.options.loanProducts;
  }

  get assetTypeOptions() {
    return CalHelper.options.assetTypes;
  }

  get paymentTypeOptions() {
    return CalHelper.options.paymentTypes;
  }

  get assetYearOptions() {
    return CalHelper.options.assetYears;
  }

  get propertyOwnerOptions() {
    return CalHelper.options.propertyOwners;
  }

  get termOptions() {
    return CalHelper.options.terms;
  }

  get privateSalesOptions() {
    return CalHelper.options.privateSales;
  }

  get typeValueOptions() {
    return CalHelper.options.typeValues;
  }

  // Events
  handleFieldChange(event) {
    console.log(`Changing value for: ${event.target.name}...`);
    const fldName = event.target.name;
    this.isCalculated = false;
    this.template.querySelector(
      "c-quote-insurance-form"
    ).isQuoteCalculated = false;
    let fld = this.template.querySelector(`[data-id="${fldName}-field"]`);
    let v = event.detail ? event.detail.value : "";
    if (fld && fld.type === "number") {
      v = Number(v);
    }
    this.quoteForm[fldName] = v;
    this.quoteForm["netDeposit"] = this.netDeposit;
    fldName === "term"
      ? (this.quoteForm[fldName] = parseInt(v))
      : (this.quoteForm[fldName] = v);
    // --------------
    // Trigger events
    // --------------

    // Base Rate Calculation
    if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
      this.baseRateCalc();
    }

    // Residual Value Calculation
    if (CalHelper.RESIDUAL_VALUE_FIELDS.includes(fldName)) {
      this.residualCalc();
    }

    // Product type change according to GST
    if (fldName === "gst") {
      this.productTypeChange();
    }

    // GST change according to PropertyOwner
    if (fldName === "propertyOwner") {
      this.gstChange();
    }

    // Insurances
    QuoteCommons.calculateInsurances(this, fldName);
    // --------------

    console.log("🍔🍔 >> " + JSON.stringify(this.quoteForm, null, 2));
  }

  // Calculations
  get netDeposit() {
    return CalHelper.getNetDeposit(this.quoteForm);
  }

  get netRealtimeNaf() {
    return CalHelper.getNetRealtimeNaf(this.quoteForm);
  }

  get disableAction() {
    return !this.isCalculated;
  }

  handleTypeChange(event) {
    this.quoteForm.typeValue = event.target.value;
    this.resPerDisable();
  }

  resPerDisable() {
    let tmp;
    this.quoteForm.typeValue === CalHelper.options.typeValues[0].value ? tmp = true : tmp = false;
    this.resDisable.per = !tmp;
    this.resDisable.val = tmp;
  }

  gstChange() {
    const gstOpt = CalHelper.getGstOptions(this.quoteForm);
    this.gstOptions = gstOpt;
    this.quoteForm.gst = gstOpt[0].value;
  }

  // Reset
  reset() {
    this.quoteForm = CalHelper.reset(this.recordId);
    console.log(
      "🚀 ~ file: QuotePepperMVCalc.js ~ line 113 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
      JSON.stringify(this.quoteForm, null, 2)
    );
  }

  // Base Rate
  baseRateCalc() {
    this.isBaseRateBusy = true;
    CalHelper.baseRates(this.quoteForm)
      .then((data) => {
        this.quoteForm.baseRate = data.baseRate;
        this.quoteForm.maxRate = data.maxRate;
        console.log(`Data loaded!`);
      })
      .catch((error) => {
        console.error(JSON.stringify(error, null, 2));
        displayToast(this, "Base Rate...", error, "error");
      })
      .finally(() => {
        this.isBaseRateBusy = false;
      });
  }

  // -------------
  // Button events
  // -------------

  // Calculate
  handleCalculate(type) {
    this.isBusy = true;
    this.messageObj = QuoteCommons.resetMessage();
    CalHelper.calculate(this.quoteForm)
      .then((data) => {
        console.log("@@data:", JSON.stringify(data, null, 2));
        this.quoteForm.commissions = data.commissions;
        this.messageObj = data.messages;
        QuoteCommons.handleHasErrorClassClear(this);
        // --- insurance ---
        if (this.quoteForm.commissions && type != "load") {
          this.isCalculated = true;
          this.template.querySelector(
            "c-quote-insurance-form"
          ).isQuoteCalculated = true;
        }
        // --- insurance: end ---
      })
      .catch((error) => {
        if (type !== "load") {
          this.messageObj = error.messages;
          QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
          console.error(
            "quotePepperMVCalc.js: get errors -- ",
            JSON.stringify(error.messages.errors, null, 2)
          );
        }
      })
      .finally(() => {
        this.isBusy = false;
      });
  }

  // Reset
  handleReset(event) {
    const appQuoteId = this.quoteForm["Id"];
    this.reset();
    this.quoteForm["Id"] = appQuoteId;
    this.isCalculated = false;
    this.messageObj = QuoteCommons.resetMessage();
    QuoteCommons.handleHasErrorClassClear(this);
    console.log(
      "🚀 ~ file: QuotePepperMVCalc.js ~ line 172 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
      JSON.stringify(this.quoteForm, null, 2)
    );
    this.baseRateCalc();
    // --- insurance ---
    this.template.querySelector("c-quote-insurance-form").resetPressed();
    // --- insurance: end ---
  }

  // all Save Buttons actions
  handleSave(event, saveType) {
    let isNONE;
    let loanType;
    if (event) {
      console.log(`event detail : ${event.target.value.toUpperCase()}`);
      isNONE = event.target.value.toUpperCase() === "NONE";
      loanType = event.target.value.toUpperCase();
    } else {
      // --- insurance ---
      loanType = saveType.toUpperCase();
      // --- insurance: end ---
    }
    console.log("save type => ", loanType);
    this.isBusy = true;
    if (!this.messageObj.errors.length > 0 || this.isErrorInsuranceOnly()) {
      this.messageObj = QuoteCommons.resetMessage();
      CalHelper.saveQuote(loanType, this.quoteForm, this.recordId)
        .then((data) => {
          console.log("@@data in handleSave:", JSON.stringify(data, null, 2));
          !isNONE
            ? this.messageObj.confirms.push(
              {
                field: "confirms",
                message: "Calculation saved successfully."
              },
              {
                fields: "confirms",
                message: "Product updated successfully."
              }
            )
            : this.messageObj.confirms.push({
              field: "confirms",
              message: "Calculation saved successfully."
            });
          // passing data to update quoteform
          this.quoteForm["Id"] = data["Id"];
        })
        .catch((error) => {
          console.error("handleSave : ", error);
        })
        .finally(() => {
          this.isBusy = false;
          // --- insurance ---
          this.quoteForm.commissions.insurance =
            loanType === "Send" ? 0.0 : this.quoteForm.commissions.insurance;
          // --- insurance: end ---
        });
    } else {
      QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
      this.isCalculated = true;
    }
  }

  // Send Email
  handleSendQuote() {
    this.isBusy = true;
    if (!this.messageObj.errors.length > 0 || this.isErrorInsuranceOnly()) {
      this.messageObj = QuoteCommons.resetMessage();
      CalHelper.sendEmail(this.quoteForm, this.recordId)
        .then((data) => {
          console.log(
            "@@data in handle send quote :",
            JSON.stringify(data, null, 2)
          );
          this.messageObj.infos.push({
            field: "infos",
            message: "Email has been sent to customer."
          });
        })
        .catch((error) => {
          console.error("handleSendQuote: ", error);
        })
        .finally(() => {
          this.isBusy = false;
        });
    } else {
      QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
      this.isCalculated = true;
    }
  }

  // --- insurance ---
  handleInsuranceMessage(event) {
    try {
      this.messageObj = QuoteCommons.resetMessage();
      this.messageObj.errors = [
        ...this.messageObj.errors,
        ...event.detail.errors
      ];
      console.log(
        "event.detail >> " + JSON.stringify(this.messageObj.errors, null, 2)
      );
    } catch (error) {
      console.error(error);
    }
  }

  isErrorInsuranceOnly() {
    let result = true;
    try {
      if (this.messageObj.errors && this.messageObj.errors.length > 0) {
        for (const error of this.messageObj.errors) {
          if (error.field !== "insurance") {
            return false;
          }
        }
      }
      return result;
    } catch (error) {
      console.error(error);
    }
  }

  handleInsuranceChange(event) {
    this.quoteForm.insurance = event.detail;
    this.isCalculated = this.template.querySelector(
      "c-quote-insurance-form"
    ).isQuoteCalculated = false;
    // comprehensive
    let cms = { ...this.quoteForm.commissions };
    cms.comprehensive.isMvAccept = this.quoteForm.insurance.ismvAccept;
    if (this.quoteForm.insurance.ismvAccept) {
      cms.comprehensive.weekly = this.quoteForm.insurance.mvRetailPrice / 52;
      cms.comprehensive.fortnightly =
        this.quoteForm.insurance.mvRetailPrice / 26;
      cms.comprehensive.monthly = this.quoteForm.insurance.mvRetailPrice / 12;
      console.log("cms ==> ", JSON.stringify(cms));
      this.quoteForm.commissions = cms;
    } else {
      cms.comprehensive.weekly = 0;
      cms.comprehensive.fortnightly = 0;
      cms.comprehensive.monthly = 0;
    }
    // end - comprehensive
    console.log(
      "handle insurance change >>  " + JSON.stringify(this.quoteForm, null, 2)
    );
  }

  handleInsurancePresentation(event) {
    console.log(event.detail);
    this.handleSave(null, event.detail);
  }

  handleInsuanceLoad(event) {
    this.handleInsuranceChange(event);
    // check if there is no acceptance
    if (
      this.quoteForm.insurance.ismvAccept ||
      this.quoteForm.insurance.isshortfallAccept ||
      this.quoteForm.insurance.iswarrantyAccept ||
      this.quoteForm.insurance.isLPIAccept ||
      this.quoteForm.insurance.isIntegrityAccept
    ) {
      this.handleCalculate("load");
    } else {
      this.quoteForm.commissions = {
        ...this.quoteForm.commissions,
        insurances: null
      };
    }
    this.console.log(
      "handleInsuanceLoad>>",
      JSON.stringify(this.quoteForm, null, 2)
    );
  }

  handleDisableButton(event) {
    this.isCalculated = event.detail;
  }
  // --- insurance: end ---

  residualCalc() {
    if (this.quoteForm.typeValue === 'Value' && this.quoteForm.residualValue > 0) {
      this.quoteForm.residualPer = CalHelper.getResiPer(this.quoteForm);
    }
    else if (this.quoteForm.typeValue === 'Percentage' && this.quoteForm.residualPer > 0) {
      this.quoteForm.residualValue = CalHelper.getResiVal(this.quoteForm);
    }
  }

  productTypeChange() {
    this.quoteForm.productType = (this.quoteForm.gst === "ABN/GST > 1 year" || this.quoteForm.gst === "ABN > 2 yrs/GST > 1year") ? "Lite" : "Express"
  }

  // --- insurance ---
  handleInsuranceMessage(event) {
    try {
      this.messageObj = QuoteCommons.resetMessage();
      this.messageObj.errors = [
        ...this.messageObj.errors,
        ...event.detail.errors
      ];
      console.log(
        "event.detail >> " + JSON.stringify(this.messageObj.errors, null, 2)
      );
    } catch (error) {
      console.error(error);
    }
  }

  isErrorInsuranceOnly() {
    let result = true;
    try {
      if (this.messageObj.errors && this.messageObj.errors.length > 0) {
        for (const error of this.messageObj.errors) {
          if (error.field !== "insurance") {
            return false;
          }
        }
      }
      return result;
    } catch (error) {
      console.error(error);
    }
  }

  handleInsuranceChange(event) {
    this.quoteForm.insurance = event.detail;
    this.isCalculated = this.template.querySelector(
      "c-quote-insurance-form"
    ).isQuoteCalculated = false;

    // comprehensive
    const cms = QuoteCommons.handleComprehensive(this.quoteForm);
    this.quoteForm.commissions = { ...cms };
    // end - comprehensive
    console.log(
      "handle insurance change >>  " + JSON.stringify(this.quoteForm, null, 2)
    );
  }

  handleInsurancePresentation(event) {
    console.log(event.detail);
    this.handleSave(null, event.detail);
  }

  handleInsuanceLoad(event) {
    this.handleInsuranceChange(event);
    // check if there is no acceptance
    if (
      this.quoteForm.insurance.ismvAccept ||
      this.quoteForm.insurance.isshortfallAccept ||
      this.quoteForm.insurance.iswarrantyAccept ||
      this.quoteForm.insurance.isLPIAccept ||
      this.quoteForm.insurance.isIntegrityAccept
    ) {
      this.handleCalculate("load");
    } else {
      this.quoteForm.commissions = {
        ...this.quoteForm.commissions,
        insurances: null
      };
    }
    this.console.log(
      "handleInsuanceLoad>>",
      JSON.stringify(this.quoteForm, null, 2)
    );
  }

  handleDisableButton(event) {
    this.isCalculated = event.detail;
  }
  // --- insurance: end ---
}