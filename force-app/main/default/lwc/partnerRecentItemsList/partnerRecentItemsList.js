import { LightningElement, wire, api } from "lwc";
import getRecentItems from "@salesforce/apex/PartnerCommunityController.getRecentItems";

const COLS = [
  { label: "Name", fieldName: "Name", editable: false }
  // { label: "Loan Type", fieldName: "Loan_Type__c", editable: true }
];

export default class PartnerRecentItemsList extends LightningElement {
  _numItemsToShow = 5;
  @api
  set numRecords(value) {
    console.log(`numRecords set property: ${value}`);
    this._numItemsToShow = value;
  }
  get numRecords() {
    this._numItemsToShow;
  }

  columns = COLS;

  @wire(getRecentItems, { numItems: 10 })
  myRecords;

  get totalRecords() {
    return this.myRecords ? this.myRecords.length : "no records";
  }
}