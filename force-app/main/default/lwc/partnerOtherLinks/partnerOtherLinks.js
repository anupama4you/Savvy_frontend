import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class PartnerOtherLinks extends LightningElement {
  @track showModal = false;
  @track showNegativeButton;
  @track showPositiveButton = true;
  @track positiveButtonLabel = 'Close';

  handleCreatelead(event) {
    event.preventDefault();
    this.showModal = true;
    // const evt = new ShowToastEvent({
    //   title: `Create Lead button Click`,
    //   message: `Functionality not implemeted yet!`,
    //   variant: "warning"
    // });
    // this.dispatchEvent(evt);
  }

  closeModal() {
    this.showModal = false;
  }
}