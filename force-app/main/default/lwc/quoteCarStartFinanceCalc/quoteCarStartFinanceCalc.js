import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { Validations } from "./quoteValidations";
import { CalHelper } from "./quoteCarStartFinanceCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/CarStartFinanceLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteCarStartFinanceCalc extends LightningElement {
  tableRatesCols = CalHelper.tableRateDataColumns;
  isBusy;
  isBaseRateBusy;
  isCalculated = false;
  @api recordId; // Opportunity Id
  @track messageObj = QuoteCommons.resetMessage();
  @track quoteForm;
  // Rate Settings
  @track tableRates = [];
  @wire(getRecord, { recordId: "$recordId", fields })
  opp;
  // -

  // --- Insurance ---
  @track insuranceIncome;
  // --- Insurance: end ---

  connectedCallback() {
    console.log(`connectedCallback... ${this.opp.data}`);
    this.isBusy = true;
    this.reset();
    CalHelper.load(this.recordId)
      .then((data) => {
        console.log(`Data loaded!`);
        this.quoteForm = data;
        this.tableRates = CalHelper.getTableRatesData();
        console.log(`tableData!`, JSON.stringify(this.tableRates, null, 2));
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

  get termOptions() {
    return CalHelper.options.terms;
  }

  get privateSalesOptions() {
    return CalHelper.options.privateSales;
  }

  get loanTypeDetailOptions() {
    return CalHelper.options.loanTypeDetailOptions;
  }

  // Additional display options 
  get isValidMaxRate() {
    return this.quoteForm.maxRate && this.quoteForm.maxRate != 0 ? true : false;
  }

  get isValidMaxRiskFee() {
    return this.quoteForm.maxRiskFee && this.quoteForm.maxRiskFee != 0 ? true : false;
  }

  get isValidMaxDof() {
    return this.quoteForm.maxDof && this.quoteForm.maxDof != 0 && this.quoteForm.maxDof != null ? true : false;
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
      this.baseRateCalc();
    }

    console.log('quoteForm>>', JSON.stringify(this.quoteForm, null, 2))

    // Insurances
    QuoteCommons.calculateInsurances(this, fldName);
    // --------------
  }

  // Calculations
  get netDeposit() {
    return CalHelper.getNetDeposit(this.quoteForm);
  }

  get netRealtimeNaf() {
    this.quoteForm["realtimeNaf"] = CalHelper.getNetRealtimeNaf(this.quoteForm) + this.quoteForm.riskFee;
    return this.quoteForm["realtimeNaf"];
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
    CalHelper.baseRates(this.quoteForm)
      .then((data) => {
        console.log(`Data loaded!`, JSON.stringify(data, null, 2));
        this.quoteForm.baseRate = data.baseRate;
        this.quoteForm.maxRate = data.maxRate;
        if (this.quoteForm.loanTypeDetail) {
          const result = this.tableRates.filter(data => data.Type_of_Finance__c == this.quoteForm.loanTypeDetail);
          this.quoteForm.maxDof = result[0].Dof_Max__c ? result[0].Dof_Max__c : null;
          this.quoteForm.maxApplicationFee = result[0].App_Fee__c;
          this.quoteForm.maxRiskFee = result[0].Risk_Fee_Max__c;
          // extra values needed for validations
          this.quoteForm.MonthlyFeeRate = result[0].Monthly_Fee__c;
          this.quoteForm.riskFeeRate = result[0].Risk_Fee__c;
          this.quoteForm.minLoanRate = result[0].Min_Loan__c;
          this.quoteForm.maxLoanRate = result[0].Max_Loan__c;
          this.quoteForm.dofRate = result[0].Dof__c;
        } else {
          this.quoteForm.maxDof = null;
          this.quoteForm.maxApplicationFee = null;
          this.quoteForm.maxRiskFee = null;
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

  // -------------
  // Button events
  // -------------

  // Calculate
  handleCalculate(type) {
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
            "quotePepperMVCalc.js: get errors -- ",
            JSON.stringify(error.messages.errors, null, 2)
          );
        }
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
    console.log(
      "🚀 ~ file: QuotePepperMVCalc.js ~ line 172 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
      JSON.stringify(this.quoteForm, null, 2)
    );
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
    console.log("save type => ", loanType);
    this.isBusy = true;
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
    console.log('handlePresentation>>')
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
      "handleInsuanceLoad>>",
      JSON.stringify(this.quoteForm, null, 2)
    );
  }

  handleDisableButton(event) {
    this.isCalculated = event.detail;
  }


  // --- insurance: end ---

}