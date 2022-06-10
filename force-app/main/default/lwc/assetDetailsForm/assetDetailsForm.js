import { LightningElement, api, track, wire } from "lwc";
import { NavigationMixin, CurrentPageReference } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getCustomOpportunities from '@salesforce/apex/assetDetailsFormController.getCustomOpportunities'
import getMakeSelectOptions from '@salesforce/apex/assetDetailsFormController.getMakeSelectOptions'
import getYears from '@salesforce/apex/assetDetailsFormController.getYears'
import assetDetailsFormController from '@salesforce/apex/assetDetailsFormController'
// import  getYears  from '@salesforce/apex/GlassServicesHelper.getYears';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = [
    'Custom_Opportunity__c.Name',
    'Custom_Opportunity__c.Application__c',
];

export default class GlassServiceEstimatorPage extends LightningElement {

    initialization(){
        this.assetType = 'Car';
        this.newUsed = 'new';
        this.carPrice = 0;
        this.deposit = 0;
        this.warranty = 0;
        this.gap = 0;
        this.lpi = 0;
        this.lti = 0;
        this.fees = 0;
        this.quotingFees = 0;
        this.isRefinanceMacq = false;
        this.isDetail = 1;

        // retrieving existing data from DB
        // loadSavedData();
           
        if(this.assetType == 'Car'){
            this.detailsIsVisible = true;
        }else{
            this.detailsIsVisible = false;
        }   

        this.rendered = true;
    }

    assetType = null;
    newUsed = null;
    year = null;
    yearSelect = null;
    make = null;
    makeSelect = null;
    badgeRedbook = null;
    badgeSelectRedbook = null;
    model = null;
    modelSelect = null;
    family = null;
    familySelect = null;
    badgeRedbook = null;
    badgeSelectRedbook = null;
    variantRedbook = null;
    variantSelectRedbook = null;
    variantObj = null;
    variantDesc = null;
    variantSelect = null;
    variantNewPrice = 0.0;
    actualKms = 0;
    assetOptionsData = null;
    assetOptions = [];
    totalPriceOptions = 0.0;
    totalEstimated = 0.0;   
    totalTradeLowPriceOptions = 0.0;
    totalTradePriceOptions = 0.0;
    totalRetailPriceOptions = 0.0;
    totalTradeLowPriceKms = 0.0;
    totalTradePriceKms = 0.0;
    totalRetailPriceKms = 0.0;
    series = null;
    seriesSelect = null;
    isDetail = 0;
    currentOpportunity;
    error = '';
    detailsIsVisible = true;
    typeLoan = null;
    carPrice = 0;
    deposit = 0;
    warranty = 0;
    gap = 0;
    lpi = 0;
    lti = 0;
    fees = 0;
    quotingFees = 0;
    isRefinanceMacq;
    state;
    assetOptionsSelect;
    assetStandardFeautersData;
    lender;
    variantOptionsMap;
    modelObj;
    
    @track rendered = false;

    @api recordId;

    @wire(getCustomOpportunities, {recordId: '$recordId'}) wiredRecord({error, data}){
        if(data){
            console.log(data);
            this.currentOpportunity = data;
            this.state = data.Dealer_State__c;
            console.log("state:::"+this.state);
            console.log(this.currentOpportunity);
        }else{
            this.error = error;
        }
    }

    getYears() {
        
        getYears({ newUsed: this.newUsed, assetType: this.assetType })
            .then((result) => {
                console.log(result)
                this.yearSelect = Object.entries(result).map(([value,label]) => ({ value, label }));
                this.error = undefined;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
                this.contacts = undefined;
            });
    }

    getMakeSelectOptions() {
        console.log(this.newUsed+":::::"+this.assetType)
        getMakeSelectOptions({ newUsed: this.newUsed, year: this.year })
            .then((result) => {
                console.log('make:::::'+result)
                this.makeSelect = Object.entries(result).map(([value,label]) => ({ value, label }));
                this.make = this.makeSelect[Object.keys(result).length-1].value;
                this.error = undefined;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
                this.contacts = undefined;
            });
    }

