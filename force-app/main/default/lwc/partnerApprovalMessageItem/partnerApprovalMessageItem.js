import { LightningElement, api } from 'lwc';

export default class PartnerApprovalMessageItem extends LightningElement {
  @api title;
  @api messages;
  @api iconName = "";
  @api variant = "error";

  get textStyle() {
    return `slds-text-color_${this.variant}`;
  }
}