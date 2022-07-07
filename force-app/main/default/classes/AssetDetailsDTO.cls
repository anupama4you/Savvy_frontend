public class AssetDetailsDTO {
    public Glass_Variant__c variantObj {get;set;}
    public String modelTypeSource {get;set;}
    public String model {get;set;}
    public String make {get;set;}
    public String options {get;set;}
    public String newUsed {get;set;}
    public List <Glass_Factory_Option__c> assetStandardFeautersData {get;set;}
    public List <AssetOptionDTO> assetStandardFeautersData2 {get;set;}
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
    public String realFees {get;set;}
    public String ltvLabel {get;set;}
    public String ltvValue {get;set;}
    public String naf {get;set;}
    public String lvrLabel {get;set;}
    public String lvrValue {get;set;}
    public Integer actualKms {get;set;}
    public Decimal totalTradeLowPriceKms {get;set;}
    public Decimal totalTradePriceKms {get;set;}
    public Decimal totalRetailPriceKms {get;set;}
    public String purchaseType {get;set;}
    public String contractNumber {get; set;}
    //Others vehicles
    public String assetType {get;set;}
    public String makeOVehicle {get;set;}
    public String modelOVehicle {get;set;}
    public String variantOVehicle {get;set;}
    public String seriesOVehicle {get;set;}
    public String year {get;set;}
    //Vendor Details
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

    public AssetDetailsDTO() {
        totalPriceOptions = 0;
        totalTradeLowPriceOptions = 0;
        totalTradePriceOptions = 0;
        totalRetailPriceOptions = 0;
        totalTradeLowPriceKms = 0;
        totalTradePriceKms = 0;
        totalRetailPriceKms = 0;
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
        	return (variantObj.New_Price__c + getDefaultValue(totalPriceOptions));
        }
        return 0.0;
    }
    
    public Decimal getTradeLowAdjustedValue() {
        if (variantObj != null && variantObj.Trade_Low_Price__c != null) {
        	return (variantObj.Trade_Low_Price__c + getDefaultValue(totalTradeLowPriceOptions) + getDefaultValue(totalTradeLowPriceKms));
        }
        return 0.0;
    }
    
    public Decimal getTradeAdjustedValue() {
        if (variantObj != null && variantObj.Trade_Price__c != null) {
        	return (variantObj.Trade_Price__c + getDefaultValue(totalTradePriceOptions) + getDefaultValue(totalTradePriceKms));
        }
        return 0.0;
    }
    
    public Decimal getReatilAdjustedValue() {
        if (variantObj != null && variantObj.Retail_Price__c != null) {
        	return (variantObj.Retail_Price__c + getDefaultValue(totalRetailPriceOptions) + getDefaultValue(totalRetailPriceKms));
        }
        return 0.0;
    }
    
    public Double getAverageKmValue() {
        Double r = null;
        if (variantObj != null && variantObj.Average_Kms__c != null) {
            r = variantObj.Average_Kms__c * 1000;
        }
        return r;
    }
    
    private Decimal getDefaultValue(Decimal value) {
        if (value == null) {
            return 0.0;
        }
        return value;
    }
    
    public String getCarLabel() {
        String label = 'Car';
        if (!'Car'.equalsIgnoreCase(assetType)) {
            label = 'Vehicle';
        }
        return label;
    }
}