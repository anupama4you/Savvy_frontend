import { LightningElement, api } from 'lwc';

export default class CurrencyOutputItem extends LightningElement {
    @api value;
    connectedCallback() {
        console.log(`load component successfully`);
        console.log(`api is ${this.value}`);
    }
}