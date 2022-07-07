import { LightningElement, api } from "lwc";
import { getRecordNotifyChange } from "lightning/uiRecordApi";
import submitApproval from "@salesforce/apex/PartnerCommunityApprovals.submitApproval";
import manualSubmission from "@salesforce/apex/PartnerCommunityApprovals.manualSubmission";
import formalApprovalValidation from "@salesforce/apex/PartnerCommunityApprovals.formalApprovalValidation";

const STAGE_INTRO = "I";
const STAGE_SUBMISSION = "S";
const STAGE_RESULTS = "R";

export default class PartnerApprovalFormalSubmission extends LightningElement {
  @api recordId;
  @api oppName;
  @api showModal;
  @api lenderSettings;
  @api hasLenderApi;

  appResult;
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

  get displayValidationResults() {
    return (
      this.appResult &&
      Object.keys(this.appResult).length > 0 &&
      Object.getPrototypeOf(this.appResult) === Object.prototype
    );
  }

  get displaySuccessResult() {
    return !(this.displayResultErrors || this.displayValidationResults);
  }

  get closeLabel() {
    let r = "Close";
    r = this.processStage === STAGE_INTRO ? "No" : r;
    r = this.processStage === STAGE_SUBMISSION ? "Cancel" : r;
    return r;
  }

  handleClose() {
    // Intro -> go manual submission
    if (this.processStage === STAGE_INTRO) {
      console.log("🚀 ~ processStage", this.processStage);
      console.log(`Invoking manual submission here!`);
      this.showSpinner = true;
      manualSubmission({ oppId: this.recordId, approvalType: "FA" })
        .then((result) => {
          this.submissionResults = result;
          console.log(`result: ${JSON.stringify(result)}`);
        })
        .catch((err) => {
          console.log(`Error => ${JSON.stringify(err)}`);
          this.appResult = {
            status: "1",
            errors: [err]
          };
        })
        .finally(() => {
          getRecordNotifyChange([{ recordId: this.recordId }]);
          this.showSpinner = false;
          this.processStage = STAGE_RESULTS;
        });
    } else {
      // Otherwise close dialog
      this.handleCancel();
    }
  }

  handleYes(event) {
    event.preventDefault();
    console.log(`Click on Yes for approval`);
    this.showSpinner = true;
    formalApprovalValidation({ oppId: this.recordId })
      .then((result) => {
        this.appResult = result;
        console.log(`result: ${JSON.stringify(result)}`);
        console.log(
          `displayValidationResults  => ${this.displayValidationResults}`
        );
        this.processStage = this.displayValidationResults
          ? STAGE_RESULTS
          : STAGE_SUBMISSION;
        console.log(`processStage  => ${this.processStage}`);
      })
      .catch((err) => {
        console.log(`Error => ${JSON.stringify(err)}`);
        this.appResult = {
          status: "1",
          errors: [err]
        };
        this.processStage = STAGE_RESULTS;
      })
      .finally(() => {
        this.showSpinner = false;
      });
  }

  handleCancel() {    
    this.dispatchEvent(new CustomEvent("close"));
    this.processStage = STAGE_INTRO;
  }
  
  processApproval() {
    this.showSpinner = true;
    let params = {
      oppId: this.recordId,
      approvalType: "FA", // Code FA -> Formal Approval
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
        this.submissionResults = {
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
      this.processApproval();
    }
  }

  handleLenderCommentsChange(event) {
    this.formData.lenderComments = event.detail ? event.detail.value : "";
  }

  handleBrokerCommentsChange(event) {
    this.formData.brokerComments = event.detail ? event.detail.value : "";
  }
}