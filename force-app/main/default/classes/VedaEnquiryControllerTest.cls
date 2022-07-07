@isTest
public  class VedaEnquiryControllerTest {

    @isTest
    private static void fetchInitialDataTest(){
        Test_DataGeneratorHelper.createOpportunity();
        VedaEnquiryController.fetchInitialData(Test_DataGeneratorHelper.tstOpportunity.Id, new Map<String, String>());
        Test_DataGeneratorHelper.createApplication();
        VedaEnquiryController.fetchInitialData(Test_DataGeneratorHelper.tstOpportunity.Id, new Map<String, String>());
    }
    @isTest
    private static void submitEnquiryTest(){
      User pu = Test_DataGeneratorHelper.buildPartnerUser();
      System.runAs(pu) {
        Test_DataGeneratorHelper.createPartnerAPISettings();
        Test_DataGeneratorHelper.createOpportunity();
        Test_DataGeneratorHelper.createApplication();
        VedaEnquiryWrapper wrap = VedaEnquiryController.fetchInitialData(Test_DataGeneratorHelper.tstOpportunity.Id, new Map<String, String>());
        wrap.dateOfBirth = Date.newInstance(1995, 2, 17);
        wrap.dLicense = '123456789';
        wrap.cStreetNum = 'something';
        wrap.cStreetName = 'Street Name';
        wrap.cStreetType  = 'ALLY';
        wrap.cState = 'QLD';
        wrap.titleStr = 'Mr';
        wrap.fname = 'John';
        wrap.lname = 'DOe';
        wrap.oname = 'Middle';
        wrap.genderCode = 'M';
        wrap.enquiryAmt = 50000;
        wrap.isCR = true;
        wrap.currentTally = 2;
        VedaEnquiryController.submitEnquiry(wrap); 
      }
    }
    @isTest 
    private static void validateVedaWrapperTest(){
        Test_DataGeneratorHelper.createOpportunity();
        Test_DataGeneratorHelper.createApplication();
        VedaEnquiryWrapper wrap = VedaEnquiryController.fetchInitialData(Test_DataGeneratorHelper.tstOpportunity.Id, new Map<String, String>());
        wrap.currentTally = 2;
        wrap.vedaLimit = 2;
        VedaEnquiryController.validateVedaWrapper(wrap);
        wrap.currentTally = 1;
        wrap.vedaLimit = 2;
        wrap.dateOfBirth = null;
        wrap.dLicense = '12345678901';
        wrap.cStreetNum = null;
        wrap.cStreetName = null;
        wrap.cStreetType  = null;
        wrap.cState = null;
        VedaEnquiryController.validateVedaWrapper(wrap);
    }

    @isTest 
    private static void formPreviousAddressXMLTest(){
        Test_DataGeneratorHelper.createOpportunity();
        Test_DataGeneratorHelper.createApplication();
        VedaEnquiryWrapper wrap = VedaEnquiryController.fetchInitialData(Test_DataGeneratorHelper.tstOpportunity.Id, new Map<String, String>());
        VedaEnquiryController.formPreviousAddressXML(wrap);
    }

