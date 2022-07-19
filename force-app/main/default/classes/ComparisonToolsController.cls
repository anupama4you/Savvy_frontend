public without sharing class ComparisonToolsController {

  @AuraEnabled
  public static List<Calculator__c> search(CompToolLenderCalcAbstract.FilterParams params){
    System.debug('searching...');
    System.debug(JSON.serializePretty(params));
    List<Calculator__c> r = new List<Calculator__c>();
    if (params == null) {
      throw new AuraHandledException('Parameters are emtpty');
    }
    // try {
      Set<Id> calcs = new Set<Id>();
      String soql = makeSearchQuery(params);
      System.debug('@@soql: ' + soql);
      // Search rules
      List<AggregateResult> d = Database.query(soql);
      for (AggregateResult a: d) {
        calcs.add((Id)a.get('Calculator__c'));
      }

      if (!calcs.isempty()) {
        r = [
          SELECT 
            Id, Name, Category__c, Comparison_Status__c, Lender__c
          FROM Calculator__c WHERE Id in :calcs
        ];
      }
    // } catch (Exception e) {
    //   throw new AuraHandledException(e.getMessage());
    // }
    return r;
  }

  public static String makeSearchQuery(CompToolLenderCalcAbstract.FilterParams params) {
    if (params == null) return null;
    String soql = 'SELECT Calculator__c FROM Calculator_Rule__c';
    soql += ' WHERE Calculator__r.Comparison_Status__c = \'Active\'';
    soql += ' AND Enabled__c = true';
    if (String.isNotBlank(params.loanType)) {
      soql += ' AND Loan_Type__c includes (\'' + params.loanType + '\')';
    }
    if (String.isNotBlank(params.assetType)) {
      soql += ' AND Asset_Type__c includes (\'' + params.assetType + '\')';
    }
    if (String.isNotBlank(params.purchaseType)) {
      soql += ' AND Purchase_Type__c includes (\'' + params.purchaseType + '\')';
    }
    if (String.isNotBlank(params.employmentType)) {
      soql += ' AND (Employment_Type__c = null OR Employment_Type__c includes (\'' + params.employmentType + '\'))';
    }
    if (String.isNotBlank(params.creditHistory)) {
      soql += ' AND Credit_History__c includes (\'' + params.creditHistory + '\')';
    }
    if (String.isNotBlank(params.residentialStatus)) {
      soql += ' AND (Residential_Status__c = null OR Residential_Status__c includes (\'' + params.residentialStatus + '\'))';
    }
    if (String.isNotBlank(params.creditScore)) {
      soql += ' AND (Credit_Score__c = null OR Credit_Score__c includes (\'' + params.creditScore + '\'))';
    }
    
    soql += ' AND (Loan_Term__c = null OR Loan_Term__c includes (\'' + params.term + '\'))';
    
    if (params.assetAge == 0) {
      soql += ' AND (Asset_Condition__c = null OR Asset_Condition__c includes (\'New\'))';
    } else {
      soql += ' AND (Asset_Condition__c = null OR Asset_Condition__c includes (\'Used\'))';
    }
    
    soql += ' AND (Asset_Age_Min__c = null OR Asset_Age_Min__c <= ' + params.assetAge + ')';
    soql += ' AND (Asset_Age_Max__c = null OR Asset_Age_Max__c >= ' + params.assetAge + ')';

    if (params.price > 0) {
      soql += ' AND (Asset_Price_Min__c = null OR Asset_Price_Min__c <= ' + params.price + ')';
    }

    Integer yet = params.assetAge + (params.term / 12);
    Set<String> ageTerms = new Set<String>();
    if (yet <= 12) {
      ageTerms.add('12 Years');
    }
    if (yet <= 15) {
      ageTerms.add('15 Years');
    }
    if (yet <= 20) {
      ageTerms.add('20 Years');
    } else {
      ageTerms.add('20+');
    }

    if (!ageTerms.isEmpty()) {
      String vals = '';
      for (String v : ageTerms) {
        if (String.isNotBlank(vals)) {
          vals += ',';
        }
        vals += '\'' + v + '\'';
      }
      soql += ' AND (Asset_Age_Term_End__c = null OR Asset_Age_Term_End__c includes(' + vals + '))';
    }
    
    soql += ' GROUP BY Calculator__c';
    return soql;
  }

  @AuraEnabled
  public static CompToolLenderResult calculate(
    Calculator__c calc, CompToolLenderCalcAbstract.FilterParams params
  ){
    System.debug('calculating...');
    System.debug('@@calc: ' + JSON.serializePretty(calc));
    System.debug('@@params: ' + JSON.serializePretty(params));
    CompToolLenderCalc c = makeCompToolCalculator(calc, params);
    CompToolLenderResult r = null;
    if (c != null) {
      r = c.calculate();
    }
    if (r == null) {
      r = new CompToolLenderResult();
    }
    return r;
  }

  public static CompToolLenderCalc makeCompToolCalculator(
    Calculator__c calc, 
    CompToolLenderCalcAbstract.FilterParams params
  ) {
    if (calc != null && params != null) {
      if ('AMMF'.equals(calc.Name) || 'Yamaha Marine'.equals(calc.Name)) {
        // calc.Name = 'Yamaha Marine';
        return new CompToolAmmfCalc(calc, params);
      } else if ('AFS Commercial'.equals(calc.Name)) {
        return new CompToolAFSCommercialCalc(calc, params);
      } else if ('AFS Consumer'.equals(calc.Name)) {
        return new CompToolAFSConsumerCalc(calc, params);
      } else if ('ANZ Commercial'.equals(calc.Name)) {
        return new CompToolAnzCommCalc(calc, params);
      } else if ('ANZ Others'.equals(calc.Name)) {
        return new CompToolAnzOthersCalc(calc, params);
      } else if ('BOQ'.equals(calc.Name)) {
        return new CompToolBoqCalc(calc, params);
      } else if ('BOQ Commercial'.equals(calc.Name)) {
        return new CompToolBoqCommCalc(calc, params);
      } else if ('Finance One'.equals(calc.Name)) {
        return new CompToolFinanceOneCalc(calc, params);
      } else if ('Finance One Commercial'.equals(calc.Name)) {
        return new CompToolFinanceOneCommCalc(calc, params);
      } else if ('Firstmac'.equals(calc.Name)) {
        return new CompToolFirstmacCalc(calc, params);
      } else if ('Green Light'.equals(calc.Name)) {
        return new CompToolGreenLightCalc(calc, params);
      } else if ('Latitude'.equals(calc.Name)) {
        return new CompToolLatitudeCalc(calc, params);
      } else if ('Latitude PL'.equals(calc.Name) || 'Latitude Personal Loan'.equals(calc.Name)) {
        calc.Name = 'Latitude Personal Loan';
        return new CompToolLatitudePLCalc(calc, params);
      } else if ('Liberty'.equals(calc.Name) || 'Liberty Drive'.equals(calc.Name)) {
        calc.Name = 'Liberty Drive';
        return new CompToolLibertyCalc(calc, params);
      } else if ('Liberty Commercial'.equals(calc.Name)) {
        return new CompToolLibertyCommCalc(calc, params);
      } else if ('Liberty Leisure'.equals(calc.Name)) {
        return new CompToolLibertyLeisureCalc(calc, params);
      } else if ('Macquarie Commercial'.equals(calc.Name)) {
        return new CompToolMacquarieCommercialCalc(calc, params);
      } else if ('Macquarie Consumer'.equals(calc.Name)) {
        return new CompToolMacquarieConsumerCalc(calc, params);
      } else if ('Metro'.equals(calc.Name)) {
        return new CompToolMetroCalc(calc, params);
      } else if ('Money3'.equals(calc.Name)) {
        return new CompToolMoney3Calc(calc, params);
      } else if ('Money Place'.equals(calc.Name)) {
        return new CompToolMoneyPlaceCalc(calc, params);
      } else if ('Now Finance'.equals(calc.Name)) {
        return new CompToolNowFinanceCalc(calc, params);
      } else if ('Pepper Commercial'.equals(calc.Name)) {
        return new CompToolPepperCommCalc(calc, params);
      } else if ('Pepper Leisure'.equals(calc.Name)) {
        return new CompToolPepperLeisureCalc(calc, params);
      } else if ('Pepper MV'.equals(calc.Name)) {
        return new CompToolPepperMVCalc(calc, params);
      } else if ('Pepper PL'.equals(calc.Name)) {
        return new CompToolPepperPLCalc(calc, params);
      } else if ('Plenti'.equals(calc.Name)) {
        return new CompToolPlentiCalc(calc, params);
      } else if ('Plenti Commercial'.equals(calc.Name)) {
        return new CompToolPlentiCommCalc(calc, params);
      } else if ('Plenti PL'.equals(calc.Name)) {
        return new CompToolPlentiPLCalc(calc, params);
      } else if ('Wisr PL'.equals(calc.Name)) {
        return new CompToolWisrPLCalc(calc, params);
      } else if ('Wisr VL'.equals(calc.Name)) {
        return new CompToolWisrVLCalc(calc, params);
      }
    }
    return null;
  }

}