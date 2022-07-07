public with sharing class DisplayTVReport2Extension {

    public DisplayTVReport2Extension () {
        // default the month and year to now
        Month = Date.today().month();
        Year = Date.today().year();
        getConsultants();
    }
    
    public Integer Month { get; set; }
    public Integer Year { get; set; }
    // List of 'RateWrapper' wrapper class
    public List<conWrapper> conObjectWrapperList = new List<conWrapper>(); 
    public decimal totalAmount{get;set;}
    public Integer leadCount{get;set;}
    public Decimal tatlBudget{get;set;}
    public Decimal sinlBudget{get;set;}

    // The upper part of the report, no OverallLeads
    // Total number of loan Sales
    public Integer dsOverallLoanSales { get; set; }
    // Total percentage of Budget
    public Decimal dsOverallPctBudget { get; set; }
    // Total number of insurance Sales
    public Integer dsOverallInsuranceSales { get; set; }
    // Total percentage of insurance conversion
    public Decimal dsOverallInsuranceConversion { get; set; }
    // Total Commission
    public Decimal dsOverallCommission {get; set; }
    // Total budget
    public Decimal dsOverallBudget {get; set; }
    // Total Net Amount Financed
    public Decimal dsOverallNAF {get; set; }
    // Total Insurance Commission
    public Decimal dsOverallInsuranceCommission {get; set; }
    // Total Brokerage/DOF (ex GST)
    public Decimal dsOverallBrokerageAndDOF {get; set; }
    // Total percentage of lead conversion
    public Decimal dsOverallLeadConversion {get;set;}
    
    // Total number of loan Sales
    public Integer dsOverallVDSales { get; set; }

    public Decimal getOverallVDConversion() {
      Decimal r = 0;
      if (dsOverallLoanSales > 0 && dsOverallVDSales > 0) {
        r = Decimal.valueOf(dsOverallVDSales) / Decimal.valueOf(dsOverallLoanSales);
      }
      return r;
    }

    //return list of ConWrapper
    public List<ConWrapper> getConsWrapperList()
    {   
        //system.debug('######## conObjectWrapperList -'+conObjectWrapperList);
        return conObjectWrapperList;
    }
                       
    public Set<Id> userIds
    {
        get
        {
            if (userIds == null)
            {

                userIds = new Set<Id>();
                for (Group g : [SELECT Id
                    FROM Group WHERE (DeveloperName = 'Sales_Consultants' OR DeveloperName = 'Customer_Loyalty') 
                    AND Type = 'Regular' ORDER BY DeveloperName ASC                   ])
                {
                    
                    for (GroupMember gm : [SELECT UserOrGroupId
                                           FROM GroupMember
                                           WHERE GroupId = :g.Id])
                    {
                        userIds.add(gm.UserOrGroupId);
                    } 
                    
                }

            }
            return userIds;
        }
        set;
    }
    
    
    public Map<Id, User> ValidUsers
    {
        get
        {
            if (ValidUsers == null)
            {
                ValidUsers = new Map<Id, User> ([SELECT Id
                                                 FROM User
                                                 WHERE Id IN :userIds]);                
            }
            return ValidUsers;
        }
        set;    
    }
    
    // The upper part of the report to show total number of leads
    public Integer OverallLeads 
    { 
        get
        {
            OverallLeads = 0;
            if(ValidUsers != null && ValidUsers.size()>0){
            
                // find the number of leads for the month
                for (AggregateResult[] ar : [SELECT COUNT(Id)
                                             FROM Lead__c
                                             WHERE Date_Lead_to_Consultant__c >= :StartDate
                                             AND Date_Lead_to_Consultant__c < :EndDate
                                             AND OwnerId IN :ValidUsers.keySet()])
                {
                    OverallLeads = Integer.valueOf(ar[0].get('expr0'));
                } 
            
            }                                             
            
            return OverallLeads;
        }
       set;
    }   
    
     private Date StartDate
    {
        get
        {
            return Date.newInstance(Year, Month, 1);
        }
    }
    
    private Date EndDate
    {
        get
        {
            return StartDate.addMonths(1);
        }
    }
    
       public List<SelectOption> Years
    {
        get
        {
            if (Years == null)
            {
                Years = new List<SelectOption>();
                Integer y = 2013;
                
                while (y <= Date.today().year())
                {
                    Years.add(new SelectOption(String.valueOf(y), String.valueOf(y)));
                    y++;
                }
            }
            return Years;    
        }
        set;
    }
    
    public PageReference getConsultants()
    {
        
            conObjectWrapperList.clear();
            List<User> userList = new List<User>();
            Set<Id> userIds = new Set<Id>();
            Map<id,List<Lead__c>> leadCountMap = new Map<id,List<Lead__c>>();
            Decimal totalNAFVal;
            Decimal totalinsSales;
            Integer opportunityCount;
            Decimal insurConversion;
            Decimal LdConversions;
            Integer PreAppdOpps;
            Integer TotalPreAppdOpps;
            Integer PreAppdFFUOpps; 
            Decimal RevePerLead;
            
            Integer vdCount;      //Lelo    2016-11-18
            Integer vdNewDemoCount = 0;      //Lelo    2017-04-07
            Decimal fullCompInsSales;  //Lelo    2017-04-07
            Decimal otherInsSales;  //Lelo    2017-04-07
            Decimal fullCompInsConversion;  //Lelo    2017-04-07
            Decimal otherInsConversion;  //Lelo    2017-04-07

            dsOverallPctBudget = 0.0;
            dsOverallCommission = 0.0;
            dsOverallNAF = 0.0;
            dsOverallInsuranceSales = 0;
            dsOverallLeadConversion = 0.0;
            dsOverallLoanSales =0;
            dsOverallInsuranceConversion = 0.0;
            dsOverallBudget = 0.0;
            dsOverallInsuranceCommission = 0.0;
            dsOverallBrokerageAndDOF = 0.0;
            
            dsOverallVDSales = 0;
            fullCompInsSales = 0;
            otherInsSales = 0;
            fullCompInsConversion = 0;
            otherInsConversion = 0;

            Map<Id, Lead__c> leadCountMap1 = new Map<Id, Lead__c>();
            
            for (Lead__c l : [SELECT Id,
                                     OwnerId,
                                     Owner.Name
                              FROM Lead__c
                              WHERE Date_Lead_to_Consultant__c >= :StartDate
                              AND Date_Lead_to_Consultant__c < :EndDate
                              AND OwnerId IN :ValidUsers.keySet()])
            {             
                userIds.add(l.OwnerId);
                leadCountMap1.put(l.ownerId,l);
                
                
                if(leadCountMap.containsKey(l.OwnerId)){
                
                
                     leadCountMap.get(l.OwnerId).add(l);
                
                
                }else{
                            
                    leadCountMap.Put(l.OwnerId, new List<Lead__c>{l}); 
                         
                }  
              
            }                              
            
           set<Id> OppUserIds = new set<Id>();
           Map<id,List<Custom_Opportunity__c>> userToOppMap = new Map<id,List<Custom_Opportunity__c>>();
           if(validUsers!= null && validUsers.size()>0){
            for(custom_opportunity__c oppObj:[
                    select id, name,Owner.Name, ownerId,Total_Commission__c,NAF_Net_Amount_Financed__c,
                           Number_Insurance_Sales__c,Total_Insurance_Commission__c,Total_Brokerage__c,
                           Total_DOF__c, VD_Status__c, VD_Is_Old_Process__c, Number_FullComp_Ins_Sales__c,
                           Number_Other_Ins_Sales__c, Lead__r.Loan_Type__c 
                    from custom_opportunity__c 
                    WHERE Owner.Name != 'System Generated' AND Date_Settled__c >= :StartDate AND Date_Settled__c < :EndDate 
                    AND Status__c = 'Settled' AND ownerId in:validUsers.keyset()]){
                if (!this.excludeOpportunity(oppObj)) {
                    OppUserIds.add(oppObj.OwnerId);
                    if(userToOppMap.containsKey(oppObj.OwnerId)){
                        userToOppMap.get(oppObj.OwnerId).add(oppObj);
                    }else{
                        userToOppMap.Put(oppObj.OwnerId, new List<Custom_Opportunity__c>{oppObj}); 
                    }
                }
             }
           
           }
           
           //Current Pre-Approved deals
           Map<id,List<Custom_Opportunity__c>> userToOppMap2 = new Map<id,List<Custom_Opportunity__c>>();
           if(validUsers!= null && validUsers.size()>0){
            for(custom_opportunity__c oppObj2:[
                      select id, name,Owner.Name, ownerId,Total_Commission__c,NAF_Net_Amount_Financed__c,
                             Number_Insurance_Sales__c,Total_Insurance_Commission__c,Total_Brokerage__c,
                             Total_DOF__c, VD_Status_Process__c, Lead__r.Loan_Type__c 
                      from custom_opportunity__c 
                      WHERE Owner.Name != 'System Generated' 
                      AND LastmodifiedDate >= :StartDate AND LastModifiedDate < :EndDate 
                      AND Status__c = 'Pre-Approved' AND ownerId in:validUsers.keyset()]){
                if (!this.excludeOpportunity(oppObj2)) {      
                    if(userToOppMap2.containsKey(oppObj2.OwnerId)){
                        userToOppMap2.get(oppObj2.OwnerId).add(oppObj2);
                    }else{
                        userToOppMap2.Put(oppObj2.OwnerId, new List<Custom_Opportunity__c>{oppObj2}); 
                    }
                }
             }
           
            }

      
            //Total Pre-Approved deals
            Set<Id> oppPreapprovedList = new Set<Id>();
            Map<id,List<Custom_Opportunity__c>> userToOppMap4 = new Map<id,List<Custom_Opportunity__c>>();
            for(custom_opportunity__c oppObj2:[
                    select id, name,Owner.Name, ownerId,Total_Commission__c,NAF_Net_Amount_Financed__c,
                       Number_Insurance_Sales__c,Total_Insurance_Commission__c,Total_Brokerage__c,
                       Total_DOF__c, VD_Status__c, VD_Is_Old_Process__c, Lead__r.Loan_Type__c 
                    from custom_opportunity__c 
                    WHERE Owner.Name != 'System Generated' 
                    AND (Date_Pre_Approved__c >= :StartDate AND Date_Pre_Approved__c < :EndDate)
                    AND ownerId in:validUsers.keyset()]){
                if (!this.excludeOpportunity(oppObj2)) {
                    if(userToOppMap4.containsKey(oppObj2.OwnerId)){
                        userToOppMap4.get(oppObj2.OwnerId).add(oppObj2);
                    }else{
                        userToOppMap4.Put(oppObj2.OwnerId, new List<Custom_Opportunity__c>{oppObj2}); 
                    } 
                    oppPreapprovedList.add(oppObj2.Id);
                }
            }           
           
            //Load Previous period Pre-Approved Opps
            for(custom_opportunity__c oppObj2:[
              select id, Lead__r.Loan_Type__c
              from custom_opportunity__c 
              WHERE Owner.Name != 'System Generated' 
              AND (Date_Pre_Approved__c >= :StartDate.addMonths(-1) AND Date_Pre_Approved__c < :EndDate.addMonths(-1))
              AND ownerId in:validUsers.keyset()]){
                if (!this.excludeOpportunity(oppObj2)) {
                    oppPreapprovedList.add(oppObj2.Id);
                }
            } 


           set<Id> OppUserIds3 = new set<Id>();
           Map<id,List<Custom_Opportunity__c>> userToOppMap3 = new Map<id,List<Custom_Opportunity__c>>();
           if(validUsers!= null && validUsers.size()>0){
            for(custom_opportunity__c oppObj3:[
                      select id, name,Owner.Name, ownerId,Total_Commission__c,NAF_Net_Amount_Financed__c,
                             Number_Insurance_Sales__c,Total_Insurance_Commission__c,Total_Brokerage__c,
                             Total_DOF__c, VD_Status__c, VD_Is_Old_Process__c, Lead__r.Loan_Type__c 
                      from custom_opportunity__c 
                      WHERE Owner.Name != 'System Generated' 
                      AND LastmodifiedDate >= :StartDate AND LastModifiedDate < :EndDate 
                      AND Status__c = 'Pre-approved FFU' AND ownerId in:validUsers.keyset()]){
                if (!this.excludeOpportunity(oppObj3)) {
                    OppUserIds3.add(oppObj3.OwnerId);
                    if(userToOppMap3.containsKey(oppObj3.OwnerId)){
                        userToOppMap3.get(oppObj3.OwnerId).add(oppObj3);
                    } else {
                        userToOppMap3.Put(oppObj3.OwnerId, new List<Custom_Opportunity__c>{oppObj3}); 
                    } 
                }           
             }
           }

           //VD Processes
           Map<Id,List<Custom_Opportunity__c>> userToVDMap = new Map<Id,List<Custom_Opportunity__c>>();
           for (Custom_Opportunity__c c : [
                SELECT Id, ownerId, Status__c, VD_Status_Process__c, VD_Owner__r.Name,
                       VD_Worksheet__r.Type_of_Process__c, Lead__r.Loan_Type__c
                FROM Custom_Opportunity__c 
                WHERE (VD_Worksheet__r.CreatedDate >= :StartDate AND VD_Worksheet__r.CreatedDate < :EndDate)
                AND Loan_Product__r.Quoting_Source__c != 'Latitude Personal Loan'
                AND Loan_Product__r.Loan_Type__c != 'Refinance'
                AND Loan_Product__r.Loan_Type__c != 'Sale & Lease Back'
                AND Lead__r.Loan_type__c != 'Personal'
              ]){
                if (!this.excludeOpportunity(c)) {
                  if(userToVDMap.containsKey(c.OwnerId)){
                    userToVDMap.get(c.OwnerId).add(c);
                  } else {
                    userToVDMap.put(c.OwnerId, new List<Custom_Opportunity__c>{c}); 
                  }
                }
           }
           

           System.debug('userToOppMap4 >> ' + JSON.serialize(userToOppMap4));

           for(User ur: [Select id,Monthly_Commission_Target__c,name,State from User where id In:validUsers.keyset() ORDER BY State ASC] ){
                
                leadCount = 0;
                System.debug('@@@@ur.id' + ur.id + ' >> ' + ur.Name);
                if(leadCountMap.containsKey(ur.id)){
                           
                   for(Lead__c ld: leadCountMap.get(ur.id)){
                   List<Lead__c> ldCountLst = new List<Lead__c>();
                   ldCountLst.add(ld);
                     // increment the lead count  
                     leadCount +=ldCountLst.size();       
                   
                   }
               
                }

                 sinlBudget = 0.0;
                 tatlBudget =0.0;
                 totalAmount = 0.0;
                 totalNAFVal =0.0;
                 totalinsSales = 0;
                 opportunityCount=0;
                 insurConversion = 0.0;
                 LdConversions = 0.0;
                 PreAppdOpps = 0;
                 TotalPreAppdOpps = 0;
                 PreAppdFFUOpps = 0;
                 RevePerLead = 0.0;

                 vdCount = 0;     //Lelo      2016-11-18
                 vdNewDemoCount = 0;
                 fullCompInsSales = 0;
                 otherInsSales = 0;
                 fullCompInsConversion = 0;
                 otherInsConversion = 0;

                 Integer vdNewDemoCountOriginal = 0;

                 if (userToVDMap.containsKey(ur.Id)) {
                    for (Custom_Opportunity__c o : userToVDMap.get(ur.Id)) {
                      if ('Fleet Referral'.equals(o.VD_Worksheet__r.Type_of_Process__c)) {
                        //if (oppPreapprovedList.contains(o.Id)) {
                          vdCount++;
                        //}
                        vdNewDemoCountOriginal++;
                      } else {
                        if (oppPreapprovedList.contains(o.Id)) {
                          vdNewDemoCount++;
                        }
                      }
                    }
                    //vdCount = userToVDMap.get(ur.Id).size();
                    //System.debug(ur.Name + ' >> ' + vdNewDemoCountOriginal + ' | ' + vdNewDemoCount);
                 }
                 
                 System.debug(ur.Name + ' >> ' + vdNewDemoCountOriginal + ' | ' + vdNewDemoCount + ' | ' + vdCount);

                 if(userToOppMap3.containskey(ur.id)) {
                 
                   for(Custom_Opportunity__c csOpp3:userToOppMap3.get(ur.id)) {
                   
                       List<custom_opportunity__c> oppCountLst3 = new List<custom_opportunity__c>();
                       oppCountLst3.add(csOpp3);
                       
                       //increment the Pre-Approved opps
                       PreAppdFFUOpps +=oppCountLst3.size();
                        
                       //if (!csOpp3.VD_Is_Old_Process__c) {
                       //   vdCount++;
                       //}

                    }
                                        
                 }
                    
                 //Current Pre-Approved deals
                 if(userToOppMap2.containskey(ur.id)) {
                 
                   for(Custom_Opportunity__c csOpp2:userToOppMap2.get(ur.id)) {
                   
                     List<custom_opportunity__c> oppCountLst2 = new List<custom_opportunity__c>();
                     oppCountLst2.add(csOpp2);
                     
                     //increment the Pre-Approved opps
                     PreAppdOpps +=oppCountLst2.size();
                     //for (Custom_Opportunity__c c: oppCountLst2) {
                     //  if (!String.isBlank(c.VD_Status__c)) {
                     //     vdCount++;
                     //  }
                     //}

                     //if (!csOpp2.VD_Is_Old_Process__c) {
                     //   vdCount++;
                     //}


                   }
                                        
                 }

                 //Total Pre-Approved deals
                 if(userToOppMap4.containskey(ur.id)) {
                   for(Custom_Opportunity__c csOpp2:userToOppMap4.get(ur.id)) {
                     List<custom_opportunity__c> oppCountLst2 = new List<custom_opportunity__c>();
                     oppCountLst2.add(csOpp2);
                     TotalPreAppdOpps +=oppCountLst2.size();
                   }
                                        
                 }
                
 
                 if(userToOppMap.containskey(ur.id)) {
                  
                     
                      for(Custom_opportunity__c csOpp:userToOppMap.get(ur.id)){
                           
                           List<custom_opportunity__c> oppCountLst = new List<custom_opportunity__c>();
                           oppCountLst.add(csOpp);
                          
                          // increment the lead count  
                          opportunityCount +=oppCountLst.size();  
                              
                          totalAmount +=  csOpp.Total_Commission__c;
                      
                          system.debug('@@@@totalAmount'+totalAmount );
                          
                          if(csOpp.NAF_Net_Amount_Financed__c != null){
                          
                              totalNAFVal += csOpp.NAF_Net_Amount_Financed__c;
                          
                          }
                          
                          if(csOpp.Number_Insurance_Sales__c != null){
                          
                              totalinsSales += csOpp.Number_Insurance_Sales__c;
                          
                          }
                          //Lelo
                          if(csOpp.Number_FullComp_Ins_Sales__c != null){
                              fullCompInsSales += csOpp.Number_FullComp_Ins_Sales__c;
                          }
                          if(csOpp.Number_Other_Ins_Sales__c != null){
                              otherInsSales += csOpp.Number_Other_Ins_Sales__c;
                          }

                          dsOverallInsuranceCommission += csOpp.Total_Insurance_Commission__c;
                          dsOverallBrokerageAndDOF += csOpp.Total_Brokerage__c+csOpp.Total_DOF__c;
                          
                          //if ('Send back to Sales Consultant'.equals(csOpp.VD_Status__c)) {
                          //  dsOverallVDSales++;
                          //  vdCount++;
                          //}
                          //if (!csOpp.VD_Is_Old_Process__c) {
                          //    vdCount++;
                          //}
                      }
                      
                  }
               System.debug('totalAmount >> ' + totalAmount);// aewtr
                        
                  if(totalinsSales != null){
                      insurConversion += (totalinsSales > 0 ? totalinsSales/opportunityCount : 0);
                  }
                  
                  if (fullCompInsSales != null) {
                    fullCompInsConversion += (fullCompInsSales > 0 ? fullCompInsSales/opportunityCount : 0);
                  }
                  if (otherInsSales != null) {
                    otherInsConversion += (otherInsSales > 0 ? otherInsSales/opportunityCount : 0);
                  }

                  if(leadCount != null){
                  
                      revePerLead += (leadCount > 0 ? totalAmount /leadCount : 0);
                      
                  }
                  system.debug('@@@@insurConversion '+ insurConversion);
                  system.debug('@@@@leadCount'+leadCount);
                  system.debug('@@@@opportunityCount'+opportunityCount);
                  
                  if(Decimal.valueOf(leadCount) != 0){
                  
                  LdConversions = (Decimal.ValueOf(opportunityCount)/Decimal.valueOf(leadCount));
                  
                  }
                  system.debug('@@@@LdConversions'+LdConversions);
                  
                   if(ur.Monthly_Commission_Target__c != null && totalAmount != null && ur.Monthly_Commission_Target__c !=0 ){
                      
                     tatlBudget += (totalAmount/ur.Monthly_Commission_Target__c);
                     sinlBudget = ur.Monthly_Commission_Target__c;
                      
                     system.debug('@@@@tatlBudget'+tatlBudget );
                     system.debug('@@@@sinlBudget'+sinlBudget );
                  }
                  
                  if(ur.Monthly_Commission_Target__c != null){
                      
                      dsOverallBudget += ur.Monthly_Commission_Target__c;

                  }
                  
                  dsOverallCommission += totalAmount;
                  
                  if(dsOverallBudget != 0){
                  
                      dsOverallPctBudget = dsOverallCommission/dsOverallBudget;
                      
                  }
                  dsOverallNAF += totalNAFVal;
                  dsOverallInsuranceSales += Integer.valueOf(totalinsSales);
                  dsOverallLoanSales += opportunityCount;
                  
                  system.debug('@@@@dsOverallInsuranceSales'+dsOverallInsuranceSales);
                  system.debug('@@@@dsOverallLoanSales'+dsOverallLoanSales);
                  
                  if(Decimal.ValueOf(dsOverallLoanSales) != 0){
                      dsOverallInsuranceConversion = dsOverallInsuranceSales/Decimal.ValueOf(dsOverallLoanSales);
                  }
                  if(Decimal.valueOf(OverallLeads) != 0){
                  
                      dsOverallLeadConversion = dsOverallLoanSales/Decimal.valueOf(OverallLeads);
                  
                  }
                  
                  ConWrapper lTempConWrapper = new ConWrapper(
                          ur, userList, totalAmount, leadCount, sinlBudget, tatlBudget, totalNAFVal,
                          totalinsSales, opportunityCount, insurConversion, LdConversions, 
                          PreAppdOpps, PreAppdFFUOpps, RevePerLead, vdCount, vdNewDemoCount, vdNewDemoCountOriginal, TotalPreAppdOpps, 
                          fullCompInsSales, otherInsSales, fullCompInsConversion, otherInsConversion);

                  conObjectWrapperList.add(lTempConWrapper);
                
            
            }
            
            return null;

    }
    // 'ConWrapper' wrapper class initialization.
    // The lower part of the report
    public class ConWrapper
    {
        // The user object instance to get the consultant name
        public User userObj {get; set;}
        public List<User> UserList {get; set;}

        // Total Commission
        public Decimal totalAmtVal{get;set;}
        public Decimal totalLoanSales{get;set;}
        // Number of leads
        public Integer ldCount{get;set;}
        // percentage of budget
        public Decimal totalBudget{get;set;}
        // Total Net Amount Financed
        public Decimal totalNaf{get;set;}
        // Number of insurance sales
        public Decimal totalInsuranceSales{get;set;}
        // Number of loan sales
        public Integer oppCount{get;set;}
        // percentage of insurance conversion
        public Decimal insuranceConversion{get;set;}
        // percentage of lead conversion
        public Decimal leadConversion{get;set;}
        // Number of Current Pre-approved Opportunities
        public Integer PreApprovedOpps{get;set;}
        // Number of Total Pre-approved Opportunities
        public Integer TotPreApprovedOpps{get;set;}
        // Number of Pre-approved FFU Opportunities
        public Integer PreApprovedFFUOpps{get;set;}
        // Revenue per lead
        public Decimal RevenuePerLead{get;set;}
        // The personal budget
        public Decimal urbudget{get;set;}
        
        //No. of  VD sales
        public Integer vdCount {get;set;}     //Lelo    2016-11-18
        public Integer vdNewDemoCount {get;set;}     //Lelo    2017-04-03
        public Integer vdNewDemoCountOri {get;set;}     //Lelo    2017-04-03
        public Decimal vDConversionRate {get;set;}     //Lelo    2016-11-18
        // Number of Full-Comp insurance sales
        public Decimal fullCompInsuranceSales{get;set;}     //Lelo    2017-04-03
        // Number of Other insurance sales
        public Decimal otherInsuranceSales{get;set;}        //Lelo    2017-04-03
        // Number of Full-Comp insurance Conversion
        public Decimal fullCompInsConversion{get;set;}     //Lelo    2017-04-03
        // Number of Other insurance Conversion
        public Decimal otherInsConversion{get;set;}        //Lelo    2017-04-03


        // ConWrapper class Constructor
        public ConWrapper(user u, List<User> usrlt, decimal ttlAmt,Integer lCount, Decimal usrbudget,
                          Decimal budget,Decimal tlNaf,Decimal insuranceTotal,Integer opCount,
                          Decimal insConversion,Decimal ldConversion,Integer PreAppOpps,
                          Integer PreAppFFUOpps, Decimal RevPerLead, Integer vdCount, Integer vdNewDemoCount, Integer vdNewDemoCountOri,
                          Integer TotPreAppOpps, Decimal fullCompInsSales, Decimal otherInsSales, 
                          Decimal fullCompInsConversion, Decimal otherInsConversion)
        {
            this.userObj=u;
            UserList = usrlt;
            this.totalAmtVal=ttlAmt;
            this.ldCount = lCount;
            this.urbudget = usrbudget;
            this.totalBudget = budget;
            this.totalNaf = tlNaf;
            this.totalInsuranceSales = insuranceTotal;
            
            this.insuranceConversion = insConversion;
            this.leadConversion = ldConversion;
            this.PreApprovedOpps = PreAppOpps;
            this.PreApprovedFFUOpps = PreAppFFUOpps;
            this.RevenuePerLead = RevPerLead;

            this.oppCount = opCount;
            this.vdCount = vdCount;     //Lelo    2016-11-18
            this.vdNewDemoCount = vdNewDemoCount;               //Lelo    2017-04-03
            this.vdNewDemoCountOri = vdNewDemoCountOri;               //Lelo    2017-04-03
            this.fullCompInsuranceSales = fullCompInsSales;     //Lelo    2017-04-03
            this.otherInsuranceSales = otherInsSales;           //Lelo    2017-04-03

            this.fullCompInsConversion = fullCompInsConversion;   //Lelo    2017-04-03
            this.otherInsConversion = otherInsConversion;         //Lelo    2017-04-03

            this.TotPreApprovedOpps = TotPreAppOpps;
            vDConversionRate = 0.0;
            Decimal totalOpps = 0.0;
            if (this.TotPreApprovedOpps != null) {
              totalOpps += this.TotPreApprovedOpps;
            }
            //if (this.oppCount != null) {
            //  totalOpps += this.oppCount; 
            //}
            if (totalOpps > 0 && this.vdCount > 0) {
              vDConversionRate = Decimal.valueOf(this.vdCount) / totalOpps;
            }

        }

        public Decimal getVdNewDemoConversionRate() {
          Decimal r = 0;
          if (this.TotPreApprovedOpps != null && this.TotPreApprovedOpps > 0 && this.vdNewDemoCount != null && this.vdNewDemoCount > 0) {
            r = Decimal.valueOf(this.vdNewDemoCount) / TotPreApprovedOpps;   
          }
          return r;
        } 

        public Integer getTotalVDDeals() {
            Integer r = 0;
            if (this.vdCount != null) r += this.vdCount;
            if (this.vdNewDemoCount != null) r += this.vdNewDemoCount;
            return r;
        } 

        public Decimal getTotalVDConversionRate() {
          Decimal r = 0;
          if (this.TotPreApprovedOpps != null && this.TotPreApprovedOpps > 0 && this.getTotalVDDeals() > 0) {
            r = Decimal.valueOf(this.getTotalVDDeals()) / TotPreApprovedOpps;   
          }
          return r;
        }
        
    }   

    public Integer getTotalCurrentPreApproved() {
      Integer r = 0 ;
      if (conObjectWrapperList != null) {
        for (ConWrapper c : conObjectWrapperList) {
          if (c.PreApprovedOpps != null) {
            r += c.PreApprovedOpps;
          }
        }
      }
      return r;
    } 

    public Integer getTotalPreApproved() {
        Integer r = 0 ;
        if (conObjectWrapperList != null) {
            for (ConWrapper c : conObjectWrapperList) {
                if (c.TotPreApprovedOpps != null) {
                    r += c.TotPreApprovedOpps;
                }
            }
        }
        return r;
    }  

    public Integer getTotalVDSent() {
      Integer r = 0 ;
      if (conObjectWrapperList != null) {
        for (ConWrapper c : conObjectWrapperList) {
          if (c.vdCount != null) {
            r += c.vdCount;
          }
        }
      }
      return r;
    } 

    public Integer getTotalVDNewDemoSent() {
      Integer r = 0 ;
      if (conObjectWrapperList != null) {
        for (ConWrapper c : conObjectWrapperList) {
          if (c.vdNewDemoCount != null) {
            r += c.vdNewDemoCount;
          }
        }
      }
      return r;
    } 

    public Decimal getTotalFullCompInsSales() {
      Decimal r = 0 ;
      if (conObjectWrapperList != null) {
        for (ConWrapper c : conObjectWrapperList) {
          if (c.fullCompInsuranceSales != null) {
            r += c.fullCompInsuranceSales;
          }
        }
      }
      return r;
    } 

    public Decimal getTotalOtherInsSales() {
      Decimal r = 0 ;
      if (conObjectWrapperList != null) {
        for (ConWrapper c : conObjectWrapperList) {
          if (c.otherInsuranceSales != null) {
            r += c.otherInsuranceSales;
          }
        }
      }
      return r;
    } 

    public Decimal getTotalFullCompConversionRate() {
        Decimal r = 0;
        if (this.dsOverallLoanSales != null && this.dsOverallLoanSales > 0 && this.getTotalFullCompInsSales() > 0) {
          r = this.getTotalFullCompInsSales() / Decimal.valueOf(dsOverallLoanSales);
        }
        return r;
    } 

    public Decimal getTotalOtherConversionRate() {
        Decimal r = 0;
        if (this.dsOverallLoanSales != null && this.dsOverallLoanSales > 0 && this.getTotalOtherInsSales() > 0) {
          r = this.getTotalOtherInsSales() / Decimal.valueOf(dsOverallLoanSales);
        }
        return r;
    }  

    public Decimal getTotalPAIntoVD() {
        Decimal r = 0;
        if (this.getTotalPreApproved() > 0) {
            r = (this.getTotalVDSent() + this.getTotalVDNewDemoSent()) / Decimal.valueOf(this.getTotalPreApproved());
        }
        return r.setScale(2);
    }      

    private Boolean excludeOpportunity(Custom_Opportunity__c opp) {
        Boolean r = false;
        if (opp == null) return r;
        if (String.isNotBlank(opp.Lead__r.Loan_Type__c)) {
            if ('Home Loan'.equals(opp.Lead__r.Loan_Type__c) ||
                'Insurance'.equals(opp.Lead__r.Loan_Type__c)) {
                r = true;
            }
        }
        //if (String.isNotBlank(opp.Lead__r.Bucket_Type__c)) {
        //    if (!'8k PL'.equals(opp.Lead__r.Bucket_Type__c) &&
        //        !'Bad Credit Car Loan'.equals(opp.Lead__r.Bucket_Type__c)) {
        //        r = true;
        //    }
        //}
        return r;
    }
}