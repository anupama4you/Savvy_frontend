public with sharing class LeadAccountLookupController
{
    public LeadAccountLookupController()
    {                               
        // do a default search if a search term has been passed in
        SearchTerm = ApexPages.CurrentPage().getParameters().get('srch');               
        if (SearchTerm != null)
        {
            SearchGo();    
        }
    }

    public String SearchTerm { get; set; }
    public List<Account> SearchResults { get; set; }
    public String Mode { get; set; }
    public Account NewAccount { get; set; }
    public String FirstName { get; set; }
    public String LastName { get; set; }
    
    public void SearchGo()
    {    
        Mode = 'Search';
    
        // convert * to % in the search term
        String likeSearch = SearchTerm.replace('*', '%') + '%';                
                
        // find the search results
        SearchResults = [SELECT Id,
                                Owner.Name,
                                Name,
                                PersonMobilePhone,
                                PersonEmail,
                                Postcode__c
                         FROM Account
                         WHERE RecordType.Name = 'Person Account'
                         AND (PersonMobilePhone LIKE :likeSearch OR PersonEmail LIKE :likeSearch)
                         ORDER BY Name limit 100];   
                         
        if (SearchResults == null)
        {
            SearchResults = new List<Account>();
        }                       
    }
    
    public void ClickNew()
    {    
        Mode = 'New';
        
        NewAccount = new Account();
        NewAccount.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Person Account'].Id;
        FirstName = ApexPages.CurrentPage().getParameters().get('fn');
        LastName = ApexPages.CurrentPage().getParameters().get('ln');
        NewAccount.PersonBirthDate = ApexPages.CurrentPage().getParameters().get('dob') != '' ? Date.parse(ApexPages.CurrentPage().getParameters().get('dob')) : null;
        NewAccount.Unit_House_Number__c = ApexPages.CurrentPage().getParameters().get('num');
        NewAccount.Street_Address__c = ApexPages.CurrentPage().getParameters().get('addr');
        NewAccount.Street_Type__c = ApexPages.CurrentPage().getParameters().get('st');
        NewAccount.Suburb__c = ApexPages.CurrentPage().getParameters().get('su');
        NewAccount.State__c = ApexPages.CurrentPage().getParameters().get('sta');
        NewAccount.Postcode__c = ApexPages.CurrentPage().getParameters().get('pc');
        NewAccount.PersonHomePhone = ApexPages.CurrentPage().getParameters().get('hp');
        NewAccount.PersonOtherPhone = ApexPages.CurrentPage().getParameters().get('wp');
        NewAccount.PersonMobilePhone = ApexPages.CurrentPage().getParameters().get('mp');
        NewAccount.PersonEmail = ApexPages.CurrentPage().getParameters().get('em');
    }
    
    public void SaveAccount()
    {
        try
        {
            NewAccount.FirstName = FirstName;
            NewAccount.LastName = LastName;
            insert NewAccount;    
            
            // select the account so that we have the name
            NewAccount = [SELECT Id,
                                 Name,
                                 PersonBirthDate,
                                 Unit_House_Number__c,
                                 Street_Address__c,
                                 Street_Type__c,                                 
                                 Suburb__c,
                                 State__c,
                                 Postcode__c,
                                 PersonHomePhone,
                                 PersonMobilePhone,
                                 PersonOtherPhone,
                                 PersonEmail,
                                 Commission_Percentage__c,
                                 Commission_Amount__c 
                          FROM Account
                          WHERE Id = :NewAccount.Id];
        }
        catch(Exception e)
        {
            CustomException.formatException(e);
        }
    }
    
}