    // useEffect
    connectedCallback() {
        this.rendered = false;
        // sample record ID - Bill
        this.recordId = 'a011y000002vcGTAAY';
        this.initialization();
        this.loadNewUsedYearOptions();
        this.getMakeSelectOptions();
    }

    get lenderOptions() {
        return [
            { label: 'Affordable', value: 'Affordable' },
            { label: 'AFS', value: 'AFS' },
            { label: 'ANZ', value: 'ANZ' },
            { label: 'APF', value: 'APF' },
            { label: 'BOQ', value: 'BOQ' },
            { label: 'Finance 1', value: 'Finance 1' },
            { label: 'Finance Now', value: 'Finance Now' },
            { label: 'Firstmac', value: 'Firstmac' },
            { label: 'Green Light', value: 'Green Light' },
            { label: 'Latitude', value: 'Latitude' },
            { label: 'Liberty', value: 'Liberty' },
            { label: 'Macquarie', value: 'Macquarie' },
            { label: 'Metro', value: 'Metro' },
            { label: 'Money 3', value: 'Money 3' },
            { label: 'Pepper', value: 'Pepper' },
            { label: 'Plenti', value: 'Plenti' },
            { label: 'UME Loans', value: 'UME Loans' },
            { label: 'Wisr', value: 'Wisr' },
            { label: 'Yamaha', value: 'Yamaha' },
        ];
    }
 
    get newOrUsedOptions() {
        return [
            { label: 'New', value: 'new' },
            { label: 'Demo', value: 'demo' },
            { label: 'Used', value: 'used' },
        ];
    }

    get assetTypes() {
        return [
            { label: 'Car', value: 'Car' },
            { label: 'Motorcycle', value: 'Motorcycle' },
            { label: 'Marine', value: 'Marine' },
            { label: 'Caravan', value: 'Caravan' },
            { label: 'Truck', value: 'Truck' },
            { label: 'Equipment', value: 'Equipment' },
        ];
    }

    get typeLoanOptions(){
        return [
            { label: 'Consumer', value: 'Consumer' },
            { label: 'Commercial', value: 'Commercial' },
            { label: 'Chattel Mortgage', value: 'Chattel Mortgage' },
            { label: 'Leasing', value: 'Leasing' },
        ];
    }

    get getStatesOptions(){
        return [
            { label: 'SA', value: 'SA' },
            { label: 'WA', value: 'WA' },
            { label: 'NSW', value: 'NSW' },
            { label: 'QLD', value: 'QLD' },
            { label: 'VIC', value: 'VIC' },
            { label: 'NT', value: 'NT' },
            { label: 'ACT', value: 'ACT' },
            { label: 'TAS', value: 'TAS' },
        ];
    }

    loadNewUsedYearOptions() {
        console.log('loadNewUsedYearOptions... ' + this.newUsed + ' >> ' + this.assetType);
        this.clearNewUsedYear();
        this.clearLenderMake();

        if (this.newUsed != null) {
            this.getYears();
        }
        if(this.isDetail == 0 || this.isDetail == 2 || this.isDetail == 3)
        listCars();

    }

    clearModelVariant() {
        this.variantObj = null;
        this.variantDesc = null;
        this.variantSelect = null;
        this.clearVariantSeries();
    }

    clearNewUsedYear() {
        this.year = null;
        this.yearSelect = null;
        this.clearLenderMake();
    }

    clearVariantSeries() {
        this.series = null;
        this.seriesSelect = null;
        clearVariantFactoryOptions();
    }

    clearVariantFactoryOptions() {
        this.variantNewPrice = 0.0;
        this.actualKms = 0;
        this.assetOptionsData = null;
        if (this.assetOptions != null) {
            this.assetOptions.clear();
        }
        this.assetOptionsSelect = null;
        this.assetStandardFeautersData = null;
        variantOptionsMap = new Map();
        this.calculateEstimation();
    }

