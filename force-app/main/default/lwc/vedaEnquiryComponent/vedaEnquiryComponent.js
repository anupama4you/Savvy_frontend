import { LightningElement,api, track } from 'lwc';
import picklistOption from 'c/vedalPicklistValues'
import fetchInitialData from '@salesforce/apex/VedaEnquiryController.fetchInitialData';
import vedaClick from '@salesforce/apex/VedaEnquiryController.vedaClick';
import submitEnquiry from '@salesforce/apex/VedaEnquiryController.submitEnquiry'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class VedaEnquiryComponent extends LightningElement {
    @api 
    recordId;
    renderNow = false;
    transactionInProgress = false;
    clientDetailsExpanded = false;
    @api 
    requestParams ={};
    @track 
    permissionTypeOption = [{value:'XY', label:'Consumer+Commercial'},{value:'YX', label:'Commercial+Consumer'}]
    @track 
    productDataLevel = [{value:'C', label:'Comprehensive'},{value:'P', label:'Partial'},{value:'N', label:'Negative'}];
    @track
    titleOptions = [{value:'MR', label:'Mr'},{value:'MRS', label:'Mrs'},{value:'MS', label:'Ms'}];
    @track genderOptions = [{value:'M', label:'Male'},{value:'F', label:'Female'},{value:'U', label:'Unknown'}];
    @track 
    stateOptions = picklistOption.stateOptions;
    @track streetTypeOptions = picklistOption.streetTypeOptions;
    @track 
    countryOptions = picklistOption.countryOptions;
    @track 
    atOptions = picklistOption.atOptions;
    @track 
    currencyOptions = [
    {label:'AUD', value:'AUD'},
    {label:'USD', value:'USD'}]
    @track 
    sectionsExpandMap ={
        clientDetails:true,
        currentResedentialAddress:true,
        previousResedentialAddress:true,
        employment:true,
        enquiry:true,
        serviceResult1:true,
        serviceResult2:true
    }

    @track 
    relationshipOptions = [
    {value:'1', label:'Principal’s Account (sole)'},
    {value:'2', label:'Principal’s Account (joint)'},
    {value:'3', label:'Guarantor'},
    {value:'4', label:'Director'}]

    @track vedalWrapper ={};

    get checkForWarnings(){
        return this.vedalWrapper && this.vedalWrapper.warningList && this.vedalWrapper.warningList.length > 0;
    }

    get checkForErrors(){
        return this.vedalWrapper && this.vedalWrapper.errorList && this.vedalWrapper.errorList.length >0;
    }
    checkValidity(evt) {

        const allValid = [
            ...this.template.querySelectorAll('lightning-input'),...this.template.querySelectorAll('lightning-textarea'), ...this.template.querySelectorAll('lightning-combobox')
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if (!allValid) {
            throw new Error('Please check for errors and resubmit');         
        } 
    }

    connectedCallback(){
        this.fetchData();

    }
    handleSectionExpansion(e){
        let section = e.target.dataset.section;
        this.sectionsExpandMap[section] = this.sectionsExpandMap[section]? false: true;
    }

    async fetchData(){
        try{
            let vedalWrapper = await fetchInitialData({recordId:this.recordId, pageQueryParamMap:this.requestParams});
            this.vedalWrapper = vedalWrapper;
        }catch(error){
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
    redirectToOpportunity(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view'
            }
        });
    }
    handleOnChange(e){
        let currentField = e.target.dataset.field;
        if(e.target.type === 'checkbox'){
            this.vedalWrapper[currentField] = e.target.checked;
        }else{
            let value = e.target.value;
            this.vedalWrapper[currentField] = value;
        }
    }
    timeout(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
    async  sleep(ms) {
        await this.timeout(ms);
    }

    async submitEnq(){
        try{
            this.transactionInProgress = true;
            let sectionMap = JSON.parse(JSON.stringify(this.sectionsExpandMap));
            sectionMap.clientDetails = true;
            sectionMap.currentResedentialAddress = true;
            sectionMap.previousResedentialAddress = true;
            sectionMap.employment = true;
            sectionMap.enquiry = true;
            sectionMap.serviceResult1 = true;
            sectionMap.serviceResult2 =true;
            this.sectionsExpandMap = sectionMap;
            await this.sleep(30);
            this.checkValidity();
            let vedalWrapper = await submitEnquiry({vedalWrapper: this.vedalWrapper});
            this.vedalWrapper = vedalWrapper;
            if(!this.vedalWrapper.isProcessOK){
                throw new Error('Unable to submit. Please review the following errors');
            }else{
                await vedaClick({vedalWrapper: this.vedalWrapper});
            }
            const event = new ShowToastEvent({
                title: 'Success',
                message: 'Enquiry Submitted Successfully!',
                variant:'success'         
            });
            this.dispatchEvent(event);
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
}