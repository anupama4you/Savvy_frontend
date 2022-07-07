import { LightningElement, api, track, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getFieldValue, getRecordNotifyChange } from "lightning/uiRecordApi";
import NAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import STATUS_FIELD from "@salesforce/schema/Custom_Opportunity__c.Status__c";
import PARTNER_EXTERNAL_FIELD from "@salesforce/schema/Custom_Opportunity__c.Partner_Is_External__c";
import preApprovalValidation from "@salesforce/apex/PartnerCommunityApprovals.preApprovalValidation";
import settlementValidation from "@salesforce/apex/PartnerCommunityApprovals.settlementValidation";
import getLenderSettings from "@salesforce/apex/PartnerCommunityApprovals.getLenderSettings";
import manualSubmission from "@salesforce/apex/PartnerCommunityApprovals.manualSubmission";


// Values for Approval process
const STAGE_NONE = "NAN";          // Validation
const STAGE_VALIDATION = "V";      // Validation
const STAGE_API = "API";           // API confirmation
const STAGE_BROKER_SUPPORT = "BS";        // Broker Support - Processing Team
const STAGE_FORMAL_APPROVAL = "FA";        // Broker Support - Processing Team
const STAGE_SETTLEMENT = "STL";        // Broker Support - Processing Team
export default class PartnerApprovalOptions extends NavigationMixin(LightningElement) {
  @api recordId;
  @track displayComp = false;
  @api quoting;
  @api opp; // Opportunity
  @api oppManualStatus;
  @api oppManualName;
  @api oppPartnerExternal;
  @api hideSettledOption;
  @api callBackAction;

  showSpinner;
  appResult;
  showApprovalMessages = false;
  showApiConfirmation = false;
  showBrokerSupport = false;
  processStatus = STAGE_NONE; // VAL - Validation, API - API confirmation, PRO - Processing team
  lenderSettings;

  @wire(getLenderSettings, { oppId: "$recordId" })
  wireLenderSettings({ error, data }) {
    // console.log(`wiring lender settings...`);
    if (data) {
      // console.log(JSON.stringify(data));
      this.lenderSettings = data;
    } else if (error) {
      console.log(error);
      this.lenderSettings = undefined;
    }
  }

  connectedCallback() {
    // console.log(`this.recordId: ` + this.recordId);
    // console.log(`this.oppManualStatus: ` + this.oppManualStatus);
    // console.log(`this.hideSettledOption: ${this.hideSettledOption}`);
    if (this.recordId && this.recordId != null && this.recordId !== "null") {
      this.displayComp = true;
    }
  }

  handleApprovalClick(event) {
    event.preventDefault();
    // console.log(`Click on Submit for approval`);
    if (this.displayComp) {
      this.showSpinner = true;
      this.processStatus = STAGE_VALIDATION;
      preApprovalValidation({ oppId: this.recordId })
        .then((result) => {
          this.appResult = result;
          // console.log(`result: ${JSON.stringify(result)}`);
          this.showApprovalMessages = this.displayApprovalResults;
          this.showSpinner = false;
          if (!this.showApprovalMessages) {
            this.processApiConfirmation();
          }
        })
        .catch((err) => {
          console.log(`Error => ${JSON.stringify(err)}`);
          this.displayError("Approval submission", err);
          this.showSpinner = false;
          this.closeApprovalDialog();
        });
    } else {
      this.displayToast(
        `Opportunity record ID not found`,
        `There is not any opportunity ID which can be associated with this option, please go to Opportunities, select one and try again.`,
        `error`
      );
    }
  }

