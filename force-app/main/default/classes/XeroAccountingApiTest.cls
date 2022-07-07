/**
 * @author       Ben Edwards (ben@benedwards.co.nz)
 * @description  Test class for the Xero API methods
 **/
@isTest
public class XeroAccountingApiTest {
  @isTest
  static void instanceInvoice() {
    List<XeroAddress> addresses = new List<XeroAddress>();
    XeroAddress xeroAddress = new XeroAddress();
    xeroAddress.City = 'Nordwood';
    xeroAddress.Country = 'Australia';
    xeroAddress.PostalCode = 'IOYRERTYU';
    xeroAddress.AttentionTo = 'I dont undestand this field';
    xeroAddress.Region = 'Oceania';
    xeroAddress.AddressLine3 = 'Why so many lines?';
    addresses.add(xeroAddress);

    List<XeroPhone> phones = new List<XeroPhone>();
    XeroPhone xeroPhone = new xeroPhone();
    xeroPhone.PhoneAreaCode = '4';
    xeroPhone.PhoneCountryCode = '+61';
    xeroPhone.PhoneNumber = '7687765';
    phones.add(xeroPhone);

    XeroContact xeroContact = new XeroContact();
    xeroContact.ContactID = '03226130-e1c5-4b17-86b8-8718035b9135';
    xeroContact.ContactStatus = 'ACTIVE';
    xeroContact.Name = 'Yohan';
    xeroContact.FirstName = 'Freddy';
    xeroContact.EmailAddress = 'yohan.v@savvy.com.au';
    xeroContact.Phones = phones;
    xeroContact.Addresses = addresses;

    XeroInvoice newInvoice = new XeroInvoice();
    newInvoice.Contact = xeroContact;
    newInvoice.InvoiceNumber = 'SAVVY-0019';
    newInvoice.Status = 'DRAFT';
    newInvoice.AmountDue = 0;
    newInvoice.AmountPaid = 0;
    newInvoice.LineAmountTypes = 'Exclusive';
    newInvoice.CurrencyCode = 'AUD';
    newInvoice.Date_x = '2018-09-07T10:37:00';
    newInvoice.DueDate = '2018-09-07T10:37:00';
    newInvoice.CurrencyRate = 0;
    newInvoice.SubTotal = 900.00;
    newInvoice.TotalTax = 90.00;
    newInvoice.Total = 990.00;
    newInvoice.Type = 'ACCREC';

    List<XeroInvoice.LineItem> items = new List<XeroInvoice.LineItem>();
    XeroInvoice.LineItem item = new XeroInvoice.LineItem();

    item.Description = 'DOF';
    item.UnitAmount = 900.00;
    item.TaxType = 'INPUT';
    item.TaxAmount = 0;
    item.LineAmount = 900.00;
    item.AccountCode = '200';
    item.Quantity = 1;
    item.LineItemID = 'ba9d40de-2da8-4288-80ed-a7ececa5a343';

    List<XeroInvoice.cls_Tracking> trackings = new List<XeroInvoice.cls_Tracking>();
    XeroInvoice.cls_Tracking tracking = new XeroInvoice.cls_Tracking();

    tracking.TrackingCategoryID = 'ba1d43de-2da8-4488-80ed-a7eceda5f343';
    tracking.Name = 'Nordwood';
    tracking.Option = 'East';
    trackings.add(tracking);
    item.Tracking = trackings;

    items.add(item);
    newInvoice.LineItems = items;
  }

  @isTest
  static void instanceTracking() {
    XeroTrackingCategories tracking = new XeroTrackingCategories();
    tracking.TrackingCategoryID = '24234234234';
    tracking.Name = 'Hello World';
    tracking.Status = 'C';

    List<XeroTrackingCategories.Option> Options = new List<XeroTrackingCategories.Option>();
    XeroTrackingCategories.Option option = new XeroTrackingCategories.Option();
    option.TrackingOptionID = '34534654456';
    option.Name = 'HI World';
    option.Status = 'R';
    option.IsActive = true;
  }

  @isTest
  static void instanceXeroOnlineInvoices() {
    XeroOnlineInvoices onlineInvoices = new XeroOnlineInvoices();
    onlineInvoices.OnlineInvoiceUrl = 'https://c.cs6.visual.force.com/apex/';

    XeroOnlineInvoices onlineInvoice = new XeroOnlineInvoices(
      'https://c.cs6.visual.force.com/apex/'
    );
  }

