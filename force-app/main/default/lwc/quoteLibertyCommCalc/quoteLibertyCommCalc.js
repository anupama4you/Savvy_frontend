import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteLibertyCommCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/LibertyLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteLibertyCommCalc extends LightningElement {
  tableRatesCols = CalHelper.tableRateDataColumns;
  isBusy;
  isBaseRateBusy;
  isCalculated = false;
  @api recordId; // Opportunity Id
  @track messageObj = QuoteCommons.resetMessage();
  @track quoteForm;
  // Rate Settings
  @track tableRates;
  @wire(getRecord, { recordId: "$recordId", fields })
  opp;
  // -

  connectedCallback() {
    console.log(`connectedCallback... ${this.recordId}`);
    this.isBusy = true;
    this.reset();
    CalHelper.load(this.recordId)
      .then((data) => {
        console.log(`Data loaded!`);
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

  get loanProductOptions() {
    return CalHelper.options.loanProducts;
  }

  get assetTypeOptions() {
    return CalHelper.options.assetTypes;
  }

  get paymentTypeOptions() {
    return CalHelper.options.paymentTypes;
  }

  get assetAgeOptions() {
    return CalHelper.options.vehicleAges;
  }

  get termOptions() {
    return CalHelper.options.terms;
  }

  get propertyOwnerOptions() {
    return CalHelper.options.propertyOwner;
  }

  get creditScoreOptions() {
    return CalHelper.options.creditScore;
  }

  get abnLengthOptions() {
    return CalHelper.options.abnLength;
  }

  get gstLengthOptions() {
    return CalHelper.options.gstLength;
  }

  get vehicleYearOptions() {
    return CalHelper.options.vehicleYear;
  }

  get netRealtimeNaf() {
    return CalHelper.getNetRealtimeNaf(this.quoteForm);
  }

  get realtimeEqFee() {
    return CalHelper.getRealtimeEqFee(this.quoteForm);
  }

  // Events
  handleFieldChange(event) {
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
    if (fldName === "applicationFee") this.dofCalc();

    // --------------
    // Trigger events
    // --------------
    // Base Rate Calculation
    // if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) this.baseRateCalc();
    // Risk Grade Calculation
    if (CalHelper.RISK_GRADE_FIELDS.includes(fldName)) this.riskGradeCalc();
    // --------------
    console.log(`🍟🍟🍟🍟 ： ${JSON.stringify(this.quoteForm, null, 2)}`);
  }

  // Calculations
  get netDeposit() {
    return CalHelper.getNetDeposit(this.quoteForm);
  }

  get disableAction() {
    return !this.isCalculated;
  }

  // DOF calculation
  dofCalc() {
    this.quoteForm.dof = CalHelper.getDOF(this.quoteForm);
    this.quoteForm.maxDof = this.quoteForm.dof;
  }
  // Risk Grade Calculation
  riskGradeCalc() {
    this.quoteForm["riskGrade"] = CalHelper.getRiskGrade(
      this.quoteForm["abnLength"],
      this.quoteForm["gstLength"],
      this.quoteForm["creditScore"],
      this.quoteForm["propertyOwner"]
    );
    this.baseRateCalc();
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
        console.log(`Data loaded!`);
        this.quoteForm.baseRate = data.baseRate;
        this.quoteForm.maxRate = data.maxRate;
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
  handleCalculate(event) {
    this.isBusy = true;
    this.messageObj = QuoteCommons.resetMessage();
    CalHelper.calculate(this.quoteForm)
      .then((data) => {
        console.log("@@data:", JSON.stringify(data, null, 2));
        this.quoteForm.commissions = data.commissions;
        this.messageObj = data.messages;
        QuoteCommons.handleHasErrorClassClear(this);
        if (this.quoteForm.commissions) this.isCalculated = true;
      })
      .catch((error) => {
        this.messageObj = error.messages;
        QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
        console.error(
          "liberty Comm calc .js: get errors ->",
          JSON.stringify(error.messages.errors, null, 2)
        );
      })
      .finally(() => {
        this.isBusy = false;
      });

    if (results && Array.isArray(results) && results.length > 0) {
      // this.quoteResult = results[0];
    }
    this.baseRateCalc();
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
      "🚀 ~ file: QuoteLibertyCommCalc.js ~ line 172 ~ QuoteLibertyCommMVCalc ~ reset ~ this.quoteForm",
      JSON.stringify(this.quoteForm, null, 2)
    );
    this.baseRateCalc();
  }

  // all Save Buttons actions
  handleSave(event) {
    console.log(`event detail : ${event.target.value.toUpperCase()}`);
    const isNONE = event.target.value.toUpperCase() === "NONE";
    this.isBusy = true;
    const loanType = event.target.value.toUpperCase();
    if (!this.messageObj.errors.length > 0) {
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
        });
    } else {
      QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
      this.isCalculated = true;
    }
  }

  // Send Email
  handleSendQuote() {
    this.isBusy = true;
    if (!this.messageObj.errors.length > 0) {
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
}