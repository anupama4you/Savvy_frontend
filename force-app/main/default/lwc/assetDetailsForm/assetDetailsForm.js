import { LightningElement, api, track, wire } from "lwc";
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { NavigationMixin, CurrentPageReference } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getCustomOpportunities from '@salesforce/apex/assetDetailsFormController.getCustomOpportunities';
import getMakeSelectOptions from '@salesforce/apex/assetDetailsFormController.getMakeSelectOptions';
import getYears from '@salesforce/apex/assetDetailsFormController.getYears';
import calculateAdjustment from '@salesforce/apex/assetDetailsFormController.calculateAdjustment';
import validateRedBookLenders from '@salesforce/apex/assetDetailsFormController.validateRedBookLenders';
import searchMakeRedbookCode  from '@salesforce/apex/assetDetailsFormController.searchMakeRedbookCode';
import getMakeModelsSelectOptionsAux  from '@salesforce/apex/assetDetailsFormController.getMakeModelsSelectOptionsAux';
import getMakeModelsSelectOptionsRedbook from '@salesforce/apex/assetDetailsFormController.getMakeModelsSelectOptionsRedbook';
import getModelVariantsSelectOptionsAux from '@salesforce/apex/assetDetailsFormController.getModelVariantsSelectOptionsAux';
import getVariantSeriesSelectOptionsAux from '@salesforce/apex/assetDetailsFormController.getVariantSeriesSelectOptionsAux';
import getMakeModelsSelectOptions from '@salesforce/apex/assetDetailsFormController.getMakeModelsSelectOptions';
import getMakeByCode from '@salesforce/apex/assetDetailsFormController.getMakeByCode';
import getGlassCarsSize from '@salesforce/apex/assetDetailsFormController.getGlassCarsSize';
import getCarsList from '@salesforce/apex/assetDetailsFormController.getCarsList';
import getVariantFactoryOptions from '@salesforce/apex/assetDetailsFormController.getVariantFactoryOptions';
import calculateUsedOptions from '@salesforce/apex/assetDetailsFormController.calculateUsedOptions';
import getFamilyBadgeSelectOptionsRedbook from '@salesforce/apex/assetDetailsFormController.getFamilyBadgeSelectOptionsRedbook';
import getBadgeVariantsSelectOptions from '@salesforce/apex/assetDetailsFormController.getBadgeVariantsSelectOptions';
import getVehicle from '@salesforce/apex/assetDetailsFormController.getVehicle';
import getStreetTypeOptions from '@salesforce/apex/assetDetailsFormController.getStreetTypeOptions';
import getCodeModel from '@salesforce/apex/assetDetailsFormController.getCodeModel';
import getStatesOptions from '@salesforce/apex/assetDetailsFormController.getStatesOptions';
import getApplicationQuoting from '@salesforce/apex/assetDetailsFormController.getApplicationQuoting';
import insertAssetDetails from '@salesforce/apex/assetDetailsFormController.insertAssetDetails';
import isUserIdSettlementTeam from '@salesforce/apex/assetDetailsFormController.isUserIdSettlementTeam';
// import  getYears  from '@salesforce/apex/GlassServicesHelper.getYears';

// FIELDS :::
// import ID from '@salesforce/schema/Custom_Opportunity__c.Id';
// import APPLICATION_C from '@salesforce/schema/Custom_Opportunity__c.Application__c';
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";

const FIELDS = [ FNAME_FIELD, LNAME_FIELD ];

let initialOpp = {
    Id : null,
    Name : null,
    Application__c : null,
    Purchase_Type__c : null,
    Dealer_Name__c : null,
    Dealer_Contact_Name__c : null,
    Dealer_Email__c : null,
    Dealer_Phone_Number__c : null,
    Dealer_Mobile__c : null,
    Dealer_Unit_Number__c : null,
    Dealer_Street_Number__c : null,
    Dealer_Address__c : null,
    Dealer_Street_Type__c : null,
    Dealer_Suburb__c : null,
    Dealer_Postcode__c : null,
    Dealer_State__c : null,
    Owner_Email__c : null,
    Loan_Product__c : null,
    Contract_Number__c : null,
    Dealer_Type__c : null,
    Application_AssetDetail__r : null
}

let intitialMakeObj = {
    Name : null
}

let initialVariantObject = {
    Code__c : null,
    Description__c : null,
    Transmission__c : null,
    Year__c : null,
    Family__c : null,
    Style__c : null,
    Engine__c : null,
    Size__c : null,
    NVIC__c : null,
    Release_Date__c : null,
    Series__c : null,
    CC__c : null,
    Cylinders__c : null
}


export default class GlassServiceEstimatorPage extends LightningElement {

    @track opp = initialOpp;
    @track makeObject = intitialMakeObj;
    @track variantObject = initialVariantObject;
    @track warnings = [];

    @api recordId;
    @track displayComp = false;
    @api showCloneBtn;
    oppUrl;
    customOpp = initialOpp;
    // @track yearSelectLatest = null;

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    oppty

    @wire(getCustomOpportunities, {recordId: '$recordId'}) wiredRecord({error, data}){
        if(data){
            console.log('wiredMethod:::'+JSON.stringify(data));
            this.opp = JSON.parse(JSON.stringify(data));
            this.customOpp = data;
            console.log('OPPPPPPPP:::', data)
            
            if(this.loadSavedData()){
                this.displayComp = true;
            }else{
                this.initialization();
                this.displayComp = true;
            }
            this.loadNewUsedYearOptions1();  
            this.loadStreetTypeOptions();
            this.loadStatesOptions();
         
        }else{
            this.error = error;
        }
    }


    // useEffect
    connectedCallback() {
        console.log('recordId:::',this.recordId)

        this.rendered = false;
        this.test = ''
        console.log('Detail::::', this.isDetail)
    }

        
    get fullName() {
        let fn = "";
        let t = getFieldValue(this.oppty.data, FNAME_FIELD);
        fn += t && t.trim().length > 0 ? t : "";
        fn += " ";
        t = getFieldValue(this.oppty.data, LNAME_FIELD);
        fn += t && t.trim().length > 0 ? t : "";
        return fn;
    }

    get displayFactoryOptions(){
        if(this.assetOptions ){
            return true;
        }else{
            return false;
        }
    }
    
    get isAssetCompleted1(){
        console.log('isAssetCompleted1>>', this.assetType == 'Car', this.newUsed, this.year)
        if(this.assetType == 'Car' && this.newUsed  && this.year ){
            return false;
        }else{
            return true;
        }
    }
    get isAssetCompleted2(){
        if(this.assetType == 'Car' && this.newUsed  && this.year  && this.make ){
            return false;
        }else{
            return true;
        }
    }
    get isAssetCompleted3(){
        if(this.assetType == 'Car' && this.newUsed  && this.year  && this.make  && this.model ){
            return false;
        }else{
            return true;
        }
    }
    get isAssetCompleted4(){
        console.log('isAssetCompleted4>>', this.variantDesc == null, this.variantDesc == '', !this.variantDesc)
        if(this.assetType == 'Car' && this.newUsed && this.year && this.make && this.model && this.variantDesc){
            return false;
        }else{
            return true;
        }
    }

    get isUserSettlementTeam() {
        isUserIdSettlementTeam({userId : this.recordId})
        .then((result) => {
            return result;
        })
        .catch((error) => {
            console.log(error);
            this.error = error;
        });
        
        return ;
    }

