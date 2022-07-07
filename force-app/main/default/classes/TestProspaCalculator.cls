/**
* 	@author Yohan VillaLeal
*	@description 
**/
@isTest(SeeAllData=true)
public class TestProspaCalculator {
	@isTest
	static void loanProductDifNull() {
        Test_DataGeneratorHelper.createProduct();
        Test_DataGeneratorHelper.reloadOpportunity();
        
        Test.startTest();
			ProspaCalculatorExtension crt = generateProspaCalculatorExtension();
        	crt.save();
        Test.stopTest();
	}
    
    @isTest
	static void loanProductNotNull() {
        Test_DataGeneratorHelper.createOpportunity();
        Test_DataGeneratorHelper.reloadOpportunity();
        
        Test.startTest();
			ProspaCalculatorExtension crt = generateProspaCalculatorExtension();
        	crt.save();
        Test.stopTest();
	}
    
    @isTest
	static void loanProductWithOppAccount() {
        Test_DataGeneratorHelper.createOpportunityAccount();
        Test_DataGeneratorHelper.reloadOpportunity();
        
        Test.startTest();
			ProspaCalculatorExtension crt = generateProspaCalculatorExtension();
        	crt.save();
        Test.stopTest();
	}
       
    @isTest
	static void loanProductWithOppLead() {
        Test_DataGeneratorHelper.createOpportunityLead();
        Test_DataGeneratorHelper.reloadOpportunity();
        
        Test.startTest();
			ProspaCalculatorExtension crt = generateProspaCalculatorExtension();
        	crt.save();
        Test.stopTest();
	}
       
    @isTest
	static void loanProductWithoutLeadAndAccount() {
        Test_DataGeneratorHelper.createOpportunityWithoutLeadAndAccount();
        Test_DataGeneratorHelper.reloadOpportunity();
        
        Test.startTest();
			ProspaCalculatorExtension crt = generateProspaCalculatorExtension();
        	crt.save();
        Test.stopTest();
	}
        
    private static ProspaCalculatorExtension generateProspaCalculatorExtension(){
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        // Finance One
        PageReference calcRef = Page.ProspaCalculator;
        calcRef.getParameters().put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        ProspaCalculatorExtension ctr = new ProspaCalculatorExtension(sc);
        return ctr;
    }
}