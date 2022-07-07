@isTest(SeeAllData=true)
private class TestBlankCalculator {
  @isTest
  static void testCalculator() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.tstOpportunity.Preapproval_Auth_Date__c = Datetime.now();
    update Test_DataGeneratorHelper.tstOpportunity;

    Test.startTest();
    
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Finance One
    PageReference calcRef = Page.BlankCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    BlankCalculatorEstension ctr = new BlankCalculatorEstension(sc);

    for (Lenders__c a : Lenders__c.getAll().values()) {
      calcRef = Page.BlankCalculator;
      calcRef.getParameters()
        .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
      calcRef.getParameters().put('quoting', a.lender__c);
      Test.setCurrentPageReference(calcRef);
      ctr = new BlankCalculatorEstension(sc);
      ctr.validate();
    }

    //Latitude Personal Loan
    calcRef = Page.BlankCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    calcRef.getParameters().put('quoting', 'Latitude Personal Loan');
    Test.setCurrentPageReference(calcRef);
    ctr = new BlankCalculatorEstension(sc);
    ctr.validate();
    
    // Prospa
    calcRef = Page.BlankCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    calcRef.getParameters().put('quoting', 'Prospa');
    Test.setCurrentPageReference(calcRef);
    ctr = new BlankCalculatorEstension(sc);
    ctr.validate();
    
    ctr.getIsBrokerPartnerUser();
    
    Test.stopTest();

  }

  @isTest
  static void testLoanProductDifNull() {
    test.startTest();
    Test_DataGeneratorHelper.applicationQuotingAndProduct();
    Test_DataGeneratorHelper.reloadOpportunity();

    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.BlankCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    BlankCalculatorEstension ctr = new BlankCalculatorEstension(sc);
    test.stopTest();
  }
}