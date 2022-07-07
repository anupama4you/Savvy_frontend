@isTest
public without sharing class VehiclesComponentCtrlTest {
    @isTest 
    private static void fetchInitialDataTest(){
        Test_DataGeneratorHelper.createOpportunity();
        VehiclesComponentCtrl.fetchInitialData(Test_DataGeneratorHelper.tstOpportunity.Id);
    }
    @isTest 
    private static void handleSubmissionTest(){
        Test_DataGeneratorHelper.createOpportunity();
        VehiclesComponentCtrl.handleSubmission(Test_DataGeneratorHelper.tstOpportunity);
        ApprovalTools.recallProcess(Test_DataGeneratorHelper.tstOpportunity.VD_Worksheet__c,'bla bla bla...');
        Test_DataGeneratorHelper.reloadOpportunity();
        VehiclesComponentCtrl.handleSubmission(Test_DataGeneratorHelper.tstOpportunity);
    }
    
}