public class MacquarieSettingsExtension {

    public Custom_Opportunity__c opp;
    public List<Maclease_Partner_Service_Settings__c> settings;
    public List <SelectOption> users;
    public List<Lender_Login__c> lendersLogin;
    public static final String MACQUARIE_LENDER = 'Macquarie';
    
    public MacquarieSettingsExtension (ApexPages.StandardController controller) {
        try {
            controller.addFields(new List<String>{'Application__c'});
        } catch (SObjectException e) {}
        this.opp = (Custom_Opportunity__c)controller.getRecord ();
        
        MacquarieManager.getUserOptionsConnect();
        loadData();
    }
    
    public void loadData(){
        settings = [select name, value__c, endpoint__c from Maclease_Partner_Service_Settings__c ];
        if (settings == null){
            settings = new List<Maclease_Partner_Service_Settings__c>();
        }
        
        lendersLogin = [SELECT Id, Lender__c, Password__c, Password_Two__c, State__c, User_Linked__c, User_Name__c, 
                        Owner.Id, Owner.Name, User_Linked__r.Name , Access_Token__c , Consumer_Key__c 
			FROM Lender_Login__c where Lender__c = :MACQUARIE_LENDER ORDER BY Owner.Name];
        if (lendersLogin == null){
            lendersLogin = new List<Lender_Login__c>();
        }
        users = Utilities.getUsersConsultantsActiveOptions();
        //users.set(index, value)
    }
    
    public void updateRow(){
        Integer i = 0;
        for (i = 0; i < lendersLogin.size(); i++){
            Lender_Login__c u = lendersLogin.get(i);
            String key = u.User_Name__c;
            String pwd = u.Password__c;
            u.Consumer_Key__c = EncodingUtil.base64Encode(Blob.valueof(key + ':' + pwd));
            if (StringUtils.isNullOrEmpty(u.id)){
                if (StringUtils.isNullOrEmpty(u.User_Name__c) || StringUtils.isNullOrEmpty(u.Password__c) 
                   	|| StringUtils.isNullOrEmpty(u.Access_Token__c)){
                    lendersLogin.remove(i);
                    continue;
                }
                u.Lender__c = MACQUARIE_LENDER;
                insert u;
            }
        }
        if (lendersLogin != null && lendersLogin.size() > 0){
            update lendersLogin;
        }
        update settings;
    }
    
    public void addUser(){
        
        if (lendersLogin == null){
            lendersLogin = new List<Lender_Login__c>();
        }
        lendersLogin.add(new Lender_Login__c());
    }
    
    public List<Maclease_Partner_Service_Settings__c> getSettings(){
        return settings;
    }
    
    
    public List<SelectOption> getUsers(){
        return users;
    }

    
    public List<Lender_Login__c> getLendersLogin (){
        return lendersLogin;
    }
    
}