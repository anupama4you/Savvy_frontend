@isTest
public class TestSettlementCheckListExt {

public static testMethod void settlementMethod()
{

        test.startTest();
        Test_DataGeneratorHelper.createAccount();
        Test_DataGeneratorHelper.createLead();
        test.stopTest();
        
        Custom_Opportunity__c tstOpportunity = new Custom_Opportunity__c(Account__c = Test_DataGeneratorHelper.tstAccount.Id,
                                             Lead__c = Test_DataGeneratorHelper.tstLead.Id,
                                             Status__c = 'Quote Sent');
        insert tstOpportunity;
         
        PageReference pageRef = Page.SettlementChecklist;  
        
        Test.setCurrentPage(pageRef);

        apexpages.currentpage().getparameters().put('id',tstOpportunity.id);
        apexpages.currentpage().getparameters().put('settledValues','Name-trueMobile-trueEmail-trueHouseNo-trueStreet-trueStreetType-trueAccSub-trueState-trueAccPost-trueOwnerName-truePrdDeposite-truePrdDof-trueLoanPrd-trueLoanProdRes-truePrdLib-truePrdClntRate-trueLoanPrdBrk-trueLoanPrdLoan-trueTotalCom-trueClientProp-trueAmountFin-trueLoanProdIns-trueLoanProdInsu-trueLoanProdInsPls-trueLoanProdInsCom-truePrefLendr-truePurchaseType-trueDealerName-trueDealerConName-trueDealerConAddress-trueDealerEmail-trueDealerPhone-trueDealerFax-trueLoanProdLoan-trueLoanProductLoanPrs-trueoppNotesToSettOff-trueoppLoanProductBalloon-trueoppLoanProductRepay-trueoppLoanProductPayments-trueoppcostOfGoods-true');
        
        SettlementChecklistExt setlmtExt = new SettlementChecklistExt(new ApexPages.StandardController(tstOpportunity));
        setlmtExt.oppNameChecked=true;
        setlmtExt.oppMobileNumberChecked=true;
        setlmtExt.oppEmailAddChecked=true; 
      /*setlmtExt.oppAccUnitHouseNo=true; 
        setlmtExt.oppAccStreetAdd=true; 
        setlmtExt.oppAccStreetType=true; 
        setlmtExt.oppAccSuburb=true;
        setlmtExt.oppstate=true;
        setlmtExt.oppAccPostCode=true;    */
        setlmtExt.oppOwnerName=true; 
        setlmtExt.oppLoanProductDeposit=true; 
        setlmtExt.oppLoanProductDof=true; 
        setlmtExt.oppLoanProductLenderAppFee=true; 
        setlmtExt.oppLoanProductEquFeePPSR=true; 
        setlmtExt.oppLoanProductResidualAmount=true; 
        setlmtExt.oppLoanProductLibertyTrail=true; 
        setlmtExt.oppLoanProductClientRate=true; 
        setlmtExt.oppLoanProductBrokerage=true; 
        setlmtExt.oppLoanProductLoanTerm=true; 
        setlmtExt.oppTotalCommission=true; 
        setlmtExt.oppIsyourClientPropertyOwner=true; 
        setlmtExt.oppNAFAmountFinanced=true; 
        setlmtExt.oppLoanProductInsuranceType=true;
        setlmtExt.oppLoanProductInsurer=true; 
        setlmtExt.oppLoanProductInsurancePolicyAmt=true; 
        setlmtExt.oppLoanProductInsuranceComm=true; 
        setlmtExt.oppPreferredLender=true; 
        setlmtExt.oppPurchaseType=true; 
        setlmtExt.oppDealerName=true; 
        setlmtExt.oppDealerContactName=true; 
        setlmtExt.oppDealerAddress=true; 
        setlmtExt.oppDealerEmail=true; 
        setlmtExt.oppDealerPhoneNumber=true; 
        setlmtExt.oppDealerFaxNumber=true; 
        setlmtExt.oppLoanProductLoanType=true; 
        setlmtExt.oppLoanProductLoanPurpose=true; 
        setlmtExt.oppNotesToSettlementOfficer=true;
        setlmtExt.oppLoanProductBalloon=true;
        setlmtExt.oppLoanProductRepay=true;
        setlmtExt.oppLoanProductPayments=true;
        setlmtExt.oppcostOfGoods=true;
        setlmtExt.UpdateCheckList();
                
    }

}