  handleSettleClick(event) {
    event.preventDefault();
    // console.log(`Click on Settle`);
    if (this.displayComp) {
      this.showSpinner = true;
      this.processStatus = STAGE_VALIDATION;
      settlementValidation({ oppId: this.recordId })
        .then((result) => {
          this.appResult = result;
          // console.log(`result: ${JSON.stringify(result)}`);
          this.showApprovalMessages = this.displayApprovalResults;
          this.showSpinner = false;
          if (!this.showApprovalMessages) {
            this.processStatus = STAGE_SETTLEMENT;
          }
        })
        .catch((err) => {
          console.log(`Error => ${JSON.stringify(err)}`);
          this.displayError("Approval submission", err);
          this.showSpinner = false;
          this.closeApprovalDialog();
        });
    } else {
      this.displayToast(
        `Opportunity record ID not found`,
        `There is not any opportunity ID which can be associated with this option, please go to Opportunities, select one and try again.`,
        `error`
      );
    }
  }

  handleFormalApprovalClick(event) {
    event.preventDefault();
    // console.log(`Click on Formal`);
    this.processStatus = STAGE_FORMAL_APPROVAL;
  }

  handleNavigationClick(event, pageName) {
    // console.log(JSON.stringify(event, null, 2));
    event.preventDefault();
    event.stopPropagation();
    if (this.displayComp) {
      console.log(`Go to ${pageName}...`);
      const pageRef = {
        type: "comm__namedPage",
        attributes: {
          name: pageName
        },
        state: {
          recordId: this.recordId,
          oppName: this.oppName
        }
      };
      // console.log(JSON.stringify(pageRef));
      // Navigate to the Account Home page.
      this[NavigationMixin.Navigate](pageRef);
      // this.displayToast(`Application Form`);
    } else {
      this.displayToast(
        `Opportunity record ID not found`,
        `There is not any opportunity ID which can be associated with this option, please go to Opportunities, select one and try again.`,
        `error`
      );
    }
  }

  displayOptionToast(name) {
    this.displayToast(
      `${name} button Click`,
      `Functionality not implemented yet!`,
      "warning"
    );
  }

  displayToast(title, message, variant, mode) {
    const evt = new ShowToastEvent({
      title: `${title}`,
      message: `${message}`,
      variant: `${variant ? variant : "info"}`,
      mode: `${mode ? mode : "dismissible"}`
    });
    this.dispatchEvent(evt);
  }

  displayError(title, err) {
    let msg = "";
    if (err && err.body && err.body.message) {
      msg = err.body.message;
    }
    this.displayToast(title, msg, "error", "sticky");
  }

  get displayApprovalResults() {
    return (
      this.appResult &&
      Object.keys(this.appResult).length > 0 &&
      Object.getPrototypeOf(this.appResult) === Object.prototype
    );
  }

  closeApprovalDialog() {
    console.log(`Closing approval message...`);
    this.showApprovalMessages = false;
    this.showApiConfirmation = false;
    this.showBrokerSupport = false;
    this.processStatus = STAGE_NONE;
    if (this.callBackAction) {
      this.callBackAction();
    }
  }

  processApiConfirmation() {
    if (this.displayAPIConfirmation) {
      this.processStatus = STAGE_API;
      this.showApiConfirmation = true;
      // this.displayToast(
      //   `Approval validation`,
      //   `process finished!`,
      //   "success",
      //   "sticky"
      // );
    } else {
      this.showBrokerSupport = true;
      this.processStatus = STAGE_BROKER_SUPPORT;
    }
  }

  settlementConfirmation() {
    if (this.displaySettlementConfirmation) {
      this.processStatus = STAGE_API;
      this.showApiConfirmation = true;
      // this.displayToast(
      //   `Approval validation`,
      //   `process finished!`,
      //   "success",
      //   "sticky"
      // );
    } else {
      this.showBrokerSupport = true;
      this.processStatus = STAGE_BROKER_SUPPORT;
    }
  }

  get displayAPIConfirmation() {
    const qn = this.quoting
      ? this.quoting.Name
      : this.lenderSettings
      ? this.lenderSettings.Name
      : undefined;
    // console.log(`@@displayAPIConfirmation:`, qn);
    return (
      qn &&
      (qn === "Pepper MV" ||
        qn === "Pepper Leisure" ||
        // qn === "Pepper Commercial" ||
        qn === "RateSetter" ||
        qn === "RateSetter PL" ||
        qn === "Finance One" ||
        qn === "Finance One Commercial" ||
        qn === "Latitude" ||
        qn === "Money3")
    );
  }