    @isTest 
    private static void formXMLRequestTest(){
        Test_DataGeneratorHelper.createOpportunity();
        Test_DataGeneratorHelper.createApplication();
        VedaEnquiryWrapper wrap = VedaEnquiryController.fetchInitialData(Test_DataGeneratorHelper.tstOpportunity.Id, new Map<String, String>());
        wrap.dateOfBirth = Date.newInstance(1995, 2, 17);
        wrap.dLicense = '123456789';
        wrap.cStreetNum = 'something';
        wrap.cStreetName = 'Street Name';
        wrap.cStreetType  = 'ALLY';
        wrap.cState = 'QLD';
        wrap.titleStr = 'Mr';
        wrap.fname = 'John';
        wrap.lname = 'DOe';
        wrap.oname = 'Middle';
        wrap.genderCode = 'M';
        wrap.enquiryAmt = 50000;
        wrap.isCR = true;
        wrap.currentTally = 2;
        String includeOname = '';
        Long enquiryAmtLong = wrap.enquiryAmt.longValue();
        String previousAddress = '';
        String dobYear = String.valueOf(wrap.dateOfBirth.year());
        String dobMonth = wrap.dateOfBirth.month() > 9 ? String.valueOf(wrap.dateOfBirth.month()): '0' + String.valueOf(wrap.dateOfBirth.month());
        String dobDay = wrap.dateOfBirth.day() > 9 ? String.valueOf(wrap.dateOfBirth.day()) : '0' + String.valueOf(wrap.dateOfBirth.day());
        VedaEnquiryController.formXMLRequest(wrap, dobYear, dobMonth, dobDay, previousAddress,  includeOname,  enquiryAmtLong);

    }
    @isTest 
    private static void sendRequestTest(){
        Test_DataGeneratorHelper.createOpportunity();
        Test_DataGeneratorHelper.createApplication();
        VedaEnquiryWrapper wrap = VedaEnquiryController.fetchInitialData(Test_DataGeneratorHelper.tstOpportunity.Id, new Map<String, String>());
        wrap.dateOfBirth = Date.newInstance(1995, 2, 17);
        wrap.dLicense = '123456789';
        wrap.cStreetNum = 'something';
        wrap.cStreetName = 'Street Name';
        wrap.cStreetType  = 'ALLY';
        wrap.cState = 'QLD';
        wrap.titleStr = 'Mr';
        wrap.fname = 'John';
        wrap.lname = 'DOe';
        wrap.oname = 'Middle';
        wrap.genderCode = 'M';
        wrap.enquiryAmt = 50000;
        wrap.isCR = true;
        wrap.currentTally = 2;
        String includeOname = '';
        Long enquiryAmtLong = wrap.enquiryAmt.longValue();
        String previousAddress = '';
        String dobYear = String.valueOf(wrap.dateOfBirth.year());
        String dobMonth = wrap.dateOfBirth.month() > 9 ? String.valueOf(wrap.dateOfBirth.month()): '0' + String.valueOf(wrap.dateOfBirth.month());
        String dobDay = wrap.dateOfBirth.day() > 9 ? String.valueOf(wrap.dateOfBirth.day()) : '0' + String.valueOf(wrap.dateOfBirth.day());
        String req1 = VedaEnquiryController.formXMLRequest(wrap, dobYear, dobMonth, dobDay, previousAddress,  includeOname,  enquiryAmtLong);
        VedaEnquiryController.servEndpointVal = 'https://google.com';
        Test.setMock(HttpCalloutMock.class, new EquifaxMock(req1));
        Test.startTest();
        VedaEnquiryController.sendRequests(wrap, req1); 
        Test.stopTest();
    }
    @isTest 
    private static void sendRequestTwoTest(){
        Test_DataGeneratorHelper.createOpportunity();
        Test_DataGeneratorHelper.createApplication();
        VedaEnquiryWrapper wrap = VedaEnquiryController.fetchInitialData(Test_DataGeneratorHelper.tstOpportunity.Id, new Map<String, String>());
        wrap.dateOfBirth = Date.newInstance(1995, 2, 17);
        wrap.dLicense = '123456789';
        wrap.cStreetNum = 'something';
        wrap.cStreetName = 'Street Name';
        wrap.cStreetType  = 'ALLY';
        wrap.cState = 'QLD';
        wrap.titleStr = 'Mr';
        wrap.fname = 'John';
        wrap.lname = 'DOe';
        wrap.oname = 'Middle';
        wrap.genderCode = 'M';
        wrap.enquiryAmt = 50000;
        wrap.isCR = true;
        wrap.currentTally = 2;
        String includeOname = '';
        Long enquiryAmtLong = wrap.enquiryAmt.longValue();
        String previousAddress = '';
        String dobYear = String.valueOf(wrap.dateOfBirth.year());
        String dobMonth = wrap.dateOfBirth.month() > 9 ? String.valueOf(wrap.dateOfBirth.month()): '0' + String.valueOf(wrap.dateOfBirth.month());
        String dobDay = wrap.dateOfBirth.day() > 9 ? String.valueOf(wrap.dateOfBirth.day()) : '0' + String.valueOf(wrap.dateOfBirth.day());
        String req1 = VedaEnquiryController.formXMLRequest(wrap, dobYear, dobMonth, dobDay, previousAddress,  includeOname,  enquiryAmtLong);
        Dom.Document doc2 = new Dom.Document();
        doc2.load(req1);
        dom.XmlNode xroot = doc2.getRootElement();
        VedaEnquiryController.repEndpointVal = 'https://google.com';
        Test.setMock(HttpCalloutMock.class, new EquifaxMock(req1));
         Test.startTest();
        VedaEnquiryController.sendRequestTwo(wrap, xroot );
        VedaEnquiryController.creatAttachment(wrap, Blob.valueOf('Hello World'));
        VedaEnquiryController.vedaClick(wrap);
        Test.stopTest();

    }
    @isTest 
    private static void exceptionTest(){
        try{
            VedaEnquiryWrapper wrap = VedaEnquiryController.fetchInitialData(null, new Map<String, String>());
        }catch(Exception excp){
        }
    }
    @isTest 
    private static void exceptionTest2(){
         try{
            VedaEnquiryWrapper wrap = new VedaEnquiryWrapper();
            VedaEnquiryController.sendRequests(wrap, null); 
        }catch(Exception excp){

        }

    }
    @isTest 
    private static void exceptionTest3(){
        try{
            VedaEnquiryWrapper wrap = new VedaEnquiryWrapper();
            VedaEnquiryController.sendRequestTwo(wrap, null); 
        }catch(Exception excp){

        }

    }
     @isTest 
    private static void exceptionTest4(){
         try{
            VedaEnquiryWrapper wrap = new VedaEnquiryWrapper();
            VedaEnquiryController.formVedalWrapper(wrap, null, new Map<String,String>());
        }catch(Exception excp){

        }

    }

