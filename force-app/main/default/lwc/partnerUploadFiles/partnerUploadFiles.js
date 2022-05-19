import { LightningElement, api, track } from "lwc";
import uploadFileToAWS from "@salesforce/apex/PartnerCommunityController.uploadFileOrFail";
import displayUploadedFiles from "@salesforce/apex/PartnerCommunityController.listCloudDocuments";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class PartnerUploadFiles extends LightningElement {
  @api recordId; //get the recordId for which files will be attached.
  selectedFilesToUpload = []; //store selected files
  @track showSpinner = false; //used for when to show spinner
  @track tableData; //to display the uploaded file and link to AWS
  uploadedFiles = [];

  //retrieve uploaded file information to display to the user
  selectCloudDocs() {
    displayUploadedFiles({ oppId: this.recordId })
      .then((data) => {
        this.tableData = data;
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error in displaying data!!",
            message: error.message,
            variant: "error"
          })
        );
      });
  }

  readFile(fileSource) {
    return new Promise((resolve, reject) => {
      const fileReader = new FileReader();
      const fileName = fileSource.name;
      const fileType = fileSource.type;
      const fileSize = fileSource.size;
      console.log(`Loading file ${fileName} [${fileType}] (${fileSize})...`);
      fileReader.onerror = () => reject(fileReader.error);
      fileReader.onload = () =>
        resolve({
          fileName,
          fileType,
          fileSize,
          sataus: "LOADED",
          base64: fileReader.result.split(",")[1]
        });
      fileReader.readAsDataURL(fileSource);
    });
  }

  async handleFileChange(event) {
    this.showSpinner = true;
    this.uploadedFiles = await Promise.all(
      [...event.target.files].map((file) => this.readFile(file))
    );
    // Here, you can now upload the files to the server //
    for (let i = 0; i < this.uploadedFiles.length; i++) {
      this.uploadFileDocument(this.uploadedFiles[i]);
    }
    console.log(`files uploaded!`);
  }

  uploadFileDocument(myFile) {
    uploadFileToAWS({
      parentId: this.recordId,
      fileName: myFile.fileName,
      fileType: myFile.fileType,
      fileContent: encodeURIComponent(myFile.base64)
    })
      .then((result) => {
        console.log("Upload result = " + result);
        myFile.status = "UPLOADED";
        this.finishUpload();
      })
      .catch((error) => {
        myFile.status = "FAILED";
        this.finishUploadError(myFile, error);
      });
  }

  finishUpload() {
    let isPending = false;
    for (let i = 0; i < this.uploadedFiles.length; i++) {
      if (this.uploadedFiles[i].status === "LOADED") {
        isPending = true;
      }
    }
    if (!isPending) {
      this.selectCloudDocs();
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Success!!",
          message: `${this.uploadedFiles.length} document(s) uploaded Successfully!!!`,
          variant: "success"
        })
      );
      this.showSpinner = false;
    }
  }

  finishUploadError(myFile, err) {
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Error",
        message: err.body.message + ` File not uploaded [${myFile.fileName}]`,
        variant: "error"
      })
    );
    let isPending = false;
    for (let i = 0; i < this.uploadedFiles.length; i++) {
      if (this.uploadedFiles[i].status === "LOADED") {
        isPending = true;
      }
    }
    if (!isPending) {
      this.selectCloudDocs();
      this.showSpinner = false;
    }
  }

  

  async connectedCallback() {
    this.selectCloudDocs();
  }

  onUpdateRecord(event) {
    console.log(`Record updated!`);
    console.log(JSON.stringify(event.detail, null, 2));
    this.selectCloudDocs();
  }

  onDeleteRecord(event) {
    console.log(`Record deleted!`);
    console.log(JSON.stringify(event.detail, null, 2));
    this.selectCloudDocs();
  }

}