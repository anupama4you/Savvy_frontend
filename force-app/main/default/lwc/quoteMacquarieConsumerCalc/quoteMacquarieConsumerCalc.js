import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { CalHelper } from "./quoteMacquarieConsumerCalcHelper";
import { QuoteCommons } from "c/quoteCommons";
import LENDER_LOGO from "@salesforce/resourceUrl/MacquarieLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import getQuotingTable from '@salesforce/apex/QuoteManager.getQuotingTable';
import getPickListValue from '@salesforce/apex/QuoteManager.getPickListValue';
import getDependentPickListValue from '@salesforce/apex/QuoteManager.getDependentPickListValue';

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteMoneyPlaceCalc extends LightningElement {
  isBusy; // loading
  isCalculated = false;
  tableRatesCols = CalHelper.tableRateDataColumns;
  @track messageObj = QuoteCommons.resetMessage();
  @track quoteForm;
  // Rate Settings
  @track tableRates = [];
  @api recordId; // Opportunity Id
  @wire(getRecord, { recordId: "$recordId", fields })
  opp;
  @track goodsTypeOptions;
  @track typeValue = "Value";
  @track goodsSubTypeOptions;
  @track loanFrequencyOptions;
  @track assetYearOptions;
  @track disableResidualPercentage = true;
  @track disableResidualValue = false;

  LENDER_QUOTING = "Macquarie Consumer";

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


    //Static picklist values
    //Asset Year
    getPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Asset Year' })
    .then(result => {
      let options = [];
      for (var key in result) {
          options.push({ label: result[key].label, value: result[key].value  });
      }
      this.assetYearOptions = options;
    })
    .catch(error => {
      console.log(error);
        this.error = error;
    });
    
    //Dynamic picklist values
    if(this.quoteForm != null && this.quoteForm != undefined){
      //Goods Type
      getDependentPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Goods Type', pickVal1: this.quoteForm.loanProduct, pickVal2: ''})
      .then(result => {
        let options = [];
        for (var key in result) {
            options.push({ label: result[key].label, value: result[key].value  });
        }
          this.quoteForm.goodsType= "";
          this.goodsTypeOptions = options;
      })
      .catch(error => {
        console.log(error);
          this.error = error;
      });
      //Goods SubType
      getDependentPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Goods SubType', pickVal1: this.quoteForm.loanProduct, pickVal2: this.quoteForm.goodsType})
        .then(result => {
          let options = [];
          for (var key in result) {
              options.push({ label: result[key].label, value: result[key].value  });
          }
            this.quoteForm.goodsSubType= "";
            this.goodsSubTypeOptions = options;
        })
        .catch(error => {
          console.log(error);
            this.error = error;
        });
        //Loan Frequency
        getDependentPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Loan Frequency', pickVal1: this.quoteForm.loanProduct, pickVal2: ''})
        .then(result => {
          let options = [];
          for (var key in result) {
              options.push({ label: result[key].label, value: result[key].value  });
          }
            this.quoteForm.loanFrequency= "";
            this.loanFrequencyOptions = options;
        })
        .catch(error => {
          console.log(error);
            this.error = error;
        });
    }
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

  get typeValueOptions() {
    return CalHelper.options.typeValues;
  }

  get propertyOwnerOptions(){
    return CalHelper.options.propertyOwners;
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
      // Type value
      if (fldName !== "typeValue") {
        this.quoteForm[fldName] = v;
      } else {
        this.typeValue = v;
      }
      // Residual Value Calculation
      if (CalHelper.RESIDUAL_VALUE_FIELDS.includes(fldName)) {
        this.residualCalc();
      }
    } catch (error) {
      console.error(error);
    }

    //Dynamic picklist values
    if(this.quoteForm != null && this.quoteForm != undefined){
      //Goods Type
      if(event.target.name == 'loanProduct'){
        getDependentPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Goods Type', pickVal1: this.quoteForm.loanProduct, pickVal2: ''})
        .then(result => {
          let options = [];
          for (var key in result) {
              options.push({ label: result[key].label, value: result[key].value  });
          }
            this.quoteForm.goodsType= "";
            this.goodsTypeOptions = options;
        })
        .catch(error => {
          console.log(error);
            this.error = error;
        });
      }
      //Goods SubType
      if(event.target.name == 'goodsType' || event.target.name == 'loanProduct'){
        getDependentPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Goods SubType', pickVal1: this.quoteForm.loanProduct, pickVal2: this.quoteForm.goodsType})
        .then(result => {
          let options = [];
          for (var key in result) {
              options.push({ label: result[key].label, value: result[key].value  });
          }
            this.quoteForm.goodsSubType= "";
            this.goodsSubTypeOptions = options;
        })
        .catch(error => {
          console.log(error);
            this.error = error;
        });
      }
      //Loan Frequency
      if(event.target.name == 'loanProduct'){
        getDependentPickListValue({ LENDER_QUOTING: this.LENDER_QUOTING, picklistName: 'Loan Frequency', pickVal1: this.quoteForm.loanProduct, pickVal2: ''})
        .then(result => {
          let options = [];
          for (var key in result) {
              options.push({ label: result[key].label, value: result[key].value  });
          }
            this.quoteForm.loanFrequency= "";
            this.loanFrequencyOptions = options;
        })
        .catch(error => {
          console.log(error);
            this.error = error;
        });
      }
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

  residualCalc() {
    console.log('residualCalc', this.typeValue);
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
}