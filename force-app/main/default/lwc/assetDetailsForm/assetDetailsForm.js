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
import getApplicationQuoting from '@salesforce/apex/QuotingToolHelper.getApplicationQuoting';
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

    @api recordId;
    @track displayComp = false;
    @api showCloneBtn;
    oppUrl;
    // @track yearSelectLatest = null;

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    oppty

    @wire(getCustomOpportunities, {recordId: '$recordId'}) wiredRecord({error, data}){
        if(data){
            console.log('wiredMethod:::'+JSON.stringify(data));
            this.currentOpp = data;
            this.opp = data;
            console.log('OPPPPPPPP:::', data)
            console.log('Dealer state:::', this.opp.Dealer_State__c)
            this.loadSavedData();

            this.displayComp = true;
        }else{
            this.error = error;
        }
    }


    // useEffect
    connectedCallback() {
        console.log('recordId:::',this.recordId)

        this.rendered = false;
        // sample record ID - Bill
        // this.recordId = 'a011y000002vcGTAAY';

        this.initialization();
        this.loadNewUsedYearOptions1();  
        this.loadStreetTypeOptions();
        this.loadStatesOptions();
    
        this.test = ''
        console.log('Detail::::', this.isDetail)

        // this.getMakeSelectOptions();
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

        // dummy values
        this.actualKms = 100000

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
    assetOptionsData = new Map();
    assetOptions;
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

    test;
    
    @track rendered = false;

    // @wire(getGlassCarsSize, {param : this.carParameters}) wiredRecord({error, data}){
    //     if(data){   
    //         console.log('car size:::',JSON.stringify(data));
    //         // this.currentOpp = data;
    //         // this.state = data.Dealer_State__c;
    //         // console.log("state:::"+this.state);
    //         // console.log(this.currentOpp);
    //     }else{
    //         this.error = error;
    //         console.error(error)
    //     }
    // }


    getCarsList(){

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

                console.log('assetOptionsSelect:::', this.assetOptionsSelect)

                this.assetStandardFeautersData = result.assetStandardFeautersData.assetStandardFeautersData; 

                this.variantObj = result.variantObj;
                this.variantObject = result.variantObj;

                // this.IsDetail2 = true;
                // this.IsDetail0 = false;

                if(this.variantObj != null){
                    this.variantNewPrice = this.variantObj.New_Price__c;
                }

                // this.model = result.model;
                console.log("model:::", JSON.stringify(result.model))
                this.calculateEstimation();

                    if(load == true){
                        if(this.glassVariant != null){
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

    loadFamilyBadgeOptions() {
        this.clearFamilyBadge();
        if (this.family != null) {
            console.log('loadFamilyBadgeOptions: Family ' + this.family);
            this.getFamilyBadgeSelectOptionsRedbook();
            
        }
    }

    loadBadgeVariantOptions(){
        this.clearBadgeVariant();
        if (this.badgeRedbook != null) {
            this.getBadgeVariantsSelectOptions();
        }
    }

    loadRedbookVehicle(RedbookKey, load){
        getVehicle({redbookKey: RedbookKey})
        .then((result) => {
            this.vehicleObj = result.vehicleByRedbookKey;
            if(load){
                if(this.vehicleObj != null){
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

    getVehicleKey(){
        if(this.variantRedbook != null){
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

    calculateFactoryOptions(e) {

        if(e && e.target)
            this.assetOptions = JSON.parse(e.target.value);
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

    calculateUsedOptions() {
        const x = calculateUsedOptions({ options: this.assetOptions, year: this.year })
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
        getFamilyBadgeSelectOptionsRedbook({ family: this.family, makeRedbook: this.makeRedbook, year: this.year, lender: this.lender })
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
            console.log('trigger list')
            // this.IsDetail0 = true;
            this.isDetail = 0;
            if(event && event.target && event.target.value){
                this.variant = event.target.value;
            }
            this.getVariantFactoryOptions();
            // this.IsDetail2 = false;
            // this.IsDetail3 = false;
            console.log('car List', this.carsList)
        }else{
            if(event && event.target && event.target.value){
                this.variant = event.target.value;
            }
            this.getVariantFactoryOptions();
        }

    }

    // retrieving make models --> glass & redbook
    loadMakeModelOrFamilyOptions(event){
        if(event && event.target && event.target.name == 'make'){
            this.make = event.target.value;
        }

        this.clearMakeModelOrFamily();
        this.clearMake();
        
        if(this.make != null){

            var carParameter = {
                year : this.year,
                make : this.make,
                newUsed : this.newUsed,
                lender : this.lender,
                code : this.make,
                family: this.family,
                variant: this.variantDesc,
                series: this.series,
                IdCar: this.variant
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

    make() {
        var carParameter = {
            year : this.year,
            make : this.make,
            newUsed : this.newUsed,
            lender : this.lender,
            code : this.make,
            family: this.family,
            variant: this.variantDesc,
            series: this.series,
            IdCar: this.variant
        }
        getMakeModelsSelectOptions({wrapper : carParameter}).then((result) => {
            console.log('MAKE() - Redbook Data:'+ JSON.stringify(result.redObj));
            this.familySelect = Object.entries(result.redObj).map(([value,label]) => ({ value, label }));
        }).catch(error => {
            console.error(error);
            this.error = error;
        }); 
    }

    putFeesValue(event) {
        if(event.target.name = 'lender')
            this.lender = event.target.value;
        if(event.target.name == 'typeLoan')
            this.typeLoan = event.target.value;
        
        this.make();
        this.fees = this.ltvFeeValue();
    }

    get isSearchCertificateNumber(){
        if(this.currentOpp && this.currentOpp.Application_AssetDetail__r.Search_Certificate_Number__c == ''){
            console.log('isSearchCertificateNumber::', 'ppsr_sent');
        }else{
            console.log('isSearchCertificateNumber::', 'ppsr_ok');
        }
        return true;
    }

    get isVehicleDetails(){
        if(this.assetType == 'Car'){
            return true;
        }else{
            return false;
        }
    }


    // get displayRedbookForm(){
    //     let r = false;
    //     validateRedBookLenders({lender: this.lender})
    //         .then((result) => {
    //             console.log('displayRedbookForm:::', result)
    //             r = result;
    //             return r;
    //         });

    // }

    // get IsDetail0(){

    //     if(this.isDetail == 0){
    //         return true;
    //     }else{
    //         return false;
    //     }
    // }


    // get IsDetail2(){
    //     if(this.isDetail == 2){
    //         this.IsDetail0 = false;
    //         return true;
    //     }else{
    //         return false;
    //     }
    // }

    // get IsDetail3(){
    //     if(this.isDetail == 3){
    //         return true;
    //     }else{
    //         return false;
    //     }
    // }

    get AverageKMs(){
        return 
    }

    get CarsSizeFunc(){
        console.log('Car Object',this.CarObj);
        return 0; 
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
        if (this.variantObj != null && this.variantObj.Average_Kms__c != null) {
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

    // getGlassCarsListFunc(){
    //     getGlassCarsList({make :this.make})
    //     .then((result) => {
    //         console.log(result)
    //         this.makeObj = result;
    //         this.glassMake = result;
    //     })
    //     .catch((error) => {
    //         console.log(error);
    //         this.error = error;
    //     });
    // }

    get displayClass(){
        return 'Light Commercial Vehicles';
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
    //     if (this.variantDesc != null) {
    //         seriesSelect = GlassServicesHelper.getVariantSeriesSelectOptionsAux(variantDesc, model, year, make);
    //     }
    //     if(isDetail == 0 || isDetail == 2 || isDetail == 3)
    //         this.listCars();
    //     if(seriesSelect != null && seriesSelect.size()==1)
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

        this.isTable1 = true;
        this.getCarsList();
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

        if(load){
            this.clearModelVariant();
        }

        // this.getCarsList();

        // this.clearModelVariant();
        if (this.model != null) {
            this.getModelVariantsSelectOptionsAuxFunc();
        }
        if(this.isDetail == 0 || this.isDetail == 2 || this.isDetail == 3)
            this.listCars();
    }

    loadVariantSeriesOptions(event, load) {
        if(event && event.target && event.target.name == 'variant'){
            this.variantDesc = event.target.value;
        }

        // this.getCarsList();
        if(load != false){
            this.clearVariantSeries();
        }
        
        if (this.variantDesc != null) {
            this.getVariantSeriesSelectOptionsAuxFunc();
        }
        if(this.isDetail == 0 || this.isDetail == 2 || this.isDetail == 3)
            this.listCars();
        if(this.seriesSelect != null && Object.keys(this.seriesSelect).length == 1)
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

        if(event.target.name == 'assetType'){
            this.assetType = event.target.value;
        }

        if(event.target.name == 'newUsed'){
            this.newUsed = event.target.value;
        }

        console.log('loadNewUsedYearOptions... ' + this.newUsed + ' >> ' + this.assetType);

        this.clearNewUsedYear();
        this.clearMake();

        if (this.newUsed != null) {
            this.getYears();
        }
        if(this.isDetail == 0 || this.isDetail == 2 || this.isDetail == 3)
            this.listCars();

    }

    loadNewUsedYearOptions1() {
        console.log('loadNewUsedYearOptions... ' + this.newUsed + ' >> ' + this.assetType);

        this.clearNewUsedYear();
        this.clearMake();

        if (this.newUsed != null) {
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
        this.actualKms = 0;
        this.assetOptionsData = null;
        if (this.assetOptions != null) {
            this.assetOptions = null;
        }
        this.assetOptionsSelect = null;
        this.assetStandardFeautersData = null;
        this.variantOptionsMap = null;
        this.calculateEstimation();
    }

    calculateEstimation() {
        console.log('Calculate estimation:::');

        console.log('asset Options Data:::', this.assetOptionsData);
        console.log('asset Options :::', this.assetOptions);

        if (this.assetOptionsData != null && this.assetOptions != null) {

            let total = 0;
            for(let i = 0; i < this.assetOptions.length; i++){ 
                console.log('Opt Obj:::', Object.keys(this.assetOptionsData)) 

                let assetOpts = this.assetOptions;
                let assetData = this.assetOptionsData;

                Object.keys(this.assetOptionsData)
                .forEach(function eachkey(key){
                    if(key == assetOpts[i]){
                        total = total + parseInt(assetData[key][0].value) 
                        console.log('prices:::',  assetData[key][0].value)
                    }
                })
            }

            this.totalPriceOptions = total;
            console.log('Total Price Options::', this.totalPriceOptions)

            if ('new' == this.newUsed || 'demo' == this.newUsed) {
              if (this.variantObj.Retail_Price__c != null && this.variantObj.Retail_Price__c > 0) {
                //value = value * .8;
                //value = value.setScale(-2);
                this.totalRetailPriceOptions += this.totalPriceOptions;
                this.totalTradePriceOptions += (this.totalPriceOptions * .5);
                this.totalTradeLowPriceOptions += (this.totalPriceOptions * .3);
              }
            } else if ('used' == this.newUsed) {
                Promise.resolve(this.calculateUsedOptions()).then(value => {
                    if(value){
                        console.log('totalRetailPriceOptions1::', value)
                        this.totalRetailPriceOptions += value;
                        this.totalTradePriceOptions += (value * 0.5);
                        this.totalTradeLowPriceOptions += (value * 0.3);
                        console.log('totalRetailPriceOptions1::', this.totalRetailPriceOptions)
                    }else{
                        this.totalRetailPriceOptions += 0;
                        this.totalTradePriceOptions += 0;
                        this.totalTradeLowPriceOptions += 0;
                    }
    
                }).catch(err => {
                    this.error = err;
                    console.log(err);
                });
                
            }    
        }
        this.calculateKmsAdjustment();
        this.totalEstimated = this.variantNewPrice + this.totalPriceOptions;
    }

    calculateKmsAdjustment(event) {

        console.log('calculateKmsAdjustment:::')

        if(event && event.target && event.target.name != null ){
            if(event.target.name == 'calculateKmsAdjustment'){
                this.actualKms = event.target.value;
            }
        }
        
        if ('used' == this.newUsed.toLowerCase() && this.variantObj != null && this.actualKms > 0 && 'AFS' != this.lender) {

            Promise.resolve(this.calculateAdjustmentFunc()).then(value => {
                if(value){
                   this.totalRetailPriceKms = value;
                   console.log('totalRetailPriceKms::', this.totalRetailPriceKms)
                }
                if (this.totalRetailPriceKms != 0) {
                    this.totalTradePriceKms = this.totalRetailPriceKms * 0.5;
                    this.totalTradeLowPriceKms = this.totalRetailPriceKms * 0.3;
                }
            }).catch(err => {
            console.log(err);
            });
           
        }
    }

    get carLabelPriceSuff(){
        return this.CarLabel + 'Price'
    }

    selectedPurchaseType(event){
        this.opp.Purchase_Type__c = event.target.value;

        this.isRefinanceMacq = false;
        if ('Refinance_Macq' == this.oppty.Purchase_Type__c.toLowerCase()){
            this.isRefinanceMacq = true;
        }else{
            this.oppty.Contract_Number__c = '';
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

    clearVariantFactoryOptions() {
        this.variantNewPrice = 0.0;
        this.actualKms = 0;
        this.assetOptionsData = null;
        if (this.assetOptions != null) {
            this.assetOptions = null;
        }
        this.assetOptionsSelect = null;
        this.assetStandardFeautersData = null;
        this.variantOptionsMap = new Map();
        this.calculateEstimation();
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
        this.clearLenderMake();
        this.clearMake();

        if(event && event.target && event.target.name == 'year'){
            this.year = event.target.value;
            console.log('::year::'+this.year);
        }

        if(this.year != null){
            this.getMakeSelectOptionsFunc();
        }

        if(this.isDetail == 0 || this.isDetail == 2 || this.isDetail == 3)
            this.listCars();
    }

    clearMake() {
        this.makeObj = null;
    }

    listCars(){

        console.log('listcars', this.series)

        if(this.series != null){
            this.isDetail = 0;
        }else{
            this.isDetail = 1;
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
    }

    // getters :::::::

    get tradeLowAdjustedValue() {
        if (this.variantObj != null) { 
            return (this.variantObj.Trade_Low_Price__c + this.totalTradeLowPriceOptions + this.totalTradeLowPriceKms);
        }
        return 0.0;
    }

    get tradeAdjustedValue() {
        if (this.variantObj != null) {
            return (this.variantObj.Trade_Price__c + this.totalTradePriceOptions + this.totalTradePriceKms);
        }
        return 0.0;
    }

    get reatilAdjustedValue() {
        if (this.variantObj != null) {
            console.log('reatilAdjustedValue:::', this.variantObj.Retail_Price__c + this.totalRetailPriceOptions + this.totalRetailPriceKms)
            const val = this.variantObj.Retail_Price__c + this.totalRetailPriceOptions + this.totalRetailPriceKms;
            return val;
        }
        return 0.0;
    }

    get tradeLowGlassValue() {
        if (this.variantObj != null) {
            return (this.variantObj.Trade_Low_Price__c);
        }
        return 0.0;
    }

    get tradeGlassValue() {
        if (this.variantObj != null) {
            return (this.variantObj.Trade_Price__c);
        }
        return 0.0;
    }

    get retailGlassValue() {
        if (this.variantObj != null) {
            return (this.variantObj.Retail_Price__c);
        }
        return 0.0;
    } 

    get ltvFeeValue() {
        return this.quotingFees;
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
                console.log('ltvValue-inside', r)
            }
        } else if (
          'demo' == this.newUsed &&
          'Macquarie' == this.lender
        ) {
          r = this.reatilAdjustedValue;
        }
        console.log('ltvValue', this.reatilAdjustedValue)
        console.log('ltvValue', r)
        return r;
    }

    get ltvNAFValue() {
        let r = 0;
        // this.LtvFeeValue;
        r += this.fees;
        if (this.warranty != null) {
            r += this.warranty;
        }
        if (this.gap != null) {
            r += this.gap;
        }
        if (('ANZ' != this.lender) && ('Liberty' != this.lender)) {
            if (this.lpi != null) {
                r += this.lpi;
            }
            if (this.lti != null) {
                r += this.lti;
            }
        }
        if (this.carPrice != null) {
            r += this.carPrice;
        }
        if (this.deposit != null) {
            r -= this.deposit;
        }
        console.log('LtvNAFValue', r)
        return r;
    }

    get ltvLvrValue() {
        let value = this.ltvValue;
        let naf = this.ltvNAFValue;
        if (value != 0) {
            let r = (naf/value) * 100;
            //System.debug('getLtvLvrValue >> ' + r);
            return r;
            // return r.setScale(0, System.RoundingMode.DOWN);
        } else {
            return 0.0;
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

    loadLists(){

    }

    // load saved data
    loadSavedData(){
        console.log('Load saved Data:::::');
        console.log(this.currentOpp)

        if(this.currentOpp.Application_AssetDetail__c != null){
            var aad = {};
            aad = this.currentOpp.Application_AssetDetail__r;
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

                if(aad.Redbook_key__c != null){
                    this.loadRedbookVehicle(aad.Redbook_Key__c, true);
                    this.variantRedbook = aad.Redbook_Key__c;
                }

                if(aad.Factory_Options__c != null){
                    console.log('Factory options::::',aad.Factory_Options__c)
                    this.assetOptions = JSON.parse(aad.Factory_Options__c);
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

            if (aad.Actual_KM__c != null) {
                this.actualKms = parseInt(aad.Actual_KM__c);
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
                series : this.series,
                IdCar : this.variant
            }

            getCodeModel({ wrapper: carParameter })
            .then((result) => {
                this.model = result;
            })
            .catch((error) => {
                console.log(error);
                this.error = error;
            }); 
     
        }

        //Load from Quoting tool
        // getApplicationQuoting(this.currentOpp.Id, this.currentOpp.Application__c)
        // .then((d) => {
        //     console.log('getApplicationQuoting::', d)
        // })
        // .catch((error) => {
        //     console.log(error);
        //     this.error = error;
        // });


    }


}