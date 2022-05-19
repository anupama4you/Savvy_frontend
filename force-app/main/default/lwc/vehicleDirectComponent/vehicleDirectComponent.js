import { LightningElement,track,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import handleSubmission from '@salesforce/apex/VehiclesComponentCtrl.handleSubmission'
import fetchInitialData from '@salesforce/apex/VehiclesComponentCtrl.fetchInitialData'
import { NavigationMixin } from 'lightning/navigation';

export default class VehicleDirectComponent extends NavigationMixin(LightningElement) {
    @track opportunity = {};
    @api
    recordId;
    isBrokerPartnerUser
    renderNow = false;
    hasErrors = false;
    transactionInProgress = false;
    errorMessage;
    get checkIfThereAreTwoApplicants(){
        return this.opportunity.Application__r &&  (this.opportunity.Application__r.No_of_People__c == 2);
    }
    @track 
    vehicleStatusCombobox = [{label:'New',value:'New'},{label:'Demo',value:'Demo'},{label:'Used',value:'Used'},{label:'Not Applicable',value:'Not Applicable'}]
    checkValidity(evt) {

        const allValid = [
            ...this.template.querySelectorAll('lightning-input'),...this.template.querySelectorAll('lightning-textarea')
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if (!allValid) {
            throw new Error('Please check for errors and resubmit');         
        } 
    }

    connectedCallback(){
        this.fetchInitialData();
    }

    async fetchInitialData(){
        try{
            let response = await fetchInitialData({recordId:this.recordId});
            console.log('fetch response ',response);
            this.opportunity = response.opportunity;
            this.isBrokerPartnerUser = response.isBrokerPartnerUser;

        }catch(error){
            this.hasErrors = true;
            this.errorMessage = error.message? error.message:error.body.message;
            const event = new ShowToastEvent({
                title: 'Error',
                message: this.errorMessage,
                variant:'error'         
            });
            this.dispatchEvent(event);
            console.log('Unable to fetch data ',e);

        }finally{
            this.renderNow = true;
        }
    }
    get checkForLoadingAndErrors(){
        return this.renderNow && !this.hasErrors;
    }

    get checkForButtonDisable(){
        return this.hasErrors && this.transactionInProgress;
    }
    async handleSave(){
        try{
            this.transactionInProgress = true;
            this.checkValidity();
            await handleSubmission({Opp:this.opportunity});
            const event = new ShowToastEvent({
                title: 'SUCCESS!',
                message: 'Record Saved Successfully',
                variant:'success'         
            });
            this.dispatchEvent(event);
            this.redirectToOpportunity();


        }catch(error){
            this.errorMessage = error.message? error.message:error.body.message;
            const event = new ShowToastEvent({
                title: 'Error',
                message: this.errorMessage,
                variant:'error'         
            });
            this.dispatchEvent(event);
        }finally{
            this.transactionInProgress = false;
        }
    }
    handleOnChange(e){
        let currentField = e.target.dataset.field;
        let value = e.target.value;
        this.opportunity[currentField] = value;
    }
    redirectToOpportunity(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view'
            }
        });
    }
}