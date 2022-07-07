trigger CustomOpportunity_History on Custom_Opportunity__c (before insert,before update) {
    CustomOpp_History__c[] oppH = new CustomOpp_History__c[0];
    try{
            //for (Custom_Opportunity__c opp : Trigger.new){
            Custom_Opportunity__c opp = Trigger.new[0];
            DateTime dt = System.now();
            Long noOfDays = 0;
            Long minutes = 0;
            Long hours = 0;
            
            if (System.Trigger.oldMap != null){
                Custom_Opportunity__c beforeUpdate = System.Trigger.oldMap.get(opp.Id);
                
                if (!opp.Status__c.equalsIgnoreCase(beforeUpdate.Status__c)){
                    List<CustomOpp_History__c> finds = [select id, CreatedDate from CustomOpp_History__c copp 
                                                   where CustomOpp_Id__c = :opp.Id and NewValue__c = :beforeUpdate.Status__c 
                                                   order by CreatedDate desc limit 1];
                
                    CustomOpp_History__c find = null;
                    
                    if (finds != null && !finds.isEmpty()){
                        find = finds[0];
                        if (find != null){
                            DateTime act = System.now();
                            dt = find.CreatedDate;
                            Date before = dt.date();
                            //noOfDays = before.daysBetween(act);
                            
                            Long dt1Long = dt.getTime();
                            Long dt2Long = act.getTime();
                            Long milliseconds = dt2Long - dt1Long;
                            Long seconds = milliseconds / 1000;
                            minutes = seconds / 60;
                            hours = milliseconds / 3600000 ;
                            Long days = hours / 24;
                            noOfDays = Long.valueOf(String.valueOf(days));
                        }
                    }
                }
                oppH.add(new CustomOpp_History__c(CustomOpp_Id__c = opp.Id, OldValue__c = beforeUpdate.Status__c, NewValue__c = opp.Status__c, 
                                                  ModifiedDate__c = dt, NumberOfDays__c = noOfDays, noOfHours__c = hours, noOfMinutes__c = minutes));
            }else{
                String dcp = '';
                if(Trigger.isinsert && Trigger.isafter){
                    dcp = 'New opportunity';
                    oppH.add(new CustomOpp_History__c(CustomOpp_Id__c = opp.Id, OldValue__c = '', NewValue__c = opp.Status__c, Description__c = dcp, 
                                                      ModifiedDate__c = dt, NumberOfDays__c = noOfDays, noOfHours__c = hours, noOfMinutes__c = minutes));
                }
            }
            
        //}
    }catch (Exception ex){
        String cmmt = 'ERR.' + ex.getMessage() + ' .-. ' + ex.getLineNumber();
        if (cmmt.length() >= 255){
            cmmt = cmmt.left(254);
        }
        oppH.add(new CustomOpp_History__c(Description__c = cmmt));
    }
    
    insert oppH;
}