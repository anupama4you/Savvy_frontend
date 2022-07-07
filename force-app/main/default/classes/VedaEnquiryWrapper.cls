public without sharing class VedaEnquiryWrapper {

    @AuraEnabled
    public String selectedProductDataLevel { get; set; }
    @AuraEnabled
    public String selectedPermissionType { get; set; }
    @AuraEnabled
    public String clientRef { get; set; }
    @AuraEnabled
    public String titleStr { get; set; }
    @AuraEnabled
    public String fname { get; set; }
    @AuraEnabled
    public String lname { get; set; }
    @AuraEnabled
    public String oname { get; set; }
    @AuraEnabled
    public String cUnitNum { get; set; }
    @AuraEnabled
    public String cStreetNum { get; set; }
    @AuraEnabled
    public String cStreetName { get; set; }
    @AuraEnabled
    public String cStreetType { get; set; }
    @AuraEnabled
    public String cSuburb { get; set; }
    @AuraEnabled
    public String cState { get; set; }
    @AuraEnabled
    public String cPostCode { get; set; }
    @AuraEnabled
    public String cCountryCode { get; set; }
    @AuraEnabled
    public String pUnitNum { get; set; }
    @AuraEnabled
    public String pStreetNum { get; set; }
    @AuraEnabled
    public String pStreetName { get; set; }
    @AuraEnabled
    public String pStreetType { get; set; }
    @AuraEnabled
    public String pSuburb { get; set; }
    @AuraEnabled
    public String pState { get; set; }
    @AuraEnabled
    public String pPostCode { get; set; }
    @AuraEnabled
    public String pCountryCode { get; set; }
    @AuraEnabled
    public String uAddress { get; set; }
    @AuraEnabled
    public String genderCode { get; set; }
    @AuraEnabled
    public Date dateOfBirth { get; set; }
    @AuraEnabled
    public String cEmployer { get; set; }
    @AuraEnabled
    public String atCode { get; set; }
    @AuraEnabled
    public Decimal enquiryAmt { get; set; }
    @AuraEnabled
    public String currencyCode { get; set; }
    @AuraEnabled
    public Boolean isCR { get; set; }
    @AuraEnabled
    public String relationshipCode { get; set; }
    @AuraEnabled
    public String enquiryCR { get; set; }
    @AuraEnabled
    public String dLicense { get; set; }
    @AuraEnabled
    public Id parentId { get; set; }
    @AuraEnabled
    public Integer currentTally { get; set; }
    @AuraEnabled
    public Integer vedaLimit { get; set; }
    @AuraEnabled
    public String enquiryID { get; set; }
    @AuraEnabled
    public Custom_Opportunity__c oppty { get; set; }
    @AuraEnabled  
    public String sfReq1 {set;get;}
    @AuraEnabled
    public String eqRes1 {set;get;}
    @AuraEnabled
    public String sfReq2 {set;get;}
    @AuraEnabled
    public String eqRes2 {set;get;}
    @AuraEnabled
    public Boolean displayServiceInfo {set;get;}
    @AuraEnabled 
    public List<String> warningList {get;set;}
    @AuraEnabled 
    public List<String> errorList {get;set;}
    @AuraEnabled 
    public List<String> infoList {get;set;}
    

    @AuraEnabled 
    public Boolean isProcessOK {get;set;}
    public VedaEnquiryWrapper(){
      this.isProcessOK = false;
      // Default values
      this.selectedPermissionType = 'XY';
      this.selectedProductDataLevel = 'C';
      this.atCode = 'AL';
      this.currencyCode = 'AUD';
      this.relationshipCode = '1';
      this.isCR = false;
    }


}