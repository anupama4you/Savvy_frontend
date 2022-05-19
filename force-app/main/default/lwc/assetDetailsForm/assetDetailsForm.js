import { LightningElement, api, track, wire } from "lwc";
import { NavigationMixin, CurrentPageReference } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getCustomOpportunities from '@salesforce/apex/assetDetailsFormController.getCustomOpportunities'
import  getYears  from '@salesforce/apex/GlassServicesHelper.getYears';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = [
    'Custom_Opportunity__c.Name',
    'Custom_Opportunity__c.Application__c',
];

export default class GlassServiceEstimatorPage extends LightningElement {
    _assetType = 'Car';
    get assetType() {
        return this._assetType;
    }
    set assetType(value) {
        this._assetType = value;
    }
    _newUsed = 'new';
    get newUsed() {
        return this._newUsed;
    }
    set newUsed(value) {
        this._newUsed = value;
    }
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
    series = null;
    seriesSelect = null;
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

    @api recordId;

    @wire(getCustomOpportunities, {recordId: '$recordId'}) wiredRecord({error, data}){
        if(data){
            this.currentOpportunity = data;
        }else{
            this.error = error;
        }
    }

    handleSearch() {
        getYears({ newUsed: this.newUsed, assetType: this.assetType })
            .then((result) => {
                this.yearSelect = result;
                console.log('years', yearSelect);
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.contacts = undefined;
            });
    }

    @wire(getYears, {newUsed: '$newUsed', assetType : '$assetType'}) wiredRecord2({error, data}){
        if(data){
            this.yearSelect = data;
            console.log('years', data)
        }else{
            this.error = error;
        }
    }
 
    get newOrUsedOptions() {
        return [
            { label: 'New', value: 'New' },
            { label: 'Demo', value: 'Demo' },
            { label: 'Used', value: 'Used' },
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
    

    loadNewUsedYearOptions() {
        console.log('loadNewUsedYearOptions... ' + this.newUsed + ' >> ' + this.assetType);
        // clearNewUsedYear();
        // clearMake();
        if (this.newUsed != null) {
            this.yearSelect = this.yearSelect;
            console.log('xxx',this.yearSelect)
        }
        if(this.isDetail == 0 || this.isDetail == 2 || this.isDetail == 3)
            this.listCars();
    }

    listCars(){
        // if(series != null){
        //     this.isDetail = 0;
        // }else{
        //     this.isDetail = 1;
        //     this.clearModel();
        //     this.clearVariant();
        //     this.clearVariantFactoryOptions();    
        // }
    }

    clearVariant() {
        variantObj = null;
    }

    clearModel() {
        this.modelObj = null;
    }

    clearNewUsedYear() {
        year = null;
        yearSelect = null;
        clearLenderMake();
    }

    clearLenderMake() {
        make = null;
        makeSelect = null;
        badgeRedbook = null;
        badgeSelectRedbook = null;
        clearMakeModelOrFamily();
    }

    clearMakeModelOrFamily() {
        clearMakeFamily();
        clearModelVariant();
        clearFamilyBadge();
        //Jesus Mora 2019-11-07 start
        clearVariantSeries();
        //Jesus Mora 2019-11-07 end
    }

    clearMakeFamily() {
        model = null;
        modelSelect = null;
        family = null;
        familySelect = null;
        clearFamilyBadge();
    }

    clearFamilyBadge() {
        badgeRedbook = null;
        badgeSelectRedbook = null;
        clearBadgeVariant();
    }

    clearBadgeVariant(){
        variantRedbook = null;
        variantSelectRedbook = null;
        //vehicleObj = null;
    }

    clearModelVariant() {
        variantObj = null;
        variantDesc = null;
        variantSelect = null;
        clearVariantSeries();
    }

    clearVariantSeries() {
        series = null;
        seriesSelect = null;
        clearVariantFactoryOptions();
    }

    clearVariantFactoryOptions() {
        variantNewPrice = 0.0;
        actualKms = 0;
        assetOptionsData = null;
        if (assetOptions != null) {
            assetOptions.clear();
        }
        assetOptionsSelect = null;
        assetStandardFeautersData = null;
        // variantOptionsMap = new Map<String, List<AssetOptionDTO>>();
        calculateEstimation();
    }

    calculateEstimation() {
        totalPriceOptions = 0.0;
        totalEstimated = 0.0;
        
        totalTradeLowPriceOptions = 0.0;
        totalTradePriceOptions = 0.0;
        totalRetailPriceOptions = 0.0;
        
        if (assetOptionsData != null && assetOptions != null) {
            // for (String optCode : assetOptions) {
            //     AssetOptionDTO fo = assetOptionsData.get(optCode);
            //     Decimal value = fo.value;
            //     if (fo != null) {
            //         totalPriceOptions += value;
            //     }
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
    
        calculateKmsAdjustment();
        totalEstimated = variantNewPrice + totalPriceOptions;
    }

    calculateKmsAdjustment() {
        totalTradeLowPriceKms = 0.0;
        totalTradePriceKms = 0.0;
        totalRetailPriceKms = 0.0;
        
        if ('used'.equalsIgnoreCase(newUsed) && variantObj != null && actualKms > 0 && !'AFS'.equals(lender)) {
            totalRetailPriceKms = GlassServicesHelper.calculateAdjustment(variantObj.KM_Category__c, actualKms, getAverageKM());
            if (totalRetailPriceKms != 0) {
                totalTradePriceKms = totalRetailPriceKms * .5;
                totalTradeLowPriceKms = totalRetailPriceKms * .3;
            }
        }
    }

    clearVariantSeries() {
        series = null;
        seriesSelect = null;
        clearVariantFactoryOptions();
    }

    clearVariantFactoryOptions() {
        variantNewPrice = 0.0;
        actualKms = 0;
        assetOptionsData = null;
        if (assetOptions != null) {
            assetOptions.clear();
        }
        assetOptionsSelect = null;
        assetStandardFeautersData = null;
        // variantOptionsMap = new Map<String, List<AssetOptionDTO>>();
        calculateEstimation();
    }

    // constructor
    connectedCallback() {
        // sample record ID - Bill
        this.recordId = 'a011y000002vcGTAAY';
        this.loadNewUsedYearOptions();
        this.handleSearch();
    }
}