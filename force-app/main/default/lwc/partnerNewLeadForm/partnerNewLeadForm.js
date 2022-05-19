import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import convertToOpp from "@salesforce/apex/PartnerCommunityController.convertToOpportunity";

export default class PartnerNewLeadForm extends NavigationMixin(
  LightningElement
) {
  @api showPositive;
  @api showNegative;
  @api positiveButtonLabel = "Save";
  @api negativeButtonLabel = "Cancel";
  @api showModal;
  buttonName="";
  showSpinner = false;

  creditHistory = "";

  constructor() {
    super();
    this.showNegative = true;
    this.showPositive = true;
    this.showModal = false;
  }

  handlePositive() {
    this.dispatchEvent(new CustomEvent("positive"));
  }

  handleNegative() {
    this.dispatchEvent(new CustomEvent("negative"));
  }

  handleClose() {
    this.dispatchEvent(new CustomEvent("close"));
  }

  handleSuccess(event) {
    const rec = event.detail.fields;
    console.log(`Lead created! ${event.detail.id}`);
    console.log(`${JSON.stringify(event.detail)}`);
    console.log(`Preparing opportunity data...`);
    const fields = {
      Name: rec.Name.value,
      First_Name__c: rec.First_Name__c.value,
      Status__c: "Become Opportunity",
      Last_Name__c: rec.Last_Name__c.value,
      Mobile_Number__c: rec.Mobile_Number__c.value,
      Email_Address__c: rec.Email_Address__c.value,
      Lead__c: event.detail.id,
    };
    console.log(`${JSON.stringify(fields)}`);
    // Convert to Opportinity
    if(this.buttonName === "mySaveConButton"){
      convertToOpp({ leadId: event.detail.id, data: fields })
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

    }

    if(this.buttonName === "mySaveButton"){
      const evt = new ShowToastEvent({
        title: "Lead created!",
        message: "Loading lead... ",
        variant: "success"
      });
      this.dispatchEvent(evt);
      this.handleRecordNavigationClick(
          event,
          event.detail.id,
          "Lead__c"
        );
    }
    
    // console.log(JSON.stringify(payload));
    // const evt = new ShowToastEvent({
    //   title: "Lead created",
    //   message:
    //     "Record for " +
    //     rec.First_Name__c.value +
    //     " created successfully!",
    //   variant: "success"
    // });
    // this.dispatchEvent(evt);
    // this.handleClose();
  }

  handleCancel(event) {
    event.preventDefault();
    this.handleClose();
  }

  get creditHistoryOptions() {
    return [
      { label: "--None--", value: "" },
      { label: "Excellent", value: "Excellent" },
      { label: "Average", value: "Average" },
      { label: "Poor", value: "Poor" },
      { label: "Not Sure", value: "Not Sure" }
    ];
  }

  handleChange(event) {
    this.creditHistory = event.detail.value;
  }

  handleSubmit(event) {
    //alert(this.buttonName+'onsubmit');
    event.preventDefault(); // stop the form from submitting
    this.showSpinner = true;
    const fields = event.detail.fields;
    fields.Credit_History__c = this.creditHistory;
    this.template.querySelector("lightning-record-edit-form").submit(fields);
    // this.handleSuccess(event);
  }

  storeButtonName(event) {
    this.buttonName = event.target.dataset.name;

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