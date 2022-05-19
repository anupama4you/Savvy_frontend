import { LightningElement, api } from 'lwc';
import signCloudDocument from "@salesforce/apex/PartnerCommunityController.signCloudDocument";

export default class PartnerOpenCloudDocument extends LightningElement {
  @api recordId;

  connectedCallback() {
    console.log(`Opening cloud document... ` + this.recordId);
    if (this.recordId && this.recordId != null && this.recordId != 'null') {
      this.handleDownloadFile();
    }
  }

  handleDownloadFile() {
    signCloudDocument({ docId: this.recordId })
      .then((result) => {
        console.log(`result: ${result}`);
        window.open(result, "_self");
        this.showSpinner = false;
      })
      .catch((err) => {
        console.log(JSON.stringify(err));
        this.showSpinner = false;
      });
  }

}