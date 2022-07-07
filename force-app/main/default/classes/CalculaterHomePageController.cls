public class CalculaterHomePageController {
    
   // @AuraEnabled public redirectLinkWrapper wrap;  
    
    @AuraEnabled
    public static redirectLinkWrapper callCalculater(Id opportunityId){
        
        
        Custom_Opportunity__c  opp = [SELECT Id, Name,Preapproval_Auth_Date__c FROM Custom_Opportunity__c WHERE Id =: opportunityId LIMIT 1];
        redirectLinkWrapper wrap = new redirectLinkWrapper();
        wrap.IsBrokerPartnerUser = SOQLSingletonQueries.recs().isBrokerPartnerUser;
        wrap.PreApprovalWarning = '';
        if(opp.Preapproval_Auth_Date__c != null){
            wrap.PreApprovalWarning = 'There is already an Authorised Pre-approval for this deal, if you change to another Lender, you should submit a new Authorization process before proceeding for any approval.';
        }
        
        wrap.OppApplication = '/partner/s/sfdcpage/%2Fapex/OppApplication?id='+opportunityId+'&isdtp=Dp1';
        wrap.LenderComparison = '/partner/s/sfdcpage/%2Fapex/LenderComparisonFilter?id='+opportunityId+'&isdtp=Dp1';
        wrap.QuotingTool = '/partner/s/sfdcpage/%2Fapex/BlankCalculator?id='+opportunityId+'&quoting=NOQUOTING&isdtp=Dp1';
        wrap.YTD_Income_Calculator = '/partner/s/sfdcpage/%2Fapex/YTDCalculator?id='+opportunityId+'&isdtp=Dp1';
        wrap.Servicing_Calculator = '/partner/s/sfdcpage/%2Fapex/ServicingCalculator?id='+opportunityId+'&isdtp=Dp1';
        wrap.Asset_Details_LTV = '/partner/s/sfdcpage/%2Fapex/GlassServiceEstimator?id='+opportunityId+'&isdtp=Dp1';
        wrap.Notes = '/partner/s/sfdcpage/%2Fapex/OppApplication?id='+opportunityId+'&sec=NTS&isdtp=Dp1';
        wrap.Credit_History = '/partner/s/sfdcpage/%2Fapex/CreditHistory?id='+opportunityId+'&isdtp=Dp1';
        
        wrap.Macquarie_Consumer = !wrap.IsBrokerPartnerUser
          ? Page.MacquarieConsumer.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/macquarie-consumer?recordId='+opportunityId+'&oppName='+opp.Name;
       
        wrap.Macquarie_Commercial = !wrap.IsBrokerPartnerUser
          ? Page.MacquarieCommercial.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/macquarie-commercial?recordId='+opportunityId+'&oppName='+opp.Name;
          
        wrap.Pepper_PL = !wrap.IsBrokerPartnerUser
          ? Page.PepperPL.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/pepper-pl?recordId='+opportunityId+'&oppName='+opp.Name; 
        
        wrap.Prospa = !wrap.IsBrokerPartnerUser
          ? Page.ProspaCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/prospa?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Pepper_MV = !wrap.IsBrokerPartnerUser
          ? Page.PepperCalculatorMV.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/pepper-mv?recordId='+opportunityId+'&oppName='+opp.Name;
        
        wrap.ANZ_Commercial = !wrap.IsBrokerPartnerUser
          ? Page.EsandaCommercial.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/anz-commercial?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.ANZ_Others = !wrap.IsBrokerPartnerUser
          ? Page.EsandaOthers.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/anz-others?recordId='+opportunityId+'&oppName='+opp.Name;
       
        wrap.Plenti_PL = !wrap.IsBrokerPartnerUser
          ? Page.RatesetterPL.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/plenti-pl?recordId='+opportunityId+'&oppName='+opp.Name;
        
        wrap.Pepper_Leisure = !wrap.IsBrokerPartnerUser
          ? Page.PepperCalculatorLeisure.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/pepper-leisure?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Pepper_Commercial = !wrap.IsBrokerPartnerUser
          ? Page.PepperComm.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/pepper-comm?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Liberty_Drive = !wrap.IsBrokerPartnerUser
          ? Page.LibertyDrive.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/liberty?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Liberty_Leisure = !wrap.IsBrokerPartnerUser
          ? Page.LibertyLeisure.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/liberty-leisure?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Liberty_Comm = !wrap.IsBrokerPartnerUser
          ? Page.LibertyCommercial.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/liberty-commercial?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Finance_One = !wrap.IsBrokerPartnerUser
          ? Page.FinanceOne.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/finance-1?recordId='+opportunityId+'&oppName='+opp.Name;
        
        wrap.Finance_One_Comm = !wrap.IsBrokerPartnerUser
          ? Page.FinanceOneComm.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/finance-1-comm?recordId='+opportunityId+'&oppName='+opp.Name;
       
        wrap.Money3 = !wrap.IsBrokerPartnerUser
          ? Page.Money3Calculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/money3?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Now_Finance = !wrap.IsBrokerPartnerUser
          ? Page.NowFinanceCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/now-finance?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Yamaha_Marine = !wrap.IsBrokerPartnerUser
          ? Page.YamahaMarineCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/ammf?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Metro = !wrap.IsBrokerPartnerUser
          ? Page.MetroCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/metro?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Latitude = !wrap.IsBrokerPartnerUser
          ? Page.LatitudeCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/latitude?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.AFS_Consumer = !wrap.IsBrokerPartnerUser
          ? Page.AfsCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/afs-consumer?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.AFS_Commercial = !wrap.IsBrokerPartnerUser
          ? Page.AfsCommercialCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/afs-commercial?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Green_Light = !wrap.IsBrokerPartnerUser
          ? Page.GreenLightCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/green-light?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Latitude_Personal_Loan = !wrap.IsBrokerPartnerUser
          ? Page.LatitudePersonalCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/latitude-pl?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Wisr = !wrap.IsBrokerPartnerUser
          ? Page.WisrCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/wisr-pl?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Wisr_VL = !wrap.IsBrokerPartnerUser
          ? Page.WisrVLCalc.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/wisr?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Firstmac = !wrap.IsBrokerPartnerUser
          ? Page.FirstmacCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/firstmac?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Plenti = !wrap.IsBrokerPartnerUser
          ? Page.RateSetterCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/plenti?recordId='+opportunityId+'&oppName='+opp.Name;
        
        wrap.PlentiComm = !wrap.IsBrokerPartnerUser
          ? Page.PlentiCommercial.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/plenti-comm?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Money_Place = !wrap.IsBrokerPartnerUser
          ? Page.MoneyPlace.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/money-place?recordId='+opportunityId+'&oppName='+opp.Name;
        
        wrap.BOQ = !wrap.IsBrokerPartnerUser
          ? Page.BOQCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/boq?recordId='+opportunityId+'&oppName='+opp.Name; //Bank Of Queensland

        wrap.BOQCommercial = !wrap.IsBrokerPartnerUser
          ? Page.BOQCommercial.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/boq?recordId='+opportunityId+'&oppName='+opp.Name; //Bank Of Queensland

        wrap.Affordable = !wrap.IsBrokerPartnerUser
          ? Page.ACLCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/affordable?recordId='+opportunityId+'&oppName='+opp.Name; ////Affordable Car Loan
        
        wrap.CarStart = !wrap.IsBrokerPartnerUser
          ? Page.CarStartFinanceCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/carstart?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Azora = !wrap.IsBrokerPartnerUser
          ? Page.AzoraCalc.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/azora?recordId='+opportunityId+'&oppName='+opp.Name;
        System.debug('wrap.Azora => ' + wrap.Azora);
        wrap.GrowBusiness = !wrap.IsBrokerPartnerUser
          ? Page.GrowBusinessLoan.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/grow-business?recordId='+opportunityId+'&oppName='+opp.Name;
        
        wrap.ShiftODR = !wrap.IsBrokerPartnerUser
          ? Page.ShiftOTL.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/shift-odr?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.ShiftAsset = !wrap.IsBrokerPartnerUser
          ? Page.ShiftAsset.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/shift-asset?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.GrowAsset = !wrap.IsBrokerPartnerUser
          ? Page.GrowAssetCar.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/grow-asset?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Angle = !wrap.IsBrokerPartnerUser
          ? Page.AngleFinance.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/angle-finance?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Morris = !wrap.IsBrokerPartnerUser
          ? Page.Morris.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/morris?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Selfco = !wrap.IsBrokerPartnerUser
          ? Page.Selfco.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/selfco?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.SilverChef = !wrap.IsBrokerPartnerUser
          ? Page.SilverChef.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/silver-chef?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.Capital = !wrap.IsBrokerPartnerUser
          ? Page.CapitalFinance.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/capital-finance?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.FleetPartners = !wrap.IsBrokerPartnerUser
          ? Page.Fleetpartners.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/fleet-partners?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.GroupGeneral = !wrap.IsBrokerPartnerUser
          ? Page.GroupGeneral.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/group-general?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.CommercialEG = !wrap.IsBrokerPartnerUser
          ? Page.CommercialEquityGroup.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/comm-equity-group?recordId='+opportunityId+'&oppName='+opp.Name;
        
        wrap.ume = !wrap.IsBrokerPartnerUser
          ? Page.UMELoans.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/ume-loans?recordId='+opportunityId+'&oppName='+opp.Name;
        
        wrap.societyOne = !wrap.IsBrokerPartnerUser
          ? Page.SocietyOne.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/society-one?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.westpac = !wrap.IsBrokerPartnerUser
          ? Page.Westpac.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/westpac?recordId='+opportunityId+'&oppName='+opp.Name;

        wrap.apf = !wrap.IsBrokerPartnerUser
          ? Page.APF.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/apf?recordId='+opportunityId+'&oppName='+opp.Name;
        
        wrap.oppName = opp.Name;


        return wrap;
    }
    
    public class redirectLinkWrapper {

        @AuraEnabled public String oppName;

        @AuraEnabled public String OppApplication; //partner/s/sfdcpage/%2Fapex/OppApplication?id=a016D000004F8YQQA0&isdtp=Dp1
        @AuraEnabled public String LenderComparison; //partner/s/sfdcpage/%2Fapex/LenderComparisonFilter?id=a016D000004F8YQQA0&isdtp=Dp1
        @AuraEnabled public String QuotingTool;//partner/s/sfdcpage/%2Fapex/BlankCalculator?id=a016D000004F8YQQA0&quoting=NOQUOTING&isdtp=Dp1
        @AuraEnabled public String YTD_Income_Calculator; // /partner/s/sfdcpage/%2Fapex/YTDCalculator?id=a016D000004F8YQQA0&isdtp=Dp1
        @AuraEnabled public String Servicing_Calculator ; ///partner/s/sfdcpage/%2Fapex/ServicingCalculator?id=a016D000004F8YQQA0&isdtp=Dp1
        @AuraEnabled public String Asset_Details_LTV;///partner/s/sfdcpage/%2Fapex/GlassServiceEstimator?id=a016D000004F8YQQA0&isdtp=Dp1
        @AuraEnabled public String Notes;///partner/s/sfdcpage/%2Fapex/OppApplication?id=a016D000004F8YQQA0&sec=NTS&isdtp=Dp1
        @AuraEnabled public String Credit_History;//partner/s/sfdcpage/%2Fapex/CreditHistory?id=a016D000004F8YQQA0&isdtp=Dp1
        
        @AuraEnabled public Boolean IsBrokerPartnerUser; //getIsBrokerPartnerUser()
        @AuraEnabled public String PreApprovalWarning;
        
        @AuraEnabled public string General;
        @AuraEnabled public string ANZ_Consumer;
        @AuraEnabled public string ANZ_Commercial;
        @AuraEnabled public string ANZ_Others;
        @AuraEnabled public string Azora;
        @AuraEnabled public string Macquarie_Consumer;
        @AuraEnabled public string Macquarie_Commercial;
        @AuraEnabled public string Pepper_MV;
        @AuraEnabled public string Pepper_Leisure;
        @AuraEnabled public string Pepper_Commercial;
        @AuraEnabled public string Pepper_5Oh;
        @AuraEnabled public string Pepper_Summer;
        @AuraEnabled public string Liberty_Drive;
        @AuraEnabled public string Liberty_Leisure;
        @AuraEnabled public string Liberty_Comm;
        @AuraEnabled public string Finance_One;
        @AuraEnabled public string Finance_One_Comm;
        @AuraEnabled public string Finance_One_PL;
        @AuraEnabled public string Money3;
        @AuraEnabled public string Yamaha_Marine;
        @AuraEnabled public string Metro;
        @AuraEnabled public string Latitude;
        @AuraEnabled public string AFS_Consumer;//Page.AfsCalculator;
        @AuraEnabled public string AFS_Commercial;//Page.AfsCommercialCalculator;
        @AuraEnabled public string Green_Light;//Page.GreenLightCalculator;
        @AuraEnabled public string Latitude_Personal_Loan; //Page.LatitudePersonalCalculator;
        @AuraEnabled public string Wisr; //Page.WisrCalculator;
        @AuraEnabled public string Wisr_VL;//Page.WisrVLCalc;
        @AuraEnabled public string Firstmac;//Page.FirstmacCalculator;
        @AuraEnabled public string Now_Finance;//Page.NowFinanceCalculator;
        @AuraEnabled public string RateSetter_PL; //Page.RatesetterPL;
        @AuraEnabled public string Plenti_PL;//Page.RatesetterPL;
        @AuraEnabled public string RateSetter;//Page.RateSetterCalculator;
        @AuraEnabled public string Plenti;//Page.RateSetterCalculator;
        @AuraEnabled public string PlentiComm;//Page.RateSetterCalculator;
        @AuraEnabled public string Money_Place;//Page.MoneyPlace;
        @AuraEnabled public string Prospa;//Page.ProspaCalculator;
        @AuraEnabled public string BOQ; // Page.BOQCalculator; //Bank Of Queensland
        @AuraEnabled public string BOQCommercial;//Page.BOQCommercial; //Bank Of Queensland
        @AuraEnabled public string Affordable;//Page.ACLCalculator; ////Affordable Car Loan
        @AuraEnabled public string Pepper_PL;//Page.ACLCalculator;//Affordable Car Loan
        @AuraEnabled public string CarStart;//Page.CarStartFinanceCalculator;

        @AuraEnabled public string GrowBusiness;
        @AuraEnabled public string ShiftODR;

        @AuraEnabled public string ShiftAsset;
        @AuraEnabled public string GrowAsset;
        @AuraEnabled public string Angle;
        @AuraEnabled public string Morris;
        @AuraEnabled public string Selfco;
        @AuraEnabled public string SilverChef;
        @AuraEnabled public string Capital;
        @AuraEnabled public string FleetPartners;
        @AuraEnabled public string GroupGeneral;
        @AuraEnabled public string CommercialEG;

        @AuraEnabled public string ume;
        @AuraEnabled public string societyOne;
        @AuraEnabled public string westpac;
        @AuraEnabled public string apf;
    }
    

}