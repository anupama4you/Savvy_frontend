import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { CalHelper } from "./quoteMoneyPlaceCalcHelper";
import { Validations } from "./quoteValidations";
import { QuoteCommons } from "c/quoteCommons";
import LENDER_LOGO from "@salesforce/resourceUrl/MoneyPlaceLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteMoneyPlaceCalc extends LightningElement {
  isBusy; // loading
  isCalculated = false;
  tableRatesCols = CalHelper.tableRateDataColumns;
  @track messageObj = QuoteCommons.resetMessage();
  @track quoteForm;
  // Rate Settings
  @track tableRates;
  @api recordId; // Opportunity Id
  @wire(getRecord, { recordId: "$recordId", fields })
  opp;

  // initial data and configs
  connectedCallback() {
    this.isBusy = true;
    this.reset();
    CalHelper.load(this.recordId)
      .then((data) => {
        console.log(`Data loaded!`);
        this.quoteForm = data;
        this.quoteForm["maxDof"] = this.quoteForm["dof"] =
          CalHelper.handleMaxDOF(this.quoteForm["price"]);
        this.tableRates = CalHelper.getTableRatesData();
      })
      .catch((error) => {
        console.error(JSON.stringify(error, null, 2));
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

  get paymentTypeOptions() {
    return CalHelper.options.paymentTypes;
  }

  get termOptions() {
    return CalHelper.options.terms;
  }

  // realtime displaying the NAF as the last row in the left side
  get netRealtimeNaf() {
    return CalHelper.getNetRealtimeNaf(this.quoteForm);
  }

  get disableAction() {
    return !this.isCalculated;
  }

  // Reset
  reset() {
    this.quoteForm = CalHelper.reset();
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
          "quoteMoneyPlaceCalc.js: get errors -- ",
          JSON.stringify(error.messages.errors, null, 2)
        );
      })
      .finally(() => {
        this.isBusy = false;
      });
    // if (results && Array.isArray(results) && results.length > 0) {
    //   // this.quoteResult = results[0];
    // }
  }

  // Reset function
  handleReset(event) {
    this.reset();
    this.messageObj = QuoteCommons.resetMessage();
    QuoteCommons.handleHasErrorClassClear(this);
    this.isCalculated = false;
  }

  // handle all field changes according to the type of field
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
    console.log(`this.quoteForm:`, JSON.stringify(this.quoteForm, null, 2));
    // // casting the string to number
    fldName === "term"
      ? (this.quoteForm[fldName] = parseInt(v))
      : (this.quoteForm[fldName] = v);
    console.log(`this.quoteForm:`, JSON.stringify(this.quoteForm, null, 2));
    // calculate max dof
    if (fldName === "price") {
      this.quoteForm["maxDof"] = this.quoteForm["dof"] = CalHelper.handleMaxDOF(
        event.detail.value
      );
    }
  }

  // Save Quoting
  handleSave(event) {
    this.isBusy = true;
    // --------- start call function from helper ---------------
    this.messageObj = Validations.validate(this.quoteForm);
    if (!this.messageObj.errors.length > 0) {
      CalHelper.saveQuoting(this.quoteForm)
        .then((data) => {
          this.messageObj.confirms = [
            { field: "", message: "Save Successful" }
          ];
        })
        .catch((error) => {})
        .finally(() => {
          this.isBusy = false;
        });
    } else {
      QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
      this.isCalculated = true;
    }
    // ---------- end call function --------------
    this.isBusy = false;
  }
}