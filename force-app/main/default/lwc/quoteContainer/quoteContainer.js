import { LightningElement, api } from "lwc";

export default class QuoteContainer extends LightningElement {
  @api title;
  @api isBusy;
  @api commissions;
  @api messages;
}