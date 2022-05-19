import { LightningElement, api } from 'lwc';
import { getRecordNotifyChange } from "lightning/uiRecordApi";
import lenderApiProcess from "@salesforce/apex/PartnerCommunityApprovals.processApi";
import manualSubmission from "@salesforce/apex/PartnerCommunityApprovals.manualSubmission";
import { buildErrorMessage } from "c/partnerJsUtils";

const STAGE_INTRO = "I";
const STAGE_RESULTS = "R";

export default class PartnerApprovalLenderApiConfirmation extends LightningElement {
  @api recordId;
  @api showModal;
  @api oppName;
  @api lenderSettings;

  showSpinner;
  result;
  processStage = STAGE_INTRO;

  get lenderLabel() {
    return (
      this.lenderSettings && this.lenderSettings.Label__c
    ) ? this.lenderSettings.Label__c : "N/A";
  }

  get displayIntro() {
    return this.processStage === STAGE_INTRO;
  }

  get displayResults() {
    return this.processStage === STAGE_RESULTS;
  }

  get displayResultMessages() {
    return (
      this.displayResults &&
      this.result &&
      (this.result.status === "1" ||
        (this.result.errors && this.result.errors.length > 0))
    );
  }

  get displaySuccessResult() {
    return this.displayResults && this.result && this.result.status === "0";
  }

  get closeLabel() {
    return this.processStage === STAGE_INTRO ? "No" : "Close";
  }

  get successLabel() {
    return `Process completed, lender application #: ${this.result.response.Application_ID__c}`;
  }

  handleClose() {
    const event = this.displayIntro ? "continue" : "close";
    this.result = undefined;
    this.processStage = STAGE_INTRO;
    this.dispatchEvent(new CustomEvent(event));
  }

  handleCloseDialog() {
    this.result = undefined;
    this.processStage = STAGE_INTRO;
    this.dispatchEvent(new CustomEvent("close"));
  }

  handleYes() {
    console.log(`API Yes click... ${this.recordId}`);
    this.showApiConfirmation = false;
    this.showSpinner = true;
    // process API
    lenderApiProcess({ oppId: this.recordId })
      .then((result) => {
        this.result = result;
        console.log(`${JSON.stringify(result)}`);
      })
      .catch((err) => {
        console.log(JSON.stringify(err));
        this.result = {
          status: "1",
          errors: [buildErrorMessage(err)]
        };
      })
      .finally(() => {
        this.showSpinner = false;
        this.updateOppStatus();
      });
  }

  updateOppStatus() {
    console.log(`UpdateOppStatus...`);
    if (this.result && this.result.status === "0") {
      this.showSpinner = true;
      manualSubmission({ oppId: this.recordId, approvalType: "PA", isApi: true })
        .then((res) => {
          if (res && res.errors && res.errors.length > 0) {
            this.result.errors = this.result.errors.concat(res.errors);
          }
          console.log(`updateOppStatus result: ${JSON.stringify(res)}`);
        })
        .catch((err) => {
          console.log(JSON.stringify(err));
          const errs = buildErrorMessage(err);
          if (errs && errs.length > 0) {
            this.result.errors = this.result.errors.concat(errs);
          }
        })
        .finally(() => {
          getRecordNotifyChange([{ recordId: this.recordId }]);
          this.processStage = STAGE_RESULTS;
          this.showSpinner = false;
        });
    } else {
      this.processStage = STAGE_RESULTS;
    }
  }
}