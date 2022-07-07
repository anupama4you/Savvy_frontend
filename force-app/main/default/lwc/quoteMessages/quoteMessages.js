import { LightningElement, api } from "lwc";

export default class QuoteMessages extends LightningElement {
  @api results;

  handleClose() {
    this.dispatchEvent(new CustomEvent("close"));
  }

  renderedCallback() {
    console.log(
      "--------render call back QuoteMessages -----------",
      JSON.stringify(this.results, null, 2)
    );
  }

  // get displayAssetMessages() {
  //   return this.results && this.results.ASD && this.results.ASD.length > 0;
  // }

  // get listAssetMessages() {
  //   let r = [];
  //   if (this.results && this.results.ASD) {
  //     r = this.results.ASD;
  //   }
  //   return r;
  // }

  // get displayDocMessages() {
  //   return this.results && this.results.DOC && this.results.DOC.length > 0;
  // }

  // get listDocMessages() {
  //   let r = [];
  //   if (this.results && this.results.DOC) {
  //     r = this.results.DOC;
  //   }
  //   return r;
  // }

  get displayConfirmMessages() {
    // return (
    //   this.results && this.results.confirms && this.results.confirms.length > 0
    // );
    return this.listConfirmMessages.length > 0;
  }

  get listConfirmMessages() {
    let r = [];
    if (this.results)
      this.results.confirms.length > 0 ? (r = this.results.confirms) : (r = []);

    return r;
  }

  get displayInfoMessage() {
    // return this.results && this.results.infos && this.results.infos.length > 0;
    return this.listInfoMessages.length > 0;
  }

  get listInfoMessages() {
    let r = [];
    if (this.results)
      this.results.infos.length > 0 ? (r = this.results.infos) : (r = []);
    return r;
  }

  get displayErrorMessages() {
    // return (
    //   this.results && this.results.errors && this.results.errors.length > 0
    // );
    return this.listErrorMessages.length > 0;
  }

  get listErrorMessages() {
    let r = [];
    if (this.results)
      this.results.errors.length > 0 ? (r = this.results.errors) : (r = []);
    return r;
  }

  get displayWarningMessages() {
    // return (
    //   this.results && this.results.warnings && this.results.warnings.length > 0
    // );
    return this.listWarningMessages.length > 0;
  }

  get listWarningMessages() {
    let r = [];
    if (this.results)
      this.results.warnings.length > 0 ? (r = this.results.warnings) : (r = []);
    return r;
  }
}