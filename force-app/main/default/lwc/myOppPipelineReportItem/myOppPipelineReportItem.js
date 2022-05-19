import { LightningElement, api } from 'lwc';

export default class MyOppPipelineReportItem extends LightningElement {
  @api oppList;

  get hasRecords() {
    return (this.oppList && this.oppList.length > 0? true : false);
  }
}