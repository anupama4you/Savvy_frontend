@isTest
public class TestOpportunityEditExtension
{
    public static testMethod void myUnitTest()
    {
    
        
        Test.StartTest();
        Test_DataGeneratorHelper.createLead();
          
        ApexPages.CurrentPage().getParameters().put('leadId', Test_DataGeneratorHelper.tstLead.Id);             
                                                                     
        OpportunityEditExtension ext = new OpportunityEditExtension(new ApexPages.StandardController(new Custom_Opportunity__c()));        
        system.debug(ext.Convert);
        system.debug(ext.ProductTypes);
                
        ext.AddProduct();
        ext.RemoveKey = ext.Products[0].Key;
        ext.RemoveProduct();
        ext.Save();
        
        ext.AddProduct();
        ext.AddProduct();
        ext.Products[0].Product.RecordTypeId = ext.FinanceRT;
        ext.Products[1].Product.RecordTypeId = ext.InsuranceRT;
        ext.Save();
        
        ext.Products[0].Product.Loan_Type__c = 'test';
        ext.Products[0].Product.Loan_Purpose__c = 'test';
        ext.Products[0].Product.Cost_of_Goods__c = 1;
        ext.Products[0].Product.DOF__c = 1;
        ext.Products[0].Product.Brokerage__c = 1;
        ext.Products[0].Product.Lender__c = 'test';
        ext.Products[0].Product.Loan_Term__c = 1;
        
        ext.Products[1].Product.Insurance_Type__c = 'test';
        ext.Products[1].Product.Insurance_Commission__c = 1;
        ext.Products[1].Product.Insurer__c = 'test';
        //Lelo						2016-08-17
        ext.ValidateProducts();
        //-
        ext.Save();
        
        Test.StopTest();        
    }
}