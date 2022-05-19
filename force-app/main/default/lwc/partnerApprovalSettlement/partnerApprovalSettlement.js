import { LightningElement, api } from "lwc";
import { getRecordNotifyChange } from "lightning/uiRecordApi";
import submitApproval from "@salesforce/apex/PartnerCommunityApprovals.submitApproval";

const STAGE_SUBMISSION = "S";
const STAGE_RESULTS = "R";

export default class PartnerApprovalSettlement extends LightningElement {
  @api recordId;
  @api oppName;
  @api showModal;
  @api lenderSettings;
  
  submissionResults;
  showSpinner = false;
  processStage;

  connectedCallback() {
    this.resetProcess();
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

  get successLabel() {
    return `Opportunity for ${this.oppName} has been settled!`;
  }

  resetProcess() {
    this.processStage = STAGE_SUBMISSION;
    this.submissionResults  =null;
  }

  handleClose() {
    this.resetProcess();
    this.dispatchEvent(new CustomEvent("close"));
  }

  handleSubmit(event) {
    event.preventDefault(); // stop the form from submitting
    console.log(`Submitting deal...`);
    this.showSpinner = true;
    let params = {
      oppId: this.recordId,
      approvalType: "ST", // Code PA -> Pre-Approval
      lenderComments: "",
      brokerSupportComments: ""
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

}