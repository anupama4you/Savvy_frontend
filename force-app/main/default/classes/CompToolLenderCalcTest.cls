@IsTest(SeeAllData=true)
public class CompToolLenderCalcTest {
  
  public static List<String> residencyValues = new List<String>{
    'Property Owner', 'Renting', 'Boarding'
  };

  public static List<String> creditHistoryValues = new List<String>{
    'Good', 'Credit Issues'
  };

  public static List<String> assetTypeValues = new List<String>{
    'Car', 'Motorbike', 'Boat', 'Caravan', 'Truck', 'Personal'
  };

  public static List<String> businessAssetTypeValues = new List<String>{
    'Cars', 'Buses', 'Caravans', 'Trucks', 'Vans', 'Yellow Goods',
    'Equipment', 'Medical', 'Printing', 'Gym Equipment', 
    'Information IT', 'Office Furniture', 'Software', 'Solar', 
    'Telephony'
  };

  public static List<String> creditScoreValues = new List<String>{
    '853 - 1200', '735 - 852', '661 - 734', '500 - 660', '0 - 499'
  };

  @IsTest
  static void calculateAffordable() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Affordable');
    ComparisonToolsController.calculate(c, p);
    List<Integer> csValues = new List<Integer>{ 500, 400, 300};
    for (Integer cs : csValues) {
      p.realCreditScore = cs;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateAfsCommercial() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('AFS Commercial');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 7, 10, 20, 30, 40
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Types
    List<String> assetTypes = new List<String>{
      'Car', 'Motorbike', 'Boat', 'Caravan'
    };
    for (String assetType : assetTypes) {
      p.assetType = assetType;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateAfsConsumer() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('AFS Consumer');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 7, 10, 20, 30, 40
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Types
    List<String> assetTypes = new List<String>{
      'Car', 'Motorbike', 'Boat', 'Caravan'
    };
    for (String assetType : assetTypes) {
      p.assetType = assetType;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateAmmf() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('AMMF');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 7, 10
    };
    p.residentialStatus = residencyValues.get(1);
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateAngle() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Angle Finance');
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateAnzCommercial() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('ANZ Commercial');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateAnzOthers() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('ANZ Others');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateApf() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('APF');
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateAzora() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Azora Consumer');
    // Credit Score
    List<Integer> csValues = new List<Integer>{ 832, 725, 621, 509, 400, 300};
    for (Integer cs : csValues) {
      p.realCreditScore = cs;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateBoq() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('BOQ');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateBoqComm() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('BOQ Commercial');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset types
    for (String assetType : businessAssetTypeValues) {
      p.assetType = assetType;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateCarStart() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('CarStart');
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateCommEquityGroup() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Commercial Equity Group');
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateFinanceOne() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Finance One');
    ComparisonToolsController.calculate(c, p);
    
    Test.stopTest();
  }

  @IsTest
  static void calculateFinanceOneComm() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Finance One Commercial');
    ComparisonToolsController.calculate(c, p);
    
    Test.stopTest();
  }

  @IsTest
  static void calculateFirstmac() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Firstmac');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 7, 10
    };
    p.residentialStatus = residencyValues.get(1);
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateGreenLight() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Green Light');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateGroupAndGeneral() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Group and General');
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateGrowAsset() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Grow Asset');
    for (String a : assetTypeValues) {
      // Credit Score
      for (String creditScore : creditScoreValues) {
        p.assetType = a;
        p.creditScore = creditScore;
        ComparisonToolsController.calculate(c, p);
      }
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateGrowBusiness() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Grow Business Loan');
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateLatitude() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Latitude');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }

    // Badcredit
    p.assetType = 'Caravan';
    p.creditHistory = creditHistoryValues.get(creditHistoryValues.size()-1);
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateLatitudePL() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Latitude PL');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }

    // Badcredit
    p.assetType = 'Caravan';
    p.creditHistory = creditHistoryValues.get(creditHistoryValues.size()-1);
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateLiberty() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Liberty');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 4, 9, 20
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    // Credit history
    p.creditHistory = creditHistoryValues.get(creditHistoryValues.size()-1);
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }  

  @IsTest
  static void calculateLibertyCommercial() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Liberty Commercial');
    // Residency
    for (String residency : residencyValues) {
      for (String ch : creditHistoryValues) {
        p.residentialStatus = residency;
        p.creditHistory = ch;
        ComparisonToolsController.calculate(c, p);
      }
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 4, 9, 20
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    
    Test.stopTest();
  }

  @IsTest
  static void calculateLibertyLeisure() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Liberty Leisure');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 4, 9, 20
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    // Credit history
    p.creditHistory = creditHistoryValues.get(creditHistoryValues.size()-1);
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  @IsTest
  static void calculateMacquarieCommercial() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Macquarie Commercial');
    // Asset Types
    for (String a : assetTypeValues) {
      p.assetType = a;
      ComparisonToolsController.calculate(c, p);
    }
    
