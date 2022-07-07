global class ScheduledEmails implements Schedulable 
{   
   global void execute(SchedulableContext ctx) 
   {
       SendScheduledEmails.Send();   
   }   
}