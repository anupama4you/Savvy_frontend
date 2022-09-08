import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteGreenLightCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/GreenLightLogo";
import GLCARRATES_IMG from "@salesforce/resourceUrl/GreenLightCarRates";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteGreenLightCalc extends LightningElement {
  tableRatesCols = CalHelper.tableRateDataColumns;
  isBusy;
  isBaseRateBusy;
  isCalculated = false;
  @api recordId; // Opportunity Id
  @track messageObj = QuoteCommons.resetMessage();
  @track quoteForm;
  @track isResetBrokerage = false;
  // Rate Settings
  @track tableRates;
  @wire(getRecord, { recordId: "$recordId", fields })
  opp;

  connectedCallback() {
    this.isBusy = true;
    this.reset();
    CalHelper.load(this.recordId)
      .then((data) => {
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

  //Images
  get logoUrl() {
    return LENDER_LOGO;
  }
  get greenLightCarRatesUrl() {
    return GLCARRATES_IMG;
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

  get vehicleYearOptions() {
    return CalHelper.options.yearList;
  }

  get paymentTypeOptions() {
    return CalHelper.options.paymentTypes;
  }

  get clientTierOptions() {
    return CalHelper.options.clientTiers;
  }

  get termOptions() {
    return CalHelper.options.terms;
  }

  get lvrOptions() {
    return CalHelper.options.lvr;
  }

  // Events
  handleFieldChange(event) {
    const fldName = event.target.name;
    this.isCalculated = false;
    this.isResetBrokerage = false;
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

    if (fldName === "clientTier") {
      this.isResetBrokerage = true;
    }
    // --------------
    // Trigger events
    // --------------

    // Base Rate Calculation
    if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
      this.baseRateCalc();
    }

    // Fees Calculation
    if (CalHelper.CALC_FEES_FIELDS.includes(fldName)) {
      this.calculateFees();
    }

    // --------------
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

  // Base Rate
  baseRateCalc() {
    this.isBaseRateBusy = true;
    CalHelper.baseRates(this.quoteForm, this.isResetBrokerage)
      .then((data) => {
        console.log("data >> ", JSON.stringify(data, null, 2));
        this.quoteForm.baseRate = data.baseRate;
        this.quoteForm.maxRate = data.maxRate;
        this.quoteForm.brokerage = data.brokeragePer;
        this.quoteForm.clientRate = data.clientRate;
      })
      .catch((error) => {
        console.error(JSON.stringify(error, null, 2));
        displayToast(this, "Base Rate...", error, "error");
      })
      .finally(() => {
        this.isBaseRateBusy = false;
      });
  }

  // Fees Calculations
  calculateFees() {
    CalHelper.calcFees(this.quoteForm)
      .then((data) => {
        this.quoteForm.applicationFee = data.applicationFee;
        this.quoteForm.maxApplicationFee = data.maxApplicationFee;
        this.quoteForm.dof = data.dof;
        this.quoteForm.maxDof = data.maxDof;
      })
      .catch((error) => {
        console.error(JSON.stringify(error, null, 2));
        //displayToast(this, "Calc Fees...", error, "error");
      })
      .finally(() => {
        //this.isBaseRateBusy = false;
      });
  }

  // -------------
  // Button events
  // -------------

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

    //if (results && Array.isArray(results) && results.length > 0) {
    // this.quoteResult = results[0];
    //}
    this.baseRateCalc();
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