    Test.stopTest();
  }

  @IsTest
  static void calculateMacquarieConsumer() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Macquarie Consumer');
    ComparisonToolsController.calculate(c, p);
    
    Test.stopTest();
  }

  @IsTest
  static void calculateMetro() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Metro');
    ComparisonToolsController.calculate(c, p);
    
    Test.stopTest();
  }

  @IsTest
  static void calculateMoney3() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Money3');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateMoneyPlace() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Money Place');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateMorris() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Morris');
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateNowFinance() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Now Finance');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculatePepperCommercial() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Pepper Commercial');
    // Residency + Credit history
    for (String residency : residencyValues) {
      for (String ch : creditHistoryValues) {
        p.residentialStatus = residency;
        p.creditHistory = ch;
        ComparisonToolsController.calculate(c, p);
      }
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 5, 9
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    // Asset Type
    for (String assetType: businessAssetTypeValues) {
      p.assetType = assetType;
      ComparisonToolsController.calculate(c, p);
    }
    p.assetType = 'Truck';
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  @IsTest
  static void calculatePepperLeisure() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Pepper Leisure');
    // Residency + Credit history
    for (String residency : residencyValues) {
      for (String ch : creditHistoryValues) {
        p.residentialStatus = residency;
        p.creditHistory = ch;
        ComparisonToolsController.calculate(c, p);
      }
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 5, 9, 12
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    
    p.assetType = 'Caravan';
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  @IsTest
  static void calculatePepperMV() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Pepper MV');
    // Residency + Credit history
    for (String residency : residencyValues) {
      for (String ch : creditHistoryValues) {
        p.residentialStatus = residency;
        p.creditHistory = ch;
        ComparisonToolsController.calculate(c, p);
      }
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 5, 9, 12
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    
    p.assetType = 'Caravan';
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  @IsTest
  static void calculatePepperPL() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Pepper PL');
    // Residency + Credit history
    for (String residency : residencyValues) {
      for (String ch : creditHistoryValues) {
        p.residentialStatus = residency;
        p.creditHistory = ch;
        ComparisonToolsController.calculate(c, p);
      }
    }
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 5, 9, 12
    };
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }
    
    p.assetType = 'Caravan';
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  @IsTest
  static void calculatePlenti() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Plenti');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculatePlentiCommercial() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Plenti Commercial');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculatePlentiPL() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Plenti PL');
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }
    Test.stopTest();
  }

  @IsTest
  static void calculateSelfco() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Selfco');
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateShiftAsset() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Shift Asset');
    // Asset Age
    List<Integer> ageValues = new List<Integer>{
      0, 10, 12, 20
    };
    p.purchaseType = 'Refinance';
    for (Integer age : ageValues) {
      p.assetAge = age;
      ComparisonToolsController.calculate(c, p);
    }    
    Test.stopTest();
  }

  @IsTest
  static void calculateShiftOdr() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Shift ODR');
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateSilverChef() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Silver Chef');
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateSocietyOne() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Society One');
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateUme() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('UME Loans');
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateWestpac() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.loanType = 'Business';
    Test.startTest();
    Calculator__c c = getCalculator('Westpac');
    ComparisonToolsController.calculate(c, p);
    Test.stopTest();
  }

  @IsTest
  static void calculateWisrVL() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Wisr VL');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }

    // Commission rate
    p.term = 36;
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  @IsTest
  static void calculateWisrPL() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    Calculator__c c = getCalculator('Wisr PL');
    // Residency
    for (String residency : residencyValues) {
      p.residentialStatus = residency;
      ComparisonToolsController.calculate(c, p);
    }
    // Credit History
    for (String ch : creditHistoryValues) {
      p.creditHistory = ch;
      ComparisonToolsController.calculate(c, p);
    }

    // Commission rate
    p.term = 36;
    ComparisonToolsController.calculate(c, p);

    Test.stopTest();
  }

  @IsTest
  static void lenderAbstract() {
    Test.startTest();
    CompToolLenderCalcAbstract.FilterParams param = new CompToolLenderCalcAbstract.FilterParams();
    param.assetCondition = null;
    param.hasPayday = null;
    param.hasVerifiableCredit = null;
    param.jobsLast3Years = null;
    param.hasEnquiries = null;
    param.verifiableSavings = null;
    param.ltv = null;
    param.customValue2 = null;
    param.customClientRate = null;
    param.customDof = null;
    param.hasPayday = null;
    param.hasPayday = null;
    param.hasPayday = null;
    param.hasPayday = null;

    param.purchaseType = 'Private';
    param.getPrivateSales();

    param.abnLength = '3';
    param.getAbnLengthValue();

    Test.stopTest();
  }

  private static Calculator__c getCalculator(String name) {
    return new Calculator__c(Name = name);
  }

  public static CompToolLenderCalcAbstract.FilterParams buildFilterParameter() {
    CompToolLenderCalcAbstract.FilterParams f = new CompToolLenderCalcAbstract.FilterParams();
    f.price = 20000;
    return f;
  }

}