  /**
   * 	@author Leandro
   *	@description Test a successful callout of the createInvoice() method
   **/
  @isTest
  static void createInvoiceJsonSuccess() {
    // Set the Mock Class for the callout
    Test.setMock(HttpCalloutMock.class, getStaticMock(200, 'XeroInvoicesMock'));

    Test.startTest();
    Xero_API_Setting__c xeroSetting = getXeroAPISettingMock();

    XeroInvoice createdInvoice = XeroAccountingApi.createInvoice(
      '{"Id": "917693e1-408b-4301-8c53-7a23b7abeb97"}',
      xeroSetting
    );

    Test.stopTest();

    // Assert that a contact exists
    system.assertNotEquals(
      null,
      createdInvoice,
      'There should be one invoice created from the callout'
    );
  }

  /**
   * 	@author Leandro
   *	@description Test a successful callout of the createInvoice() method
   **/
  @isTest
  static void createInvoiceJsonXeroSettingFail() {
    // Set the Mock Class for the callout
    Test.setMock(HttpCalloutMock.class, getStaticMock(200, 'XeroInvoicesMock'));

    Test.startTest();
    Xero_API_Setting__c xeroSetting = getXeroAPISettingMock();

    XeroInvoice createdInvoice = XeroAccountingApi.createInvoice(
      '{"Id": "917693e1-408b-4301-8c53-7a23b7abeb97"}',
      xeroSetting
    );

    Test.stopTest();

    // Assert that a contact exists
    system.assertNotEquals(
      null,
      createdInvoice,
      'There should be one invoice created from the callout'
    );
  }

  /**
   * 	@author Leandro
   *	@description Test an unsuccessful callout of the createInvoice() method
   **/
  @isTest
  static void createInvoiceJsonFail() {
    // Set the Mock Class for the callout
    Test.setMock(HttpCalloutMock.class, getStaticMock(500, 'XeroInvoicesMock'));

    Test.startTest();

    // Execute the callout
    try {
      Xero_API_Setting__c xeroSetting = getXeroAPISettingMock();

      XeroInvoice createdInvoice = XeroAccountingApi.createInvoice(
        '{"Id": "917693e1-408b-4301-8c53-7a23b7abeb97",}',
        xeroSetting
      );
    } catch (Exception ex) {
      System.debug(ex.getCause());
      System.debug(ex.getLineNumber());
      System.debug(ex.getMessage());
      System.debug(ex.getStackTraceString());
      System.debug(ex.getTypeName());
      // Error expected, as failed callout raises an exception
      system.assert(
        String.valueOf(ex).contains('500'),
        'The 500 error code should be contained in the string.'
      );
    }

    Test.stopTest();
  }

  @isTest
  static void createTrackingOptionSuccess() {
    // Set the Mock Class for the callout
    Test.setMock(
      HttpCalloutMock.class,
      getStaticMock(200, 'XeroTrackingCategoriesMock')
    );

    Test.startTest();
    Xero_API_Setting__c xeroSetting = getXeroAPISettingMock();
    // Execute the callout
    XeroAccountingApi.createTrackingOption(
      '{"Options": [{"TrackingOptionID": "3a008012-fc8e-4388-b6b5-206bc38b2b1b","Name": "SavvyA","Status": "ACTIVE","HasValidationErrors": false,"IsDeleted": false,"IsArchived": false,"IsActive": true}]}',
      xeroSetting
    );

    Test.stopTest();
  }

  @isTest
  static void createTrackingOptionJsonFail() {
    // Set the Mock Class for the callout
    Test.setMock(
      HttpCalloutMock.class,
      getStaticMock(500, 'XeroTrackingCategoriesMock')
    );

    Test.startTest();

    try {
      Xero_API_Setting__c xeroSetting = getXeroAPISettingMock();

      // Execute the callout
      XeroAccountingApi.createTrackingOption(
        '{"Options": [{"TrackingOptionID": "3a008012-fc8e-4388-b6b5-206bc38b2b1b","Name": "SavvyA","Status": "ACTIVE","HasValidationErrors": false,"IsDeleted": false,"IsArchived": false,"IsActive": true}]}',
        xeroSetting
      );
    } catch (Exception ex) {
      System.debug(ex.getCause());
      System.debug(ex.getLineNumber());
      System.debug(ex.getMessage());
      System.debug(ex.getStackTraceString());
      System.debug(ex.getTypeName());
      // Error expected, as failed callout raises an exception
      system.assert(
        String.valueOf(ex).contains('500'),
        'The 500 error code should be contained in the string.'
      );
    }

    Test.stopTest();
  }

