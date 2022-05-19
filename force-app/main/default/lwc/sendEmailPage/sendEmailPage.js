import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getEmailTemplate from '@salesforce/apex/SendEmailController.getEmailTemplate';
import renderEmailTemplatewithMergeField from '@salesforce/apex/SendEmailController.renderEmailTemplatewithMergeField';
import sendEmail from '@salesforce/apex/SendEmailController.sendEmail';
import getAllDocument from '@salesforce/apex/SendEmailController.allDocumentList';
import saveDocument from '@salesforce/apex/SendEmailController.DocumentSave';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { getRecord } from 'lightning/uiRecordApi';
import EMAIL_FIELD from '@salesforce/schema/Custom_Opportunity__c.Email_Address__c';
import { refreshApex } from '@salesforce/apex';
import { displayToast } from "c/partnerJsUtils";

const FIELDS = [EMAIL_FIELD];
export default class SendEmailPage extends LightningElement {
  @api recordId;
  folderLabel = "Folder";
  @api folderValue;
  @api folderOptions = [];
  @api templateOptions = [];
  @api templateValue;
  @api emailTemplateArray = [];
  @api emailBody = "";
  @api subject = "";
  //toAddress='';
  ccAddress = "";
  @api additionalToAddress = "";
  @api bccAddress = "";
  error;
  fileData;

  documentList;
  noRecords = false;
  nextFlag = false;

  allDoc() {
    getAllDocument({ oppId: this.recordId })
      .then((result) => {
        this.documentList = result;
        console.log(
          "documentList ::::: all doc :::" + JSON.stringify(this.documentList)
        );
        this.nextFlag = true;
        if (result.length === 0) {
          this.noRecords = true;
        }
        this.error = undefined;
      })
      .catch((error) => {
        this.error = error;
        this.documentList = undefined;
        this.noRecords = false;
      });
  }

  getCheckedValue(event) {
    const SpecificName = event.target.name;
    console.log("Specific Name -- " + SpecificName);
    console.log("CheckBoxValue  --- " + event.target.checked);
    const CheckBoxValue = event.target.checked;
    let tempAllRecords = Object.assign([], this.documentList);
    for (let j = 0; j < this.documentList.length; j++) {
      let tempRec = Object.assign({}, tempAllRecords[j]);
      if (tempRec.documentName === SpecificName) {
        tempRec.flag = CheckBoxValue;
      }
      tempAllRecords[j] = tempRec;
    }
    this.documentList = tempAllRecords;
  }

  saveToOpp() {
    // alert(typeof this.documentList);
    // console.log('this.documentList:::' + JSON.stringify(this.documentList));
    saveDocument({ docList: this.documentList, recordIdd: this.recordId })
      .then((result) => {
        this.nextFlag = false;
        // this.documentList = result;
        // this.handleTemplateChange();
        this.getRefreshTemplate();

        console.log("::::::::" + JSON.stringify(this.templateValue));
        // console.log("::::::::" + JSON.stringify(this.documentList));
      })
      .catch((error) => {
        let errMsg = "error processing your request";
        if (error.body.message) {
          errMsg = error.body.message;
        }
        console.log("err => " + JSON.stringify(error));
        alert("Getting error while updaing opportunity. " + errMsg);
      })
      .finally(() => {
        refreshApex(this.emailBody);
        refreshApex(this.subject);
        // refreshApex(this.documentList);
      });
    // this.allDoc();
  }

  getRefreshTemplate() {
    // console.log('#### reas' + this.emailTemplateArray.length);
    // this.templateValue = event.detail.value;

    renderEmailTemplatewithMergeField({
      templateId: this.templateValue,
      recordId: this.recordId
    })
      .then((result) => {
        // console.log('##result.emailBody##' + result.emailBody);
        this.emailBody = result.emailBody;
        this.subject = result.subject;
      })
      .catch((error) => {
        this.error = error;
      });
  }

