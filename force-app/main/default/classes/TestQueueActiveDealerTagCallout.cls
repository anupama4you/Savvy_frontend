@isTest(SeeAllData=true)
public class TestQueueActiveDealerTagCallout {
	
    @isTest static void testSavePdf() {
    	Test_DataGeneratorHelper.createOpportunity();
        Test_DataGeneratorHelper.reloadOpportunity();
        
        System.enqueueJob(new queueActiveDealerTagCallout(Test_DataGeneratorHelper.tstOpportunity));
    }
}