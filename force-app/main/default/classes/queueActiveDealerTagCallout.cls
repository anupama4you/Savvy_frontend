global class queueActiveDealerTagCallout implements Queueable , Database.AllowsCallouts {
    Custom_Opportunity__c opp = new Custom_Opportunity__c();
    
    public queueActiveDealerTagCallout(Custom_Opportunity__c oppObj) {
        System.debug('Creating ActiveDealerTagCallout...');
        opp = oppObj;
    }
    
    public void execute(QueueableContext context) {
        System.debug('Executing ActiveDealerTagCallout...');
        if(String.isNotEmpty(opp.Dealer_Email__c)){
            System.debug('Creating a request...');
            HttpRequest request = new HttpRequest();
            request.setMethod('POST');
            request.setEndpoint(BusinessParamHelper.getParameter('ACDEALER_ENPOINT'));
            request.setBody('Content-Type=application/x-www-form-urlencoded');                
            request.setBody('Content-Length="512"');
            request.setBody(dealerXML(opp)); 
            System.debug('Body...');
            System.debug(request.getBody());
            HttpResponse response = null;
            Http http = new Http();
            if(!Test.isRunningTest()){
                System.debug('Sending the request...');
                response = http.send(request);
            }
        }else{
            System.debug('The Dealer Email is empty. Please fill the dealer email field for the opportunity ' + Opp.Id);
        }
        System.debug('End.');
    }
    
    private static String dealerXML(Custom_Opportunity__c opp)
    {
        String msg = '';
        String ACDealerListId = BusinessParamHelper.getParameter('ACDEALER_LIST');
        String[] dealerType = new String[10];
        String[] dealerFirstName = new String[10]; 
        String dealerLastName;
        String dealerName = string.isEmpty(opp.Dealer_Name__c) ? '' : opp.Dealer_Name__c;
        String dealerPhoneNumber = string.isEmpty(opp.Dealer_Phone_Number__c) ? '' : opp.Dealer_Phone_Number__c;
        String dealerMobile = string.isEmpty(opp.Dealer_Mobile__c) ? '' : opp.Dealer_Mobile__c;
        String dealerSuburb = string.isEmpty(opp.Dealer_Suburb__c) ? '' : opp.Dealer_Suburb__c;
        String dealerPostcode = string.isEmpty(opp.Dealer_Postcode__c) ? '' : opp.Dealer_Postcode__c;
        String dealerState = string.isEmpty(opp.Dealer_State__c) ? '' : opp.Dealer_State__c;
        
        if(opp.Dealer_Contact_Name__c!=null){
            dealerFirstName = opp.Dealer_Contact_Name__c.split(' ');
            dealerLastName = dealerFirstName.size() > 1 ? dealerFirstName[1] : ' ';
        }else{
            dealerFirstName[0] = '';
            dealerLastName = '';
        }
        
        if(opp.Dealer_Type__c != null){
            dealerType = opp.Dealer_Type__c.split(' ');
        }else{
            dealerType[0]= '';
        }
        
        msg += 'email=' + EncodingUtil.urlEncode(opp.Dealer_Email__c,'UTF-8');
        msg += '&p['+ACDealerListId+']='+ACDealerListId+'&instantresponders[3]=0';
        msg += '&field[' + EncodingUtil.urlEncode('%DEALERSHIP_NAME%','UTF-8') + ',0]=' + dealerName;
        msg += '&field[' + EncodingUtil.urlEncode('%DEALER_FIRST_NAME%','UTF-8') + ',0]=' + dealerFirstName[0];
        msg += '&field[' + EncodingUtil.urlEncode('%DEALER_LAST_NAME%','UTF-8') + ',0]=' + dealerLastName;
        msg += '&field[' + EncodingUtil.urlEncode('%DEALER_PHONE%','UTF-8') + ',0]=' + dealerPhoneNumber;
        msg += '&field[' + EncodingUtil.urlEncode('%DEALER_MOBILE%','UTF-8') + ',0]=' + dealerMobile;
        msg += '&field[' + EncodingUtil.urlEncode('%DEALER_SUBURB%','UTF-8') + ',0]=' + dealerSuburb;
        msg += '&field[' + EncodingUtil.urlEncode('%DEALER_POSTCODE%','UTF-8') + ',0]=' + dealerPostcode;
        msg += '&field[' + EncodingUtil.urlEncode('%DEALER_STATE%','UTF-8') + ',0]=' + dealerState;
        msg += '&tags[0]=' + dealerType[0];
        return msg;   
    }
}