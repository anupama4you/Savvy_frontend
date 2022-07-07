@isTest(SeeAllData=true)
public class TestUtilitiesAll extends TestAPILenders {
  public static Custom_Opportunity__c opp;

  public static testMethod void testGeneral() {
    Test.startTest();
    testList();
    testStringUtils();
    testUtilities();
    testNumberUtils();
    testDateUtils();
    testVehicleYear();
    Test.stopTest();
  }

  private static void testList() {
    UtilitiesList.getStreetTypeOptions();
    UtilitiesList.getStatesOptions();
    UtilitiesList.getCountryOptions();
    UtilitiesList.getNameStreetType('AMBL');
    UtilitiesList.getWorstPastOptions();
    UtilitiesList.getPaidUnpaidOptions();
    UtilitiesList.getPaymentsMissedOptions();
    UtilitiesList.getReasonOptions();
    UtilitiesList.getBankruptcyTypeOptions();
    UtilitiesList.getAdverseEventOptions();
  }

  private static void testStringUtils() {
    StringUtils.validateNull('value');
    StringUtils.validateNull(null);
    StringUtils.convertToString(50);
    StringUtils.convertToString(null);
    StringUtils.removeSpaces(null);
    StringUtils.removeSpaces('12 25');

    StringUtils.isNullOrEmpty('abc');
    StringUtils.isNullOrEmpty(null);
    StringUtils.getFrequencyType(null, 'dfault');
    StringUtils.getFrequencyType('any', 'dfault');
    StringUtils.getFrequencyType('Monthly', 'dfault');
    StringUtils.getFrequencyType('Fortnightly', 'dfault');
    StringUtils.getFrequencyType('Weekly', 'dfault');
    StringUtils.getFrequencyType('Yearly', 'dfault');

    StringUtils.getLocalPhoneFormat(null);
    StringUtils.getLocalPhoneFormat('+61875521568');
    StringUtils.getLocalPhoneFormat('61415125585');

    StringUtils.removeAllCharacters(null);
    StringUtils.removeAllCharacters('34ref34f43f');

    System.assert(
      !StringUtils.isTestData('Any value'),
      'Test data should not be evaluated as a Test'
    );
    System.assert(
      StringUtils.isTestData('Test'),
      'Test data should be evaluated as a Test'
    );

    System.assert('0'.equals(StringUtils.convertToInt(null)), 'null values should return 0');
    System.assert('0'.equals(StringUtils.convertToInt('abc')), 'alphabet strings should return 0');
    System.assert('123'.equals(StringUtils.convertToInt('123')), 'integer values should return the same value');
    System.assert('123'.equals(StringUtils.convertToInt('123.45')), 'decimal values should return an integer value');

    System.assert('123'.equals(StringUtils.maxLength('12345', 3)), '3 characters fails');
    System.assert('123'.equals(StringUtils.maxLength('123', 3)), '3 characters fails');

  }

  private static void testUtilities() {
    Utilities.getStates();
    Utilities.getMessageCode('CM-TERTI');
    Utilities.getListMessageCodes('CM');
    Utilities.getMessageCode_Description('Cars');
    Utilities.getListMessageCodes_Description('Cars');

    Utilities.salesforceValueToMessageCode_Code('NSW', Utilities.STATES);
    Utilities.salesforceValueToMessageCode_Code('NSK', Utilities.STATES);

    Utilities.getEncrypt('encrypt', 'encrypt');
    Utilities.getUsersConsultantsActiveOptions();

    Utilities.getMonthlyValue('Weekly', null, 2);
    Utilities.getMonthlyValue('Weekly', 1000.00, 2);
    Utilities.getMonthlyValue('Fortnightly', 1000.00, 2);
    Utilities.getMonthlyValue('Yearly', 1000.00, 2);

    Utilities.validateFrequency('Weekly');
    Utilities.validateFrequency('Fortnightly');
    Utilities.validateFrequency('Yearly');
    Utilities.validateFrequency('Monthly');
    Utilities.validateFrequency('Monthly - income');
    Utilities.getGUID();
  }

