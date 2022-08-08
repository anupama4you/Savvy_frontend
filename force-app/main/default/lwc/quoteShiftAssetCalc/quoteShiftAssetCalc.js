import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { Validations } from "./quoteValidations";
import { CalHelper } from "./quoteShiftAssetCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/ShiftLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteShiftAssetCalc extends LightningElement {
  isBusy;
  isBaseRateBusy;
  isCalculated = false;
  @api recordId; // Opportunity Id
  @track messageObj = QuoteCommons.resetMessage();
  @track quoteForm;
  @track typeValue = "Value";
  @track disableResidualPercentage = true;
  @track disableResidualValue = false;
  // Rate Settings
  @track assetRates1;
  @track assetRates2;
  @track tableData;
  @track addOnsList;
  @track commissionsList;
  @wire(getRecord, { recordId: "$recordId", fields })
  opp;
  // -

  connectedCallback() {
    console.log(`connectedCallback...`);
    this.isBusy = true;
    this.reset();
    CalHelper.load(this.recordId)
      .then((data) => {
        console.log(`Data loaded!`);
        this.quoteForm = data;
        this.tableData = CalHelper.getTableRatesData();
        console.log('@@tableOutput>>', JSON.stringify(this.tableData, null, 2));
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

  get clientTierOptions() {
    return CalHelper.options.clientTiers;
  }

  get abnLengthOptions() {
    return CalHelper.options.AbnLengths;
  }

  get propertyOwnerOptions() {
    return CalHelper.options.propertyOwners;
  }

  get gstLengthOptions() {
    return CalHelper.options.GstLengths;
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
    let fld = this.template.querySelector(`[data-id="${fldName}-field"]`);
    let v = event.detail ? event.detail.value : "";
    if (fld && fld.type === "number") {
      v = Number(v);
    }

    // Type value
    if (fldName !== "typeValue") {
      this.quoteForm[fldName] = v;
    } else {
      this.typeValue = v;
    }

    // if (fldName == "typeValue") {
    //   this.quoteForm['residualValuePercentage'] = 0.0;
    //   this.quoteForm['residualValue'] = 0.0;
    // }

    this.quoteForm[fldName] = v;
    this.quoteForm["netDeposit"] = this.netDeposit;
    fldName === "term"
      ? (this.quoteForm[fldName] = (v))
      : (this.quoteForm[fldName] = v);

    // --------------
    // Trigger events
    // --------------

    // Residual Value Calculation
    if (CalHelper.RESIDUAL_VALUE_FIELDS.includes(fldName)) {
      this.residualCalc();
    }
    // Base Rate Calculation
    if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
      this.baseRateCalc();
    }
    // Client Rate Calculation
    if (CalHelper.CLIENT_RATE_FIELDS.includes(fldName)) {
      this.clientRateCalc();
    }

    // --------------
  }

  // Calculations
  get netDeposit() {
    return CalHelper.getNetDeposit(this.quoteForm);
  }

  get netRealtimeNaf() {
    this.quoteForm.realtimeNaf = CalHelper.getNetRealtimeNaf(this.quoteForm);
    return this.quoteForm.realtimeNaf;
  }

  get disableAction() {
    return !this.isCalculated;
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
    this.quoteForm.endOfTerm = Number(this.quoteForm.assetAge) + Number(this.quoteForm.term) / 12;
    console.log('line 173 end of term', this.quoteForm.endOfTerm, this.quoteForm.assetAge, this.quoteForm.term);
    CalHelper.baseRates(this.quoteForm)
      .then((data) => {
        console.log(`baseRateCalc Data loaded!`);
        this.quoteForm.baseRate = data.baseRate;
        this.clientRateCalc();
      })
      .catch((error) => {
        console.error(JSON.stringify(error, null, 2));
        displayToast(this, "Base Rate Calculate...", error, "error");
      })
      .finally(() => {
        this.isBaseRateBusy = false;
      });
  }

  // Client Rate() 
  clientRateCalc() {
    let brokeragePercentage = this.quoteForm.brokeragePercentage > 0 ? this.quoteForm.brokeragePercentage : 0;
    let baseRate = this.quoteForm.baseRate > 0 ? this.quoteForm.baseRate : 0;
    this.quoteForm.clientRate = (brokeragePercentage * 0.5) + baseRate;
  }

  residualCalc() {
    if (this.typeValue === "Value") {
      this.disableResidualValue = false;
      this.disableResidualPercentage = true;
      if (this.quoteForm.residualValue > 0) {
        this.quoteForm.residualValuePercentage = CalHelper.getResidualPercentage(this.quoteForm);
      }
    } else {
      this.disableResidualValue = true;
      this.disableResidualPercentage = false;
      if (this.quoteForm.residualValuePercentage > 0) {
        this.quoteForm.residualValue = CalHelper.getResidualValue(this.quoteForm);
      }

    }
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
          "quotePepperMVCalc.js: get errors -- ",
          JSON.stringify(error.messages.errors, null, 2)
        );
      })
      .finally(() => {
        this.isBusy = false;
      });

    if (results && Array.isArray(results) && results.length > 0) {
      // this.quoteResult = results[0];
    }
    // this.baseRateCalc();
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