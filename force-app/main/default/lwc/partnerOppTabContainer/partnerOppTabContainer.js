import { LightningElement, api } from 'lwc';

export default class PartnerOppTabContainer extends LightningElement {
  @api recordId;
  @api objectApiName = "Custom_Opportunity__c";
}