@isTest
public class QuotingToolAssistantTest {
  
  @isTest static void calcParameter() {
    Test.startTest();
    QuotingToolAssistant.CalcParam p = new QuotingToolAssistant.CalcParam('XXX');
    p.paymentType = null;
    p.ltv = null;
    p.customerProfile = null;
    p.adverseCredit = null;
    p.clientTier = null;
    p.loanType = null;
    p.loanTypeDetail = null;
    p.productLoanType = null;
    p.assetType = null;
    p.privateSales = null;
    p.saleBacksPurchased = null;
    p.goodsType = null;
    p.goodsSubType = null;
    p.vehiclesProfile = null;
    p.condition = null;
    p.vehicleYear = null;
    p.lpiLevel = null;
    p.state = null;
    p.vedascore = null;
    p.greenCar = null;
    p.riskGrade = null;
    p.bankrupt = null;
    p.residency = null;
    p.maxRate = null;
    p.hasDefault = null;
    p.hasImports = null;
    p.commType = null;
    p.vehiclePrice = null;
    p.commPayable = null;
    p.getPaymentTypeBoolean();
    Test.stopTest();
  }


  @isTest static void checkOptions() {
    List<String> lenders = new List<String>{
      ShiftAssetExtension.LENDER_QUOTING,
      ShiftOTLExtension.LENDER_QUOTING,
      SelfcoExtension.LENDER_QUOTING,
      CommercialEquityGroupExtension.LENDER_QUOTING,
      GrowBusinessLoanExtension.LENDER_QUOTING,
      GrowAssetCarExtension.LENDER_QUOTING,
      AngleFinanceExtension.LENDER_QUOTING,
      MorrisExtension.LENDER_QUOTING,
      SilverChefExtension.LENDER_QUOTING,
      CapitalFinanceExtension.LENDER_QUOTING,
      GroupGeneralExtension.LENDER_QUOTING,
      FleetpartnersExtension.LENDER_QUOTING
    };
    for (String a: lenders) {
      QuotingToolAssistant.getLoanTypeOptions(a);
      QuotingToolAssistant.getassetTypeOptions(a);
      QuotingToolAssistant.gettermOptions(a);
      QuotingToolAssistant.getabnLengthOptions(a);
      QuotingToolAssistant.getassetAgeOptions(a);
      QuotingToolAssistant.getpropertyOwnerOptions(a);
      QuotingToolAssistant.getprivateSalesOptions(a);
      QuotingToolAssistant.getpaymentTypeOptions(a);
      QuotingToolAssistant.getproductTypeOptions(a);
      QuotingToolAssistant.getloanProductOptions(a);
      QuotingToolAssistant.getgstLengthOptions(a);
      QuotingToolAssistant.gettierOptions(a);
    }

  }

}