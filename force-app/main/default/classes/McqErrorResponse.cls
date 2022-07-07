public class McqErrorResponse extends ObjectJsonSerialize{
    
    public class ErrorsValidationData{
        public String code {set; get;}
        public String label {set; get;}
        public String message {set; get;}
        public String description {set;}
        
        public String getDescription(){
            List<Message_Codes__c> lCodes = [select name, code__c, description__c, domain__c from message_codes__c where code__c =: message];
            Message_Codes__c mc = (lCodes != null && lCodes.size() > 0) ? lCodes[0] : null;
            String dp = '@Message code no found';
            if (mc != null){
                dp = mc.description__c;
                if (dp == null || (dp != null && dp.equals(''))){
                    dp =  '@Description no found';
                }
            }
            return dp;
        }
    }
    
    public String error {set; get;}
    public String code {set; get;}
    public String message {set; get;}
    public String user {set; get;}
    public String reason {set; get;}
    public String entity_id {set; get;}
    public String entity {set; get;}
    
    public List<ErrorsValidationData> errors {set; get;}
    
    public override String toString(){
        String s = '-{';
        s += 'Error: ' + error;
        s += 'Code: ' + code;
        s += 'Message: ' + message;
        s += 'User: ' + user;
        s += 'Reason: ' + reason;
        s += 'EntityId: ' + entity_id;
        s += 'Entity: ' + entity;
        s += '}-';
        return s;
    }

}