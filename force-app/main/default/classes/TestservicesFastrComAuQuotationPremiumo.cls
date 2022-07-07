/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-07 
* @description    Test class for testing servicesFastrComAuQuotationPremiumo web service apex class
*/

@isTest(SeeAllData=true)
public class TestservicesFastrComAuQuotationPremiumo {

     public static testMethod void servicesFastrComAuQuotationPremiumoMthd(){
         
         //Quotation item override
         servicesFastrComAuQuotationPremiumo.QuotationItemOverride servFComAQuotItOverTestRec = new servicesFastrComAuQuotationPremiumo.QuotationItemOverride();
         
         servFComAQuotItOverTestRec.CoverTypeCode = 'test';
         servFComAQuotItOverTestRec.PremiumOverride = 1.0;
         
         //Premium override request
         servicesFastrComAuQuotationPremiumo.PremiumOverrideRequest servFComAPremOverReqTestRec = new servicesFastrComAuQuotationPremiumo.PremiumOverrideRequest();
   
         servicesFastrComAuQuotationPremiumo.ArrayOfQuotationItemOverride servFComAPremOverReqArryQItOverTestRec = new servicesFastrComAuQuotationPremiumo.ArrayOfQuotationItemOverride();
         
         servFComAPremOverReqTestRec.Items = servFComAPremOverReqArryQItOverTestRec;
         servFComAPremOverReqTestRec.QuotationNumber = '123';
    
         //Array of Premium override details
         servicesFastrComAuQuotationPremiumo.ArrayOfPremiumOverrideDetails servFComAArryPremODetTestRec = new servicesFastrComAuQuotationPremiumo.ArrayOfPremiumOverrideDetails();
   
         servicesFastrComAuQuotationPremiumo.PremiumOverrideDetails[] servFComAArryPremODetPremODetListTestRec = new servicesFastrComAuQuotationPremiumo.PremiumOverrideDetails[]{};
   
         servFComAArryPremODetTestRec.PremiumOverrideDetails = servFComAArryPremODetPremODetListTestRec;
   
         //Premium override details 
         servicesFastrComAuQuotationPremiumo.PremiumOverrideDetails servFComAPremOverDetailsTestRec = new servicesFastrComAuQuotationPremiumo.PremiumOverrideDetails();
         
         servicesFastrComAuQuotationData.ArrayOfPaymentMethod servFComAPremOverDetailsArryPymntMthdTestRec = new servicesFastrComAuQuotationData.ArrayOfPaymentMethod();
         
         //servicesFastrComAuQuotationData.ArrayOfPaymentMethod AvailablePaymentMethods;
         
         servFComAPremOverDetailsTestRec.AvailablePaymentMethods = servFComAPremOverDetailsArryPymntMthdTestRec;
         
         servFComAPremOverDetailsTestRec.CostExGst = 1.0;
         servFComAPremOverDetailsTestRec.CoverTypeCode = 'test';
         servFComAPremOverDetailsTestRec.EstablishmentFee = 1.0;
         servFComAPremOverDetailsTestRec.Gst = 1.0;
         servFComAPremOverDetailsTestRec.Premium = 1.0;
         servFComAPremOverDetailsTestRec.StampDuty = 1.0;
         
         //Premium override response 
         servicesFastrComAuQuotationPremiumo.PremiumOverrideResponse servFComAPremOverRespTestRec = new servicesFastrComAuQuotationPremiumo.PremiumOverrideResponse();
         
         servicesFastrComAuQuotationPremiumo.ArrayOfPremiumOverrideDetails servFComAArryPremOverDetailsTestRec = new servicesFastrComAuQuotationPremiumo.ArrayOfPremiumOverrideDetails();
         
         servFComAPremOverRespTestRec.PremiumOverrideSuccessful = false;
         servFComAPremOverRespTestRec.QuotationNumber = '123';

     }     
     
}