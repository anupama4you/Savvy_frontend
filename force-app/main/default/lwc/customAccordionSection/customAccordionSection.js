import { LightningElement, api } from "lwc";

export default class CustomAccordionSection extends LightningElement {
  @api label;
  open = false;

  get sectionClass() {
    return this.open
      ? "slds-accordion__section slds-is-open"
      : "slds-accordion__section";
  }

  handleClick() {
    this.open = !this.open;
  }
}