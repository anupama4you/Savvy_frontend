import { LightningElement, track } from "lwc";

export default class PartnerNewLeadButton extends LightningElement {
  @track showModal = false;
  @track showNegativeButton;
  @track showPositiveButton = true;
  @track positiveButtonLabel = 'Close';
  
  closeModal() {
    this.showModal = false;
  }

  showModalPopup() {
    this.showModal = true;
  }
}