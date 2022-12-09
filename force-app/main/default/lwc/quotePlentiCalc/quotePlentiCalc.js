import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quotePlentiCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/PlentiLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import getRateSetterRate from "@salesforce/apex/QuoteManager.getRateSetterRate";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];
export default class QuotePlentiCalc extends LightningElement {
  tableRatesCols = CalHelper.tableRateDataColumns;
  isBusy;
  isBaseRateBusy;
  isCalculated = false;
  @api recordId; // Opportunity Id
  @track messageObj = QuoteCommons.resetMessage();
  @track quoteForm;
  // Rate Settings
  @track tableRates;
  // Api details
  @track apiDetails = [];
  @wire(getRecord, { recordId: "$recordId", fields })
  opp;

  connectedCallback() {
    this.isBusy = true;
    this.reset();
    CalHelper.load(this.recordId)
      .then((data) => {
        this.quoteForm = data;
        this.tableRates = CalHelper.getTableRatesData();
        this.apiDetails = CalHelper.getApiResponses();

        this.messageObj = data.messages;
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
    return CalHelper.options.terms;
  }

  get customerProfileOptions() {
    return CalHelper.options.customerProfiles;
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

  get vehicleYearOptions() {
    return CalHelper.options.vehicleYears;
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
    // --------------
    // Trigger events
    // --------------

    // Base Rate Calculation
    if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
      console.log("==> SHOOT HERE Base Rate Calculation handlefieldchange");
      this.baseRateCalc();
    }

    // Fees Calculation
    if (CalHelper.CALC_FEES_FIELDS.includes(fldName)) {
      console.log(
        "==> SHOOT HERE CALC_FEES_FIELDS Calculation handlefieldchange"
      );
      this.calculateFees();
    }

    //CommRate
    getRateSetterRate({ param: this.quoteForm })
      .then((param) => {
        console.log("getRateSetterRate==>" + param.commRate.toString());
        this.quoteForm.commRate = param.commRate;
      })
      .catch((error) => reject(error));

    // Insurances
    QuoteCommons.calculateInsurances(this, fldName);
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
    this.messageObj = QuoteCommons.resetMessage();
    console.log(
      "🚀 ~ file: QuotePlentiCalc.js ~ line 172 ~ QuotePlentiCalc ~ reset ~ this.quoteForm",
      JSON.stringify(this.quoteForm, null, 2)
    );
  }

  // Base Rate
  baseRateCalc() {
    this.isBaseRateBusy = true;
    CalHelper.baseRates(this.quoteForm)
      .then((data) => {
        //console.log(`Data loaded!`);
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

  // Fees Calculations
  calculateFees() {
    this.quoteForm.maxApplicationFee = CalHelper.calcFees(this.quoteForm);
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
            this.messageObj = error.messages;
            QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
            console.error(
              "quotePlentiCalc.js: get errors -- ",
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

  // all Save Buttons actions - CURRENTLY DISABLE DUE UNFINISHED COMMON COMPS
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
      console.log('this.messageObj in saving: ', JSON.stringify(this.messageObj, null, 2));
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
          if (isNONE && data.Goods_type__c === "Motorbikes") {
            this.messageObj.warnings.push({
              field: "confirms",
              message: "Only credit files > 12 months and active credit in last 12 months considered."
            });
          }
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

  handleInsuranceLoad(event) {
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
      "handleInsuranceLoad>>",
      JSON.stringify(this.quoteForm, null, 2)
    );
  }

  handleDisableButton(event) {
    this.isCalculated = event.detail;
  }

  // --- insurance: end ---
}