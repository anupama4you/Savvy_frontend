trigger trgOptyLenderFieldU on Product__c (after insert, after update){
List<Custom_Opportunity__c> listOfOpty = new List<Custom_Opportunity__c>();
if(trigger.IsInsert){
    for(Product__c t: trigger.new){
        if(t.Lender__c != null && t.Lender__c != ''){
            Custom_Opportunity__c custOpty = new Custom_Opportunity__c();
            custOpty.Preferred_Lender__c = t.Lender__c;
            custOpty.Id = t.Opportunity_Name__c;
            listOfOpty.add(custOpty);
        }
    }
    if(listOfOpty.size()>0){
        update listOfOpty;
    }

}

else if(trigger.isUpdate){
    for(Product__c t:trigger.new){
        if(t.Lender__c != Trigger.oldMap.get(t.Id).Lender__c){
            Custom_Opportunity__c custOpty = new Custom_Opportunity__c();
            custOpty.Preferred_Lender__c = t.Lender__c;
            custOpty.Id = t.Opportunity_Name__c;
            listOfOpty.add(custOpty);       
        }
        
    }
    if(listOfOpty.size()>0){
        update listOfOpty;
    }

}


}