    initialization(){
        this.assetType = 'Car';
        this.newUsed = 'new';
        this.carPrice = 0;
        this.deposit = 0.0;
        this.warranty = 0;
        this.gap = 0;
        this.lpi = 0;
        this.lti = 0;
        this.fees = 0;
        this.quotingFees = 0;
        this.isRefinanceMacq = false;
        this.isDetail = 1;
        this.displayCarList = false;
        this.variantObj = 
        {
            New_Price__c : null,
            Retail_Price__c : null,
            KM_Category__c : null,
            Trade_Low_Price__c : null,
            Trade_Price__c : null,
            Retail_Price__c : null,
            Trade_Low_Price__c : null,
            Trade_Price__c : null,
            Type_Source__c : null,
            Family__c : null,
            Code__c : null,
            Average_Kms__c : null
        };
        this.totalPriceOptions = 0.0;
        this.totalEstimated = 0.0;
        this.totalTradeLowPriceOptions = 0.0;
        this.totalTradePriceOptions = 0.0;
        this.totalRetailPriceOptions = 0.0;
        this.showOptions = false;


        // dummy values
        // this.actualKms = 100000

        // retrieving existing data from DB
        // loadSavedData();
           
        if(this.assetType == 'Car'){
            this.detailsIsVisible = true;
        }else{
            this.detailsIsVisible = false;
        }   
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
    familySelect = [];
    badgeRedbook = null;
    badgeSelectRedbook = null;
    variantRedbook = null;
    variantSelectRedbook = null;
    variantObj = {};
    variantDesc = null;
    variantSelect = null;
    variantNewPrice = 0.0;
    actualKms = 0;
    assetOptionsData;
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
    currentOpp;
    error = '';
    detailsIsVisible = true;
    typeLoan = null;
    @track carPrice = 0;
    deposit = 0;
    warranty = 0;
    gap = 0;
    lpi = 0;
    lti = 0;
    @track fees = 0;
    quotingFees = 0;
    isRefinanceMacq;
    state;
    assetOptionsSelect ;
    assetStandardFeautersData;
    lender;
    variantOptionsMap;
    modelObj;
    variantOptionsMap;
    makeObj = {}; 
    makeRedbook;
    isvalidateRedBookLenders;
    abc;
    variant;
    labelV;
    variantCode;
    displayCarList; 
    isTable1;
    isTable2;
    isTable3;
    carList;
    glassMake;
    carListLen;
    glassVariant;
    IsDetail0;
    IsDetail2;
    IsDetail3;
    vehicleObj = {};
    streetType;
    streetTypeOptions_;
    makeOVehicle;
    modelOVehicle;
    variantOVehicle;
    seriesOVehicle;
    rego;
    vin;
    engine;
    colour;
    regoState;
    statesOptions;
    purchaseTypes;
    purchaseType;
    dealerType;
    dealerName;
    dealerPhoneNo;
    dealerStreetNo;
    dealerSuburb;
    dealerContactName;
    dealerMobile;
    dealerAddress;
    dealerPostCode;
    dealerEmail;
    dealerUnitNo;
    dealerStreetType;
    dealerState;
    contractNumber;
    showOptions;
    application_AssetDetail__r = {
        PPSR_Proxy_Id__c : null,
        PPSR_Proxy_Last_Update__c : null,
        Search_Certificate_Number__c : null,
        PPSR_Proxy_Message__c : null
    }
    progress = 0;
    visibleProgress;

    test;
    
    @track rendered = false;

    getCarsList(setBtn){

        console.log("check variables got values:::", this.make , this.model, this.variantDesc , this.series)

        if(this.make && this.model && this.variantDesc && this.series){

            var carParameter = {
                year : this.year,
                make : this.make,
                family : this.model,
                variant : this.variantDesc,
                series : this.series,
                IdCar : this.variant
            }

            getCarsList({ wrapper: carParameter })
            .then((result) => {
                console.log("glassMakeRec:::", JSON.stringify(result.glassMakeRec))
                console.log("glassVariantObj:::", JSON.stringify(result.glassVariantObj))
                console.log("glassVariant:::", JSON.stringify(result.glassVariant))

                this.carsList = result.glassVariantObj;
                // this.IsDetail0 = true;
                this.carListLen = Object.keys(result.glassVariantObj).length;
                this.glassMake = result.glassMakeRec;
                this.makeObj = result.glassMakeRec;
                this.glassVariant = result.glassVariant;

                if(setBtn){
                    this.IsDetail0 = true;
                    this.IsDetail2 = false;
                    this.IsDetail3 = false;
                }

                console.log('CarList:::', result.glassVariantObj)
                // this.isDetail = true;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
                this.contacts = undefined;
            });      

        }
    }


    loadStreetTypeOptions(){
        getStreetTypeOptions()
        .then((result) => {
            console.log('getStreetTypeOptions::::', result)
            this.streetTypeOptions_ = Object.entries(result).map(([value,label]) => ({ value, label }));
        })
        .catch((error) => {
            console.log(error);
            this.error = error;
        });
    }

    getVariantFactoryOptions(load){

        console.log("check variables:::", this.make , this.model, this.variantDesc , this.series)

            var carParameter = {
                year : this.year,
                make : this.make,
                family : this.model,
                variant : this.variantDesc,
                series : this.series,
                serie : this.series,
                IdCar : this.variant
            }

            console.log('Car Parameter:::', carParameter)

            getVariantFactoryOptions({ wrapper: carParameter })
            .then((result) => {
                console.log('xxxxx::', result)

                this.glassVariant = result.glassVariant;

                console.log('Glass Variant:::', load);
                if(load != true){
                    this.clearVariantFactoryOptions();
                }

                this.variantOptionsMap = result.variantOptionsMap;
                this.assetOptionsData = result.assetStandardFeautersData.assetOptionsData; 
                this.assetOptionsSelect = Object.entries(result.assetStandardFeautersData.assetOptionsSelect).map(([value,label]) => ({ value, label }));

                if(this.assetOptionsSelect && Object.keys(this.assetOptionsSelect).length > 0){
                    console.log('show options:;', this.showOptions)
                    this.showOptions = true;
                }else{
                    this.showOptions = false;
                }

                // this.assetOptionsSelect = result.assetStandardFeautersData.assetOptionsSelect;

                console.log('assetOptionsSelect:::', result.assetStandardFeautersData.assetOptionsSelect)
                console.log('assetOptions:::', this.assetOptions)

                this.assetStandardFeautersData = result.assetStandardFeautersData.assetStandardFeautersData; 

                this.variantObj = result.variantObj;
                this.variantObject = result.variantObj;

                // this.IsDetail2 = true;
                // this.IsDetail0 = false;

                if(this.variantObj ){
                    this.variantNewPrice = this.variantObj.New_Price__c;
                }

                // this.model = result.model;
                console.log("model:::", JSON.stringify(result.model))
                this.calculateEstimation();

                    if(load == true){
                        if(this.glassVariant ){
                            this.model = this.glassVariant.Family__c;
                            this.getModelVariantsSelectOptionsAuxFunc();
                            this.variantDesc = this.glassVariant.Description__c;
                            this.loadVariantSeriesOptions(null, false);
                            this.series = this.glassVariant.Series__c;
                            this.isDetail = 3;

                            //load table
                            if(this.isDetail == 0 || this.isDetail == 2 || this.isDetail == 3){
                                this.getCarsList();
                            }
                    
                            if(this.isDetail == 0){
                                this.IsDetail0 = true;
                                this.IsDetail2 = false;
                                this.IsDetail3 = false;
                            }else if(this.isDetail == 2){
                                this.IsDetail0 = false;
                                this.IsDetail2 = true;
                                this.IsDetail3 = false;
                            }else if(this.isDetail == 3){
                                this.IsDetail0 = false;
                                this.IsDetail2 = false;
                                this.IsDetail3 = true;
                            }
                            // this.IsDetail3 = true;
                            console.log('working...//',this.IsDetail3, this.carList )
                            this.getVariantFactoryOptions(false);
                        }
                    }

            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            });      

        // }
    }

    loadFamilyBadgeOptions(e) {
        if(e && e.target && e.target.value){
            this.family = e.target.value;
        }

        this.clearFamilyBadge();
        if (this.family ) {
            console.log('loadFamilyBadgeOptions: Family ' + this.family);
            this.getFamilyBadgeSelectOptionsRedbook();
            
        }
    }

    loadBadgeVariantOptions(e){
        if(e && e.target && e.target.value){
            this.badgeRedbook = e.target.value;
        }

        this.clearBadgeVariant();
        if (this.badgeRedbook ) {
            this.getBadgeVariantsSelectOptions();
        }
    }

    loadRedbookVehicle(RedbookKey, load){
        getVehicle({redbookKey: RedbookKey})
        .then((result) => {
            this.vehicleObj = result.vehicleByRedbookKey;
            if(load){
                if(this.vehicleObj ){
                    this.family = this.vehicleObj.Family_Code__c;
                    this.loadFamilyBadgeOptions();
                    this.badgeRedbook = this.vehicleObj.Badge_Description__c;
                }
                this.loadBadgeVariantOptions();
            }
        })
        .catch((error) => {
            console.log(error);
            this.error = error;
        });  
    }

    getVehicleKey(e){
        if(e && e.target && e.target.value){
            this.variantRedbook = e.target.value;
        }

        if(this.variantRedbook ){
            getVehicle({code: this.variantRedbook})
            .then((result) => {
                this.vehicleObj = result.vehicleByRedbookKey;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            });  
        }
    }

    calculateFactoryOptions(event) {
        console.log('button assetoptions::', this.assetOptions)

        if(event && event.detail){
            this.assetOptions = event.detail.value ;
        }

        console.log('button assetoptions::', this.assetOptions)
        this.calculateEstimation();
    }

    getYears() {
        getYears({ newUsed: this.newUsed, assetType: this.assetType })
            .then((result) => {
                console.log(result)
                console.log('year list::', result)
                this.yearSelect = Object.entries(result).map(([value,label]) => ({ value, label })).reverse();
                console.log('year select::', this.yearSelect)
                this.error = undefined;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
                this.contacts = undefined;
            });
    }

    getBadgeVariantsSelectOptions(){
        getBadgeVariantsSelectOptions({ makeRedbook: this.makeRedbook, model: this.family, badge: this.badgeRedbook })
        .then((result) => {
            console.log(result)
            console.log('getBadgeVariantsSelectOptions::', result)
            this.variantSelectRedbook = Object.entries(result).map(([value,label]) => ({ value, label })).reverse();
        })
        .catch((error) => {
            console.log(error);
            this.error = error;
            this.contacts = undefined;
        });
    }

    calculateUsedOptions(assetOpt) {
        console.log('calculateUsedOptions-PARA::::', assetOpt, this.year);
        const x = calculateUsedOptions({ options: assetOpt, year: this.year })
            .then((result) => {
                console.log('calculateUsedOptions::::',result);
                return result;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
                return error;
            });
        return x;
    }

    getFamilyBadgeSelectOptionsRedbook() {
        getFamilyBadgeSelectOptionsRedbook({ code: this.family, make: this.makeRedbook, year: this.year, lender: this.lender })
            .then((result) => {
                console.log('getFamilyBadgeSelectOptionsRedbook::::',result);
                this.badgeSelectRedbook = Object.entries(result).map(([value,label]) => ({ value, label }));
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
                return error;
            });
    }

    loadVariantFactoryOptions(event){

        if(event && event.target && event.target.name == 'backToList1'){
            this.IsDetail0 = true;
            this.IsDetail2 = false;
            this.IsDetail3 = false;
            this.isDetail = 0;
            if(event && event.target && event.target.value){
                this.variant = event.target.value;
            }
            console.log('car List', this.carsList)
        }else{
            if(event && event.target && event.target.value){
                this.variant = event.target.value;
            }
            this.getVariantFactoryOptions();
            this.IsDetail0 = false;
            this.IsDetail2 = true;
            this.IsDetail3 = false;
            this.isDetail = 2;
        }

    }

    changeDetails(e){
        const fieldName = e.target.name;
        if(fieldName == 'make'){
            this.make = e.target.value;
        }else if(fieldName == 'model'){
            this.model = e.target.value;
        }else if(fieldName == 'variant'){
            this.variantDesc = e.target.value;
        }else if(fieldName == 'series'){
            this.series = e.target.value;
        }
    }

    // retrieving make models --> glass & redbook
    loadMakeModelOrFamilyOptions(event){
        if(event && event.target && event.target.name == 'make'){
            this.make = event.target.value;
        }

        this.clearMakeModelOrFamily();
        this.clearMake();
        
        if(this.make ){

            var carParameter = {
                year : this.year,
                make : this.make,
                newUsed : this.newUsed,
                lender : this.lender,
                code : this.make
            }
            getMakeModelsSelectOptions({wrapper : carParameter}).then((result) => {
                console.log('Glass Data:'+ JSON.stringify(result.glassObj));
                console.log('Redbook Data:'+ JSON.stringify(result.redObj));
                this.modelSelect = Object.entries(result.glassObj).map(([value,label]) => ({ value, label }));
                this.familySelect = Object.entries(result.redObj).map(([value,label]) => ({ value, label }));

                //  this.makeObj & this.glassMake;
                this.getMakeByCodeFunc();

            }).catch(error => {
                console.error(error);
                this.error = error;
            }); 
        }

        if(this.isDetail == 0 || this.isDetail == 2 || this.isDetail == 3)
            this.listCars();
    }

    loadMake() {
        console.log('make function triggered!')
        if(this.make  && this.newUsed  && this.year ){
            var carParameter = {
                year : this.year,
                make : this.make,
                newUsed : this.newUsed,
                lender : this.lender,
                code : this.make
            }
            getMakeModelsSelectOptions({wrapper : carParameter}).then((result) => {
                console.log('MAKE() - Redbook Data:'+ JSON.stringify(result.redObj));
                this.familySelect = Object.entries(result.redObj).map(([value,label]) => ({ value, label }));
            }).catch(error => {
                console.error(error);
                this.error = error;
            }); 
    }
    }

    putFeesValueTypeLoan(event) {
        if(event.target.name == 'typeLoan'){
            this.typeLoan = event.target.value;
        }
        
        this.loadMake();
        this.fees = this.ltvFeeValue;
    }

    putFeesValue(event) {
        if(event.target.name = 'lender'){
            this.lender = event.target.value;
        }
        
        this.loadMake();
        this.fees = this.ltvFeeValue;
    }

    get isSearchCertificateNumber(){
        if(this.opp && this.opp.Application_AssetDetail__r){
            if(this.opp.Application_AssetDetail__r.Search_Certificate_Number__c == ''){
                // console.log('isSearchCertificateNumber::', 'ppsr_sent');
                return false;
            }else{
                // console.log('isSearchCertificateNumber::', 'ppsr_ok');
                return true;
            }
        }else{
            return false;
        }
    }

    get isVehicleDetails(){
        if(this.assetType == 'Car'){
            return true;
        }else{
            return false;
        }
    }

    get dyanamicSection(){
        if(this.assetType == 'Car'){
            return true;
        }else{
            return false;
        }
    }

    get isDetailsTexts(){
        if(this.assetType == 'Car'){
            return true;
        }else{
            return false;
        }
    }

    get CarsSizeFunc(){
        console.log('Car Object',this.CarObj);
        return 0; 
    }

    get purchaseTypeOptions() {
        return [
            { label: '--None--', value: '' },
            { label: 'Dealer', value: 'Dealer' },
            { label: 'Dealer - Vehicles Direct', value: 'ANZ' },
            { label: 'Private', value: 'APF' },
            { label: 'Private Sale - Verimoto', value: 'BOQ' },
            { label: 'Priavate with ABN', value: 'Finance 1' },
            { label: 'Refinance', value: 'Finance Now' },
            { label: 'Refinance Macquarie', value: 'Firstmac' },
            { label: 'Sales and Leaseback', value: 'Green Light' }
        ];
    }

    get dealerTypeOptions() {
        return [
            { label: '--None--', value: '' },
            { label: 'Independent Dealer - Cars', value: 'Independent Dealer - Cars' },
            { label: 'Franchised Dealer - Cars', value: 'Franchised Dealer - Cars' },
            { label: 'Leisure Dealer', value: 'Leisure Dealer' },
            { label: 'Equipment Dealer', value: 'Equipment Dealer' },
            { label: 'Other', value: 'Other' }
        ];
    }

    calculateAdjustmentFunc(){
        console.log('calculateAdjustment:::',this.variantObj.KM_Category__c,  this.actualKms, this.averageKM)
        const x = calculateAdjustment({category : this.variantObj.KM_Category__c , kms : this.actualKms ,  average : this.averageKM})
        .then((result) => {
            console.log(result)
            console.log('calculateAdjustment:::',result);
            // this.totalRetailPriceKms = result
            return result;
        })
        .catch((error) => {
            console.log(error);
            this.error = error;
        });
        return x;
    }

    get averageKM() {
        if (this.variantObj  && this.variantObj.Average_Kms__c ) {
            return this.variantObj.Average_Kms__c * 1000;
        }
        return 0;
    }

    searchMakeRedbookCodeFunc(){
        const x = searchMakeRedbookCode({make :this.make, newUsed : this.newUsed, year: this.year})
        .then((result) => {
            console.log(result)
            this.makeRedbook = result
            return result;
        })
        .catch((error) => {
            console.log(error);
            this.error = error;
        });
        return x;
    }

    getMakeModelsSelectOptionsRedbookFunc(){
        getMakeModelsSelectOptionsRedbook({code :this.makeRedbook, year: this.year})
        .then((result) => {
            console.log('results::::'+result)
            this.familySelect = Object.entries(result).map(([value,label]) => ({ value, label }));
            console.log("family select:::"+ this.familySelect);
        })
        .catch((error) => {
            console.log(error);
            this.error = error;
        });
    }

    getMakeModelsSelectOptionsAuxFunc(){
        console.log('getMakeModelsSelectOptionsAux...');
        getMakeModelsSelectOptionsAux({code :this.make, newUsed: this.newUsed, year: this.year})
        .then((result) => {
            console.log('getMakeModelsSelectOptionsAux:', result);
            this.modelSelect = Object.entries(result).map(([value,label]) => ({ value, label }));
        })
        .catch((error) => {
            console.error(error);
            this.error = error;
        });
    }

    getMakeByCodeFunc(){
        console.log('getMakeByCodeFunc:::', this.make)
        getMakeByCode({code :this.make})
        .then((result) => {
            console.log('Make object::', JSON.stringify(result) )
            this.makeObj = result;
            this.makeObject = result;
            this.glassMake = result;
        })
        .catch((error) => {
            console.log(error);
            this.error = error;
        });
    }


    get displayClass(){
        if(this.variantObject && this.variantObject.Type_Source__c == 'CVG'){
            return 'Light Commercial Vehicles';
        }else if(this.variantObject && this.variantObject.Type_Source__c == 'PVG'){
            return 'Passenger Vehicles';
        }else if(this.variantObject && this.variantObject.Type_Source__c == 'OCG'){
            return 'Older Cars';
        }else if(this.variantObject && this.variantObject.Type_Source__c == 'OLC'){
            return 'Older Light Commercial';
        }
        return null;
    }

    getModelVariantsSelectOptionsAuxFunc(){
        console.log("getModelVariantsSelectOptionsAuxFunc::::", this.model, this.year, this.make);
        getModelVariantsSelectOptionsAux({code: this.model, year: this.year, make: this.make})
        .then((result) => {
            console.log('variant options:::'+ JSON.stringify(result))
            this.variantSelect = Object.entries(result).map(([value,label]) => ({ value, label }));
        })
        .catch((error) => {
            console.log(error);
            this.error = error;
        });
    }

    // loadVariantSeriesOptionsFunc() {
    //     this.clearVariantSeries();
    //     if (this.variantDesc ) {
    //         seriesSelect = GlassServicesHelper.getVariantSeriesSelectOptionsAux(variantDesc, model, year, make);
    //     }
    //     if(isDetail == 0 || isDetail == 2 || isDetail == 3)
    //         this.listCars();
    //     if(seriesSelect  && seriesSelect.size()==1)
    //         isDetail=0;
    // }

    getVariantSeriesSelectOptionsAuxFunc(){
        console.log("getVariantSeriesSelectOptionsAux::::", this.variantDesc, this.model, this.year, this.make);
        getVariantSeriesSelectOptionsAux({variantDesc: this.variantDesc, model: this.model, year: this.year, make: this.make})
        .then((result) => {
            console.log(result)
            this.seriesSelect = Object.entries(result).map(([value,label]) => ({ value, label }));
        })
        .catch((error) => {
            console.log(error);
            this.error = error;
        });
    }

    setSeries(event){
        if(event.target.name == 'series'){
            this.series = event.target.value;
        }

        this.isDetail = 0;
        this.getCarsList(true);
    }


    get isDisabledLenderOptions(){
        if(this.year == null){
            return true
        }else{
            return false
        }
    }

    get CarLabel() {
        var label = 'Car';
        if ('Car' != this.assetType) {
            label = 'Vehicle';
        }
        return label;
    }


    loadModelVariantOptions(event, load) {

        if(event && event.target && event.target.name == 'model'){
            this.model = event.target.value;
        }

        if(!load){
            this.clearModelVariant();
        }

        if (this.model ) {
            this.getModelVariantsSelectOptionsAuxFunc();
        }
        if(this.isDetail == 0 || this.isDetail == 2 || this.isDetail == 3)
            this.listCars();
    }

    loadVariantSeriesOptions(event, load) {
        if(event && event.target && event.target.name == 'variant'){
            this.variantDesc = event.target.value;
        }

        if(load != false){
            this.clearVariantSeries();
        }
        
        if (this.variantDesc ) {
            this.getVariantSeriesSelectOptionsAuxFunc();
        }
        if(this.isDetail == 0 || this.isDetail == 2 || this.isDetail == 3)
            this.listCars();
        if(this.seriesSelect  && Object.keys(this.seriesSelect).length == 1)
            this.IsDetail0 = true;
            this.isDetail = 0;
    }

    clearMakeModelOrFamily() {
        this.clearMakeFamily();
        this.clearModelVariant();
        this.clearFamilyBadge();
        this.clearVariantSeries();
    }

     validateRedBookLendersFunc(){
        console.log("validateRedBookLenders...", this.lender);
        const x = validateRedBookLenders({lender: this.lender})
            .then((result) => {
                this.isvalidateRedBookLenders = result;
                return result;
            })
            .catch((error) => {
                this.error = undefined;
                return error;
            });
        return x;
    }

    getMakeSelectOptionsFunc() {
        console.log("getMakeSelectOptions...", this.newUsed, this.year);
        getMakeSelectOptions({ newUsed: this.newUsed, year: this.year })
            .then((result) => {
                this.makeSelect = Object.entries(result).map(([value,label]) => ({ value, label }));
                // this.make = this.makeSelect[Object.keys(result).length-1].value;
                this.error = undefined;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
                this.contacts = undefined;
            });
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

    renderedCallback(){
        // console.log('Get cars List!!')

       

        // console.log('isDetail::', this.isDetail )


    }

    get typeLoanOptions(){
        return [
            { label: '--None--', value: '' },
            { label: 'Consumer', value: 'Consumer' },
            { label: 'Commercial', value: 'Commercial' },
            { label: 'Chattel Mortgage', value: 'Chattel Mortgage' },
            { label: 'Leasing', value: 'Leasing' },
        ];
    }

    loadStatesOptions(){
        getStatesOptions()
        .then((result) => {
            console.log('states options::', result)
            this.statesOptions = Object.entries(result).map(([value,label]) => ({ value, label }));
        })
        .catch((error) => {
            console.log(error);
            this.error = error;
        });
    }

    loadNewUsedYearOptions(event) {
        if(this.assetOptions ){
                this.assetOptions = [];
            }
            this.assetOptionsSelect = null;

        if(event.target.name == 'assetType'){
            this.assetType = event.target.value;
            this.clearNewUsedYear();
            this.clearMake();
        }

        if(event.target.name == 'newUsed'){
            this.newUsed = event.target.value;
            if(this.assetType == 'Car'){
                this.clearNewUsedYear();
                this.clearMake();
            }
        }

        console.log('loadNewUsedYearOptions... ' + this.newUsed + ' >> ' + this.assetType);

        if(this.carList ){
            this.carList = null;
        }

        if (this.newUsed ) {
            this.getYears();
        }
        if(this.isDetail == 0 || this.isDetail == 2 || this.isDetail == 3)
            this.listCars();

    }

    loadNewUsedYearOptions1() {
        console.log('loadNewUsedYearOptions... ' + this.newUsed + ' >> ' + this.assetType);

        if (this.newUsed ) {
            this.getYears();
        }
        if(this.isDetail == 0 || this.isDetail == 2 || this.isDetail == 3)
            this.listCars();

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
        this.clearVariantFactoryOptions();
    }

    clearVariantFactoryOptions() {
        this.variantNewPrice = 0.0;
        // this.actualKms = 0;
        // this.assetOptionsData = null;
        // if (this.assetOptions ) {
        //     this.assetOptions = [];
        // }
        // this.assetOptionsSelect = null;
        this.assetStandardFeautersData = null;
        this.variantOptionsMap = null;
        this.calculateEstimation();
    }

    calculateEstimation() {
        console.log('Calculate estimation:::');

        var totalPriceOptions = 0.0;
        var totalEstimated = 0.0;
        var totalTradeLowPriceOptions = 0.0;
        var totalTradePriceOptions = 0.0;
        var totalRetailPriceOptions = 0.0;

        
        if (this.assetOptionsData  && this.assetOptions ) {

            console.log('asset Options Data 1:::', this.assetOptionsData);
            console.log('asset Options  1:::', this.assetOptions);

            let assetOpts = this.assetOptions;
            let assetData = this.assetOptionsData;

            let total = 0;
            for(let i = 0; i < this.assetOptions.length; i++){ 
                console.log('Opt Obj:::', Object.keys(this.assetOptionsData)) 

                Object.keys(this.assetOptionsData)
                .forEach(function eachkey(key){
                    if(key == assetOpts[i]){
                        total = total + parseInt(assetData[key][0].value) 
                        console.log('prices:::',  assetData[key][0].value)
                    }
                })
            }

            totalPriceOptions = total;
            console.log('Total Price Options::', totalPriceOptions)

            if ('new' == this.newUsed || 'demo' == this.newUsed) {
              if (this.variantObj.Retail_Price__c  && this.variantObj.Retail_Price__c > 0) {
                //value = value * .8;
                //value = value.setScale(-2);
                totalRetailPriceOptions += totalPriceOptions;
                totalTradePriceOptions += (totalPriceOptions * .5);
                totalTradeLowPriceOptions += (totalPriceOptions * .3);
              }

              
            } else if ('used' == this.newUsed) {
                console.log('calculateUsedOptions>>>>', assetOpts)

                calculateUsedOptions({ options: assetOpts, year: this.year })
                .then((value) => {
                    console.log('calculateUsedOptions>>>', value)
                    if(value){
                        console.log('totalRetailPriceOptions1::', value)
                        totalRetailPriceOptions += value;
                        totalTradePriceOptions += (value * 0.5);
                        totalTradeLowPriceOptions += (value * 0.3);
                        console.log('totalRetailPriceOptions1::', totalRetailPriceOptions)
                    }else{
                        totalRetailPriceOptions += 0;
                        totalTradePriceOptions += 0;
                        totalTradeLowPriceOptions += 0;
                    }

                    this.totalRetailPriceOptions = totalRetailPriceOptions;
                    this.totalTradePriceOptions = totalTradePriceOptions;
                    this.totalTradeLowPriceOptions = totalTradeLowPriceOptions;
                })
                .catch((error) => {
                    console.error(error);
                    this.error = error;
                });

             console.log('****TEST-->>', totalRetailPriceOptions)

                    // this.totalRetailPriceOptions = totalRetailPriceOptions;
                    // this.totalTradePriceOptions = totalTradePriceOptions;
                    // this.totalTradeLowPriceOptions = totalTradeLowPriceOptions;
    
                // }).catch(err => {
                //     this.error = err;
                //     console.log(err);
                // });
                
            }    
        }
       
        totalEstimated = this.variantNewPrice + totalPriceOptions;

        this.totalPriceOptions = totalPriceOptions;
        this.totalEstimated = totalEstimated;
        this.totalTradeLowPriceOptions = totalTradeLowPriceOptions;
        this.totalTradePriceOptions = totalTradePriceOptions;
        this.totalRetailPriceOptions = totalRetailPriceOptions;

        this.calculateKmsAdjustment();
    }

    calculateKmsAdjustment(event) {

        var totalRetailPriceKms = 0;
        var totalTradePriceKms = 0;
        var totalTradeLowPriceKms = 0;
        

        console.log('calculateKmsAdjustment:::')

        if(event && event.target && event.target.name  ){
            if(event.target.name == 'calculateKmsAdjustment'){
                this.actualKms = event.target.value;
            }
        }else{
        
            if ('used' == this.newUsed.toLowerCase() && this.variantObj  && this.actualKms > 0 && 'AFS' != this.lender) {

                Promise.resolve(this.calculateAdjustmentFunc()).then(value => {
                    if(value){
                    totalRetailPriceKms = value;
                    console.log('totalRetailPriceKms::', totalRetailPriceKms)
                    }
                    if (totalRetailPriceKms != 0) {
                        totalTradePriceKms = totalRetailPriceKms * 0.5;
                        totalTradeLowPriceKms = totalRetailPriceKms * 0.3;
                    }
                    this.totalRetailPriceKms = totalRetailPriceKms;
                    this.totalTradePriceKms = totalTradePriceKms;
                    this.totalTradeLowPriceKms = totalTradeLowPriceKms;
                }).catch(err => {
                console.log(err);
                });
            
            }
            this.totalRetailPriceKms = totalRetailPriceKms;
            this.totalTradePriceKms = totalTradePriceKms;
            this.totalTradeLowPriceKms = totalTradeLowPriceKms;
        }
    }

    get carLabelPriceSuff(){
        return this.CarLabel + 'Price'
    }

    selectedPurchaseType(event){

        if(event && event.target){
            this.purchaseType = event.target.value;
        }

        this.isRefinanceMacq = false;
        if ('Refinance_Macq' == this.purchaseType){
            this.isRefinanceMacq = true;
        }else{
            this.contractNumber = '';
        }

    }

    get ltvCarAge() {
        var gap = 0;
        const today = new Date();
        console.log('car age::::', today.getUTCFullYear() - parseInt(this.year))
        gap = today.getUTCFullYear() - parseInt(this.year);
        if(Number.isNaN(gap) || gap < 0){
            return 0;
        }else{
            return gap;
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
        this.clearVariantFactoryOptions();
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
        if(this.assetType == 'Car'){
            this.clearLenderMake();
            this.clearMake();
        }

        if(event && event.target && event.target.name == 'year'){
            this.year = event.target.value;
            console.log('::year::'+this.year);
        }

        if(this.assetType == 'Car'){

            if(this.year ){
                this.getMakeSelectOptionsFunc();
            }

            if(this.isDetail == 0 || this.isDetail == 2 || this.isDetail == 3)
                this.listCars();
        }
    }

    checkCarList(){
        this.getCarsList();
    }

    clearMake() {
        this.makeObj = null;
        this.makeObject = intitialMakeObj;
    }

    listCars(){

        if(this.series ){
            this.isDetail = 0;
            this.IsDetail0 = true;
            this.IsDetail2 = false;
            this.IsDetail3 = false;
        }else{
            this.isDetail = 1;
            this.IsDetail0 = false;
            this.IsDetail2 = false;
            this.IsDetail3 = false;
            this.clearModel();
            this.clearVariant();
            this.clearVariantFactoryOptions();    
        }
    }

    clearModel() {
        this.modelObj = null;
    }

    clearVariant() {
        this.variantObj = null;
        this.variantObject = initialVariantObject;
    }

    // getters :::::::

    get tradeLowAdjustedValue() {
        if (this.variantObj ) { 
            return (this.variantObj.Trade_Low_Price__c + this.totalTradeLowPriceOptions + this.totalTradeLowPriceKms);
        }
        return 0.0;
    }

    get tradeAdjustedValue() {
        if (this.variantObj ) {
            return (this.variantObj.Trade_Price__c + this.totalTradePriceOptions + this.totalTradePriceKms);
        }
        return 0.0;
    }

    get reatilAdjustedValue() {
        if (this.variantObj ) {
            console.log('reatilAdjustedValue:::', this.variantObj.Retail_Price__c + this.totalRetailPriceOptions + this.totalRetailPriceKms)
            const val = this.variantObj.Retail_Price__c + this.totalRetailPriceOptions + this.totalRetailPriceKms;
            return val;
        }
        return 0.0;
    }

    get tradeLowGlassValue() {
        if (this.variantObj ) {
            return (this.variantObj.Trade_Low_Price__c);
        }
        return 0.0;
    }

    get tradeGlassValue() {
        if (this.variantObj ) {
            return (this.variantObj.Trade_Price__c);
        }
        return 0.0;
    }

    get retailGlassValue() {
        if (this.variantObj ) {
            return (this.variantObj.Retail_Price__c);
        }
        return 0.0;
    } 

    get ltvFeeValue() {
        let quFee = this.quotingFees;
        return (quFee);
    }   

    // pending.....
    get ltvValueLabel() {
        let labelVal = 'RRP';
        console.log('Label::::', this.lender)
        if ('used' == this.newUsed) {
            if ('ANZ' == this.lender) {
                labelVal = 'Trade Value';
            } 
            else if ('Liberty' == this.lender) { 
                if (this.ltvCarAge >= 10) {
                    labelVal = 'Trade Value';
                } else {
                    labelVal = 'Retail Value';
                }
            }
        }
        return labelVal;
    }

    get carPriceLabel(){
        return this.CarLabel + ' Age';
    }

    get ltvLvrLabel() {
        let label = 'LVR';
        if ('St George' == this.lender || 'Macquarie' ==  this.lender || 'Pepper' ==  this.lender) {
            label = 'Estimated LVR';
        }
        return label;
    }

    get ltvValue() {
        let r = this.totalEstimated;
        if ('used' == this.newUsed) {
            if ('ANZ' == this.lender) {
                r =  this.TradeAdjustedValue;
            } else if ('Liberty' == this.lender) { 
                if (this.ltvCarAge >= 10) {
                    r =  this.TradeAdjustedValue;
                } else {
                    r = this.reatilAdjustedValue;
                }
            } else {
                r = this.reatilAdjustedValue;
            }
        } else if (
          'demo' == this.newUsed &&
          'Macquarie' == this.lender
        ) {
          r = this.reatilAdjustedValue;
        }
        return r;
    }

    get ltvNAFValue() {
        let r = 0;
        // this.LtvFeeValue;
        if(this.fees ){
            r += parseFloat(this.fees)
        }

        if (this.warranty ) {
            r += parseFloat(this.warranty);
        }
        if (this.gap ) {
            r += parseFloat(this.gap);
        }

        if (('ANZ' != this.lender) && ('Liberty' != this.lender)) {
            if (this.lpi ) {
                r += parseFloat(this.lpi);
            }
            if (this.lti ) {
                r += parseFloat(this.lti);
            }
        }
        if (this.carPrice ) {
            r += parseFloat( this.carPrice);
        }

        if (this.deposit ) {
            r -= parseFloat(this.deposit);
        }


        return parseFloat(r);
     
    }

    get ltvLvrValue() {
        let value = this.ltvValue;
        let naf = this.ltvNAFValue;
        if (value != 0) {
            let r = (naf/value);
            console.log('getLtvLvrValue >> ' + r);
            return r;
            // return r.setScale(0, System.RoundingMode.DOWN);
        } else {
            return 0;
        }
    }

    get displayRedbookForm() {
        let r = false;
        const x = Promise.resolve(this.validateRedBookLendersFunc()).then(value => {
            if(value){
                r = value;
            }else{
                r = value;
            }
        }).catch(err => {
            console.log(err);
        });
        console.log('display::out::', this.isvalidateRedBookLenders)
        return this.isvalidateRedBookLenders;
    }

    isValidRequiredFields(){
        console.log('test function')
        let isValid = true;
        this.template.querySelectorAll('.validate').forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                console.log('invalid fields:::', inputField.label);
                isValid = false;
            }          
       });
       console.log('validation results::', isValid)
       return isValid;
    }

