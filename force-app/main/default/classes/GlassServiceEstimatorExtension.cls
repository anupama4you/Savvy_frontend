public class GlassServiceEstimatorExtension {
    public Map<ApexPages.severity, List<String>> userMgs {set; get;}
    public Custom_Opportunity__c Opp;
    public String newUsed {get;set;}
    public String year {get;set;}	
    public List <SelectOption> yearSelect {get;set;}
    public String make {get;set;}
    public Glass_Make__c makeObj {get;set;}
    public List <SelectOption> makeSelect {get;set;}
    public String model {get;set;}
    public Glass_Model__c modelObj {get;set;}
    public List <SelectOption> modelSelect {get;set;}
    public String  family {get;set;}
    public String familyCode {get;set;}
    public List <SelectOption> familySelect {get;set;}
    public Redbook_Family__c familyObj {get;set;}
    public String badgeRedbook {get;set;}
    public List <SelectOption> badgeSelectRedbook {get;set;}
    public Redbook_Vehicle__c vehicleObj {get;set;}
    public String variant {get;set;}
    public List <SelectOption> variantSelect {get;set;}
    public String variantRedbook {get;set;}
    public List <SelectOption> variantSelectRedbook {get;set;}
    public String[] assetOptions {get;set;}
    public List <SelectOption> assetOptionsSelect {get;set;}
    public MAP<String, AssetOptionDTO> assetOptionsData = null;
    //public MAP<String, Glass_Factory_Option__c> assetOptionsData = null;
    public Glass_Variant__c variantObj {get;set;}
    public Decimal variantNewPrice {get;set;}
    public Decimal totalPriceOptions {get;set;}
    public Decimal totalTradeLowPriceOptions {get;set;}
    public Decimal totalTradePriceOptions {get;set;}
    public Decimal totalRetailPriceOptions {get;set;}
    public Decimal totalEstimated {get;set;}
    public List <AssetOptionDTO> assetStandardFeautersData {get;set;}
    //public List <Glass_Factory_Option__c> assetStandardFeautersData {get;set;}
    
    public Integer actualKms {get;set;}
    public Decimal totalTradeLowPriceKms {get;set;}
    public Decimal totalTradePriceKms {get;set;}
    public Decimal totalRetailPriceKms {get;set;}
    public Decimal fees {get;set;}
        
    //LTV Calculator
    public String lender {get;set;}
    public List <SelectOption> lenderOptions {get;set;}
    private List<String> lenderValues = new List<String> {
      'Affordable', 'AFS', 'ANZ', 'APF', 'BOQ', 'Finance 1', 'Finance Now', 
      'Firstmac', 'Green Light', 'Latitude', 'Liberty', 'Macquarie', 
      'Metro', 'Money 3', 'Pepper', 'Plenti', 'UME Loans', 'Wisr', 'Yamaha'
    };
    public String typeLoan {get;set;}
    public List <SelectOption> typeLoanOptions {get;set;}
    private List<String> typeLoanValues = new List<String> {
      'Consumer', 'Commercial', 'Chattel Mortgage', 'Leasing'
    };
    public Decimal carPrice {get;set;}
    public Decimal deposit {get;set;}   
    public Decimal warranty {get;set;}   
    public Decimal gap {get;set;}   
    public Decimal lpi {get;set;}   
    public Decimal lti {get;set;}   
    //public String purchaseType {get;set;}
    //Others vehicles
    public String assetType {get;set;}
    public String makeOVehicle {get;set;}
    public String modelOVehicle {get;set;}
    public String variantOVehicle {get;set;}
    public String seriesOVehicle {get;set;}
    public String makeRedbook {get;set;}
    
    //Lelo 2016-12-30
    private Map<String, List<AssetOptionDTO>> variantOptionsMap = new Map<String, List<AssetOptionDTO>>();
    
    //Lelo 2017-02-20
    public String rego {get;set;}
    public String vin {get;set;}
    public String engine {get;set;}
    public String colour {get;set;}
    public String regoState {get;set;}
    //-
    
    public Boolean isRefinanceMacq {set; get;}
    public List <SelectOption> statesOfIssue2Sel {get; set;}
    public Decimal quotingFees {set;get;}
    //Jesus Mora 2019-11-07 start
    public String series {get;set;}
    public List <SelectOption> seriesSelect {get;set;}
    public Integer isDetail {set; get;}
    public Glass_Make__c glassMake {set; get;}
    public Glass_Variant__c glassVariant {set; get;}
    public String carID {set; get;}
    public String variantDesc {get;set;}
    //Jesus Mora 2019-11-07 end
    //Yohan VillaLeal               2019-01-06
    
    public GlassServiceEstimatorExtension(ApexPages.StandardController controller) {
        try {
            controller.addFields(new List<String>{'Application__c'});
        } catch (SObjectException e) {}
        this.Opp = (Custom_Opportunity__c)controller.getRecord ();
        this.assetOptions = new String[]{};
        assetType = 'Car';
        newUsed = 'new';
        
        //Load select options
        lenderOptions = new List<SelectOption>();
        lenderOptions.add(new SelectOption ('', '--None--'));
        for(String value : lenderValues) {
            lenderOptions.add(new SelectOption (value, value));
        }
        
        loadNewUsedYearOptions();
        
        typeLoanOptions = new List<SelectOption>();
        typeLoanOptions.add(new SelectOption ('', '--None--'));
        for (String value : typeLoanValues) {
            typeLoanOptions.add(new SelectOption (value, value));
        }
        
        carPrice = 0;
        deposit = 0;
        warranty = 0;
        gap = 0;
        lpi = 0;
        lti = 0;
        fees = 0;
        quotingFees = 0;
        
        isRefinanceMacq = false;
        statesOfIssue2Sel = UtilitiesList.getStatesOptions();
        //Jesus Mora 2019-11-07 start
        isDetail = 1;
        //Jesus Mora 2019-11-07 end
        loadSavedData();
        
        //NWC Calculator - HJ - 12-07-2018 - I
    	//Connection direct to PPSR Service
        //resetUserMessages();
        //NWC Calculator - HJ - 12-07-2018 - F
    }

    public void loadNewUsedYearOptions() {
        System.debug('loadNewUsedYearOptions... ' + newUsed + ' >> ' + assetType);
        clearNewUsedYear();
        clearMake();
        if (!String.isBlank(newUsed)) {
            yearSelect = GlassServicesHelper.getYears(newUsed, assetType);
        }
        if(isDetail == 0 || isDetail == 2 || isDetail == 3)
            listCars();
    }
    
    public void loadLenderMakeOptions() {
        clearLenderMake();
        clearMake();
        if (!String.isBlank(year)) {
            makeSelect = GlassServicesHelper.getMakeSelectOptions(newUsed, year);
        }
        //Jesus Mora 2019-11-07 start
        if(isDetail == 0 || isDetail == 2 || isDetail == 3)
            listCars();
        //Jesus Mora 2019-11-07 end
    }
    
    public void loadMakeModelOrFamilyOptions() {
        clearMakeModelOrFamily();
        //Jesus Mora 2019-11-07 start
        clearMake();
        //Jesus Mora 2019-11-07 end
        if (!String.isBlank(make)) {
            if(GlassServicesHelper.validateRedBookLenders(lender)){
                makeRedbook  = GlassServicesHelper.searchMakeRedbookCode(make, newUsed, year);
                if(makeRedbook!=''){
                    familySelect = GlassServicesHelper.getMakeModelsSelectOptionsRedbook(makeRedbook, year);
                }else{
                    //Jesus Mora 2019-11-07 start
                    familySelect = new List<SelectOption>();
                    //Jesus Mora 2019-11-07 end 
                    familySelect.add(new SelectOption ('', '--No Models Found--'));
                }
            }
            //Jesus Mora 2019-11-07 start
            //modelSelect = GlassServicesHelper.getMakeModelsSelectOptions(make, newUsed, year);
            modelSelect = GlassServicesHelper.getMakeModelsSelectOptionsAux(make, newUsed, year);
            //Jesus Mora 2019-11-07 end
            makeObj = GlassServicesHelper.getMakeByCode(make);
        }
        //Jesus Mora 2019-11-07 start
        if(isDetail == 0 || isDetail == 2 || isDetail == 3)
            listCars();
        //Jesus Mora 2019-11-07 end
    }
    
    public void make() {
        if (!String.isBlank(make)) {
            if(GlassServicesHelper.validateRedBookLenders(lender)){
                makeRedbook  = GlassServicesHelper.searchMakeRedbookCode(make, newUsed, year);
                if(makeRedbook!=''){
                    familySelect = GlassServicesHelper.getMakeModelsSelectOptionsRedbook(makeRedbook, year);
                }else{
                    //Jesus Mora 2019-11-07 start
                    familySelect = new List<SelectOption>();
                    //Jesus Mora 2019-11-07 end 
                    familySelect.add(new SelectOption ('', '--No Models Found--'));
                }
            }
        }
    }
    
    public void loadModelVariantOptions() {
        clearModelVariant();
        if (!String.isBlank(model)) {
            //Jesus Mora 2019-11-07 start
            //variantSelect = GlassServicesHelper.getModelVariantsSelectOptions(model, year);
            variantSelect = GlassServicesHelper.getModelVariantsSelectOptionsAux(model, year, make);
            //modelObj = GlassServicesHelper.getModelByCode(model);
            //Jesus Mora 2019-11-07 end
        }
        //Jesus Mora 2019-11-07 start
        if(isDetail == 0 || isDetail == 2 || isDetail == 3)
            listCars();
        //Jesus Mora 2019-11-07 end
    }
    //Jesus Mora 2019-11-07 start
    public void loadVariantSeriesOptions() {
        clearVariantSeries();
        if (!String.isBlank(variantDesc)) {
            seriesSelect = GlassServicesHelper.getVariantSeriesSelectOptionsAux(variantDesc, model, year, make);
        }
        if(isDetail == 0 || isDetail == 2 || isDetail == 3)
            listCars();
        if(seriesSelect != null && seriesSelect.size()==1)
            isDetail=0;
    }
    //Jesus Mora 2019-11-07 end
    public void loadVariantFactoryOptions() {
        //Jesus Mora 2019-11-07 start
        glassVariant = getGlassVariantCar();
        //Jesus Mora 2019-11-07 end
        clearVariantFactoryOptions();
        //Jesus Mora 2019-11-07 start
        //if (!String.isBlank(variant)) {
        if (glassVariant != null) {
        //Jesus Mora 2019-11-07 end
            //Jesus Mora 2019-11-07 start
            //variantOptionsMap = GlassServicesHelper.getVariantOptionsByCode(variant);    
            variantOptionsMap = GlassServicesHelper.getVariantOptionsByCode(glassVariant.Code__c);
            //Jesus Mora 2019-11-07 end
            loadVariantOptionsSettings();
            //Jesus Mora 2019-11-07 start
            //variantObj = GlassServicesHelper.getVariantByCode(variant);
            variantObj = GlassServicesHelper.getVariantByCode(glassVariant.Code__c);
            //Jesus Mora 2019-11-07 end
            if (variantObj != null) {
                variantNewPrice = variantObj.New_Price__c;
            }
            //Jesus Mora 2019-11-07 start
            String model = GlassServicesHelper.getCodeModel(setParameters());
            // modelObj = GlassServicesHelper.getModelByCode(model);
            //Jesus Mora 2019-11-07 end
            calculateEstimation();
        }
    }
    
    public void loadFamilyBadgeOptions() {
        clearFamilyBadge();
        if (!String.isBlank(family)) {
            system.debug('loadFamilyBadgeOptions: Family ' + family);
            if(GlassServicesHelper.validateRedBookLenders(lender)){
                badgeSelectRedbook = GlassServicesHelper.getFamilyBadgeSelectOptionsRedbook(family, makeRedbook, year);
                //familyObj = GlassServicesHelper.getFamilyByCode(family);
                system.debug('Obtuvo el badgeSelect');
            }
        }
    }
    
    public void loadBadgeVariantOptions(){
        clearBadgeVariant();
        if (!String.isBlank(badgeRedbook)) {
            variantSelectRedbook = GlassServicesHelper.getBadgeVariantsSelectOptions(makeRedbook, family, badgeRedbook);
            //vehicleObj = GlassServicesHelper.getVehicleByCode(badgeRedbook);
        }
    }
    
    public void loadRedbookVehicle(String RedbookKey){
        vehicleObj = GlassServicesHelper.getVehicleByRedbookKey(RedbookKey);
    }
    
    public void getVehicleKey(){
        if (!String.isBlank(variantRedbook)) {
            vehicleObj = GlassServicesHelper.getVehicleByCode(variantRedbook);
        }
    }
    
    public void calculateFactoryOptions() {
        calculateEstimation();
    }
    
    private void clearNewUsedYear() {
        year = null;
        yearSelect = null;
        clearLenderMake();
    }
    
    private void clearLenderMake() {
        make = null;
        makeSelect = null;
        badgeRedbook = null;
        badgeSelectRedbook = null;
        clearMakeModelOrFamily();
    }
    
    private void clearMakeModelOrFamily() {
        clearMakeFamily();
        clearModelVariant();
        clearFamilyBadge();
        //Jesus Mora 2019-11-07 start
        clearVariantSeries();
        //Jesus Mora 2019-11-07 end
    }
    
    private void clearModelVariant() {
        variantObj = null;
        //Jesus Mora 2019-11-07 start
        //variant = null;
        variantDesc = null;
        //Jesus Mora 2019-11-07 end
        variantSelect = null;
        //Jesus Mora 2019-11-07 start
        //clearVariantFactoryOptions();
        clearVariantSeries();
        //Jesus Mora 2019-11-07 end
    }
    //Jesus Mora 2019-11-07 start
    private void clearVariant() {
        variantObj = null;
    }
    
    private void clearMake() {
        makeObj = null;
    }
    
    private void clearModel() {
        modelObj = null;
    }
    //Jesus Mora 2019-11-07 end
    //Jesus Mora 2019-11-07 start
    private void clearVariantSeries() {
        series = null;
        seriesSelect = null;
        clearVariantFactoryOptions();
    }
    //Jesus Mora 2019-11-07 end
    private void clearVariantFactoryOptions() {
        variantNewPrice = 0.0;
        actualKms = 0;
        assetOptionsData = null;
        if (assetOptions != null) {
            assetOptions.clear();
        }
        assetOptionsSelect = null;
        assetStandardFeautersData = null;
        variantOptionsMap = new Map<String, List<AssetOptionDTO>>();
        calculateEstimation();
    }
    
    private void clearMakeFamily() {
        model = null;
        modelSelect = null;
        family = null;
        familySelect = null;
        clearFamilyBadge();
    }
    
    private void clearFamilyBadge() {
        badgeRedbook = null;
        badgeSelectRedbook = null;
        clearBadgeVariant();
    }
    
    private void clearBadgeVariant(){
        variantRedbook = null;
        variantSelectRedbook = null;
        //vehicleObj = null;
    }
    
    private void calculateEstimation() {
        totalPriceOptions = 0.0;
        totalEstimated = 0.0;
        
        totalTradeLowPriceOptions = 0.0;
        totalTradePriceOptions = 0.0;
        totalRetailPriceOptions = 0.0;
        
        if (assetOptionsData != null && assetOptions != null) {
            for (String optCode : assetOptions) {
                AssetOptionDTO fo = assetOptionsData.get(optCode);
                Decimal value = fo.value;
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
              Decimal value = GlassServicesHelper.calculateUsedOptions(assetOptions, year);
                
              totalRetailPriceOptions += value;
              totalTradePriceOptions += (value * .5);
              totalTradeLowPriceOptions += (value * .3);
            }    
        }
        calculateKmsAdjustment();
        totalEstimated = variantNewPrice + totalPriceOptions;
    }
    
    public void calculateKmsAdjustment() {
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
    
    public Decimal getTradeLowAdjustedValue() {
        if (variantObj != null) {
            return (variantObj.Trade_Low_Price__c + totalTradeLowPriceOptions + totalTradeLowPriceKms);
        }
        return 0.0;
    }
    
    public Decimal getTradeAdjustedValue() {
        if (variantObj != null) {
            return (variantObj.Trade_Price__c + totalTradePriceOptions + totalTradePriceKms);
        }
        return 0.0;
    }
    
    public Decimal getReatilAdjustedValue() {
        if (variantObj != null) {
            return (variantObj.Retail_Price__c + totalRetailPriceOptions + totalRetailPriceKms);
        }
        return 0.0;
    }
    
    public Decimal getTradeLowGlassValue() {
        if (variantObj != null) {
            return (variantObj.Trade_Low_Price__c);
        }
        return 0.0;
    }
    
    public Decimal getTradeGlassValue() {
        if (variantObj != null) {
            return (variantObj.Trade_Price__c);
        }
        return 0.0;
    }
    
    public Decimal getRetailGlassValue() {
        if (variantObj != null) {
            return (variantObj.Retail_Price__c);
        }
        return 0.0;
    }
    
    private boolean isPdfReadyToGenerate(String prefixFile) {
        Boolean isOk = true;
        if (!String.isBlank(prefixFile)) {
            if (Opp.Application__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please create an Application form before saving for any appoval process.'));
                isOk = false;
            }
            if(prefixFile.contains('FORMAL_APPROVAL')) {
                String t = ' in Vendor Details section before saving for Formal Approval.';
                if (String.isBlank(Opp.Dealer_Name__c)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a Vendor Name' + t));
                    isOk = false;       
                }
                if (String.isBlank(Opp.Dealer_Email__c)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill an Email' + t));
                    isOk = false;       
                }
                if (String.isBlank(Opp.Dealer_Address__c)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill an Address' + t));
                    isOk = false;       
                }
                if (String.isBlank(Opp.Dealer_Contact_Name__c)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a Contact Name' + t));
                    isOk = false;       
                }
                if (String.isBlank(Opp.Dealer_Phone_Number__c)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a Phone Number' + t));
                    isOk = false;       
                }
                
                if (String.isBlank(Opp.Dealer_Suburb__c)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a Suburb' + t));
                    isOk = false;       
                }
                if (String.isBlank(Opp.Dealer_Postcode__c)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a Postcode' + t));
                    isOk = false;       
                }
                if (String.isBlank(Opp.Dealer_State__c)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a State' + t));
                    isOk = false;       
                }
                if (String.isBlank(Opp.Dealer_Type__c)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a Dealer Type' + t));
                    isOk = false;       
                }
            }
        }
        if ('Car'.equalsIgnoreCase(assetType )) {
            // if (makeObj == null || modelObj == null || variantObj == null) {
            if (variantObj == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a variant of the car model before generating the Pdf.'));
                isOk = false;
            }
            if(GlassServicesHelper.validateRedBookLenders(lender)){
                if(family == null || variantRedbook == null || badgeRedbook == null){
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please identify the car in Redbook Details.'));
                    //isOk = false;
                }
            }
        } else {
            if (String.isBlank(year)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a year before generating the Pdf.'));
                isOk = false;
            }
            if (String.isBlank(makeOVehicle) || String.isBlank(modelOVehicle) || String.isBlank(variantOVehicle) || String.isBlank(seriesOVehicle)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all detail fields before generating the Pdf.'));
                isOk = false;
            }
        }
        if (lender == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Lender in LTV section before generating the Pdf.'));
            isOk = false;
        }
        if (typeLoan == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Type Loan in LTV section before generating the Pdf.'));
            isOk = false;
        }
        if (carPrice == null || carPrice == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a car price in LTV section before generating the Pdf.'));
            isOk = false;
        }
        if (getLtvNAFValue() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please adjust your values, NAF must be greater than 0 in LTV section.'));
            isOk = false;
        }
        if (fees == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a value for Fees in LTV section before generating the Pdf.'));
            isOk = false;
        }
        if (Opp.Purchase_Type__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Purchase Type in LTV section'));
            isOk = false;       
        }
        if (Opp.Purchase_Type__c!=null && 'Refinance_Macq'.equalsIgnoreCase(opp.Purchase_Type__c) && (Opp.Contract_Number__c == null || String.isBlank(Opp.Contract_Number__c))){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a contract number in LTV section'));
            isOk = false;       
        }
        if ('used'.equalsIgnoreCase(newUsed)) {
            if ((actualKms == null) && !'ANZ'.equals(lender)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill Actual Km field before generating the Pdf (or type 0 in case that it isn\'t required).'));
                isOk = false;
            }
        }
        return isOk;
    }
    
    private void loadSavedData() {
        System.debug('loadSavedData... ' + Opp.Application_AssetDetail__c);
        //dealerType = Opp.Dealer_Type__c;
        System.debug(Opp.Application_AssetDetail__c);
        if (Opp.Application_AssetDetail__c != null) {
            Application_Asset_Detail__c aad = Opp.Application_AssetDetail__r;
            assetType = aad.Type__c;    
            lender = aad.Lender__c;
            System.debug(assetType);
            if ('Car'.equalsIgnoreCase(assetType)) {
                newUsed = aad.Condition__c;
                loadNewUsedYearOptions();
                year = String.valueOf(aad.Year__c);
                loadLenderMakeOptions();
                make = aad.Make__c;
                loadMakeModelOrFamilyOptions();
                model = aad.Model__c;
                loadModelVariantOptions();
                variant = aad.Variant__c;
                //Jesus Mora 2019-11-07 start
                variantDesc = aad.Variant_Desc__c;
                loadVariantSeriesOptions();
                series = aad.Series__c;
                //Jesus Mora 2019-11-07 end
                loadVariantFactoryOptions();
                //Jesus Mora 2019-11-07 start
                if (glassVariant != null){
                    model = glassVariant.Family__c;
                    loadModelVariantOptions();
                    variantDesc = glassVariant.Description__c;
                    loadVariantSeriesOptions();
                    series = glassVariant.Series__c;
                    loadVariantFactoryOptions();
                    isDetail = 3;
                }
                //Jesus Mora 2019-11-07 end
                if(aad.Redbook_key__c!=null){
                    loadRedbookVehicle(aad.Redbook_Key__c);
                    if (vehicleObj != null)  {
                        family = vehicleObj.Family_Code__c;
                        loadFamilyBadgeOptions();
                        badgeRedbook = vehicleObj.Badge_Description__c;
                    }
                    loadBadgeVariantOptions();
                    variantRedbook = aad.Redbook_Key__c;
                }
                
                system.debug('loadSavedData: variantRedbook variable chaged. Family ' + variantRedbook);
                if (aad.Factory_Options__c != null) {
                    assetOptions = (List<String>)JSON.deserialize(aad.Factory_Options__c, List<String>.class);
                }
                System.debug(assetOptions);
                //Jesus Mora 2019-11-07 start
                calculateFactoryOptions();
                //Jesus Mora 2019-11-07 end
            } else {
                newUsed = aad.Condition__c;
                loadNewUsedYearOptions();
                year = String.valueOf(aad.Year__c);
                makeOVehicle = aad.Make__c;
                modelOVehicle = aad.Model__c;
                variantOVehicle = aad.Variant__c;
                seriesOVehicle = aad.Series__c;
            }
            
            typeLoan = aad.Type_Loan__c;
            carPrice = aad.Price__c;
            deposit = aad.Deposit__c;
            warranty = aad.Warranty__c;
            gap = aad.GAP__c;
            lpi = aad.LPI__c;
            lti = aad.LTI__c;
            fees = aad.Fees__c;
            if (aad.Actual_KM__c != null) {
                actualKms = Integer.valueOf(aad.Actual_KM__c);
            }
            rego = aad.Rego__c;
            vin = aad.VIN__c;
            engine = aad.Engine_No__c;
            colour = aad.Colour__c;
            regoState = aad.Rego_State__c;
            //aad.NAF__c = getLtvNAFValue();
            //aad.LVR__c = getLtvLvrValue().round(System.RoundingMode.CEILING);
            //aad.RRP__c = getLtvValue();
            //Jesus Mora 2019-11-07 start
            String model = GlassServicesHelper.getCodeModel(setParameters());
            // modelObj = GlassServicesHelper.getModelByCode(model);
            //Jesus Mora 2019-11-07 end
        }
    
             //else {
        //Load from Quoting tool
        Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, this.Opp.Application__c);
        if (d != null) {
            if (d.Name.containsIgnoreCase('ANZ')) {
                lender = 'ANZ';
            } else if (d.Name.containsIgnoreCase('Macquarie')) {
                lender = 'Macquarie';
            } else if (d.Name.containsIgnoreCase('Pepper')) {
                lender = 'Pepper';
            } else if (d.Name.containsIgnoreCase('Liberty')) {
                lender = 'Liberty';
            } else if (d.Name.containsIgnoreCase('Finance')) {
                lender = 'Finance 1';
            } else if (d.Name.containsIgnoreCase('Money')) {
                lender = 'Money 3';
            } else if (d.Name.containsIgnoreCase('Yamaha')) {
                lender = 'Yamaha';
            } else if (d.Name.containsIgnoreCase('Metro')) {
                lender = 'Metro';
            } else if (d.Name.containsIgnoreCase('Latitude')) {
                lender = 'Latitude';
            } else if (d.Name.containsIgnoreCase('AFS')) {
                lender = 'AFS';
            } else if (d.Name.containsIgnoreCase('Green')) {
                lender = 'Green Light';
            } else if (d.Name.containsIgnoreCase('Plenti') || d.Name.containsIgnoreCase('RateSetter')) {
              lender = 'Plenti';
            } else if (d.Name.containsIgnoreCase('Wisr')) {
                lender = 'Wisr';
            } else {
                lender = d.Name;
            }
            //Type loan
            if ('Consumer Loan'.equals(d.Loan_Product__c)) {
                typeLoan = 'Consumer';
            } else if (String.isNotBlank(d.Loan_Product__c)) {
                if (d.Loan_Product__c.containsIgnoreCase('Lease')) {
                    typeLoan = 'Leasing';
                } else if (d.Loan_Product__c.containsIgnoreCase('Chattel')) {
                    typeLoan = 'Chattel Mortgage';
                }
            }
            
            carPrice = d.Vehicle_Price__c;
            deposit = 0;
            warranty = 0;
            gap = 0;
            lpi = 0;
            lti = 0;
            if (d.Net_Deposit__c != null) {
                deposit += d.Net_Deposit__c;
            }
            if ('A'.equals(d.Insurance_Warranty_Acceptance__c)) {
                warranty = d.Insurance_Warranty_Retail_Price__c;
            } else if ('A'.equals(d.Insurance_NWC_Acceptance__c)) {
                warranty = d.Insurance_NWC_Retail_Price__c;
            }
            if ('A'.equals(d.Insurance_GAP_Acceptance__c)) {
                gap = d.Insurance_GAP_Retail_Price__c;
            } else if ('A'.equals(d.Insurance_VEI_Acceptance__c)) {
                gap = d.Insurance_VEI_Retail_Price__c;
            }
            if ('A'.equals(d.Insurance_LTI_Acceptance__c)) {
                lti = d.Insurance_LTI_Retail_Price__c;
            }
            if ('A'.equals(d.Insurance_LPI_Acceptance__c)) {
                lpi = d.Insurance_LPI_Retail_Price__c;
            } else if ('A'.equals(d.Insurance_AIC_Acceptance__c)) {
                lpi = d.Insurance_AIC_Retail_Price__c;
            }

            quotingFees = 0;
            if (d.Application_Fee__c != null) {
                quotingFees += d.Application_Fee__c;
            }
            
            if ('Liberty'.equals(lender)) {
                if (d.Registration_Fee__c != null) {
                    quotingFees += d.Registration_Fee__c;
                }
            } else {
                if (d.DOF__c != null) {
                    quotingFees += d.DOF__c;
                }
            }
            
            if ('Money 3'.equals(lender)) {
                if ('Asset Finance'.equals(d.Customer_Profile__c)) {
                    if (d.Risk_Fee__c != null) {
                        quotingFees += d.Risk_Fee__c;
                    }
                }
            }
            
            if ('Finance 1'.equals(lender)) {
                if (d.Risk_Fee__c != null) {
                    quotingFees += d.Risk_Fee__c;
                }
            }
            
            if (d.PPSR__c != null) {
                quotingFees += d.PPSR__c;
            }
            if ('Latitude'.equals(d.Name) ||
                d.Name.startsWith('AFS')) {
                if (d.Registration_Fee__c != null) {
                    quotingFees += d.Registration_Fee__c;
                }
            }
        }
        
        selectedPurchaseType();
        calculateKmsAdjustment();
    }

    public void savePdf () {
        saveEstimationPdf('');
    }
    
    public void savePreApproval () {
        saveEstimationPdf('PRE_APPROVAL_');
    }
    
    public void saveAmendment () {
        saveEstimationPdf('AMENDMENT_');
    }
    
    public void saveFormalApproval () {
        saveEstimationPdf('FORMAL_APPROVAL_');
    }
    
    public void saveEstimationPdf (String prefixFile) {
        PageReference pdf = null;
        AssetDetailsDTO dto = new AssetDetailsDTO();
        Application_Asset_Detail__c aad = null;
        if (isPdfReadyToGenerate(prefixFile)) {
            if (Opp.Application_AssetDetail__c != null) {
                aad = Opp.Application_AssetDetail__r;
            }
            if (aad == null) {
                aad = new Application_Asset_Detail__c();
            }
            pdf = Page.GlassServicePdf;
            dto.assetType = assetType;
            aad.Type__c = assetType;
            if ('Car'.equalsIgnoreCase(assetType)) {
                dto.variantObj = variantObj;
                // dto.modelTypeSource = modelObj.Type_Source__c;
                // dto.model = modelObj.Name;
                dto.modelTypeSource = variantObj.Type_Source__c;
                dto.model = variantObj.Family__c;
                dto.make = makeObj.Name;
                
                String tmpOptions = '';
                if (assetOptionsData != null && assetOptions != null) {
                    for (String optCode : assetOptions) {
                        AssetOptionDTO fo = assetOptionsData.get(optCode);
                        if (String.isNotBlank(tmpOptions)) {
                             tmpOptions += ', ';
                        }
                        tmpOptions += fo.name + ' (' + fo.value.format() + ')';
                    }
                }
                dto.options = tmpOptions;
                dto.totalPriceOptions = totalPriceOptions;
                dto.totalTradeLowPriceOptions = totalTradeLowPriceOptions;
                dto.totalTradePriceOptions = totalTradePriceOptions;
                dto.totalRetailPriceOptions = totalRetailPriceOptions;
                dto.totalTradeLowPriceKms = totalTradeLowPriceKms;
                dto.totalTradePriceKms = totalTradePriceKms;
                dto.totalRetailPriceKms = totalRetailPriceKms;

                aad.Make__c = make;
                aad.Model__c = model;
                aad.Variant__c = variant;
                //Jesus Mora 2019-11-07 start
                aad.Variant_Desc__c = variantDesc;
                //Jesus Mora 2019-11-07 end
                if (vehicleObj != null) {
                    aad.Redbook_Key__c = vehicleObj.Name;
                    dto.redbookKey = aad.Redbook_Key__c;
                }
                if (assetOptions != null && !assetOptions.isEmpty()) {
                    aad.Factory_Options__c = JSON.serialize(assetOptions);
                } else {
                    aad.Factory_Options__c = null;
                }
                //Jesus Mora 2019-11-07 start
                //aad.Series__c = null;
                aad.Series__c = series;
                //Jesus Mora 2019-11-07 end
            } else {
                //Lelo                  2016-08-30
                dto.makeOVehicle = makeOVehicle;
                dto.modelOVehicle = modelOVehicle;
                dto.variantOVehicle = variantOVehicle;
                dto.seriesOVehicle = seriesOVehicle;
                dto.year = year;
                //-
                aad.Make__c = makeOVehicle;
                aad.Model__c = modelOVehicle;
                aad.Variant__c = variantOVehicle;
                aad.Series__c = seriesOVehicle;
                aad.Factory_Options__c = null;
            }
            dto.newUsed = newUsed;
            aad.Condition__c = newUsed;
            aad.Year__c = Decimal.valueOf(year);
            //LTV
            dto.lender = lender;
            dto.typeLoan = typeLoan;
            dto.carPrice = '$' + formatDecimalValues(carPrice,0);
            dto.deposit = '$' + formatDecimalValues(deposit,0);
            dto.warranty = '$' + formatDecimalValues(warranty,0);
            dto.gap = '$' + formatDecimalValues(gap,0);
            dto.lpi = '$' + formatDecimalValues(lpi,0);
            dto.lti = '$' + formatDecimalValues(lti,0);
            dto.carAge = String.valueOf(getLtvCarAge());
            dto.fees = '$' + fees.format();
            dto.realFees = getLtvFeeValue().format();
            dto.ltvLabel = getLtvValueLabel();
            dto.ltvValue = '$' + getLtvValue().format();
            dto.naf = '$' + getLtvNAFValue().format();
            dto.lvrLabel = getLtvLvrLabel();
            dto.lvrValue = String.valueOf(getLtvLvrValue().round(System.RoundingMode.CEILING)) + '%';            
            dto.actualKms = actualKms;
            dto.purchaseType = Opp.Purchase_Type__c;
            dto.contractNumber = Opp.Contract_Number__c;
            dto.vendorName = Opp.Dealer_Name__c;
            dto.vendorEmail = Opp.Dealer_Email__c;
            dto.vendorAddress = Opp.Dealer_Address__c;
            dto.vendorContact = Opp.Dealer_Contact_Name__c;
            dto.vendorPhone = Opp.Dealer_Phone_Number__c;
            dto.vendorMobile = Opp.Dealer_Mobile__c;
            dto.rego = rego;
            dto.vin = vin;
            dto.engine = engine;
            dto.colour = colour;
            dto.regoState = regoState;

            pdf.getParameters().put('id',Opp.Id);
            
            aad.Lender__c = lender;
            aad.Type_Loan__c = typeLoan;
            aad.Price__c = carPrice;
            aad.Deposit__c = deposit;
            aad.Warranty__c = warranty;
            aad.GAP__c = gap;
            aad.LPI__c = lpi;
            aad.LTI__c = lti;
            aad.Fees__c = fees;
            aad.Actual_KM__c = actualKms;
            aad.NAF__c = getLtvNAFValue();
            aad.LVR__c = getLtvLvrValue().round(System.RoundingMode.CEILING);
            aad.RRP__c = getLtvValue();
            aad.Rego__c = rego;
            aad.VIN__c = vin;
            aad.Engine_No__c = engine;
            aad.Colour__c = colour;
            aad.Rego_State__c = regoState;

            //pdf.getParameters().put('OBJ_DATA', JSON.serialize(dto));
            pdf.getParameters().put('ASSET_TYPE', dto.assetType);
            if ('Car'.equalsIgnoreCase(assetType)) {
                pdf.getParameters().put('VARIANT_CODE', dto.variantObj.Code__c);
                pdf.getParameters().put('TYPE_SOURCE', dto.modelTypeSource);
                pdf.getParameters().put('MAKE', dto.make);
                pdf.getParameters().put('OPTIONS_CHECKED', dto.options);
                pdf.getParameters().put('TOTAL_PRIECE_OPTIONS', String.valueOf(dto.totalPriceOptions));
                pdf.getParameters().put('TOTAL_TRADE_LOW_OPTIONS', String.valueOf(dto.totalTradeLowPriceOptions));
                pdf.getParameters().put('TOTAL_TRADE_OPTIONS', String.valueOf(dto.totalTradePriceOptions));
                pdf.getParameters().put('TOTAL_RETAIL_OPTIONS', String.valueOf(dto.totalRetailPriceOptions));
                pdf.getParameters().put('TOTAL_TRADE_LOW_KMS', String.valueOf(dto.totalTradeLowPriceKms));
                pdf.getParameters().put('TOTAL_TRADE_KMS', String.valueOf(dto.totalTradePriceKms));
                pdf.getParameters().put('TOTAL_RETAIL_KMS', String.valueOf(dto.totalRetailPriceKms));
                pdf.getParameters().put('LVR_VALUE', dto.lvrValue);
                pdf.getParameters().put('LTV_VALUE', dto.ltvValue);
                
            } else {
                pdf.getParameters().put('MAKE_OVHEICLE', dto.makeOVehicle);
                pdf.getParameters().put('MODEL_OVEHICLE', dto.modelOVehicle);
                pdf.getParameters().put('VARIANT_OVEHICLE', dto.variantOVehicle);
                pdf.getParameters().put('SERIES_OVEHICLE', dto.seriesOVehicle);
                pdf.getParameters().put('YEAR', dto.year);
                pdf.getParameters().put('LVR_VALUE', 'N/A');
                pdf.getParameters().put('LTV_VALUE', 'N/A');
            }
            pdf.getParameters().put('NEWUSED', dto.newUsed);
            pdf.getParameters().put('LENDER', dto.lender);
            pdf.getParameters().put('TYPE_LOAN', dto.typeLoan);
            pdf.getParameters().put('CAR_PRICE', dto.carPrice);
            pdf.getParameters().put('DEPOSIT', dto.deposit);
            pdf.getParameters().put('WARRANTY', dto.warranty);
            pdf.getParameters().put('GAP', dto.gap);
            pdf.getParameters().put('LPI', dto.lpi);
            pdf.getParameters().put('LTI', dto.lti);
            pdf.getParameters().put('CAR_AGE', dto.carAge);
            pdf.getParameters().put('FEES', dto.fees);
            pdf.getParameters().put('LTV_LABEL', dto.ltvLabel);
            pdf.getParameters().put('NAF', dto.naf);
            pdf.getParameters().put('LVR_LABEL', dto.lvrLabel);
            pdf.getParameters().put('ACTUAL_KM', dto.actualKms.format());
            pdf.getParameters().put('PURCHASE_TYPE', dto.purchaseType);
            pdf.getParameters().put('CONTRACT_NUMBER', dto.contractNumber);
            pdf.getParameters().put('VENDOR_NAME', dto.vendorName);
            pdf.getParameters().put('VENDOR_CONTACT', dto.vendorContact);
            pdf.getParameters().put('VENDOR_EMAIL', dto.vendorEmail);
            pdf.getParameters().put('VENDOR_ADDRESS', dto.vendorAddress);
            pdf.getParameters().put('VENDOR_PHONE', dto.vendorPhone);
            pdf.getParameters().put('VENDOR_MOBILE', dto.vendorMobile);
            pdf.getParameters().put('REGO', dto.rego);
            pdf.getParameters().put('VIN', dto.vin);
            pdf.getParameters().put('ENGINE', dto.engine);
            pdf.getParameters().put('COLOUR', dto.colour);
            pdf.getParameters().put('REGO_STATE', dto.regoState);
            pdf.getParameters().put('REDBOOK_KEY', aad.Redbook_Key__c);
        }
        if (pdf != null) {
          try {
            if (aad.Id == null) {
                insert aad;
                this.Opp.Application_AssetDetail__c = aad.Id;
            } else {
                update aad;
            }
            if (aad.LVR__c != null) {
              try {
                QuotingToolHelper.updateLTV(this.Opp.Id, String.valueOf(aad.LVR__c));
              } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'LTV value could not be updated in Quoting tools.'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
              }
            }
            Opp.New_Used__c = dto.newUsed.capitalize();
            update Opp;
            String prefixName = 'AssetDetails_' + prefixFile;
            String typeData = null;
            Boolean isSaveCloud = false;
            if (prefixFile.equals('PRE_APPROVAL_')) {
                typeData = 'Asset Detail - LTV (Pre-approval)';
            } else if (prefixFile.equals('FORMAL_APPROVAL_')) {
                typeData = 'Asset Detail - LTV (Formal Approval)';
                isSaveCloud = true;
                if(!Test.isRunningTest()) {
                    if(this.Opp.Id != null){
                        System.enqueueJob(new queueActiveDealerTagCallout(Opp)); 
                    }
                }
            } else if (prefixFile.equals('AMENDMENT_')) {
                typeData = 'Asset Detail - LTV (Amendment)';
                isSaveCloud = true;
            }
            if (typeData != null) {
                ApplicationExtraDataHelper.upsertData(Opp.Application__c, 'Asset Detail ' + lender, typeData, dto);
            }
            QuotingToolHelper.attachPdfFile(Opp.Id, prefixName, pdf, isSaveCloud);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Assest Details PDF saved successfully.'));
          } catch (Exception e) {
            String errMsg = e.getMessage();
            if (errMsg.contains('UNABLE_TO_LOCK_ROW')) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Some data could not be saved properly. Please reload this page and try to save your data again.'));
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
          }
        }
    }
    
    //LTV
    public Decimal getLtvFeeValue() {
        //decimal r = 0.0;
        //if (lender != null) {
        //    if ('Liberty'.equalsIgnoreCase(lender)) {
        //        r = 1405.2;
        //    } else if ('Finance 1'.equalsIgnoreCase(lender)) {
        //        r = 1585.0;
        //    } else if ('Macquarie'.equalsIgnoreCase(lender)) {
        //        r = 1251.8;
        //    } else if ('Pepper'.equalsIgnoreCase(lender)) {
        //        r = 1179.2;
        //    } else if ('St George'.equalsIgnoreCase(lender)) {
        //        r = 1058.07;
        //    } else if ('ANZ'.equalsIgnoreCase(lender)) {
        //        if ('Consumer'.equalsIgnoreCase(typeLoan)) {
        //            r = 1126.8;
        //        } else if ('Commercial'.equalsIgnoreCase(typeLoan)) {
        //            r = 1151.8;
        //        } else if ('Chattel Mortgage'.equalsIgnoreCase(typeLoan)) {
        //            r = 1151.8;
        //        }
        //    } else if ('Money 3'.equalsIgnoreCase(lender)) {
        //        r = 2271.8;
        //    } else if ('Yamaha'.equalsIgnoreCase(lender)) {
        //        r = 1001.8;
        //    } else if ('Metro'.equalsIgnoreCase(lender)) {
        //        r = 756.2;
        //    } else if ('Latitude'.equalsIgnoreCase(lender)) {
        //        r = 1179.2;
        //    } else if ('AFS'.equalsIgnoreCase(lender)) {
        //        r = 1405.76;
        //    } else if ('Green Light'.equalsIgnoreCase(lender)) {
        //        r = 1490.0;
        //    } 

        //    //'Yamaha', 'Metro', 'Latitude', 'AFS', 'Green Light'
        //}
        return quotingFees;
    }   
    
    public String getLtvValueLabel() {
        String label = 'RRP';
        if ('used'.equalsIgnoreCase(newUsed)) {
            if ('ANZ'.equalsIgnoreCase(lender)) {
                label = 'Trade Value';
            } else if ('Liberty'.equalsIgnoreCase(lender)) { 
                if (getLtvCarAge() >= 10) {
                    label = 'Trade Value';
                } else {
                    label = 'Retail Value';
                }
            }
        }
        return label;
    }
    
    public String getLtvLvrLabel() {
        String label = 'LVR';
        if ('St George'.equalsIgnoreCase(lender) || 'Macquarie'.equalsIgnoreCase(lender) || 'Pepper'.equalsIgnoreCase(lender)) {
            label = 'Estimated LVR';
        }
        return label;
    }
    
    public Integer getLtvCarAge() {
        Integer r = 0;
        //if ('used'.equalsIgnoreCase(newUsed) && year != null) {
        if (year != null) {
            Integer y = Date.today().year();
            r = y - Integer.valueOf(year);
            if (r < 0) {
                r = 0;
            }
        }
        return r;
    }
    
    public Decimal getLtvValue() {
        Decimal r = totalEstimated;
        if ('used'.equalsIgnoreCase(newUsed)) {
            if ('ANZ'.equalsIgnoreCase(lender)) {
                r =  getTradeAdjustedValue();
            } else if ('Liberty'.equalsIgnoreCase(lender)) { 
                if (getLtvCarAge() >= 10) {
                    r =  getTradeAdjustedValue();
                } else {
                    r = getReatilAdjustedValue();
                }
            } else {
                r = getReatilAdjustedValue();
            }
        } else if (
          'demo'.equalsIgnoreCase(newUsed) &&
          'Macquarie'.equalsIgnoreCase(lender)
        ) {
          r = getReatilAdjustedValue();
        }
        return r;
    }
    
    public Decimal getLtvNAFValue() {
        Decimal r = 0.0;
        getLtvFeeValue();
        r += fees;
        if (warranty != null) {
            r += warranty;
        }
        if (gap != null) {
            r += gap;
        }
        if (!'ANZ'.equalsIgnoreCase(lender) && !'Liberty'.equalsIgnoreCase(lender)) {
            if (lpi != null) {
                r += lpi;
            }
            if (lti != null) {
                r += lti;
            }
        }
        if (carPrice != null) {
            r += carPrice;
        }
        if (deposit != null) {
            r -= deposit;
        }
        return r;
    }
    
    public Decimal getLtvLvrValue() {
        Decimal value = getLtvValue();
        Decimal naf = getLtvNAFValue();
        if (value != 0) {
            Decimal r = (naf/value) * 100;
            //System.debug('getLtvLvrValue >> ' + r);
            return r.setScale(0, System.RoundingMode.DOWN);
        } else {
            return 0.0;
        }
    }
    
    public Double getAverageKM() {
        if (variantObj != null && variantObj.Average_Kms__c != null) {
            return variantObj.Average_Kms__c * 1000;
        }
        return 0;
    }
    
    public void putFeesValue() {
        make();
        fees = getLtvFeeValue();
    }
    
    private String formatDecimalValues(Decimal value, Integer scale) {
        if (value != null){
            return String.valueOf(value.setScale(scale, RoundingMode.HALF_UP).format());
        } 
        return null;
    }
    
    public String getCarLabel() {
        String label = 'Car';
        if (!'Car'.equalsIgnoreCase(assetType)) {
            label = 'Vehicle';
        }
        return label;
    }
        
    //Lelo              2016-12-30
    private void loadVariantOptionsSettings() {
        assetOptionsData = new Map<String, AssetOptionDTO>();
        assetOptionsSelect = new List<SelectOption>();
        List<AssetOptionDTO> d = variantOptionsMap.get('Optional');
        if (d != null) {
            for (AssetOptionDTO a : d) {
                assetOptionsSelect.add(new SelectOption(a.code, (a.name + ' ($' + a.value.format() + ')')));
                assetOptionsData.put(a.code, a);
            }
        }
        assetStandardFeautersData = variantOptionsMap.get('Standard');       
    }
    //-   
    public PageReference goPrivateSaleTaxInvoice() {
        //Application Form
        if (this.Opp.Application__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Application Form must be created.'));
            return null;
        }
        if (this.Opp.Loan_Product__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'A Loan Product must be asociated.'));
            return null;
        }
        if (this.Opp.Application_AssetDetail__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Asset Details - LTV must be saved.'));
            return null;
        }
        PageReference r = Page.PrivateSalesTaxInvoiceDetails;
        r.getParameters().put('id', this.Opp.Id);
        return r;
    }

    public Boolean getIsUserSettlementTeam() {
        return ApprovalTools.isUserIdSettlementTeam(UserInfo.getUserId());
    }
    
    public void selectedPurchaseType(){
        isRefinanceMacq = false;
        if ('Refinance_Macq'.equalsIgnoreCase(opp.Purchase_Type__c)){
            isRefinanceMacq = true;
        }else{
            Opp.Contract_Number__c = '';
        }
    }
    
    public List<SelectOption> getStreetTypeOptions() {
        List<SelectOption> stOptions = UtilitiesList.getStreetTypeOptions();
        return stOptions;
        
    }
    
    public Boolean getDisplayRedbookForm() {
        Boolean r = false;
        if (GlassServicesHelper.validateRedBookLenders(this.lender)) {
            r = true;
        }
        return r;
    }
    
    //NWC Calculator - HJ - 12-07-2018 - I
    //Connection direct to PPSR Service
    /*
    public void requestPPSRCertificate(){
        //resetUserMessages();
        PPSRService p = new PPSRService();
        try{
            System.debug('Transaction_1 ------I');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'SerialNumber->' + vin));
            PPSRService.Parameter param = new PPSRService.Parameter();
            param.req_typeSearchSerialNumber = PPSRSearchBySerialNumber.TYPE_VIN;
            param.req_serialNumber = vin;
            String certf = p.requestPPSR(param, opp);
            System.debug('Transaction_1 ------F');
            //putUserMessage(ApexPages.Severity.CONFIRM, 'SerialNumber->' + vin);
        }catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'[' + e.getMessage() +  '] ->' + e.getStackTraceString()));
            //putUserMessage(ApexPages.Severity.ERROR, e.getMessage());
        }
    }
    
    public void retrivePPSRCertificate(){
        //if (!userMgs.containsKey(ApexPages.Severity.ERROR)) {
            try{
                PPSRService p = new PPSRService();
                PPSRService.Parameter param = new PPSRService.Parameter();
                
                //PPSR_Service_Transaction__c ar = [Select Search_Certificate_Number__c FROM PPSR_Service_Transaction__c where Custom_Opportunity__r.id = :opp.id  order by CreatedDate desc limit 1];
                //String certf = ar.Search_Certificate_Number__c;
                //System.debug('Transaction_2 ------ ' + certf);
 
                p.retrieveCertificate(param, opp);
            }catch (Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'[' + e.getMessage() +  '] ->' + e.getStackTraceString()));
            }
        //}
        //showUserMessages();
    }
    
    private void resetUserMessages() {
        userMgs = new Map<ApexPages.severity, List<String>>();
    }
    
    private void putUserMessage(ApexPages.severity msgType, String message) {
        List<String> lst = userMgs.get(msgType);
        if (lst == null) {
            lst = new List<String>();
            userMgs.put(msgType, lst);
        }
        lst.add(message);
    }
    
    private void showUserMessages() {
        System.debug('Showing messages...');
        if (userMgs != null) {
            System.debug('Total messages >> ' + userMgs.size());
            for (ApexPages.severity k : userMgs.keySet()) {
                for (String m : userMgs.get(k)) {
                    System.debug(k  + '|' + m);
                    ApexPages.addMessage(new ApexPages.Message(k, m));
                }
            }
        }
    }
    */
    
    public void requestPPSRCertificate(){
        try{
        	PPSRServiceRestManager.requestPPSR (opp, vin, PPSRServiceRestManager.TYPE_VIN);
        }catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'[' + e.getMessage() +  '] ->' + e.getStackTraceString()));
            //putUserMessage(ApexPages.Severity.ERROR, e.getMessage());
        }
    }
        
    //NWC Calculator - HJ - 12-07-2018 - F
    //Jesus Mora 2019-11-07 start
    public GlassServicesHelper.Parameter setParameters(){
        GlassServicesHelper.Parameter p = new GlassServicesHelper.Parameter();
        p.year = year;
        p.make = make;
        p.family = model;
        p.variant = variantDesc;
        p.serie = series;
        p.IdCar = variant;
        return p;
    }
    
    public Integer getCarsSize(){
        return GlassServicesHelper.getGlassCarsSize(setParameters());
    }
    
    public List<Glass_Variant__c> getCarsList(){
        glassMake = GlassServicesHelper.getMakeByCode(String.valueOf(make));
        return GlassServicesHelper.getGlassCarsList(setParameters());
    }
    
    public Glass_Variant__c getGlassVariantCar(){
        glassVariant = GlassServicesHelper.getGlassCarAux(setParameters());
        if(glassVariant != null){
            variantNewPrice = glassVariant.New_Price__c;
            return glassVariant;    
        }
        return null;
    }
    
    public void listCars(){
        if(series != null){
            isDetail = 0;
        }else{
            isDetail = 1;
            clearModel();
            clearVariant();
            clearVariantFactoryOptions();    
        }
    }
    //Jesus Mora 2019-11-07 end

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }
}