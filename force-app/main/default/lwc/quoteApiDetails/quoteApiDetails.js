import { LightningElement, api } from "lwc";

export default class QuoteApiDetails extends LightningElement {
  @api responses;
  @api applicationIdLabel;
  @api hideMessage;

  get idLabel() {
    return this.applicationIdLabel && this.applicationIdLabel.length > 0
      ? this.applicationIdLabel
      : "Application Number";
  }

  get response() {
    return this.responses && this.responses.length > 0
      ? this.responses[0]
      : { Application_ID__c: null, CreatedDate: null, Message__c: null };
  }

  get displayMessage() {
    return !this.hideMessage;
  }

}