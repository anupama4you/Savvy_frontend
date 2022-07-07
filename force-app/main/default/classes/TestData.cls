@isTest
public class TestData
{
    public TestData()
    {
        RecordTypes = new Map<String, Id>();
        for (RecordType rt : [SELECT Id,
                                     Name
                              FROM RecordType])
        {
            RecordTypes.put(rt.Name, rt.Id);
        }     
        
        SysGen = [SELECT Id FROM User WHERE Name = 'System Generated'];                         
                                           
        TestAccount = new Account(RecordTypeId = recordTypes.get('Person Account'),
                                  FirstName = 'Test',
                                  LastName = 'Test',
                                  PersonMobilePhone = '0412345678',
                                  PersonEmail = 'test1@test.com',
                                  PersonOtherStreet = 'Test',
                                  PersonOtherCity = 'Test',
                                  PersonOtherState = 'Test',
                                  PersonOtherPostalCode = 'Test');
        insert TestAccount;        
        
        TestLeadConsultantDealer = new Account(RecordTypeId = recordTypes.get('Savvy Dealer'),
                                               Name = 'Test',
                                               BillingStreet = 'Test',
                                               BillingCity = 'Test',
                                               BillingState = 'Test',
                                               BillingPostalCode = 'Test',
                                               ShippingStreet = 'Test',
                                               ShippingCity = 'Test',
                                               ShippingState = 'Test',
                                               ShippingPostalCode = 'Test',
                                               Commission_Amount__c = 123);
        insert TestLeadConsultantDealer;
        
        TestLeadConsultant = new Contact(AccountId = TestLeadConsultantDealer.Id,
                                         FirstName = 'Test',
                                         LastName = 'Test');
        insert TestLeadConsultant;                                       
        
        TestLead = new Lead__c(Account__c = TestAccount.Id,
                               First_Name__c = 'Test',
                               Last_Name__c = 'Test',
                               Finance_Amount__c = 123,
                               Email_Address__c = 'test2@test.com',
                               Lead_Consultant__c = TestLeadConsultant.Id,
                               OwnerId = UserInfo.getUserId(),
                               Status__c = 'Attempted Contact');
        insert TestLead; 
        
        TestSysGenLead = new Lead__c(OwnerId = SysGen.Id,
                                     Account__c = TestAccount.Id,
                                     First_Name__c = 'Test',
                                     Last_Name__c = 'SysGen',
                                     Finance_Amount__c = 123);
        insert TestSysGenLead ;   
        
        TestOpportunity = new Custom_Opportunity__c(Account__c = TestAccount.Id,
                                             Lead__c = TestLead.Id,
                                             Status__c = 'Quote Sent'/*,
                                             Date_closed_or_settled__c = Date.today().addMonths(-1)addYes(-1)*/);
        insert TestOpportunity;  
        
        TestFinanceProduct = new Product__c(RecordTypeId = RecordTypes.get('Finance'),
                                            Opportunity_Name__c = TestOpportunity.Id,
                                            End_of_Loan_Date__c = Date.today().addDays(60),                                            
                                            DOF__c = 1,
                                            Brokerage__c = 1);
        insert TestFinanceProduct;
        
        insert new Product__c(RecordTypeId = RecordTypes.get('Finance'),
                              Opportunity_Name__c = TestOpportunity.Id,
                              End_of_Loan_Date__c = Date.today().addMonths(3),                              
                              DOF__c = 1,
                              Brokerage__c = 1);
        
        TestInsuranceProduct = new Product__c(RecordTypeId = RecordTypes.get('Insurance'),
                                              Opportunity_Name__c = TestOpportunity .Id,                                              
                                              Insurance_Type__c = 'Gap Insurance');
        insert TestInsuranceProduct; 

        update TestOpportunity;

        //TestInvoice = new Invoice__c(Product__c = TestProduct.Id);
        //insert TestInvoice;    
        
        // set up the custom settings
        insert new Saasu_Settings__c(URL__c = 'https://secure.saasu.com/webservices/rest/r1/Tasks?wsaccesskey=096D4FEF450C4A078A848B00448C1DBB&FileUid=48127');
    }
    
    public Account TestAccount { get; set; }
    public Account TestLeadConsultantDealer { get; set; }
    public Contact TestLeadConsultant { get; set; }
    public Lead__c TestLead { get; set; }
    public Lead__c TestSysGenLead { get; set; }
    public Custom_Opportunity__c TestOpportunity { get; set; }
    public Product__c TestFinanceProduct { get; set; }
    public Product__c TestInsuranceProduct { get; set; }
    public Invoice__c TestInvoice { get; set; }
    public User SysGen { get; set; }
    public Map<String, Id> RecordTypes { get; set; } 
}