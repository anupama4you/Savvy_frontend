@isTest(SeeAllData=true)
public class TestMoney3APIService extends TestAPILenders {

    public static Custom_Opportunity__c opp;
    private static String endPointApplication = Money3APIManager.getParameterService(Money3APIManager.MONEY3_SERVICE_ENDPOINT);
    private static String documentEndpoint = Money3APIManager.getParameterService(Money3APIManager.MONEY3_SERVICE_DOCUMENT_ENDPOINT);

    @isTest
    public static void testRequestApplication() {
        MultiRequestMock requestMocks = new MultiRequestMock();
        
        SingleRequestMock fakeRes = getQuickMockRequest('{"loanId": 456765,"brokerReferenceLoanId": "12345678","broker": "Johnny Money","submissionStatus": "Application Received","note": "If you haven\'t already, please upload the required documents so that Money3 can assess this loan.","additionalDetails": [{"field": "Address Renting Contact","message": "Renting Contact detials shoul dbe provided when applicant is renting"}],"createdAt": "2017-03-19T13:38:02+11:00"}', 200);
        requestMocks.addRequestMock(endPointApplication, fakeRes);
        
        fakeRes = getQuickMockRequest('{"errors":[{"message": "Loan Id does not exist"}]}', 404);
        requestMocks.addRequestMock(documentEndpoint, fakeRes);
        
        Test.setMock(HttpCalloutMock.class, requestMocks);
        
        opp = loadData();
        Application__c app = opp.Application__r;
        app.Application_Type__c = 'Personal';
        app.Status__c = 'F';
        update app;
        // Application Loans
        List<Application_Loan__c> loanList = new List<Application_Loan__c>();
        Application_Loan__c loan = getLoan('Debt/Default Arrangements');
        loan.Application__c = app.Id;
        loanList.add(loan);
        loan = getLoan('Personal Loan');
        loan.Application__c = app.Id;
        loanList.add(loan);
        insert loanList;
        // Credit cards
        Application_Credit_Card__c card = getCard(20000);
        card.Application__c = app.Id;
        insert card;
        //application extra data
        Application_Extra_Data__c data = new Application_Extra_Data__c();
        data.Category__c = 'Lender';
        data.Data__c = 'test';
        data.Type_of_Data__c = 'Notes';
        data.Application__c = app.Id;
        insert data;
        //documents
        Cloud_Documents__c doc = new Cloud_Documents__c();
        doc.Document_Type__c='Drivers License (Front & Back)';
        doc.Custom_Opportunity__c = opp.Id;
        doc.Send_To_Lender__c=true;
        insert doc;
        
        doc = new Cloud_Documents__c();
        doc.Document_Type__c='Applicant 2 Drivers License';
        doc.Custom_Opportunity__c = opp.Id;
        doc.Send_To_Lender__c=true;
        insert doc;
        //insert lender login
        Lender_Login__c userLogin = new Lender_Login__c();
        userLogin.Lender__c = 'Money3';
        userLogin.User_Name__c = '1234';
        insert userLogin;

        Test.startTest();
        loadParameterService ( 'Money3_Service_Endpoint', endPointApplication, 'Money3 API endpoint ');
        loadParameterService ( 'Money3_Service_Document_Endpoint', documentEndpoint, 'Money3 API document endpoint ');
        Money3APIService service = new Money3APIService();
        Money3APIManager manager = new Money3APIManager();
        List <SelectOption> usersAPIOptions = Money3APIManager.getUserOptionsConnect();
        LenderAPIResponse__c lar = null;
        try{
            service.requestApplication(manager, opp.Id, userLogin.User_Name__c, false);
            String money3API_BrokerReferenceId = manager.responseDto.brokerReferenceLoanId;
            Integer money3API_LoanId = manager.responseDto.loanId;
            String money3API_lastResponseApp = manager.responseDto.lastResponseApplication;
            System.debug('Application number:   ' + money3API_BrokerReferenceId);
            System.debug('Loan Id:   ' + money3API_LoanId);
            lar = Money3APIManager.saveLenderAPIResponse(opp.Id, manager, 'Money3', userLogin.User_Name__c);
        }catch(GenericException ex){
            manager.isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return;
        }
        doc = new Cloud_Documents__c();
        doc.Custom_Opportunity__c = opp.Id;
        doc.Send_To_Lender__c=true;
        insert doc;
        service.submitRequest(manager, opp.Id, 1, false);
        service.submitRequest(manager, opp.Id, 1, true);
        LenderAPIResponse__c l = new LenderAPIResponse__c();
        l.Application_ID__c = '1';
        l.Provider__c = 'Money3';
        // insert l;
        LenderAPIResponse__c l2 = new LenderAPIResponse__c();
        l2.Cloud_Document__c = doc.Id;
        l2.LenderAPIResponse__c = l.Id;
        l2.Status__c = 201;
        l2.Provider__c = 'Money3';
        // insert l2;
        
        service.submitRequest(manager, opp.Id, 1, true);

        if (lar != null) {
          manager.responseDto.docs = new List<LenderAPIResponse__c>{
            l, l2
          };
          Money3APIManager.saveLenderAPIResponseFiles(lar.Id, manager);
        }
        Test.stopTest();
    }

