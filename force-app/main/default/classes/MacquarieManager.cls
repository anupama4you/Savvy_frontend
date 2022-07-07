public class MacquarieManager extends APIServiceManager{

    /**
    public Boolean isError {set; get;}
    public String message {set; get;}
    
    public Integer responseStatus {set; get;}
    public String responseMessage {set; get;}
    **/
    
    public McqAuthenticationDTO mcqAuthentication {set; get;}
    public McqErrorResponse mcqError {set; get;}
    public McqQuoteResponseDTO mcqQuoteResponse {set; get;}
    public McqCreditApplicationResponseDTO mcqCreditAppResponse {set; get;}
    
    public MacquarieManager(){
        clean();
    }
    
    /**
    private void validateMessageErrorMacquarie (String jsonString){
        mcqError = parseErrorResponse (jsonString);
        if (mcqError == null){
            isError = true;
        }else if (mcqError.message != null && mcqError.code != null){
            isError = true;
            this.message = mcqError.message;
        }
    }
    **/
    
    public McqCreditApplicationResponseDTO parseCreateApplicationResponse (String jsonString){
        try{
            JSONParser parser = JSON.createParser(jsonString);
            mcqCreditAppResponse = (McqCreditApplicationResponseDTO) parser.readValueAs(McqCreditApplicationResponseDTO.class);
            mcqCreditAppResponse.lastResponseApplication = DateUtils.convertToString(System.now(), DateUtils.ddMMYYYY_hhmmss);
        	return mcqCreditAppResponse;
        }catch (JSONException ex){
            String msg = '@Error parse object *createApplicationResponse*. -[' + jsonString + '] - [' + ex.getMessage() + ']';
            System.debug(msg);
            throw new MacLeasePartnerException(msg, ex);
        }
        
    }
    
    public McqQuoteResponseDTO parseQuoteResponse (String jsonString){
        try{
            JSONParser parser = JSON.createParser(jsonString);
            mcqQuoteResponse = (McqQuoteResponseDTO) parser.readValueAs(McqQuoteResponseDTO.class);
            //mcqQuoteResponse.lastResponseQuote = System.now().format('hh:mm:ss /  dd-MM-YYYY'); 
            mcqQuoteResponse.lastResponseQuote = DateUtils.convertToString(System.now(), DateUtils.ddMMYYYY_hhmmss);
        	return mcqQuoteResponse;
        }catch (JSONException ex){
            String msg = '@Error parse object *QuoteResponse*. -[' + jsonString + '] - [' + ex.getMessage() + ']';
            System.debug(msg);
            throw new MacLeasePartnerException(msg, ex);
        }
        
    }
          
    public McqAuthenticationDTO parseAuthentication (String jsonString){
        //return (McqAuthenticationDTO) JSON.deserialize(jString, McqAuthenticationDTO.class);
        try{
            JSONParser parser = JSON.createParser(jsonString);
            mcqAuthentication = (McqAuthenticationDTO) parser.readValueAs(McqAuthenticationDTO.class);
        	return mcqAuthentication;
        }catch (JSONException ex){
            String msg = '@Error parse object *Authentication*. -[' + jsonString + '] - [' + ex.getMessage() + ']';
            System.debug(msg);
            throw new MacLeasePartnerException(msg, ex);
        }
        
    }
    
    public McqErrorResponse parseErrorResponse (String jsonString){
        try{
            JSONParser parser = JSON.createParser(jsonString);
            mcqError = (McqErrorResponse)  parser.readValueAs(McqErrorResponse.class);
            return mcqError;
        }catch (JSONException ex){
            String msg = '@Error parse object *ErrorResponse*. -[' + jsonString + '] - [' + ex.getMessage() + ']';
            System.debug(msg);
            throw new MacLeasePartnerException(msg, ex);
        }
    }
    
    public static List <SelectOption> getUserOptionsConnect(){
        List <SelectOption> mcqUserOptions = new List <SelectOption> ();
        mcqUserOptions.add(new SelectOption ('', 'None'));
        /**
        List<Message_Codes__c> users = Utilities.getListMessageCodes(Utilities.McQ_CONSUMER_KEY);
        for (Message_Codes__c u : users){
            mcqUserOptions.add(new SelectOption (u.description__c,u.code__c));
        }
        **/
        List<Lender_Login__c> lendersLogin = [SELECT Id, User_Name__c, Owner.Name, Consumer_Key__c 
                                                	FROM Lender_Login__c where Lender__c = :MacquarieSettingsExtension.MACQUARIE_LENDER 
                                              	and Consumer_Key__c <> '' and Access_Token__c <> '' ORDER BY Owner.Name];
        for (Lender_Login__c u : lendersLogin){
            mcqUserOptions.add(new SelectOption (u.id,u.User_Name__c + '-' + u.Owner.Name));
        }
        return mcqUserOptions;
    }
    
    /**
    public void clean(){
        this.isError = false;
        this.message = '';
    }
**/
}