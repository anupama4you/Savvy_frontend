global class ScheduledRenewalLead implements Schedulable 
{   
   global void execute(SchedulableContext ctx) 
   {
       RenewalLeadCreator.Create();        
   }   
}