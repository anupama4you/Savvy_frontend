@isTest(SeeAllData=true)
public class MacquarieSettingsTest {
    
     public static testMethod void myTest(){
         Custom_Opportunity__c opp = [select id from Custom_Opportunity__c  where id = 'a019000001NvVJf'];
         if (opp != null){
             ApexPages.StandardController sc = new ApexPages.StandardController(opp);
             MacquarieSettingsExtension sett = new MacquarieSettingsExtension(sc);
             sett.loadData();
             sett.getSettings();
             sett.getUsers();
             sett.addUser();
             sett.updateRow();
         }
    }
}