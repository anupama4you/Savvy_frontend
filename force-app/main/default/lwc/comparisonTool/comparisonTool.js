import { LightningElement, api } from 'lwc';
import searchLenders from "@salesforce/apex/ComparisonToolsController.search";
import { displayToast } from "c/partnerJsUtils";
import { convertNumbers } from "c/comparisonToolUtils";

export default class ComparisonTool extends LightningElement {
  @api recordId;

  filterParams;
  calcs;
  isSearching = false;

  handleSearch (event) {
    this.isSearching = true;
    // console.log("🚀 ~ file: comparisonTool.js ~ line 7 ~ ComparisonTool ~ handleSearch ~ event", JSON.stringify(event.detail, null, 2));
    console.log(`searching...`);
    this.filterParams = event.detail;
    this.calcs = [];
    const p = convertNumbers(this.filterParams);
    console.log(`p:`, JSON.stringify(p, null, 2));
    searchLenders({params: p}).then(data => {
      console.log("🚀 ~ file: comparisonTool.js ~ line 14 ~ ComparisonTool ~ searchLenders ~ data", JSON.stringify(data, null, 2));
      this.calcs = data;
      displayToast(this, "Success", `Calculators found: ${this.calcs.length}`, "success");
    }).catch( error => {
      console.error(JSON.stringify(error, null, 2));
      displayToast(this, "Error", error, "error");
    }).finally (() => {
      this.isSearching = false;
    });
    
  };




}