  sendEmail() {
    this.nextFlag = false;
  }

  @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
  oppty;

  get toAddress() {
    return getFieldValue(this.oppty.data, EMAIL_FIELD);
  }
  handleChangeEvent(event) {
    console.log(event.target.name);
    if (event.target.name === "to") this.toAddress = event.target.value;
    if (event.target.name === "additionalTo")
      this.additionalToAddress = event.target.value;
    if (event.target.name === "cc") this.ccAddress = event.target.value;
    if (event.target.name === "bcc") this.bccAddress = event.target.value;
    if (event.target.name === "subject") this.subject = event.target.value;
    if (event.target.name === "body") {
      this.emailBody = event.target.value;
      console.log(`${this.emailBody}`);
    }
  }
  connectedCallback() {
    this.allDoc();
    getEmailTemplate()
      .then((result) => {
        console.log("result" + result.length);
        for (let i = 0; i < result.length; i++) {
          this.templateOptions = [
            ...this.templateOptions,
            { value: result[i].Id, label: result[i].Name }
          ];
          this.emailTemplateArray.push(result[i]);
        }
        this.error = undefined;
      })
      .catch((error) => {
        this.error = error;
        this.templateOptions = undefined;
      });
  }
  /*handleChange(event){
            this.folderValue = event.detail.value;
            //this.templateValue = undefined;
            this.templateOptions = [];
            
            getEmailTemplate({ folderId: this.folderValue}).then(result =>{
                console.log('result'+result.length);
                for(let i=0; i<result.length; i++) {
                    this.templateOptions = [...this.templateOptions ,{value: result[i].Id , label: result[i].Name}];                                   
                    this.emailTemplateArray.push(result[i]);
                }
                this.error = undefined; 
            })
            .catch(error =>{
                this.error = error;
                this.templateOptions = undefined;
            });
        }*/
  handleTemplateChange(event) {
    //  console.log('#### reas' + this.emailTemplateArray.length);
    this.templateValue = event.detail.value;
    this.getRefreshTemplate();
  }

  handleSendClick(event) {
    console.log("#### INSIDE SEND");
    // console.log('--' + this.fileData.base64 + this.fileData + '----' + this.fileData.filename);
    // this.saveToOpp();
    console.log(`preparing the email`);
    const b64 = this.fileData ? this.fileData.base64 : null;
    const fileName = this.fileData ? this.fileData.filename : null;
    const params = {
      templateId: this.templateValue,
      recordId: this.recordId,
      subject: this.subject,
      htmlBody: this.emailBody,
      toAddress: this.toAddress,
      ccAddress: this.ccAddress,
      bccAddress: this.bccAddress,
      additionalToAddress: this.additionalToAddress,
      docList: this.documentList,
      base64: b64,
      filename: fileName
    };
    // console.log(JSON.stringify(params, null, 2));
    sendEmail(params)
      .then((result) => {
        displayToast(this, "Success", "Email Sent Successfully", "success");
        // const evt = new ShowToastEvent({
        //   title: "Success",
        //   message: "Email Sent Successfully",
        //   variant: "success"
        // });
        // this.dispatchEvent(evt);
      })
      .catch((error) => {
        this.error = error;
        const evt = new ShowToastEvent({
          title: "Failure",
          message: "Email can't be send, Please contact administrator",
          variant: "error"
        });
      });
  }

  handleUploadFinished(event) {
    // Get the list of uploaded files
    const uploadedFiles = event.detail.files;
    alert("No. of files uploaded : " + uploadedFiles.length);
    console.log("444444---> " + event.detail.files);
  }
  openfileUpload(event) {
    const file = event.target.files[0];
    var reader = new FileReader();
    reader.onload = () => {
      var base64 = reader.result.split(",")[1];
      this.fileData = {
        filename: file.name,
        base64: base64,
        recordId: this.recordId
      };
      console.log(this.fileData);
    };
    reader.readAsDataURL(file);
  }

}