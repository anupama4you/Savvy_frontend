import { LightningElement, api } from 'lwc';

export default class PartnerApprovalMessages extends LightningElement {
  @api results;

  handleClose() {
    this.dispatchEvent(new CustomEvent("close"));
  }

  get displayAssetMessages() {
    return this.results && this.results.ASD && this.results.ASD.length > 0;
  }

  get listAssetMessages() {
    let r = [];
    if (this.results && this.results.ASD) {
      r = this.results.ASD;
    }
    return r;
  }

  get displayDocMessages() {
    return this.results && this.results.DOC && this.results.DOC.length > 0;
  }

  get listDocMessages() {
    let r = [];
    if (this.results && this.results.DOC) {
      r = this.results.DOC;
    }
    return r;
  }

  get displayQuoteMessages() {
    return this.results && this.results.QUO && this.results.QUO.length > 0;
  }

  get listQuoteMessages() {
    let r = [];
    if (this.results && this.results.QUO) {
      r = this.results.QUO;
    }
    return r;
  }

  get displayOtherMessages() {
    return this.results && this.results.OTH && this.results.OTH.length > 0;
  }

  get listOtherMessages() {
    let r = [];
    if (this.results && this.results.OTH) {
      r = this.results.OTH;
    }
    return r;
  }
  get displayErrorMessages() {
    return (
      this.results &&
      ((this.results.ERR && this.results.ERR.length > 0) ||
        (this.results.errors && this.results.errors.length > 0))
    );
  }

  get listErrorMessages() {
    let r = [];
    if (this.results) {
      if (this.results.ERR) {
        r = this.results.ERR;
      } else if (this.results.errors) {
        r = this.results.errors;
      }
    }
    return r;
  }

  get displayWarningMessages() {
    return (
      this.results &&
      ((this.results.WAR && this.results.WAR.length > 0) ||
        (this.results.warnings && this.results.warnings.length > 0))
    );
  }

  get listWarningMessages() {
    let r = [];
    if (this.results && this.results.WAR) {
      r = this.results.WAR;
    }
    if (this.results) {
      if (this.results.WAR) {
        r = this.results.WAR;
      } else if (this.results.warnings) {
        r = this.results.warnings;
      }
    }
    return r;
  }
}