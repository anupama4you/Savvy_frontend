import { LightningElement, api, track, wire } from 'lwc';
import {
  getRecord,
  getFieldValue,
} from "lightning/uiRecordApi";
import searchLenders from "@salesforce/apex/ComparisonToolsController.search";
import { displayToast } from "c/partnerJsUtils";
import { convertNumbers } from "c/comparisonToolUtils";

import NAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import CREDIT_SCORE_FIELD from "@salesforce/schema/Custom_Opportunity__c.Credit_Score__c";

const fields = [NAME_FIELD, CREDIT_SCORE_FIELD];
export default class ComparisonTool extends LightningElement {
  @api recordId;
  @track calcs;
  @track record;
  @track globalParams = {};

  filterParams;
  isSearching = false;

  @wire(getRecord, { recordId: "$recordId", fields })
  wireRecord({ error, data }) {
    if (data) {
      this.record = data;
      this.globalParams = {
        oppName: this.oppName,
        creditScore: this.creditScore
      };
      console.log(
        "🚀 ~ file: comparisonTool.js ~ line 26 ~ ComparisonTool ~ wireRecord ~ globalParams",
        JSON.stringify(this.globalParams, null, 2)
      );
    }
  }

  handleSearch(event) {
    this.isSearching = true;
    // console.log("🚀 ~ file: comparisonTool.js ~ line 7 ~ ComparisonTool ~ handleSearch ~ event", JSON.stringify(event.detail, null, 2));
    console.log(`searching...`);
    this.filterParams = event.detail;
    this.calcs = [];
    const p = convertNumbers(this.filterParams);
    // console.log(`p:`, JSON.stringify(p, null, 2));
    searchLenders({ params: p })
      .then((data) => {
        // console.log(
        //   "🚀 ~ file: comparisonTool.js ~ line 14 ~ ComparisonTool ~ searchLenders ~ data",
        //   JSON.stringify(data, null, 2)
        // );
        this.calcs = data;
        displayToast(
          this,
          "Success",
          `Calculators found: ${this.calcs.length}`,
          "success"
        );
      })
      .catch((error) => {
        console.error(JSON.stringify(error, null, 2));
        displayToast(this, "Error", error, "error");
      })
      .finally(() => {
        this.isSearching = false;
      });
  }

  get oppName() {
    return this.record ? getFieldValue(this.record, NAME_FIELD) : null;
  }

  get creditScore() {
    return this.record ? getFieldValue(this.record, CREDIT_SCORE_FIELD) : null;
  }

  get cardTitle() {
    let r = "Comparison Tool";
    r +=
      this.oppName && this.oppName != null && this.oppName.length > 0
        ? ` for ${this.oppName}`
        : "";
    return r;
  }
}