    calculateEstimation() {
        totalPriceOptions = 0.0;
        totalEstimated = 0.0;
        
        totalTradeLowPriceOptions = 0.0;
        totalTradePriceOptions = 0.0;
        totalRetailPriceOptions = 0.0;
        
        if (assetOptionsData != null && assetOptions != null) {
            for (const optCode of assetOptions) {
                // AssetOptionDTO fo = assetOptionsData.get(optCode);
                // Decimal value = fo.value;
                if (fo != null) {
                    totalPriceOptions += value;
                }
            }
            if ('new'.equals(newUsed) || 'demo'.equals(newUsed)) {
              if (variantObj.Retail_Price__c != null && variantObj.Retail_Price__c > 0) {
                //value = value * .8;
                //value = value.setScale(-2);
                totalRetailPriceOptions += totalPriceOptions;
                totalTradePriceOptions += (totalPriceOptions * .5);
                totalTradeLowPriceOptions += (totalPriceOptions * .3);
              }
            } else if ('used'.equals(newUsed)) {
            //   Decimal value = GlassServicesHelper.calculateUsedOptions(assetOptions, year);
                
              totalRetailPriceOptions += value;
              totalTradePriceOptions += (value * .5);
              totalTradeLowPriceOptions += (value * .3);
            }    
        }
        calculateKmsAdjustment();
        totalEstimated = variantNewPrice + totalPriceOptions;
    }

    calculateKmsAdjustment() {
        this.totalTradeLowPriceKms = 0.0;
        this.totalTradePriceKms = 0.0;
        this.totalRetailPriceKms = 0.0;
        
        if ('used'.equalsIgnoreCase(this.newUsed) && this.variantObj != null && ac > 0 && !'AFS'.equals(this.lender)) {
            this.totalRetailPriceKms = assetDetailsFormController.calculateAdjustment(this.variantObj.KM_Category__c, this.actualKms, getAverageKM());
            if (this.totalRetailPriceKms != 0) {
                this.totalTradeLowPriceKms = this.totalRetailPriceKms * .5;
                this.totalTradeLowPriceKms = this.totalRetailPriceKms * .3;
            }
        }
    }

    clearLenderMake() {
        this.make = null;
        this.makeSelect = null;
        this.badgeRedbook = null;
        this.badgeSelectRedbook = null;
        this.clearMakeModelOrFamily();
    }

    clearMakeModelOrFamily() {
        this.clearMakeFamily();
        this.clearModelVariant();
        this.clearFamilyBadge();
        this.clearVariantSeries();
    }

    clearModelVariant() {
        this.variantObj = null;
        this.variantDesc = null;
        this.variantSelect = null;
        this.clearVariantSeries();
    }

    clearVariantSeries() {
        this.series = null;
        this.seriesSelect = null;
        clearVariantFactoryOptions();
    }

    clearVariantFactoryOptions() {
        this.variantNewPrice = 0.0;
        this.actualKms = 0;
        this.assetOptionsData = null;
        if (this.assetOptions != null) {
            this.assetOptions.clear();
        }
        this.assetOptionsSelect = null;
        this.assetStandardFeautersData = null;
        variantOptionsMap = new Map();
        calculateEstimation();
    }

    clearMakeFamily() {
        this.model = null;
        this.modelSelect = null;
        this.family = null;
        this.familySelect = null;
        this.clearFamilyBadge();
    }

    clearFamilyBadge() {
        this.badgeRedbook = null;
        this.badgeSelectRedbook = null;
        this.clearBadgeVariant();
    }

    clearBadgeVariant(){
        this.variantRedbook = null;
        this.variantSelectRedbook = null;
        //vehicleObj = null;
    }

    loadLenderMakeOptions(event) {
        console.log(event.target.value+'::::'+this.year);
        // clearLenderMake();
        // clearMake();

        console.log(this.year == null);
        
        if (this.year == '') {
            this.year = event.target.value;
            this.getMakeSelectOptions();
        }
        // if(isDetail == 0 || isDetail == 2 || isDetail == 3)
        //     listCars();
    }

    listCars(){
        if(this.series != null){
            this.isDetail = 0;
        }else{
            this.isDetail = 1;
            clecarModel();
            clearVariant();
            clearVariantFactoryOptions();    
        }
    }

    clearModel() {
        this.modelObj = null;
    }

    clearVariant() {
        this.variantObj = null;
    }

}