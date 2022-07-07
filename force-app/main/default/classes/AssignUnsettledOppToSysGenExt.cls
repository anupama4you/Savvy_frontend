public class AssignUnsettledOppToSysGenExt {
    
    private Integer limitSOQL = 1000;
    public Boolean runAgain {set;get;}

    public Id userId {get;set;}



    public AssignUnsettledOppToSysGenExt(){
        this.userId = System.currentPageReference().getParameters().get( 'id' );
        runAgain = false;
        //System.debug('runAgain >> ' + runAgain);
    }
    
    public void setOpportunities(){
        try{
            List<GroupMember> memebers = [Select UserOrGroupId, GroupId From GroupMember where Group.DeveloperName = 'Sales_Consultants' and Group.Type = 'Queue'];
            GroupMember salesConsultantQueue = null;
            if (!memebers.isEmpty()) {
                salesConsultantQueue = memebers.get(0);
            }
            // GroupMember salesConsultantQueue = [Select UserOrGroupId, GroupId From GroupMember where Group.DeveloperName = 'Sales_Consultants' and Group.Type = 'Queue'];
            //System.debug('salesConsultantQueue: '+ salesConsultantQueue + ':' + salesConsultantQueue.GroupId);
            if(salesConsultantQueue != null && salesConsultantQueue.GroupId != null){
                System.debug('Checking for Settled Opportunities...');
                List<Custom_Opportunity__c> custOppList = [Select OwnerId, Lead__c, Status__c, Reason_for_Closure__c, VD_Reason_for_closure__c, VD_Status__c, Account__c 
                                                           from Custom_Opportunity__c where OwnerId = :userId 
                                                           and Status__c != 'Settled' and Status__c != 'Unresolved Opportunity' LIMIT :limitSOQL];
                
                
                for(Custom_Opportunity__c custOpp : custOppList){
                    custOpp.OwnerId = salesConsultantQueue.GroupId;
                    System.debug('custOpp.Account__c::' + custOpp.Account__c);
					
                    System.debug(custOpp.VD_Status__c + ' TEST!!2: '+ custOpp.VD_Reason_for_closure__c);
                    if(custOpp.VD_Status__c == 'Send back to Sales Consultant - cannot proceed' && custOpp.VD_Reason_for_closure__c == null){
                        custOpp.VD_Reason_for_closure__c = 'none';
                        
                    } 
                    if(custOpp.Status__c == 'Closed Opportunity' && custOpp.Reason_for_Closure__c == null){
                        custOpp.Reason_for_Closure__c = 'none';
                        System.debug('TEST!!2: '+ custOpp.Reason_for_Closure__c);
                    }               
                }

                if (limitSOQL == custOppList.size()) {
                    runAgain = true;
                }

                if(custOppList != null && !custOppList.isEmpty()){
                
                    Database.SaveResult[] srList = Database.update(custOppList, false);
    
                    Integer successes = 0;

                    for (Database.SaveResult sr : srList) {
                        
                        if (sr.isSuccess()) {
                            successes++;
                        } else {
                            for(Database.Error err : sr.getErrors()) {
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,err.getStatusCode() + ': ' + err.getMessage());
                                ApexPages.addMessage(myMsg);
                            }
                        }
                    }

                    if(successes > 0){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Number of Unsettled Opportunities transferred to Sales Consultants Group: ' + successes);
                        ApexPages.addMessage(myMsg);
                    }

                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Opportunities found.');
                    ApexPages.addMessage(myMsg);
                }
                
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Sales Consultant Queue not found.');
                ApexPages.addMessage(myMsg);
            }

            System.debug('Checking for Accounts...');
            //Transfer accounts
            List<User> userList = [SELECT Id FROM User WHERE UserRoleId IN (
                                       SELECT Id FROM UserRole WHERE Name = 'System Generated'
                                  )];
            User sysGenUser = null;
            if (!userList.isEmpty()) {
                sysGenUser = userList.get(0);
            }

            if (sysGenUser != null) {
                //Update
                List<Account> accList = [select Id, OwnerId from Account WHERE OwnerId = :userId LIMIT :limitSOQL];
                if (!accList.isEmpty()) {
                    for (Account a : accList) {
                        a.OwnerId = sysGenUser.Id;
                    }
                    Database.SaveResult[] srList = Database.update(accList, false);
    
                    Integer successes = 0;

                    for (Database.SaveResult sr : srList) {
                        
                        if (sr.isSuccess()) {
                            successes++;
                        } else {
                            for(Database.Error err : sr.getErrors()) {
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Accounts >> ' + err.getStatusCode() + ': ' + err.getMessage());
                                ApexPages.addMessage(myMsg);
                            }
                        }
                    }
                    if(successes > 0){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Number of Accounts transferred to System Generated: ' + successes);
                        ApexPages.addMessage(myMsg);
                    }
                }

                if (limitSOQL == accList.size()) {
                    runAgain = true;
                }

                System.debug('Checking for Unresolved Opportunities...');
                //Unresolved Opportunity
                List<Custom_Opportunity__c> custOppList = [Select OwnerId, Reason_for_Closure__c, VD_Reason_for_closure__c, VD_Status__c, Account__c 
                                                           from Custom_Opportunity__c where OwnerId = :userId 
                                                           and (Status__c = 'Unresolved Opportunity') LIMIT :limitSOQL];
                
                
                for(Custom_Opportunity__c custOpp : custOppList){
                    custOpp.OwnerId = sysGenUser.Id;
                    System.debug('custOpp.Account__c::' + custOpp.Account__c);
                    
                    System.debug(custOpp.VD_Status__c + ' TEST!!2: '+ custOpp.VD_Reason_for_closure__c);
                    if(custOpp.VD_Status__c == 'Send back to Sales Consultant - cannot proceed' && custOpp.VD_Reason_for_closure__c == null){
                        custOpp.VD_Reason_for_closure__c = 'none';
                        
                    } 
                    if(custOpp.Status__c == 'Closed Opportunity' && custOpp.Reason_for_Closure__c == null){
                        custOpp.Reason_for_Closure__c = 'none';
                        System.debug('TEST!!2: '+ custOpp.Reason_for_Closure__c);
                    }               
                }

                if (limitSOQL == custOppList.size()) {
                    runAgain = true;
                }

                if(custOppList != null && !custOppList.isEmpty()){
                    
                
                    Database.SaveResult[] srList = Database.update(custOppList, false);
    
                    Integer successes = 0;

                    for (Database.SaveResult sr : srList) {
                        
                        if (sr.isSuccess()) {
                            successes++;
                        } else {
                            for(Database.Error err : sr.getErrors()) {
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,err.getStatusCode() + ': ' + err.getMessage());
                                ApexPages.addMessage(myMsg);
                            }
                        }
                    }
                    if(successes > 0){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Number of Unresolved Opportunities transferred to System Generated user: ' + successes);
                        ApexPages.addMessage(myMsg);
                    }
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Unresolved Opportunities found.');
                    ApexPages.addMessage(myMsg);
                }


            }  else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'System Generated user not found.');
                ApexPages.addMessage(myMsg);    
            }



        } catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Exception error:' + ex.getMessage());
            ApexPages.addMessage(myMsg);
        }
        
    }
}