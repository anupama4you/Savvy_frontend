public class VDAllocation {
    
    public static Id allocateSales () {
        //
        List<GroupMember> members = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId IN 
                            (SELECT Id FROM Group WHERE DeveloperName = 'VD_Sales_Group')];
        List<Id> vdUsers = new List<Id>();
        for (GroupMember gm :  members) {
            vdUsers.add(gm.UserOrGroupId);
        }
        // Map to hold the count of tasks of each VD Owner
        Map<integer,User> VDOwnedMap = new Map<integer,User> ();
        Profile VDSales = [select id from profile where name = 'Vehicles Direct - Sales'];
        Id VDSalesId = null;
        List<AggregateResult> result  = [
            SELECT p.ActorId, count(ProcessInstanceId) TOTAL FROM ProcessInstanceWorkitem p 
            WHERE p.ActorId IN :vdUsers 
            GROUP BY p.ActorId
            ORDER BY count(ProcessInstanceId) ASC
        ];
        Map<Id, Integer> vdApprovers = new Map<Id, Integer>();
        
        for (AggregateResult a : result) {
            vdApprovers.put((Id)a.get('ActorId'), (Integer)a.get('TOTAL'));
        }
        
        List<User> VDOwners = [SELECT ID, Phone, Email, MobilePhone, Name, profileid FROM User 
                               WHERE profileid =: VDSales.id AND isActive = true
                               AND Id IN :vdUsers];
        for (User u : VDOwners) {
            if (!vdApprovers.containsKey(u.Id) && VDSalesId==null) {
                VDSalesId = u.Id;
            }
        }
        
        if (!result.isEmpty() && VDSalesId==null) {
            VDSalesId = (Id)result.get(0).get('ActorId');
        } else if (!VDOwners.isEmpty() && VDSalesId==null) {
            VDSalesId = VDOwners.get(0).Id;
        }
                
        /*Set <id> VDids = new Set<id> ();
        for (User VDOwner : VDOwners) {
            VDids.add(VDOwner.id);
        }
        
        For (User VDOwner : VDOwners) {
            System.debug('The Owner Id is: ' + VDOwner.id + ' and the Owner Name is: ' + VDOwner.Name);
            
            Integer VDCount = [SELECT count() FROM Custom_Opportunity__c WHERE VD_Owner__c =: VDOwner.Id 
                               and VD_Status__c != 'Sent back to Finance Consultant'
                               AND VD_Is_Old_Process__c = false];
            VDOwnedMap.put(VDCount, VDOwner);
            System.debug('The VDOwner is: ' + VDOwner.Name + ' and the count is: ' + VDCount);
        } //end for
        // Sort the map key to get the owner who has fewest tasks
        List<Integer> countList = new List<Integer> ();
        countList.addAll(VDOwnedMap.keySet());
        countList.sort();
        
        Id VDSalesId = VDOwnedMap.get(countList[0]).Id;
        System.debug('The person is: ' + VDOwnedMap.get(countList[0]).Name);*/
        System.debug('The Id is ' + VDSalesId);
        return VDSalesId;
    } //end method
    
    public static Id allocateSettlements () {
        List<User> VDOwners = [SELECT ID, Phone, Email, MobilePhone, Name, profileid FROM User 
                               WHERE profileid IN (SELECT id FROM profile WHERE name = 'Vehicles Direct - Settlements') AND isActive = true];
        if(!VDOwners.isEmpty()){
            return VDOwners.get(0).Id;
        }
        return null;

        //// Map to hold the count of tasks of each VD Owner
        //Map<integer,Id> VDOwnedMap = new Map<integer,Id> ();
        //Profile VDSettlements = SOQLSingletonQueries.recs().getVDProfile;//[select id from profile where name = 'Vehicles Direct - Settlements'];
        //List<User> VDOwners = new List<User>();
        //if(VDSettlements != null && VDSettlements.Id != null) {
        //	VDOwners = SOQLSingletonQueries.setProfId(VDSettlements.Id).vdUserByProfileId;//[SELECT ID, Phone, Email, MobilePhone, Name, profileid FROM User Where profileid =: VDSettlements.id AND isActive = true];
        //}
        //Set<Id> vdOwnerIds = new Set<Id>();
        //For (User VDOwner : VDOwners) {
        //	vdOwnerIds.add(VDOwner.Id);
        //}
        //Map<Id, Integer> vdCountMap = SOQLSingletonQueries.setUserIds(vdOwnerIds).vdOwnerOpportunityCountMap;
        //For (Id vdId : vdCountMap.keySet()) {         
        //	//System.debug('The Owner Id is: ' + VDOwner.id + ' and the Owner Name is: ' + VDOwner.Name);   
        //    Integer VDCount = vdCountMap.get(vdId);//[SELECT count() FROM Custom_Opportunity__c WHERE VD_Owner__c =: VDOwner.Id and VD_Status__c != 'Sent back to Finance Consultant'];
        //    VDOwnedMap.put(VDCount, vdId);
        //    //System.debug('The VDOwner is: ' + VDOwner.Name + ' and the count is: ' + VDCount);
        //} //end for
        //// Sort the map key to get the owner who has fewest tasks
        //List<Integer> countList = new List<Integer> ();
        //countList.addAll(VDOwnedMap.keySet());
        //countList.sort();
        
        ///*Id VDSettlementsId = VDOwnedMap.get(countList[0]).Id;
        //System.debug('The person is: ' + VDOwnedMap.get(countList[0]).Name);
        //System.debug('The Id is ' + VDSettlementsId);*/
        //if(!VDOwnedMap.isEmpty()){
        //	return VDOwnedMap.get(countList[0]);
        //}
        //return null;
    } //end method


    public static Boolean isActiveVDSalesUser(Id userId) {
        Boolean r = false;
        if (userId != null) {
            List<User> usrLists = [SELECT Id, isActive, profileid FROM User WHERE Id = :userId];
            if (!usrLists.isEmpty()) {
                if (usrLists.get(0).isActive) {
                    Profile p = [Select Name from Profile where Id =: usrLists.get(0).profileid];
                    if ('Vehicles Direct - Sales'.equals(p.name)) {
                        r = true;
                    }
                }
            }
        }
        return r;
    }

}