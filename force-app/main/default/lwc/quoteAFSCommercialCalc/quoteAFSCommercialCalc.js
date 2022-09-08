import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
//import { Validations } from "./quoteValidations";
import { CalHelper } from "./quoteAFSCommercialCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/AFSLogo";
import AFSCOMMERCIALRATES_IMG from "@salesforce/resourceUrl/AFSCommercial";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteAFSCommercialCalc extends LightningElement {
  isBusy;
  isBaseRateBusy;
  isCalculated = false;
  @api recordId; // Opportunity Id
  @track messageObj = QuoteCommons.resetMessage();
  @track quoteForm;
  // Rate Settings

  @wire(getRecord, { recordId: "$recordId", fields })
  opp;

  connectedCallback() {
    this.isBusy = true;
    this.reset();
    CalHelper.load(this.recordId)
      .then((data) => {
        this.quoteForm = data;
      })
      .catch((error) => {
        displayToast(this, "Loading...", error, "error");
      })
      .finally(() => {
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
  get afsCommercialRates() {
    return AFSCOMMERCIALRATES_IMG;
  }

  // Combobox options
  get loanTypeOptions() {
    return CalHelper.options.loanTypes;
  }

  get loanProductOptions() {
    return CalHelper.options.loanProducts;
  }

  get termOptions() {
    return CalHelper.options.terms;
  }

  get carAgeOptions() {
    return CalHelper.options.carAges;
  }

  get residencyOptions() {
    return CalHelper.options.residencies;
  }

  get paymentTypeOptions() {
    return CalHelper.options.paymentTypes;
  }

  get gstOptions() {
    return CalHelper.options.gst;
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

  // Reset
  reset() {
    this.quoteForm = CalHelper.reset(this.recordId);
  }

  // -------------
  // Button events
  // -------------

  handleFieldChange(event) {
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
    // --------------
    // Trigger events
    // --------------

    console.log("quote form >> ", JSON.stringify(this.quoteForm, null, 2));
  }

  // Calculate
  handleCalculate() {
    this.isBusy = true;
    this.messageObj = QuoteCommons.resetMessage();
    CalHelper.calculate(this.quoteForm)
      .then((data) => {
        this.quoteForm.commissions = data.commissions;
        this.messageObj = data.messages;
        QuoteCommons.handleHasErrorClassClear(this);
        if (this.quoteForm.commissions) this.isCalculated = true;
      })
      .catch((error) => {
        this.messageObj = error.messages;
        QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
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
  }

  // all Save Buttons actions
  handleSave(event) {
    try {
      let isNONE;
      let loanType;
      console.log(`event detail : ${event.target.value.toUpperCase()}`);
      isNONE = event.target.value.toUpperCase() === "NONE";
      loanType = event.target.value.toUpperCase();
      this.isBusy = true;
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
    } catch (error) {
      console.error(error);
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
}