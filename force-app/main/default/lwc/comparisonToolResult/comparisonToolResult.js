import { LightningElement, api, track } from "lwc";

export default class ComparisonToolResult extends LightningElement {
  @api params;

  @api get records() {
    return this.myRecords;
  }

  set records(value) {
    this.setAttribute("records", value);
    this.myRecords = value;
    this.loadCalculations();
  }

  myRecords;

  @track formData = {
    clientRate: 2.0,
    frequency: "M",
    sortBy: "clientRate",
    recalculate: false
  };

  calculations;
  countCompleted = 0;
  parityNumber = 0;

  connectedCallback() {
    console.log(`comparisonToolResult connectedCallback...`);
  }

  loadCalculations() {
    this.calculations = new Map();
    if (this.records) {
      this.records.forEach((e) => {
        this.calculations.set(e.Id, { calc: e, result: {} });
      });
    }
    this.sortTable();
    console.log(`loadCalculations...`, this.calculations.size);
  }

  get hasRecords() {
    // console.log(
    //   `this.calculations`,
    //   this.calculations ? this.calculations.size : "NaN"
    // );
    return this.recordData && this.recordData.length > 0;
    // return this.calculations && this.calculations.size > 0;
  }

  handleChange(event) {
    this.formData.clientRate = event.detail.value;
    console.log("🚀 ~ file: comparisonToolResult.js ~ line 55 ~ ComparisonToolResult ~ handleChange ~ this.formData", JSON.stringify(this.formData));
  }

  handleChangeSortBy(event) {
    this.formData.sortBy = event.detail.value;
    this.sortTable();
  }

  handleChangeFrequency(event) {
    this.formData.frequency = event.detail.value;
    console.log(`formData.frequency: `, this.formData.frequency);
  }

  get frequencyOptions() {
    return [
      { label: "M", value: "M" },
      { label: "F", value: "F" },
      { label: "W", value: "W" }
    ];
  }

  get sortByOptions() {
    return [
      { label: "Client Rate", value: "clientRate" },
      { label: "Payment", value: "monthlyPayment" },
      { label: "T/Comms", value: "totalCommission" }
    ];
  }

  get displayClientRate() {
    return this.params && this.params.loanType === "Personal";
  }

  handleRecalculate(event) {
    console.log(`handleRecalculating...`);
    // this.formData.recalculate = true;
    const recs = this.template.querySelectorAll(
      "c-comparison-tool-record"
    );
    recs.forEach((rec) => {
      rec.calculate();
    });
  }

  handleCompletedCalculation(event) {
    console.log(`Completed: `, JSON.stringify(event.detail));
    const d = event.detail;
    const o = this.calculations.get(d.calcId);
    // if (o == undefined) {
    //   this.calculations.set(d.calcId, { calc: e, result: {} });
    // }
    o.result = d.result;
    this.countCompleted += 1;
    if (this.calculations && this.calculations.size === this.countCompleted) {
      this.formData.recalculate = false;
      this.sortTable();
    }
  }

  sortTable() {
    console.log(`sortTable...`);

    const emptyCals = new Map();
    const cals = new Map();
    this.calculations.forEach((e) => {
      if (e.result.rental > 0.00) {
        cals.set(e.calc.Id, e);
      } else {
        emptyCals.set(e.calc.Id, e);
      }
    });

    const sortNumAsc = new Map(
      [...cals].sort((a, b) => {
        const v1 =
          a[1].result && a[1].result[`${this.formData.sortBy}`] > 0
            ? a[1].result[`${this.formData.sortBy}`]
            : 0.0;
        const v2 =
          b[1].result && b[1].result[`${this.formData.sortBy}`] > 0
            ? b[1].result[`${this.formData.sortBy}`]
            : 0.0;
        // v1 = v1 > 0 ? v1 : 1000000;
        // v2 = v2 > 0 ? v2 : 1000000;
        return v1 - v2;
      })
    );

    sortNumAsc.forEach((e) => {
      console.log(e.calc.Name, e.result[`${this.formData.sortBy}`]);
    });

    this.calculations = new Map([...sortNumAsc, ...emptyCals]);

    this.countCompleted = 0;
  }

  get recordData() {
    let r = new Array();
    this.calculations.forEach((e) => r.push(e.calc));
    return r;
    // return this.myRecords;
  }
}