    carPriceChange(e){
        if(e.target.value){
            this.carPrice = e.target.value;
        }else{
            this.carPrice = 0;
        }
    }

    warrantyChange(e){
        this.warranty = e.target.value;
    }

    certificateChange(e){
        this.application_AssetDetail__r[e.target.name] = e.target.value;
        console.log('certificateChange', this.application_AssetDetail__r);
    }

    depositChange(e){
        this.deposit = e.target.value;
    }

    gapChange(e){
        this.gap = e.target.value;
    }

    averageKMChange(e){
        this.averageKM = e.target.value;
    }

    feesChange(e){
        if(e.target.value){
            this.fees = e.target.value;
        }else{
            this.fees = 0;
        }
    }

    lpiChange(e){
        this.lpi = e.target.value;
    }

    // all values in vendor details changed from here
    dealerValChange(e){
        this.opp[e.target.name] = e.target.value;   
    }

    regoNoChange(e){
        this.rego = e.target.value;
    }

    stateChange(e){
        this.regoState = e.target.value;
    }

    VinChange(e){
        this.vin = e.target.value;
    }

    engineChange(e){
        this.engine = e.target.value;
    }

    colourChange(e){
        this.colour = e.target.value;
    }

    // load saved data
    loadSavedData(){
        console.log('Load saved Data:::::');
        console.log(JSON.stringify( this.opp))

        this.visibleProgress = false;

        if(this.opp.Application_AssetDetail__c ){
            var aad = {};
            aad = this.opp.Application_AssetDetail__r;
            console.log('AAD::::', aad);

            this.assetType = aad.Type__c;
            this.lender = aad.Lender__c;
            if(this.assetType == 'Car'){
                this.newUsed = aad.Condition__c;
                this.loadNewUsedYearOptions1();
                this.year = aad.Year__c.toString();
                this.loadLenderMakeOptions();
                this.make = aad.Make__c;
                this.loadMakeModelOrFamilyOptions();
                this.model = aad.Model__c;
                this.loadModelVariantOptions();
                this.variant = aad.Variant__c;
                this.variantDesc = aad.Variant_Desc__c;
                this.loadVariantSeriesOptions();
                this.series = aad.Series__c;
                this.getVariantFactoryOptions(true);

                console.log('working.....', this.glassVariant);

                if(aad.Redbook_key__c ){
                    this.loadRedbookVehicle(aad.Redbook_Key__c, true);
                    this.variantRedbook = aad.Redbook_Key__c;
                }

                if(aad.Factory_Options__c ){
                    this.assetOptions = JSON.parse(aad.Factory_Options__c);
                    console.log('Factory options::::', this.assetOptions)
                }

                this.calculateFactoryOptions();

            }else{
                this.newUsed = aad.Condition__c;
                this.loadNewUsedYearOptions1();
                this.year = aad.Year__c;
                this.makeOVehicle = aad.Make__c;
                this.modelOVehicle = aad.Model__c;
                this.variantOVehicle = aad.Variant__c;
                this.seriesOVehicle = aad.Series__c;
            }

            this.typeLoan = aad.Type_Loan__c;
            this.carPrice = aad.Price__c;
            this.deposit = aad.Deposit__c;
            this.warranty = aad.Warranty__c;
            this.gap = aad.GAP__c;
            this.lpi = aad.LPI__c;
            this.fees =  aad.Fees__c;

            if (aad.Actual_KM__c ) {
                console.log(aad.Actual_KM__c)
                this.actualKms = aad.Actual_KM__c;
            }

            this.rego = aad.Rego__c;
            this.vin = aad.VIN__c;
            this.engine = aad.Engine_No__c;
            this.colour = aad.Colour__c;
            this.regoState = aad.Rego_State__c;

            var carParameter = {
                year : this.year,
                make : this.make,
                family : this.model,
                variant : this.variantDesc,
                serie : this.series,
                IdCar : this.variant
            }

            this.purchaseType = this.opp.Purchase_Type__c;
            // this.dealerAddress = this.opp.Dealer_Address__c;
            // this.dealerContactName = this.opp.Dealer_Contact_Name__c;
            // this.dealerEmail = this.opp.Dealer_Email__c;
            // this.dealerMobile = this.opp.Dealer_Mobile__c;
            // this.dealerName = this.opp.Dealer_Name__c;
            // this.dealerPhoneNo = this.opp.Dealer_Phone_Number__c; 
            // this.dealerType = this.opp.Dealer_Type__c;
            // this.dealerUnitNo = this.opp.Dealer_Unit_Number__c;
            // this.dealerStreetType = this.opp.Dealer_Street_Type__c;
            // this.dealerState = this.opp.Dealer_State__c;
            // this.contractNumber = this.opp.Contract_Number__c;
            // this.dealerStreetNo = this.opp.Dealer_Street_Number__c;
            // this.dealerSuburb = this.opp.Dealer_Suburb__c;
            // this.dealerPostCode = this.opp.Dealer_Postcode__c;

            console.log('parameters:::', carParameter)

            return true;

            // unecessary snippet ---//
            // getCodeModel({ param : carParameter })
            // .then((result) => {
            //     console.log('get code model:::', result)
            //     this.model = result;
            // })
            // .catch((error) => {
            //     console.log(error);
            //     this.error = error;
            // }); 
     
        }

        //Load from Quoting tool
        getApplicationQuoting({oppId: this.opp.Id, appId: this.opp.Application__c})
        .then((d) => {
            console.log('getApplicationQuoting::::', d)
            if (d ) {
                if (d.Name =='ANZ') {
                    this.lender = 'ANZ';
                } else if (d.Name =='Macquarie') {
                    this.lender = 'Macquarie';
                } else if (d.Name =='Pepper MV') {
                    this.lender = 'Pepper';
                } else if (d.Name =='Liberty') {
                    this.lender = 'Liberty';
                } else if (d.Name =='Finance') {
                    this.lender = 'Finance 1';
                } else if (d.Name =='Money') {
                    this.lender = 'Money 3';
                } else if (d.Name =='Yamaha') {
                    this.lender = 'Yamaha';
                } else if (d.Name =='Metro') {
                    this.lender = 'Metro';
                } else if (d.Name =='Latitude') {
                    this.lender = 'Latitude';
                } else if (d.Name =='AFS') {
                    this.lender = 'AFS';
                } else if (d.Name =='Green') {
                    this.lender = 'Green Light';
                } else if (d.Name =='Plenti' || d.Name =='RateSetter') {
                    this.lender = 'Plenti';
                } else if (d.Name =='Wisr') {
                    this.lender = 'Wisr';
                } else {
                    this.lender = d.Name;
                }
                //Type loan
                if ('Consumer Loan' == d.Loan_Product__c) {
                    this.typeLoan = 'Consumer';
                } else if (d.Loan_Product__c ) {
                    if (d.Loan_Product__c =='Lease') {
                        this.typeLoan = 'Leasing';
                    } else if (d.Loan_Product__c =='Chattel') {
                        this.typeLoan = 'Chattel Mortgage';
                    }
                }
                
                this.carPrice = d.Vehicle_Price__c;
                // this.deposit = 0;
                // this.warranty = 0;
                // this.gap = 0;
                // this.lpi = 0;
                // this.lti = 0;
                if (d.Net_Deposit__c ) {
                    this.deposit += d.Net_Deposit__c;
                }
                if ('A' == d.Insurance_Warranty_Acceptance__c) {
                    this.warranty = d.Insurance_Warranty_Retail_Price__c;
                } else if ('A' ==d.Insurance_NWC_Acceptance__c) {
                    this.warranty = d.Insurance_NWC_Retail_Price__c;
                }
                if ('A' ==d.Insurance_GAP_Acceptance__c) {
                    this.gap = d.Insurance_GAP_Retail_Price__c;
                } else if ('A' ==d.Insurance_VEI_Acceptance__c) {
                    this.gap = d.Insurance_VEI_Retail_Price__c;
                }
                if ('A' ==d.Insurance_LTI_Acceptance__c) {
                    this.lti = d.Insurance_LTI_Retail_Price__c;
                }
                if ('A' ==d.Insurance_LPI_Acceptance__c) {
                    this.lpi = d.Insurance_LPI_Retail_Price__c;
                } else if ('A' ==d.Insurance_AIC_Acceptance__c) {
                    this.lpi = d.Insurance_AIC_Retail_Price__c;
                }
    
                // this.quotingFees = 0;
                if (d.Application_Fee__c ) {
                    this.quotingFees += d.Application_Fee__c;
                }
                
                if ('Liberty' ==this.lender) {
                    if (d.Registration_Fee__c ) {
                        this.quotingFees += d.Registration_Fee__c;
                    }
                } else {
                    if (d.DOF__c ) {
                        this.quotingFees += d.DOF__c;
                    }
                }
                
                if ('Money 3' ==this.lender) {
                    if ('Asset Finance' == d.Customer_Profile__c) {
                        if (d.Risk_Fee__c ) {
                            this.quotingFees += d.Risk_Fee__c;
                        }
                    }
                }
                
                if ('Finance 1' ==this.lender) {
                    if (d.Risk_Fee__c ) {
                        this.quotingFees += d.Risk_Fee__c;
                    }
                }
                
                if (d.PPSR__c ) {
                    this.quotingFees += d.PPSR__c;
                }
                if ('Latitude' == d.Name ||
                    d.Name.startsWith('AFS')) {
                    if (d.Registration_Fee__c ) {
                        this.quotingFees += d.Registration_Fee__c;
                    }
                }
            }
            
            this.selectedPurchaseType();
            this.calculateKmsAdjustment();

            return true;
        })
        .catch((error) => {
            console.log(error);
            this.error = error;
        })

        return false;
    }

