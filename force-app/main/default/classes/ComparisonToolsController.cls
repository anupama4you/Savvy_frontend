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
            Id, Name, Category__c, Comparison_Status__c, 
            Lender__c, Break_Costs__c, Document_Id__c
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

    if ('Business'.equals(params.loanType)) {
      soql += ' AND GST_Registered__c includes (\'' + params.gstRegistered + '\')';
      soql += ' AND ABN_Length__c includes (\'' + params.abnLength + '\')';
    }

    if (String.isNotBlank(params.residentialStatus)) {
      soql += ' AND (Residential_Status__c = null OR Residential_Status__c includes (\'' + params.residentialStatus + '\'))';
    }
    if (String.isNotBlank(params.creditScore)) {
      soql += ' AND (Credit_Score__c = null OR Credit_Score__c includes (\'' + params.creditScore + '\'))';
    }
    if (String.isNotBlank(params.hasVerifiableCredit)) {
      soql += ' AND (Current_verifiable_credit__c = null OR Current_verifiable_credit__c includes (\'' + params.hasVerifiableCredit + '\'))';
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
      soql += ' AND (Asset_Price_Max__c = null OR Asset_Price_Max__c >= ' + params.price + ')';

      Decimal p = params.deposit > 0.00? params.deposit : 0.00;
      p = p / params.price * 100.0;

      soql += ' AND (Deposit_Min__c = null OR Deposit_Min__c <= ' + p + ')';
      soql += ' AND (Deposit_Max__c = null OR Deposit_Max__c >= ' + p + ')';

      p = params.residual > 0.00? params.residual : 0.00;
      p = p / params.price * 100.0;

      soql += ' AND (Residual_Maximum__c = null OR Residual_Maximum__c >= ' + p + ')';
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

    // Paydays
    if (String.isNotBlank(params.paydays)) {
      soql += ' AND (Paydays__c = null OR Paydays__c includes (\'' + params.paydays + '\'))';
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
      if ('Affordable'.equals(calc.Name)) {
        return new CompToolAffordableCalc(calc, params);
      } else if ('AMMF'.equals(calc.Name) || 'Yamaha Marine'.equals(calc.Name)) {
        // calc.Name = 'Yamaha Marine';
        return new CompToolAmmfCalc(calc, params);
      } else if ('AFS Commercial'.equals(calc.Name)) {
        return new CompToolAFSCommercialCalc(calc, params);
      } else if ('AFS Consumer'.equals(calc.Name)) {
        return new CompToolAFSConsumerCalc(calc, params);
      } else if ('Angle Finance'.equals(calc.Name)) {
        return new CompToolAngleCalc(calc, params);
      } else if ('ANZ Commercial'.equals(calc.Name)) {
        return new CompToolAnzCommCalc(calc, params);
      } else if ('ANZ Others'.equals(calc.Name)) {
        return new CompToolAnzOthersCalc(calc, params);
      } else if ('APF'.equals(calc.Name)) {
        return new CompToolApfCalc(calc, params);
      } else if ('Azora Consumer'.equals(calc.Name)) {
        return new CompToolAzoraCalc(calc, params);
      } else if ('BOQ'.equals(calc.Name)) {
        return new CompToolBoqCalc(calc, params);
      } else if ('BOQ Commercial'.equals(calc.Name)) {
        return new CompToolBoqCommCalc(calc, params);
      } else if ('CarStart'.equals(calc.Name)) {
        return new CompToolCarStartCalc(calc, params);
      } else if ('Commercial Equity Group'.equals(calc.Name)) {
        return new CompToolCommEquityGroupCalc(calc, params);
      } else if ('Finance One'.equals(calc.Name)) {
        return new CompToolFinanceOneCalc(calc, params);
      } else if ('Finance One Commercial'.equals(calc.Name)) {
        return new CompToolFinanceOneCommCalc(calc, params);
      } else if ('Firstmac'.equals(calc.Name)) {
        return new CompToolFirstmacCalc(calc, params);
      } else if ('Green Light'.equals(calc.Name)) {
        return new CompToolGreenLightCalc(calc, params);
      } else if ('Group and General'.equals(calc.Name)) {
        return new CompToolGroupAndGeneralCalc(calc, params);
      } else if ('Grow Asset'.equals(calc.Name)) {
        return new CompToolGrowAssetCalc(calc, params);
      } else if ('Grow Business Loan'.equals(calc.Name)) {
        return new CompToolGrowBusinessCalc(calc, params);
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
      } else if ('Morris'.equals(calc.Name)) {
        return new CompToolMorrisCalc(calc, params);
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
      } else if ('Selfco'.equals(calc.Name)) {
        return new CompToolSelfcoCalc(calc, params);
      } else if ('Shift Asset'.equals(calc.Name)) {
        return new CompToolShiftAssetCalc(calc, params);
      } else if ('Shift ODR'.equals(calc.Name)) {
        return new CompToolShiftOdrCalc(calc, params);
      } else if ('Silver Chef'.equals(calc.Name)) {
        return new CompToolSilverChefCalc(calc, params);
      } else if ('Society One'.equals(calc.Name)) {
        return new CompToolSocietyOneCalc(calc, params);
      } else if ('UME Loans'.equals(calc.Name)) {
        return new CompToolUmeCalc(calc, params);
      } else if ('Westpac'.equals(calc.Name)) {
        return new CompToolWestpacCalc(calc, params);
      } else if ('Wisr PL'.equals(calc.Name)) {
        return new CompToolWisrPLCalc(calc, params);
      } else if ('Wisr VL'.equals(calc.Name)) {
        return new CompToolWisrVLCalc(calc, params);
      }
    }
    return null;
  }

  @AuraEnabled
  public static CompToolLenderCalcAbstract.FilterParams getInitialParamsById(Id oppId) {
    System.debug('@@getInitialParams: ' + oppId);
    if (String.isBlank(oppId)) {
      throw new GenericException('Record Id not provided');
    }
    
    List<Custom_Opportunity__c> d = [
      SELECT
        Application__c, Lead__c,
        Application__r.Type_of_Asset__c,
        Application__r.Loan_For__c,
        Application__r.Application_Type__c,
        Application__r.Mode_of_Employment_1__c,
        Application__r.Date_Started_1__c,
        Application__r.Vehicle_Year__c,
        Application__r.Length_of_Term__c,
        Application__r.Current_Residence_Status_1__c,
        Application__r.Purchase_Price__c,
        Application__r.Finance_Amount__c,
        Lead__r.Credit_History__c,
        Lead__r.Finance_Amount__c,
        Lead__r.Loan_Type__c,
        Lead__r.Loan_For__c,
        Lead__r.Employment_Status__c,
        Lead__r.Property_Owner__c,
        Lead__r.Vehicle_Year__c,
        Lead__r.Length_of_Term__c
      FROM Custom_Opportunity__c
      WHERE Id = :oppId
    ];

    CompToolLenderCalcAbstract.FilterParams r = new CompToolLenderCalcAbstract.FilterParams(false);
    return !d.isEmpty() ? getInitialParams(d.get(0)) : r;

  }

  public static CompToolLenderCalcAbstract.FilterParams getInitialParams(Custom_Opportunity__c opp) {
    CompToolLenderCalcAbstract.FilterParams r = new CompToolLenderCalcAbstract.FilterParams(false);
    if (opp != null) {
      Boolean hasApp = String.isNotBlank(opp.Application__c);
      Boolean hasLead = String.isNotBlank(opp.Lead__c);
      // Application
      if (hasApp) {
        Application__c app = opp.Application__r;
        
        // Loan Type
        if (String.isNotBlank(app.Application_Type__c)) {
          r.loanType = app.Application_Type__c;
        }

        if ('Personal'.equals(r.loanType)) {
          // Asset Type
          String v = String.isNotBlank(app.Type_of_Asset__c) 
          ? app.Type_of_Asset__c : null;
          
          if ('Car'.equals(v)) {
            r.assetType = 'Car';
          } else if ('Bike'.equals(v)) {
            r.assetType = 'Motorbike';
          } else if ('Caravan'.equals(v)) {
            r.assetType = 'Caravan';
          } else if ('Truck'.equals(v)) {
            r.assetType = 'Truck';
          } else if ('Boat'.equals(v) ||  'JetSki'.equals(v)) {
            r.assetType = 'Boat';
          } else {
            r.assetType = getCompAssetType(r.loanType, v, app.Loan_For__c);
          }
          
          // Employment
          if ('Full Time'.equals(app.Mode_of_Employment_1__c)) {
            r.employmentType = 'Full-Time';
          } else if ('Part Time'.equals(app.Mode_of_Employment_1__c)) {
            r.employmentType = 'Permanent Part-Time';
          } else if ('Casual'.equals(app.Mode_of_Employment_1__c)) {
            Integer m = FieldValidationsHelper.getMonthsBetween(app.Date_Started_1__c);
            if (m != null) {
              if (m < 6) {
                r.employmentType = 'Casual < 6 months';        
              } else if (m < 12) {
                r.employmentType = 'Casual < 12 months';        
              } else {
                r.employmentType = 'Casual > 12 months';        
              }
            }
          }
        } else {
          r.employmentType = 'Self-Employed';
          r.assetType = getCompAssetType(r.loanType, app.Type_of_Asset__c, app.Loan_For__c);
        }

        // Asset Age
        if (String.isNotBlank(app.Vehicle_Year__c) && app.Vehicle_Year__c.isNumeric()) {
          Integer cy = Date.today().year();
          Integer ay = Integer.valueOf(app.Vehicle_Year__c);
          r.assetAge = cy - ay;
        }

        // Term
        if (app.Length_of_Term__c > 0) {
          r.term = Integer.valueOf(app.Length_of_Term__c) * 12;
        }

        // Residential Status
        if (
          'Own Outright'.equals(app.Current_Residence_Status_1__c) || 
          'Mortgage'.equals(app.Current_Residence_Status_1__c)
        ) {
          r.residentialStatus = 'Property Owner';
        } else if (
          'Renting(Agent)'.equals(app.Current_Residence_Status_1__c) ||
          'Renting(Private)'.equals(app.Current_Residence_Status_1__c)
        ) {
          r.residentialStatus = 'Renting';
        } else {
          r.residentialStatus = 'Boarding';
        }

        // Asset Price
        if (app.Purchase_Price__c > 0) {
          r.price = app.Purchase_Price__c;
        }

        // Deposit
        if (app.Finance_Amount__c > 0 && app.Finance_Amount__c < app.Purchase_Price__c) {
          r.deposit = app.Purchase_Price__c - app.Finance_Amount__c;
        }

        //Current payday loan in the last 6 months?
        List<Application_Loan__c> loans = ApplicationService.getApplicationLoans(opp.Application__c);
        if (loans != null && !loans.isEmpty()) {
          Integer paydays = 0;
          for (Application_Loan__c a : loans) {
            if ('Payday Loan'.equals(a.Type__c)) {
              paydays++;
            }
          }
          if (paydays > 0) {
            r.paydays = paydays > 5? '5' : String.valueOf(paydays);
          }
        }
      }

      if (hasLead) {
        Lead__c lead = opp.Lead__r;
        // Credit History
        if (
          String.isNotBlank(Lead.Credit_History__c) &&
          !'Excellent'.equals(Lead.Credit_History__c) &&
          !'Average'.equals(Lead.Credit_History__c)
        ) {
          r.creditHistory = 'Credit Issues';
        }

        // Price
        if (!(r.price > 0)) {
          r.price = lead.Finance_Amount__c;
        }

        // Loan type
        if (String.isBlank(r.loanType)) {
          r.loanType = 'Personal';
          if (
            'Commercial Loan'.equals(lead.Loan_Type__c) ||
            'Chattel Mortgage'.equals(lead.Loan_Type__c)
          ) {
            r.loanType = 'Business';
          }
        }

        if (String.isBlank(r.assetType)) {
          // Asset Type
          r.assetType = getCompAssetType(
            r.loanType,
            lead.Loan_Type__c,
            lead.Loan_For__c
          );

        }

        // Employment
        // if (!'Business'.equals(r.loanType) && String.isBlank(r.employmentType)) {
        //   if ('Employed'.equals(lead.Employment_Status__c)) {
        //     r.employmentType = 'Full-Time';
        //   } else if ('Self employed'.equals(lead.Employment_Status__c)) {
        //     r.employmentType = 'Self-Employed';
        //   }
        // }

        // Residential
        if (String.isBlank(r.residentialStatus)) {
          if ('Yes'.equals(lead.Property_Owner__c)) {
            r.residentialStatus = 'Property Owner';
          } else {
            r.residentialStatus = 'Renting';
          }
        }

        // Term
        if (r.term == null && lead.Length_of_Term__c > 0) {
          r.term = Integer.valueOf(lead.Length_of_Term__c) * 12;
        }

        // Asset Age
        if (
          r.assetAge == null && 
          String.isNotBlank(lead.Vehicle_Year__c) && 
          lead.Vehicle_Year__c.isNumeric()
        ) {
          Integer cy = Date.today().year();
          Integer ay = Integer.valueOf(lead.Vehicle_Year__c);
          r.assetAge = cy - ay;
        }

      }

    }

    return r;
  }

  public static String getCompAssetType(String loanType, String assetType, String loanFor) {
    String r = null;
    if (
      'Car'.equals(assetType) ||
      'Car Loan'.equals(assetType) ||
      'Bad Credit Car Loan'.equals(assetType) ||
      'Car'.equals(loanFor) ||
      'Taxi'.equals(loanFor) ||
      'Taxi Finance'.equals(loanFor)
    ) {
      r = 'Business'.equals(loanType) ? 'Cars' : 'Car';
    } else if (
      'Boat'.equals(assetType) ||
      'Boat'.equals(loanFor) ||
      'JetSki'.equals(loanFor)
    ) {
      r = 'Business'.equals(loanType) ? r : 'Boat';
    } else if (
      'Bike'.equals(assetType) ||
      'Bike'.equals(loanFor)
    ) {
      r = 'Business'.equals(loanType) ? r : 'Motorbike';
    } else if (
      'Bus'.equals(loanFor) ||
      'Bus Finance'.equals(loanFor)
    ) {
      r = 'Business'.equals(loanType) ? 'Buses' : r;
    } else if (
      'Caravan'.equals(assetType) ||
      'Caravan'.equals(loanFor)
    ) {
      r = 'Business'.equals(loanType) ? 'Caravans' : 'Caravan';
    } else if (
      'Truck'.equals(assetType) ||
      (
        String.isNotBlank(loanFor) &&
        (
          loanFor.containsIgnoreCase('Truck') ||
          loanFor.containsIgnoreCase('Lorries') ||
          loanFor.containsIgnoreCase('Trailers')
        )
      )
    ) {
      r = 'Business'.equals(loanType) ? 'Trucks' : 'Truck';
    } else if (
      'Personal'.equals(loanFor) ||
      'Personal Loan'.equals(loanFor)
    ) {
      r = 'Business'.equals(loanType) ? r : 'Personal';
    } else if (
      String.isNotBlank(loanFor) &&
      loanFor.containsIgnoreCase('Solar')
    ) {
      r = 'Business'.equals(loanType) ? 'Solar' : r;
    } else if (
      String.isNotBlank(loanFor) &&
      loanFor.containsIgnoreCase('Printing')
    ) {
      r = 'Business'.equals(loanType) ? 'Printing' : r;
    } else if ('IT - Software Finance'.equals(loanFor)) {
      r = 'Business'.equals(loanType) ? 'Software' : r;
    } else if (
      'IT - Hardware Finance'.equals(loanFor) ||
      'Computer Finance'.equals(loanFor) ||
      'Technology'.equals(loanFor) ||
      'Technology Finance'.equals(loanFor)
    ) {
      r = 'Business'.equals(loanType) ? 'Information IT' : r;
    } else if (
      'Telephone System'.equals(loanFor) ||
      'Telephone System Finance'.equals(loanFor)
    ) {
      r = 'Business'.equals(loanType) ? 'Telephony' : r;
    } else if (
      'Commercial Utilities and Van'.equals(loanFor) ||
      'Commercial Utilities and Van Finance'.equals(loanFor)
    ) {
      r = 'Business'.equals(loanType) ? 'Vans' : r;
    } else if (
      String.isNotBlank(loanFor) &&
      (
        loanFor.containsIgnoreCase('Yellows') ||
        loanFor.containsIgnoreCase('Bulldozer')
      )
    ) {
      r = 'Business'.equals(loanType) ? 'Yellow Goods' : r;
    } else if (
      String.isNotBlank(loanFor) &&
      (
        loanFor.containsIgnoreCase('Medical') ||
        loanFor.containsIgnoreCase('Dental') 
      )
    ) {
      r = 'Business'.equals(loanType) ? 'Medical' : r;
    } else if (
      String.isNotBlank(loanFor) &&
      (
        loanFor.containsIgnoreCase('Office') ||
        loanFor.containsIgnoreCase('Point of Sale')
      )
    ) {
      r = 'Business'.equals(loanType) ? 'Office Furniture' : r;
    } else if (
      'Equipment'.equals(assetType) ||
      String.isNotBlank(loanFor) &&
      loanFor.containsIgnoreCase('Equipment')
    ) {
      // r = 'Business'.equals(loanType) ? 'Equipment' : r;
      r = 'Equipment';
    }
    System.debug('@@getCompAssetType: ' + loanType + ' > ' + assetType + ' > ' + loanFor + ' > ' + r);
    return r;
  }

}