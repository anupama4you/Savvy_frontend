@isTest(SeeAllData=true)
public class TestTaskService extends TestAPILenders{
    
    public static Custom_Opportunity__c opp;
    
    public static testMethod void testGeneral(){
        opp = loadData();
        Test_DataGeneratorHelper.createLead();
        opp.Lead__r = Test_DataGeneratorHelper.tstLead;
        update opp;
        Test.startTest();
        List<Task> taskList = new List<Task>();
        Task newTask = new Task();
        newTask.WhatId = opp.Id;
        newTask.TaskSubtype = 'Call';
        newTask.Status = 'Completed';
        taskList.add(newTask);
        
        newTask = new Task();
        newTask.WhatId = opp.Id;
        newTask.TaskSubtype = 'Task';
        newTask.Subject = 'Voice call on 3/25/2019 - 11:59:17 PM';
        newTask.Status = 'Completed';
        taskList.add(newTask);

        insert taskList;
        List<Task> tasks = new List<Task>();
        tasks.add(newTask);
        Task_Service.updateOpportunityByCallTask(tasks);
        
        TaskTriggerHandler hand = new TaskTriggerHandler();
        Map<ID, sObject> newRecordsMap = new Map<ID, sObject>();
        hand.onAfterInsert(tasks,newRecordsMap);
        Test.stopTest();
    }

}