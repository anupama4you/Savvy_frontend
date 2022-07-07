public class SettlementChecklistExt 
{
       
    public boolean oppNameChecked {get;set; }
    public boolean oppMobileNumberChecked {get; set;}
    public boolean oppEmailAddChecked {get; set; }
 /* public boolean oppAccUnitHouseNo {get; set; }
    public boolean oppAccStreetAdd {get; set; }  
    public boolean oppAccStreetType {get; set; }
    public boolean oppAccSuburb{get; set; }
    public boolean oppstate{get; set; } 
    public boolean oppAccPostCode {get; set; }    */
    public boolean oppOwnerName {get; set; }
    public boolean oppLoanProductDeposit {get; set; }
    public boolean oppLoanProductDof {get; set; }
    public boolean oppLoanProductLenderAppFee {get; set; }
    public boolean oppLoanProductEquFeePPSR {get; set; }
    public boolean oppLoanProductResidualAmount {get; set; }
    public boolean oppLoanProductLibertyTrail {get; set; }
    public boolean oppLoanProductClientRate {get; set; }
    public boolean oppLoanProductBrokerage {get; set; }
    public boolean oppLoanProductLoanTerm {get; set; }
    public boolean oppTotalCommission {get; set; }
    public boolean oppIsyourClientPropertyOwner {get; set; }
    public boolean oppNAFAmountFinanced {get; set; }
    public boolean oppLoanProductInsuranceType {get; set; }
    public boolean oppLoanProductInsurer {get; set; }
    public boolean oppLoanProductInsurancePolicyAmt {get; set; }
    public boolean oppLoanProductInsuranceComm {get; set; }
    public boolean oppPreferredLender {get; set; }
    public boolean oppPurchaseType {get; set; }
    public boolean oppDealerName {get; set; }
    public boolean oppDealerContactName {get; set; }
    public boolean oppDealerAddress {get; set; }
    public boolean oppDealerEmail {get; set; }
    public boolean oppDealerPhoneNumber {get; set; }
    public boolean oppDealerFaxNumber {get; set; }
    public boolean oppLoanProductLoanType {get; set; }
    public boolean oppLoanProductLoanPurpose {get; set; }
    public boolean oppNotesToSettlementOfficer {get; set;}
    public boolean oppLoanProductBalloon {get; set; }
    public boolean oppLoanProductRepay {get; set; }
    public boolean oppLoanProductPayments {get; set; }
    public boolean oppcostOfGoods {get; set; }
    public string  oppCustomerAddress {get; set; }
    
        
    private Id oppId;
    private Custom_Opportunity__c cOppObj;
    private string checkedVal;
    public account acc;
        
    public SettlementChecklistExt(ApexPages.StandardController controller) {
    
        oppId=apexpages.currentpage().getparameters().get('id');
        
        cOppObj = [select id, name, Account__r.Unit_House_Number__c, Account__r.Street_Address__c, VerifiedFields__c, Account__r.Street_Type__c, Account__r.Suburb__c, State__c, Account__r.Postcode__c from Custom_Opportunity__c where id=:oppId];
        
        checkedVal=apexpages.currentpage().getparameters().get('settledValues');
        checkedVal = String.isBlank(checkedVal)? '' : checkedVal;
        
        oppNameChecked = false;
        oppMobileNumberChecked = false;
        oppEmailAddChecked = false;
        oppOwnerName = false;
        oppLoanProductDeposit = false;
        oppLoanProductDof = false;
        oppLoanProductLenderAppFee = false;
        oppLoanProductEquFeePPSR = false;
        oppLoanProductResidualAmount = false;
        oppLoanProductLibertyTrail = false;
        oppLoanProductClientRate = false;
        oppLoanProductBrokerage = false;
        oppLoanProductLoanTerm = false;
        oppTotalCommission = false;
        oppIsyourClientPropertyOwner = false;
        oppNAFAmountFinanced = false;
        oppLoanProductInsuranceType = false;
        oppLoanProductInsurer = false;
        oppLoanProductInsurancePolicyAmt = false;
        oppLoanProductInsuranceComm = false;
        oppPreferredLender = false;
        oppPurchaseType = false;
        oppDealerName = false;
        oppDealerContactName = false; 
        oppDealerAddress = false;
        oppDealerEmail = false;
        oppDealerPhoneNumber = false;
        oppDealerFaxNumber = false;
        oppLoanProductLoanType = false;
        oppLoanProductLoanPurpose = false;
        oppNotesToSettlementOfficer = false;
        oppLoanProductBalloon = false;
        oppLoanProductRepay = false;
        oppLoanProductPayments = false;
        oppcostOfGoods = false;
            
        oppCustomerAddress = (cOppObj.Account__r.Unit_House_Number__c + ',' + cOppObj.Account__r.Street_Address__c + ',' + cOppObj.Account__r.Street_Type__c + ',' + cOppObj.Account__r.Suburb__c + ',' + cOppObj.State__c + ',' + cOppObj.Account__r.Postcode__c);
               
        if(checkedVal.contains('Name-true')){
        
            oppNameChecked=true;
        }
        if(checkedVal.contains('Mobile-true')){
        
            oppMobileNumberChecked=true;
        }
        
        if(checkedVal.contains('Email-true')){
            oppEmailAddChecked=true;
        }
    /*    
        if(checkedVal.contains('HouseNo-true')){
            oppAccUnitHouseNo=true;
        } 
        if(checkedVal.contains('Street-true')){

            oppAccStreetAdd=true;
        } 
        if(checkedVal.contains('StreetType-true')){
            
            oppAccStreetType=true;
        }
        
        if(checkedVal.contains('AccSub-true')){
            oppAccSuburb=true;
            
        }
        
        if(checkedVal.contains('State-true')){
            oppState=true;
        }
        
        if(checkedVal.contains('AccPost-true')){
            oppAccPostCode=true;
             
        }  
   */     
        if(checkedVal.contains('OwnerName-true')){
            oppOwnerName=true;
            
        }
        if(checkedVal.contains('PrdDeposite-true')){
            oppLoanProductDeposit=true;
            
        }
        if(checkedVal.contains('PrdDof-true')){
            
            oppLoanProductDof=true;
        }
        if(checkedVal.contains('LoanPrd-true')){
            oppLoanProductLenderAppFee=true;
            
        }
        if(checkedVal.contains('LoanProdEq-true')){
            
            oppLoanProductEquFeePPSR=true;
        }
        if(checkedVal.contains('LoanProdRes-true')){
            
            oppLoanProductResidualAmount=true;
        }
        if(checkedVal.contains('PrdLib-true')){
            
            oppLoanProductLibertyTrail=true;
        }
        if(checkedVal.contains('PrdClntRate-true')){
            oppLoanProductClientRate=true;
            
        }
        if(checkedVal.contains('LoanPrdBrk-true')){
            oppLoanProductBrokerage=true;
            
        }
        if(checkedVal.contains('LoanPrdLoan-true')){
            oppLoanProductLoanTerm=true;
            
        }
        if(checkedVal.contains('TotalCom-true')){
            oppTotalCommission=true;
            
        }
        if(checkedVal.contains('ClientProp-true')){
            oppIsyourClientPropertyOwner=true;
            
        }
        if(checkedVal.contains('AmountFin-true')){
            oppLoanProductInsuranceType=true;
        }
        if(checkedVal.contains('LoanProdIns-true')){
            
            oppNAFAmountFinanced=true;
        }
        if(checkedVal.contains('LoanProdInsu-true')){
            
            oppLoanProductInsurer=true;
        }
        if(checkedVal.contains('LoanProdInsPls-true')){
            oppLoanProductInsurancePolicyAmt=true;
            
        }
        if(checkedVal.contains('LoanProdInsCom-true')){
            
            oppLoanProductInsuranceComm=true;
        }
        if(checkedVal.contains('PrefLendr-true')){
            
            oppPreferredLender=true;
        }
        if(checkedVal.contains('PurchaseType-true')){
            
            oppPurchaseType=true;
        }
        if(checkedVal.contains('DealerName-true')){
            
            oppDealerName=true;
        }
        if(checkedVal.contains('DealerConName-true')){
            
            oppDealerContactName=true;
        }
        if(checkedVal.contains('DealerConAddress-true')){
            
            oppDealerAddress=true;
        }
        if(checkedVal.contains('DealerEmail-true')){
            oppDealerEmail=true;
            
        }
        if(checkedVal.contains('DealerPhone-true')){
            oppDealerPhoneNumber=true;
        }
        if(checkedVal.contains('DealerFax-true')){
        
            oppDealerFaxNumber=true;
        }
        if(checkedVal.contains('LoanProdLoan-true')){
        
            oppLoanProductLoanType=true;
        }
        
        if(checkedVal.contains('LoanProductLoanPrs-true')){
            oppLoanProductLoanPurpose=true;
        }
        
        if(checkedVal.contains('oppNotesToSettOff-true')){
            oppNotesToSettlementOfficer=true;
        }
        if(checkedVal.contains('oppLoanProductBalloon-true')) {
            oppLoanProductBalloon=true;
        }
        if(checkedVal.contains('oppLoanProductRepay-true')) {
            oppLoanProductRepay=true;
        }
        if(checkedVal.contains('oppLoanProductPayments')) {
            oppLoanProductPayments=true;
        }   
        if(checkedVal.contains('oppcostOfGoods')) {
            oppcostOfGoods=true;
        }
        
        for(Product__c prd:[Select Id, name, Opportunity_Name__c,Loan_Type__c,Insurer__c,Insurance_Policy_Amount__c,Insurance_Commission__c from Product__c where Opportunity_Name__c=:oppId AND RecordTypeID='012N00000008ZFh' order by createddate ASC Limit 1]){
        
         
        
        }
       // return new PageReference ('/' + custom_opportunity__c.Id );
    }
     
   
    public pagereference UpdateCheckList(){
    
        if(oppNameChecked){
        
            cOppObj.VerifiedFields__c = 'Name-'+oppNameChecked;
            
        }
        if(oppMobileNumberChecked){
        
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c +'Mobile-'+oppMobileNumberChecked;
            
        }
        if(oppEmailAddChecked){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c + 'Email-'+oppEmailAddChecked;
        }
 /*     if(oppAccUnitHouseNo){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'HouseNo-'+oppAccUnitHouseNo;
        }  
        if(oppAccStreetAdd){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'Street-'+oppAccStreetAdd;
        } 
        if(oppAccStreetType){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'StreetType-'+oppAccStreetType;
        }
        if(oppAccSuburb){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'AccSub-'+oppAccSuburb;
        }
        if(oppState){
        cOppObj.verifiedFields__c = cOppObj.verifiedFields__c+'State-'+oppState;
        }
        if(oppAccPostCode){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'AccPost-'+oppAccPostCode;
        }
    */   
        if(oppOwnerName){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'OwnerName-'+oppOwnerName;
        }
        if(oppLoanProductDeposit){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'PrdDeposite-'+oppLoanProductDeposit;
        }
        if(oppLoanProductDof){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'PrdDof-'+oppLoanProductDof;
        }
        if(oppLoanProductLenderAppFee){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'LoanPrd-'+oppLoanProductLenderAppFee;
        }
        if(oppLoanProductEquFeePPSR){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'LoanProdEq-'+oppLoanProductEquFeePPSR;
        }
        if(oppLoanProductResidualAmount){ 
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'LoanProdRes-'+oppLoanProductResidualAmount;
        }
        if(oppLoanProductLibertyTrail){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'PrdLib-'+oppLoanProductLibertyTrail;
        }
        if(oppLoanProductClientRate){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'PrdClntRate-'+oppLoanProductClientRate;
        }
        if(oppLoanProductBrokerage){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'LoanPrdBrk-'+oppLoanProductBrokerage;
        }
        if(oppLoanProductLoanTerm){
        cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'LoanPrdLoan-'+oppLoanProductLoanTerm;
        }
        if(oppTotalCommission){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'TotalCom-'+oppTotalCommission;
        
        }
        if(oppIsyourClientPropertyOwner){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'ClientProp-'+oppIsyourClientPropertyOwner;
        
        }
        if(oppNAFAmountFinanced){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'AmountFin-'+oppNAFAmountFinanced;
        
        }
        if(oppLoanProductInsuranceType){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'LoanProdIns-'+oppLoanProductInsuranceType;
        
        }
        if(oppLoanProductInsurer){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'LoanProdInsu-'+oppLoanProductInsurer;
        
        }
        if(oppLoanProductInsurancePolicyAmt){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'LoanProdInsPls-'+oppLoanProductInsurancePolicyAmt;
        
        }
        if(oppLoanProductInsuranceComm){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'LoanProdInsCom-'+oppLoanProductInsuranceComm;
        
        }
        if(oppPreferredLender){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'PrefLendr-'+oppPreferredLender;
        
        }
        if(oppPurchaseType){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'PurchaseType-'+oppPurchaseType;
        
        }
        if(oppDealerName){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'DealerName-'+oppDealerName;
        
        }
        if(oppDealerContactName){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'DealerConName-'+oppDealerContactName;
        
        }
        if(oppDealerAddress){
        
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'DealerConAddress-'+oppDealerAddress;
        
        }
        if(oppDealerEmail){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'DealerEmail-'+oppDealerEmail;
        
        }if(oppDealerPhoneNumber){
        
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'DealerPhone-'+oppDealerPhoneNumber;
        
        }
        if(oppDealerFaxNumber){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'DealerFax-'+oppDealerFaxNumber;
        
        }
        if(oppLoanProductLoanType){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'LoanProdLoan-'+oppLoanProductLoanType;
        
        }
        if(oppLoanProductLoanPurpose){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'LoanProductLoanPrs-'+oppLoanProductLoanPurpose;
        
        }
        if(oppNotesToSettlementOfficer){
            
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'oppNotesToSettOff-'+oppNotesToSettlementOfficer;
        
        }
        
        if(oppLoanProductBalloon){
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'oppLoanProductBalloon-'+oppLoanProductBalloon;
        }
        if(oppLoanProductRepay) {
            cOppObj.VerifiedFields__c = cOppObj.VerifiedFields__c+'oppLoanProductRepay-'+oppLoanProductRepay;
        }
        if(oppLoanProductPayments) {
           cOppObj.VerifiedFields__c = cOppObj.verifiedFields__c+'oppLoanProductPayments-'+oppLoanProductPayments; 
        }
        if(oppcostOfGoods) {
           cOppObj.VerifiedFields__c = cOppObj.verifiedFields__c+'oppcostOfGoods-'+oppcostOfGoods;
        }
        
        update cOppObj;
        
        PageReference oppPage = new PageReference('/' + cOppObj.id);
        oppPage.setRedirect(true);
        return oppPage; 
    
     }
    
}