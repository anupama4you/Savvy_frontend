import { LightningElement, api } from 'lwc';

export default class SendSMSUsingMagic extends LightningElement {
    @api recordId;
    @api frameUrlNew;

    connectedCallback(){
        this.frameUrl = "https://savvydev--dev.my.salesforce.com/apex/Conversation_Custom_Opportunity?id="+this.recordId;
    }

}