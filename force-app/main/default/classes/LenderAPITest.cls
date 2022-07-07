@isTest(SeeAllData=true)
public class LenderAPITest {
  @isTest static void invokePepperTest() {
    User pu = Test_DataGeneratorHelper.buildPartnerUser();
    Custom_Opportunity__c opp = null;
    Application__c app = null;
    System.runAs(pu) {
      app = Test_DataGeneratorHelper.buildCarApp(true);
      opp = Test_DataGeneratorHelper.tstOpportunity;
    }
    Test.startTest();
    System.runAs(pu) {
      LenderAPI.invokeApi(null);
      LenderAPI.invokeApi(opp.Id);
      // Create a quoting record
      Test_DataGeneratorHelper.createQuoting('Any Lender');
      LenderAPI.invokeApi(opp.Id);
      Test_DataGeneratorHelper.quoting.Name = 'Pepper MV';
      update Test_DataGeneratorHelper.quoting;
      LenderAPI.invokeApi(opp.Id);
      // Partner API Settings
      Contact con = SOQLSingletonQueries.recs().myContact;
      System.assert(con !=null, 'Contact can\'t be null');
      Test_DataGeneratorHelper.createPartnerAPISetting(
        'OAuth', 'Pepper', con.AccountId
      );
      LenderAPI.invokeApi(opp.Id);
      // Lender Login
      Test_DataGeneratorHelper.createLenderLogin(
        'Pepper', 'myuser', pu.Id
      );
      LenderAPI.invokeApi(opp.Id);

      // Pepper Leisure
      Test_DataGeneratorHelper.quoting.Name = 'Pepper Leisure';
      update Test_DataGeneratorHelper.quoting;
      LenderAPI.invokeApi(opp.Id);

      // Pepper Commercial
      Test_DataGeneratorHelper.quoting.Name = 'Pepper Commercial';
      update Test_DataGeneratorHelper.quoting;
      LenderAPI.invokeApi(opp.Id);

    }
    Test.stopTest();
  }

  @isTest static void invokePlentiTest() {
    User pu = Test_DataGeneratorHelper.buildPartnerUser();
    Custom_Opportunity__c opp = null;
    Application__c app = null;
    System.runAs(pu) {
      app = Test_DataGeneratorHelper.buildCarApp(true);
      opp = Test_DataGeneratorHelper.tstOpportunity;
    }
    Test.startTest();
    System.runAs(pu) {
      
      // Partner API Settings
      Contact con = SOQLSingletonQueries.recs().myContact;
      System.assert(con !=null, 'Contact can\'t be null');
      Test_DataGeneratorHelper.createPartnerAPISetting(
        'Partner ID', 'Plenti', con.AccountId
      );
      
      // Lender Login
      Test_DataGeneratorHelper.createLenderLogin(
        'Plenti', 'myuser', pu.Id
      );
      
      // Create a quoting record
      Test_DataGeneratorHelper.createQuoting('RateSetter');
      LenderAPI.invokeApi(opp.Id);

      // Plenti PL
      Test_DataGeneratorHelper.quoting.Name = 'RateSetter PL';
      update Test_DataGeneratorHelper.quoting;
      LenderAPI.invokeApi(opp.Id);

    }
    Test.stopTest();
  }

  @isTest static void invokeFinanceOneTest() {
    User pu = Test_DataGeneratorHelper.buildPartnerUser();
    Custom_Opportunity__c opp = null;
    Application__c app = null;
    System.runAs(pu) {
      app = Test_DataGeneratorHelper.buildCarApp(true);
      opp = Test_DataGeneratorHelper.tstOpportunity;
    }
    Test.startTest();
    System.runAs(pu) {
      
      // Partner API Settings
      Contact con = SOQLSingletonQueries.recs().myContact;
      System.assert(con !=null, 'Contact can\'t be null');
      Test_DataGeneratorHelper.createPartnerAPISetting(
        'Token', 'FinanceOne', con.AccountId
      );
      
      // Lender Login
      Test_DataGeneratorHelper.createLenderLogin(
        'Finance 1', 'myuser', pu.Id
      );
      
      // Create a quoting record
      Test_DataGeneratorHelper.createQuoting('	Finance One');
      LenderAPI.invokeApi(opp.Id);

    }
    Test.stopTest();
  }

  @isTest static void invokeLatitudeTest() {
    User pu = Test_DataGeneratorHelper.buildPartnerUser();
    Custom_Opportunity__c opp = null;
    Application__c app = null;
    System.runAs(pu) {
      app = Test_DataGeneratorHelper.buildCarApp(true);
      opp = Test_DataGeneratorHelper.tstOpportunity;
    }
    Test.startTest();
    System.runAs(pu) {
      
      // Partner API Settings
      Contact con = SOQLSingletonQueries.recs().myContact;
      System.assert(con !=null, 'Contact can\'t be null');
      Test_DataGeneratorHelper.createPartnerAPISetting(
        'OAuth', 'Latitude', con.AccountId
      );
      
      // Lender Login
      Test_DataGeneratorHelper.createLenderLogin(
        'Latitude (E Motor)', 'myuser', pu.Id
      );
      
      // Create a quoting record
      Test_DataGeneratorHelper.createQuoting('Latitude');
      LenderAPI.invokeApi(opp.Id);

    }
    Test.stopTest();
  }

  @isTest static void invokeMoney3Test() {
    User pu = Test_DataGeneratorHelper.buildPartnerUser();
    Custom_Opportunity__c opp = null;
    Application__c app = null;
    System.runAs(pu) {
      app = Test_DataGeneratorHelper.buildCarApp(true);
      opp = Test_DataGeneratorHelper.tstOpportunity;
    }
    Test.startTest();
    System.runAs(pu) {
      
      // Partner API Settings
      Contact con = SOQLSingletonQueries.recs().myContact;
      System.assert(con !=null, 'Contact can\'t be null');
      Test_DataGeneratorHelper.createPartnerAPISetting(
        'Token + Partner ID', 'Money3', con.AccountId
      );
      
      // Lender Login
      Test_DataGeneratorHelper.createLenderLogin(
        'Money3', 'myuser', pu.Id
      );
      
      // Create a quoting record
      Test_DataGeneratorHelper.createQuoting('Money3');
      LenderAPI.invokeApi(opp.Id);

    }
    Test.stopTest();
  }

}