  /**
   * 	@author Yohan villamizar
   *	@description Test a successful callout of the getTrackingCaategory(TrackingID) method
   **/
  @isTest
  static void getTrackingsSuccess() {
    // Set the Mock Class for the callout
    Test.setMock(
      HttpCalloutMock.class,
      getStaticMock(200, 'XeroTrackingCategoriesMock')
    );

    Test.startTest();
    Xero_API_Setting__c xeroSetting = getXeroAPISettingMock();
    // Execute the callout
    XeroTrackingCategories trackingCategory = XeroAccountingApi.getTrackingCaategory(
      xeroSetting
    );

    Test.stopTest();
  }

  @isTest
  static void getInvoicePdf() {
    Test.setMock(
      HttpCalloutMock.class,
      getStaticMock(200, 'XeroOnlineInvoiceMock')
    );
    Test.startTest();
    Xero_API_Setting__c xeroSetting = getXeroAPISettingMock();
    XeroAccountingApi.getInvoicePdf(
      '917693e1-408b-4301-8c53-7a23b7abeb97',
      xeroSetting
    );
    Test.stopTest();
  }

  @isTest
  static void getInvoicePdfFail400() {
    Test.setMock(
      HttpCalloutMock.class,
      getStaticMock(400, 'XeroOnlineInvoiceMock')
    );
    Test.startTest();
    Xero_API_Setting__c xeroSetting = getXeroAPISettingMock();
    XeroAccountingApi.getInvoicePdf(
      '917693e1-408b-4301-8c53-7a23b7abeb97',
      xeroSetting
    );
    Test.stopTest();
  }

  @isTest
  static void getInvoicePdfFail500() {
    Test.setMock(
      HttpCalloutMock.class,
      getStaticMock(500, 'XeroOnlineInvoiceMock')
    );
    Test.startTest();
    Xero_API_Setting__c xeroSetting = getXeroAPISettingMock();
    XeroAccountingApi.getInvoicePdf(
      '917693e1-408b-4301-8c53-7a23b7abeb97',
      xeroSetting
    );
    Test.stopTest();
  }

  /**
   * 	@author Yohan villamizar
   *	@description Test a successful callout of the getTrackingCaategory(TrackingID) method
   **/
  @isTest
  static void xmlUtilitySuccess() {
    // Set the Mock Class for the callout
    Test.setMock(
      HttpCalloutMock.class,
      getStaticMock(200, 'XeroTrackingCategoriesMock')
    );

    Test.startTest();

    XeroTrackingCategories.Option option = new XeroTrackingCategories.Option();
    option.TrackingOptionID = '34534654456';
    option.Name = 'HI World';
    option.Status = 'R';
    option.IsActive = true;
    XeroXmlUtility.serializeJson(option);

    Test.stopTest();
  }

  /**
   * 	@author Ben Edwards (ben@benedwards.co.nz)
   *	@description Test an unsuccessful callout of the getContacts() method
   **/
  private static StaticResourceCalloutMock getStaticMock(
    Integer responseCode,
    String mockName
  ) {
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource(mockName);
    mock.setStatusCode(responseCode);
    mock.setHeader('Content-Type', 'application/json');

    return mock;
  }

  /**
   * 	@author Ben Edwards (ben@benedwards.co.nz)
   *	@description Create test data for the method
   **/
  @testSetup
  static void setupTestData() {
    // Create a test Xero Setting record to Company A
    Xero_API_Setting__c x = getXeroAPISettingMock();
    insert x;
  }

  private static Xero_API_Setting__c getXeroAPISettingMock() {
    Xero_API_Setting__c r = new Xero_API_Setting__c();

    //SetupOwnerId = Userinfo.getOrganizationId();
    r.Name = 'CompanyA';
    r.App_Name__c = 'ApplicationA';
    r.Consumer_Key__c = '123456789';
    r.Consumer_Secret__c = '123456789';
    r.Endpoint__c = 'https://api.xero-test.com/';
    r.Invoice_Status__c = 'DRAFT';
    r.Tag_Category__c = 'fcfa4b51-5489-4347-ae47-5dea90f33c75';
    r.Profile__c = '';
    r.Active__c = true;
    r.Certificate_Name__c = 'savvycert';
    r.Xero_Tenant_ID__c = '3b6e7c1c-2a5e-4b5b-9c34-3dd0413cb094';

    return r;
  }
}