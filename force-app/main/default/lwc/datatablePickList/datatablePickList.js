import { LightningElement, api } from "lwc";

export default class DatatablePickList extends LightningElement {
  @api label;
  @api placeholder;
  @api options;
  @api value;
  @api context;

  connectedCallback() {
    console.log("Options is " + JSON.stringify(this.options));
    console.log("Value is " + JSON.stringify(this.value));
  }

  handleChange(event) {
    //show the selected value on UI
    this.value = event.detail.value;

    //fire event to send context and selected value to the data table
    this.dispatchEvent(
      new CustomEvent("picklistchanged", {
        composed: true,
        bubbles: true,
        cancelable: true,
        detail: {
          data: { context: this.context, value: this.value }
        }
      })
    );
  }
}