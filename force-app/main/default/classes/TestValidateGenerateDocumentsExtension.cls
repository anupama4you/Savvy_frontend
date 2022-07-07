@isTest
public class TestValidateGenerateDocumentsExtension
{
    public static testMethod void myUnitTest()
    {
        
        Test.StartTest();   
        Test_DataGeneratorHelper.createProduct();
           
        Test_DataGeneratorHelper.tstOpportunity.Occupation__c = 'test';
        Test_DataGeneratorHelper.tstOpportunity.Occupation_Status__c = 'test';
        Test_DataGeneratorHelper.tstOpportunity.Occupation_Time_Years__c = '1';
        Test_DataGeneratorHelper.tstOpportunity.Occupation_Time_Months__c = '1';
        Test_DataGeneratorHelper.tstOpportunity.Number_of_Dependents__c = '1';
        Test_DataGeneratorHelper.tstOpportunity.Goods_Description__c = 'test';
        Test_DataGeneratorHelper.tstOpportunity.Preferred_Lender__c = 'test';
        Test_DataGeneratorHelper.tstOpportunity.Insurance_Cover__c = 'test';        
        //Test_DataGeneratorHelper.tstOpportunity.Vehicle_securities_registration_fee__c = 1;
        //Test_DataGeneratorHelper.tstOpportunity.ASIC_Registration__c = 1;
        //Test_DataGeneratorHelper.tstOpportunity.Other_Fees_or_Charges__c = 1;
        update Test_DataGeneratorHelper.tstOpportunity;
        
        Test.StopTest(); 
        
        Test_DataGeneratorHelper.tstFinanceProduct.Loan_Purpose__c = 'Personal Use';
        update Test_DataGeneratorHelper.tstFinanceProduct;
        
        Test_DataGeneratorHelper.tstFinanceProduct.Deposit__c = 1;
        Test_DataGeneratorHelper.tstFinanceProduct.Lender_App_Fee__c = 1;
        Test_DataGeneratorHelper.tstFinanceProduct.Equalisation_Fee_PPSR__c = 1;
        update Test_DataGeneratorHelper.tstFinanceProduct;
        
        Test_DataGeneratorHelper.tstFinanceProduct.Loan_Purpose__c = 'Business Use';
        update Test_DataGeneratorHelper.tstFinanceProduct;
                                       
                    
    }
    public static testMethod void myUnitTest1()
    {
    Test.startTest();
    Test_DataGeneratorHelper.createOpportunity();
    test.stopTest();    

    ValidateGenerateDocumentsExtension ext = new ValidateGenerateDocumentsExtension(new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity));
    ext.DoValidate();
    ext.SaveContinue();  
    
    Test_DataGeneratorHelper.tstOpportunity.Current_payslip_with_vehicle_allowance__c = true;
    Test_DataGeneratorHelper.tstOpportunity.Employer_letter_confirming_business_use__c = true;
    Test_DataGeneratorHelper.tstOpportunity.Letter_from_Accountant__c = true;
    Test_DataGeneratorHelper.tstOpportunity.Low_Doc_confirmation__c = true;
    Test_DataGeneratorHelper.tstOpportunity.No_hardship_for_applicant__c = true;
    Test_DataGeneratorHelper.tstOpportunity.Recent_Business_Activity_Statement__c = true;
    Test_DataGeneratorHelper.tstOpportunity.Recent_Tax_Return_with_M_V_deductions__c = true;
    Test_DataGeneratorHelper.tstOpportunity.Signed_Deed_of_Novation__c = true;
    update Test_DataGeneratorHelper.tstOpportunity; 

    Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c='dealer';
    Test_DataGeneratorHelper.tstOpportunity.Dealer_Name__c = null;
    update Test_DataGeneratorHelper.tstOpportunity;
    ext = new ValidateGenerateDocumentsExtension(new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity));
    ext.Validate();
    ext.SaveContinue();

 
    
    }
    
    public static testMethod void myUnitTest2()
    {
        
        Test.startTest();
        Test_DataGeneratorHelper.createProduct();
        Test_DataGeneratorHelper.createLead();
        Test_DataGeneratorHelper.createAccount();
        Test.stopTest();
        
        Test_DataGeneratorHelper.tstFinanceProduct.Loan_Purpose__c ='business Use';
        update Test_DataGeneratorHelper.tstFinanceProduct;
        
        Custom_Opportunity__c tstOpportunity = new Custom_Opportunity__c(Account__c = Test_DataGeneratorHelper.tstAccount.Id,
                                             Lead__c = Test_DataGeneratorHelper.tstLead.Id,
                                             Status__c = 'Quote Sent',
                                             Loan_Product__c=Test_DataGeneratorHelper.tstFinanceProduct.id);
        insert tstOpportunity; 
        ValidateGenerateDocumentsExtension ext = new ValidateGenerateDocumentsExtension(new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity));
        Test_DataGeneratorHelper.tstOpportunity.Low_Doc_confirmation__c = false;
        update Test_DataGeneratorHelper.tstOpportunity;
        
        ext.Validate();
    
    }
}