    @isTest
    public static void testDocumentUpload() {
        Test.setMock(HttpCalloutMock.class, getStaticMock(201, 'Money3APIDocument_Response', ConnectionRESTWs.CONTENT_TYPE_JSON));
        opp = loadData();
        //documents
        Cloud_Documents__c doc = new Cloud_Documents__c();
        doc.Document_Type__c='Drivers License (Front & Back)';
        doc.Custom_Opportunity__c = opp.Id;
        doc.Send_To_Lender__c=true;
        insert doc;

        Test.startTest();
        loadParameterService ( 'Money3_Service_Document_Endpoint', documentEndpoint, 'Money3 API document endpoint ');
        Money3APIService service = new Money3APIService();
        Money3APIManager manager = new Money3APIManager();
        manager.responseDto = new Money3APIResponseDTO();
        try{
            service.uploadDocumentsToMoney3(manager, opp.Id, 1234, false);
        }catch(GenericException ex){
            manager.isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ex.getMessage()));
            return;
        }
        MultiRequestMock requestMocks = new MultiRequestMock();
        SingleRequestMock fakeRes = getQuickMockRequest('{"errors":[{"field": "documentType","value": "Lorem","message": "Exceeded max length of 100"}]}', 400);
        requestMocks.addRequestMock(documentEndpoint, fakeRes);
        Test.setMock(HttpCalloutMock.class, requestMocks);
        service.uploadDocumentsToMoney3(manager, opp.Id, 1234, false);
        service.uploadDocumentsToMoney3(manager, opp.Id, 1234, true);
        Money3APIManager.LoanResponseDTO l = new Money3APIManager.LoanResponseDTO();
        l.loanId = 1;
        l.brokerReferenceLoanId = 's';
        l.branch = 's';
        l.broker = 's';
        l.submissionStatus = 's';
        l.note = 's';
        l.createdAt = 's';
        l.getHasMoreDetails();
        
        Money3APIManager.LoanResponseDetailsDTO l2 = new Money3APIManager.LoanResponseDetailsDTO();
        l2.field = 's';
        l2.message = 's';
        Test.stopTest();
    }

    private static Application_Loan__c getLoan(String loanType) {
        Application_Loan__c r = new Application_Loan__c();
        r.Type__c = loanType;
        r.Lender__c = 'Test';
        r.Amount_Owing__c = 10000;
        r.Payment__c = 100;
        r.Frequency__c = 'Weekly';
        r.Order__c = 0;
        return r;
    }

    private static Application_Credit_Card__c getCard(Decimal limitAmount) {
        Application_Credit_Card__c r = new Application_Credit_Card__c();
        r.Amount_Owing__c = 1000;
        r.Issuer__c = 'X';
        r.Limit__c = limitAmount;
        return r;
    }
    
    private static SingleRequestMock getQuickMockRequest(String body, Integer code) {
        SingleRequestMock r = new SingleRequestMock(
            code, 'Complete', body, null
        );
        return r;
    }
}