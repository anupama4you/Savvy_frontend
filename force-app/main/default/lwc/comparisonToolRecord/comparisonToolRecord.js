import { LightningElement, api, track } from 'lwc';
import calculatePayments from "@salesforce/apex/ComparisonToolsController.calculate";
import { convertNumbers, lenderLogo } from "c/comparisonToolUtils";

export default class ComparisonToolRecord extends LightningElement {
  @api record;
  @api params;

  @track data = {};
  isCalculating = false;

  form = {
    clientRate: undefined,
    dof: undefined,
    customValue1: undefined,
    customValue2: undefined,
    customLabel1: undefined,
    customLabel2: undefined
  };

  connectedCallback() {
    this.calculate();
  }

  calculate() {
    console.log(`Calculating:`, this.record.Name);
    this.isCalculating = true;
    // this.data = {};
    const c = JSON.parse(JSON.stringify(this.record));
    const p = convertNumbers(this.params);
    // Custom params
    p["customValue1"] = this.form.customValue1;
    p["customValue2"] = this.form.customValue2;
    p["customClientRate"] = this.form.clientRate;
    p["customDof"] = this.form.dof;
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
        this.form.clientRate = this.data.clientRate;
        this.form.dof = this.data.dof;
        this.form.customValue1 = this.data.customValue1;
        this.form.customValue2 = this.data.customValue2;
        this.form.customLabel1 = this.data.customLabel1;
        this.form.customLabel2 = this.data.customLabel2;
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

  get customValue1Options() {
    let opts = [];
    if (this.data && this.data.customValue1Options) {
      this.data.customValue1Options.forEach((v) => {
        opts.push({ label: v, value: v });
      });
    }
    return opts;
  }

  get displayCustomLabel() {
    return !this.displayCustomValue1;
  }

  get displayCustomValue1() {
    return this.form.customValue1;
  }

  handleFieldChange(event) {
    const fldName = event.target.name;
    this.form[fldName] = event.detail ? event.detail.value : "";
    console.log(`this.form:`, JSON.stringify(this.form));
    let fld = this.template.querySelector(`[data-id="${fldName}-field"]`);
    let v = event.detail ? event.detail.value : "";
    if (fld && fld.type === "number") {
      v = Number(v);
    } else {
      this.calculate();
    }
    console.log(`fld.type > `, fld.type);    
  }
}