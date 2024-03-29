import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import calculatePayments from "@salesforce/apex/ComparisonToolsController.calculate";
import {
  convertNumbers,
  lenderLogo,
  getQuotingPage
} from "c/comparisonToolUtils";

export default class ComparisonToolRecord extends NavigationMixin(LightningElement) {
  @api recordId;
  @api record;
  @api params;
  @api get options() {
    return this.myOptions;
  }

  set options(value) {
    console.log(
      "🚀 ~ file: comparisonToolRecord.js ~ line 14 ~ ComparisonToolRecord ~ setoptions ~ value",
      JSON.stringify(value, null, 2)
    );
    this.setAttribute("options", value);
    this.myOptions = value;
    if (this.myOptions && this.myOptions.recalculate === true) {
      this.calculate();
    }
  }

  @track data = {};

  myOptions;
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

  @api calculate() {
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
    p["clientRateFactor"] = this.myOptions.clientRate;
    console.log(`Record params:`, JSON.stringify(this.params, null, 2));
    // console.log(`p:`, JSON.stringify(p, null, 2));
    // console.log(`invoking backend...`);
    // console.log(`calc:`, JSON.stringify(c));
    // console.log(`params:`, JSON.stringify(p));
    // calculatePayments({ calc: this.record, params: this.params })
    calculatePayments({ calc: c, params: p })
      .then((data) => {
        this.data = data;
        // console.log(this.record.Name, `:`, JSON.stringify(data, null, 2));
        this.form.clientRate = this.data.clientRate;
        this.form.dof = this.data.dof;
        this.form.customValue1 = this.data.customValue1;
        this.form.customValue2 = this.data.customValue2;
        this.form.customLabel1 = this.data.customLabel1;
        this.form.customLabel2 = this.data.customLabel2;

        this.dispatchEvent(
          new CustomEvent("completed", {
            detail: {
              calcId: this.record.Id,
              calcName: this.record.Name,
              result: this.data
            }
          })
        );
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

  handleOpenCalculator(event) {
    // this.calculate();
    console.log(`handleOpenCalculator...`);
    let pageRef = getQuotingPage(this.recordId, this.oppName, this.record.Name, undefined);
    console.log("🚀 ~ file: comparisonToolRecord.js ~ line 106 ~ ComparisonToolRecord ~ handleOpenCalculator ~ pageRef", JSON.stringify(pageRef, null, 2));
    
    this[NavigationMixin.Navigate](pageRef);
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

  get displayBreakCost() {
    return (
      this.record &&
      this.record.Break_Costs__c &&
      this.record.Break_Costs__c.length > 0
    );
  }

  get displayDocIcon() {
    return (
      this.record &&
      this.record.Document_Id__c &&
      this.record.Document_Id__c.length > 0
    );
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

  get payment() {
    let r = 0.0;
    if (this.data && this.data.monthlyPayment > 0.0) {
      r = this.data.monthlyPayment;
      if (this.myOptions) {
        if (this.myOptions.frequency === "F") {
          r = this.data.fortnightlyPayment;
        } else if (this.myOptions.frequency === "W") {
          r = this.data.weeklyPayment;
        }
      }
    }
    return r;
  }

  get oppName() {
    return this.params && this.params.oppName ? this.params.oppName : null;
  }

}