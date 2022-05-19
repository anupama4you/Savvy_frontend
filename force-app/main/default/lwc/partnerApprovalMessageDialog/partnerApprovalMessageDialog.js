import { LightningElement, api } from 'lwc';

export default class PartnerApprovalMessageDialog extends LightningElement {
  @api showModal;
  @api results;

  handleClose() {
    this.dispatchEvent(new CustomEvent("close"));
  }
}