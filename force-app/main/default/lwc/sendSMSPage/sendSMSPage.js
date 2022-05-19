import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
export default class sendSMSPage extends LightningElement {
    @api recordId;
    frameUrlNew;
    connectedCallback() {
        console.log('123--->'+this.recordId);
        this.frameUrlNew = "https://savvydev--dev.my.salesforce.com/apex/Conversation_Custom_Opportunity?id="+this.recordId
    }
}