import { LightningElement, api } from 'lwc';

export default class ComparisonToolResult extends LightningElement {
  @api params;
  @api records;

  formData = {
    clientRate: 0.00,
    dof: undefined
  };

  get hasRecords() {
    return this.records && this.records.length > 0;
  }

  handleChange(event) {
    this.formData.clientRate = event.detail.value;
  }

}