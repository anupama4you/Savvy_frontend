import { LightningElement, api, track } from 'lwc';
import { ComparisonOptions } from "./filterFormComToolsHelper";
import getInitialParamsById from "@salesforce/apex/ComparisonToolsController.getInitialParamsById";

export default class FilterFormComTools extends LightningElement {
  @api get recordId() {
    return this.myRecordId;
  }
  set recordId(value) {
    this.myRecordId = value;
    console.log(`Filters - recordId:`, this.myRecordId)
  }

  @api get globalParams() {
    return this.myGlobalParams;
  }
  set globalParams(value) {
    this.setAttribute("globalParams", value);
    this.myGlobalParams = value;
    this.loadGlobalParams();
  }

  myRecordId;
  myGlobalParams;
  @track params = this.resetFormData();

  connectedCallback() {
    console.log(`this.params 1:`, JSON.stringify(this.params, null, 2));
    console.log(
      `this.globalParams 1:`,
      JSON.stringify(this.globalParams, null, 2)
    );
    this.loadData();
    // if (!this.params) {
    //   this.resetFormData();
    // }
    // console.log(`this.params 2:`, JSON.stringify(this.params, null, 2));
  }

  loadData() {
    console.log(`filter - loadData...`, this.recordId);
    if (this.recordId) {
      getInitialParamsById({ oppId: this.recordId })
        .then((data) => {
          console.log("data:", JSON.stringify(data, null, 2));
          if (data) {
            Object.keys(data).forEach((v) => {
              // console.log(v, ': ', data[`${v}`]);
              this.params[`${v}`] = `${data[`${v}`]}`;
            });
          }
          if (this.params.loanType === 'Business' && !data.assetType) {
            this.params.assetType = 'Cars';
          }
        })
        .catch((error) => {
          console.error(error);
        });
    }
  }

  resetFormData() {
    return {
      assetType: "Car",
      loanType: "Personal",
      employmentType: "Full-Time",
      purchaseType: "Dealer",
      creditHistory: "Good",
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
      creditScore: "853 - 1200",
      realCreditScore: null,
      verifiableSavings: "",
      ltv: "",
      abnLength: "0",
      gstRegistered: "N",
      paydays: null,
      oppName: null
    };

    // this.template.querySelectorAll("lightning-combobox").forEach((each) => {
    //   each.value = this.params[each.name];
    //   console.log("cleaning combobox: ", each.name);
    // });

    // this.template.querySelectorAll("lightning-input").forEach((each) => {
    //   each.value = this.params[each.name];
    //   console.log("cleaning combobox: ", each.name);
    // });
  }

  get assetTypeOptions() {
    return this.isBusiness
      ? ComparisonOptions.businessAssetTypes
      : ComparisonOptions.assetTypes;
  }

  get loanTypeOptions() {
    return ComparisonOptions.loanTypes;
  }

  get employmentTypeOptions() {
    return this.isBusiness
      ? ComparisonOptions.businessEmploymentTypes
      : ComparisonOptions.employmentTypes;
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

  get isBusiness() {
    return this.params.loanType === "Business";
  }

  get abnLengthOptions() {
    return ComparisonOptions.abnLengths;
  }

  get gstRegisteredOptions() {
    return ComparisonOptions.gstRegisteredOptions;
  }

  get paydaysOptions() {
    return ComparisonOptions.paydays;
  }

  handleFieldChange(event) {
    console.log(
      `handleFieldChange...`,
      event.target.name,
      event.detail.value,
      this.params[`${event.target.name}`]
    );
    this.params[`${event.target.name}`] = event.detail
      ? event.detail.value
      : "";
    if (event.target.name === "loanType") {
      this.params.assetType =
        event.detail.value === "Business" ? "Cars" : "Car";
      this.params.employmentType =
        event.detail.value === "Business" ? "Self-Employed" : "Full-Time";
    }
    console.log(`this.params:`, JSON.stringify(this.params, null, 2));

    // this.params = [...this.params];
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

  handleReset(event) {
    this.params = this.resetFormData();
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

  loadGlobalParams() {
    if (this.params && this.myGlobalParams) {
      if (
        this.myGlobalParams.creditScore &&
        this.myGlobalParams.creditScore > 0
      ) {
        this.params.realCreditScore = this.myGlobalParams.creditScore;
        this.params.creditScore = ComparisonOptions.getCreditScoreValue(
          this.params.realCreditScore
        );
      }
      if (this.myGlobalParams.oppName) {
        this.params.oppName = this.myGlobalParams.oppName;
      }
    }
  }

  get creditScoreLabel() {
    let v = "Credit Score";
    if (
      this.myGlobalParams.creditScore &&
      this.myGlobalParams.creditScore > 0
    ) {
      v += " (" + this.myGlobalParams.creditScore + ")";
    }
    return v;
  }

  get disableCreditScore() {
    return this.params.realCreditScore > 0;
  }
}