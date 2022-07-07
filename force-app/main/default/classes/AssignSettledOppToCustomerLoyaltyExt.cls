public class AssignSettledOppToCustomerLoyaltyExt {
    public Id userId {get;set;}
    public Integer totalOpps {set;get;}
    public Boolean requireNewProcess {set;get;}

    public AssignSettledOppToCustomerLoyaltyExt(){
        this.userId       = System.currentPageReference().getParameters().get( 'id' );
        this.totalOpps = 0;
    }
    
    public void setOpportunities(){
        try{
            this.requireNewProcess = true;
            GroupMember groupId = [
                Select UserOrGroupId, GroupId From GroupMember 
                where Group.DeveloperName = 'Customer_Loyalty' 
                and Group.Type = 'Queue'];
            if (groupId == null || groupId.GroupId == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Customer Loyalty Group not found.'));
                return;
            }
            // Total Settled opps
            List<AggregateResult> tsopps = [
                SELECT COUNT(Id) total FROM Custom_Opportunity__c 
                WHERE OwnerId = :userId and Status__c = 'Settled'];
            if (!tsopps.isEmpty() && tsopps[0].get('total') != null) {
                this.totalOpps = (Integer)tsopps[0].get('total');
            }
            List<Custom_Opportunity__c> custOppList = [
                Select OwnerId, Lead__c, Status__c, Reason_for_Closure__c, Account__c 
                from Custom_Opportunity__c 
                where OwnerId = :userId and Status__c = 'Settled'
                limit 50];
            for(Custom_Opportunity__c custOpp : custOppList){
                custOpp.OwnerId = groupId.GroupId ;
            }
            if(custOppList != null && !custOppList.isEmpty()){
                Database.SaveResult[] srList = Database.update(custOppList, false);
                Integer successes = 0;
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        successes++;
                    }
                    // } else {
                    //     for(Database.Error err : sr.getErrors()) {
                    //         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,err.getStatusCode() + ': ' + err.getMessage() + '. Account fields that affected this error: ' + err.getFields());
                    //         ApexPages.addMessage(myMsg);
                    //     }
                    // }
                }
                if(successes > 0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Number of records transferred to Customer Loyalty Group:' + successes));
                }
                if (successes < this.totalOpps) {
                    this.requireNewProcess = true;
                    ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.WARNING,successes + ' of ' + this.totalOpps +' records transferred to Customer Loyalty Group, please click on Process to continue'));
                }
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Opportunities found.');
                ApexPages.addMessage(myMsg);
            }
        } catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception error:' + ex.getMessage()));
        }
        
    }
}