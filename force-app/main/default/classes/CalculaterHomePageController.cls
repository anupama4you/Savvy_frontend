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
        
        // ------ Consumer Asset ------
        // Affordable Car Loan
        wrap.Affordable = !wrap.IsBrokerPartnerUser
        ? Page.ACLCalculator.getUrl() + '?id=' + opportunityId
        : '/partner/s/sales-tools/quoting-tools/affordable?recordId='+opportunityId+'&oppName='+opp.Name; 
        // APF
        wrap.apf = !wrap.IsBrokerPartnerUser
          ? Page.APF.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/apf?recordId='+opportunityId+'&oppName='+opp.Name;
        // AFS Consumer
        wrap.AFS_Consumer = !wrap.IsBrokerPartnerUser
          ? Page.AfsCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/afs-consumer?recordId='+opportunityId+'&oppName='+opp.Name;
        // Azora Consumer
        wrap.Azora = !wrap.IsBrokerPartnerUser
          ? Page.AzoraCalc.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/azora?recordId='+opportunityId+'&oppName='+opp.Name;
        // Bank of Queensland
        wrap.BOQ = !wrap.IsBrokerPartnerUser
          ? Page.BOQCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/boq?recordId='+opportunityId+'&oppName='+opp.Name;
        // Branded Consumer
        wrap.BrandedConsumer = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/branded-consumer?recordId='+opportunityId+'&oppName='+opp.Name;
        // C1 Finance
        wrap.C1Finance = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/c1-finance?recordId='+opportunityId+'&oppName='+opp.Name;
        // Car Start Finance
        wrap.CarStart = !wrap.IsBrokerPartnerUser
          ? Page.CarStartFinanceCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/carstart?recordId='+opportunityId+'&oppName='+opp.Name;
        // Finance One
        wrap.Finance_One = !wrap.IsBrokerPartnerUser
          ? Page.FinanceOne.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/finance-1?recordId='+opportunityId+'&oppName='+opp.Name;
        // First Mac
        wrap.Firstmac = !wrap.IsBrokerPartnerUser
          ? Page.FirstmacCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/firstmac?recordId='+opportunityId+'&oppName='+opp.Name;
        // Gedda
        wrap.Gedda = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/gedda?recordId='+opportunityId+'&oppName='+opp.Name;
        // General
        wrap.General = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/general?recordId='+opportunityId+'&oppName='+opp.Name;
        // Green
        wrap.Green_Light = !wrap.IsBrokerPartnerUser
          ? Page.GreenLightCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/green-light?recordId='+opportunityId+'&oppName='+opp.Name;
        // Krisp
        wrap.Krisp = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/krisp?recordId='+opportunityId+'&oppName='+opp.Name;
        // Liberty
        wrap.Liberty_Drive = !wrap.IsBrokerPartnerUser
          ? Page.LibertyDrive.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/liberty?recordId='+opportunityId+'&oppName='+opp.Name;
        // Liberty Leisure
        wrap.Liberty_Leisure = !wrap.IsBrokerPartnerUser
          ? Page.LibertyLeisure.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/liberty-leisure?recordId='+opportunityId+'&oppName='+opp.Name;
        // Latitude
        wrap.Latitude = !wrap.IsBrokerPartnerUser
          ? Page.LatitudeCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/latitude?recordId='+opportunityId+'&oppName='+opp.Name;
        // AMMF
        wrap.Yamaha_Marine = !wrap.IsBrokerPartnerUser
          ? Page.YamahaMarineCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/ammf?recordId='+opportunityId+'&oppName='+opp.Name;
        // Macquarie Consumer
        wrap.Macquarie_Consumer = !wrap.IsBrokerPartnerUser
          ? Page.MacquarieConsumer.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/macquarie-consumer?recordId='+opportunityId+'&oppName='+opp.Name;
        // Money3
        wrap.Money3 = !wrap.IsBrokerPartnerUser
          ? Page.Money3Calculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/money3?recordId='+opportunityId+'&oppName='+opp.Name;
        // Pepper MV
        wrap.Pepper_MV = !wrap.IsBrokerPartnerUser
          ? Page.PepperCalculatorMV.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/pepper-mv?recordId='+opportunityId+'&oppName='+opp.Name;
        // Pepper Bikes/Boats
        wrap.Pepper_Leisure = !wrap.IsBrokerPartnerUser
          ? Page.PepperCalculatorLeisure.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/pepper-leisure?recordId='+opportunityId+'&oppName='+opp.Name;
        // Plenti
        wrap.Plenti = !wrap.IsBrokerPartnerUser
          ? Page.RateSetterCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/plenti?recordId='+opportunityId+'&oppName='+opp.Name;
        // Racv
        wrap.racv = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/racv?recordId='+opportunityId+'&oppName='+opp.Name;
        // Society One
        wrap.societyOne = !wrap.IsBrokerPartnerUser
          ? Page.SocietyOne.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/society-one?recordId='+opportunityId+'&oppName='+opp.Name;
        // UME
        wrap.ume = !wrap.IsBrokerPartnerUser
          ? Page.UMELoans.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/ume-loans?recordId='+opportunityId+'&oppName='+opp.Name;
        // Wisr
        wrap.Wisr = !wrap.IsBrokerPartnerUser
          ? Page.WisrCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/wisr-pl?recordId='+opportunityId+'&oppName='+opp.Name;

        // ------ Commercial Asset ------
        // ANZ Commercial
        wrap.ANZ_Commercial = !wrap.IsBrokerPartnerUser
          ? Page.EsandaCommercial.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/anz-commercial?recordId='+opportunityId+'&oppName='+opp.Name;
        // ANZ Others
        wrap.ANZ_Others = !wrap.IsBrokerPartnerUser
          ? Page.EsandaOthers.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/anz-others?recordId='+opportunityId+'&oppName='+opp.Name;
        // AFS Commercial
        wrap.AFS_Commercial = !wrap.IsBrokerPartnerUser
          ? Page.AfsCommercialCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/afs-commercial?recordId='+opportunityId+'&oppName='+opp.Name;
        // Azora Commercial
        wrap.AzoraCommercial = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/azora-commercial?recordId='+opportunityId+'&oppName='+opp.Name;
        // BOQ Commercial
        wrap.BOQCommercial = !wrap.IsBrokerPartnerUser
          ? Page.BOQCommercial.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/boq-commercial?recordId='+opportunityId+'&oppName='+opp.Name; 
        // Branded Commercial
        wrap.BrandedCommercial = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/branded-commercial?recordId='+opportunityId+'&oppName='+opp.Name;
        // Capital Finance
        wrap.Capital = !wrap.IsBrokerPartnerUser
          ? Page.CapitalFinance.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/capital-finance?recordId='+opportunityId+'&oppName='+opp.Name;
        // CommercialEG
        wrap.CommercialEG = !wrap.IsBrokerPartnerUser
          ? Page.CommercialEquityGroup.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/comm-equity-group?recordId='+opportunityId+'&oppName='+opp.Name;
        // EarlyPayComm
        wrap.EarlyPayComm = !wrap.IsBrokerPartnerUser
          ? Page.CommercialEquityGroup.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/early-pay-comm?recordId='+opportunityId+'&oppName='+opp.Name;
        // Angle Finance
        wrap.Angle = !wrap.IsBrokerPartnerUser
          ? Page.AngleFinance.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/angle-finance?recordId='+opportunityId+'&oppName='+opp.Name;
        // Finance One Commercial
        wrap.Finance_One_Comm = !wrap.IsBrokerPartnerUser
          ? Page.FinanceOneComm.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/finance-1-comm?recordId='+opportunityId+'&oppName='+opp.Name;
        // Fleet Partners
          wrap.FleetPartners = !wrap.IsBrokerPartnerUser
          ? Page.Fleetpartners.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/fleet-partners?recordId='+opportunityId+'&oppName='+opp.Name;
        // Grow Asset
        wrap.GrowAsset = !wrap.IsBrokerPartnerUser
          ? Page.GrowAssetCar.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/grow-asset?recordId='+opportunityId+'&oppName='+opp.Name;
        // Group General Finance
        wrap.GroupGeneral = !wrap.IsBrokerPartnerUser
          ? Page.GroupGeneral.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/group-general?recordId='+opportunityId+'&oppName='+opp.Name;
        // Liberty Commercial
        wrap.Liberty_Comm = !wrap.IsBrokerPartnerUser
          ? Page.LibertyCommercial.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/liberty-commercial?recordId='+opportunityId+'&oppName='+opp.Name;
        // Macquaire Commercial
        wrap.Macquarie_Commercial = !wrap.IsBrokerPartnerUser
          ? Page.MacquarieCommercial.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/macquarie-commercial?recordId='+opportunityId+'&oppName='+opp.Name;
        // Metro Finance
        wrap.Metro = !wrap.IsBrokerPartnerUser
          ? Page.MetroCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/metro?recordId='+opportunityId+'&oppName='+opp.Name;
        // Morris
        wrap.Morris = !wrap.IsBrokerPartnerUser
          ? Page.Morris.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/morris?recordId='+opportunityId+'&oppName='+opp.Name;
        // Multipli
        wrap.Multipli = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/multipli?recordId='+opportunityId+'&oppName='+opp.Name;
        // Pepper Commercial
        wrap.Pepper_Commercial = !wrap.IsBrokerPartnerUser
          ? Page.PepperComm.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/pepper-comm?recordId='+opportunityId+'&oppName='+opp.Name;
        // Plenti Commercial
        wrap.PlentiComm = !wrap.IsBrokerPartnerUser
          ? Page.PlentiCommercial.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/plenti-comm?recordId='+opportunityId+'&oppName='+opp.Name;
        // Resimac
        wrap.resimac = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/resimac?recordId='+opportunityId+'&oppName='+opp.Name;
        // Shift Asset
        wrap.ShiftAsset = !wrap.IsBrokerPartnerUser
          ? Page.ShiftAsset.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/shift-asset?recordId='+opportunityId+'&oppName='+opp.Name;
        // Selfco
        wrap.Selfco = !wrap.IsBrokerPartnerUser
          ? Page.Selfco.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/selfco?recordId='+opportunityId+'&oppName='+opp.Name;
        // Silver Chef
        wrap.SilverChef = !wrap.IsBrokerPartnerUser
          ? Page.SilverChef.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/silver-chef?recordId='+opportunityId+'&oppName='+opp.Name;
        // Westpac
        wrap.westpac = !wrap.IsBrokerPartnerUser
          ? Page.Westpac.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/westpac?recordId='+opportunityId+'&oppName='+opp.Name;
        // Scotpac Asset
        wrap.ScotpacAsset = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/scotpac-asset?recordId='+opportunityId+'&oppName='+opp.Name;
        // Thorn
        wrap.Thorn = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/thorn?recordId='+opportunityId+'&oppName='+opp.Name;

        // ------ Personal Loans ------
        // Latitude PL
        wrap.Latitude_Personal_Loan = !wrap.IsBrokerPartnerUser
          ? Page.LatitudePersonalCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/latitude-pl?recordId='+opportunityId+'&oppName='+opp.Name;
        // Now Finance
        wrap.Now_Finance = !wrap.IsBrokerPartnerUser
          ? Page.NowFinanceCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/now-finance?recordId='+opportunityId+'&oppName='+opp.Name;
        // Money Place
        wrap.Money_Place = !wrap.IsBrokerPartnerUser
          ? Page.MoneyPlace.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/money-place?recordId='+opportunityId+'&oppName='+opp.Name;
        // Money3 PL  
        wrap.Money3_PL = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/money3-pl?recordId='+opportunityId+'&oppName='+opp.Name;
        // Pepper PL
        wrap.Pepper_PL = !wrap.IsBrokerPartnerUser
          ? Page.PepperPL.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/pepper-pl?recordId='+opportunityId+'&oppName='+opp.Name; 
        // Plenti PL
        wrap.Plenti_PL = !wrap.IsBrokerPartnerUser
          ? Page.RatesetterPL.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/plenti-pl?recordId='+opportunityId+'&oppName='+opp.Name;
        // Wisr PL
        wrap.Wisr_VL = !wrap.IsBrokerPartnerUser
          ? Page.WisrVLCalc.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/wisr?recordId='+opportunityId+'&oppName='+opp.Name;

        // ------ Personal Loans ------
        // Bizcap
        wrap.Bizcap = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/bizcap?recordId='+opportunityId+'&oppName='+opp.Name;
        // Grow Business Loan
        wrap.GrowBusiness = !wrap.IsBrokerPartnerUser
          ? Page.GrowBusinessLoan.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/grow-business?recordId='+opportunityId+'&oppName='+opp.Name;
        // Lumi
        wrap.Lumi = !wrap.IsBrokerPartnerUser
          ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/lumi?recordId='+opportunityId+'&oppName='+opp.Name;
        // Prospa
        wrap.Prospa = !wrap.IsBrokerPartnerUser
          ? Page.ProspaCalculator.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/prospa?recordId='+opportunityId+'&oppName='+opp.Name;
        // Shift ODR
        wrap.ShiftODR = !wrap.IsBrokerPartnerUser
          ? Page.ShiftOTL.getUrl() + '?id=' + opportunityId
          : '/partner/s/sales-tools/quoting-tools/shift-odr?recordId='+opportunityId+'&oppName='+opp.Name;
        // ScotPac
        wrap.ScotPac = !wrap.IsBrokerPartnerUser
        ? Page.GeneralCalculator.getUrl() + '?id=' + opportunityId
        : '/partner/s/sales-tools/quoting-tools/scotpac?recordId='+opportunityId+'&oppName='+opp.Name;
        
        wrap.oppName = opp.Name;
        return wrap;
    }
    
    public class redirectLinkWrapper {
        @AuraEnabled public String oppName;

        // General Fields
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
        
        // ------ Cunsumer Asset ------
        @AuraEnabled public String Affordable;  //Page.ACLCalculator;   //Affordable Car Loan
        @AuraEnabled public String apf; 
        @AuraEnabled public String AFS_Consumer;//Page.AfsCalculator;
        @AuraEnabled public String Azora;
        @AuraEnabled public String BOQ; // Page.BOQCalculator; //Bank Of Queensland
        @AuraEnabled public String BrandedConsumer;//Page.BrandedConsumer;
        @AuraEnabled public String C1Finance;
        @AuraEnabled public String CarStart;//Page.CarStartFinanceCalculator;
        @AuraEnabled public String Finance_One;
        @AuraEnabled public String Firstmac;//Page.FirstmacCalculator;
        @AuraEnabled public String Gedda;
        @AuraEnabled public String General;
        @AuraEnabled public String Green_Light;//Page.GreenLightCalculator;
        @AuraEnabled public String Krisp;//Page.KrispCalculator;
        @AuraEnabled public String Liberty_Drive;
        @AuraEnabled public String Liberty_Leisure;
        @AuraEnabled public String Latitude;
        @AuraEnabled public String Yamaha_Marine;
        @AuraEnabled public String Macquarie_Consumer;
        @AuraEnabled public String Money3;
        @AuraEnabled public String Pepper_MV;
        @AuraEnabled public String Pepper_Leisure;
        @AuraEnabled public String Plenti;  //Page.RateSetterCalculator;
        @AuraEnabled public String racv;
        @AuraEnabled public String societyOne;
        @AuraEnabled public String ume;
        @AuraEnabled public String Wisr; //Page.WisrCalculator;

        // ------ Commercial Asset ------
        @AuraEnabled public String ANZ_Commercial;
        @AuraEnabled public String ANZ_Consumer;
        @AuraEnabled public String ANZ_Others;
        @AuraEnabled public String Angle;
        @AuraEnabled public String AFS_Commercial;//Page.AfsCommercialCalculator;
        @AuraEnabled public String AzoraCommercial;//Page.Resimac;
        @AuraEnabled public String BOQCommercial;//Page.BOQCommercial; //Bank Of Queensland
        @AuraEnabled public String BrandedCommercial;//Page.BrandedCommercial;
        @AuraEnabled public String Capital;
        @AuraEnabled public String CommercialEG;
        @AuraEnabled public String EarlyPayComm;
        @AuraEnabled public String Finance_One_Comm;
        @AuraEnabled public String FleetPartners;
        @AuraEnabled public String GrowAsset;
        @AuraEnabled public String GroupGeneral;
        @AuraEnabled public String Liberty_Comm;
        @AuraEnabled public String Macquarie_Commercial;
        @AuraEnabled public String Metro;
        @AuraEnabled public String Morris;
        @AuraEnabled public String Multipli;
        @AuraEnabled public String Pepper_Commercial;
        @AuraEnabled public String PlentiComm;//Page.RateSetterCalculator;
        @AuraEnabled public String resimac;//Page.Resimac;
        @AuraEnabled public String ShiftAsset;
        @AuraEnabled public String Selfco;
        @AuraEnabled public String SilverChef;
        @AuraEnabled public String westpac;
        @AuraEnabled public String ScotpacAsset;
        @AuraEnabled public String Thorn;

        // ------ Personal Loans ------
        @AuraEnabled public String Latitude_Personal_Loan; //Page.LatitudePersonalCalculator;
        @AuraEnabled public String Now_Finance;//Page.NowFinanceCalculator;
        @AuraEnabled public String Money_Place;//Page.MoneyPlace;
        @AuraEnabled public String Money3_PL;
        @AuraEnabled public String Pepper_PL;//Page.ACLCalculator;//Affordable Car Loan
        @AuraEnabled public String Plenti_PL;//Page.RatesetterPL;
        @AuraEnabled public String Wisr_VL;//Page.WisrVLCalc;

        // ------ Personal Loans ------
        @AuraEnabled public String Bizcap;
        @AuraEnabled public String GrowBusiness;
        @AuraEnabled public String Lumi;
        @AuraEnabled public String Prospa;//Page.ProspaCalculator;
        @AuraEnabled public String ShiftODR;
        @AuraEnabled public String ScotPac;

        @AuraEnabled public String Pepper_5Oh;
        @AuraEnabled public String Pepper_Summer;
        @AuraEnabled public String Finance_One_PL;
        @AuraEnabled public String RateSetter_PL; //Page.RatesetterPL;
        @AuraEnabled public String RateSetter;//Page.RateSetterCalculator;
    }
}