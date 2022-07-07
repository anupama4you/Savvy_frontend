global class Veda_clicks implements Schedulable {

  public static String CRON_EXP = '0 0 3 1 * ?';

  global void execute(SchedulableContext SC) {
    List<Opportunity_veda__c> d = [SELECT Idopvd__c, clicks__c FROM Opportunity_veda__c];
    for (Opportunity_veda__c mihw : d) {
      mihw.clicks__c=0;
    }
    update d;
  }   

}