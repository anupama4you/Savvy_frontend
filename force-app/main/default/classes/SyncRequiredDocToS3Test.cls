/**
 * @author Andre Calimlim - Accenture
 * @description Test class for SyncRequiredDocToS3 class
 *				Test executed:testSyncRequriedDocumentsToS3BatchJob
 *				
 */
@isTest
private class SyncRequiredDocToS3Test {

    static testMethod void testSyncRequriedDocumentsToS3BatchJob() {
        Test_DataGeneratorHelper.createRequiredDocument();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseSuccess());
        
        Test.startTest();
        Id batchjob = Database.executeBatch(new SyncRequiredDocToS3(), 1);
        Test.stopTest();
    }
}