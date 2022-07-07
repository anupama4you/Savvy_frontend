public virtual class TestAPILenders {
    
    public static void loadParameterService (String name, String value, String descp){
        if (Parameters_Service__c.getValues(name) == null){
            createParameterService(name, value, descp);
        }
    }
    
    private static void createParameterService(String name, String value, String descp){
        Parameters_Service__c serv = new Parameters_Service__c();
        serv.name = name;
        serv.value__c = value;
        serv.description__c = descp;
        insert serv;
    }
    
    public static Custom_Opportunity__c loadData(){
        Test_DataGeneratorHelper.createProduct();
        Test_DataGeneratorHelper.applicationQuoting(true);
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.createAssets();
        Test_DataGeneratorHelper.createPreviousEmployment();
        Test_DataGeneratorHelper.createQuoteAnnotations();
        
        
        Custom_Opportunity__c opp = getCustomOpportunity(Test_DataGeneratorHelper.tstOpportunity.Id);
        System.debug('------------------->> ' + opp);
        return opp;
           
    }
    
    private static Custom_Opportunity__c getCustomOpportunity (String idOpp){
        List<Custom_Opportunity__c> r = null;
        if (idOpp != null) {
            r = [Select id, Application__r.id, Application_AssetDetail__r.VIN__c, name, o.Owner_Email__c
                        from Custom_Opportunity__c  as o where id =: idOpp];
        }
        if (r != null && !r.isEmpty()) {
            return r.get(0);
        } else {
            return null;
        }
    }
    
    public static StaticResourceCalloutMock getStaticMock (Integer responseCode, String mockName, String typeHeader) {
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource(mockName);
        mock.setStatusCode(responseCode);
        mock.setHeader(ConnectionRESTWs.CONTENT_TYPE_HEADER , typeHeader);
        
        return mock;
    }
    
    public static void createEmailTemplate(String DeveloperName, String HtmlValue, String Subject, String name, String TemplateType){
        EmailTemplate et = new EmailTemplate();
        et.isActive = true; 
        et.Name = name;
        et.DeveloperName = DeveloperName;  
        et.TemplateType = 'text';  
        et.FolderId = UserInfo.getUserId(); 
	et.Body = ''; 

insert et; 
    }
}