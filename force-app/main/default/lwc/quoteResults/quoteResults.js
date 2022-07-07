import { LightningElement, api } from 'lwc';
import { QuoteCommons } from "c/quoteCommons";

export default class QuoteResults extends LightningElement {

  @api results;

  connectedCallback() {
    if (!this.results) {
      this.results = QuoteCommons.resetResults();
    }
  }

}