    //  SHOW toast
    showToast(type, message) {
        const event = new ShowToastEvent({
            title: type,
            message: message,
                variant: type,
        });
        this.dispatchEvent(event);
    }
 

    isPdfReadyToGenerate(prefixFile) {
        let isOk = true;
        // return isOk;
        if(this.isValidRequiredFields()){
            if (prefixFile ) {
                if (this.opp.Application__c == null) {
                    this.showToast('error','Please create an Application form before saving for any appoval process.');
                    isOk = false;
                }
                if(prefixFile.includes('FORMAL_APPROVAL')) {
                    let t = ' in Vendor Details section before saving for Formal Approval.';
                    let fields = [];

                    if (!this.opp.Dealer_Name__c){
                        // this.showToast('error','Please fill a Vendor Name'+t);
                        fields.push('[Vendor Name]');
                        isOk = false;       
                    }
                    if (!this.opp.Dealer_Email__c){
                        // this.showToast('error','Please fill an Email'+t);
                        fields.push('[Email]');
                        isOk = false;       
                    }
                    if (!this.opp.Dealer_Address__c){
                        // this.showToast('error','Please fill an Address'+t);
                        fields.push('[Address]');
                        isOk = false;       
                    }
                    if (!this.opp.Dealer_Contact_Name__c){
                        // this.showToast('error','Please fill a Contact Name'+t);
                        fields.push('[Contact Name]');
                        isOk = false;       
                    }
                    if (!this.opp.Dealer_Phone_Number__c){
                        // this.showToast('error','Please fill a Phone Number'+t);
                        fields.push('[Phone Number]');
                        isOk = false;       
                    }
                    if (!this.opp.Dealer_Suburb__c){
                        // this.showToast('error','Please fill a Suburb'+t);
                        fields.push('[Suburb]');
                        isOk = false;       
                    }
                    if (!this.opp.Dealer_Postcode__c){
                        // this.showToast('error','Please fill an Address'+t);
                        fields.push('[Address]');
                        isOk = false;       
                    }
                    if (!this.opp.Dealer_State__c) {
                        // this.showToast('error','Please fill a State'+t);
                        fields.push('[State]');
                        isOk = false;       
                    }
                    if (!this.opp.Dealer_Type__c){
                        // this.showToast('error','Please fill a Dealer Type'+t);
                        fields.push('[Dealer Type]');
                        isOk = false;       
                    }
                    this.showToast('error','Please fill '+ fields +t);
                }
            }
            if (this.assetType == 'Car') {
                if (this.variantObj == null) {
                    this.showToast('error','Please select a variant of the car model before generating the Pdf.');
                    isOk = false;
                }
            } else {
                if (this.year == null) {
                    this.showToast('error','Please select a year before generating the Pdf.');
                    isOk = false;
                }
                if (this.makeOVehicle == null || this.modelOVehicle == null || this.variantOVehicle == null || this.seriesOVehicle == null) {
                    this.showToast('error','Please fill all detail fields before generating the Pdf.');
                    isOk = false;
                }
            }
            if (this.lender == null) {
                this.showToast('error','Please select a Lender in LTV section before generating the Pdf.');
                isOk = false;
            }
            if (this.typeLoan == null) {
                this.showToast('error','Please select a Type Loan in LTV section before generating the Pdf.');
                isOk = false;
            }
            if (this.carPrice == null || this.carPrice == 0) {
                this.showToast('error','Please fill a car price in LTV section before generating the Pdf.');
                isOk = false;
            }
            if (this.ltvNAFValue == 0) {
                this.showToast('error','Please adjust your values, NAF must be greater than 0 in LTV section.');
                isOk = false;
            }
            if (this.fees == 0) {
                this.showToast('error','Please fill a value for Fees in LTV section before generating the Pdf.');
                isOk = false;
            }
            if (this.customOpp.Purchase_Type__c == null){
                this.showToast('error','Please select a Purchase Type in LTV section');
                isOk = false;       
            }
            if ((this.customOpp.Purchase_Type__c !=null && 'Refinance_Macq'== this.customOpp.Purchase_Type__c) && (this.contractNumber == null || this.contractNumber == null)){
                this.showToast('error','Please fill a contract number in LTV section');
                isOk = false;       
            }
            if ('used' == this.newUsed) {
                if ((this.actualKms == null) && ('ANZ' != this.lender)) {
                    this.showToast('error','Please fill Actual Km field before generating the Pdf (or type 0 in case that it isn\'t required).');
                    isOk = false;
                }
            }
        }else{
            this.showToast('error','Please fill required fields.');
            isOk = false;
        }
        return isOk;
    }