  private static void testNumberUtils() {
    NumberUtils.convertToDecimal(null, true);
    NumberUtils.convertToDecimal(null, false);
    NumberUtils.convertToDecimal('abc', true);
    NumberUtils.convertToDecimal('abc', false);
    NumberUtils.convertToDecimal('10', false);
    NumberUtils.convertToDecimal('10', true);

    NumberUtils.convertDecimalToScale(123.45, 1);
    NumberUtils.convertDecimalToScale(null, 1);

    NumberUtils.convertStringToDecimal('123.45', 1);
    NumberUtils.convertStringToDecimal(null, 1);

    NumberUtils.convertStringToDecimal('123.45', 1);
    NumberUtils.convertToDecimal(null);
    NumberUtils.convertToDecimal(123.45);

    NumberUtils.convertToInteger(123.45);
    NumberUtils.convertToInteger(null);

    NumberUtils.convertToDecimal(123.456, 2);
    NumberUtils.formatCounter(0, 0);
    NumberUtils.formatCounter(10, 20);
    NumberUtils.formatCounter(20, 10);

    NumberUtils.intToString(20.0);

    List<Decimal> a = new List<Decimal>{8500.23, 8500.2, 8500.00, 12345678, 12345678.9, 12345678.90, 12345678.99, 45.1, 45.00, 45.69, null};
    for (Decimal x: a) {
      System.debug(NumberUtils.format(x));
    }
  }

  private static void testDateUtils() {
    Date d = null;
    Datetime dt = null;
    String st = null;
    DateUtils.convertToString(System.today(), DateUtils.ddMMYYYY_hhmmss);
    DateUtils.convertToString(d, DateUtils.ddMMYYYY_hhmmss);
    DateUtils.convertToString(System.now(), DateUtils.ddMMYYYY_hhmmss);
    DateUtils.convertToString(dt, DateUtils.ddMMYYYY_hhmmss);
    DateUtils.formatDate('05/05/2025', DateUtils.ddMMYYYY_hhmmss);
    DateUtils.formatDate(st, DateUtils.ddMMYYYY_hhmmss);
    DateUtils.formatDate(System.today(), DateUtils.ddMMyyyy);
    DateUtils.formatDate(d, DateUtils.ddMMyyyy);
    try {
      DateUtils.formatDate('NOTFORMAT', DateUtils.ddMMYYYY_hhmmss);
    } catch (GenericException e) {
      System.debug('Exception expected, all good!');
    }
    DateUtils.convertToDate('05/05/2025');
    try {
      DateUtils.convertToDate('NOTGORMAT');
    } catch (GenericException e) {
      System.debug('Exception expected, all good!');
    }
    DateUtils.convertToDate(st);
    d = Date.today().addDays(-100);
    // Lelo                 2018-2-16
    DateUtils.getHowManyYears(Date.today(), d);
    DateUtils.getHowManyYears(Date.today(), Date.today());
    DateUtils.getHowManyMonths(Date.today(), d);
    DateUtils.getHowManyMonths(Date.today(), Date.today());
    DateUtils.convertToDate(Date.today().year(), 2, 31);
    // Lelo                 2018-4-24
    DateUtils.getTimeForFileName();
    DateUtils.getTotalTimeInMonths(d, Date.today());
    DateUtils.getTotalTimeInMonths('01/01/2017', '01/01/2018');
    DateUtils.getTotalTimeInMonths(null, '01/01/2018');
    //
    Integer c = DateUtils.getHowManyYears('01/01/2018');

    DateUtils.getDateOfWorkingDay(System.now(), 7);

    DateUtils.formatDate(Datetime.now(), DateUtils.YYYY_MM_DD);
    DateUtils.formatDate(Datetime.now(), null);

    DateUtils.convertToDateToFormat('01/01/2001', DateUtils.YYYY_MM_DD);
    DateUtils.convertToDateToFormat(null, DateUtils.YYYY_MM_DD);
  }

  private static void testVehicleYear() {
    opp = loadData();
    Application_Asset_Detail__c aad = ApplicationService.getAssetDetail(opp.Id);
    Utilities.getVehicleAgeYears(aad, opp);
    Utilities.getVehicleAgeYears(null, null);
    Utilities.getVehicleYear(null, null);
  }
}