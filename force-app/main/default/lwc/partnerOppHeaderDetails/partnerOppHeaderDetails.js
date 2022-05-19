import { LightningElement, api, wire, track } from "lwc";
import {
  getRecord,
  getFieldValue,
  getFieldDisplayValue
} from "lightning/uiRecordApi";
import { NavigationMixin } from "lightning/navigation";
import cloneOpportunity from "@salesforce/apex/PartnerCommunityController.cloneOpportunity";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import PLENDER_FIELD from "@salesforce/schema/Custom_Opportunity__c.Opp_Product_Lender__c";
import COMM_FIELD from "@salesforce/schema/Custom_Opportunity__c.Total_Commission__c";
import MOBILE_FIELD from "@salesforce/schema/Custom_Opportunity__c.Mobile_Number__c";
import EMAIL_FIELD from "@salesforce/schema/Custom_Opportunity__c.Email_Address__c";

const fields = [
  OPPNAME_FIELD,
  FNAME_FIELD,
  LNAME_FIELD,
  PLENDER_FIELD,
  COMM_FIELD,
  MOBILE_FIELD,
  EMAIL_FIELD
];

export default class PartnerOppHeaderDetails extends NavigationMixin(LightningElement) {
  @api recordId;
  @api showCloneBtn;
  @track displayComp = false;
  oppUrl;
  showSpinner = false;
  showCloneModal = false;

  @wire(getRecord, { recordId: "$recordId", fields })
  opp;

  connectedCallback() {
    if (this.recordId && this.recordId != null && this.recordId != "null") {
      this.displayComp = true;
    }
    if (this.recordId) {
      const pageRef = {
        type: "standard__recordPage",
        attributes: {
          objectApiName: "Custom_Opportunity__c",
          actionName: "view",
          recordId: this.recordId
        }
      };
      this[NavigationMixin.GenerateUrl](pageRef)
        .then((url) => {
          this.oppUrl = url;
        })
        .catch((err) => console.log(err));
    }
  }

  get fullName() {
    let fn = "";
    let t = getFieldValue(this.opp.data, FNAME_FIELD);
    fn += t && t.trim().length > 0 ? t : "";
    fn += " ";
    t = getFieldValue(this.opp.data, LNAME_FIELD);
    fn += t && t.trim().length > 0 ? t : "";
    return fn;
  }

  get oppName() {
    return getFieldValue(this.opp.data, OPPNAME_FIELD);
  }

  get lender() {
    return getFieldValue(this.opp.data, PLENDER_FIELD);
  }

  get comm() {
    return getFieldDisplayValue(this.opp.data, COMM_FIELD);
  }

  get mobile() {
    return getFieldValue(this.opp.data, MOBILE_FIELD);
  }

  get email() {
    return getFieldValue(this.opp.data, EMAIL_FIELD);
  }

  handleCloneClick() {
    this.showCloneModal = true;
  }

  handleCloneClose() {
    this.showCloneModal = false;
  }

  handleCloneYesClick(event) {
    console.log(`Cloning the opportunity...`);
    this.showSpinner = true;
    cloneOpportunity({ oppId: this.recordId })
      .then((data) => {
        console.log(`data:`, data);
        const evt = new ShowToastEvent({
          title: "Opportunity created!",
          message: "Loading cloned " + this.oppName + "'s opportunity...",
          variant: "success"
        });
        this.dispatchEvent(evt);
        this.handleRecordNavigationClick(
          event,
          data,
          "Custom_Opportunity__c"
        );
      })
      .catch((error) => {
        console.error(JSON.stringify(error, null, 2));
        let errMsg = `Cloning opportunity has failed. `;
        if (error && error.body) {
          errMsg += error.body.message;
        }
        const evt = new ShowToastEvent({
          title: "Error",
          message: errMsg,
          variant: "error"
        });
        this.dispatchEvent(evt);
      }).finally (() => {
        this.showSpinner = false;
        this.handleCloneClose();
      });
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