    savePdf () {
        this.saveEstimationPdf('');
    }

    savePreApproval () {
        this.saveEstimationPdf('PRE_APPROVAL_');
    }
    
    saveAmendment () {
        this.saveEstimationPdf('AMENDMENT_');
    }
    
    saveFormalApproval () {
        this.saveEstimationPdf('FORMAL_APPROVAL_');
    }

    toggleProgress(status) {
        if (status) {
            // stop
            this.visibleProgress = false;
            clearInterval(this._interval);
        } else {
            // start
            this.visibleProgress = true;
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            this._interval = setInterval(() => {
                this.progress = this.progress === 100 ? 0 : this.progress + 2;
            }, 200);
        }
        console.log('progress>>>', this.progress)
    }

    saveEstimationPdf(prefixFile){
        // PageReference pdf = null;
        const allVariables = {};
        let aad = {};
        let oppLocal = {};
        let aad1 = {};
        let dto = {};
        let pdf = 1;

        console.log('running0....', JSON.stringify(aad))

        if(this.isPdfReadyToGenerate(prefixFile)){

            this.toggleProgress(false);
            
            try{
                oppLocal = JSON.parse(JSON.stringify(this.opp));
            if(this.opp.Application_AssetDetail__c ){
                aad = JSON.parse(JSON.stringify(this.opp.Application_AssetDetail__r))  ;
                // console.log('aad1::', aad)
            }

            console.log('running0....', aad)

            dto.assetType = this.assetType;
            aad.Type__c = this.assetType;
            if('Car' == this.assetType){
                dto.variantObj = this.variantObj;
                dto.modelTypeSource = this.variantObj ? this.variantObj.Type_Source__c : null;
                dto.model = this.variantObj ? this.variantObj.Family__c : null;
                dto.make = this.makeObj ? this.makeObj.Name : null;

                console.log('running1-1-1....', dto)
                let tmpOptions = '';

                if(this.assetOptions ){

                    for(let i = 0; i < this.assetOptions.length; i++){ 
                    
                        let assetOpts = this.assetOptions;
                        let assetData = this.assetOptionsData;

                        console.log('running1-2....', assetOpts)
                        console.log('running1-2....', assetData)

                        Object.keys(assetData)
                        .forEach(function eachkey(key){
                            if(key == assetOpts[i]){
                                console.log('opts::', key)
                                if(tmpOptions != ''){
                                    tmpOptions += ', ';
                                }
                                tmpOptions += assetData[key][0].name + ' (' + assetData[key][0].value + ')';
                            }
                        })

                    }
                }
                console.log('running1-2....', dto)
                dto.options = tmpOptions;
                dto.totalPriceOptions = this.totalPriceOptions;
                dto.totalTradeLowPriceOptions = this.totalTradeLowPriceOptions;
                dto.totalTradePriceOptions = this.totalTradePriceOptions;
                dto.totalRetailPriceOptions = this.totalRetailPriceOptions;
                dto.totalTradeLowPriceKms = this.totalTradeLowPriceKms;
                dto.totalTradePriceKms = this.totalTradePriceKms;
                dto.totalRetailPriceKms = this.totalRetailPriceKms;


                aad.Make__c = this.make;
                aad.Model__c = this.model;
                aad.Variant__c = this.variant;
                aad.Variant_Desc__c = this.variantDesc;

                if (this.vehicleObj ) {
                    aad.Redbook_Key__c = this.vehicleObj.Name;
                    dto.redbookKey = aad.Redbook_Key__c;
                }
                console.log('running1-3....', aad)
                if (this.assetOptions  || this.assetOptions != []) {
                    aad.Factory_Options__c =  JSON.stringify(this.assetOptions);
                } else {
                    aad.Factory_Options__c = null;
                }
                console.log('running1-3....', aad)
                aad.Series__c = this.series;

                console.log('running1....', aad)
        
            }else{
                dto.makeOVehicle = this.makeOVehicle;
                dto.modelOVehicle = this.modelOVehicle;
                dto.variantOVehicle = this.variantOVehicle;
                dto.seriesOVehicle = this.seriesOVehicle;
                dto.year = this.year;
                aad.Make__c = this.makeOVehicle;
                aad.Model__c = this.modelOVehicle;
                aad.Variant__c = this.variantOVehicle;
                aad.Series__c = this.seriesOVehicle;
                aad.Factory_Options__c = null;
            }
            dto.newUsed = this.newUsed;
            aad.Condition__c = this.newUsed;
            aad.Year__c = parseInt(this.year);
            //LTV
            dto.lender = this.lender;
            dto.typeLoan = this.typeLoan;
            dto.carPrice = '$' + this.carPrice;
            dto.deposit = '$' + this.deposit;
            dto.warranty = '$' + this.warranty;
            dto.gap = '$' + this.gap;
            dto.lpi = '$' + this.lpi;
            dto.lti = '$' + this.lti;
            dto.carAge = this.ltvCarAge.toString();
            dto.fees = '$' + this.fees;
            dto.realFees = this.ltvFeeValue;

            console.log('running2....', dto)

            // continue after break
            dto.ltvLabel = this.ltvValueLabel;
            dto.ltvValue = '$' + this.ltvValue;
            dto.naf = '$' + this.ltvNAFValue;
            dto.lvrLabel = this.ltvLvrLabel;
            dto.lvrValue = parseFloat(this.ltvLvrValue*100 ).toFixed(2) + '%';            
            dto.actualKms = this.actualKms;
            dto.purchaseType = this.purchaseType;
            dto.contractNumber = this.contractNumber;
            dto.vendorName = this.dealerName;
            dto.vendorEmail = this.dealerEmail;
            dto.vendorAddress = this.dealerAddress;
            dto.vendorContact = this.dealerContactName;
            dto.vendorPhone = this.dealerPhoneNo;
            dto.vendorMobile = this.dealerMobile;
            dto.rego = this.rego;
            dto.vin = this.vin;
            dto.engine = this.engine;
            dto.colour = this.colour;
            dto.regoState = this.regoState;

            console.log('running2-1....', dto)

            // pdf.getParameters().put('id',Opp.Id);

            aad.Lender__c = this.lender;
            aad.Type_Loan__c = this.typeLoan;
            aad.Price__c = this.carPrice;
            aad.Deposit__c = this.deposit;
            aad.Warranty__c = this.warranty;
            aad.GAP__c = this.gap;
            aad.LPI__c = this.lpi;
            aad.LTI__c = this.lti;
            aad.Fees__c = this.fees;
            aad.Actual_KM__c = this.actualKms;
            console.log('updated Object', aad)
            aad.NAF__c = this.ltvNAFValue;
            aad.LVR__c = Math.round(this.ltvLvrValue * 100) / 100;
            aad.RRP__c = this.ltvValue;
            aad.Rego__c = this.rego;
            aad.VIN__c = this.vin;
            aad.Engine_No__c = this.engine;
            aad.Colour__c = this.colour;
            aad.Rego_State__c = this.regoState;

            oppLocal.New_Used__c = dto.newUsed.toUpperCase();
            oppLocal.Purchase_Type__c = this.purchaseType;
            oppLocal.Contract_Number__c = this.contractNumber;
            
            console.log('AAD....', aad)
            console.log('DTO....', dto)
            console.log('OPP-LOCAL....', oppLocal)
            console.log('Prefix file....', prefixFile)

            if(pdf ){
                        // console.log('insertAssetDetails>>>', aad, oppLocal, dto, prefixFile)
                        insertAssetDetails({ appAssetDetails : aad, oppt : oppLocal, dto: dto, prefixFile : prefixFile })
                        .then((result) => {
                            console.log('insertAssetDetails:::', result)
                            if(result == 'success'){
                                this.showToast('success','Assest Details PDF saved successfully.')
                            }else{
                                this.showToast('error',result)
                            }
                            this.toggleProgress(true);
                        })
                        .catch((error) => {
                            this.showToast('error', error.message)
                            console.log(error);
                            this.error = error;
                        });     
                    
                    // QuotingToolHelper.attachPdfFile(Opp.Id, prefixName, pdf, isSaveCloud);
                    
            }

           
        }catch(e){
            console.log('erererer',e)
            var errMsg = e.getMessage();
            if (errMsg.includes('UNABLE_TO_LOCK_ROW')) {
                this.showToast('warning','Some data could not be saved properly. Please reload this page and try to save your data again.');
            }
            this.showToast('error', e.stack);
            this.visibleProgress = false;
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
        }
        // }

    }
    }
}