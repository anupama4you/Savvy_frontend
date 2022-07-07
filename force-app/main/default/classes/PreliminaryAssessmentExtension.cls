public class PreliminaryAssessmentExtension {
	
    public Custom_Opportunity__c Opp;
    public Application_Quoting__c quo {set;get;}
    public AppServicingCalculatorDTO servCalc {set;get;}
    
    public PreliminaryAssessmentExtension (ApexPages.StandardController controller) {
      List<String> fields = new List<String>{'Application__c', 'Account__c', 'Account__r.Name'};
      if (!Test.isRunningTest()) controller.addFields(fields);
      this.Opp = (Custom_Opportunity__c)controller.getRecord ();
      loadPreApprovalData(Opp.Application__c);
    }
    
    private void loadPreApprovalData(Id appId) {
        // Application_Extra_Data__c a = ApplicationExtraDataHelper.getApplicationExtraDataId(appId, 'Quoting Calculation');
        // if (a != null) {
        //     try {
        //         quo = (Application_Quoting__c)JSON.deserialize(a.Data__c, Application_Quoting__c.class);
        //     } catch (Exception e) {
        //         System.debug('loadPreApprovalData >> Quoting >> ' + e.getMessage());
        //     }
        // }
        quo = QuotingToolHelper.getApplicationQuoting(this.Opp.Id, null);
        Application_Extra_Data__c a = ApplicationExtraDataHelper.getApplicationExtraDataId(appId, 'Servicing Calculation');
        if (a != null) {
            try {
                servCalc = (AppServicingCalculatorDTO)JSON.deserialize(a.Data__c, AppServicingCalculatorDTO.class);
            } catch (Exception e) {
                System.debug('loadPreApprovalData >> Servicing >> ' + e.getMessage());
            }
        }
    }
    
    
    public Decimal getTotalExpenses() {
        Decimal r = 0;
        if (servCalc != null) {
            r += NumberUtils.convertToDecimal(servCalc.rentMtgePaid, false);
            r += NumberUtils.convertToDecimal(servCalc.livingExpenses, false);
            r += NumberUtils.convertToDecimal(servCalc.totLiabilities, false);
            r += NumberUtils.convertToDecimal(servCalc.otherDebts, false);
        }
        if (quo != null && quo.Repayment_Monthly__c != null) {
            r += quo.Repayment_Monthly__c;
        }
        return r;
    }
    
    public Decimal getTotalSurplusDeficiency() {
        Decimal r = 0;
        if (servCalc != null) {
            r += NumberUtils.convertToDecimal(servCalc.netMonthlyIncome, false);
        }
        r -= getTotalExpenses();
        return r;
    }
    
    public String getToday() {
        return Datetime.now().format('MMMM d,  yyyy');
    }
    
    public Account getAccountVar()
    {
        List<User> userList;
        //userList = [SELECT Name, ContactId FROM User WHERE Id = '005N000000ACtxMIAT'  limit 1];
        userList = [SELECT Name, ContactId FROM User WHERE Id = :UserInfo.getUserId()  limit 1];
        
        List<Contact> contactList;
        contactList = [SELECT FirstName, LastName, Email, AccountId FROM Contact WHERE Id =: userList[0].ContactId limit 1];
        
        if(contactList.size() > 0){
          List<Account> accountList;
          accountList = [
            SELECT 
              Id, Name, Fax, Phone, BillingStreet, 
              BillingCity, BillingCountry, BillingState, 
              BillingPostalCode, Website, PersonMobilePhone, 
              Business_Name__c, Business_Logo__c 
            FROM Account WHERE Id =: contactList[0].AccountId limit 1
          ];
          return accountList[0];
        }else{
            return null;
        }
        
        
    }
}