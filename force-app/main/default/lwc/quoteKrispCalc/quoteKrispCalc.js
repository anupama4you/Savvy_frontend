import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteKrispCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/KrispLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];
export default class QuoteKrispCalc extends LightningElement {
  tableRatesCols = CalHelper.tableRateDataColumns;
  isBusy;
  isBaseRateBusy;
  lenderSettingDof = 0;
  isCalculated = false;
  @api recordId; // Opportunity Id
  @track messageObj = QuoteCommons.resetMessage();
  @track quoteForm;
  // Rate Settings
  @track customerGradingOptions = [];
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
      })
      .catch((error) => {
        console.error(error);
      })
      .finally(() => {
        this.isBusy = false;
        this.calculateParams(this.quoteForm.clientRate);
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

  get riskFeeTotal() {
    console.log(
      "risk fee total >> " + CalHelper.getMoney3RiskFee(this.quoteForm)
    );
    this.quoteForm.riskFeeTotal = CalHelper.getMoney3RiskFee(this.quoteForm);
    return CalHelper.getMoney3RiskFee(this.quoteForm);
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
    try {
      let termsOpts = CalHelper.renderTerms(this.quoteForm);
      const indexOfTerm = termsOpts.findIndex(
        (t) => t.value === this.quoteForm["term"]
      );
      console.log("index > " + indexOfTerm);
      if (indexOfTerm < 0) {
        this.quoteForm["term"] = termsOpts[0].value;
      }
      return termsOpts;
    } catch (error) {
      console.error(error);
    }
  }

  get customerProfileOptions() {
    return CalHelper.options.customerProfiles;
  }

  get clientTierOptions() {
    return CalHelper.options.clientTiers;
  }

  get customerGradings() {
    if (this.quoteForm["customerProfile"] === null)
      this.quoteForm["customerGrading"] = null;
    return this.quoteForm["customerProfile"] === null
      ? CalHelper.options.noneOption
      : this.quoteForm["customerProfile"] == "Asset Finance"
        ? [
          ...CalHelper.options.customerGradings,
          { label: "Micro Motor", value: "Micro Motor" }
        ]
        : [
          ...CalHelper.options.customerGradings,
          { label: "Mini PL", value: "Mini PL" }
        ];
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
      // -------------- Trigger events --------------
      if (fldName === "customerProfile")
        this.quoteForm["customerGrading"] = null;
      if (fldName === "customerProfile" || fldName === "customerGrading") {
        this.customerGradings;
        if (
          this.quoteForm["customerProfile"] === "Asset Finance" &&
          this.quoteForm["customerGrading"]
        ) {
          this.quoteForm.maxDof = this.quoteForm.dof = this.lenderSettingDof;
        } else {
          this.quoteForm.maxDof = this.quoteForm.dof = 0.0;
        }
      }
      // Fees Calculation
      if (CalHelper.CALC_FEES_FIELDS.includes(fldName)) {
        this.calculateParams(false, true);
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

  // Calculations
  get netDeposit() {
    return CalHelper.getNetDeposit(this.quoteForm);
  }

  get netRealtimeNaf() {
    return CalHelper.calculateRealTimeNaf(this.quoteForm);
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
        this.quoteForm.clientRate = data.baseRate;
      })
      .catch((error) => {
        console.error(error);
        displayToast(this, "Base Rate...", error, "error");
      })
      .finally(() => {
        this.isBaseRateBusy = false;
      });
  }

  calculateParams(skipClientRate, notSkipDof) {
    this.isBaseRateBusy = true;
    console.log("✈✈ cal params >> " + JSON.stringify(this.quoteForm, null, 2));
    CalHelper.calculateParams(this.quoteForm)
      .then((data) => {
        // console.log("calculate params >> " + JSON.stringify(data, null, 2));
        if (data) {
          this.quoteForm.baseRate = data.baseRate;
          if (!skipClientRate) {
            this.quoteForm.maxDof = data.maxDof;
            this.quoteForm.clientRate = data.baseRate;
          } else {
            this.quoteForm.maxDof = this.quoteForm.dof;
          }
          if (notSkipDof) {
            this.quoteForm.dof = this.quoteForm.maxDof;
            this.quoteForm.riskFee = this.riskFeeTotal;
          }
        }
        // this.termOptions;
      })
      .catch((error) => {
        console.error(error);
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