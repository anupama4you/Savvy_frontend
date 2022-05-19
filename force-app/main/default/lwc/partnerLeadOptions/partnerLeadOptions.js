import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import NAME_FIELD from "@salesforce/schema/Lead__c.Name";
import FNAME_FIELD from "@salesforce/schema/Lead__c.First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Lead__c.Last_Name__c";
import EMAIL_FIELD from "@salesforce/schema/Lead__c.Email_Address__c";
import MOBILE_FIELD from "@salesforce/schema/Lead__c.Mobile_Number__c";
import STATE_FIELD from "@salesforce/schema/Lead__c.State__c";
import convertToOpp from "@salesforce/apex/PartnerCommunityController.convertToOpportunity";

const fields = [
  NAME_FIELD,
  FNAME_FIELD,
  LNAME_FIELD,
  EMAIL_FIELD,
  MOBILE_FIELD,
  STATE_FIELD
];

export default class PartnerLeadOptions extends NavigationMixin(
  LightningElement
) {
  @api recordId;
  @track record;
  @track error;
  @track showModal = false;
  showSpinner;

  @wire(getRecord, { recordId: "$recordId", fields })
  wireRecord({ error, data }) {
    console.log (`wiring...`);
    if (data) {
      this.record = data;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.record = undefined;
    }
    console.log(JSON.stringify(this.record));
    console.log(JSON.stringify(this.error));
    console.log(
      `Record id: ${this.recordId} [${this.oppName}] > ${document.title}`
    );
  }

  get lead() {
    return {
      name: getFieldValue(this.record, NAME_FIELD),
      fname: getFieldValue(this.record, FNAME_FIELD),
      lname: getFieldValue(this.record, LNAME_FIELD),
      mobile: getFieldValue(this.record, MOBILE_FIELD),
      email: getFieldValue(this.record, EMAIL_FIELD),
      state: getFieldValue(this.record, STATE_FIELD)
    };
  }

  openConvertToOppModal(event) {
    this.showModal = true;
  }

  handleConvertSubmit(event){
    event.preventDefault(); // stop the form from submitting
    this.showSpinner = true;
    const formFields = event.detail.fields;
    formFields.Lead__c = this.recordId;
    console.log(JSON.stringify(formFields, null, 2));
    convertToOpp({ leadId: this.recordId, data: formFields })
      .then((data, error) => {
        const evt = new ShowToastEvent({
          title: "Opportunity created!",
          message: "Loading opportunity " + data.Name + "...",
          variant: "success"
        });
        this.dispatchEvent(evt);
        this.handleRecordNavigationClick(
          event,
          data.Id,
          "Custom_Opportunity__c"
        );
      })
      .catch((error) => {
        console.error(JSON.stringify(error, null, 2));
        const evt = new ShowToastEvent({
          title: "Error",
          message: "Opportunity could not created",
          variant: "error"
        });
        this.dispatchEvent(evt);
        this.showSpinner = false;
      });
    // this.template.querySelector('lightning-record-edit-form').submit(formFields);
  }

  handleConvertSuccess(event) {
    const rec = event.detail.fields;
    // console.log(JSON.stringify(payload));
    const evt = new ShowToastEvent({
      title: "Opportunity created!",
      message:
        "Redirecting to " +
        rec.Name.value +
        "...",
      variant: "success"
    });
    this.dispatchEvent(evt);
    // this.handleEditClose();
    this.handleRecordNavigationClick(event, rec.Id, "Custom_Opportunity__c");
  }

  handleConvertClose() {
    this.showModal = false;
    this.showSpinner = false;
  }

  handleRecordNavigationClick(event, recId, pageName) {
    event.stopPropagation();
    console.log(`Go to ${pageName}...`);
    const pageRef = {
      type: "standard__recordPage",
      attributes: {
        objectApiName: pageName,
        actionName: "view",
        recordId: recId
      }
    };
    // Navigate to the Account Home page.
    this[NavigationMixin.Navigate](pageRef);
    // this.displayToast(`Application Form`);
  }
}