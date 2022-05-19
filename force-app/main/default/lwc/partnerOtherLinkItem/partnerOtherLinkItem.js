import { LightningElement, api } from 'lwc';

export default class PartnerOtherLinkItem extends LightningElement {
  @api label;
  @api iconName;
  @api url;

  handleClick(event) {
    event.preventDefault();
    this.dispatchEvent(new CustomEvent("click"));
    // const evt = new ShowToastEvent({
    //   title: `Create Lead button Click`,
    //   message: `Functionality not implemeted yet!`,
    //   variant: "warning"
    // });
    // this.dispatchEvent(evt);
  }

  get isUrlLink() {
    return (this.url? true: false);
  }

  get isButtonLink() {
    return !this.isUrlLink;
  }

}