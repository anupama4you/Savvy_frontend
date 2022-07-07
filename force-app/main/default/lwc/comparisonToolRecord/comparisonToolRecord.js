import { LightningElement, api, track } from 'lwc';
import calculatePayments from "@salesforce/apex/ComparisonToolsController.calculate";
import { convertNumbers, lenderLogo } from "c/comparisonToolUtils";

export default class ComparisonToolRecord extends LightningElement {
  @api record;
  @api params;

  @track data = {};
  isCalculating = false;

  connectedCallback() {
    this.calculate();
  }

  calculate() {
    console.log(`Calculating:`, this.record.Name);
    this.isCalculating = true;
    // this.data = {};
    const c = JSON.parse(JSON.stringify(this.record));
    const p = convertNumbers(this.params);
    console.log(`param:`, JSON.stringify(this.params, null, 2));
    console.log(`p:`, JSON.stringify(p, null, 2));
    console.log(`invoking backend...`);
    // console.log(`calc:`, JSON.stringify(c));
    // console.log(`params:`, JSON.stringify(p));
    // calculatePayments({ calc: this.record, params: this.params })
    calculatePayments({ calc: c, params: p })
      .then((data) => {
        this.data = data;
        console.log(this.record.Name, `:`, JSON.stringify(data, null, 2));
      })
      .catch((err) => {
        console.error(this.record.Name, `:`, err);
      })
      .finally(() => {
        this.isCalculating = false;
      });
  }

  get logoUrl() {
    return lenderLogo(this.record.Lender__c);
  }

  handleCalculate(event) {
    this.calculate();
  }
}