public without sharing class OpenNextLeadController
{   
    
    private static final String LEAD_TYPE_CLEAN = 'CLEAN';
    private static final String LEAD_TYPE_MONEY3 = 'M3';
    private static final String LEAD_TYPE_BCCL = 'BCCL';

    //private string nxtLead{get;set;}
    public Lead__c leadSel {get;set;}


    public PageReference NextLeadURL() {
        // find the next oldest system generated lead
        //for (Lead__c l : [SELECT Id, Name,
        //                         OwnerId, account__r.createddate
        //                  FROM Lead__c
        //                  WHERE Owner.Name = 'System Generated'
        //                  AND Employment_Status__c != 'Unemployed'
        //                  AND Status__c != 'Closed Lead'
        //                  AND Status__c != 'Become Opportunity'
        //                  AND Is_Call_Center__c = false
        //                  ORDER BY CreatedDate ASC, account__r.createddate DESC
        //                  LIMIT 1])
        //{
        //    l.OwnerId = UserInfo.getUserId();
        //    update l;

        //    leadSel = l;
            
        //    //return new PageReference('/apex/LeadEdit?id=' + l.Id + '&retURL=/'+'&nxtLead=true');                    
        //}   
        
        /*
        List<Lead__c> d = [SELECT Id, Name, Loan_Type__c, Finance_Amount__c, Credit_History__c,
                                 OwnerId, account__r.createddate
                          FROM Lead__c
                          WHERE CreatedDate=LAST_N_DAYS:2
                          AND Owner.Name = 'System Generated'
                          AND Employment_Status__c != 'Unemployed'
                          AND Status__c != 'Closed Lead'
                          AND Status__c != 'Become Opportunity'
                          AND Is_Call_Center__c = false
                          AND (NOT(
                                (Loan_Type__c like 'Personal%' OR Loan_Type__c like '%Car%') AND 
                                Finance_Amount__c <= 5000 AND 
                                (Credit_History__c = 'Bad' OR Credit_History__c = 'Not Sure' OR Credit_History__c = 'Poor')
                              ))
                          AND (Bucket_Type__c = null OR Bucket_Type__c = '8k PL')
                          ORDER BY CreatedDate ASC, account__r.createddate DESC
                          LIMIT 1];
        
        for (Lead__c l : d) {
          //if (isValidLead(l)) {
          //if (!d.isEmpty()) {
            this.leadSel = l;
            //break;
          //}
        }

        if (this.leadSel != null) {
          leadSel.OwnerId = UserInfo.getUserId();
          update leadSel;
        }
        */
        this.leadSel = this.getLead(LEAD_TYPE_CLEAN);
        return null;
    }

    public PageReference ReturnHome()
    {
        return new PageReference('/');
    }

    public Boolean getHasLeadSelected() {
      if (this.leadSel != null) {
        return true;
      }
      return false;
    }

    public Pagereference nextBCCLLead() {
      this.leadSel = this.getLead(LEAD_TYPE_BCCL);
      return null;
    }

    public Pagereference nextMoney3Lead() {
      this.leadSel = this.getLead(LEAD_TYPE_MONEY3);
      return null;
    }

    private Lead__c getLead(String leadType) {
      Lead__c r = null;
      List<Lead__c> d = null;
      if (LEAD_TYPE_BCCL.equals(leadType)) {
          d = [SELECT Id, Name, Loan_Type__c, Finance_Amount__c, Credit_History__c,
                        OwnerId, account__r.createddate
                FROM Lead__c
                WHERE CreatedDate=LAST_N_DAYS:10
                AND Owner.Name = 'System Generated'
                AND Employment_Status__c != 'Unemployed'
                AND Status__c != 'Closed Lead'
                AND Status__c != 'Become Opportunity'
                AND Loan_Type__c = 'Bad Credit Car Loan'
                AND Is_Call_Center__c = false
                AND (NOT(
                        (Loan_Type__c like 'Personal%' OR Loan_Type__c like '%Car%') AND 
                        Finance_Amount__c <= 5000 AND 
                        (Credit_History__c = 'Bad' OR Credit_History__c = 'Not Sure' OR Credit_History__c = 'Poor')
                    ))
                AND (Bucket_Type__c = null OR Bucket_Type__c = 'Sales' OR Bucket_Type__c = '8k PL')
                ORDER BY CreatedDate ASC, account__r.createddate DESC
                LIMIT 1];
      } else if (LEAD_TYPE_MONEY3.equals(leadType)) {
          d = [SELECT Id, Name, Loan_Type__c, Finance_Amount__c, Credit_History__c,
                        OwnerId, account__r.createddate
                FROM Lead__c
                WHERE CreatedDate=LAST_N_DAYS:10
                AND Owner.Name = 'System Generated'
                AND Employment_Status__c != 'Unemployed'
                AND Status__c != 'Closed Lead'
                AND Status__c != 'Become Opportunity'
                AND Is_Call_Center__c = false
                AND Bucket_Type__c = 'Money3'
                ORDER BY CreatedDate ASC, account__r.createddate DESC
                LIMIT 1];
      } else {
          // Clean leads
          d = [SELECT Id, Name, Loan_Type__c, Finance_Amount__c, Credit_History__c,
                        OwnerId, account__r.createddate
                FROM Lead__c
                WHERE CreatedDate=LAST_N_DAYS:10
                AND Owner.Name = 'System Generated'
                AND Employment_Status__c != 'Unemployed'
                AND Status__c != 'Closed Lead'
                AND Status__c != 'Become Opportunity'
                AND Loan_Type__c != 'Bad Credit Car Loan'
                AND Is_Call_Center__c = false
                AND (NOT(
                        (Loan_Type__c like 'Personal%' OR Loan_Type__c like '%Car%') AND 
                        Finance_Amount__c <= 5000 AND 
                        (Credit_History__c = 'Bad' OR Credit_History__c = 'Not Sure' OR Credit_History__c = 'Poor')
                    ))
                AND (Bucket_Type__c = null OR Bucket_Type__c = 'Sales' OR Bucket_Type__c = '8k PL')
                ORDER BY CreatedDate ASC, account__r.createddate DESC
                LIMIT 1];
      }

      if (d != null && !d.isEmpty()) {
        r = d.get(0);
        if (r != null) {
          r.OwnerId = UserInfo.getUserId();
          update r;
        }
      }
      return r;
    }

}