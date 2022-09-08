import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
//import { Validations } from "./quoteValidations";
import { CalHelper } from "./quoteAFSConsumerCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/AFSLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteAFSConsumerCalc extends LightningElement {
  tableRatesCols = CalHelper.tableRateDataColumns;
  isBusy;
  isBaseRateBusy;
  isCalculated = false;
  showMaxAndBaseRates = true;
  isCRReadOnly = false;
  @api recordId; // Opportunity Id
  @track messageObj = QuoteCommons.resetMessage();
  @track quoteForm;

  // Rate Settings
  @track propertyOwners;
  @track nPropertyOwnersRenters;
  @track nPropertyOwnersOthers;
  @wire(getRecord, { recordId: "$recordId", fields })
  opp;

  connectedCallback() {
    this.isBusy = true;
    this.reset();
    CalHelper.load(this.recordId)
      .then((data) => {
        this.quoteForm = data;
        this.propertyOwners = CalHelper.getTableRatesData(
          "Property Owner",
          this.quoteForm.assetType
        );
        this.nPropertyOwnersRenters = CalHelper.getTableRatesData(
          "Non-Property Owner - Renter",
          this.quoteForm.assetType
        );
        this.nPropertyOwnersOthers = CalHelper.getTableRatesData(
          "Non-Property Owner - Other",
          this.quoteForm.assetType
        );

        if (this.quoteForm.loanProduct === "Gold Club - Non-Property") {
          this.showMaxAndBaseRates = false;
        }
      })
      .catch((error) => {
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
  //Images
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

  get assetConditionOptions() {
    return CalHelper.options.assetConditions;
  }

  get termOptions() {
    return CalHelper.options.terms;
  }

  get assetAgeOptions() {
    return CalHelper.assetAgeOptions(this.quoteForm);
  }

  get residencyOptions() {
    return CalHelper.options.residency;
  }

  get employmentStatsOptions() {
    return CalHelper.options.employmentStats;
  }

  get creditImpairedOptions() {
    return CalHelper.options.creditImpaireds;
  }

  get payDayEnquiriesOptions() {
    return CalHelper.options.payDayEnqs;
  }

  get importsOptions() {
    return CalHelper.options.imports;
  }

  get odometerOptions() {
    return CalHelper.options.odometers;
  }

  get privateSalesOptions() {
    return CalHelper.options.privateSales;
  }

  get paymentTypeOptions() {
    return CalHelper.options.paymentTypes;
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

  // Base Rate
  baseRateCalc() {
    this.isBaseRateBusy = true;
    CalHelper.baseRates(this.quoteForm)
      .then((data) => {
        this.quoteForm.baseRate = data.baseRate;
        this.quoteForm.maxRate =
          this.quoteForm.baseRate !== 0 ? data.baseRate + 2 : 0.0;
        if (this.quoteForm.loanProduct === "Gold Club - Non-Property") {
          this.quoteForm.clientRate = data.baseRate;
        }
      })
      .catch((error) => {
        console.error(JSON.stringify(error, null, 2));
        displayToast(this, "Base Rate...", error, "error");
      })
      .finally(() => {
        this.isBaseRateBusy = false;
      });
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
    //net deposit
    this.quoteForm["netDeposit"] = this.netDeposit;
    //term
    fldName === "term"
      ? (this.quoteForm[fldName] = parseInt(v))
      : (this.quoteForm[fldName] = v);

    //Asset Age logic
    if (fldName === "assetCondition" && v === "New/Demo") {
      this.quoteForm.assetAge = "N/A";
    }

    //max and base rate field display logic
    this.showMaxAndBaseRates =
      this.quoteForm.loanProduct !== "Gold Club - Non-Property";
    this.isCRReadOnly =
      this.quoteForm.loanProduct === "Gold Club - Non-Property";

    // --------------
    // Trigger events
    // --------------

    // Base Rate Calculation
    if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
      this.baseRateCalc();
    }

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
  handleReset() {
    const appQuoteId = this.quoteForm["Id"];
    this.reset();
    this.quoteForm["Id"] = appQuoteId;
    this.isCalculated = false;
    this.messageObj = QuoteCommons.resetMessage();
    QuoteCommons.handleHasErrorClassClear(this);

    this.baseRateCalc();
  }

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