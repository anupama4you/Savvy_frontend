import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteGeddaCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/GeddaLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];
export default class QuoteGeddaCalc extends LightningElement {
  tableRatesCols = CalHelper.tableRateDataColumns;
  isBusy;
  isBaseRateBusy;
  lenderSettingDof = 0;
  isCalculated = false;
  @api recordId; // Opportunity Id
  @track messageObj = QuoteCommons.resetMessage();
  @track quoteForm;
  @track termOptions = [];
  // Rate Settings
  @track customerGradingOptions = [];
  // Api details
  @track apiDetails = [];

  @wire(getRecord, { recordId: "$recordId", fields })
  opp;

  connectedCallback() {
    console.log(`connectedCallback... > ${this.recordId}`);
    this.isBusy = true;
    this.reset();
    CalHelper.load(this.recordId)
      .then((data) => {
        this.quoteForm = data;
        this.lenderSettingDof = data.dof;
        this.apiDetails = CalHelper.getApiResponses();
        this.loadCustomerGradings('customerProfile');
        this.baseRateCalc();
      })
      .catch((error) => {
        console.error(error);
      })
      .finally(() => {
        this.dofCalc();
        this.applicationFeeCalc();
        this.loadTermOptions();
        this.isBusy = false;
      });
  }

  // lifecycle hook - after rendering all components(child+parent), will triggered
  renderedCallback() {
    QuoteCommons.resetValidateFields(this);
  }

  //Images
  get logoUrl() {
    return LENDER_LOGO;
  }

  get displayLoanPurpose() {
    return this.quoteForm["customerProfile"] === "Personal Finance";
  }

  // Combobox options
  get loanTypeOptions() {
    return CalHelper.options.loanTypes;
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

  get termOptions() {
    const terms = CalHelper.renderTerms(this.quoteForm);
    this.quoteForm.term = terms.default;
    console.log('term@@', this.quoteForm.term)
    return terms.options;
  }

  get customerProfileOptions() {
    return CalHelper.options.customerProfiles;
  }

  // Events
  handleFieldChange(event) {
    try {
      console.log(`Changing value for: ${event.target.name}...`);
      const fldName = event.target.name;
      this.isCalculated = false;
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

        console.log('term@1@', this.quoteForm['term'])

      // -------------- Trigger events --------------

      // Custom gradings change according to custom profile
      if (fldName === "customerProfile") {
        this.loadCustomerGradings(fldName, true);
      }

      // Base Rate Calculation
      if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
        this.baseRateCalc();
      }

      // DOF calculation
      if (CalHelper.DOF_CALC_FIELDS.includes(fldName)) {
        this.dofCalc();
      }

      // ApplicationFee calculation
      if (CalHelper.APPLICATION_FEE_CALC_FIELDS.includes(fldName)) {
        this.applicationFeeCalc();
      }

       // termOptions Loading
       if (CalHelper.TERM_OPTIONS_FIELDS.includes(fldName)) {
        this.loadTermOptions(true);
      }

      console.log(
        "🚀🚀 quoteform >> " + JSON.stringify(this.quoteForm, null, 2)
      );
      // Insurances
      QuoteCommons.calculateInsurances(this, fldName);
      // --------------
    } catch (error) {
      console.error(error);
    }
  }

  loadTermOptions (change) {
      const terms = CalHelper.renderTerms(this.quoteForm);
      if (change) {
        this.quoteForm.term = terms.default;
      } else {
        this.quoteForm.term = this.quoteForm.term ? this.quoteForm.term : terms.default;
      }
      console.log('term@@', this.quoteForm.term)
      this.termOptions = terms.options;
  }

  loadCustomerGradings(fldName, change) {
    if (this.quoteForm[fldName] === "Asset Finance") {
      this.customerGradingOptions = CalHelper.options.customerGradings;
    } else {
      this.customerGradingOptions = CalHelper.options.noneOption;
      this.quoteForm.customerGrading = "";
    }
  }

  // Calculations
  get netDeposit() {
    return CalHelper.getNetDeposit(this.quoteForm);
  }

  get netRealtimeNaf() {
    return CalHelper.calculateRealTimeNaf(this.quoteForm);
  }

  applicationFeeCalc() {
      this.quoteForm.maxApplicationFee = CalHelper.calculateApplicationFee(this.quoteForm);
      console.log('appFee@', this.quoteForm.maxApplicationFee)
      this.quoteForm.applicationFee = this.quoteForm.applicationFee ? this.quoteForm.applicationFee : this.quoteForm.maxApplicationFee;
  }

  dofCalc() {
    console.log('DOF Calc::',this.quoteForm.maxDof )
    this.quoteForm.maxDof = CalHelper.calculateDOF(this.quoteForm);
    this.quoteForm.dof = this.quoteForm.dof ? this.quoteForm.dof : this.quoteForm.maxDof;
  }

  get disableAction() {
    return !this.isCalculated;
  }

  // Reset
  reset() {
    this.quoteForm = CalHelper.reset(this.recordId);
  }

  // Base Rate
  baseRateCalc() {
    this.isBaseRateBusy = true;
    CalHelper.baseRates(this.quoteForm)
      .then((data) => {
        this.quoteForm.baseRate = data.baseRate;
        this.quoteForm.clientRate = this.quoteForm.clientRate ? this.quoteForm.clientRate : this.quoteForm.baseRate;
        console.log('BaseRate@@', data.baseRate)
      })
      .catch((error) => {
        console.error(error);
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
    try {
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
            console.error(`error from QuoteMoney3Calc ${error}`);
            this.messageObj = error.messages;
            QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
            console.error(
              "quoteMoney3Calc.js: get errors -- ",
              JSON.stringify(error.messages.errors, null, 2)
            );
          }
        })
        .finally(() => {
          this.isBusy = false;
        });
    } catch (error) {
      console.error(error);
    }
  }

  // Reset
  handleReset(event) {
    const appQuoteId = this.quoteForm["Id"];
    this.reset();
    this.quoteForm["Id"] = appQuoteId;
    this.isCalculated = false;
    this.messageObj = QuoteCommons.resetMessage();
    QuoteCommons.handleHasErrorClassClear(this);
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
    this.isBusy = true;
    if (this.quoteForm.loanPupose === "")
      this.messageObj.errors.push({
        field: "loanPurpose",
        message: "The Loan Purpose needs to be inserted into the quoting tool"
      });
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

  // Send Email - CURRENTLY DISABLE DUE UNFINISHED COMMON COMPS
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
}