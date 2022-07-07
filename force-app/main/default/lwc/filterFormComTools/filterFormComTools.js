import { LightningElement, api } from 'lwc';
import { ComparisonOptions } from "./filterFormComToolsHelper";

export default class FilterFormComTools extends LightningElement {
  @api recordId;
  @api params;

  connectedCallback() {
    console.log(`this.params:`, JSON.stringify(this.params, null, 2));
    if (!this.params) {
      this.resetFormData();
    }
  }

  resetFormData() {
    this.params = {
      assetType: "Car",
      loanType: "Personal",
      employmentType: "Full-Time",
      purchaseType: "Dealer",
      creditHistory: "Excellent",
      assetAge: "0",
      term: "60",
      residentialStatus: "Property Owner",
      price: null,
      deposit: "0.00",
      residual: "0.00",
      hasPayday: "",
      hasVerifiableCredit: "",
      jobsLast3Years: "",
      hasEnquiries: "",
      creditScore: "",
      verifiableSavings: "",
      ltv: ""
    };

    this.template.querySelectorAll("lightning-combobox").forEach((each) => {
      each.value = this.params[each.name];
      console.log("cleaning combobox: ", each.name);
    });

    this.template.querySelectorAll("lightning-input").forEach((each) => {
      each.value = this.params[each.name];
      console.log("cleaning combobox: ", each.name);
    });
  }

  get assetTypeOptions() {
    return ComparisonOptions.assetTypes;
  }

  get loanTypeOptions() {
    return ComparisonOptions.loanTypes;
  }

  get employmentTypeOptions() {
    return ComparisonOptions.employmentTypes;
  }

  get purchaseTypeOptions() {
    return ComparisonOptions.purchaseTypes;
  }

  get creditHistoryOptions() {
    return ComparisonOptions.creditHistories;
  }

  get assetAgeOptions() {
    return ComparisonOptions.assetAge;
  }

  get loanTermOptions() {
    return ComparisonOptions.loanTerms;
  }

  get residentialStatusOptions() {
    return ComparisonOptions.residentialStatus;
  }

  get yesNoOptions() {
    return ComparisonOptions.yesNo;
  }

  get creditScoreOptions() {
    return ComparisonOptions.creditScores;
  }

  get savingOptions() {
    return ComparisonOptions.savings;
  }

  get ltvOptions() {
    return ComparisonOptions.ltvs;
  }

  get jobOptions() {
    return ComparisonOptions.jobs;
  }

  handleFieldChange(event) {
    this.params[event.target.name] = event.detail ? event.detail.value : "";
    console.log(`this.params:`, JSON.stringify(this.params));
  }

  handleSearch(event) {
    if (this.isValidForm() === true) {
      console.log(
        "🚀 ~ file: filterFormComTools.js ~ line 106 ~ FilterFormComTools ~ handleSearch ~ event"
      );
      const myEvent = new CustomEvent("search", {
        detail: this.params
      });
      this.dispatchEvent(myEvent);
    }
  }

  isValidForm() {
    let r = true;
    // Price
    if (!this.params.price || this.params.price.trim().length === 0) {
      r = false;
      let fld = this.template.querySelector(`[data-id="price-field"]`);
      fld.reportValidity();
    }
    
    return r;
  }
}