  get displaySettlementConfirmation() {
    return this.processStatus === STAGE_SETTLEMENT;
  }

  get displayFormalApproval() {
    return this.processStatus === STAGE_FORMAL_APPROVAL;
  }

  get oppName() {
    // return getFieldValue(this.opp, NAME_FIELD);
    return this.oppManualName
      ? this.oppManualName
      : getFieldValue(this.opp, NAME_FIELD);
  }

  get oppStatus() {
    // console.log(`oppManualStatus >> ${this.oppManualStatus}`);
    // return getFieldValue(this.opp, STATUS_FIELD);
    return this.oppManualStatus
      ? this.oppManualStatus
      : getFieldValue(this.opp, STATUS_FIELD);
  }

  get isExternal() {
    // console.log(`oppPartnerExternal >> ${this.oppPartnerExternal}`);
    // return getFieldValue(this.opp, STATUS_FIELD);
    return this.oppPartnerExternal !== undefined
      ? this.oppPartnerExternal
      : getFieldValue(this.opp, PARTNER_EXTERNAL_FIELD);
  }

  handlerApiNo() {
    // console.log(`API No click...`);
    this.showApiConfirmation = false;
    this.showBrokerSupport = true;
    this.processStatus = STAGE_BROKER_SUPPORT;
  }

  handlerApiClose() {
    this.closeApprovalDialog();
  }

  handlerBrokerSupportNo() {
    console.log(`Broker Support No click...`);
    this.showSpinner = true;
    manualSubmission({ oppId: this.recordId, approvalType: "PA" })
      .then((result) => {
        this.appResult = result;
        console.log(`result: ${JSON.stringify(result)}`);
      })
      .catch((err) => {
        console.log(`Error => ${JSON.stringify(err)}`);
        this.displayError("Approval API process", err);
      })
      .finally(() => {
        getRecordNotifyChange([{ recordId: this.recordId }]);
        this.showSpinner = false;
        this.showBrokerSupport = false;
        this.processStatus = STAGE_NONE;
      });
  }

  handlerBrokerSupportCancel() {
    this.closeApprovalDialog();
  }

  handlerSettlementClose() {
    this.closeApprovalDialog();
  }

  handlerFormalClose() {
    this.closeApprovalDialog();
  }

  handlerBrokerSupportYes() {
    console.log(`Broker Support Yes click...`);
    this.showBrokerSupport = false;
    this.showSpinner = true;
    // TODO: move Opp status to Pre-approved (go manually)
    this.showSpinner = false;
    this.processStatus = STAGE_NONE;
  }

  handlerSettlementYes() {
    console.log(`Settlement Yes click...`);
    this.showBrokerSupport = false;
    this.showSpinner = true;
    // TODO: move Opp status to Settled (go manually)

    this.showSpinner = false;
    this.processStatus = STAGE_NONE;
  }

  get showFAButton() {
    return (
      !this.isExternal &&
      (
        this.oppStatus === "Pre-Approved" ||
        this.oppStatus === "Submitted for Formal Approval" ||
        this.oppStatus === "Sent to Lender for Formal Approval" ||
        this.oppStatus === "Formal Approved"
      )
    );
  }

  get disableSettledButton() {
    return !(
      this.oppStatus === "Pre-Approved" || this.oppStatus === "Formal Approved"
    );
  }

  get disablePAButton() {
    return !(
      this.oppStatus === "Become Opportunity" ||
      this.oppStatus === "Quote Sent" ||
      this.oppStatus === "Application Form Sent" ||
      this.oppStatus === "Application Forms Received" ||
      this.oppStatus === "Awaiting Paperwork" ||
      this.oppStatus === "24 Hour Call" ||
      this.oppStatus === "Future follow up"
    );
  }

  get disableFAButton() {
    return !(this.oppStatus === "Pre-Approved");
  }

  get showSettledButton() {
    return !(this.hideSettledOption === true);
  }
}