    @isTest 
    private static void processRequestTest(){
        Test_DataGeneratorHelper.createOpportunity();
        Test_DataGeneratorHelper.createApplication();
        VedaEnquiryWrapper wrap = VedaEnquiryController.fetchInitialData(Test_DataGeneratorHelper.tstOpportunity.Id, new Map<String, String>());
        wrap.dateOfBirth = Date.newInstance(1995, 2, 17);
        wrap.dLicense = '123456789';
        wrap.cStreetNum = 'something';
        wrap.cStreetName = 'Street Name';
        wrap.cStreetType  = 'ALLY';
        wrap.cState = 'QLD';
        wrap.titleStr = 'Mr';
        wrap.fname = 'John';
        wrap.lname = 'DOe';
        wrap.oname = 'Middle';
        wrap.genderCode = 'M';
        wrap.enquiryAmt = 50000;
        wrap.isCR = true;
        wrap.currentTally = 2;
        VedaEnquiryController.servEndpointVal = 'https://google.com';
        VedaEnquiryController.repEndpointVal = 'https://google.com';
         String includeOname = '';
        Long enquiryAmtLong = wrap.enquiryAmt.longValue();
        String previousAddress = '';
        String dobYear = String.valueOf(wrap.dateOfBirth.year());
        String dobMonth = wrap.dateOfBirth.month() > 9 ? String.valueOf(wrap.dateOfBirth.month()): '0' + String.valueOf(wrap.dateOfBirth.month());
        String dobDay = wrap.dateOfBirth.day() > 9 ? String.valueOf(wrap.dateOfBirth.day()) : '0' + String.valueOf(wrap.dateOfBirth.day());
        String req1 = VedaEnquiryController.formXMLRequest(wrap, dobYear, dobMonth, dobDay, previousAddress,  includeOname,  enquiryAmtLong);
        //String req1 = VedaEnquiryController.formXMLRequest(wrap, dobYear, dobMonth, dobDay, previousAddress,  includeOname,  enquiryAmtLong);
         Test.setMock(HttpCalloutMock.class, new EquifaxMock(req1));
          Test.startTest();
        VedaEnquiryController.processRequest(wrap);
        Test.stopTest();

    }

}