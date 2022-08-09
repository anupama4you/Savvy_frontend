import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

export default class ComparisonToolDocument extends NavigationMixin(LightningElement) {
  @api docId;
  @api iconName = "utility:contract_doc";
  @api iconSize = "small";
  @api title = "Open document";

  @track docUrl;

  connectedCallback() {
    if (this.docId) {
      let pageRef = {
        type: "standard__recordPage",
        attributes: {
          objectApiName: "ContentDocument",
          actionName: "view",
          recordId: this.docId
        }
      };
      this[NavigationMixin.GenerateUrl](pageRef)
        .then((url) => {
          this.docUrl = url;
        })
        .catch((err) => console.log(err));
      // this.docUrl = `/partner/sfc/servlet.shepherd/document/download/${this.docId}?operationContext=S1`;
    }
  }

  // handleIconClick(event) {
  //   event.stopPropagation();
  //   console.log(`Go to ContentDocument...`);
  //   const pageRef = {
  //     type: "standard__recordPage",
  //     attributes: {
  //       objectApiName: "ContentDocument",
  //       actionName: "view",
  //       recordId: this.docId
  //     }
  //   };
  //   // Navigate to the Document page.
  //   this[NavigationMixin.Navigate](pageRef);
  // }

  // handleLinkIconClick(event) {
  //   event.stopPropagation();
  //   console.log(`Go to ContentDocument 3... ${this.docId}`);
  //   const pageRef = {
  //     type: "standard__recordPage",
  //     attributes: {
  //       pageName: "filePreview"
  //     },
  //     state: {
  //       selectedRecordId: this.docId
  //     }
  //   };
  //   // Navigate to the Document page.
  //   this[NavigationMixin.Navigate](pageRef);
  // }
  
}