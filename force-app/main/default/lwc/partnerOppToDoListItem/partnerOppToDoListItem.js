import { LightningElement, api } from 'lwc';

export default class PartnerOppToDoListItem extends LightningElement {
  @api itemUrl;
  @api itemNumber;
  @api label;
  @api status;
  @api preapproved;
  @api formalApproved;
  @api itemType;          // FullApproval, OnlyPreapproval, AppForm, None

  get displayTag () {
    return this.status && this.status.length > 0? true : false;
  }

  get tagLabel () {
    let r = "";
    if (this.itemType === "AppForm") {
      if (this.status === "F") {
        r = "Completed!";
      } else if (this.status === "U") {
        r = "Unfinished!";
      }
    }
    return r;
  }

  get tagStyle() {
    if (this.itemType === "AppForm") {
      return `item-tag   ${
        this.tagLabel === "Completed!" ? "item-tag-done" : "item-tag-undone"
      }`;
    }
    return "";
  }

  get itemDone() {
    if (this.itemType === "AppForm") {
      if (this.status === "F") {
        return true;
      }
    } else if (this.itemType === "OnlyPreapproval") {
      return this.preapproved;
    } else if (this.itemType === "FullApproval") {
      return this.preapproved && this.formalApproved;
    }
    return false;
  }

  get displayPre() {
    return (this.itemType === "OnlyPreapproval" || this.itemType === "FullApproval")? true : false;
  }
  get displayFor() {
    return this.itemType === "FullApproval";
  }

  get preIconStyle() {
    let r = "approval-icon pre-approval-icon";
    if (this.preapproved === true) {
      r += " approval-done";
    } else {
      r += " approval-undone";
    }
    return r;
  }

  get formalIconStyle() {
    let r = "approval-icon for-approval-icon";
    if (this.formalApproved === true) {
      r += " approval-done";
    } else {
      r += " approval-undone";
    }
    return r;
  }

}