public class ActiveOppCampaignCallout {

  @future (callout=true)
  public static void InsertAndUpdate(Set<Id> setOppsIds, Map<id,string> mapStsUpd) {

    for(Custom_Opportunity__c oppObj : [Select id, Account_First_Name__c,Email_Address__c,Status__c,Reason_for_closure__c,Mobile_Number__c,Opp_Loan_Term__c,Opp_Loan_Type__c,State__c,
                                               Owner_Name__c,Owner_Email__c,Owner_Mobile__c,Owner_Phone__c 
            from Custom_Opportunity__c where Id in :setOppsIds and Owner_Name__c != 'Home Loans']){
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_sync&api_output=json');
        req.setMethod('POST');
        req.setBody('Content-Type=application/x-www-form-urlencoded');                
        req.setBody('Content-Length="512"');
        string statusUpdate='No';
        
        if(mapStsUpd.containsKey(oppObj.id) && mapStsUpd.get(oppObj.id) == 'Yes'){                
                    statusUpdate='Yes';                
        }else if(mapStsUpd.containsKey(oppObj.id) && mapStsUpd.get(oppObj.id) == 'No'){                
                    statusUpdate='No';
        }
        
        system.debug('####statusUpdate'+statusUpdate);                
        System.debug(opportunityXML(oppObj,statusUpdate));
        
        req.setBody(opportunityXML(oppObj,statusUpdate)); 
        
        System.debug('HttpRequest :' +req);
        System.debug('HttpRequest :' +req.getBody());
        System.debug('HttpRequest :' +req.getHeader('Authorization'));
        
        HttpResponse res = http.send(req);
        System.debug('HttpRequest Response:' +res.getBody());
        System.debug('HttpRequest Status Code:' +res.getStatusCode());
        
        if (res.getStatusCode() != 200) {
            System.debug('Error from ' + req.getEndpoint() + ' : ' +
            res.getStatusCode() + ' ' + res.getStatus());
        }

        
    }// end for  
 
  }// end method
  
    @future (callout=true)
    public static void DeleteReq(Set<Id> setOppsIds) {
            /*
             for(Id oppObjID : setOppsIds){
            
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_delete&api_output=json');
                req.setMethod('GET');
                req.setBody('Content-Type=application/x-www-form-urlencoded');                
                req.setBody('Content-Length="512"');          
                
                req.setBody(oppObjId); 

                HttpResponse res = http.send(req);
                System.debug('HttpRequest Response:' +res.getBody());
                System.debug('HttpRequest Status Code:' +res.getStatusCode());
                
                if (res.getStatusCode() != 200) {
                    System.debug('Error from ' + req.getEndpoint() + ' : ' +
                    res.getStatusCode() + ' ' + res.getStatus());
                }
                
            }*/
        
    }
  
   private static String opportunityXML(Custom_Opportunity__c opp, string isStatusUpd)
    {
        String msg = '';
        string oppStatus=string.valueOf(opp.Status__c);
        string oppClosure=string.valueOf(opp.Reason_for_closure__c);
        string oppLoanTerm=string.valueOf(opp.Opp_Loan_Term__c);
        string OwnerName;
        string OwnerEmail;
        string OwnerMobile;
        string OwnerPhone;
        string oppStatusUpd;
        
        if(opp.Owner_Name__c == 'System Generated'){
            OwnerName='';
        }
        else  
        {
            OwnerName=opp.Owner_Name__c;      
        }   
        if(opp.Owner_Email__c == 'systemgenerated@savvy.com.au'){
            OwnerEmail='';
        }
        else
        {
            OwnerEmail=opp.Owner_Email__c;
        }
        if(opp.Owner_Mobile__c ==''){
            OwnerMobile = '';
        }      
        else
        {    
            OwnerMobile = opp.Owner_Mobile__c;
        }
        if(opp.Owner_Phone__c ==''){
            OwnerPhone='';
        }
        else
        {
            OwnerPhone=opp.Owner_Phone__c ;
        }
        if(opp.Status__c==opp.status__c){
            oppStatusUpd='';
        }
        else
        {
            oppstatusUpd=oppStatus;
        }
        
           
        msg+='email='+opp.Email_Address__c+'&First_Name='+opp.Account_First_Name__c+'&p[3]=3&instantresponders[3]=1&field[%OPP_STATUS%,0]='+opp.Status__c+'&instantresponders[3]=1&field[%STATE%,0]='+opp.State__c+'&instantresponders[3]=1&field[%OWNER_NAME%,0]='+OwnerName+'&instantresponders[3]=1&field[%OWNER_EMAIL%,0]='+OwnerEmail+'&instantresponders[3]=1&field[%OWNER_MOBILE%,0]='+OwnerMobile+'&instantresponders[3]=1&field[%OWNER_PHONE%,0]='+OwnerPhone+'&instantresponders[3]=1&field[%OPP_REASON_FOR_CLOSURE%,0]='+opp.Reason_for_closure__c+'&instantresponders[3]=1&field[%LOAN_TERM%,0]='+opp.Opp_Loan_Term__c+'&instantresponders[3]=1&field[%LOAN_TYPE%,0]='+opp.Opp_Loan_Type__c+'&tags[0]='+oppStatus+'&tags[1]='+oppClosure; 

        if(isStatusUpd=='Yes'){
        msg+='&instantresponders[3]=1&field[%OPP_STATUS%,0]='+opp.Status__c;
        }
        
        
        return msg;
        
    } // end method
  
  
}//end class