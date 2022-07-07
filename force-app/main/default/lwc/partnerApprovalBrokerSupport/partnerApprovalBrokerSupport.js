import { LightningElement, api } from "lwc";
import { getRecordNotifyChange } from "lightning/uiRecordApi";
import submitApproval from "@salesforce/apex/PartnerCommunityApprovals.submitApproval";

const STAGE_INTRO = "I";
const STAGE_SUBMISSION = "S";
const STAGE_RESULTS = "R";

export default class PartnerApprovalBrokerSupport extends LightningElement {
  @api recordId;
  @api oppName;
  @api showModal;
  @api lenderSettings;
  @api hasLenderApi;
  @api isExternal;

  submissionResults;
  showSpinner = false;
  formData;
  processStage;

  connectedCallback() {
    this.processStage = STAGE_INTRO;
    this.resetFormData();
  }

  resetFormData() {
    this.formData = {
      lenderComments: "",
      brokerComments: ""
    };
  }

  get lenderLabel() {
    // return "N/A";
    return this.lenderSettings && this.lenderSettings.Label__c
      ? this.lenderSettings.Label__c
      : "N/A";
  }

  get displayIntro() {
    return this.processStage === STAGE_INTRO;
  }

  get displaySubmission() {
    return this.processStage === STAGE_SUBMISSION;
  }

  get displayResults() {
    return this.processStage === STAGE_RESULTS;
  }

  get displayResultErrors() {
    return this.submissionResults && this.submissionResults.status === "1";
  }

  get displayNoCloseButton() {
    return !this.displaySubmission && !this.isExternal;
  }

  get yesLabel() {
    return this.processStage === STAGE_INTRO && this.isExternal 
      ? "Accept & Proceed" : "Yes";
  }

  get closeLabel() {
    let r = "Close";
    r = this.processStage === STAGE_INTRO ? "No" : r;
    r = this.processStage === STAGE_SUBMISSION ? "Cancel" : r;
    return r;
  }

  handleClose() {
    this.dispatchEvent(new CustomEvent("close"));
    this.processStage = STAGE_INTRO;
  }

  handleCloseDialog() {
    this.dispatchEvent(new CustomEvent("cancel"));
    this.processStage = STAGE_INTRO;
  }

  handleYes() {
    // this.dispatchEvent(new CustomEvent("yes"));
    if (this.isExternal) {
      this.dispatchEvent(new CustomEvent("close"));
      this.processStage = STAGE_INTRO;
    } else {
      this.processStage = STAGE_SUBMISSION;
    }
  }

  isValidForm() {
    let r = true;
    if (
      !this.formData.lenderComments ||
      this.formData.lenderComments.trim().length === 0
    ) {
      r = false;
      let fld = this.template.querySelector(
        `[data-id="lender-comments-field"]`
      );
      fld.reportValidity();
    }
    if (
      !this.formData.brokerComments ||
      this.formData.brokerComments.trim().length === 0
    ) {
      r = false;
      let fld = this.template.querySelector(
        `[data-id="broker-comments-field"]`
      );
      fld.reportValidity();
    }
    console.log(`Validation => ${r}`);
    return r;
  }

  handleSubmit(event) {
    event.preventDefault(); // stop the form from submitting
    console.log(`Submitting deal...`);
    if (this.isValidForm() === true) {
      this.showSpinner = true;
      let params = {
        oppId: this.recordId,
        approvalType: "PA", // Code PA -> Pre-Approval
        lenderComments: this.formData.lenderComments,
        brokerSupportComments: this.formData.brokerComments
      };
      submitApproval(params)
        .then((result) => {
          console.log(`${JSON.stringify(result)}`);
          this.submissionResults = result;
        })
        .catch((err) => {
          console.log(JSON.stringify(err));
          this.resultErrors = {
            status: "1",
            errors: [err]
          };
        })
        .finally(() => {
          getRecordNotifyChange([{ recordId: this.recordId }]);
          this.processStage = STAGE_RESULTS;
          this.showSpinner = false;
        });
    }
  }

  handleLenderCommentsChange(event) {
    this.formData.lenderComments = event.detail ? event.detail.value : "";
  }

  handleBrokerCommentsChange(event) {
    this.formData.brokerComments = event.detail ? event.detail.value : "";
  }
}