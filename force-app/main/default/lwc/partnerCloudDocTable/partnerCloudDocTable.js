import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import signCloudDocument from "@salesforce/apex/PartnerCommunityController.signCloudDocument";
import deleteCloudDocument from "@salesforce/apex/PartnerCommunityController.deleteCloudDocument";

const ACTIONS = [
  { label: "Edit", name: "edit_details" },
  { label: "Delete", name: "delete_file" }
];

const COLS = [
  { label: "File Name", fieldName: "File_Name__c", editable: false },
  { label: "Document Type", fieldName: "Document_Type__c", editable: false },
  { label: "Send To Lender", fieldName: "Send_To_Lender__c", editable: false },
  {
    label: "File",
    fieldName: "Id",
    type: "button",
    fixedWidth: 160,
    typeAttributes: {
      label: "Download",
      name: "downloadFile",
      iconName: "utility:download",
      title: "Open file"
    }
  },
  // {
  //   label: "",
  //   fieldName: "Id",
  //   type: "button-icon",
  //   fixedWidth: 90,
  //   typeAttributes: {
  //     label: "Delete",
  //     name: "deleteFile",
  //     iconName: "action:remove",
  //     title: "Delete file"
  //   }
  // },
  {
    type: "action",
    typeAttributes: { rowActions: ACTIONS }
  }
];

export default class PartnerCloudDocTable extends LightningElement {
  @api docs;
  @track showEditModal = false;
  @track showDeleteModal = false;
  columns = COLS;
  rowOffset = 0;
  docSelected;
  showSpinner;
  showPopupSpinner;


  handleRowAction(event) {
    console.log(`Click on ... ${event.detail.action.name}`);
    const actionName = event.detail.action.name;
    this.docSelected = event.detail.row;
    console.log(JSON.stringify(this.docSelected, null, 2));
    switch (actionName) {
      case "downloadFile":
        this.handleDownloadFile();
        break;
      case "edit_details":
        this.handleEdit();
        break;
      case "delete_file":
        this.handleDelete();
        break;
    }
  }

  handleDownloadFile() {
    this.showSpinner = true;
    const doc = this.docSelected;
    console.log(JSON.stringify(doc));
    signCloudDocument({ docId: doc.Id })
      .then((result) => {
        console.log(`result: ${result}`);
        window.open(result, "_blank");
        this.showSpinner = false;
      })
      .catch((err) => {
        console.log(JSON.stringify(err));
        this.showSpinner = false;
      });
  }

  handleDelete() {
    this.showDeleteModal = true;
  }

  handleEdit() {
    console.log(`Editing file... ${this.docSelected.Name}`);
    this.showEditModal = true;
  }

  /* Edit popup */
  handleEditClose() {
    this.showEditModal = false;
    this.showPopupSpinner = false;
  }

  handleEditSubmit(event){
    event.preventDefault();       // stop the form from submitting
    this.showPopupSpinner = true;
    const fields = event.detail.fields;
    console.log(JSON.stringify(fields, null, 2));
    // fields.Credit_History__c = this.creditHistory;
    this.docSelected.Document_Type__c = fields.Document_Type__c;
    this.template.querySelector('lightning-record-edit-form').submit(fields);
    // this.handleSuccess(event);
  }

  handleEditSuccess(event) {
    const rec = event.detail.fields;
    // console.log(JSON.stringify(payload));
    const evt = new ShowToastEvent({
      title: "Record updated",
      message:
        "Record for " +
        rec.Name.value +
        " updated successfully!",
      variant: "success"
    });
    this.dispatchEvent(evt);
    this.dispatchEvent(
      new CustomEvent("updaterecord", {
        detail: {
          docId: this.docSelected.Id,
          docType: this.docSelected.Document_Type__c
        }
      })
    );
    this.handleEditClose();
  }

  handleDeleteNo() {
    this.showDeleteModal = false;
    this.showSpinner = false;
  }

  handleDeleteYes () {
    console.log(`Deleting file... ${this.docSelected.Name}`);
    this.showSpinner = true;
    deleteCloudDocument({ docId: this.docSelected.Id })
      .then((rsl) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "File deleted!",
            message: `File [ ${this.docSelected.Name} ] deleted!`,
            variant: "success"
          })
        );
        this.dispatchEvent(
          new CustomEvent("deleterecord", {
            detail: {
              docId: this.docSelected.Id
            }
          })
        );
        this.handleDeleteNo();
      })
      .catch((err) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error",
            message: error.message,
            variant: "error"
          })
        );
        this.handleDeleteNo();
      });
  }
}