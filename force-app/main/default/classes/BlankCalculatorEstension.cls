public with sharing class BlankCalculatorEstension {
  private Custom_Opportunity__c opp = null;
  private String lender = null;

  public BlankCalculatorEstension(ApexPages.StandardController stdController) {
    opp = (Custom_Opportunity__c) stdController.getRecord();
    String paramTmp = System.currentPageReference()
      .getParameters()
      .get('quoting');
    if (!String.isBlank(paramTmp)) {
      lender = paramTmp;
      if ('NOQUOTING'.equals(lender) || 'General'.equals(lender)) {
        //Yohan Villamizar 2019-07-29
        if (opp.Loan_Product__r != null) {
          if ('Prospa'.equals(opp.Loan_Product__r.Lender__c)) {
            lender = 'Prospa';
          }
        }
      }
    }
    System.debug('Redirect to ' + lender);
  }

  public PageReference validate() {
    if (!String.isBlank(lender)) {
      PageReference p = null;
      if ('General'.equals(lender)) {
        p = Page.GeneralCalculator;
      } else if ('ANZ Consumer'.equals(lender)) {
        p = Page.EsandaCalculator;
      } else if ('ANZ Commercial'.equals(lender)) {
        p = Page.EsandaCommercial;
      } else if ('ANZ Others'.equals(lender)) {
        p = Page.EsandaOthers;
      } else if ('Macquarie Consumer'.equals(lender)) {
        p = Page.MacquarieConsumer;
      } else if ('Macquarie Commercial'.equals(lender)) {
        p = Page.MacquarieCommercial;
      } else if ('Pepper MV'.equals(lender)) {
        p = Page.PepperCalculatorMV;
      } else if ('Pepper Leisure'.equals(lender)) {
        p = Page.PepperCalculatorLeisure;
      } else if ('Pepper Commercial'.equals(lender)) {
        p = Page.PepperComm;
      } else if ('Pepper 5Oh'.equals(lender)) {
        p = Page.PepperCalculatorSeasonal;
      } else if ('Pepper Summer'.equals(lender)) {
        p = Page.PepperSummer;
      } else if ('Liberty Drive'.equals(lender)) {
        p = Page.LibertyDrive;
      } else if ('Liberty Leisure'.equals(lender)) {
        p = Page.LibertyLeisure;
      } else if ('Finance One'.equals(lender)) {
        p = Page.FinanceOne;
      } else if ('Finance One PL'.equals(lender)) {
        p = Page.FinanceOnePL;
        // } else if ('Finance One Business'.equals(lender)) {
        //     p = Page.FinanceOneComm;
      } else if ('Money3'.equals(lender)) {
        p = Page.Money3Calculator;
      } else if ('Yamaha Marine'.equals(lender)) {
        p = Page.YamahaMarineCalculator;
      } else if ('Metro'.equals(lender)) {
        p = Page.MetroCalculator;
      } else if ('Latitude'.equals(lender)) {
        p = Page.LatitudeCalculator;
      } else if ('AFS Consumer'.equals(lender)) {
        p = Page.AfsCalculator;
      } else if ('AFS Commercial'.equals(lender)) {
        p = Page.AfsCommercialCalculator;
      } else if ('Green Light'.equals(lender)) {
        p = Page.GreenLightCalculator;
      } else if ('Latitude Personal Loan'.equals(lender)) {
        p = Page.LatitudePersonalCalculator;
      } else if ('Wisr'.equals(lender)) {
        p = Page.WisrCalculator;
      } else if ('Wisr VL'.equals(lender)) {
        p = Page.WisrVLCalc;
      } else if ('Firstmac'.equals(lender)) {
        p = Page.FirstmacCalculator;
      } else if ('Now Finance'.equals(lender)) {
        p = Page.NowFinanceCalculator;
      } else if ('RateSetter PL'.equals(lender) || 'Plenti PL'.equals(lender)) {
        p = Page.RatesetterPL;
      } else if ('RateSetter'.equals(lender) || 'Plenti'.equals(lender)) {
        p = Page.RateSetterCalculator;
      } else if ('Money Place'.equals(lender)) {
        p = Page.MoneyPlace;
      } else if ('Prospa'.equals(lender)) {
        p = Page.ProspaCalculator;
      } else if ('BOQ'.equals(lender)) {
        //Bank Of Queensland
        p = Page.BOQCalculator;
      } else if ('BOQCommercial'.equals(lender)) {
        //Bank Of Queensland
        p = Page.BOQCommercial;
      } else if ('Affordable'.equals(lender)) {
        //Affordable Car Loan
        p = Page.ACLCalculator;
      } else if ('Pepper PL'.equals(lender)) {
        //Affordable Car Loan
        p = Page.PepperPL;
      } else if ('CarStart'.equals(lender)) {
        p = Page.CarStartFinanceCalculator;
      } else if ('Azora Consumer'.equals(lender)) {
        p = Page.AzoraCalc;
      } else if ('Finance One Commercial'.equals(lender)) {
        p = Page.FinanceOneComm;
      } else if ('Shift Asset'.equals(lender)) {
        p = Page.ShiftAsset;
      } else if ('Shift ODR'.equals(lender)) {
        p = Page.ShiftOTL;
      } else if ('Grow Asset'.equals(lender)) {
        p = Page.GrowAssetCar;
      } else if ('Grow Business Loan'.equals(lender)) {
        p = Page.GrowBusinessLoan;
      } else if ('Angle Finance'.equals(lender)) {
        p = Page.AngleFinance;
      } else if ('Morris'.equals(lender)) {
        p = Page.Morris;
      } else if ('Selfco'.equals(lender)) {
        p = Page.Selfco;
      } else if ('Silver Chef'.equals(lender)) {
        p = Page.SilverChef;
      } else if ('Capital Finance'.equals(lender)) {
        p = Page.CapitalFinance;
      } else if ('Fleet Partners'.equals(lender)) {
        p = Page.Fleetpartners;
      } else if ('Group and General'.equals(lender)) {
        p = Page.GroupGeneral;
      } else if ('Commercial Equity Group'.equals(lender)) {
        p = Page.CommercialEquityGroup;
      } else if ('Plenti Commercial'.equals(lender)) {
        p = Page.PlentiCommercial;
      } else if ('Liberty Commercial'.equals(lender)) {
        p = Page.LibertyCommercial;
      } else if ('UME Loans'.equals(lender)) {
        p = Page.UMELoans;
      } else if ('Society One'.equals(lender)) {
        p = Page.SocietyOne;
      } else if ('Westpac'.equals(lender)) {
        p = Page.Westpac;
      } else if ('APF'.equals(lender)) {
        p = Page.APF;
      } else if ('Krisp'.equals(lender)) {
        p = Page.KrispCalc;
      }
      if (p != null) {
        p.getParameters().put('id', opp.Id);
        p.setRedirect(true);
        return p;
      }
    }
    if (this.opp.Preapproval_Auth_Date__c != null) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.WARNING,
          'There is already an Authorised Pre-approval for this deal, if you change to another Lender, you should submit a new Authorization process before proceeding for any approval.'
        )
      );
    }
    return null;
  }

  public Boolean getIsBrokerPartnerUser() {
    return SOQLSingletonQueries.recs().isBrokerPartnerUser;
  }
}