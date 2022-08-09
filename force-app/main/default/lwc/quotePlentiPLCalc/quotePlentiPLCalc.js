import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { CalHelper } from "./quotePlentiPLCalcHelper";
import { QuoteCommons } from "c/quoteCommons";
import LENDER_LOGO from "@salesforce/resourceUrl/RateSetterLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import getQuotingTable from '@salesforce/apex/QuoteManager.getQuotingTable';

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteMoneyPlaceCalc extends LightningElement {
  isBusy; // loading
  isCalculated = false;
  tableRatesCols = CalHelper.tableRateDataColumns;
  tableRatesCols2 = CalHelper.tableRateDataColumns2;
  @track messageObj = QuoteCommons.resetMessage();
  @track quoteForm;
  // Rate Settings
  @track tableRates = [];
  @track tableRates2 = [];
  @api recordId; // Opportunity Id
  @wire(getRecord, { recordId: "$recordId", fields })
  opp;

  LENDER_QUOTING = "Plenti PL";
  LENDER_QUOTING2 = "Plenti PL Fee";

  // initial data and configs
  connectedCallback() {
    getQuotingTable({ LENDER_QUOTING: this.LENDER_QUOTING })
    .then(result => {
      console.log(result);
        this.tableRates = result;
    })
    .catch(error => {
      console.log(error);
        this.error = error;
    });

    getQuotingTable({ LENDER_QUOTING: this.LENDER_QUOTING2 })
    .then(result => {
      console.log(result);
        this.tableRates2 = result;
    })
    .catch(error => {
      console.log(error);
        this.error = error;
    });

    this.isBusy = true;
    this.reset();
    CalHelper.load(this.recordId)
      .then((data) => {
        console.log(`Data loaded!`);
        this.quoteForm = data;
        this.quoteForm["maxDof"] = this.quoteForm["dof"] =
          CalHelper.handleMaxDOF(this.quoteForm["price"]);
        //this.tableRates = CalHelper.getTableRatesData();TBC
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

  get profileOptions() {
    return CalHelper.options.profiles;
  }

  get termOptions() {
    return CalHelper.options.terms;
  }

  get assetTypeOptions() {
    return CalHelper.options.assetTypes;
  }

  get clientTierOptions() {
    return CalHelper.options.clientTiers;
  }

  get vehicleConditionOptions() {
    return CalHelper.options.vehicleConditions;
  }

  get greenCarOptions() {
    return CalHelper.options.greenCars;
  }

  get vehicleBuildDateOptions() {
    return CalHelper.options.vehicleBuildDates;
  }

  get leaseAgreementOptions() {
    return CalHelper.options.leaseAgreements;
  }

  get privateSalesOptions() {
    return CalHelper.options.privateSales;
  }

  get plentiAPIUserOptions() {
    return CalHelper.options.plentiAPIUsers;
  }

  get purposeTypeOptions() {
    return CalHelper.options.purposeTypes;
  }

  get securityOptions() {
    return CalHelper.options.securitys;
  }

  get additionalDetailsOptions() {
    return CalHelper.options.additionalDetails;
  }
  
  //clientTierOptions

  // realtime displaying the NAF as the last row in the left side
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

  // Calculate
  handleCalculate(event) {
    try {
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
          console.error(`error from QuoteMoneyPlaceCalc ${error}`);
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
    } catch (error) {
      console.error(error);
    }
  }

  // Reset function
  handleReset(event) {
    const appQuoteId = this.quoteForm["Id"];
    this.reset();
    this.quoteForm["Id"] = appQuoteId;
    this.messageObj = QuoteCommons.resetMessage();
    QuoteCommons.handleHasErrorClassClear(this);
    this.isCalculated = false;
  }

  // handle all field changes according to the type of field
  handleFieldChange(event) {
    console.log(`Changing value for: ${event.target.name}...`);
    try {
      const fldName = event.target.name;
      this.isCalculated = false;
      let fld = this.template.querySelector(`[data-id="${fldName}-field"]`);
      let v = event.detail ? event.detail.value : "";
      if (fld && fld.type === "number") {
        v = Number(v);
      }
      this.quoteForm[fldName] = v;
      // // casting the string to number
      fldName === "term" || fldName === "vehicleBuildDate"
        ? (this.quoteForm[fldName] = parseInt(v))
        : (this.quoteForm[fldName] = v);
      // calculate max dof
      if (fldName === "price") {
        this.quoteForm["maxDof"] = this.quoteForm["dof"] =
          CalHelper.handleMaxDOF(event.detail.value);
      }
    } catch (error) {
      console.error(error);
    }
  }

  // all Save Buttons actions
  handleSave(event) {
    console.log(`event detail : ${event.target.value.toUpperCase()}`);
    const isNONE = event.target.value.toUpperCase() === "NONE";
    this.isBusy = true;
    const loanType = event.target.value.toUpperCase();
    try {
      if (!this.messageObj.errors.length > 0) {
        this.messageObj = QuoteCommons.resetMessage();
        CalHelper.saveQuote(loanType, this.quoteForm, this.recordId)
          .then((data) => {
            console.log(
              "@@data in handle save quote:",
              JSON.stringify(data, null, 2)
            );
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
            console.error("handlePreApproval : ", error);
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