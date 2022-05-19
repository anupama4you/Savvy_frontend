import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import userId from '@salesforce/user/Id';
import uploadPartnerLogo from '@salesforce/apex/UploadFileCtrl.uploadPartnerLogo';

export default class UploadFileComponent extends LightningElement {
    userInId = userId;
    get acceptedFormats() {
        return ['.pdf', '.png', '.jpg', '.jpeg'];
    }
   
    handleUploadFinished(event) {
        
        const uploadedFiles = event.detail.files;
        uploadPartnerLogo({ userId : this.userInId , documentId : uploadedFiles[0].documentId}).then(result => {
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Logo Successfully uploaded',
                variant: 'success',
            });
            this.dispatchEvent(evt);
        })
        .catch(error => {
            this.error = error;
            const evt = new ShowToastEvent({
                title: 'Failure',
                message: 'Logo can not be uploaded. Please contact System Admin',
                variant: 'error',
            });
        });
    }
}