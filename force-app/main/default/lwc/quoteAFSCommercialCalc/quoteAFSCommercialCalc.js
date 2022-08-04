import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
//import { Validations } from "./quoteValidations"; CLA TO DO
import { CalHelper } from "./quoteAFSCommercialCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/AFSLogo";
import AFSCOMMERCIALRATES_IMG from "@salesforce/resourceUrl/AFSCommercial";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteAFSCommercialCalc extends LightningElement {
    //tableRatesCols = CalHelper.tableRateDataColumns;
    isBusy;
    isBaseRateBusy;
    isCalculated = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage(); 
    @track quoteForm;
    // Rate Settings
    //@track tableRates;
    @wire(getRecord, { recordId: "$recordId", fields }) 
    opp;

    connectedCallback() {
    }

    // lifecycle hook - after rendering all components(child+parent), will triggered
    renderedCallback() {
    }
    //Images
    get logoUrl() {
        return LENDER_LOGO;
    }
    get afsCommercialRates() {
        return AFSCOMMERCIALRATES_IMG;
    }

    // Combobox options
    get loanTypeOptions() {
        return CalHelper.options.loanTypes;
    }

    get loanProductOptions() {
        return CalHelper.options.loanProducts;
    }

    get termOptions() {
        return CalHelper.options.terms;
    }

    get carAgeOptions() {
        return CalHelper.options.carAges;
    }

    get residencyOptions() {
        return CalHelper.options.residency;
    }

    get paymentTypeOptions() {
        return CalHelper.options.paymentTypes;
    }

    get gstOptions() {
        return CalHelper.options.gst;
    }

    // Calculations
    get disableAction() {
        return !this.isCalculated;
    }

    // -------------
    // Button events
    // -------------

    handleFieldChange(event) {

    }

    // Calculate
    handleCalculate(event) {

    }

    // Reset
    handleReset(event) {

    }

}