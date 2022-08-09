import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
//import { Validations } from "./quoteValidations"; CLA TO DO
import { CalHelper } from "./quoteAFSConsumerCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/AFSLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];
const oppID = 'a01Bm00000192uuIAA'; 
export default class QuoteAFSConsumerCalc extends LightningElement {
    tableRatesCols = CalHelper.tableRateDataColumns;
    isBusy;
    isBaseRateBusy;
    isCalculated = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage(); 
    @track quoteForm;
    // Rate Settings
    @track tableRates;
    @wire(getRecord, { recordId: "$recordId", fields }) 
    opp;

    connectedCallback() {
        this.isBusy = true;
        this.reset(); 
        //CalHelper.load(this.recordId)
        CalHelper.load(oppID) 
            .then((data) => {
            console.log(`==> Data in JS `, JSON.stringify(data));
            //console.log(`JS DATA `, JSON.stringify(data));
            this.quoteForm = data;
            this.tableRates = CalHelper.getTableRatesData();
            })
            .catch((error) => {
            
            displayToast(this, "Loading...", error, "error");
            })
            .finally(() => {
            this.isBusy = false;
            //this.baseRateCalc(); TO DO
            });
    }

    // lifecycle hook - after rendering all components(child+parent), will triggered
    renderedCallback() {
        QuoteCommons.resetValidateFields(this); 
    }
    //Images
    get logoUrl() {
        return LENDER_LOGO;
    }

    // Combobox options
    get loanTypeOptions() {
        return CalHelper.options.loanTypes;
    }

    get loanProductOptions() {
        return CalHelper.options.loanProducts;
    }

    get assetTypeOptions() {
        return CalHelper.options.assetTypes;
    }

    get assetConditionOptions() {
        return CalHelper.options.assetConditions;
    }

    get termOptions() {
        return CalHelper.options.terms;
    }

    get assetAgeOptions() {
        return CalHelper.options.assetAges;
    }

    get residencyOptions() {
        return CalHelper.options.residency;
    }

    get employmentStatsOptions() {
        return CalHelper.options.employmentStats;
    }

    get creditImpairedOptions() {
        return CalHelper.options.creditImpaireds;
    }

    get payDayEnquiriesOptions() {
        return CalHelper.options.payDayEnqs;
    }

    get importsOptions() {
        return CalHelper.options.imports;
    }

    get odometerOptions() {
        return CalHelper.options.odometers;
    }

    get privateSalesOptions() {
        return CalHelper.options.privateSales;
    }

    get paymentTypeOptions() {
        return CalHelper.options.paymentTypes;
    }

    // Calculations
    get netDeposit() {
        return CalHelper.getNetDeposit(this.quoteForm);
    }

    get netRealtimeNaf() {
        return CalHelper.getNetRealtimeNaf(this.quoteForm); 
    }

    get disableAction() {
        return !this.isCalculated;
    }

    // Reset
     reset() {
    
        //this.quoteForm = CalHelper.reset(this.recordId); CLA TO DO
        this.quoteForm = CalHelper.reset(oppID);
    }

    // -------------
    // Button events
    // -------------

    handleFieldChange(event) {
        const fldName = event.target.name;
        this.isCalculated = false;
        let fld = this.template.querySelector(`[data-id="${fldName}-field"]`);
        let v = event.detail ? event.detail.value : "";
        if (fld && fld.type === "number") {
        v = Number(v);
        }
        this.quoteForm[fldName] = v;
        this.quoteForm["netDeposit"] = this.netDeposit;
        fldName === "term"
        ? (this.quoteForm[fldName] = parseInt(v))
        : (this.quoteForm[fldName] = v); 
        // --------------
        // Trigger events
        // --------------

        // Base Rate Calculation
        if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
        //this.baseRateCalc(); CLA TO DO
        }
    }

    // Calculate
    handleCalculate(event) {

    }

    // Reset
    handleReset(event) {
        //this.quoteForm = CalHelper.reset(this.recordId); CLA TO DO
        this.quoteForm = CalHelper.reset(oppID);
    }

   



}