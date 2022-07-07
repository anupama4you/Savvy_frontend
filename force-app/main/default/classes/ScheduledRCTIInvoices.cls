global class ScheduledRCTIInvoices implements Schedulable 
{   
   global void execute(SchedulableContext ctx) 
   {
       RCTIInvoicesCreator.Create();   
   }   
}