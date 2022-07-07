public class GlassServicePdfExtension {
	
    public Glass_Variant__c variantObj {get;set;}
    public List <AssetOptionDTO> assetStandardFeautersData {get;set;}
	  public String modelTypeSource {get;set;}
    public String make {get;set;}
    public String options {get;set;}
    public String newUsed {get;set;}
    
    public Decimal totalPriceOptions {get;set;}
    public Decimal totalTradeLowPriceOptions {get;set;}
    public Decimal totalTradePriceOptions {get;set;}
    public Decimal totalRetailPriceOptions {get;set;}
    
    //LTV
    public String lender {get;set;}
    public String typeLoan {get;set;}
    public String carPrice {get;set;}
	  public String deposit {get;set;}   
    public String warranty {get;set;}   
    public String gap {get;set;}   
    public String lpi {get;set;}   
    public String lti {get;set;}
    //Calculated
    public String carAge {get;set;}
    public String fees {get;set;}
    public String ltvLabel {get;set;}
    public String ltvValue {get;set;}
    public String naf {get;set;}
    public String lvrLabel {get;set;}
    public String lvrValue {get;set;}
    
    public String actualKms {get;set;}
    public Decimal totalTradeLowPriceKms {get;set;}
    public Decimal totalTradePriceKms {get;set;}
    public Decimal totalRetailPriceKms {get;set;}
    
    public String purchaseType {get;set;}
    //Lelo				2016-08-30
    public String assetType {get;set;}
    public String makeOVehicle {get;set;}
    public String modelOVehicle {get;set;}
    public String variantOVehicle {get;set;}
    public String seriesOVehicle {get;set;}
    public String year {get;set;}
    //-
    public String vendorName {get;set;}
    public String vendorEmail {get;set;}
    public String vendorAddress {get;set;}
    public String vendorContact {get;set;}
    public String vendorPhone {get;set;}
    public String vendorMobile {get;set;}
    
    public String rego {get;set;}
    public String vin {get;set;}
    public String engine {get;set;}
    public String colour {get;set;}
    public String regoState {get;set;}
    public String redbookKey {get;set;}

    public Custom_Opportunity__c opp;

    public GlassServicePdfExtension (ApexPages.StandardController controller) {
        Set<String> fields = new Set<String>{
          'OwnerId'
        };
        if (!Test.isRunningTest()) controller.addFields(new List<String>(fields));
        this.opp = (Custom_Opportunity__c)controller.getRecord ();

        String variantCode = System.currentPageReference().getParameters().get('VARIANT_CODE');
        variantObj = GlassServicesHelper.getVariantByCode(variantCode);
        assetStandardFeautersData = GlassServicesHelper.getVariantOptionsByCodeAndType(variantCode, 'Standard');
        
        modelTypeSource = System.currentPageReference().getParameters().get('TYPE_SOURCE'); 
        make = System.currentPageReference().getParameters().get('MAKE'); 
        
        options = System.currentPageReference().getParameters().get('OPTIONS_CHECKED'); 
        if (String.isBlank(options)) {
            options = 'None.';
        }
        
        totalPriceOptions = 0;
        totalTradeLowPriceOptions = 0;
        totalTradePriceOptions = 0;
        totalRetailPriceOptions = 0;
        
        String tmp = System.currentPageReference().getParameters().get('TOTAL_PRIECE_OPTIONS'); 
        if (String.isNotBlank(tmp)) {
            totalPriceOptions = Decimal.valueOf(tmp);
        }
        tmp = System.currentPageReference().getParameters().get('TOTAL_TRADE_LOW_OPTIONS'); 
        if (String.isNotBlank(tmp)) {
            totalTradeLowPriceOptions = Decimal.valueOf(tmp);
        }
        tmp = System.currentPageReference().getParameters().get('TOTAL_TRADE_OPTIONS'); 
        if (String.isNotBlank(tmp)) {
            totalTradePriceOptions = Decimal.valueOf(tmp);
        }
        tmp = System.currentPageReference().getParameters().get('TOTAL_RETAIL_OPTIONS'); 
        if (String.isNotBlank(tmp)) {
            totalRetailPriceOptions = Decimal.valueOf(tmp);
        }
        newUsed = System.currentPageReference().getParameters().get('NEWUSED');
        
        //LTV
        lender = System.currentPageReference().getParameters().get('LENDER');
        typeLoan = System.currentPageReference().getParameters().get('TYPE_LOAN');
        carPrice = System.currentPageReference().getParameters().get('CAR_PRICE');
        deposit = System.currentPageReference().getParameters().get('DEPOSIT');
        warranty = System.currentPageReference().getParameters().get('WARRANTY');
        gap = System.currentPageReference().getParameters().get('GAP');
        lpi = System.currentPageReference().getParameters().get('LPI');
        lti = System.currentPageReference().getParameters().get('LTI');
        carAge = System.currentPageReference().getParameters().get('CAR_AGE');
        fees = System.currentPageReference().getParameters().get('FEES');
        ltvLabel = System.currentPageReference().getParameters().get('LTV_LABEL');
        ltvValue = System.currentPageReference().getParameters().get('LTV_VALUE');
        naf = System.currentPageReference().getParameters().get('NAF');
        lvrLabel = System.currentPageReference().getParameters().get('LVR_LABEL');
        lvrValue = System.currentPageReference().getParameters().get('LVR_VALUE');
        
        actualKms = System.currentPageReference().getParameters().get('ACTUAL_KM');
        tmp = System.currentPageReference().getParameters().get('TOTAL_TRADE_LOW_KMS'); 
        if (String.isNotBlank(tmp)) {
            totalTradeLowPriceKms = Decimal.valueOf(tmp);
        }
        tmp = System.currentPageReference().getParameters().get('TOTAL_TRADE_KMS'); 
        if (String.isNotBlank(tmp)) {
            totalTradePriceKms = Decimal.valueOf(tmp);
        }
        tmp = System.currentPageReference().getParameters().get('TOTAL_RETAIL_KMS'); 
        if (String.isNotBlank(tmp)) {
            totalRetailPricekms = Decimal.valueOf(tmp);
        }
        
        purchaseType = System.currentPageReference().getParameters().get('PURCHASE_TYPE');
        //Lelo				2016-08-30
        assetType = System.currentPageReference().getParameters().get('ASSET_TYPE');
        makeOVehicle = System.currentPageReference().getParameters().get('MAKE_OVHEICLE');
        modelOVehicle = System.currentPageReference().getParameters().get('MODEL_OVEHICLE');
        variantOVehicle = System.currentPageReference().getParameters().get('VARIANT_OVEHICLE');
        seriesOVehicle = System.currentPageReference().getParameters().get('SERIES_OVEHICLE');
        year = System.currentPageReference().getParameters().get('YEAR');
        //-
        vendorName = System.currentPageReference().getParameters().get('VENDOR_NAME');
        vendorContact = System.currentPageReference().getParameters().get('VENDOR_CONTACT');
        vendorEmail = System.currentPageReference().getParameters().get('VENDOR_EMAIL');
        vendorAddress = System.currentPageReference().getParameters().get('VENDOR_ADDRESS');
        vendorPhone = System.currentPageReference().getParameters().get('VENDOR_PHONE');
        vendorMobile = System.currentPageReference().getParameters().get('VENDOR_MOBILE');

        rego = System.currentPageReference().getParameters().get('REGO');
        vin = System.currentPageReference().getParameters().get('VIN');
        engine = System.currentPageReference().getParameters().get('ENGINE');
        colour = System.currentPageReference().getParameters().get('COLOUR');
        regoState = System.currentPageReference().getParameters().get('REGO_STATE');
        redbookKey = System.currentPageReference().getParameters().get('REDBOOK_KEY');
    }
    
    public Decimal getNewPriceValue() {
        if (variantObj != null) {
        	return (variantObj.New_Price__c);
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
    
    public Decimal getNewPriceAdjustedValue() {
        if (variantObj != null && variantObj.New_Price__c != null) {
        	return (variantObj.New_Price__c + totalPriceOptions);
        }
        return 0.0;
    }
    
    public Decimal getTradeLowAdjustedValue() {
        if (variantObj != null && variantObj.Trade_Low_Price__c != null) {
        	return (variantObj.Trade_Low_Price__c + totalTradeLowPriceOptions);
        }
        return 0.0;
    }
    
    public Decimal getTradeAdjustedValue() {
        if (variantObj != null && variantObj.Trade_Price__c != null) {
        	return (variantObj.Trade_Price__c + totalTradePriceOptions);
        }
        return 0.0;
    }
    
    public Decimal getReatilAdjustedValue() {
        if (variantObj != null && variantObj.Retail_Price__c != null) {
        	return (variantObj.Retail_Price__c + totalRetailPriceOptions);
        }
        return 0.0;
    }
    
    public Double getAverageKmValue() {
        Double r = 0;
        if (variantObj != null && variantObj.Average_Kms__c != null) {
            r = variantObj.Average_Kms__c * 1000;
        }
        return r;
    }
    
    public String getCarLabel() {
        String label = 'Car';
        if (!'Car'.equalsIgnoreCase(assetType)) {
            label = 'Vehicle';
        }
        return label;
    }

  public Account getAccountVar() {
    return SOQLSingletonQueries.getPartnerAccount(this.opp.OwnerId);
  } 
}