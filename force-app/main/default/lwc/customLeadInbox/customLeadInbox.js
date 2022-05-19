import { LightningElement,api,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getUnassignedLead from '@salesforce/apex/PartnerCommunityController.getUnassignedLeadList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import OWNER_FIELD from '@salesforce/schema/Lead__c.OwnerId';
import Id from '@salesforce/user/Id';
import ID_FIELD from '@salesforce/schema/Lead__c.Id';

export default class NavigationExampleLWC extends NavigationMixin(LightningElement) {
  @api portalLeadUrl;
  leads;
  userId = Id;
  connectedCallback() {
    // this.currenRecordId = this.recordId;
    this.reloadLeads();
  }

  reloadLeads() {
    console.log(`Reloading leads...`);
    getUnassignedLead()
      .then((results) => {
        console.log(JSON.stringify(results));
        this.leads = results.map((result) => ({
          href: `${this.portalLeadUrl}/${result.Id}`,
          ...result
        }));
      })
      .catch((error) => {
        console.log("error:", error);
      })
      .finally(() => {
        console.log(`Leads reloaded!`);
      });
  }

  updateContact(event) {
    const fields = {};
    fields[OWNER_FIELD.fieldApiName] = this.userId;
    fields[ID_FIELD.fieldApiName] = event.target.dataset.recordId;
    const recordInput = { fields };
    console.log(recordInput);
    updateRecord(recordInput)
      .then(() => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "lead updated",
            variant: "success"
          })
        );
        // Display fresh data in the form
        return refreshApex(this.leads);
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error updating  record",
            message: error.body.message,
            variant: "error"
          })
        );
      })
      .finally(() => this.reloadLeads());
  }

  handleListViewNavigation() {
    // Navigate to the Accounts object's Recent list view.
    this[NavigationMixin.Navigate]({
      type: "standard__objectPage",
      attributes: {
        objectApiName: "Lead__c",
        actionName: "list"
      },
      state: {
        filterName: "00BN0000000tSV5MAM"
      }
    });
  }

  enquireHandler() {}

}