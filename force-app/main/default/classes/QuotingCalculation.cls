public without sharing class QuotingCalculation {
  public static final String CALC_QUOTING = 'Q';
  public static final String CALC_SIMPLE = 'S';
  public static final String CALC_PROTECTED = 'PPY';
  public static final String PRO_FULLY = 'PF';
  public static final String PRO_STANDARD = 'PS';
  public static final String PRO_BASIC = 'PB';
  public static final String PRO_CUSTOM = 'PC';
  public static final String PRO_UNPROTECTED = 'UP';

  private static List<Protected_Payment_Settings__c> protectedRatesList;
  private static Map<String, RateSetterRate__c> rateSetterRatesMap;
  private static Map<String, Map<String, List<GreenLightRates__c>>> greenLightRatesMap;
  private static List<Wisr_Fee_Rate__c> wisrRates;
  private static Map<String, MetroPlanOption__c> metroPlanOptions;
  private static Map<String, List<MacquarieConsumerRatesv2__c>> macquarieRatesMap;
  private static Map<String, Lenders__c> lenderSettingsMap;

  private static Map<String, Map<String, BasicLenderRates__c>> basicRatesMap;

  public static Application_Quoting_Result__c calculate(CalcParam param) {
    Application_Quoting_Result__c r = null;
    
    // System.debug('QuotingCalculation.calculate...');
    if (param != null) {
      // System.debug('Lender Calculation >> ' + param.lender);
      if (
        'ANZ Consumer'.equals(param.lender) ||
        'ANZ Commercial'.equals(param.lender)
      ) {
        r = calculateANZ(param, false);
      } else if ('ANZ Others'.equals(param.lender)) {
        r = calculateANZ(param, true);
      } else if (
        'Shift Asset'.equals(param.lender) 
        || 'Shift ODR'.equals(param.lender) 
        || 'Grow Asset'.equals(param.lender)
        || 'Grow Business Loan'.equals(param.lender)
        || 'Morris'.equals(param.lender)
        || 'Selfco'.equals(param.lender)
        || 'Silver Chef'.equals(param.lender)
        || 'Capital Finance'.equals(param.lender)
        || 'Fleet Partners'.equals(param.lender)
        || 'Commercial Equity Group'.equals(param.lender)
        || 'Group and General'.equals(param.lender)
      ) {
        r = calculateGCA(param);
      } else if (
        'Pepper MV'.equals(param.lender) ||
        'Pepper Leisure'.equals(param.lender)
      ) {
        // System.debug('param.productLoanType: ' + param.productLoanType);
        // System.debug('param.customerProfile: ' + param.customerProfile);
        // System.debug('param.vehicleYear: ' + param.vehicleYear);
        if (!'Consumer Loan'.equals(param.productLoanType)) {
          r = calculatePepper(param);
        } else {
          r = calculatePepperV2(param);
        }
      } else if ('Pepper Commercial'.equals(param.lender)) {
        // if (
        //   'WHEELS'.equals(param.customerProfile) ||
        //   'OTHER'.equals(param.customerProfile)
        // ) {
        //   r = calculateBrokerageGeneric(param);
        // } else {
        //   r = calculatePepper(param);
        // }
        r = calculatePepperV2(param);
      } else if (
        'Pepper 5Oh'.equals(param.lender) ||
        'Pepper Summer'.equals(param.lender)
      ) {
        r = calculatePepper(param);
      } else if (
        'Liberty Drive'.equals(param.lender) ||
        'Liberty Leisure'.equals(param.lender) ||
        'Liberty Options'.equals(param.lender) ||
        'Liberty Commercial'.equals(param.lender)
      ) {
        r = calculateLiberty(param);
      } else if (
        'Macquarie Consumer'.equals(param.lender) ||
        'Macquarie Commercial'.equals(param.lender)
      ) {
        r = calculateMacquarie(param);
      } else if (
        'Finance One'.equals(param.lender) ||
        'Finance One PL'.equals(param.lender) ||
        'Finance One Business'.equals(param.lender) ||
        'Finance One Commercial'.equals(param.lender)
      ) {
        r = calculateFinanceOne(param);
      } else if (
        'Money3'.equals(param.lender) ||
        'Now Finance'.equals(param.lender) ||
        'RateSetter'.equals(param.lender) ||
        'RateSetter PL'.equals(param.lender) ||
        'Plenti PL'.equals(param.lender) ||
        'Pepper PL'.equals(param.lender) ||
        'Wisr VL'.equals(param.lender) ||
        'CarStart'.equals(param.lender) ||
        'Azora Consumer'.equals(param.lender) ||
        'UME Loans'.equals(param.lender) ||
        'Society One'.equals(param.lender) ||
        'APF'.equals(param.lender)
      ) {
        r = calculateMoney3(param);
      } else if (
        'Metro'.equals(param.lender) ||
        //'Green Light'.equals(param.lender) ||
        'General'.equals(param.lender)
      ) {
        r = calculateBrokerageGeneric(param);
      } else if (
        'AFS Consumer'.equals(param.lender) ||
        'AFS Commercial'.equals(param.lender) ||
        'Latitude'.equals(param.lender) ||
        LatitudePersonalCalculatorExtension.LENDER_QUOTING.equals(
          param.lender
        ) ||
        'BOQ'.equals(param.lender) ||
        'Affordable'.equals(param.lender)
      ) {
        r = calculateCommRate(param);
      } else if (
        'Yamaha Marine'.equals(param.lender) ||
        'Yamaha Motorcycles'.equals(param.lender) ||
        'Yamaha Water'.equals(param.lender) ||
        'AMMF'.equals(param.lender)
      ) {
        r = calculateYamaha(param);
      } else if ('Wisr'.equals(param.lender) || 'Wisr PL'.equals(param.lender)) {
        r = calculateWisr(param);
        // } else if ('Firstmac'.equals(param.lender)) {
        //   r = calculateFirstmac(param);
      } else if ('Green Light'.equals(param.lender)) {
        r = calculateGreenLight(param);
      } else if (MoneyPlaceExtension.LENDER_QUOTING.equals(param.lender)) {
        r = calculateMoneyPlace(param);
      } else if ('BOQ Commercial'.equals(param.lender)) {
        // Girish P
        system.debug('calculating boqcommercial' + param);
        r = calculateBOQCommercial(param);
      } else if ('Firstmac'.equals(param.lender)) {
        r = calculateFirstmac(param);
      } else if ('Plenti Commercial'.equals(param.lender)) {
        r = calculatePlentiCommercial(param);
      } else if ('Westpac'.equals(param.lender)) {
        r = calculateWestpac(param);
      } else if ('Angle Finance'.equals(param.lender)) {
        r = calculateAngleFinance(param);
      }
    }
    return r;
  }

  //ANZ Consumer/Commercial/Others
  private static Application_Quoting_Result__c calculateANZ(
    CalcParam param,
    Boolean hasBrokerage
  ) {
    // System.debug('ANZ Calculation...');

    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();

    // calculate the payment rate based on client rate, which is determined by consultants
    decimal realRate = param.clientRate / 100;
    decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    // calculate the payment rate based on base rate, which is determined by Customer Profile and LTV
    decimal realBaseRate = param.baseRate / 100;
    decimal baseFutureValue = FinancialUtilities.fv(
      realBaseRate / 12,
      12,
      1000
    );
    decimal baseRateValue = FinancialUtilities.rate(
      1000,
      12,
      0,
      baseFutureValue,
      realBaseRate / 12,
      false
    );

    //Lelo                                                                                          2016-07-29
    Decimal realTermToCalcCommision = param.term;
    if (realTermToCalcCommision > 60) {
      realTermToCalcCommision = 60;
    }

    //// System.debug('The calculated base payment is: ' + basePayment + '|' + basePaymentCommission);
    r.Rental__c = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);

    if (hasBrokerage) {
      r.Estimated_Commission__c = (param.getNaf() * param.brokeragePer / 100);
    } else {
      if ('ANZ Consumer'.equals(param.lender)) {
        r.Estimated_Commission__c = getANZConsumerCommission(param);
      } else {
        // calculate the base payment without brokerage
        Decimal basePaymentCommission = FinancialUtilities.pmt(
          param.getNaf(),
          baseRateValue,
          realTermToCalcCommision,
          param.residualValue,
          param.getPaymentTypeBoolean()
        ); //Lelo                  2016-09-01
        // calculate the monthly payment based on client rate
        Decimal rentalCommission = FinancialUtilities.pmt(
          param.getNaf(),
          rate,
          realTermToCalcCommision,
          param.residualValue,
          param.getPaymentTypeBoolean()
        ); //Lelo                  2016-09-01
        //rentalCommission = rentalCommission.setScale(2);
        // calculate the estimated commission
        //estimatedCommission = ((rental * term) - (basePayment * term)) * 0.7 + docFees;               //Lelo                  2016-09-01
        //r.Estimated_Commission__c = ((rentalCommission * realTermToCalcCommision) - (basePaymentCommission * realTermToCalcCommision)) * 0.7 + param.docFees;     //  Original 2017-09-07
        //r.Estimated_Commission__c = ((rentalCommission * realTermToCalcCommision) - (basePaymentCommission * realTermToCalcCommision)) * 1 + param.docFees;       //  Lelo 2017-09-07
        r.Estimated_Commission__c =
          ((rentalCommission * realTermToCalcCommision) -
          (basePaymentCommission * realTermToCalcCommision)) * 1; //  Lelo 2017-10-16
      }
    }
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);

    //calculate the insurance income
    //insuranceIncome = nwcIncome + gapIncome + warrantyIncome + ltiIncome + truckGapIncome + taiIncome +mvIncome + cciIncome;          //Lelo          2017-05-15
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();
    return r;
  }

  public static void saveQuotingResults(
    Id quotationId,
    List<Application_Quoting_Result__c> resultList
  ) {
    //System.debug('saveQuotingResults >> ' + quotationId + '|' + resultList);
    //Reset current results
    delete [
      SELECT Id
      FROM Application_Quoting_Result__c
      WHERE Application_Quoting__c = :quotationId
    ];
    if (resultList != null) {
      List<Application_Quoting_Result__c> d = new List<Application_Quoting_Result__c>();
      for (Application_Quoting_Result__c r : resultList) {
        if (r != null && String.isNotBlank(r.Result_Type__c)) {
          r.Id = null;
          r.Application_Quoting__c = quotationId;
          d.add(r);
        }
      }
      if (!d.isEmpty()) {
        insert d;
      }
    }
  }

  public static List<Application_Quoting_Result__c> getQuotingResultsByQuoId(
    Id quotingId
  ) {
    List<Application_Quoting_Result__c> r = new List<Application_Quoting_Result__c>();
    if (quotingId != null) {
      r = [
        SELECT
          Result_Type__c,
          Weekly_Payment__c,
          Application_Quoting__c,
          DOF__c,
          Estimated_Commission__c,
          Fortnightly_Payment__c,
          Insurance_Income__c,
          Monthly_Payment__c,
          NAF__c,
          Rental__c,
          Total_Commission__c,
          Total_Commission_Gst__c
        FROM Application_Quoting_Result__c
        WHERE Application_Quoting__c = :quotingId
      ];
    }
    return r;
  }

  public static Map<String, Application_Quoting_Result__c> getMapQuotingResultsByQuoId(
    Id quotingId
  ) {
    Map<String, Application_Quoting_Result__c> r = new Map<String, Application_Quoting_Result__c>();
    List<Application_Quoting_Result__c> d = getQuotingResultsByQuoId(quotingId);
    for (Application_Quoting_Result__c a : d) {
      r.put(a.Result_Type__c, a);
    }
    return r;
  }

  // Lelo                 2018-10-12
  private static Application_Quoting_Result__c calculatePepperV2(
    CalcParam param
  ) {
    System.debug(param.lender + ' calculating...');
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();
    // System.debug('NAF: ' + r.NAF__c);

    // calculate the payment rate based on client rate, which is determined by consultants
    decimal realRate = param.clientRate / 100;
    // System.debug('realRate: ' + realRate);
    decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );
    // System.debug('The calculated rate: ' + rate);

    // calculate the payment rate based on base rate, which is determined by Customer Profile and LTV
    decimal realBaseRate = param.baseRate / 100;
    decimal baseFutureValue = FinancialUtilities.fv(
      realBaseRate / 12,
      12,
      1000
    );
    decimal baseRateValue = FinancialUtilities.rate(
      1000,
      12,
      0,
      baseFutureValue,
      realBaseRate / 12,
      false
    );
    // System.debug('The calculated base rate is: ' + baseRateValue);

    // calculate the monthly payment based on client rate
    r.Rental__c = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);
    // System.debug('rental: ' + r.Rental__c);
    // calculate the estimated commission

    Decimal riskGrade = 0;
    if ('COMMERCIAL'.equals(param.customerProfile)) {
      if ('A'.equals(param.clientTier)) {
        riskGrade = 0.65;
      } else if ('B'.equals(param.clientTier)) {
        riskGrade = 0.60;
      } else if ('C'.equals(param.clientTier)) {
        riskGrade = 0.50;
      }
    } else if ('OTHER - Primary'.equals(param.customerProfile) || 'OTHER - 2nd & 3rd'.equals(param.customerProfile)) {
      riskGrade = 0.75;
    } else {
      if ('A'.equals(param.clientTier)) {
        riskGrade = 0.9;
      } else if ('B'.equals(param.clientTier)) {
        riskGrade = 0.85;
      } else if ('C'.equals(param.clientTier)) {
        riskGrade = 0.8;
      }
    }
    Decimal realTermToCalcCommision = param.term;
    if (realTermToCalcCommision > 60) {
      realTermToCalcCommision = 60;
    }

    // calculate the base payment without brokerage
    // Decimal basePaymentCommission = FinancialUtilities.pmt(param.getNaf(), baseRateValue, realTermToCalcCommision, param.residualValue, param.getPaymentTypeBoolean());               //Lelo                  2016-09-01
    Decimal basePaymentCommission = FinancialUtilities.pmt(
      param.getNaf(),
      baseRateValue,
      realTermToCalcCommision,
      0.00,
      param.getPaymentTypeBoolean()
    ); //Lelo                  2021-02-05
    // System.debug('basePaymentCommission: ' + basePaymentCommission + '|' +  param.getNaf());
    // basePaymentCommission = param.getNaf();
    // calculate the monthly payment based on client rate
    // Decimal rentalCommission = FinancialUtilities.pmt(param.getNaf(), rate, realTermToCalcCommision, param.residualValue, param.getPaymentTypeBoolean());                     //Lelo                  2016-09-01
    Decimal rentalCommission = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      realTermToCalcCommision,
      0.00,
      param.getPaymentTypeBoolean()
    ); //Lelo                  2021-02-05
    r.Estimated_Commission__c =
      ((rentalCommission.setScale(2) * realTermToCalcCommision) -
      (basePaymentCommission.setScale(2) * realTermToCalcCommision)) *
      riskGrade; //  Lelo 2017-10-16

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);
    // System.debug('DOF: ' + r.DOF__c);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);
    // System.debug('Monthly Payment: ' + r.Monthly_Payment__c);

    r.recalculateFormulas();

    return r;
  }
  //
  //Lelo                2017-07-24
  private static Application_Quoting_Result__c calculatePepper(
    CalcParam param
  ) {
    System.debug(param.lender + ' calculating...');
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();

    // calculate the payment rate based on client rate, which is determined by consultants
    decimal realRate = param.clientRate / 100;
    decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    // calculate the monthly payment based on client rate
    r.Rental__c = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);
    System.debug('rental: ' + r.Rental__c);
    // calculate the estimated commission

    Decimal commissionRate = 0;
    if (param.term >= 12 && param.term < 24) {
      commissionRate = 0.20;
    } else if (param.term >= 24 && param.term < 36) {
      commissionRate = 0.40;
    } else if (param.term >= 36 && param.term < 48) {
      commissionRate = 0.60;
    } else if (param.term >= 48 && param.term < 60) {
      commissionRate = 0.80;
    } else if (param.term >= 60 && param.term <= 84) {
      commissionRate = 1.00;
    }
    System.debug('Commission rates: ' + param.commRate + '|' + commissionRate);
    r.Estimated_Commission__c =
      r.NAF__c *
      param.commRate /
      100 *
      commissionRate;
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);
    System.debug('Estimated Commission: ' + r.Estimated_Commission__c);

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);
    // System.debug('DOF: ' + r.DOF__c);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);
    // System.debug('Monthly Payment: ' + r.Monthly_Payment__c);

    r.recalculateFormulas();

    return r;
  }

  //Lelo                2017-07-24
  private static Application_Quoting_Result__c calculateLiberty(
    CalcParam param
  ) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'SP';
    r.NAF__c = param.getNaf();

    // calculate the payment rate based on client rate, which is determined by consultants
    decimal realRate = param.clientRate / 100;
    decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );
    // System.debug('The calculated rate is: ' + rate);

    Decimal rentTerm = param.term;
    if (param.residualValue > 0) {
      //rentTerm = rentTerm - 1;      // 2018-08-14
    }

    r.Rental__c = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      rentTerm,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    //System.debug('Rental: ' + r.Rental__c + '|' + param.getNaf() + '|' + rate + '|' + rentTerm + '|' + param.residualValue + '|' + param.getPaymentTypeBoolean());
    r.Rental__c = r.Rental__c.setScale(2);

    // calculate the estimated commission
    Decimal termRate = 0.0;
    // Decimal finalCommRate = 0.0;
    param.commRate = getLibertyCommission(param);
    Decimal commbase = r.NAF__c;
    Decimal commMult = getLibertyMultiplier(param); // Fair Value Multiplier (FMV) 
    Decimal rateDisc = param.clientRate > param.baseRate? param.clientRate - param.baseRate : 0.00;
    Decimal finalCommRate = rateDisc * commMult;

    if ('Liberty Commercial'.equals(param.lender)) {
      r.Estimated_Commission__c = ((finalCommRate/100)*commbase);
      r.Estimated_Commission__c = r.Estimated_Commission__c/1.1;
    } else {
      System.debug('@@Calculator: ' + param.lender);
      termRate = 1.0;
      if (param.term < 60) {
        termRate = 0.60;
      }
      Decimal commDisc = 0;
      
      // rateDisc = (param.baseRate + 2 - param.clientRate);
      rateDisc = param.clientRate > param.baseRate? param.clientRate - param.baseRate : 0.00;
      finalCommRate = rateDisc + param.commRate - 2;

      System.debug('@@ param.clientTier: ' + param.clientTier);
      System.debug('@@ param.baseRate: ' + param.baseRate);
      System.debug('@@ param.clientRate: ' + param.clientRate);
      System.debug('@@ param.commRate: ' + param.commRate);
      System.debug('@@ commMult: ' + commMult);
      System.debug('@@ commbase: ' + commbase);
      System.debug('@@ finalCommRate: ' + finalCommRate);

      if ('Liberty Leisure'.equals(param.lender)) {
        // if ('Caravan'.equals(param.goodsType)) {
        //   commMult = 0;
        //   if ('AAA'.equals(param.clientTier)) {
        //     commMult = rateDisc == 2.0? 0.0 : 1.75;
        //   } else if (
        //     'AA'.equals(param.clientTier) || 'A+'.equals(param.clientTier)
        //   ) {
        //     commMult = 1.5;
        //   }
        //   System.debug('commMult: ' + commMult);
        //   // finalCommRate = (param.commRate - rateDisc);
        //   finalCommRate = (param.commRate - rateDisc) * commMult;
        // }

        // rateDisc = param.clientRate > param.baseRate? param.clientRate - param.baseRate : 0.00;
        // finalCommRate = rateDisc + param.commRate - 2;
        // System.debug('@@ finalCommRate: ' + finalCommRate);
        // r.Estimated_Commission__c = commbase * finalCommRate * termRate / 100;
        commMult = termRate;
        // r.Estimated_Commission__c = commbase * (param.clientRate - param.baseRate) / 100 * termRate;

      // } else {
        // rateDisc = param.clientRate > param.baseRate? ((param.clientRate - param.baseRate)/2.00) : 0.00;
        // rateDisc = param.clientRate > param.baseRate? param.clientRate - param.baseRate : 0.00;
        // finalCommRate = rateDisc + param.commRate - 2;
        // System.debug('@@ rateDisc: ' + rateDisc);
        // System.debug('@@ finalCommRate: ' + finalCommRate);

        // r.Estimated_Commission__c = commbase * finalCommRate * commMult / 100;


        // if ('AAA'.equals(param.clientTier)) {
        //   commDisc = 3.5;
        // } else if (
        //   'AA'.equals(param.clientTier) || 'A+'.equals(param.clientTier)
        // ) {
        //   commDisc = 3.0;
        // } else if (
        //   'A'.equals(param.clientTier) || 'B+'.equals(param.clientTier)
        // ) {
        //   commDisc = 2.5;
        // } else {
        //   commDisc = 2.0;
        // }
        
        // System.debug('@@ commDisc: ' + commDisc);
        // finalCommRate = param.commRate - (commDisc * (rateDisc / 2.0));
      }
      r.Estimated_Commission__c = commbase * finalCommRate * commMult / 100;
      // System.debug('@@ rateDisc: ' + rateDisc);
      // System.debug('@@ finalCommRate: ' + finalCommRate);
      //-- end
      //finalCommRate =  (param.commRate - (param.baseRate + 2 - param.clientRate));

      // r.Estimated_Commission__c = commbase * (param.clientRate - param.baseRate) / 100 * termRate;
    }
    
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);
    System.debug('@@Commission: ' + r.Estimated_Commission__c);

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();

    return r;
  }

  //Lelo                2017-07-26
  private static Application_Quoting_Result__c calculateMacquarie(
    CalcParam param
  ) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();

    // calculate the payment rate based on client rate, which is determined by consultants
    decimal realRate = param.baseRate / 100;
    decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    r.Rental__c = FinancialUtilities.pmt(
      param.amountBasePmt,
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);

    r.Estimated_Commission__c = param.brokeragePer / 100 * param.amountBaseComm;
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();

    return r;
  }

  private static Application_Quoting_Result__c calculateWestpac(
    CalcParam param
  ) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();

    // calculate the payment rate based on client rate, which is determined by consultants
    decimal realRate = param.baseRate / 100;
    decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    r.Rental__c = FinancialUtilities.pmt(
      param.amountBasePmt,
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);

    r.Estimated_Commission__c = param.brokeragePer / 100 * param.amountBaseComm;
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();

    return r;
  }

  private static Application_Quoting_Result__c calculatePlentiCommercial(
    CalcParam param
  ) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();
    
    // calculate the payment rate based on client rate, which is determined by consultants
    decimal realRate = param.baseRate / 100;
    decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    r.Rental__c = FinancialUtilities.pmt(
      param.amountBasePmt,
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);

    r.Estimated_Commission__c = param.brokeragePer / 100 * param.amountBaseComm;
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();

    return r;
  }

  //Lelo                2017-07-27
  private static Application_Quoting_Result__c calculateFinanceOne(
    CalcParam param
  ) {
    // System.debug('Finance One calculation...');
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();
    // System.debug('NAF: ' + r.NAF__c);
    // calculate the payment rate based on client rate, which is determined by consultants
    Decimal realRate = param.clientRate / 100;
    Decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    Decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );
    // System.debug('realRate: ' + realRate);
    // System.debug('rate: ' + rate);

    // calculate the monthly payment based on client rate
    r.Rental__c = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);
    // System.debug('rental: ' + r.Rental__c);

    // calculate the estimated commission
    Decimal commBase = 0.0;
    Decimal commBaseAmount = param.nafCommission;
    // Decimal diff = param.clientRate - param.baseRate;
    if ('Finance One PL'.equals(param.lender)) {
      commBase = 2;
    } else if ('Finance One'.equals(param.lender)) {
        if ('Platinum'.equals(param.loanTypeDetail)) {
          commBase = 3.0 + (param.clientRate - param.baseRate);
        }
        if ('Gold'.equals(param.loanTypeDetail)) {
          commBase = 3.0 + (param.clientRate - param.baseRate);
        }
        if ('Silver'.equals(param.loanTypeDetail)) {
          commBase = 2.0 + (param.clientRate - param.baseRate);
        }
        if ('Bronze'.equals(param.loanTypeDetail)) {
          commBase = 1.0 + (param.clientRate - param.baseRate);
        }
    
      if (commBase == 0.0) {
        commBase = (param.clientRate - param.baseRate);
      }
    } else if ('Finance One Commercial'.equals(param.lender)) {
      
      commBaseAmount = param.nafCommission;
      commBase = param.brokeragePer;
    }
    System.debug('commBase: ' + commBase);
    r.Estimated_Commission__c = commBase / 100 * commBaseAmount; //Lelo, 2016-10-12
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);
    // System.debug('param.nafCommission: ' + param.nafCommission);
    // System.debug('Estimated Commission: ' + r.Estimated_Commission__c);

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();

    return r;
  }

  //Lelo                2017-07-27
  private static Application_Quoting_Result__c calculateMoney3(
    CalcParam param
  ) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();

    //param.baseRate = param.clientRate;

    // calculate the payment rate based on client rate, which is determined by consultants
    Decimal realRate = param.clientRate / 100;
    Decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);

    Decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    // calculate the monthly payment based on client rate
    r.Rental__c = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    // r.Rental__c = FinancialUtilities.pmt(param.getNaf(), rate, param.term, param.residualValue, param.getPaymentTypeBoolean());

    r.Rental__c = r.Rental__c.setScale(2);

    // calculate the estimated commission
    r.Estimated_Commission__c = 0.0;
    if ('Money3'.equals(param.lender) && param.amountBaseComm != null) {
      r.Estimated_Commission__c =
        param.amountBaseComm *
        getMoney3CommPercentage(param) /
        100;
    }
    if ('RateSetter'.equals(param.lender) && param.commRate != null) {
      // calculate the payment rate based on base rate, which is determined by Customer Profile and LTV
      Decimal br = param.baseRate;
      if (br > param.clientRate) {
        br = param.clientRate;
      }
      Decimal realBaseRate = br / 100;
      Decimal baseFutureValue = FinancialUtilities.fv(
        realBaseRate / 12,
        12,
        1000
      );
      Decimal baseRateValue = FinancialUtilities.rate(
        1000,
        12,
        0,
        baseFutureValue,
        realBaseRate / 12,
        false
      );

      //Lelo                                                                                          2016-07-29
      Decimal realTermToCalcCommision = param.term;
      if (realTermToCalcCommision > 60) {
        realTermToCalcCommision = 60;
      }
      // calculate the base payment without brokerage
      Decimal basePaymentCommission = FinancialUtilities.pmt(
        param.getNaf(),
        baseRateValue,
        realTermToCalcCommision,
        param.residualValue,
        param.getPaymentTypeBoolean()
      ); //Lelo                  2016-09-01
      // calculate the monthly payment based on client rate
      Decimal rentalCommission = FinancialUtilities.pmt(
        param.getNaf(),
        rate,
        realTermToCalcCommision,
        param.residualValue,
        param.getPaymentTypeBoolean()
      ); //Lelo                  2016-09-01
      //rentalCommission = rentalCommission.setScale(2);
      // calculate the estimated commission
      r.Estimated_Commission__c =
        ((rentalCommission * realTermToCalcCommision) -
        (basePaymentCommission * realTermToCalcCommision)) *
        param.commRate /
        100;
      r.Estimated_Commission__c = r.Estimated_Commission__c / 1.1;
      r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);
    }
    if ('Plenti PL'.equals(param.lender) || 'RateSetter PL'.equals(param.lender)) {
      // r.Estimated_Commission__c = param.amountBaseComm * 0.01;
      r.Estimated_Commission__c = param.amountBaseComm * 0.00;
      r.Estimated_Commission__c = r.Estimated_Commission__c / 1.1;
      r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);
    }
    if ('CarStart'.equals(param.lender)) {
      r.Estimated_Commission__c = param.amountBaseComm;
      r.Estimated_Commission__c = r.Estimated_Commission__c / 1.1;
      r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);
    }
    if ('APF'.equals(param.lender)) {
      r.Estimated_Commission__c = param.amountBaseComm;
      r.Estimated_Commission__c = r.Estimated_Commission__c / 1.1;
      r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);
    }
    if ('Pepper PL'.equals(param.lender)) {
      r.Estimated_Commission__c = param.getNaf() * 0.018;
      r.Estimated_Commission__c = r.Estimated_Commission__c / 1.1;
      r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);
    }
    if ('Azora Consumer'.equals(param.lender)) {
      r.Estimated_Commission__c = param.getNaf() * 0.04;
      r.Estimated_Commission__c = r.Estimated_Commission__c / 1.1;
      r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);
    }
    if ('Wisr VL'.equals(param.lender)) {
      Decimal d = param.clientRate - param.baseRate;
      Decimal ds = param.maxRate - param.baseRate;
      if (ds > 0) {
        r.Estimated_Commission__c =
          param.getNAF() *
          (param.commRate / 100) *
          (d / ds);
      }
      r.Estimated_Commission__c = r.Estimated_Commission__c / 1.1;
      r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);
    }
    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);
    r.recalculateFormulas();
    return r;
  }

  //Lelo                2021-12-13
  private static Application_Quoting_Result__c calculateFirstmac(
    CalcParam param
  ) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();

    //param.baseRate = param.clientRate;

    // calculate the payment rate based on client rate, which is determined by consultants
    Decimal realRate = param.baseRate / 100;
    Decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);

    // Base rate
    Decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    // calculate the monthly payment based on base rate
    Decimal baseRental = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );

    // Client Rate
    realRate = param.clientRate / 100;
    futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    
    rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    // calculate the monthly payment based on client rate
    r.Rental__c = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    // r.Rental__c = FinancialUtilities.pmt(param.getNaf(), rate, param.term, param.residualValue, param.getPaymentTypeBoolean());

    r.Rental__c = r.Rental__c.setScale(2);

    // calculate the estimated commission
    r.Estimated_Commission__c = param.baseRate == param.clientRate? 0.00 : (r.Rental__c - baseRental) * param.term;
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);

    // if ('Firstmac'.equals(param.lender)) {
    //   Decimal d = param.clientRate - param.baseRate;
    //   Decimal ds = param.maxRate - param.baseRate;
    //   if (ds > 0) {
    //     // r.Estimated_Commission__c =
    //       // param.getNAF() * (d / ds) * 0.1;
    //     r.Estimated_Commission__c = param.getNAF() * 0.0573 * (d / ds);
    //   }
    //   r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);
    // }
    
    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);
    r.recalculateFormulas();
    return r;
  }

  //Lelo                2017-07-27
  private static Application_Quoting_Result__c calculateBrokerageGeneric(
    CalcParam param
  ) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();
    System.debug(param.clientRate);
    // calculate the payment rate based on client rate, which is determined by consultants
    Decimal realRate = param.clientRate / 100;
    Decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    Decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    // calculate the monthly payment based on client rate
    r.Rental__c = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);

    // calculate the estimated commission
    if (GreenLightCalculatorExtension.LENDER_QUOTING.equals(param.lender)) {
      r.Estimated_Commission__c =
        (param.brokeragePer / 100 * param.amountBaseComm) / 1.1;
    } else {
      r.Estimated_Commission__c = param.brokeragePer / 100 * param.getNaf();
    }

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();

    return r;
  }

  //Lelo                2017-07-27
  private static Application_Quoting_Result__c calculateCommRate(
    CalcParam param
  ) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    if (
      String.isNotBlank(param.lender) &&
      param.lender.contains('Latitude')
    ) {
      r.Payment_Calc_Type__c = 'SP';
    }
    r.NAF__c = param.getNaf();

    // calculate the payment rate based on client rate, which is determined by consultants
    Decimal realRate = param.clientRate / 100;
    Decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    Decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    // calculate the monthly payment based on client rate
    r.Rental__c = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);

    Decimal comm = param.commRate;
    Decimal bonus = 0.0;
    Decimal baseComm = param.getNaf();
    if ('AFS Consumer'.equals(param.lender)) {
      comm = Math.abs(param.clientRate - param.baseRate) / 2.0 * param.commRate;
    }
    if ('Affordable'.equals(param.lender)) {
      baseComm = param.amountBaseComm;
      // if (baseComm > 10000) {
      //   if (param.clientRate < 10.0) {
      //     comm = 4.0;
      //   } else if (param.clientRate >= 10.0 && param.clientRate < 21) {
      //     comm = 5.0;
      //   } else {
      //     comm = 3.0;
      //   }
      // } else {
      //   comm = 2.0;
      // }
      if (param.commBonus != null) {
        bonus = param.commBonus;
      }
    }

    // calculate the estimated commission
    r.Estimated_Commission__c = (comm / 100 * baseComm) + bonus;
    if ('Affordable'.equals(param.lender)) {
      if ('Manual'.equals(param.commType)) {
        // r.Calculated_Commission__c = r.Estimated_Commission__c;
        r.Estimated_Commission__c = param.commPayable + bonus;
      }
      r.Estimated_Commission__c = r.Estimated_Commission__c / 1.1; 
    }

    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);
    System.debug(
      param.commRate +
      '|' +
      comm +
      '|' +
      param.getNaf() +
      '|' +
      baseComm +
      '|' +
      bonus +
      '|' +
      r.Estimated_Commission__c
    );

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();

    return r;
  }

  //Lelo                2017-07-27
  private static Application_Quoting_Result__c calculateYamaha(
    CalcParam param
  ) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();

    //Lelo                                              2016-07-29
    Decimal realTermToCalcCommision = param.term;
    if (param.term > 60) {
      realTermToCalcCommision = 60;
    }

    // calculate the payment rate based on client rate, which is determined by consultants
    Decimal realRate = param.clientRate / 100;
    Decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    Decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    // calculate the payment rate based on base rate, which is determined by Customer Profile and LTV
    Decimal realBaseRate = param.baseRate / 100;
    Decimal baseFutureValue = FinancialUtilities.fv(
      realBaseRate / 12,
      12,
      1000
    );
    Decimal baseRateValue = FinancialUtilities.rate(
      1000,
      12,
      0,
      baseFutureValue,
      realBaseRate / 12,
      false
    );
    // System.debug('The calculated base rate is: ' + baseRateValue);

    // System.debug('The calculated base payment is: ' + basePaymentCommission);

    r.Rental__c = FinancialUtilities.pmt(
      r.NAF__c,
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);

    Decimal commScaling = 0.0;
    if ('Commercial'.equals(param.loanTypeDetail)) {
      if (param.term <= 24) {
        commScaling = 40.0 / 100.0;
      } else if (param.term <= 36) {
        commScaling = 60.0 / 100.0;
      } else if (param.term <= 48) {
        commScaling = 80.0 / 100.0;
      } else if (param.term <= 60) {
        commScaling = 100.0 / 100.0;
      } else if (param.term <= 84) {
        commScaling = 80.0 / 100.0;
      }
    } else {
      if (param.term <= 24) {
        commScaling = 40.0 / 100.0;
      } else if (param.term <= 36) {
        commScaling = 70.0 / 100.0;
      } else if (param.term <= 48) {
        commScaling = 80.0 / 100.0;
      } else if (param.term <= 60) {
        commScaling = 100.0 / 100.0;
      } else if (param.term <= 84) {
        commScaling = 100.0 / 100.0;
      }
    }
    // System.debug('param.commRate >> ' + param.commRate + '|commScaling >> ' + commScaling + '|param.term >> ' + param.term);
    // calculate the estimated commission

    // ORIGINAL LINE - r.Estimated_Commission__c = (((rentalCommission * realTermToCalcCommision) - (basePaymentCommission * realTermToCalcCommision)) * (param.commRate/100) + param.docFees) * commScaling;
    if ('Commercial'.equals(param.loanTypeDetail)) {
      // calculate the base payment without brokerage
      Decimal basePaymentCommission = FinancialUtilities.pmt(
        r.NAF__c,
        baseRateValue,
        realTermToCalcCommision,
        param.residualValue,
        param.getPaymentTypeBoolean()
      ); //Lelo          2016-09-01
      // calculate the monthly payment based on client rate
      Decimal rentalCommission = FinancialUtilities.pmt(
        r.NAF__c,
        rate,
        realTermToCalcCommision,
        param.residualValue,
        param.getPaymentTypeBoolean()
      ); //Lelo          2016-09-01
      r.Estimated_Commission__c =
        ((rentalCommission * realTermToCalcCommision) -
        (basePaymentCommission * realTermToCalcCommision)) *
        commScaling *
        0.7; //  Lelo 2017-10-16
    } else {
      r.Estimated_Commission__c =
        (param.getNaf() * param.commRate / 100.0) * commScaling;
    }

    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();

    return r;
  }

  //Lelo                2017-07-25
  public static Decimal getProtectedPercentaje(Decimal vehiclePrice) {
    Decimal r = 0.0;
    if (protectedRatesList == null) {
      protectedRatesList = Protected_Payment_Settings__c.getAll().values();
      protectedRatesList.sort();
    }
    for (Protected_Payment_Settings__c s : protectedRatesList) {
      if (vehiclePrice >= s.From__c) {
        r = s.Percentaje__c / 100;
      } else {
        break;
      }
    }
    return r;
  }

  //-

  //Lelo              2017-07-25
  // public static List<Application_Quoting_Result__c> getComparisonResultsByLead(Id leadId) {

  //Loading Ledner Settings
  //Map<String, Lenders__c> lenderSettings = new Map<String, Lenders__c>();
  //List<Lenders__c> lenderLst = Lenders__c.getAll().values();
  //for (Lenders__c a : lenderLst) {
  //    if (a.Active__c) {
  //        lenderSettings.put(a.lender__c, a);
  //    }
  //}

  ////Quoting data
  //List<Lead__c> objLst = [SELECT Finance_Amount__c, Type_of_Asset__c, Length_of_Term__c, Do_you_own_a_Property__c,
  //                               Residential_Status__c, Vehicle_Year__c, Application_Type__c
  //                        FROM Lead__c WHERE Id = :leadId];

  //Select lenders

  //Calculate base rate

  //Calculate client rate

  //Calulate

  //     return null;
  // }

  //BaseRateCalc
  public static Decimal getBaseRate(CalcParam param) {
    System.debug('@@getBaseRate: ' + JSON.serializePretty(param));
    Decimal r = 0.0;
    if (param != null) {
      // System.debug('param.lender' + param.lender);
      if ('ANZ Consumer'.equals(param.lender)) {
        r = getANZConsumerBaseRate(param);
      } else if ('ANZ Commercial'.equals(param.lender)) {
        r = getANZCommercialBaseRate(param);
      } else if ('ANZ Others'.equals(param.lender)) {
        r = getANZOthersBaseRate(param);
      } else if ('BOQ'.equals(param.lender)) {
        r = getBOQBaseRate(param, false);
      } else if ('BOQ Commercial'.equals(param.lender)) {
        r = getBOQCommBaseRate(param, false);
      } else if ('Pepper MV'.equals(param.lender)) {
        r = getPepperBaseRate(param, false);
      } else if ('Pepper Leisure'.equals(param.lender)) {
        r = getPepperBaseRate(param, false);
      } else if ('Pepper Commercial'.equals(param.lender)) {
        r = getPepperBaseRate(param, false);
      } else if ('Pepper 5Oh'.equals(param.lender)) {
        r = getPepper5OhBaseRate(param, false);
      } else if ('Pepper Summer'.equals(param.lender)) {
        r = getPepperSummerBaseRate(param, false);
      } else if ('Liberty Drive'.equals(param.lender) || 
        'Liberty Commercial'.equals(param.lender)) {
        //r = getLibertyDriveBaseRate(param);
        r = getLibertyBaseRate(param, false);
      } else if ('Liberty Leisure'.equals(param.lender)) {
        r = getLibertyBaseRate(param, false);
      } else if ('Liberty Options'.equals(param.lender)) {
        r = getLibertyOptionsBaseRate(param);
      } else if ('Macquarie Consumer'.equals(param.lender)) {
        r = getMacquarieConsumerBaseRate(param);
      } else if ('Macquarie Commercial'.equals(param.lender)) {
        r = getMacquarieConsumerBaseRate(param);
        // r = getMacquarieCommercialBaseRate(param);
      } else if (
        'Finance One'.equals(param.lender) ||
        'Finance One PL'.equals(param.lender) ||
        'Finance One Business'.equals(param.lender) ||
        'Finance One Commercial'.equals(param.lender)
      ) {
        r = getFinanceOneBaseRate(param);
      } else if ('Metro'.equals(param.lender)) {
        r = getMetroBaseRate(param);
      } else if (
        'Yamaha Marine'.equals(param.lender) ||
        'Yamaha Motorcycles'.equals(param.lender) ||
        'Yamaha Water'.equals(param.lender) ||
        'AMMF'.equals(param.lender)
      ) {
        r = getYamahaBaseRate(param, true);
      } else if ('Wisr'.equals(param.lender) || 'Wisr PL'.equals(param.lender)) {
        r = getWisrBaseRate(param);
      } else if ('Wisr VL'.equals(param.lender)) {
        r = getWisrVLBaseRate(param, false);
      } else if ('Firstmac'.equals(param.lender)) {
        r = getFirstmacBaseRate(param);
      } else if ('Now Finance'.equals(param.lender)) {
        r = getNowFinanceBaseRate(param);
      } else if ('CarStart'.equals(param.lender)) {
        r = getCarStartFinanceBaseRate(param);
      } else if ('RateSetter'.equals(param.lender) || 'Plenti Commercial'.equals(param.lender)) {
        r = getRateSetterBaseRate(param, false);
      } else if ('Latitude'.equals(param.lender)) {
        r = getRateLatitudeBaseRate(param, false);
      } else if ('Green Light'.equals(param.lender)) {
        r = getRateGreenLightBaseRate(param);
      } else if (
        LatitudePersonalCalculatorExtension.LENDER_QUOTING.equals(param.lender)
      ) {
        r = getRateLatitudePLBaseRate(param, false);
      } else if (AfsCalculatorExtension.LENDER_QUOTING.equals(param.lender)) {
        r = getAFSConsumerBaseRate(param, false);
      } else if ('AFS Commercial'.equals(param.lender)) {
        r = getAFSCommercialBaseRate(param, false);
      } else if (MoneyPlaceExtension.LENDER_QUOTING.equals(param.lender)) {
        r = getWisrBaseRate(param);
      } else if (
        Money3CalculatorExtension.LENDER_QUOTING.equals(param.lender)
      ) {
        r = getMoney3BaseRate(param);
      } else if ('Affordable'.equals(param.lender)) {
        r = getAffordableBaseRate(param, false);
      } else if('Shift Asset'.equals(param.lender)){
        r = getShiftAssetBaseRate(param);  
      } else if ('Shift ODR'.equals(param.lender)) {
        r = getShiftOTLBaseRate(param);
      } else if ('Grow Asset'.equals(param.lender)) {
        r = getGetGrowAssetCarBaseRate(param);
      } else if ('Grow Business Loan'.equals(param.lender)) {
        r = getGetGrowBusinessLoanBaseRate(param);
      } else if ('Morris'.equals(param.lender)) {
        r = getMorrisBaseRate(param);
      } else if ('Selfco'.equals(param.lender)) {
        r = getSelfcoBaseRate(param);
      } else if ('Angle Finance'.equals(param.lender)) {
        r = getAngleFinanceBaseRate(param);
      } else if ('Capital Finance'.equals(param.lender)) {
        r = getCapitalFinanceBaseRate(param);
      } else if ('Azora Consumer'.equals(param.lender)) {
        r = getAzoraBaseRate(param);
      } else if ('Society One'.equals(param.lender)) {
        r = getSocietyOneBaseRate(param, false);
      }
    }
    System.debug('@@baseRateCalculated: ' + r);
    return r;
  }

  //ANZ Consumer --> BaseRateCalc
  private static Decimal getANZConsumerBaseRate(CalcParam param) {
    Decimal r = 0.0;
    if (param == null || String.isBlank(param.ltv))
      return r;

    //Load rates
    List<Esanda_Consumer_Rates__c> rates = Esanda_Consumer_Rates__c.getAll()
      .values();
    rates.sort();

    if ('OG1'.equalsIgnoreCase(param.ltv)) {
      if ('Property Owner - New Car'.equals(param.customerProfile)) {
        r = rates[0].Other_Goods__c;
      } else if ('Property Owner - Old Car'.equals(param.customerProfile)) {
        r = rates[1].Other_Goods__c;
      } else if ('Non Property Owner - New Car'.equals(param.customerProfile)) {
        r = rates[2].Other_Goods__c;
      } else if ('Non Property Owner - Old Car'.equals(param.customerProfile)) {
        r = rates[3].Other_Goods__c;
      } else {
        r = 0;
      }
    } else if ('OG2'.equalsIgnoreCase(param.ltv)) {
      if ('Property Owner - New Car'.equals(param.customerProfile)) {
        r = rates[0].Other_Goods_2__c;
      } else if ('Property Owner - Old Car'.equals(param.customerProfile)) {
        r = rates[1].Other_Goods_2__c;
      } else if ('Non Property Owner - New Car'.equals(param.customerProfile)) {
        r = rates[2].Other_Goods_2__c;
      } else if ('Non Property Owner - Old Car'.equals(param.customerProfile)) {
        r = rates[3].Other_Goods_2__c;
      } else {
        r = 0;
      }
    } else {
      if (param.ltv.isNumeric()) {
        decimal ltvValue = decimal.valueOf(param.ltv);
        if (ltvValue <= 110) {
          if ('Property Owner - New Car'.equals(param.customerProfile)) {
            r = rates[0].LTV_110__c;
          } else if ('Property Owner - Old Car'.equals(param.customerProfile)) {
            r = rates[1].LTV_110__c;
          } else if (
            'Non Property Owner - New Car'.equals(param.customerProfile)
          ) {
            r = rates[2].LTV_110__c;
          } else if (
            'Non Property Owner - Old Car'.equals(param.customerProfile)
          ) {
            r = rates[3].LTV_110__c;
          } else {
            r = 0;
          }
        } else if (ltvValue > 110 && ltvValue <= 140) {
          if ('Property Owner - New Car'.equals(param.customerProfile)) {
            r = rates[0].LTV_110_140__c;
          } else if ('Property Owner - Old Car'.equals(param.customerProfile)) {
            r = rates[1].LTV_110_140__c;
          } else if (
            'Non Property Owner - New Car'.equals(param.customerProfile)
          ) {
            r = rates[2].LTV_110_140__c;
          } else if (
            'Non Property Owner - Old Car'.equals(param.customerProfile)
          ) {
            r = rates[3].LTV_110_140__c;
          } else {
            r = 0;
          }
        } else if (ltvValue > 140) {
          if ('Property Owner - New Car'.equals(param.customerProfile)) {
            r = rates[0].LTV_140__c;
          } else if ('Property Owner - Old Car'.equals(param.customerProfile)) {
            r = rates[1].LTV_140__c;
          } else if (
            'Non Property Owner - New Car'.equals(param.customerProfile)
          ) {
            r = rates[2].LTV_140__c;
          } else if (
            'Non Property Owner - Old Car'.equals(param.customerProfile)
          ) {
            r = rates[3].LTV_140__c;
          } else {
            r = 0;
          }
        } //else {
        //r = 0;
        //}
      } else {
        r = 0;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill LTV field with an Integer value (decimal values aren\'t valid).'));
      } //end if numeric
    } //end if 'OG'

    if (r > 0) {
      r -= 2;
      if (param.term > 60) {
        r += 0.4;
      }
      if ('Y'.equals(param.adverseCredit)) {
        r += 0.4;
      }
    }

    return r;
  }

  //ANZ Consumer --> BaseRateCalc
  private static Decimal getANZCommercialBaseRate(CalcParam param) {
    Decimal r = 0.0;
    if (param == null || String.isBlank(param.ltv))
      return r;

    //Load rates
    List<Esanda_Commercial_Rates__c> rates = Esanda_Commercial_Rates__c.getAll()
      .values();
    rates.sort();

    if ('OG'.equals(param.ltv) || 'Other Goods'.equals(param.ltv)) {
      if ('Property Owner - New Car'.equals(param.customerProfile)) {
        r = rates[0].Other_Goods__c;
      } else if ('Property Owner - Old Car'.equals(param.customerProfile)) {
        r = rates[1].Other_Goods__c;
      } else if ('Non Property Owner - New Car'.equals(param.customerProfile)) {
        r = rates[2].Other_Goods__c;
      } else if ('Non Property Owner - Old Car'.equals(param.customerProfile)) {
        r = rates[3].Other_Goods__c;
      } else {
        r = 0;
      }
    } else {
      if (param.ltv.isNumeric()) {
        decimal ltvValue = decimal.valueOf(param.ltv);
        //if (ltvValue <= 140) {
        if ('Property Owner - New Car'.equals(param.customerProfile)) {
          r = rates[0].LTV_140__c;
        } else if ('Property Owner - Old Car'.equals(param.customerProfile)) {
          r = rates[1].LTV_140__c;
        } else if (
          'Non Property Owner - New Car'.equals(param.customerProfile)
        ) {
          r = rates[2].LTV_140__c;
        } else if (
          'Non Property Owner - Old Car'.equals(param.customerProfile)
        ) {
          r = rates[3].LTV_140__c;
        } else {
          r = 0;
        }
        //}
        //else if (ltvValue > 140) {
        //    if ('Property Owner - New Car'.equals(param.customerProfile)) {
        //        r = rates[0].LTV_140__c + 1.70;
        //    } else if ('Property Owner - Old Car'.equals(param.customerProfile)) {
        //        r = rates[1].LTV_140__c + 1.70;
        //    } else if ('Non Property Owner - New Car'.equals(param.customerProfile)) {
        //        r = rates[2].LTV_140__c + 1.70;
        //    } else if ('Non Property Owner - Old Car'.equals(param.customerProfile)) {
        //        r = rates[3].LTV_140__c + 1.70;
        //    } else {
        //        r = 0;
        //    }
        //} //else {
        //r = 0;
        //}
      } else {
        r = 0;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill LTV field with an Integer value (decimal values aren\'t valid).'));
      } //end if numeric
    } //end if 'OG'

    if (r > 0) {
      //if (param.term < 37 || param.term > 60) {
      if (param.term > 60) {
        r += 0.6;
      }
      if ('Y'.equals(param.adverseCredit)) {
        r += 0.4;
      }
      if (
        String.isNotBlank(param.ltv) &&
        param.ltv.isNumeric() &&
        Integer.valueOf(param.ltv) > 140
      ) {
        r += 1.70;
      }
    }

    return r;
  }

  //ANZ Others --> BaseRateCalc
  public static ANZOthers_Rate__mdt getANZOthersRate(CalcParam param) {
    if (
      param == null || String.isBlank(param.goodsType) ||
      String.isBlank(param.vehiclesProfile)
    )
      return null;
    List<ANZOthers_Rate__mdt> d = [
      SELECT Profile__c, Profile_Desc__c, Rate__c
      FROM ANZOthers_Rate__mdt
      WHERE
        Category__c = :param.goodsType
        AND Profile__c = :param.vehiclesProfile
      ORDER BY Profile__c
    ];
    if (!d.isEmpty()) {
      return d[0];
    }
    return null;
  }

  private static Decimal getANZOthersBaseRate(CalcParam param) {
    Decimal r = 0.00;
    ANZOthers_Rate__mdt rate = getANZOthersRate(param);
    if (rate != null) {
      r = rate.Rate__c;
      if (param.brokeragePer >= 3.51 && param.brokeragePer <= 4.4) {
          r += 0.5;
      }
    }
    return r;

    // // System.debug('ANZ Others base rate calculation....');
    // Map<String, EsandaOthersChattel__c> esandaChattelMap = EsandaOthersChattel__c.getAll();
    // Map<String, EsandaOthersEquipment__c> esandaEquipmentMap = EsandaOthersEquipment__c.getAll();
    // Map<String, EsandaOthersLeisure__c> esandaLeisureMap = EsandaOthersLeisure__c.getAll();

    // Decimal totalAmount = param.getNaf();
    // String label = 'z';
    // String originalRate = '0.00';

    // if (param.goodsType == 'chattel') {
    //   if (param.vehiclesProfile == 'New_3_years_old__c') {
    //     if (totalAmount >= 150000) {
    //       label = 'a';
    //     } else if (totalAmount >= 100000 && totalAmount < 150000) {
    //       label = 'b';
    //     } else if (totalAmount >= 60000 && totalAmount < 100000) {
    //       label = 'c';
    //     } else if (totalAmount >= 20000 && totalAmount < 60000) {
    //       label = 'd';
    //     } else if (totalAmount >= 10000 && totalAmount < 20000) {
    //       label = 'e';
    //     } else {
    //       label = 'z';
    //     }
    //     if (esandaChattelMap.get(label) != null) {
    //       originalRate = esandaChattelMap.get(label).New_3_years_old__c;
    //     } else {
    //       originalRate = 'error';
    //     }
    //   } else if (param.vehiclesProfile == 'X4_8_years_old__c') {
    //     if (totalAmount >= 150000) {
    //       label = 'a';
    //     } else if (totalAmount >= 100000 && totalAmount < 150000) {
    //       label = 'b';
    //     } else if (totalAmount >= 60000 && totalAmount < 100000) {
    //       label = 'c';
    //     } else if (totalAmount >= 20000 && totalAmount < 60000) {
    //       label = 'd';
    //     } else if (totalAmount >= 10000 && totalAmount < 20000) {
    //       label = 'e';
    //     } else {
    //       label = 'z';
    //     }
    //     if (esandaChattelMap.get(label) != null) {
    //       originalRate = esandaChattelMap.get(label).X4_8_years_old__c;
    //     } else {
    //       originalRate = 'error';
    //     }
    //   } else if (param.vehiclesProfile == 'Over_8_years_old__c') {
    //     if (totalAmount >= 150000) {
    //       label = 'a';
    //     } else if (totalAmount >= 100000 && totalAmount < 150000) {
    //       label = 'b';
    //     } else if (totalAmount >= 60000 && totalAmount < 100000) {
    //       label = 'c';
    //     } else if (totalAmount >= 20000 && totalAmount < 60000) {
    //       label = 'd';
    //     } else if (totalAmount >= 10000 && totalAmount < 20000) {
    //       label = 'e';
    //     } else {
    //       label = 'z';
    //     }
    //     if (esandaChattelMap.get(label) != null) {
    //       originalRate = esandaChattelMap.get(label).Over_8_years_old__c;
    //     } else {
    //       originalRate = 'error';
    //     }
    //   } else {
    //     originalRate = '0.00';
    //   }
    // } else if (param.goodsType == 'equipment') {
    //   if (param.vehiclesProfile == 'New_Goods__c') {
    //     if (totalAmount >= 60000) {
    //       label = 'a';
    //     } else if (totalAmount >= 20000 && totalAmount < 60000) {
    //       label = 'b';
    //     } else if (totalAmount >= 10000 && totalAmount < 20000) {
    //       label = 'c';
    //     } else {
    //       label = 'z';
    //     }
    //     if (esandaEquipmentMap.get(label) != null) {
    //       originalRate = esandaEquipmentMap.get(label).New_Goods__c;
    //     } else {
    //       originalRate = 'error';
    //     }
    //   } else if (param.vehiclesProfile == 'Used_up_to_5_years_old__c') {
    //     if (totalAmount >= 60000) {
    //       label = 'a';
    //     } else if (totalAmount >= 20000 && totalAmount < 60000) {
    //       label = 'b';
    //     } else if (totalAmount >= 10000 && totalAmount < 20000) {
    //       label = 'c';
    //     } else {
    //       label = 'z';
    //     }
    //     if (esandaEquipmentMap.get(label) != null) {
    //       originalRate = esandaEquipmentMap.get(label)
    //         .Used_up_to_5_years_old__c;
    //     } else {
    //       originalRate = 'error';
    //     }
    //   } else if (param.vehiclesProfile == 'Over_5_years_old__c') {
    //     if (totalAmount >= 60000) {
    //       label = 'a';
    //     } else if (totalAmount >= 20000 && totalAmount < 60000) {
    //       label = 'b';
    //     } else if (totalAmount >= 10000 && totalAmount < 20000) {
    //       label = 'c';
    //     } else {
    //       label = 'z';
    //     }
    //     if (esandaEquipmentMap.get(label) != null) {
    //       originalRate = esandaEquipmentMap.get(label).Over_5_years_old__c;
    //     } else {
    //       originalRate = 'error';
    //     }
    //   } else {
    //     originalRate = '0.00';
    //   }
    // } else if (param.goodsType == 'leisure') {
    //   if (param.vehiclesProfile == 'New_1_year_old__c') {
    //     if (totalAmount >= 60000) {
    //       label = 'a';
    //     } else if (totalAmount >= 20000 && totalAmount < 60000) {
    //       label = 'b';
    //     } else if (totalAmount >= 10000 && totalAmount < 20000) {
    //       label = 'c';
    //     } else {
    //       label = 'z';
    //     }
    //     if (esandaLeisureMap.get(label) != null) {
    //       originalRate = esandaLeisureMap.get(label).New_1_year_old__c;
    //     } else {
    //       originalRate = 'error';
    //     }
    //   } else if (param.vehiclesProfile == 'X2_5_years_old__c') {
    //     if (totalAmount >= 60000) {
    //       label = 'a';
    //     } else if (totalAmount >= 20000 && totalAmount < 60000) {
    //       label = 'b';
    //     } else if (totalAmount >= 10000 && totalAmount < 20000) {
    //       label = 'c';
    //     } else {
    //       label = 'z';
    //     }
    //     if (esandaLeisureMap.get(label) != null) {
    //       originalRate = esandaLeisureMap.get(label).X2_5_years_old__c;
    //     } else {
    //       originalRate = 'error';
    //     }
    //   } else if (param.vehiclesProfile == 'Over_5_years_old__c') {
    //     if (totalAmount >= 60000) {
    //       label = 'a';
    //     } else if (totalAmount >= 20000 && totalAmount < 60000) {
    //       label = 'b';
    //     } else if (totalAmount >= 10000 && totalAmount < 20000) {
    //       label = 'c';
    //     } else {
    //       label = 'z';
    //     }
    //     if (esandaLeisureMap.get(label) != null) {
    //       originalRate = esandaLeisureMap.get(label).Over_5_years_old__c;
    //     } else {
    //       originalRate = 'error';
    //     }
    //   } else {
    //     originalRate = '0.00';
    //   } // end if for vehiclesProfile
    // } else {
    //   originalRate = '0.00';
    // } // end if for goodsType
    // // System.debug(totalAmount + '|' + param.goodsType + '|' + param.vehiclesProfile + '|' + param.brokeragePer + '|' + label);
    // try {
    //   r = Decimal.valueOf(originalRate);
    // } catch (Exception e) {
    //   r = 0.0;
    // }
    // // System.debug('Base Rate 1 >> ' + r);
    // if (
    //   param.brokeragePer != null &&
    //   (param.brokeragePer >= 3.30 &&
    //   param.brokeragePer <= 4.40)
    // ) {
    //   r += 0.5;
    // }
    // // System.debug('Base Rate def >> ' + r);
    // return r;
  }

  //Liberty Drive Calculators
  private static Decimal getLibertyBaseRate(
    CalcParam param,
    Boolean isMaxRate
  ) {
    Decimal r = 0.00;
    if (param == null || String.isBlank(param.vehicleYear))
      return r;
    //System.debug('clientTier: ' + param.clientTier + ' | vehicleYear: ' + param.vehicleYear);
    //String t = param.clientTier;
    //String v = param.vehicleYear;
    String prodType = 'Consumer';
    String plan = param.vehicleYear;
    if (!'Consumer Loan'.equals(param.productLoanType)) {
      prodType = 'Commercial';
      //plan = param.loanTypeDetail;
    } else if ('Caravan'.equals(param.goodsType)) {
      prodType = 'Consumer [' + param.goodsType + ']';
    }
    // System.debug('prodType => ' + prodType);
    // System.debug(JSON.serializePretty(param));
    List<LibertyRates__c> d = [
      SELECT Rate__c
      FROM LibertyRates__c
      WHERE
        Type__c = :prodType
        AND Tier__c = :param.clientTier
        AND Vehicle_Age__c = :plan
    ];
    if (!d.isEmpty()) {
      r = d.get(0).Rate__c;
      if (prodType.startsWith('Consumer')) {
        if (!isMaxRate) {
          r -= 2;
        }
      } else {
        // Commercial
        /*
        Boolean isOldCar = false;
        if (
          param.vehicleYear.isNumeric() &&
          Integer.valueOf(param.vehicleYear) >= 5
        ) {
          isOldCar = true;
        }
        System.debug(
          'Tier: ' +
          param.clientTier +
          ' | isOldCar: ' +
          isOldCar +
          ' | param.vehicleYear: ' +
          param.vehicleYear
        );
        if (!'AAA'.equals(param.clientTier) && isOldCar) {
          if ('AA'.equals(param.clientTier)) {
            r += 1.5;
          } else if ('A'.equals(param.clientTier)) {
            r += 2.0;
          } else if ('B'.equals(param.clientTier)) {
            r += 3.0;
          } else if ('C'.equals(param.clientTier)) {
            r += 4.0;
          }
        }
        // Balloon
        if (
          ('AAA'.equals(param.clientTier) || 'AA'.equals(param.clientTier)) &&
          param.residualValue > 0
        ) {
          r += 0.1;
        }
        */
        if (isMaxRate) {
          if ('AAA'.equals(param.clientTier) || 'AA'.equals(param.clientTier)) {
            r += 6;
          } else {
            r += 10;
          }
        }
      }
    }
    return r;
  }

  public static Decimal getLibertyMultiplier(CalcParam param) {
    Decimal r = 0.0;
    if ('Consumer Loan'.equals(param.productLoanType)) {
      if (param.term >= 60) {
        if ('AAA'.equals(param.clientTier)) {
          r = 1.75;
        } else if (
          'AA'.equals(param.clientTier) ||
          'A+'.equals(param.clientTier)
        ) {
          r = 1.5;
        } else if (
          'A'.equals(param.clientTier) ||
          'B+'.equals(param.clientTier)
        ) {
          r = 1.25;
        } else if (
          'B'.equals(param.clientTier) ||
          'C'.equals(param.clientTier)
        ) {
          r = 1.0;
        }
      } else if (param.term == 48) {
        if (
          'B'.equals(param.clientTier) ||
          'C'.equals(param.clientTier)
        ) {
          r = 0.75;
        } else {
          r = 1.0;
        }
      } else if (param.term == 36) {
        if (
          'B'.equals(param.clientTier) ||
          'C'.equals(param.clientTier)
        ) {
          r = 0.5;
        } else {
          r = 0.75;
        }
      } else if (param.term == 24) {
        if (
          'B'.equals(param.clientTier) ||
          'C'.equals(param.clientTier)
        ) {
          r = 0.25;
        } else {
          r = 0.5;
        }
      }
    } else {
      if (param.term >= 60) {
        if ('AAA'.equals(param.clientTier)) {
          r = 1.65;
        } else if ('AA'.equals(param.clientTier)) {
          r = 1.35;
        } else {
          r = 1.0;
        }
      } else if (param.term == 48) {
        if ('AAA'.equals(param.clientTier) || 'AA'.equals(param.clientTier)) {
          r = 1.0;
        } else {
          r = 0.75;
        }
      } else if (param.term == 36) {
        if ('AAA'.equals(param.clientTier) || 'AA'.equals(param.clientTier)) {
          r = 0.75;
        } else {
          r = 0.5;
        }
      } else if (param.term == 24) {
        if ('AAA'.equals(param.clientTier) || 'AA'.equals(param.clientTier)) {
          r = 0.5;
        } else {
          r = 0.25;
        }
      }
    }
    return r;
  }

  public static Decimal getLibertyCommission(CalcParam param) {
    Decimal r = 0.00;
    if (param == null)
      return r;
    if ('Consumer Loan'.equals(param.productLoanType)) {
      if ('Liberty Leisure'.equals(param.lender)) {
        if ('New'.equals(param.vehicleYear)) {
          if ('AAA'.equals(param.clientTier)) {
            r = 2.75;
          } else {
            r = 3.00;
          }
        } else {
          if ('AAA'.equals(param.clientTier)) {
            r = 3.00;
          } else {
            r = 3.50;
          }
        }
      } else {
        if ('10+ years'.equals(param.vehicleYear)) {
          if ('AAA'.equals(param.clientTier)) {
            r = 3.25;
          } else if ('AA'.equals(param.clientTier)) {
            r = 3.50;
          } else if ('A+'.equals(param.clientTier)) {
            r = 3.75;
          }
        } else if ('5-9 years'.equals(param.vehicleYear)) {
          if ('AAA'.equals(param.clientTier)) {
            r = 3.25;
          } else if (
            'AA'.equals(param.clientTier) || 'A+'.equals(param.clientTier)
          ) {
            r = 3.50;
          }
        } else if ('0-4 years'.equals(param.vehicleYear)) {
          if ('AAA'.equals(param.clientTier)) {
            r = 3.15;
          } else if (
            'AA'.equals(param.clientTier) || 'A+'.equals(param.clientTier)
          ) {
            r = 3.50;
          }
        } else {
          if ('AAA'.equals(param.clientTier)) {
            r = 2.00;
          } else if ('AA'.equals(param.clientTier)) {
            r = 2.75;
          } else if ('A+'.equals(param.clientTier)) {
            r = 3.00;
          }
        }
        if ('A'.equals(param.clientTier) || 'B'.equals(param.clientTier) || 'C'.equals(param.clientTier)
        ) {
          r = 4.00;
        } else if ('B+'.equals(param.clientTier)) {
          r = 5.00;
        }
      }
    } else {
      // Commercial
      /*
      if ('AAA'.equals(param.clientTier)) {
        r = 1.65;
      } else if ('AA'.equals(param.clientTier)) {
        r = 1.35;
      } else {
        r = 1.00;
      }
      */
    }
    System.debug(
      System.LoggingLevel.INFO,
      'Commission for Liberty is ' + r.format()
    );
    return r;
  }

  /*
    private static Decimal getLibertyDriveBaseRate(CalcParam param) {
        return getLibertyDriveBaseRate(param, false);
    }

    private static Decimal getLibertyDriveBaseRate(CalcParam param, Boolean isMaxRate) {
        Decimal r = 0.0;

        List <LibertyDrive__c> libertyRates = LibertyDrive__c.getAll().values();
        libertyRates.sort();

        Integer ltvVal = 0;
        if (String.isNotBlank(param.ltv) && param.ltv.isNumeric()) {
            ltvVal = Integer.valueOf(param.ltv);
        }

        if ('Consumer'.equals(param.loanTypeDetail)) {
            if (ltvVal < 100) {
                //r = 11.69;
                r =  libertyRates[0].X100_LVR__c;
            } else if (ltvVal >= 100 && ltvVal <= 130) {
                //r = 11.99;
                r =  libertyRates[0].X100_130_LVR__c;
            } else if (ltvVal > 130 && ltvVal <= 150) {
                //r = 12.79;
                r =  libertyRates[0].X131_150_LVR__c;
            } else {
                r = 0;
            }
        } else if ('Commercial Star'.equals(param.loanTypeDetail)) {
            //if (ltv >= 100 && ltv <= 130) {
            //if (ltvVal <= 130) {
                //originalRate = 11.99;
                //r = 10.99;
                r =  libertyRates[1].X100_130_LVR__c;
            //} else {
            //    r = 0;
            //}
        } else if ('Commercial Nova'.equals(param.loanTypeDetail)) {
            //if (ltvVal <= 130) {
                //originalRate = 12.24;
                //r = 11.24;
                r =  libertyRates[2].X100_130_LVR__c;
            //} else {
            //    r = 0;
            //}
        } else {
            r = 0;
        }

        if (param.residualValue > 0) {
            r += 0.1;
        }
        if (!isMaxRate) {
            r = r - 6;
        }
        return r;
    }
    */
  //Liberty Drive Calculators
  private static Decimal getLibertyOptionsBaseRate(CalcParam param) {
    return getLibertyOptionsBaseRate(param, false);
  }
  private static Decimal getLibertyOptionsBaseRate(
    CalcParam param,
    Boolean isMaxRate
  ) {
    Decimal r = 0.0;

    if (
      param == null ||
      param.loanTypeDetail == null ||
      param.clientTier == null ||
      param.carAge == null
    ) {
      // System.debug('no parameters to calculate Liberty Options base rate');
      //// System.debug(param + '|' + param.loanTypeDetail + '|' + param.clientTier + '|' + param.carAge);
      return r;
    }

    // System.debug(param.loanTypeDetail + '|' + param.clientTier + '|' + param.carAge);

    List<LibertyOptions__c> libertyRates = LibertyOptions__c.getAll().values();
    libertyRates.sort();

    Map<String, Map<String, Decimal>> rates = new Map<String, Map<String, Decimal>>();

    Map<String, Decimal> optVehAge = new Map<String, Decimal>();
    optVehAge.put('AA', 1.50);
    optVehAge.put('A', 2.0);
    optVehAge.put('B', 3.00);
    optVehAge.put('C', 4.00);

    for (LibertyOptions__c d : libertyRates) {
      Map<String, Decimal> a = new Map<String, Decimal>();
      if (d.AA__c != null) {
        a.put('AA', d.AA__c);
      }
      if (d.A__c != null) {
        a.put('A', d.A__c);
      }
      if (d.B__c != null) {
        a.put('B', d.B__c);
      }
      if (d.C__c != null) {
        a.put('C', d.C__c);
      }
      rates.put(d.Loan_Type__c, a);
    }

    Map<String, Decimal> br = rates.get(param.loanTypeDetail);
    Decimal originalRate = 0;
    if (br != null) {
      originalRate = br.get(param.clientTier);
      System.debug('LO 1: originalRate >> ' + originalRate);
      if (
        originalRate != null && optVehAge.containsKey(param.clientTier) &&
        param.carAge >= 5
      ) {
        originalRate += optVehAge.get(param.clientTier);
      } else if (originalRate == null) {
        originalRate = 0.0;
      }
      System.debug('LO 2: originalRate >> ' + originalRate);
    }
    // System.debug('original rate >> ' + originalRate);

    if (isMaxRate) {
      r = originalRate;
    } else {
      r = originalRate - 10;
    }
    System.debug(
      'LO 3: originalRate >> ' +
      originalRate +
      '|' +
      r +
      '|' +
      isMaxRate
    );
    if (param.residualValue > 0) {
      r += 0.1;
    }
    return r;
  }

  //Yamaha --> BaseRateCalc
  private static Decimal getYamahaBaseRate(
    CalcParam param,
    Boolean checkPrimePlus
  ) {
    return getYamahaBaseRate(param, checkPrimePlus, false);
  }
  private static Decimal getYamahaBaseRate(
    CalcParam param,
    Boolean checkPrimePlus,
    Boolean isMaxRate
  ) {
    Decimal r = 0.0;
    Map<String, YamahaRatesV2__c> rates = new Map<String, YamahaRatesV2__c>();
    List<YamahaRatesV2__c> ratesList = YamahaRatesV2__c.getAll().values();
    ratesList.sort();
    for (YamahaRatesV2__c y : ratesList) {
      rates.put(y.Profile__c, y);
    }
    String pro = param.loanTypeDetail;
    // if (String.isNotBlank(pro) && pro.contains('Prime') && checkPrimePlus) {
    //     if (param.getNaf() > 35000) {
    //         pro += ' (over 35K)';
    //     }
    // }
    System.debug(
      param.loanTypeDetail +
      '|' +
      pro +
      '|' +
      param.privateSales +
      '|' +
      param.getNaf() +
      '|' +
      checkPrimePlus +
      '|' +
      isMaxRate
    );
    YamahaRatesV2__c y = rates.get(pro);
    if (y != null) {
      if (param.getNaf() < 35000) {
        r = y.Rate_1__c;
      } else if ((param.getNaf() >= 35000 && param.getNaf() < 500000 && !'Commercial'.equals(param.loanTypeDetail)) ||
      (param.getNaf() >= 35000 && 'Commercial'.equals(param.loanTypeDetail))) {
        r = y.Rate_2__c;
      } else if (param.getNaf() >= 500000) {
        r = y.Rate_3__c;
      }

      if (r > 0) {
        if (
          'Y'.equals(param.privateSales) ||
          'Used'.equalsIgnoreCase(param.customerProfile)
        ) {
          r += 'Commercial'.equals(param.loanTypeDetail) ? 1 : 0.5;
        }

        // if ('Y'.equals(param.privateSales)) {
        //     r += 1;
        //     if ('Commercial'.equals(param.loanTypeDetail)) {
        //         r += 1;     // total 2+
        //     }
        // }
        // if ('Used'.equalsIgnoreCase(param.customerProfile)) {
        //     r += 1;
        // }

        if (!isMaxRate && !'Commercial'.equals(param.loanTypeDetail)) {
          r -= 2;
        }

        if (isMaxRate && 'Commercial'.equals(param.loanTypeDetail)) {
          r += 7;
        }
      }
    }
    return r;
  }

  //Yamaha Dof calculation
  public static Decimal getYamahaDOfCalculation(
    Decimal base,
    String loanTypeDetail
  ) {
    Decimal r = 0.0;
    if ('Commercial'.equals(loanTypeDetail)) {
      if (base > 35000) {
        r = 990;
      } else {
        r = 720;
      }
    } else {
      if (base >= 35000) {
        r = 990;
      } else {
        r = 720;
      }
    }
    return r;
  }

  // public static Decimal getYamahaDOfCalculation(Decimal base, String lender) {
  //     Decimal r = 0.0;
  //     Boolean isMarine = false;
  //     if (lender != null && lender.containsIgnoreCase('Marine')) {
  //         isMarine = true;
  //     }
  //     if (base > 1500) {
  //         r = 165;
  //     }
  //     if (base > 3000) {
  //         r = 275;
  //     }
  //     if (base > 5000) {
  //         r = 490;
  //     }
  //     if (base > 10000) {
  //         r = 600;
  //     }
  //     if (base > 20000) {
  //         r = 720;
  //     }
  //     if (isMarine && base > 35000) {
  //         r = 990;
  //     }
  //     return r;
  // }

  //Yamaha Commission Rate
  public static Decimal getYamahaCommission(CalcParam param) {
    Decimal r = 0.0;
    // Map<String, YamahaRates__c> rates = new Map<String, YamahaRates__c>();
    // List<YamahaRates__c> ratesList = YamahaRates__c.getAll().values();
    // ratesList.sort();
    // for (YamahaRates__c y : ratesList) {
    //     rates.put(y.Program__c, y);
    // }
    // if (param != null && String.isNotBlank(param.loanTypeDetail)) {
    //     YamahaRates__c a =  rates.get(param.loanTypeDetail);
    //     if (a != null) {
    //         r = a.Commission__c;
    //     }
    // }
    if (
      param != null &&
      param.maxRate != null &&
      param.baseRate != null &&
      param.clientRate != null
    ) {
      if ('Commercial'.equals(param.loanTypeDetail)) {
        r = 5.0;
      } else {
        r = 5.0;
        Decimal d =
          (Math.abs(param.maxRate - param.baseRate) -
          Math.abs(param.clientRate - param.baseRate)) * 100;
        Decimal f = 1.0;
        if (d >= 1 && d <= 20) {
          f = 0.9;
        } else if (d >= 21 && d <= 40) {
          f = 0.8;
        } else if (d >= 41 && d <= 60) {
          f = 0.7;
        } else if (d >= 61 && d <= 80) {
          f = 0.6;
        } else if (d >= 81 && d <= 100) {
          f = 0.5;
        } else if (d >= 101 && d <= 120) {
          f = 0.4;
        } else if (d >= 121 && d <= 140) {
          f = 0.3;
        } else if (d >= 141 && d <= 160) {
          f = 0.2;
        } else if (d >= 161 && d <= 180) {
          f = 0.1;
        } else if (d >= 181) {
          f = 0.0;
        }
        r *= f;
      }
    }
    return r;
  }

  //Pepper MV Commission Rate
  public static Decimal getPepperMVCommission(CalcParam param) {
    List<PepperMV__c> mvValues = PepperMV__c.getAll().values();
    mvValues.sort();
    List<PepperMV__c> tierAValues = new List<PepperMV__c>();
    List<PepperMV__c> tierBValues = new List<PepperMV__c>();
    List<PepperMV__c> tierCValues = new List<PepperMV__c>();
    for (PepperMV__C value : mvValues) {
      if (value.Tier__c == 'A') {
        tierAValues.add(value);
      } else if (value.Tier__c == 'B') {
        tierBValues.add(value);
      } else if (value.Tier__c == 'C') {
        tierCValues.add(value);
      }
    }

    Decimal r = 0.0;
    Decimal br = 0.0; //Base Rate
    if (param.clientTier == 'A') {
      for (Integer i = 0; i < tierAValues.size() - 1; i++) {
        if (i == 0) {
          br = tierAValues[i].Rates__c;
        }
        if (
          param.clientRate >= tierAValues[i].Rates__c &&
          param.clientRate < tierAValues[i + 1].Rates__c
        ) {
          r = tierAValues[i].Comms__c;
        }
      }
      if (param.clientRate >= tierAValues[tierAValues.size() - 1].Rates__c) {
        r = tierAValues[tierAValues.size() - 1].Comms__c;
      }
    } else if (param.clientTier == 'B') {
      for (Integer i = 0; i < tierBValues.size() - 1; i++) {
        if (i == 0) {
          br = tierBValues[i].Rates__c;
        }
        if (
          param.clientRate >= tierBValues[i].Rates__c &&
          param.clientRate < tierBValues[i + 1].Rates__c
        ) {
          r = tierBValues[i].Comms__c;
        }
      }
      if (param.clientRate >= tierBValues[tierBValues.size() - 1].Rates__c) {
        r = tierBValues[tierBValues.size() - 1].Comms__c;
      }
    } else if (param.clientTier == 'C') {
      for (Integer i = 0; i < tierCValues.size() - 1; i++) {
        if (i == 0) {
          br = tierCValues[i].Rates__c;
        }
        if (
          param.clientRate >= tierCValues[i].Rates__c &&
          param.clientRate < tierCValues[i + 1].Rates__c
        ) {
          r = tierCValues[i].Comms__c;
        }
      }
      if (param.clientRate >= tierCValues[tierCValues.size() - 1].Rates__c) {
        r = tierCValues[tierCValues.size() - 1].Comms__c;
      }
    }
    //if (r > 0) {
    //    if (br == param.clientRate) {
    //        r = 0.0;
    //    }
    //}
    return r;
  }

  //Pepper Leisure Commission Rate
  public static Decimal getPepperLeisureCommission(CalcParam param) {
    List<PepperLeisure__c> mvValues = PepperLeisure__c.getAll().values();
    mvValues.sort();
    List<PepperLeisure__c> tierAValues = new List<PepperLeisure__c>();
    List<PepperLeisure__c> tierBValues = new List<PepperLeisure__c>();
    List<PepperLeisure__c> tierCValues = new List<PepperLeisure__c>();
    for (PepperLeisure__c value : mvValues) {
      if (value.Tier__c == 'A') {
        tierAValues.add(value);
      } else if (value.Tier__c == 'B') {
        tierBValues.add(value);
      } else if (value.Tier__c == 'C') {
        tierCValues.add(value);
      }
    }
    Decimal r = 0.0;
    Decimal br = 0.0; //Base Rate
    if (param.clientTier == 'A') {
      for (Integer i = 0; i < tierAValues.size() - 1; i++) {
        if (i == 0) {
          br = tierAValues[i].Rates__c;
        }
        if (
          param.clientRate >= tierAValues[i].Rates__c &&
          param.clientRate < tierAValues[i + 1].Rates__c
        ) {
          r = tierAValues[i].Comms__c;
        }
      }
      if (param.clientRate >= tierAValues[tierAValues.size() - 1].Rates__c) {
        r = tierAValues[tierAValues.size() - 1].Comms__c;
      }
    } else if (param.clientTier == 'B') {
      for (Integer i = 0; i < tierBValues.size() - 1; i++) {
        if (i == 0) {
          br = tierBValues[i].Rates__c;
        }
        if (
          param.clientRate >= tierBValues[i].Rates__c &&
          param.clientRate < tierBValues[i + 1].Rates__c
        ) {
          r = tierBValues[i].Comms__c;
        }
      }
      if (param.clientRate >= tierBValues[tierBValues.size() - 1].Rates__c) {
        r = tierBValues[tierAValues.size() - 1].Comms__c;
      }
    } else if (param.clientTier == 'C') {
      for (Integer i = 0; i < tierCValues.size() - 1; i++) {
        if (i == 0) {
          br = tierCValues[i].Rates__c;
        }
        if (
          param.clientRate >= tierCValues[i].Rates__c &&
          param.clientRate < tierCValues[i + 1].Rates__c
        ) {
          r = tierCValues[i].Comms__c;
        }
      }
      if (param.clientRate >= tierCValues[tierAValues.size() - 1].Rates__c) {
        r = tierCValues[tierCValues.size() - 1].Comms__c;
      }
    }
    //if (r > 0) {
    //    if (br == param.clientRate) {
    //        r = 0.0;
    //    }
    //}
    return r;
  }

  //Pepper 5Oh Commission Rate
  public static Decimal getPepper50hCommission(CalcParam param) {
    List<PepperSeasonal__c> mvValues = PepperSeasonal__c.getAll().values();
    mvValues.sort();
    List<PepperSeasonal__c> tierAValues = new List<PepperSeasonal__c>();
    List<PepperSeasonal__c> tierBValues = new List<PepperSeasonal__c>();
    for (PepperSeasonal__c value : mvValues) {
      if (value.Tier__c == 'A') {
        tierAValues.add(value);
      } else if (value.Tier__c == 'B') {
        tierBValues.add(value);
      }
    }

    Decimal r = 0.0;
    Decimal br = 0.0; //Base Rate
    if (param.clientTier == 'A') {
      for (Integer i = 0; i < tierAValues.size() - 1; i++) {
        if (i == 0) {
          br = tierAValues[i].Rates__c;
        }
        if (
          param.clientRate >= tierAValues[i].Rates__c &&
          param.clientRate < tierAValues[i + 1].Rates__c
        ) {
          r = tierAValues[i].Comms__c;
        }
      }
      if (param.clientRate >= tierAValues[tierAValues.size() - 1].Rates__c) {
        r = tierAValues[tierAValues.size() - 1].Comms__c;
      }
    } else if (param.clientTier == 'B') {
      for (Integer i = 0; i < tierBValues.size() - 1; i++) {
        if (i == 0) {
          br = tierBValues[i].Rates__c;
        }
        if (
          param.clientRate >= tierBValues[i].Rates__c &&
          param.clientRate < tierBValues[i + 1].Rates__c
        ) {
          r = tierBValues[i].Comms__c;
        }
      }
      if (param.clientRate >= tierBValues[tierBValues.size() - 1].Rates__c) {
        r = tierBValues[tierAValues.size() - 1].Comms__c;
      }
    }
    //if (r > 0) {
    //    if (br == param.clientRate) {
    //        r = 0.0;
    //    }
    //}
    return r;
  }

  //Pepper Summer Commission Rate
  public static Decimal getPepperSummerCommission(CalcParam param) {
    List<Pepper_Summer_Rates__c> mvValues = Pepper_Summer_Rates__c.getAll()
      .values();
    mvValues.sort();

    Decimal r = 0.0;
    Decimal br = 0.0; //Base Rate
    for (Integer i = 0; i < mvValues.size(); i++) {
      if (param.clientTier == 'A') {
        if (i == 0) {
          br = mvValues[i].Rate__c;
        }
        if (param.clientRate >= mvValues[i].Rate__c) {
          r = mvValues[i].Tier_A_Comm__c;
        }
        System.debug(param.clientRate + '|' + mvValues[i].Rate__c + '|' + r);
      } else if (param.clientTier == 'B') {
        if (i == 0) {
          br = mvValues[i].Tier_B__c;
        }
        if (param.clientRate >= mvValues[i].Tier_B__c) {
          r = mvValues[i].Tier_A_Comm__c;
        }
      }
    }
    //if (r > 0) {
    //    if (br == param.clientRate) {
    //        r = 0.0;
    //    }
    //}
    return r;
  }

  //Macquarie Consumer Base Rate
  private static Decimal getMacquarieConsumerBaseRate(CalcParam param) {
    Decimal r = 0.0;
    MacquarieConsumerRatesv2__c rate = null;

    //Define Product
    String proType = null;
    if ('MOTOV'.equals(param.goodsType)) {
      proType = 'Motor Vehicles';
    } else {
      proType = 'Other Assets';
    }
    String loanProduct = 'Consumer';
    if (!'Consumer Loan'.equals(param.productLoanType)) {
      loanProduct = 'Commercial';
    }
    //Define Customer Profile
    String profile = 'Non property owner';
    if ('Y'.equals(param.customerProfile)) {
      profile = 'Property owner';
    }

    Integer year = Date.today().year() - 4;
    if (String.isNotBlank(param.vehicleYear) && param.vehicleYear.isNumeric()) {
      year = Integer.valueOf(param.vehicleYear);
    }
    String vYear = String.valueOf(year);
    System.debug('loanProduct >> ' + loanProduct);
    System.debug('proType >> ' + proType);
    System.debug('profile >> ' + profile);
    System.debug('vYear >> ' + vYear);
    for (MacquarieConsumerRatesv2__c a : getMacquarieRates(loanProduct)) {
      if (
        a.Product__c.equals(proType) &&
        a.Profile__c.equals(profile) &&
        String.isNotBlank(param.vehicleYear) &&
        a.Year__c.contains(vYear)
      ) {
        rate = a;
        break;
      }
    }
    System.debug('rate >> ' + rate);
    if (rate != null) {
      if ('Motor Vehicles'.equals(rate.Product__c)) {
        Integer ltvVal = 0;
        if (String.isNotBlank(param.ltv) && param.ltv.isNumeric()) {
          ltvVal = Integer.valueOf(param.ltv);
        }
        if (ltvVal < 90) {
          r = rate.R1__c;
        } else if (ltvVal >= 90 && ltvVal <= 110) {
          r = rate.R2__c;
        } else if (ltvVal > 110 && ltvVal <= 130) {
          r = rate.R3__c;
        } else if (ltvVal > 130) {
          r = rate.R4__c;
        }
      } else {
        r = rate.R1__c;
      }
    }

    // if (param.term > 60 && 'Motor Vehicles'.equals(proType)) {
    // Lelo                 2020-04-29
    if (
      param.term > 60 &&
      ('Consumer Loan'.equals(param.productLoanType) ||
      'Motor Vehicles'.equals(proType))
    ) {
      r += 1;
    }
    // if (param.getNaf() < 10000)  {
    //     r += 2;
    // }
    // if ('Y'.equals(param.privateSales) || 'Sale & Lease Back'.equals(param.loanType)) {
    //     r += 0.7;
    // }

    /*
        if (param.brokeragePer != null) {
            if (param.brokeragePer > 4 && param.brokeragePer <= 5) {
                r += 0.50;
            } else if (param.brokeragePer > 5 && param.brokeragePer <= 6) {
                r += 1.0;
            } else if (param.brokeragePer > 6 && param.brokeragePer <= 7) {
                r += 1.5;
            } else if (param.brokeragePer > 7 && param.brokeragePer <= 8) {
                r += 2.5;
            }
        }
        */

    // if (r > 2) {
    //     r -= 2;         //Correction
    // } else {
    //     r = 0.0;
    // }

    return r;
  }
  /*
    private static Decimal getMacquarieConsumerBaseRate(CalcParam param) {
        Decimal r = 0.0;
        
        List <MacquarieConsumerRates__c> macquarieRates = MacquarieConsumerRates__c.getAll().values();
        macquarieRates.sort();

        Decimal financeAmount = param.getNaf();
        if (param.term >= 12 && param.term <= 35) {
            if (financeAmount >= 5000 && financeAmount <= 10000) {
                r = macquarieRates[0].X12_35_months__c + 5.00;
            } else if (financeAmount > 10000 && financeAmount <= 60000) {
                r = macquarieRates[1].X12_35_months__c;
            } else if (financeAmount > 60000 && financeAmount <= 250000) {
                r = macquarieRates[2].X12_35_months__c;
            } else {
                r = 0.00;
            }
        } else if (param.term >= 36 && param.term <= 60) {
            if (financeAmount >= 5000 && financeAmount <= 10000) {
                r = macquarieRates[0].X36_60_months__c + 5.00;
            } else if (financeAmount > 10000 && financeAmount <= 60000) {
                r = macquarieRates[1].X36_60_months__c;
            } else if (financeAmount > 60000 && financeAmount <= 250000) {
                r = macquarieRates[2].X36_60_months__c;
            } else {
                r = 0.00;
            }
        } else if (param.term >= 61 && param.term <= 84) {
            if (financeAmount >= 5000 && financeAmount <= 10000) {
                r = macquarieRates[0].X61_84_months__c + 5.00;
            } else if (financeAmount > 10000 && financeAmount <= 60000) {
                r = macquarieRates[1].X61_84_months__c;
            } else if (financeAmount > 60000 && financeAmount <= 250000) {
                r = macquarieRates[2].X61_84_months__c;
            } else {
                r = 0.00;
            }
        } else {
            r = 0.00;
        }
                
        if (param.carAge > 4) {
            r += 0.50;
        }
        if ('Motorbike'.equals(param.assetType)) {
            r += 1.00;
        }
        if ('Caravan'.equals(param.assetType)) {
            r += 0.50;
        }
        //Lelo                                  2016-08-29
        if (param.privateSales == 'Y') {
            r += 0.50;
        }
        //Lelo                                  2017-08-03
        if (String.isNotBlank(param.ltv) && param.ltv.isNumeric()) {
            if (Integer.valueOf(param.ltv) > 130) {
                r += 0.50;       
            }
        }

        if (param.brokeragePer != null) {
            if (param.brokeragePer > 4 && param.brokeragePer <= 5) {
                r += 0.50;
            } else if (param.brokeragePer > 5 && param.brokeragePer <= 6) {
                r += 1.0;
            } else if (param.brokeragePer > 6 && param.brokeragePer <= 7) {
                r += 1.5;
            } else if (param.brokeragePer > 7 && param.brokeragePer <= 8) {
                r += 2.5;
            }
        }

        return r;
    }
    */

  //Macquarie Consumer Base Rate
  // private static Decimal getMacquarieCommercialBaseRate(CalcParam param) {
  //     Decimal r = 0.0;

  //     List <MacquarieCommercialRates__c> macquarieRates = MacquarieCommercialRates__c.getAll().values();
  //     macquarieRates.sort();

  //     Decimal financeAmount = param.getNaf();

  //     if (param.term >= 12 && param.term <= 35) {
  //         if (financeAmount >= 10000 && financeAmount <= 18000) {
  //             //originalRate = macquarieRates[0].X12_35_months__c + 5.00;  //Lelo         2016-09-29
  //             r = macquarieRates[0].X12_35_months__c;
  //         } else if (financeAmount > 18000 && financeAmount <= 60000) {
  //             r = macquarieRates[1].X12_35_months__c;
  //         } else if (financeAmount > 60000) {
  //             r = macquarieRates[2].X12_35_months__c;
  //         } else {
  //             r = 0.00;
  //         }
  //     } else if (param.term >= 36 && param.term <= 60) {
  //         if (financeAmount >= 10000 && financeAmount <= 18000) {
  //             r = macquarieRates[0].X36_60_months__c;   //Lelo         2016-09-29
  //         } else if (financeAmount > 18000 && financeAmount <= 60000) {
  //             r = macquarieRates[1].X36_60_months__c;
  //         } else if (financeAmount > 60000) {
  //             r = macquarieRates[2].X36_60_months__c;
  //         } else {
  //             r = 0.00;
  //         }
  //     } else {
  //         r = 0.00;
  //     }

  //     if (param.carAge > 4) {
  //         r += 0.50;
  //     }

  //     //Lelo                                  2016-08-29
  //     if (param.privateSales == 'Y') {
  //         r += 0.50;
  //     }

  //     // -

  //     if (param.brokeragePer != null) {
  //         if (param.brokeragePer > 4 && param.brokeragePer <= 5) {
  //             r += 0.50;
  //         } else if (param.brokeragePer > 5 && param.brokeragePer <= 6) {
  //             r += 1.0;
  //         } else if (param.brokeragePer > 6 && param.brokeragePer <= 7) {
  //             r += 1.5;
  //         } else if (param.brokeragePer > 7 && param.brokeragePer <= 8) {
  //             r += 2.5;
  //         }
  //     }

  //     return r;
  // }

  //Finance One Base Rate
  public static Decimal getFinanceOneBaseRate(CalcParam param) {
    return getFinanceOneBaseRate(param, false);
  }
  public static Decimal getFinanceOneBaseRate(
    CalcParam param,
    Boolean isMaxRate
  ) {
    Decimal r = 0;
    FinanceOneRates__c rate = getFinanceOneRates(param);
    System.debug('param: ' + param);
    System.debug('rate: ' + rate);
    if (rate != null) {
      if (isMaxRate) {
        r = rate.Max_Rate__c;
      } else {
        r = rate.Base_Rate__c;
      }
    }
    return r;
  }

  public static FinanceOneRates__c getFinanceOneRates(CalcParam param) {
    FinanceOneRates__c r = null;
    if (
      param == null || String.isBlank(param.productLoanType) ||
      String.isBlank(param.productLoanType)
    )
      return r;
    String category = 'Consumer';
    // lelo             2020-05-08
    if (!'Consumer Loan'.equals(param.productLoanType)) {
      category = 'Commercial';
    }
    if (String.isNotBlank(param.customerProfile)) {
      category = 'Personal Loan';
    }
    List<FinanceOneRates__c> d = null;
    if ('Personal Loan'.equals(category)) {
      String pbr = '"Gold" ' + param.customerProfile + '%';
      d = [
        SELECT
          Base_Rate__c,
          Category__c,
          Maximun_Amount__c,
          Max_Rate__c,
          Minimum_Amount__c,
          Max_Term__c,
          Product__c,
          Application_Fee__c
        FROM FinanceOneRates__c
        WHERE
          Category__c = :category
          AND Product__c = :param.loanTypeDetail
          AND Product_Base_Rate__c LIKE :pbr
      ];
    } else {
      d = [
        SELECT
          Base_Rate__c,
          Category__c,
          Maximun_Amount__c,
          Max_Rate__c,
          Minimum_Amount__c,
          Max_Term__c,
          Product__c,
          Application_Fee__c
        FROM FinanceOneRates__c
        WHERE Category__c = :category AND Product__c = :param.loanTypeDetail
      ];
    }

    if (!d.isEmpty()) {
      r = d.get(0);
    }
    return r;
  }

  public static Decimal getFinanceOneApplicationFee(CalcParam param) {
    FinanceOneRates__c rate = getFinanceOneRates(param);
    if (rate == null)
      return 0.0;
    Decimal r = 0.0;
    if ('Economy'.equals(rate.Product__c)) {
      r = param.getNaf() * rate.Application_Fee__c / 100;
      r = r.setScale(2);
    } else {
      r = rate.Application_Fee__c;
    }
    return r;
  }

  //Liberty Drive Calculators
  private static Decimal getMetroBaseRate(CalcParam param) {
    System.debug(param.loanTypeDetail);
    Decimal r = 0.0;
    // System.debug('Metro base rate...');
    //Validation
    if (
      'Passenger and Commercial Vehicles'.equals(param.loanTypeDetail) ||
      'Wheeled Plant & Equipment'.equals(param.loanTypeDetail)
    ) {
      if (param.getNaf() < 5000) {
        return r;
      }
    } else if ('Heavy Commercial Vehicles'.equals(param.loanTypeDetail)) {
      if (param.getNaf() < 10000) {
        return r;
      }
    }

    List<MetroCalculatorRates__c> rates = MetroCalculatorRates__c.getAll()
      .values();
    rates.sort();
    System.debug('@@TotalRates: ' + rates.size());

    Decimal originalRate = 0.00;
    //decimal totalInsurance = nwc + gap + warranty + lti + truckGap + tai + mv + cci;
    //Lelo                              2016-08-25
    Decimal financeAmount = param.getNaf();
    //-

    // System.debug(param.term + '|' + financeAmount + '|' + param.loanTypeDetail);

    if ('Passenger and Commercial Vehicles'.equals(param.loanTypeDetail)) {
      if (param.term <= 24) {
        if (financeAmount >= 20000) {
          originalRate = rates[0].X24_Months__c;
        } else if (financeAmount >= 10000) {
          originalRate = rates[1].X24_Months__c;
        } else if (financeAmount >= 5000) {
          originalRate = rates[2].X24_Months__c;
        }
      } else if (param.term > 24 && param.term <= 36) {
        if (financeAmount >= 20000) {
          originalRate = rates[0].X36_Months__c;
        } else if (financeAmount >= 10000) {
          originalRate = rates[1].X36_Months__c;
        } else if (financeAmount >= 5000) {
          originalRate = rates[2].X36_Months__c;
        }
      } else if (param.term > 36 && param.term <= 48) {
        if (financeAmount >= 20000) {
          originalRate = rates[0].X48_Months__c;
        } else if (financeAmount >= 10000) {
          originalRate = rates[1].X48_Months__c;
        } else if (financeAmount >= 5000) {
          originalRate = rates[2].X48_Months__c;
        }
      } else if (param.term > 48 && param.term <= 60) {
        if (financeAmount >= 20000) {
          originalRate = rates[0].X60_Months__c;
        } else if (financeAmount >= 10000) {
          originalRate = rates[1].X60_Months__c;
        } else if (financeAmount >= 5000) {
          originalRate = rates[2].X60_Months__c;
        }
      }
    } else if ('Heavy Commercial Vehicles'.equals(param.loanTypeDetail)) {
      if (param.term <= 24) {
        if (financeAmount >= 20000) {
          originalRate = rates[3].X24_Months__c;
        } else if (financeAmount >= 10000) {
          originalRate = rates[4].X24_Months__c;
        }
      } else if (param.term > 24 && param.term <= 36) {
        if (financeAmount >= 20000) {
          originalRate = rates[3].X36_Months__c;
        } else if (financeAmount >= 10000) {
          originalRate = rates[4].X36_Months__c;
        }
      } else if (param.term > 36 && param.term <= 48) {
        if (financeAmount >= 20000) {
          originalRate = rates[3].X48_Months__c;
        } else if (financeAmount >= 10000) {
          originalRate = rates[4].X48_Months__c;
        }
      } else if (param.term > 48 && param.term <= 60) {
        if (financeAmount >= 20000) {
          originalRate = rates[3].X60_Months__c;
        } else if (financeAmount >= 10000) {
          originalRate = rates[4].X60_Months__c;
        }
      }
    } else if ('Wheeled Plant & Equipment'.equals(param.loanTypeDetail)) {
      if (param.term <= 24) {
        if (financeAmount >= 20000) {
          originalRate = rates[5].X24_Months__c;
        } else if (financeAmount >= 10000) {
          originalRate = rates[6].X24_Months__c;
        } else if (financeAmount >= 5000) {
          originalRate = rates[7].X24_Months__c;
        }
      } else if (param.term > 24 && param.term <= 36) {
        if (financeAmount >= 20000) {
          originalRate = rates[5].X36_Months__c;
        } else if (financeAmount >= 10000) {
          originalRate = rates[6].X36_Months__c;
        } else if (financeAmount >= 5000) {
          originalRate = rates[7].X36_Months__c;
        }
      } else if (param.term > 36 && param.term <= 48) {
        if (financeAmount >= 20000) {
          originalRate = rates[5].X48_Months__c;
        } else if (financeAmount >= 10000) {
          originalRate = rates[6].X48_Months__c;
        } else if (financeAmount >= 5000) {
          originalRate = rates[7].X48_Months__c;
        }
      } else if (param.term > 48 && param.term <= 60) {
        if (financeAmount >= 20000) {
          originalRate = rates[5].X60_Months__c;
        } else if (financeAmount >= 10000) {
          originalRate = rates[6].X60_Months__c;
        } else if (financeAmount >= 5000) {
          originalRate = rates[7].X60_Months__c;
        }
      }
    }

    r = originalRate.setScale(2);

    // Green car
    if ('New/Demo'.equals(param.condition) && 'Y'.equals(param.greenCar)) {
      r -= 1.0;
    }

    // System.debug('originalRate >> ' + originalRate);
    if (((param.term / 12) + param.carAge) > 10) {
      r += 1.5;
    } else if (param.carAge > 5) {
      r += 0.75;
    }

    if (param.privateSales == 'Y') {
      r += 0.75;
    }
    if (param.saleBacksPurchased == 'Y') {
      r += 1.5;
    }
    if (String.isNotBlank(param.clientTier)) {
      MetroPlanOption__c a = getMetroPlanOptions().get(param.clientTier);
      if (a != null && a.Extra_Rate__c != null) {
        r += a.Extra_Rate__c;
      }
    }
    // System.debug('Base Rate 1 >> ' + r);
    //Lelo                                  2016-08-25
    //Brokerage %
    // System.debug('brokeragePer >> ' + param.brokeragePer);
    if (param.brokeragePer != null && param.brokeragePer != 0) {
      if (param.brokeragePer > 4 && param.brokeragePer <= 5) {
        r += 0.50;
      } else if (param.brokeragePer > 5 && param.brokeragePer <= 6) {
        r += 1.0;
      } else if (param.brokeragePer > 6 && param.brokeragePer <= 7) {
        r += 1.5;
      } else if (param.brokeragePer > 7 && param.brokeragePer <= 8) {
        r += 2.0;
      }
    }
    // System.debug('Base Rate def >> ' + r);
    return r;
  }

  public static List<LatitudeRatesv3__c> getLatitudeRatesByClass(
    String category,
    String classType,
    Integer carAge
  ) {
    // Category
    if (String.isBlank(category)) {
      category = 'Car/Motorbike';
    }
    // Define Asset Age
    String aa = '';
    // if ('Car/Motorbike'.equals(category)) {
    //   if (carAge < 3) {
    //       aa = '< 3 years';
    //   } else if (carAge >= 3 && carAge <= 7) {
    //       aa = '3 - 7 years';
    //   } else {
    //       aa = '> 7 years';
    //   }
    // } else {
    if (carAge <= 3) {
      aa = '0 - 3 years';
    } else if (carAge >= 4 && carAge <= 7) {
      aa = '4 - 7 years';
    } else {
      aa = '> 7 years';
    }
    List<LatitudeRatesv3__c> r = new List<LatitudeRatesv3__c>();
    List<LatitudeRatesv3__c> d = LatitudeRatesv3__c.getAll().values();
    d.sort();
    for (LatitudeRatesv3__c x :  d) {
      if (
        x.Category__c.equals(category) &&
        x.Class__c.equals(classType) &&
        x.Asset_Age__c.equals(aa)
        ) {
          r.add(x);
      }
    }

    // }
    // List<LatitudeRatesv3__c> r = [
    //   SELECT Asset_Age__c, Rate__c, Comm__c
    //   FROM LatitudeRatesv3__c
    //   WHERE
    //     Category__c = :category
    //     AND Class__c = :classType
    //     AND Asset_Age__c = :aa
    //   ORDER BY Name
    // ];
    // System.debug(category + '|' + classType + '|' + aa + '| records: ' + r.size());
    return r;
  }

  private void loadLatitudeRates() {

  }

  // public static List<LatitudeRatesv2__c> getLatitudeRatesV2ByClass(String classType) {
  //     List<LatitudeRatesv2__c> ratesList = LatitudeRatesv2__c.getAll().values();
  //     ratesList.sort();
  //     Map<String, List<LatitudeRatesv2__c>> rates = new Map<String, List<LatitudeRatesv2__c>>();
  //     for (LatitudeRatesv2__c a : ratesList) {
  //         List<LatitudeRatesv2__c> l = rates.get(a.Class__c);
  //         if (l == null) {
  //             l = new List<LatitudeRatesv2__c>();
  //             rates.put(a.Class__c, l);
  //         }
  //         l.add(a);
  //     }
  //     return rates.get(classType);
  // }

  //Latitude Commision Rate
  public static Decimal getLatitudeRateCommission(CalcParam param) {
    Decimal r = 0.0;
    if (param != null && param.clientRate != 0) {
      List<LatitudeRatesv3__c> rateList = getLatitudeRatesByClass(
        param.goodsType,
        param.loanTypeDetail,
        param.carAge
      );
      if (rateList != null) {
        Decimal x = 0;
        for (LatitudeRatesv3__c a : rateList) {
          x = a.Rate__c;
          if (param.clientRate >= x) {
            r = a.Comm__c;
          }
        }
      }
    }
    return r;
  }

  //Generic Client Rate Calculation
  public static Decimal getClientRateCalculation(CalcParam param) {
    return getClientRateCalculation(param, 2);
  }
  public static Decimal getClientRateCalculation(
    CalcParam param,
    Integer scale
  ) {
    System.debug('@@getClientRate: ' + JSON.serializePretty(param));
    Decimal r = 0.0;
    // System.debug('@@Lender >> ' + param.lender);
    // System.debug('amuntPmt >> ' + param.amountBasePmt);
    // System.debug('baseRate  >> ' + param.baseRate);
    // System.debug('ratePmt  >> ' + (param.baseRate/100/12));
    // System.debug('term     >> ' + param.term);
    if (param.residualValue == null) {
      param.residualValue = 0.0;
    }
    if (param.term > 0 && param.baseRate > 0 && param.amountBasePmt > 0) {
      Integer type = 0;
      if ('Advance'.equals(param.paymentType))
        type = 1;
      try {
        Decimal pmt = FinancialUtilities.pmt2(
          (param.baseRate /
          100 /
          12),
          Integer.valueOf(param.term),
          (param.amountBasePmt * -1),
          param.residualValue,
          type
        );
        //System.debug('pmt      >> ' + pmt);
        r =
          FinancialUtilities.rate2(
            Integer.valueOf(param.term),
            (pmt * -1.0),
            param.getNaf(),
            (param.residualValue * -1),
            type
          ) *
          12 *
          100;
        //System.debug('Cl Rate  >> ' + r);
      } catch (MathException e) {
        System.debug('Error >> ' + e.getMessage());
      }
    }
    r = r.setScale(scale);
    return r;
  }

  //Lelo                                      2017-09-25
  //Finance One DOF calc
  public static Decimal getFinanceOneDofCalc(CalcParam param) {
    Decimal r = 0.0;
    if ('E-Motors'.equals(param.loanTypeDetail)) {
      r = 330.00;
    } else {
      if (param.getNaf() >= 5000 && param.getNaf() <= 14000) {
        r = 990.00;
      } else if (param.getNaf() > 14000) {
        r = 1100.00;
      }
    }
    return r;
  }
  //--

  //Lelo          2017-07-27
  public static Decimal getFinanceOneRiskFeeCalc(CalcParam param) {
    Decimal r = 0.0;
    Decimal nc = param.nafCommission;
    if ('E-Motors'.equals(param.loanTypeDetail)) {
      r = 0;
    } else {
      if (nc >= 5000 && nc <= 12000) {
        r = 995.00;
      } else if (nc > 12000 && nc <= 20000) {
        r = 1495.00;
      } else if (nc > 20000 && nc < 50000) {
        r = 1995.00;
      } else {
        r = 0;
      }
    }
    return r.setScale(2);
  }

  public static Decimal getMaximunBaseRate(CalcParam param) {
    Decimal r = 0.0;
    if (param != null) {
      // System.debug('param.lender' + param.lender);
      if ('ANZ Consumer'.equals(param.lender)) {
        //r = getANZConsumerBaseRate(param);
      } else if ('ANZ Commercial'.equals(param.lender)) {
        //r = getANZCommercialBaseRate(param);
      } else if ('ANZ Others'.equals(param.lender)) {
        //r = getANZOthersBaseRate(param);
      } else if ('BOQ'.equals(param.lender)) {
        r = getBOQBaseRate(param, true);
      } else if ('Pepper MV'.equals(param.lender)) {
        //r = getPepperMVBaseRate(param, true);
        r = getPepperBaseRate(param, true);
      } else if ('Pepper Leisure'.equals(param.lender)) {
        //r = getPepperLeisureBaseRate(param, true);
        r = getPepperBaseRate(param, true);
      } else if ('Pepper Commercial'.equals(param.lender)) {
        //r = getPepperMVBaseRate(param, true);
        r = getPepperBaseRate(param, true);
      } else if ('Pepper 5Oh'.equals(param.lender)) {
        r = getPepper5OhBaseRate(param, true);
      } else if ('Pepper Summer'.equals(param.lender)) {
        r = getPepperSummerBaseRate(param, true);
      } else if ('Liberty Drive'.equals(param.lender) || 
        'Liberty Commercial'.equals(param.lender)) {
        //r = getLibertyDriveBaseRate(param, true);
        r = getLibertyBaseRate(param, true);
      } else if ('Liberty Leisure'.equals(param.lender)) {
        r = getLibertyBaseRate(param, true);
      } else if ('Liberty Options'.equals(param.lender)) {
        r = getLibertyOptionsBaseRate(param, true);
      } else if ('Macquarie Consumer'.equals(param.lender)) {
        //r = getMacquarieConsumerBaseRate(param);
      } else if ('Macquarie Commercial'.equals(param.lender)) {
        //r = getMacquarieCommercialBaseRate(param);
      } else if (
        'Finance One'.equals(param.lender) ||
        'Finance One PL'.equals(param.lender) ||
        'Finance One Business'.equals(param.lender) ||
        'Finance One Commercial'.equals(param.lender)
      ) {
        r = getFinanceOneBaseRate(param, true);
      } else if ('Metro'.equals(param.lender)) {
        //r = getMetroBaseRate(param);
      } else if (
        'Yamaha Marine'.equals(param.lender) ||
        'Yamaha Motorcycles'.equals(param.lender) ||
        'Yamaha Water'.equals(param.lender)
      ) {
        r = getYamahaBaseRate(param, true, true);
      } else if ('Latitude'.equals(param.lender)) {
        r = getRateLatitudeBaseRate(param, true);
      } else if ('AFS Consumer'.equals(param.lender)) {
        r = getAFSConsumerBaseRate(param, true);
      } else if ('AFS Commercial'.equals(param.lender)) {
        r = getAfsCommercialBaseRate(param, true);
      } else if (
        LatitudePersonalCalculatorExtension.LENDER_QUOTING.equals(param.lender)
      ) {
        r = getRateLatitudePLBaseRate(param, true);
      } else if (
        GreenLightCalculatorExtension.LENDER_QUOTING.equals(param.lender)
      ) {
        r = getGreenLightMaxRate(param);
      } else if ('CarStart'.equals(param.lender)) {
        r = getCarStartFinanceMaxRate(param);
      } else if ('RateSetter'.equals(param.lender)) {
        r = getRateSetterBaseRate(param, true);
      } else if ('Firstmac'.equals(param.lender)) {
        r = getFirstmacBaseRate(param, true);
      } else if ('Wisr VL'.equals(param.lender)) {
        r = getWisrVLBaseRate(param, true);
      } else if ('Affordable'.equals(param.lender)) {
        r = getAffordableBaseRate(param, true);
      } else if ('Azora Consumer'.equals(param.lender)) {
        r = getAzoraBaseRate(param);
      } else if ('Society One'.equals(param.lender)) {
        r = getSocietyOneBaseRate(param, true);
      }
    }
    return r;
  }

  private static Decimal getPepper5OhBaseRate(
    CalcParam param,
    Boolean isMaxRate
  ) {
    Decimal r = 0.0;
    List<PepperSeasonal__c> mvValues = PepperSeasonal__c.getAll().values();
    mvValues.sort();
    List<PepperSeasonal__c> tierRates = new List<PepperSeasonal__c>();
    for (PepperSeasonal__c value : mvValues) {
      if (value.Tier__c.equals(param.clientTier)) {
        tierRates.add(value);
      }
    }
    if (!tierRates.isEmpty()) {
      Integer i = 0;
      if (isMaxRate) {
        i = tierRates.size() - 1;
      }
      r = tierRates[i].Rates__c;
    }
    return r;
  }

  //All Pepper Calculators
  public static Decimal getPepperBaseRate(CalcParam param, Boolean isMaxRate) {
    if (param == null)
      return 0.0;
    Decimal r = 0.0;
    List<PepperRate__c> rates = PepperRate__c.getAll().values();
    rates.sort();
    PepperRate__c rate = null;
    for (PepperRate__c a : rates) {
      if (
        a.Product__c.equals(param.customerProfile) &&
        a.Tier__c.equals(param.clientTier)
      ) {
        rate = a;
      }
    }
    if (rate != null) {
      if (
        'New'.equals(param.vehicleYear) || 
        ('OTHER - 2nd & 3rd'.equals(param.customerProfile) && String.isNotBlank(param.vehicleYear))
      ) {
        r = rate.Rate0__c;
      } else if (
        'Used 0-5 years'.equals(param.vehicleYear) || 
        ('OTHER - Primary'.equals(param.customerProfile) && String.isNotBlank(param.vehicleYear))
      ) {
        r = rate.Rate1__c;
      } else if (
        'Used 6-9 years'.equals(param.vehicleYear) ||
        'Used 6+ years'.equals(param.vehicleYear)
      ) {
        r = rate.Rate2__c;
      } else if ('Used 10+ years'.equals(param.vehicleYear)) {
        r = rate.Rate3__c;
      }
    }
    if (r > 0) {
      if (!isMaxRate) {
        r -= 'Consumer Loan'.equals(param.productLoanType)? 2 : 0;
      } else {
        r += !'Consumer Loan'.equals(param.productLoanType)? 6 : 0;
      }
      if (
        'Consumer Loan'.equals(param.productLoanType) && 
        !'CARAVAN'.equals(param.customerProfile) && param.term > 60
      ) {
        r += 0.5; //added on 2020-04-03 Monday requirement
      }
      
      if (
        !'Consumer Loan'.equals(param.productLoanType)
      ) {
        // if ('Y'.equals(param.privateSales)) {
        //   r += 0.5;
        // }
        if (param.term > 60) {
          r += 0.5;
        }
      }
    }
    return r;
  }

  /*
    public static Decimal getPepperMVBaseRate(CalcParam param, Boolean isMaxRate) {
        Decimal r = 0.0;
        List <PepperMV__c> mvValues = PepperMV__c.getAll().values();
        mvValues.sort();
        List <PepperMV__c> tierRates = new List <PepperMV__c> ();
        for (PepperMV__C value : mvValues) {
            if (value.Tier__c.equals(param.clientTier)) {
                tierRates.add(value);
            }
        }
        if (!tierRates.isEmpty()) {
            Integer i = 0;
            if (isMaxRate) {
                i = tierRates.size() - 1;
            } 
            r = tierRates[i].Rates__c;
        }
        return r;
    }*/

  //Pepper Leisure Calculators
  /*
    private static Decimal getPepperLeisureBaseRate(CalcParam param, Boolean isMaxRate) {
        Decimal r = 0.0;
        List <PepperLeisure__c> mvValues = PepperLeisure__c.getAll().values();
        mvValues.sort();
        //List <PepperLeisure__c> tierAValues = new List <PepperLeisure__c> ();
        //List <PepperLeisure__c> tierBValues = new List <PepperLeisure__c> ();
        //List <PepperLeisure__c> tierCValues = new List <PepperLeisure__c> ();
        List <PepperLeisure__c> tierRates = new List <PepperLeisure__c> ();
        for (PepperLeisure__c value : mvValues) {
            if (value.Tier__c.equals(param.clientTier)) {
                tierRates.add(value);
            }
        }
        if (!tierRates.isEmpty()) {
            Integer i = 0;
            if (isMaxRate) {
                i = tierRates.size() - 1;
            } 
            r = tierRates[i].Rates__c;
        }
        return r;
    }*/

  //Pepper Summer Calculators
  private static Decimal getPepperSummerBaseRate(
    CalcParam param,
    Boolean isMaxRate
  ) {
    Decimal r = 0.0;
    List<Pepper_Summer_Rates__c> mvValues = Pepper_Summer_Rates__c.getAll()
      .values();
    mvValues.sort();
    Integer i = 0;
    if (isMaxRate) {
      i = mvValues.size() - 1;
    }
    if ('A'.equals(param.clientTier)) {
      r = mvValues[i].Rate__c;
    } else if ('B'.equals(param.clientTier)) {
      r = mvValues[i].Tier_B__c;
    }
    return r;
  }

  public static Decimal getLibertyOptionRiskFee(CalcParam param) {
    Decimal r = 0.0;
    Decimal base = param.riskFeeBase;
    if (param.clientTier == 'AA') {
      r = 0;
    } else if (param.clientTier == 'A') {
      r = 0.075 * base;
    } else if (param.clientTier == 'B') {
      r = 0.09 * base;
    } else if (param.clientTier == 'C') {
      r = 0.10 * base;
    } else {
      r = 0;
    }
    r = r.setScale(2);
    return r;
  }

  public static Decimal getANZConsumerCommission(CalcParam param) {
    Decimal r = 0.0;
    List<ANZ_Commissions__c> rateValues = ANZ_Commissions__c.getAll().values();
    rateValues.sort();
    ANZ_Commissions__c rate = null;
    String realProfile = param.customerProfile;
    if ('Car'.equals(param.goodsType)) {
      if (param.customerProfile.containsIgnoreCase('Non Property')) {
        realProfile = 'Non Property Owner - ';
      } else {
        realProfile = 'Property Owner - ';
      }
      if ('New'.equals(param.condition)) {
        realProfile += 'New Car';
      } else {
        realProfile += 'Old Car';
      }
    } else {
      realProfile = 'Other Goods';
    }
    for (ANZ_Commissions__c a : rateValues) {
      if (realProfile.equals(a.Customer_Profile__c)) {
        rate = a;
      }
    }
    System.debug(
      'param.customerProfile >> ' +
      param.customerProfile +
      '|realProfile >> ' +
      realProfile +
      '|' +
      rate
    );
    if (rate == null) {
      rate = rateValues.get(rateValues.size() - 1);
    }
    r = rate.Max_AFC__c;
    if (param.getNaf() > 50000) {
      r += rate.Goods_50K__c;
    } else if (param.getNaf() < 25000 && 'New'.equals(param.condition)) {
      r += rate.Good_25k__c;
    } else if (param.getNaf() < 10000 && 'Used'.equals(param.condition)) {
      r += rate.Used_Goods_10k__c;
    }
    System.debug('Commission >> ' + r);
    if (r > 0) {
      Decimal decuction =
        (Math.abs(2 + param.baseRate - param.clientRate) * 0.5) * r;
      System.debug(
        'Rate diference >> ' + Math.abs(param.baseRate - param.clientRate)
      );
      System.debug('Deduction >> ' + decuction);
      r = r - decuction;
    }
    System.debug('Final Commision >> ' + r);
    return r;
  }

  public static Lenders__c getLenderSettings(String lender) {
    Lenders__c r = null;
    if (lenderSettingsMap == null) {
      lenderSettingsMap = new Map<String, Lenders__c>();
      for (Lenders__c a : Lenders__c.getAll().values()) {
        lenderSettingsMap.put(a.lender__c, a);
        // if (a.lender__c.equals(lender)) {
        //     r = a;
        // }
      }
    }
    return lenderSettingsMap.get(lender);
  }

  public static LibertyLPI calculateLibertyLPI(CalcParam param) {
    LibertyLPI r = new LibertyLPI();
    Map<String, Liberty_LPI_Setting__c> settings = QuotingToolHelper.getLibertyLPIMap(
      'ALL'
    );
    StateStampDuties__c sd = QuotingToolHelper.getStateStampDuty(param.state);

    Map<String, Decimal> coverRates = new Map<String, Decimal>();
    for (String k : settings.keySet()) {
      Liberty_LPI_Setting__c a = settings.get(k);
      Decimal v = 0.0;
      if (param.term <= 12) {
        v = a.Term_1__c;
      } else if (param.term <= 24) {
        v = a.Term_2__c;
      } else if (param.term <= 36) {
        v = a.Term_3__c;
      } else if (param.term <= 48) {
        v = a.Term_4__c;
      } else if (param.term <= 60) {
        v = a.Term_5__c;
      } else if (param.term <= 72) {
        v = a.Term_6__c;
      } else if (param.term <= 84) {
        v = a.Term_7__c;
      }
      coverRates.put(k, v / 100.0);
      //System.debug(k + ' >> ' + coverRates.get(k));
    }

    Decimal netPremium = 0.0;
    Decimal grossPer = 0.0;
    Decimal basePremiumDisabilityUnemployment;
    Decimal basePremiumLCICCC = 0;
    Decimal basePremiumHHC;
    Decimal GSTDisabilityUnemployment;
    Decimal GSTLCICCC;
    Decimal GSTHHC;
    Decimal premiumDisabilityOnlyDisabilityAndUnemployment;
    Decimal commissionDisabilityOnlyDisabilityAndUnemployment;
    if (String.isNotBlank(param.lpiLevel) && sd != null && coverRates.containsKey(param.lpiLevel)) {
      netPremium = param.totalAmount * coverRates.get(param.lpiLevel);
      /*
      if ('Life Only'.equals(param.lpiLevel)) {
        grossPer = coverRates.get('Life Only') * (1 + sd.Life__c / 100.0);
      } else
      */ 
      if ('Disability Only'.equals(param.lpiLevel)) {
        
        basePremiumDisabilityUnemployment = param.totalAmount * coverRates.get('Disability Only');
        
        if (Date.parse(param.dateofBirth).daysBetween(Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day()))/365 >= 30) {
          basePremiumLCICCC = 10 / 0.8 * (param.term / 12);
        }
        
        GSTDisabilityUnemployment = basePremiumDisabilityUnemployment * 0.10;
        GSTLCICCC = basePremiumLCICCC * 0.10;
        premiumDisabilityOnlyDisabilityAndUnemployment = basePremiumDisabilityUnemployment + GSTDisabilityUnemployment + sd.Disability__c / 100 * (basePremiumDisabilityUnemployment + basePremiumLCICCC + GSTDisabilityUnemployment + GSTLCICCC) + basePremiumLCICCC + GSTLCICCC;
        commissionDisabilityOnlyDisabilityAndUnemployment = (netPremium + basePremiumLCICCC)* 0.2;
        /*
        grossPer =
          coverRates.get('Disability Only') * (1 + sd.Disability__c / 100.0);
          
      } else if ('Life & Disability'.equals(param.lpiLevel)) {
        grossPer =
          coverRates.get('Disability Only') *
          (1 + sd.Disability__c / 100.0) *
          1.1;
        grossPer += coverRates.get('Life Only') * (1 + sd.Life__c / 100.0);
        */
      } else if ('Disability & Unemployment'.equals(param.lpiLevel)) {

        basePremiumDisabilityUnemployment = param.totalAmount * coverRates.get('Disability Only');
        
        Decimal basePremiumLCIC = 0;

            if (Date.parse(param.dateofBirth).daysBetween(Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day()))/365 >= 30) {
          basePremiumLCIC = 10 / 0.8 * (param.term / 12);
        }
        
        GSTDisabilityUnemployment = basePremiumDisabilityUnemployment * 0.10;
        GSTLCICCC = basePremiumLCIC * 0.10;
        
        Decimal premiumDisabilityOnly = basePremiumDisabilityUnemployment + GSTDisabilityUnemployment + sd.Disability__c / 100 * (basePremiumDisabilityUnemployment + basePremiumLCIC + GSTDisabilityUnemployment + GSTLCICCC) + basePremiumLCIC + GSTLCICCC;
            
            basePremiumDisabilityUnemployment = param.totalAmount * coverRates.get('Disability & Unemployment');
        basePremiumHHC = 6.5 / 0.8 * (param.term/12);
        GSTDisabilityUnemployment = basePremiumDisabilityUnemployment * 0.10;
        
        if (!'Single'.equals(param.maritalStatus) || param.noOfDependants > 0) {
          basePremiumLCICCC = 5 / 0.8 * (param.term / 12);
        }

        GSTLCICCC = basePremiumLCICCC * 0.10;
        GSTHHC = basePremiumHHC * 0.10;
        
        premiumDisabilityOnlyDisabilityAndUnemployment = basePremiumDisabilityUnemployment + GSTDisabilityUnemployment + sd.Unemployed__c / 100 * (basePremiumDisabilityUnemployment + GSTDisabilityUnemployment + basePremiumLCICCC + GSTLCICCC + basePremiumHHC + GSTHHC) + basePremiumLCICCC + GSTLCICCC + basePremiumHHC + GSTHHC + premiumDisabilityOnly;
        commissionDisabilityOnlyDisabilityAndUnemployment = (basePremiumLCICCC + basePremiumHHC + basePremiumLCIC + basePremiumDisabilityUnemployment + (param.totalAmount * coverRates.get('Disability Only'))) * 0.2;
        /*
        grossPer =
          coverRates.get('Disability & Unemployment') *
          (1 + sd.Disability__c / 100.0) *
          1.1;
          
      } else if ('Life, Disability & Unemployment'.equals(param.lpiLevel)) {
        grossPer =
          coverRates.get('Disability & Unemployment') *
          (1 + sd.Disability__c / 100.0) *
          1.1;
        grossPer += coverRates.get('Life Only') * (1 + sd.Life__c / 100.0);
        */
      }
    }
    //System.debug('grossPer >> ' + grossPer);
    if (premiumDisabilityOnlyDisabilityAndUnemployment != null) {
      if (param.noOfPeople == 2) {
        premiumDisabilityOnlyDisabilityAndUnemployment = premiumDisabilityOnlyDisabilityAndUnemployment * 2 * 0.9;
        commissionDisabilityOnlyDisabilityAndUnemployment = commissionDisabilityOnlyDisabilityAndUnemployment * 2 * 0.9;
      }
      r.premium = premiumDisabilityOnlyDisabilityAndUnemployment;
      r.income = commissionDisabilityOnlyDisabilityAndUnemployment; 
     } else {
      r.premium = param.totalAmount * grossPer;
      r.premium = r.premium.setScale(2);
      r.income = netPremium * 0.2;
      r.income = r.income.setScale(2);
     }
     System.debug('premium >> ' + param.totalAmount + ' x ' + grossPer + ' = ' + r.premium);
     System.debug(JSON.serializePretty(param));
    return r;
  }

  public static Decimal getWisrBaseRate(CalcParam param) {
    Decimal r = 0.0;
    if (param != null && param.vedascore != null && param.term != null) {
      Direct_Money_Rate__c rate = null;
      for (Direct_Money_Rate__c a : Direct_Money_Rate__c.getAll().values()) {
        if (param.vedascore >= a.Vedascore_Start__c) {
          if (a.Vedascore_End__c != null) {
            if (param.vedascore <= a.Vedascore_End__c) {
              rate = a;
            }
          } else {
            rate = a;
          }
        }
      }
      if (rate != null) {
        if (param.term == 36) {
          r = rate.Term_A__c;
        } else if (param.term == 60) {
          r = rate.Term_B__c;
        } else if (param.term == 84 && rate.Term_C__c != null) {
          r = rate.Term_C__c;
        }
      }
    }
    return r;
  }

  public static Decimal getWisrVLBaseRate(CalcParam param, Boolean isMaxRate) {
    Decimal r = 0.0;
    if (
      param != null &&
      param.vedascore != null &&
      String.isNotBlank(param.vehicleYear) &&
      String.isNotBlank(param.customerProfile)
    ) {
      WisrVL_Rates__c rate = null;
      for (WisrVL_Rates__c a : WisrVL_Rates__c.getAll().values()) {
        if (
          a.Profile__c.equals(param.customerProfile) &&
          param.vedascore >= a.Credit_Score_Start__c
        ) {
          if (param.vedascore <= a.Credit_Score_End__c) {
            rate = a;
          } else if (a.Credit_Score_End__c == null) {
            rate = a;
          }
        }
      }
      if (rate != null) {
        Integer dif = Date.today().year() - Integer.valueOf(param.vehicleYear);
        if (dif >= 0 && dif <= 1) {
          r = rate.Rate_1__c;
        } else if (dif >= 2 && dif <= 3) {
          r = rate.Rate_2__c;
        } else if (dif >= 4 && dif <= 7) {
          r = rate.Rate_3__c;
        } else if (dif >= 8) {
          r = rate.Rate_4__c;
        }
      }
      if (param.term == 84) {
        r += 0.5;
      }
      if (
        String.isNotBlank(param.ltv) &&
        param.ltv.isNumeric() &&
        Integer.valueOf(param.ltv) > 130
      ) {
        r += 1.5;
      }
      if (!isMaxRate && r > 0.0) {
        r -= 2.0;
      }
    }
    return r;
  }

  public static Decimal getWisrCommission(CalcParam param) {
    Decimal r = 0.0;
    if (param != null && param.amountBaseComm > 0) {
      r = param.amountBaseComm * 0.01;
      if (r > 350.0) {
        r = 350.0;
      }
    }
    // if (param != null && param.amountBaseComm > 0) {
    //     r = param.amountBaseComm * 0.01;
    // }
    // if (param != null && param.getNAF() > 0) {
    //     r = param.getNAF() * 0.015;
    // }
    // if (r > 450.0) {
    //     r = 450.0;
    // }
    return r;
  }

  private static Application_Quoting_Result__c calculateWisr(CalcParam param) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();

    param.baseRate = param.clientRate;

    // calculate the payment rate based on client rate, which is determined by consultants
    Decimal realRate = param.clientRate / 100;
    Decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    Decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    // calculate the monthly payment based on client rate
    r.Rental__c = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);

    // calculate the estimated commission
    // r.Estimated_Commission__c = getWisrCommission(param) / 1.1;
    r.Estimated_Commission__c = getWisrCommission(param) / 1.1;
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();

    return r;
  }

  private static Application_Quoting_Result__c calculateMoneyPlace(
    CalcParam param
  ) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();

    param.baseRate = param.clientRate;

    // calculate the payment rate based on client rate, which is determined by consultants
    Decimal realRate = param.clientRate / 100;
    Decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    Decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    // calculate the monthly payment based on client rate
    r.Rental__c = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);

    // calculate the estimated commission
    r.Estimated_Commission__c = 0.0;
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();

    return r;
  }

  // public static Decimal getFirstmacCommission(CalcParam param) {
  //     Decimal r = 0.0;
  //     if (param != null && param.amountBaseComm != null && param.brokeragePer != null) {
  //         r = param.amountBaseComm * param.brokeragePer / 100;
  //     }
  //     return r;
  // }

  // private static Application_Quoting_Result__c calculateFirstmac(CalcParam param) {
  //     Application_Quoting_Result__c r = new Application_Quoting_Result__c();
  //     r.Payment_Calc_Type__c = 'DF';
  //     r.NAF__c = param.getNaf();

  //     // calculate the payment rate based on client rate, which is determined by consultants
  //     decimal realRate = param.baseRate/100;
  //     decimal futureValue = FinancialUtilities.fv(realRate/12,12,1000);
  //     decimal rate = FinancialUtilities.rate(1000, 12, 0, futureValue, realRate/12, false);

  //     //System.debug('realRate >> ' + realRate);
  //     //System.debug('futureValue >> ' + futureValue);
  //     //System.debug('rate >> ' + rate);
  //     //System.debug('param.amountBasePmt >> ' + param.amountBasePmt);

  //     r.Rental__c = FinancialUtilities.pmt(param.amountBasePmt, rate, param.term, param.residualValue, param.getPaymentTypeBoolean());
  //     r.Rental__c = r.Rental__c.setScale(2);

  //     // calculate the estimated commission
  //     r.Estimated_Commission__c = getFirstmacCommission(param);
  //     r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);

  //     //calculate the insurance income
  //     r.Insurance_Income__c = param.totalInsuranceIncome;
  //     r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
  //     r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

  //     // calculate the dof without GST
  //     r.DOF__c = param.dof / 1.1;
  //     r.DOF__c = r.DOF__c.setScale(2);

  //     // calculate the monthly payment
  //     r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
  //     r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

  //     r.recalculateFormulas();

  //     return r;
  // }

  public static Decimal getFirstmacBaseRate(CalcParam param) {
    return getFirstmacBaseRate(param, false);
  }

  public static Decimal getFirstmacBaseRate(
    CalcParam param,
    Boolean isMaxRate
  ) {
    Decimal r = 0.0;

    if (
      param != null && 
      String.isNotBlank(param.customerProfile) && 
      String.isNotBlank(param.loanTypeDetail) && 
      String.isNotBlank(param.residency)
    ) {
      String rateType = param.loanTypeDetail;
      String ho =  'Y'.equals(param.residency)? 'Yes' : 'No';
      FirstmacRate__c rate = null;

      for (FirstmacRate__c a : FirstmacRate__c.getAll().values()) {
        if (
          'Standard'.equals(a.Category__c) &&
          ho.equals(a.Home_Owner__c) &&
          a.Rate__c.equals(rateType) &&
          a.Rate_Type__c.equals(param.interestType)
        ) {
          rate = a;
        }
      }
      if (rate != null) {
        if (
          'Standard'.equals(param.customerProfile) ||
          ('Edge'.equals(param.customerProfile) &&
           !'Used 8-12 years'.equals(rate.Rate__c))
        ) {
          r  = rate.Value__c;
          r += 'Edge'.equals(param.customerProfile)? 1.00 : 0.00;
        }
      }
      if (r > 0) {
        //r -= 'Y'.equals(param.greenCar)? 0.7 : 0.0;
        // r -= 'Y'.equals(param.residency)? 0.5 : 0.0;
        r += (isMaxRate)? 2 : 0.0;
      }
    }
    return r;
  }

  public static Decimal getNowFinanceBaseRate(CalcParam param) {
    Decimal r = 0.0;
    if (param != null) {
      if ('Secured'.equals(param.loanTypeDetail)) {
        List<NowFinanceSecuredRate__mdt> d = [
          SELECT MasterLabel, APR__c
          FROM NowFinanceSecuredRate__mdt
          ORDER BY APR__c
          LIMIT 1
        ];
        if (!d.isEmpty()) {
          r = d.get(0).APR__c;
        }
      } else {
        r = 15.0;
      }
    }
    return r;
  }

  public static Decimal getRateSetterBaseRate(
    CalcParam param,
    Boolean isMaxRate
  ) {
    Decimal r = 0.0;
    if (
      param != null && String.isNotBlank(param.customerProfile) &&
      String.isNotBlank(param.clientTier) &&
      String.isNotBlank(param.vehicleYear) &&
      param.vehicleYear.isNumeric()
    ) {
      RateSetterRate__c d = getRateSetterRate(param);
      Integer y = Integer.valueOf(param.vehicleYear);
      Integer cy = Date.today().year();
      if (d != null) {
        if (('new'.equals(param.condition) || 'demo'.equals(param.condition)) && 'RateSetter'.equals(param.lender)) {
          r = d.Rate0__c;
        } else if (y >= (cy - 1)) {
          //2021 - 2020
          r = d.Rate1__c;
        } else if (y >= (cy - 3)) {
          //2019 - 2018
          r = d.Rate2__c;
        } else if (y >= (cy - 7)) {
          //2017 - 2014
          r = d.Rate3__c;
        } else {
          //2013 - 2009
          r = d.Rate4__c;
        }

        if (
          'Car'.equals(param.assetType) &&
          !'Property Owner'.equals(param.customerProfile) &&
          'N'.equals(param.hasImports)
        ) {
          r += 1;
        }
        
        if (!isMaxRate && 'RateSetter'.equals(param.lender)) {
          r = r - 2.0;
        }
        
        if (param.brokeragePer != null && param.brokeragePer > 4) {
          r += (param.brokeragePer - 4).intValue() * 0.5;
        }

        if ('Y'.equals(param.greenCar)) {
          r -= 0.5;
        }
        Decimal t = param.term > 0? param.term / 12.0 : 0.0;
        if (t > 5) {
          r += 0.3;
        }
      }
    }
    return r;
  }

  public static RateSetterRate__c getRateSetterRate(CalcParam param) {
    RateSetterRate__c r = null;
    if (
      param != null && String.isNotBlank(param.customerProfile) &&
      String.isNotBlank(param.clientTier) &&
      String.isNotBlank(param.vehicleYear)
    ) {
      String profile = 'Non asset backed';
      if ('Property Owner'.equals(param.customerProfile)) {
        profile = 'Asset backed';
      }
      List<RateSetterRate__c> dList = [
        SELECT
          Profile__c,
          Tier__c,
          Overs__c,
          Min_Equifax_Score__c,
          Rate0__c,
          Rate1__c,
          Rate2__c,
          Rate3__c,
          Rate4__c
        FROM RateSetterRate__c
        WHERE Profile__c = :profile AND Tier__c = :param.clientTier AND Loan_Product__c = :'Plenti Commercial'.equals(param.lender)? 'Commercial' : 'Consumer'
        ORDER BY Name
      ];
      RateSetterRate__c d = null;
      if (!dList.isEmpty()) {
        r = dList.get(0);
      }
    }
    return r;
  }

  //Calc Params
  public class CalcParam {
    @AuraEnabled
    public String lender { get; set; }
    @AuraEnabled
    public Decimal totalAmount { get; set; }
    @AuraEnabled
    public Decimal totalInsurance { get; set; }
    @AuraEnabled
    public Decimal totalInsuranceIncome { get; set; }
    @AuraEnabled
    public Decimal clientRate { get; set; }
    @AuraEnabled
    public Decimal baseRate { get; set; }
    @AuraEnabled
    public String paymentType { get; set; }
    @AuraEnabled
    public String repaymentType { get; set; }
    @AuraEnabled
    public Decimal term { get; set; }
    @AuraEnabled
    public Decimal dof { get; set; }
    @AuraEnabled
    public Decimal monthlyFee { get; set; }
    @AuraEnabled
    public Decimal docFees { get; set; }
    @AuraEnabled
    public Decimal residualValue { get; set; }
    @AuraEnabled
    public Decimal brokeragePer { get; set; }
    //Pepper / Liberty
    @AuraEnabled
    public Decimal commRate { get; set; }
    //Macquarie
    @AuraEnabled
    public Decimal amountBasePmt { get; set; }
    @AuraEnabled
    public Decimal amountBaseComm { get; set; }
    //Finance One
    @AuraEnabled
    public Decimal nafCommission { get; set; }
    //Liberty Options
    @AuraEnabled
    public Decimal riskFeeBase { get; set; }
    @AuraEnabled
    public String ltv { get; set; }
    @AuraEnabled
    public String customerProfile { get; set; }
    @AuraEnabled
    public String adverseCredit { get; set; } //Y / N
    @AuraEnabled
    public String clientTier { get; set; }
    @AuraEnabled
    public String loanType { get; set; }
    @AuraEnabled
    public String loanTypeDetail { get; set; }
    @AuraEnabled
    public String productLoanType { get; set; }
    @AuraEnabled
    public Integer carAge { get; set; }
    @AuraEnabled
    public String assetType { get; set; }
    @AuraEnabled
    public String privateSales { get; set; }
    @AuraEnabled
    public String saleBacksPurchased { get; set; } //Metro
    @AuraEnabled
    public String goodsType { get; set; } //Anz Others
    @AuraEnabled
    public String goodsSubType { get; set; } //Macquarie
    @AuraEnabled
    public String vehiclesProfile { get; set; } //Anz Others
    @AuraEnabled
    public String condition { get; set; } //Anz Consumer: New/Demo or Used
    @AuraEnabled
    public String vehicleYear { get; set; } //Macquarie
    @AuraEnabled
    public String lpiLevel { get; set; } //Liberty LPI
    @AuraEnabled
    public String state { get; set; } //Liberty LPI
    @AuraEnabled
    public Integer vedascore { get; set; } //Wisr
    @AuraEnabled
    public String greenCar { get; set; } //firstmac
    @AuraEnabled
    public String riskGrade { get; set; } // AFS
    @AuraEnabled
    public String bankrupt { get; set; } // AFS
    @AuraEnabled
    public String residency { get; set; } // AFS
    @AuraEnabled
    public Decimal maxRate { get; set; }
    @AuraEnabled
    public String hasDefault { get; set; }
    @AuraEnabled
    public String hasImports { get; set; }
    @AuraEnabled
    public Decimal rental { get; set; }
    @AuraEnabled
    public Decimal vehiclePrice { get; set; }
    @AuraEnabled
    public Decimal commBonus { get; set; }
    @AuraEnabled
    public String commType { get; set; }
    @AuraEnabled
    public Decimal commPayable { get; set; }
    @AuraEnabled
    public String dateOfBirth { get; set; }
    // New cacls
    @AuraEnabled
    public Decimal equifaxScore {get;set;}
    @AuraEnabled
    public String abnLength {get;set;}
    @AuraEnabled
    public String gstLength {get;set;}
    @AuraEnabled
    public String assetAge {get;set;}  
    @AuraEnabled
    public String tier {get;set;}  
    @AuraEnabled
    public Decimal endOfTerm {get;set;}
    @AuraEnabled
    public String maritalStatus {get;set;}
    @AuraEnabled
    public Decimal noOfDependants {get;set;}
    @AuraEnabled
    public Decimal noOfPeople {get;set;} 
    @AuraEnabled
    public String interestType { get; set; }
    @AuraEnabled
    public String creditScore { get; set; }
    @AuraEnabled
    public String companyScore { get; set; }
    @AuraEnabled
    public String directorSoleTraderScore { get; set; }
    @AuraEnabled
    public String paidDefault {set; get;}
    @AuraEnabled
    public Boolean hasMaxRate {set; get;}
    @AuraEnabled
    public Decimal applicationFee {set; get;}
    @AuraEnabled
    public Decimal riskFee { get; set; }

    public CalcParam() {
      this.totalAmount = 0.0;
      this.totalInsurance = 0.0;
      this.totalInsuranceIncome = 0.0;
      this.clientRate = 0.0;
      this.baseRate = 0.0;
      this.term = 0.0;
      this.dof = 0.0;
      this.monthlyFee = 0.0;
      this.docFees = 0.0;
      this.residualValue = 0.0;
      this.brokeragePer = 0.0;
      this.commRate = 0.0;
      this.amountBasePmt = 0.0;
      this.amountBaseComm = 0.0;
      this.nafCommission = 0.0;
      this.carAge = 0;
      this.riskFeeBase = 0.0;
      this.vedascore = 0;
      this.greenCar = 'N';
      this.rental = 0.0;
      this.commBonus = 0.0;
      this.applicationFee = 0.00;
      this.riskFee = 0.00;
    }

    public CalcParam(String lender) {
      this();
      this.lender = lender;
    }

    public Decimal getNaf() {
      Decimal r = 0.0;
      if (this.totalAmount != null)
        r += this.totalAmount;
      if (this.totalInsurance != null)
        r += this.totalInsurance;
      return r;
    }

    public Boolean getPaymentTypeBoolean() {
      Boolean r = false;
      if ('Advance'.equals(paymentType)) {
        r = true;
      }
      return r;
    }
  }

  public class LibertyLPI {
    public Decimal premium { get; set; }
    public Decimal income { get; set; }

    public LibertyLPI() {
      this.premium = 0.0;
      this.income = 0.0;
    }
  }

  public static Decimal getAfsConsumerMinBaseRate(CalcParam param) {
    if (param == null || String.isBlank(param.clientTier))
      return 0;
    List<ASFRates__c> fullRates = ASFRates__c.getAll().values();
    fullRates.sort();
    //System.debug('Total rates >> ' + fullRates.size() + '|param.clientTier: ' + param.clientTier);
    ASFRates__c rate = fullRates.get(0);

    Decimal r = 0.0;
    if ('Gold Club'.equals(param.clientTier)) {
      r = rate.Gold_Club_Rate__c;
    } else if ('Drive More Plus'.equals(param.clientTier)) {
      r = rate.Drive_More_Plus_Rate__c;
    } else if ('Drive More'.equals(param.clientTier)) {
      r = rate.Drive_More_Rate__c;
    } else if ('Autoline Plus'.equals(param.clientTier)) {
      r = rate.Autoline_Plus_Rate__c;
    } else if ('Autoline'.equals(param.clientTier)) {
      r = rate.Autoline_Rate__c;
    } else if ('Autoline (Credit Impaired)'.equals(param.clientTier)) {
      r = rate.Autoline_Credit_Impaired_Rate__c;
    }
    return r;
  }

  public static Decimal getAfsConsumerMaxBaseRate(CalcParam param) {
    if (param == null || String.isBlank(param.clientTier))
      return 0;
    List<ASFRates__c> fullRates = ASFRates__c.getAll().values();
    fullRates.sort();
    Decimal r = 0.0;
    for (ASFRates__c rate : fullRates) {
      Decimal cr = 0;
      if ('Gold Club'.equals(param.clientTier)) {
        cr = rate.Gold_Club_Rate__c;
      } else if ('Drive More Plus'.equals(param.clientTier)) {
        cr = rate.Drive_More_Plus_Rate__c;
      } else if ('Drive More'.equals(param.clientTier)) {
        cr = rate.Drive_More_Rate__c;
      } else if ('Autoline Plus'.equals(param.clientTier)) {
        cr = rate.Autoline_Plus_Rate__c;
      } else if ('Autoline'.equals(param.clientTier)) {
        cr = rate.Autoline_Rate__c;
      } else if ('Autoline (Credit Impaired)'.equals(param.clientTier)) {
        cr = rate.Autoline_Credit_Impaired_Rate__c;
      }
      if (cr != null && cr > 0) {
        r = cr;
      }
    }
    return r;
  }

  public static Decimal getAfsConsumerCommission(CalcParam param) {
    if (param == null || String.isBlank(param.clientTier))
      return 0;
    List<ASFRates__c> fullRates = ASFRates__c.getAll().values();
    fullRates.sort();
    Decimal r = 0.0;
    for (ASFRates__c rate : fullRates) {
      if ('Gold Club'.equals(param.clientTier)) {
        if (param.clientRate >= rate.Gold_Club_Rate__c) {
          r = rate.Gold_Club_Comm__c;
        }
      } else if ('Drive More Plus'.equals(param.clientTier)) {
        if (param.clientRate >= rate.Drive_More_Plus_Rate__c) {
          r = rate.Drive_More_Plus_Comm__c;
        }
      } else if ('Drive More'.equals(param.clientTier)) {
        if (param.clientRate >= rate.Drive_More_Rate__c) {
          r = rate.Drive_More_Comm__c;
        }
      } else if ('Autoline Plus'.equals(param.clientTier)) {
        if (param.clientRate >= rate.Autoline_Plus_Rate__c) {
          r = rate.Autoline_Plus_Comm__c;
        }
      } else if ('Autoline'.equals(param.clientTier)) {
        if (param.clientRate >= rate.Autoline_Rate__c) {
          r = rate.Autoline_Comm__c;
        }
      } else if ('Autoline (Credit Impaired)'.equals(param.clientTier)) {
        if (param.clientRate >= rate.Autoline_Credit_Impaired_Rate__c) {
          r = rate.Autoline_Credit_Impaired_Comm__c;
        }
      }
    }
    return r;
  }

  public static Decimal getAfsCommercialMinBaseRate(CalcParam param) {
    if (param == null || String.isBlank(param.clientTier))
      return 0;
    List<AFS_Commercial_Rates__c> fullRates = AFS_Commercial_Rates__c.getAll()
      .values();
    fullRates.sort();
    //System.debug('Total rates >> ' + fullRates.size() + '|param.clientTier: ' + param.clientTier);
    AFS_Commercial_Rates__c rate = fullRates.get(0);

    Decimal r = 0.0;
    if ('New - 6 years old'.equals(param.clientTier)) {
      r = rate.Rate__c;
    } else if ('Used 7 years+'.equals(param.clientTier)) {
      for (AFS_Commercial_Rates__c a : fullRates) {
        if (a.Comm_8_Years__c != null && a.Comm_8_Years__c > 0.0) {
          r = a.Rate_2__c;
          break;
        }
      }
    }
    return r;
  }

  public static Decimal getAfsCommercialMaxBaseRate(CalcParam param) {
    if (param == null || String.isBlank(param.clientTier))
      return 0;
    List<AFS_Commercial_Rates__c> fullRates = AFS_Commercial_Rates__c.getAll()
      .values();
    fullRates.sort();
    AFS_Commercial_Rates__c rate = fullRates.get(fullRates.size() - 1);
    Decimal r = rate.Rate__c;
    return r;
  }

  // public static Decimal getAfsCommercialCommission(CalcParam param) {
  //   if (param == null || String.isBlank(param.clientTier))
  //     return 0;
  //   List<AFS_Commercial_Rates__c> fullRates = AFS_Commercial_Rates__c.getAll()
  //     .values();
  //   fullRates.sort();
  //   //System.debug('Total rates >> ' + fullRates.size() + '|param.clientTier: ' + param.clientTier);

  //   Decimal r = 0.0;
  //   for (AFS_Commercial_Rates__c rate : fullRates) {
  //     if (param.clientRate >= rate.Rate__c) {
  //       if ('0-7 years'.equals(param.clientTier)) {
  //         r = rate.Comm_07_Years__c;
  //       } else if ('8 years +'.equals(param.clientTier)) {
  //         r = rate.Comm_8_Years__c;
  //       }
  //     }
  //   }
  //   return r;
  // }

  private static Decimal getRateLatitudeBaseRate(
    CalcParam param,
    Boolean isMaxRate
  ) {
    List<LatitudeRatesv3__c> rateList = getLatitudeRatesByClass(
      param.goodsType,
      param.loanTypeDetail,
      param.carAge
    );
    Decimal minRate = 0.0;
    Decimal maxRate = 0.0;
    if (rateList != null && !rateList.isEmpty()) {
      minRate = rateList[0].Rate__c;
      maxRate = rateList[rateList.size() - 1].Rate__c;
    }
    if (isMaxRate) {
      return maxRate;
    }
    return minRate;
  }

  private static Decimal getRateLatitudePLBaseRate(
    CalcParam param,
    Boolean isMaxRate
  ) {
    Decimal r = 0.0;
    List<LatitudePersonalRates__c> rates = LatitudePersonalRates__c.getAll()
      .values();
    rates.sort();
    for (LatitudePersonalRates__c a : rates) {
      if (param.loanTypeDetail.equals(a.Risk_Grade__c)) {
        if ('Secured'.equals(param.customerProfile)) {
          r = a.Secured__c;
        } else {
          r = a.Unsecured__c;
        }
      }
    }
    if (r > 0 && isMaxRate) {
      r += 10;
    }
    return r;
  }

  private static Decimal getRateGreenLightBaseRate(CalcParam param) {
    GreenLightRates__c g = getRateGreenLight(param);
    if (g != null) {
      return g.Base_Rate__c;
    }
    return 0.00;
  }

  public static Decimal getGreenLightMaxRate(CalcParam param) {
    GreenLightRates__c g = getRateGreenLight(param);
    if (g != null) {
      return g.Max_Rate__c;
    }
    return 0.00;
  }

  public static void loadGreenLightRates() {
    if (greenLightRatesMap == null) {
      List<GreenLightRates__c> data = GreenLightRates__c.getAll().values();
      greenLightRatesMap = new Map<String, Map<String, List<GreenLightRates__c>>>();
      if (data != null) {
        data.sort();
        for (GreenLightRates__c g : data) {
          Map<String, List<GreenLightRates__c>> assetList = greenLightRatesMap.get(
            g.Asset_Type__c
          );
          // Asset Type
          if (assetList == null) {
            assetList = new Map<String, List<GreenLightRates__c>>();
            greenLightRatesMap.put(g.Asset_Type__c, assetList);
          }
          // Tier
          List<GreenLightRates__c> grs = assetList.get(g.Tier__c);
          if (grs == null) {
            grs = new List<GreenLightRates__c>();
            assetList.put(g.Tier__c, grs);
          }
          grs.add(g);
        }
      }
    }
    System.debug('loadGreenLightRates... ' + greenLightRatesMap.size());
  }

  public static GreenLightRates__c getRateGreenLight(CalcParam param) {
    loadGreenLightRates();
    GreenLightRates__c r = null;
    // System.debug('Checking rates for Asset Type => ' + param.assetType);
    Map<String, List<GreenLightRates__c>> d = greenLightRatesMap.get(param.assetType);
    if (d != null && String.isNotBlank(param.vehicleYear) && param.vehicleYear.isNumeric()) {
      // System.debug('Checking rates for Client Tier => ' + param.clientTier);
      List<GreenLightRates__c> rates = d.get(param.clientTier);
      if (rates != null) {
        if (rates.size() == 1) {
          r = rates.get(0);
        } else {
          String vy = '';
          Integer a = Date.today().year() - Integer.valueOf(param.vehicleYear);
          if (a >= 0 && a <= 3) {
            vy = 'New to 3 years';
          } else if (a >= 4 && a <= 7) {
            vy = '4 to 7 years';
          } else if (a >= 8) {
            vy = '8 or more years';
          }
          // System.debug('Checking rates for vehicle => ' + param.vehicleYear + '|' + vy + '|' + param.ltv + '|' + rates.size());
          for (GreenLightRates__c g: rates) {
            // System.debug('[' + g.LVR__C + '|' + param.ltv + '] [' + g.Vehicle_Age__c + '|' + vy + ']');
            if ('Car'.equals(param.assetType) && g.Asset_Type__c.equals(param.assetType)) {
              if (
                g.Tier__c.equals(param.clientTier) &&
                String.isNotBlank(g.LVR__c) &&
                String.isNotBlank(g.Vehicle_Age__c) &&
                g.LVR__c.equals(param.ltv) &&
                g.Vehicle_Age__c.equals(vy)
              ) {
                r = g;
                // System.debug('Rate found it! ' + r);
                break;
              }
            } else if ('Motorcycle'.equals(param.assetType) && g.Asset_Type__c.equals(param.assetType)) {
              if (g.Tier__c.equals(param.clientTier)) {
                r = g;
                // System.debug('Rate found it! ' + r);
                break;
              }
            }
          }
        }
      }
    }
    return r;
  }

  public static Set<String> getGreenLightProducts(CalcParam param) {
    loadGreenLightRates();
    return greenLightRatesMap.get(param.assetType).keySet();
  }

  public static Decimal wisrApplicationFee(Decimal baseComm) {
    initWisrRates();
    Decimal r = 0;
    Decimal topAmount = baseComm;
    if (topAmount > 50000) {
      topAmount = 50000.0;
    }
    for (Wisr_Fee_Rate__c a : wisrRates) {
      if (topAmount >= a.Loan_Min__c && topAmount <= a.Loan_Max__c) {
        r = a.Loan_Fee__c;
      }
    }
    return r;
  }

  private static void initWisrRates() {
    if (wisrRates == null) {
      wisrRates = [
        SELECT DOF_Max__c, Loan_Fee__c, Loan_Max__c, Loan_Min__c
        FROM Wisr_Fee_Rate__c
        ORDER BY Name
      ];
      wisrRates.sort();
    }
  }

  public static Decimal wisrMaxDOF(Decimal baseComm) {
    Decimal r = 0;
    initWisrRates();
    for (Wisr_Fee_Rate__c a : wisrRates) {
      if (baseComm >= a.Loan_Min__c && baseComm <= a.Loan_Max__c) {
        r = a.DOF_Max__c;
      }
    }
    if (r == 0 && !wisrRates.isEmpty()) {
      r = wisrRates.get(wisrRates.size() - 1).DOF_Max__c;
    }
    //if (baseComm >= 5000 && baseComm < 7500) {
    //    r = 500;
    //} else if (baseComm >= 7500 && baseComm < 10000) {
    //    r = 750;
    //} else if (baseComm >= 10000 && baseComm < 20000) {
    //    r = 900;
    //} else if (baseComm >= 20000 && baseComm < 35000) {
    //    r = 990;
    //} else if (baseComm >= 35000) {
    //    r = 990;
    //}
    return r;
  }

  public static Map<String, MetroPlanOption__c> getMetroPlanOptions() {
    if (metroPlanOptions == null) {
      metroPlanOptions = new Map<String, MetroPlanOption__c>();
      List<MetroPlanOption__c> d = MetroPlanOption__c.getAll().values();
      d.sort();
      for (MetroPlanOption__c m : d) {
        metroPlanOptions.put(m.Name, m);
      }
    }
    return metroPlanOptions;
  }

  public static Decimal getAFSConsumerBaseRate(
    CalcParam param,
    Boolean isMaxRate
  ) {
    Decimal r = 0.00;
    if (param != null) {
      AFSRateV2__c rate = getAFSConsumerRate(param);
      if (rate != null) {
        r = rate.Rate__c;

        // AFS quoting tool change -removal of rate loading
        // https://savvy-league.monday.com/boards/164662384/pulses/2271425059
        // LVR
        /*
        if (String.isNotBlank(param.ltv) && param.ltv.isNumeric()) {
          Integer lvr = Integer.valueOf(param.ltv);
          if (lvr > 120 && lvr <= 140) {
            r += 1.0;
            // } else if (lvr > 140 && lvr <= 150) {
          } else if (lvr > 140) {
            r += 2.0;
          }
        }
        */
        // Credit Impaired
        if ('Y'.equals(param.bankrupt)) {
          r += 2.5;
        }

        // Pay Day Enquiries
        if ('Over 6 months ago'.equals(param.riskGrade)) {
          r += 2.0;
        }

        // Imports
        if ('Y'.equals(param.hasImports)) {
          r += 1.0;
        }

        // Leisure
        if (
          'Leisure'.equals(param.assetType) && 'Used'.equals(param.condition)
        ) {
          r += 1.0;
        }

        // Odometer
        if ('>200,000'.equals(param.vehiclesProfile)) {
          r += 1.0;
        }

        // Lelo - 2022-06-28
        // Residency
        // if ('Property Owner'.equals(param.residency) && param.term > 60) {
        if (param.term > 60) {
          r += 0.5;
        }

        // Private Sales
        if ('Y'.equals(param.privateSales)) {
          r += 0.7;
        }

        // Casual < 12 or Contract
        if ('Y'.equals(param.customerProfile)) {
          r += 1.0;
        }

        if (!isMaxRate) {
          r = r - 2;
        }
      } else {
        if ('Gold Club - Non-Property'.equals(param.productLoanType)) {
          r = 7.47;
        }
      }
    }
    return r;
  }

  public static AFSRateV2__c getAFSConsumerRate(CalcParam param) {
    AFSRateV2__c r = null;

    if ('Gold Club - Non-Property'.equals(param.productLoanType)) {
      return r;
    }
    String plan = null;
    String condition = param.condition;
    String risk = null;
    String assetType = param.assetType;

    // identify Plan
    if ('Property Owner'.equals(param.residency)) {
      plan = 'Property Owner';
    } else if ('Renting'.equals(param.residency)) {
      plan = 'Non-Property Owner - Renter';
    } else if (String.isNotBlank(param.residency)) {
      plan = 'Non-Property Owner - Other';
    }

    // Checking the Risk
    if ('New/Demo'.equals(condition)) {
      if (param.vehiclePrice >= 35000.0) {
        risk = '>= $35k';
      } else {
        risk = '< $35K';
      }
    } else if ('Used'.equals(condition)) {
      risk = param.vehicleYear;
    }
    // Validate query params
    if (
      String.isBlank(plan) ||
      String.isBlank(condition) ||
      String.isBlank(risk)
    )
      return r;
    List<AFSRateV2__c> d = [
      SELECT Rate__c, Comm__c
      FROM AFSRateV2__c
      WHERE
        Asset_Type__c = :assetType
        AND Plan__c = :plan
        AND Condition__c = :condition
        AND Risk_Grade__c = :risk
    ];
    if (!d.isEmpty()) {
      r = d.get(0);
    }
    return r;
  }

  //Pepper MV Commission Rate
  public static Decimal getPepperCommercialCommission(CalcParam param) {
    if (
      param == null || String.isBlank(param.clientTier) ||
      param.clientRate == null
    )
      return 0.0;
    if (
      'LEISURE'.equals(param.customerProfile) ||
      'CARAVAN'.equals(param.customerProfile)
    ) {
      List<PepperLeisure__c> d = [
        SELECT Comms__c
        FROM PepperLeisure__c
        WHERE Tier__c = :param.clientTier AND Rates__c <= :param.clientRate
        ORDER BY Rates__c DESC
      ];
      if (!d.isEmpty()) {
        return d.get(0).Comms__c;
      }
    } else {
      String tier = param.clientTier;
      List<PepperMV__c> d = [
        SELECT Comms__c
        FROM PepperMV__c
        WHERE Tier__c = :tier AND Rates__c <= :param.clientRate
        ORDER BY Rates__c DESC
      ];
      if (!d.isEmpty()) {
        return d.get(0).Comms__c;
      }
    }
    return 0.0;
  }

  // public static Decimal getPepperConsumerCommission(CalcParam param) {
  //     if (param == null  || String.isBlank(param.clientTier) || param.clientRate == null) return 0.0;
  //     List<Pepper_Summer_Rates__c> d = null;
  //     if ('A'.equals(param.clientTier)) {
  //         d = [
  //             SELECT Tier_A_Comm__c FROM Pepper_Summer_Rates__c
  //             WHERE Rate__c <= :param.clientRate
  //             ORDER BY Rate__c DESC
  //         ];
  //     } else {
  //         d = [
  //             SELECT Tier_A_Comm__c FROM Pepper_Summer_Rates__c
  //             WHERE Tier_B__c <= :param.clientRate
  //             ORDER BY Tier_B__c DESC
  //         ];
  //     }
  //     if (!d.isEmpty()) {
  //         return d.get(0).Tier_A_Comm__c;
  //     }
  //     return 0.0;
  // }

  public static Decimal getMoney3maxDof(CalcParam param) {
    Decimal r = 0.0;
    if (
      param == null ||
      param.totalAmount == null ||
      String.isBlank(param.customerProfile) ||
      String.isBlank(param.riskGrade)
    ) {
      return r;
    }

    Decimal vp = param.getNaf();
    if ('Asset Finance'.equals(param.customerProfile)) {
      if ('Micro Motor'.equals(param.riskGrade)) {
        if (param.totalAmount >= 2000.0 && param.totalAmount < 3000.0) {
          r = 220.0;
        } else if (param.totalAmount >= 3000.0 && param.totalAmount < 5000.0) {
          r = 330.0;
        } else if (param.totalAmount >= 5000.0 && param.totalAmount < 6000.0) {
          r = 440.0;
        } else if (param.totalAmount >= 6000.0 && param.totalAmount < 7000.0) {
          r = 550.0;
        } else if (param.totalAmount >= 7000.0) {
          r = 880.0;
        }
      } else {
        if (param.totalAmount >= 8000.0 && param.totalAmount < 9000.0) {
          r = 770.0;
        } else if (param.totalAmount >= 9000.0 && param.totalAmount < 10000.0) {
          r = 880.0;
        } else if (
          param.totalAmount >= 10000.0 &&
          param.totalAmount < 11000.0
        ) {
          r = 990.0;
        } else if (
          param.totalAmount >= 11000.0 &&
          param.totalAmount < 12000.0
        ) {
          r = 1100.0;
        } else if (
          param.totalAmount >= 12000.0 &&
          param.totalAmount < 16000.0
        ) {
          r = 1210.0;
        } else if (param.totalAmount >= 16000.0) {
          r = 1320.0;
        }
      }
    } else if ('Personal Finance'.equals(param.customerProfile)) {
      if ('Mini PL'.equals(param.riskGrade)) {
        if (param.totalAmount >= 2000.0 && param.totalAmount < 3000.0) {
          r = 220.0;
        } else if (param.totalAmount >= 3000.0 && param.totalAmount < 5000.0) {
          r = 330.0;
        } else if (param.totalAmount == 5000.0) {
          r = 440.0;
        }
      } else {
        if (param.totalAmount >= 5000.0 && param.totalAmount < 6000.0) {
          r = 440.0;
        } else if (param.totalAmount >= 6000.0 && param.totalAmount < 7000.0) {
          r = 550.0;
        } else if (param.totalAmount >= 7000.0 && param.totalAmount < 8001.0) {
          r = 660.0;
        } else if (param.totalAmount >= 8001.0 && param.totalAmount < 9000.0) {
          r = 770.0;
        } else if (param.totalAmount >= 9000.0 && param.totalAmount < 10000.0) {
          r = 880.0;
        } else if (
          param.totalAmount >= 10000.0 &&
          param.totalAmount < 11000.0
        ) {
          r = 990.0;
        } else if (
          param.totalAmount >= 11000.0 &&
          param.totalAmount < 12000.0
        ) {
          r = 1100.0;
        } else if (param.totalAmount >= 12000.0) {
          r = 1210.0;
        }
      }
    }
    System.debug(r);
    return r;
  }

  //Lelo              2017-07-24
  private static Application_Quoting_Result__c calculateGreenLight(
    CalcParam param
  ) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();

    // calculate the payment rate based on client rate, which is determined by consultants
    decimal realRate = param.clientRate / 100;
    decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );
    // System.debug('The calculated rate is: ' + rate);

    Decimal rentTerm = param.term;
    if (param.residualValue > 0) {
      //rentTerm = rentTerm - 1;      // 2018-08-14
    }

    r.Rental__c = FinancialUtilities.pmt(
      param.getNaf(),
      rate,
      rentTerm,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    //System.debug('Rental: ' + r.Rental__c + '|' + param.getNaf() + '|' + rate + '|' + rentTerm + '|' + param.residualValue + '|' + param.getPaymentTypeBoolean());
    r.Rental__c = r.Rental__c.setScale(2);

    // calculate the estimated commission
    //Decimal finalCommRate = (param.brokeragePer - (param.baseRate + 2 - param.clientRate));
    Decimal finalCommRate = 0.0;
    if (
      'Bronze'.equals(param.clientTier) ||
      'Budget Loan'.equals(param.clientTier)
    ) {
      finalCommRate = param.brokeragePer;
    } else {
      if (param.clientRate < param.baseRate) {
        finalCommRate = 0.0;
      } else if (param.clientRate > (param.baseRate + 2)) {
        finalCommRate = param.brokeragePer;
      } else {
        finalCommRate =
          (Math.abs(param.clientRate - param.baseRate) / 2.00) *
          param.brokeragePer;
      }
    }

    Decimal commbase = param.amountBaseComm;

    System.debug(
      'finalCommRate: ' +
      param.clientTier +
      ' | ' +
      finalCommRate +
      ' | ' +
      commbase +
      ' | ' +
      param.clientRate +
      '|' +
      param.baseRate +
      '|' +
      param.brokeragePer
    );
    r.Estimated_Commission__c = finalCommRate / 100 * commbase;
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);
    //System.debug('Commission: ' + r.Estimated_Commission__c);

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();

    return r;
  }

  public static boolean deleteQuotingApplication(Custom_Opportunity__c Opp) {
    boolean isDeleteAppQuoting = false;
    if (Opp != null) {
      List<Application_Quoting__c> apps = [
        SELECT id
        FROM Application_Quoting__c
        WHERE Opportunity__c = :Opp.Id
      ];
      if (apps.size() > 0) {
        Application_Quoting__c app = apps.get(0);
        if (app != null) {
          delete [
            SELECT Id
            FROM Application_Quoting_Result__c
            WHERE Application_Quoting__c = :app.Id
          ];
          delete [
            SELECT Id
            FROM Application_Quoting__c
            WHERE Opportunity__c = :Opp.Id
          ];
          isDeleteAppQuoting = true;
        }
      }
    }
    return isDeleteAppQuoting;
  }

  public static Decimal getMoney3BaseRate(CalcParam param) {
    if (param != null && String.isNotBlank(param.riskGrade)) {
      if ('Platinum'.equals(param.riskGrade)) {
        return 19.95;
      } else if ('Gold'.equals(param.riskGrade)) {
        return 22.0;
      } else if ('Silver'.equals(param.riskGrade)) {
        return 25.0;
      } else if ('Bronze'.equals(param.riskGrade)) {
        return 28.0;
      } else if ('Micro Motor'.equals(param.riskGrade)) {
        return 24.95;
      } else if ('Mini PL'.equals(param.riskGrade)) {
        return 28.0;
      }
    }
    return 0.0;
  }

  public static Decimal getMoney3RiskFee(CalcParam param) {
    Decimal r = 0.0;
    if (
      param != null &&
      param.riskFeeBase != null &&
      param.riskFeeBase > 12000
    ) {
      r = param.riskFeeBase * 5 / 100.0;
      if (r > 995.0) {
        r = 995.0;
      }
    }
    return r.setScale(2);
  }

  public static Decimal getMoney3CommPercentage(CalcParam param) {
    Decimal r = 0.0;
    if (
      param != null && String.isNotBlank(param.customerProfile) &&
      String.isNotBlank(param.riskGrade) &&
      'Asset Finance'.equals(param.customerProfile) &&
      param.amountBaseComm > 10000
    ) {
      if ('Platinum'.equals(param.riskGrade)) {
        r = 4.0;
      } else if ('Gold'.equals(param.riskGrade)) {
        r = 3.0;
      } else if ('Silver'.equals(param.riskGrade)) {
        r = 2.0;
      }
    }
    return r;
  }

  public static List<MacquarieConsumerRatesv2__c> getMacquarieRates(
    String loanProduct
  ) {
    if (String.isNotBlank(loanProduct)) {
      if (macquarieRatesMap == null) {
        List<MacquarieConsumerRatesv2__c> d = MacquarieConsumerRatesv2__c.getAll()
          .values();
        d.sort();
        macquarieRatesMap = new Map<String, List<MacquarieConsumerRatesv2__c>>();
        for (MacquarieConsumerRatesv2__c a : d) {
          List<MacquarieConsumerRatesv2__c> m = macquarieRatesMap.get(
            a.Loan_Product__c
          );
          if (m == null) {
            m = new List<MacquarieConsumerRatesv2__c>();
            macquarieRatesMap.put(a.Loan_Product__c, m);
          }
          m.add(a);
        }
      }
      return macquarieRatesMap.get(loanProduct);
    }
    return new List<MacquarieConsumerRatesv2__c>();
  }

  public static void loadBasicRates() {
    if (basicRatesMap == null) {
      basicRatesMap = new Map<String, Map<String, BasicLenderRates__c>>();
      List<BasicLenderRates__c> d = BasicLenderRates__c.getall().values();
      for (BasicLenderRates__c a : d) {
        Map<String, BasicLenderRates__c> lender = basicRatesMap.get(
          a.Lender__c
        );
        if (lender == null) {
          lender = new Map<String, BasicLenderRates__c>();
          basicRatesMap.put(a.Lender__c, lender);
        }
        lender.put(a.Profile__c, a);
      }
    }
  }

  public static Map<String, BasicLenderRates__c> getBasicRates(String lender) {
    loadBasicRates();
    if (String.isNotBlank(lender)) {
      if (basicRatesMap.containsKey(lender)) {
        return basicRatesMap.get(lender);
      }
    }
    return new Map<String, BasicLenderRates__c>();
  }

  public static Set<String> getBasicRateProfiles(String lender) {
    loadBasicRates();
    if (String.isNotBlank(lender)) {
      if (basicRatesMap.containsKey(lender)) {
        return basicRatesMap.get(lender).keySet();
      }
    }
    return new Set<String>();
  }

  public static List<BasicLenderRates__c> listBasicRates(String lender) {
    loadBasicRates();
    List<BasicLenderRates__c> r = new List<BasicLenderRates__c>();
    if (String.isNotBlank(lender) && basicRatesMap.containsKey(lender)) {
      Map<String, BasicLenderRates__c> d = basicRatesMap.get(lender);
      for (String k : d.keySet()) {
        r.add(d.get(k));
      }
    }
    return r;
  }

  public static Decimal getAffordableBaseRate(
    CalcParam param,
    Boolean isMaxRate
  ) {
    Decimal r = 0.0;
    BasicLenderRates__c rate = getAffordableRate(param);
    if (rate != null) {
      if (isMaxRate) {
        r = rate.Rate_2__c;
      } else {
        r = rate.Rate_1__c;
      }
      // check vehicle year
      if (
        String.isNotBlank(param.vehicleYear) && param.vehicleYear.isNumeric()
      ) {
        Integer a = Date.today().year() - Integer.valueOf(param.vehicleYear);
        if (a >= 8) {
          r += 1.0;
        } else if (a > 2) {
          r += 0.5;
        }
      }
    }
    return r;
  }

  public static BasicLenderRates__c getAffordableRate(CalcParam param) {
    //if (param != null && String.isNotBlank(param.clientTier)) {
    if (param != null && String.isNotBlank(param.creditScore)) {  
      Map<String, BasicLenderRates__c> lender = getBasicRates(param.lender);
      //if (lender != null && lender.containsKey(param.clientTier)) {
      if (lender != null && lender.containsKey(param.creditScore)) {
        return lender.get(param.creditScore);
      }
    }
    return null;
  }

  public static ACLUpfrontLoanFees__c getAffordableFees(Decimal rate) {
    List<ACLUpfrontLoanFees__c> d = ACLUpfrontLoanFees__c.getall().values();
    d.sort();
    ACLUpfrontLoanFees__c r = null;
    for (ACLUpfrontLoanFees__c x : d) {
      if (rate >= x.Min_Interest_Rate__c && rate <= x.Max_Interest_Rate__c) {
        r = x;
        // dto.maxApplicationFee = x.Establishment_Fee__c;
        // dto.riskFeeTotal = (((myRate/100)*(x.Risk_Fee_Interest_Rate_Of_NAF__c/100)*getLoandTermInYears())*getNAF()).setScale(2);
      }
    }
    return r;
  }

  public static CarStartFinanceRate__c getCarStartFinance(CalcParam param) {
    CarStartFinanceRate__c r = null;

    List<CarStartFinanceRate__c> d = [
      SELECT
        Rate__c,
        Rate_Max__c,
        App_Fee__c,
        Dof__c,
        Dof_Max__c,
        Max_Loan__c,
        Min_Loan__c,
        Monthly_Fee__c,
        Risk_Fee__c,
        Risk_Fee_Max__c,
        Standard_Commission__c,
        Standard_Commission_Max__c,
        Type_of_Finance__c
      FROM CarStartFinanceRate__c
      WHERE Type_of_Finance__c = :param.loanTypeDetail
    ];
    if (!d.isEmpty()) {
      r = d.get(0);
    }

    return r;
  }

  public static Decimal getCarStartFinanceBaseRate(CalcParam param) {
    Decimal r = 0.0;
    CarStartFinanceRate__c c = getCarStartFinance(param);
    if (c != null) {
      r = c.Rate__c;
    }
    return r;
  }

  public static Decimal getCarStartFinanceMaxRate(CalcParam param) {
    CarStartFinanceRate__c c = getCarStartFinance(param);
    if (c != null) {
      return c.Rate_Max__c;
    }
    return 0.00;
  }

  /**
   * @description       :
   * @author            : Girish P
   * @group             :
   * @last modified on  : 08-19-2021
   * @last modified by  : Girish P
   **/
  private static Application_Quoting_Result__c calculateBOQCommercial(
    CalcParam param
  ) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();

    // calculate the payment rate based on client rate, which is determined by consultants
    decimal realRate = param.baseRate / 100;
    decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    r.Rental__c = FinancialUtilities.pmt(
      param.amountBasePmt,
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);

    r.Estimated_Commission__c = param.brokeragePer / 100 * param.amountBaseComm;
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);
    system.debug(r + 'r**********');
    r.recalculateFormulas();

    return r;
  }

  public static Azora_Rates__c getAzora(CalcParam param) {
    Azora_Rates__c r = null;

    List<Azora_Rates__c> d = [
      SELECT
        Rate__c,
        Risk_Fee__c,
        Max_Loan__c
      FROM Azora_Rates__c
      WHERE Credit_Score__c = :param.loanTypeDetail
    ];
    if (!d.isEmpty()) {
      r = d.get(0);
    }

    return r;
  }

  private static Application_Quoting_Result__c calculateGCA(CalcParam param) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();

    // calculate the payment rate based on client rate, which is determined by consultants
    decimal realRate = param.baseRate / 100;
    
    decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    
    decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    r.Rental__c = FinancialUtilities.pmt(
      param.amountBasePmt,
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);

    r.Estimated_Commission__c = param.brokeragePer / 100 * param.amountBaseComm;
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();

    return r;
  }

  private static Application_Quoting_Result__c calculateAngleFinance(CalcParam 
    param) {
    Application_Quoting_Result__c r = new Application_Quoting_Result__c();
    r.Payment_Calc_Type__c = 'DF';
    r.NAF__c = param.getNaf();

    // calculate the payment rate based on client rate, which is determined by consultants
    decimal realRate = param.clientRate / 100;
    
    decimal futureValue = FinancialUtilities.fv(realRate / 12, 12, 1000);
    
    decimal rate = FinancialUtilities.rate(
      1000,
      12,
      0,
      futureValue,
      realRate / 12,
      false
    );

    r.Rental__c = FinancialUtilities.pmt(
      param.amountBasePmt,
      rate,
      param.term,
      param.residualValue,
      param.getPaymentTypeBoolean()
    );
    r.Rental__c = r.Rental__c.setScale(2);

    r.Estimated_Commission__c = (param.brokeragePer / 100 * 
    param.amountBaseComm) / 1.1;
    r.Estimated_Commission__c = r.Estimated_Commission__c.setScale(2);

    //calculate the insurance income
    r.Insurance_Income__c = param.totalInsuranceIncome;
    r.Insurance_Income__c = r.Insurance_Income__c / 1.1;
    r.Insurance_Income__c = r.Insurance_Income__c.setScale(2);

    // calculate the dof without GST
    r.DOF__c = param.dof / 1.1;
    r.DOF__c = r.DOF__c.setScale(2);

    // calculate the monthly payment
    r.Monthly_Payment__c = r.Rental__c + param.monthlyFee;
    r.Monthly_Payment__c = r.Monthly_Payment__c.setScale(2);

    r.recalculateFormulas();

    return r;
  }
  //Shift Asset --> BaseRateCalc
  private static Decimal getShiftAssetBaseRate(CalcParam param) {
      Decimal r = 0.0;
      system.debug('param***'+param);
      String loanAmount = 'Up to $250,000';
      if(param.totalAmount > 250000){
          loanAmount = 'Over $250,000';
          if(param.assetAge != 'New to 4 years'){
              loanAmount = 'Up to $250,000';
              param.assetType = '';
              param.assetAge = 'Other';
          }
      }else{
          if(param.assetType == 'Secondary Assets' && param.assetAge == '20+ years'){
              param.assetAge = '11+ years';
          }else if(param.assetType == 'Tertiary Assets' && param.assetAge == 'New to 4 years'){
              param.assetAge = 'New only';
          }else if(param.assetType == 'Tertiary Assets' && param.assetAge != 'New to 4 years'){
              param.assetType = '';
              param.assetAge = 'Other';
          }else if(param.assetType == 'Fitout Finance'){
              param.assetAge = 'Professional';
          }
      }
      
      List<Get_Capital_Rates__c> getCapitalRateList = [Select Name, Age_of_Asset__c , Non_Property_Backed__c , Property_Backed__c , Type_of_Asset__c from Get_Capital_Rates__c where
                                                       Princing_fees_and_commission__c = :loanAmount AND
                                                       Age_of_Asset__c = :param.assetAge AND
                                                       Type_of_Asset__c = :param.assetType
                                                       order by Name asc];
      system.debug('getCapitalRateList***'+getCapitalRateList);
      
      if(getCapitalRateList.size() > 0){
          try{
              if(param.customerProfile == 'N'){
                  String strval = getCapitalRateList[0].Non_Property_Backed__c.replace('%','');
                  r  = Decimal.valueOf(strval); 
              }else if(param.customerProfile == 'Y'){
                  String strval = getCapitalRateList[0].Property_Backed__c.replace('%','');
                  r  = Decimal.valueOf(strval);
              }
          }
          catch(exception e){
              r = 14.95;
          }
      }
      
      if(param.privateSales == 'Y'){
          r = r + 0.5;
      }
      if(param.loanType == 'Refinance' || param.loanType == 'Sale and Leaseback'){
          r = r + 0.5;
      }else if(param.loanType == 'Equity Raise'){
          r = r + 2.5;
      }
      if(param.brokeragePer > 5){
          decimal excess = param.brokeragePer - 5;
          Integer additional = excess.intValue();
          r = r + additional*0.5;
      }
      return r;
  }
    
    
  //Get Capital OTL --> BaseRateCalc
  private static Decimal getShiftOTLBaseRate(CalcParam param) {
      Decimal r = 0.0;
      system.debug('param***'+param);
      
      r = 24.95;
      return r;
  }
  
  private static Decimal getGetGrowAssetCarBaseRate(CalcParam param) {
    Decimal r = 0.0;
    system.debug('param***'+param);
    
    String abnLengthSearch = '';
    String assetAgeSearch = '';
    Decimal assetAgeEndOfTerm = Integer.valueOf(param.assetAge) + param.term / 12;
    String tier;
  
    if ((assetAgeEndOfTerm) <= 7) {
      assetAgeSearch = '0-7 years';
    } else if ((assetAgeEndOfTerm ) <= 15) {
      assetAgeSearch = '8-15 years';
    }
  
    if(param.assetType == 'Tier 1 - Cars'){
      tier = 'Tier 1';
    } else if (param.assetType == 'Tier 2 - Trucks yellow goods') {
      tier = 'Tier 2';
      if (assetAgeSearch == '' && (assetAgeEndOfTerm) <= 25) {
        assetAgeSearch = '16-25 years';
      }
    } else if (param.assetType == 'Tier 3 - Specialised') {
      tier = 'Tier 3';
      assetAgeSearch = 'New';
      if (param.condition == 'Used') {
        assetAgeSearch = 'Used';
      }
    }
  
    List <Grow_Asset_Car_Rates__c> rates;
  
    if (tier != null && assetAgeSearch != '') {
      rates = [select Asset_backed__c, Non_Asset_backed__c from 
        Grow_Asset_Car_Rates__c where Asset_type__c =: tier AND Asset_age__c =: 
          assetAgeSearch];
    }
  
    if (rates != null) {
      try {
        if(param.customerProfile == 'Y'){
          r = Decimal.valueOf(rates[0].Asset_backed__c.replace('%',''));
        }else{
          r = Decimal.valueOf(rates[0].Non_Asset_backed__c.replace('%',''));
        }
      } catch (Exception e) {}
      
      rates = [select Additional_rate__c, Condition__c from 
        Grow_Asset_Car_Rates__c];
  
      for (Grow_Asset_Car_Rates__c rate : rates) {
  
        if ('Company score < 500'.equals(rate.Condition__c)) {
          if(param.companyScore == '< 500'){
            r = r + Decimal.valueOf(rate.Additional_rate__c.replace('%',''));
          }
        }
        
        if ('Director score < 600'.equals(rate.Condition__c)) {
          if(param.directorSoleTraderScore == '< 600'){
            r = r + Decimal.valueOf(rate.Additional_rate__c.replace('%',''));
          }
        }
        
        if ('Private sales'.equals(rate.Condition__c)) {
          if(param.privateSales == 'Y'){
            r = r + Decimal.valueOf(rate.Additional_rate__c.replace('%',''));
          }
        }
        
        if ('Term > 60 months'.equals(rate.Condition__c)) {
          if(param.term > 60){
            r = r + Decimal.valueOf(rate.Additional_rate__c.replace('%',''));
          }
        }
        
        if ('ABN / GST age < 24 months'.equals(rate.Condition__c)) {
          if(param.abnLength == '> 12 months' || param.gstLength == '< 2 years'){
            r = r + Decimal.valueOf(rate.Additional_rate__c.replace('%',''));
          }
        }
        
        if (
          '<$5000 paid on adverse on file ( excludes paid Telco/utility < $ 1000)'
            .equals(rate.Condition__c)) {
          if(param.paidDefault == 'Oth Default <$5K'){
            r = r + Decimal.valueOf(rate.Additional_rate__c.replace('%',''));
          }
        }
        
        if ('Term < 24 months'.equals(rate.Condition__c)) {
          if(param.term < 24){
            r = r + Decimal.valueOf(rate.Additional_rate__c.replace('%',''));
          }
        }
      }
  
      if (param.brokeragePer > 5) {
        r += (param.brokeragePer - 5).intValue() * 0.5;
      }
    }
    
    /*
    if(param.assetType == 'Cars/Vans/Utes'){
        if(param.abnLength == '> 36 months'){
            abnLengthSearch = '> 36 Months ABN + GST';
        }else{
            abnLengthSearch = '< 36 Months ABN + GST';
        }
        
        if(Integer.valueOf(param.assetAge) <= 2){
            assetAgeSearch = 'New (0-2yrs old)';
        }else if(Integer.valueOf(param.assetAge) > 2){ 
            assetAgeSearch = 'Used';
        }
        
        List <Grow_Asset_Car_Rates__c> gacTier1 = [select id, name, ABN_length__c, Asset_age__c, Additional_rate__c, Asset_backed__c, Asset_type__c, Condition__c,  Non_Asset_backed__c from Grow_Asset_Car_Rates__c 
                                                    where Asset_type__c = 'Tier 1' 
                                                    AND ABN_length__c =:  abnLengthSearch 
                                                    AND Asset_age__c =: assetAgeSearch
                                                    order by name asc];
        
        if(param.customerProfile == 'Y'){
            r = Decimal.valueOf(gacTier1[0].Asset_backed__c.replace('%',''));
        }else{
            r = Decimal.valueOf(gacTier1[0].Non_Asset_backed__c.replace('%',''));
        }
    }else if(param.assetType == 'Auto'){
        
        if(Integer.valueOf(param.assetAge) <= 10){
            assetAgeSearch = 'New/Used (<= 10 years EOT)';
        }else if(Integer.valueOf(param.assetAge) <= 15){ 
            assetAgeSearch = 'Used (<= 15 years EOT)';
        }else if(Integer.valueOf(param.assetAge) <= 25){
            assetAgeSearch = 'Used (<= 25 years EOT)';
        }
        
        List <Grow_Asset_Car_Rates__c> gacTier1 = [select id, name, ABN_length__c, Asset_age__c, Additional_rate__c, Asset_backed__c, Asset_type__c, Condition__c,  Non_Asset_backed__c from Grow_Asset_Car_Rates__c 
                                                    where Asset_type__c = 'Tier 2' 
                                                    AND Asset_age__c =: assetAgeSearch
                                                    order by name asc];
        
        if(param.customerProfile == 'Y'){
            r = Decimal.valueOf(gacTier1[0].Asset_backed__c.replace('%',''));
        }else{
            r = Decimal.valueOf(gacTier1[0].Non_Asset_backed__c.replace('%',''));
        }
    }
    */
  
    /*
    if(param.privateSales == 'Y'){
        r = r + 0.5;
    }
    if(param.equifaxScore < 500){
        r = r + 0.5;
    }
    if(param.abnLength == '> 12 months'){
        r = r + 2;
    }
    if(param.term > 60){
        r = r + 0.5;
    }
    */
    return r;
  }
    
    private static Decimal getGetGrowBusinessLoanBaseRate(CalcParam param) {
      Decimal r = 0.0;
      system.debug('param***'+param);
      
      r = 11.95;
      return r;
    }
    
    private static Decimal getMorrisBaseRate(CalcParam param) {
      Decimal r = 0.0;
      system.debug('param***'+param);
      if(param.totalAmount < 250000 && param.totalAmount > 99999){
          r = 12.99;
      }else if(param.totalAmount < 50000 && param.totalAmount > 0){
          r = 16.99;
      }else if(param.totalAmount < 100000 && param.totalAmount > 49999){
          r = 14.99;
      }else{
          r = 12.99;
      }
      return r;
    }
    
    
    private static Decimal getAngleFinanceBaseRate(CalcParam param) {
      Decimal r = 0.0;
      system.debug('param***'+param);
      
      
      list<Angle_Finance_Rates__c> AFrate = new list<Angle_Finance_Rates__c>();
          
      if(Integer.valueOf(param.assetAge) < 6){
          AFrate = [select id,Name, ABN__c, Asset_age__c,   Asset_type__c,  End_of_Term__c, Property_Owner__c, Non_Property_Owner__c from Angle_Finance_Rates__c 
                                                  where Asset_age__c = 'Age 0-5'
                                                  AND ABN__c =: param.abnLength
                                                  AND Asset_type__c =: param.assetType order by name];
      }else{
          String EOT = '';
          if(param.endOfTerm < 16){
              EOT = 'End of Term 15';
          }else if(param.endOfTerm <= 20){
              EOT = 'End of Term 20';
          }
          AFrate = [select id,Name, ABN__c, Asset_age__c,   Asset_type__c,  End_of_Term__c, Property_Owner__c, Non_Property_Owner__c from Angle_Finance_Rates__c 
                                                  where Asset_age__c = null
                                                  AND Asset_type__c =: param.assetType
                                      AND ABN__c =: param.abnLength
                                      AND End_of_Term__c =: EOT order by name];
      }
      
      if(AFrate.size() > 0){
          if(param.customerProfile == 'Y' && AFrate[0].Property_Owner__c != 'N/A'){
              r = Decimal.valueOf(AFrate[0].Property_Owner__c.replace('%',''));
          }else if(AFrate[0].Non_Property_Owner__c != 'N/A'){
              r = Decimal.valueOf(AFrate[0].Non_Property_Owner__c.replace('%',''));
          }else{
              r = null;
          }
      }else{
          r = null;
      }
      
      return r;
    }
    
    private static Decimal getSelfcoBaseRate(CalcParam param) {
      Decimal r = 0.0;
      system.debug('param***'+param);
        
        
      if(param.customerProfile == 'Y'){
          if(param.tier == 'A'){
              r = 7.95;
          }else if(param.tier == 'B'){
              r = 8.95;
          }else if(param.tier == 'C'){
              r = 11.95;
          }
      }else if(param.customerProfile == 'N'){
          if(param.tier == 'A'){
              r = 9.95;
          }else if(param.tier == 'B'){
              r = 13.95;
          }else if(param.tier == 'C'){
              r = 13.95;
          }
      }
      
      if(param.privateSales == 'Y'){
          r = r + 1;
      }
      if(param.totalAmount > 25000){
          r = r + 2;
      }

      if(param.loanType == 'Sale and Leaseback'){
          r = r + 2;
      } 
      
      if(Integer.valueOf(param.assetAge) > 20 ){
          r = r + 2;
      }
      
      return r;
    }
    
  private static Decimal getCapitalFinanceBaseRate(CalcParam param) {
    Decimal r = 0.0;
    system.debug('param***'+param);
    
    for(Capital_Finance_Rates__c rec : [Select Id, Amount_Max__c, Amount_Min__c, Asset_Type__c, Loan_Type__c, Term_24_60_months__c, New_Primary__c, Used_Primary_4_years_old__c, Used_Primary_6_years_old__c 
                                        from Capital_Finance_Rates__c where Asset_Type__c =: param.assetType AND Term_24_60_months__c != 'Refer Small Ticket Bulletin'])
    {
      System.debug('**********************************************');
      System.debug('param.assetType => ' + param.assetType);
      System.debug('param.totalAmount => ' + param.totalAmount);
      System.debug('param.term => ' + param.term + ' ['+(param.term > 12)+']');
      System.debug('param.assetAge => ' + param.assetAge + ' ['+(param.assetAge == 'New - 4 years')+']');
      System.debug('rec.Asset_Type__c => ' + rec.Asset_Type__c + ' ['+(rec.Asset_Type__c == 'MV < 4.5T')+']');
      System.debug('rec.Amount_Min__c => ' + rec.Amount_Min__c + ' ['+(Decimal.valueOf(rec.Amount_Min__c) <= param.totalAmount)+']');

      if (
        rec.Asset_Type__c == 'MV < 4.5T' && 
        Decimal.valueOf(rec.Amount_Min__c) <= param.totalAmount && 
        param.term > 12 && 
        param.assetAge == 'New - 4 years'
      ) {
        String strval = rec.Term_24_60_months__c.replace('%','');
        r  = Decimal.valueOf(strval); 
        break;
      } else if (rec.Asset_Type__c != 'MV < 4.5T' && param.term > 12) {
          if(
            Decimal.valueOf(rec.Amount_Min__c) == 150000 && 
            Decimal.valueOf(rec.Amount_Min__c) <= param.totalAmount && 
            param.assetAge == 'New - 4 years'
          ){
            String strval = rec.Term_24_60_months__c.replace('%','');
            r  = Decimal.valueOf(strval); 
            break;
          }else if (
            Decimal.valueOf(rec.Amount_Min__c) == 55000 && 
            Decimal.valueOf(rec.Amount_Min__c) <= param.totalAmount && 
            Decimal.valueOf(rec.Amount_Max__c) >= param.totalAmount && 
            param.assetAge == 'New - 4 years'
          ){
            String strval = rec.Term_24_60_months__c.replace('%','');
            r  = Decimal.valueOf(strval); 
            break;
          } else if (
            Decimal.valueOf(rec.Amount_Min__c) == 20000 && 
            Decimal.valueOf(rec.Amount_Min__c) <= param.totalAmount && 
            Decimal.valueOf(rec.Amount_Max__c) >= param.totalAmount
          ){
            String strval = '0';
            if(param.assetAge == 'New - 4 years'){
              strval = rec.New_Primary__c.replace('%','');
              r  = Decimal.valueOf(strval); 
              break;
            }else if(param.assetAge == '> 4 years'){
              strval = rec.Used_Primary_4_years_old__c.replace('%','');
              r  = Decimal.valueOf(strval); 
              break;
            }else if(param.assetAge == '> 6 years'){
              strval = rec.Used_Primary_6_years_old__c.replace('%','');
              r  = Decimal.valueOf(strval); 
              break;
            }
            r  = Decimal.valueOf(strval); 
            break;
          } else if (
            Decimal.valueOf(rec.Amount_Min__c) == 10000 && 
            Decimal.valueOf(rec.Amount_Min__c) <= param.totalAmount && 
            Decimal.valueOf(rec.Amount_Max__c) >= param.totalAmount
          ){
            String strval = '0';
            if(param.assetAge == 'New - 4 years'){
              strval = rec.New_Primary__c.replace('%','');
              r  = Decimal.valueOf(strval); 
              break;
            }else if(param.assetAge == '> 4 years'){
              strval = rec.Used_Primary_4_years_old__c.replace('%','');
              r  = Decimal.valueOf(strval); 
              break;
            }else if(param.assetAge == '> 6 years'){
              strval = rec.Used_Primary_6_years_old__c.replace('%','');
              r  = Decimal.valueOf(strval); 
              break;
            }
            r  = Decimal.valueOf(strval); 
            break;
          } else if (
            Decimal.valueOf(rec.Amount_Min__c) == 5000 && 
            Decimal.valueOf(rec.Amount_Min__c) <= param.totalAmount && 
            Decimal.valueOf(rec.Amount_Max__c) >= param.totalAmount
          ){
            String strval = '0';
            if(param.assetAge == 'New - 4 years'){
              strval = rec.New_Primary__c.replace('%','');
              r  = Decimal.valueOf(strval); 
              break;
            }else if(param.assetAge == '> 4 years'){
              strval = rec.Used_Primary_4_years_old__c.replace('%','');
              r  = Decimal.valueOf(strval); 
              break;
            }else if(param.assetAge == '> 6 years'){
              strval = rec.Used_Primary_6_years_old__c.replace('%','');
              r  = Decimal.valueOf(strval); 
              break;
            }
          }
        }
      }
      
      if(param.assetType == 'MV < 4.5T' && param.assetAge == '> 4 years'){
        r = r + 0.25;
      }else if(param.assetType == 'MV < 4.5T' && param.assetAge == '> 6 years'){
        r = r + 1;
      }
      
      if(param.brokeragePer > 3){
        decimal excess = param.brokeragePer - 3;
        Integer additional = excess.intValue();
        r = r + additional*0.5;
      }
      
      return r;
  }
  
  
  /** Wiser VL - fees */
  public static Decimal getWisrVLMaxDOF(Decimal amount) { 
    // amount -> asset proice - net deposit
    Decimal r = 0.0;
    if (amount >= 50000) {
      r = 1990.0;
    } else if (amount >= 40000) {
      r = 1500.0;
    } else if (amount >= 30000) {
      r = 1250.0;
    } else if (amount >= 20000) {
      r = 990.0;
    } else if (amount >= 10000) {
      r = 900.0;
    } else if (amount >= 7500) {
      r = 750.0;
    } else if (amount >= 5000) {
      r = 500.0;
    }
    return r;
  }

  public static Decimal getWisrVLMaxAppFee(Decimal naf) { 
    Decimal r = 0.0;
    if (naf < 10000) {
      r = 495.0;
    } else if (naf < 20000) {
      r = 520.0;
    } else if (naf < 25000) {
      r = 555.0;
    } else if (naf < 30000) {
      r = 575.0;
    } else if (naf < 35000) {
      r = 630.0;
    } else if (naf < 40000) {
      r = 735.0;
    } else if (naf < 45000) {
      r = 840.0;
    } else if (naf < 50000) {
      r = 945.0;
    } else {
      r = 990.0;
    }
    return r;
  }

  // AFS Commission rate
  public static Decimal getAFSRateCommission(CalcParam param) {
    Decimal r = 0.00;
    AFSRateV2__c rate = QuotingCalculation.getAFSConsumerRate(param);
    if (rate != null) {
      r = rate.Comm__c;
    } else if('Gold Club - Non-Property'.equals(param.productLoanType)){
      r = 5.00;
    } else {
      r = 0.00;
    }
    return r;
  }

  // AFS Commercial rates
  public static Decimal getAFSCommercialBaseRate(
    CalcParam param,
    Boolean isMaxRate
  ) {
    
    Decimal minRate = 0.0;
    Decimal maxRate = 0.0;

    List<AFS_Commercial_Rates__c> rates = AFS_Commercial_Rates__c.getAll().values();
    rates.sort();
    
    Integer maxIdx = rates.size()-1;

    if ('Not Registered'.equals(param.gstLength)) {
      // Used 7 years
      minRate = rates.get(4).Rate_2__c;
      maxRate = rates.get(maxIdx).Rate_2__c;
    } else if ('New - 6 years old'.equals(param.assetAge)) {
      if ('Home Buyer'.equals(param.residency)) {
        minRate = rates.get(0).Rate__c;
      } else {
        minRate = rates.get(4).Rate__c;
      }
      maxRate = rates.get(maxIdx-3).Rate__c;
    } else {
      if ('Home Buyer'.equals(param.residency)) {
        minRate = rates.get(0).Rate_2__c;
      } else {
        minRate = rates.get(4).Rate_2__c;
      }
      maxRate = rates.get(maxIdx).Rate_2__c;
    }
    return isMaxRate? maxRate : minRate;
  }

  // AFS Commercial rates
  public static Decimal getAFSCommercialCommission(CalcParam param) {
    List<AFS_Commercial_Rates__c> rates = AFS_Commercial_Rates__c.getAll().values();
    rates.sort();
    Decimal r = 0.00;
    for (AFS_Commercial_Rates__c rate: rates) {
      if ('New - 6 years old'.equals(param.assetAge)) {
        if (rate.Rate__c > 0 && param.clientRate >= rate.Rate__c) {
          r = rate.Comm_07_Years__c;
        }
      } else {
        if (rate.Rate_2__c > 0 && param.clientRate >= rate.Rate_2__c) {
          r = rate.Comm_8_Years__c;
        }
      }
    }
    return r;
  }

  public static Decimal getMoneyPlaceMaxDOF(CalcParam param) {
    Decimal r = 0.00;
    Decimal v = param.amountBasePmt;
    Lenders__c lenderSettings = getLenderSettings(param.lender);
    if (v < 20000) {
      r = v * 0.1;
      r = r > lenderSettings.Max_DOF__c? lenderSettings.Max_DOF__c : r; 
    } else if (v < 40000) {
      r = 1690.00;
    } else {
      r = 1990.00;
    }
    return r.setScale(2);
  }

  public static Decimal getBOQBaseRate(CalcParam param, Boolean isMaxRate ) {
    Decimal r = 0.00;
    List<BOQRate__c> d = [
      SELECT CustomerInterestRate__c FROM BOQRate__c
      WHERE ClientTier__c = :param.clientTier
      ORDER BY CustomerInterestRate__c
    ];

    if (!d.isEmpty()) {
      r = isMaxRate? d.get(d.size() - 1).CustomerInterestRate__c : d.get(0).CustomerInterestRate__c;
    }

    return r;
  }

  public static Decimal getBOQCommRate(CalcParam param) {
    Decimal r = 0.00;
    List<BOQRate__c> d = [
      SELECT BaseCommisionRate__c FROM BOQRate__c
      WHERE ClientTier__c = :param.clientTier
      AND CustomerInterestRate__c >= :param.clientRate
      ORDER BY BaseCommisionRate__c
    ];

    if (!d.isEmpty()) {
      r = d.get(0).BaseCommisionRate__c;
    }

    return r;
  }

  public static Decimal getBOQCommBaseRate(CalcParam param, Boolean isMaxRate) {
    BOQCalculatorCommercialHelper boqHelper = new BOQCalculatorCommercialHelper();
    return boqHelper.getInterestRates(param.goodsType, param.vehicleYear);
  }

  public static Decimal getAzoraBaseRate(CalcParam param) {
    Decimal r = 0.00;
    Azora_Rates__c rateSel = QuotingCalculation.getAzora(param);
    System.debug(rateSel);
    if(rateSel != null){
      r = rateSel.Rate__c;
    }
    
    return r;
  }

  public static Decimal getSocietyOneBaseRate(CalcParam param, Boolean isMaxRate) {
    Decimal r = 0.00;
    Society_One_Rate__mdt rate = getSocietyOneRate(param);
    if (rate != null) {
      if (param.term <= 36) {
        r = isMaxRate ? rate.Rate_1_Max__c : rate.Rate_1__c;
      } else if (param.term <= 60) {
        r = isMaxRate ? rate.Rate_2_Max__c : rate.Rate_2__c;
      } else if ('Secured'.equals(param.customerProfile)) {
        r = isMaxRate ? rate.Rate_3_Max__c : rate.Rate_3__c;
      }
    }
    return r;
  }

  public static Society_One_Rate__mdt getSocietyOneRate(CalcParam param) {
    String name = param.customerProfile + '_' + param.clientTier;
    name = name.replace(' ', '_');
    return Society_One_Rate__mdt.getInstance(name);
  }

}