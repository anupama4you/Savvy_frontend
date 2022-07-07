public with sharing class DisplayVDTvReportExtension {

	public Integer Month { get; set; }
    public Integer Year { get; set; }

    // List of 'RateWrapper' wrapper class
    public List<conWrapper> conObjectWrapperList = new List<conWrapper>(); 
    public decimal totalAmount{get;set;}
    public Integer leadCount{get;set;}
    
    // Total Commission
    public Decimal dsOverallCommission {get; set; }
    
    public DisplayVDTvReportExtension() {
        // default the month and year to now
        Month = Date.today().month();
        Year = Date.today().year();
        getConsultants();
    }

    //return list of ConWrapper
    public List<ConWrapper> getConsWrapperList() {   
        system.debug('######## conObjectWrapperList -'+conObjectWrapperList);
        return conObjectWrapperList;
    }
                       
    /*public Set<Id> userIds {
        get
        {
            if (userIds == null)
            {

                userIds = new Set<Id>();

                for (Group g : [SELECT Id
                    FROM Group
                    WHERE DeveloperName = 'Vehicles_Direct' AND Type = 'Regular' ORDER BY DeveloperName ASC
                    LIMIT 1])
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
    }*/
    
    
    /*public Map<Id, User> ValidUsers {
        get
        {
            if (ValidUsers == null)
            {
                ValidUsers = new Map<Id, User> ([SELECT Id, Name, State, isActive 
                                                 FROM User
                                                 WHERE userrole.name = 'Vehicles Direct Sales']);                
            }
            return ValidUsers;
        }
        set;    
    }*/
    
    // The upper part of the report to show total number of leads
    /*public Integer OverallLeads  { 
        get
        {
            OverallLeads = 0;
            if(ValidUsers != null && ValidUsers.size()>0){
            
                // find the number of leads for the month
                for (AggregateResult[] ar : [SELECT COUNT(Id)
                                             FROM Custom_Opportunity__c
                                             WHERE VD_Date_Sent__c >= :StartDate
                                             AND VD_Date_Sent__c < :EndDate
                                             AND OwnerId IN :ValidUsers.keySet()])
                {
                    OverallLeads = Integer.valueOf(ar[0].get('expr0'));
                } 
            
            }                                             
            
            return OverallLeads;
        }
       set;
    }   */
    
    private Date StartDate {
        get
        {
            return Date.newInstance(Year, Month, 1);
        }
    }
    
    private Date EndDate {
        get
        {
            return StartDate.addMonths(1);
        }
    }
    
    public List<SelectOption> Years {
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
    
    public PageReference getConsultants() {
        System.debug('getConsultants...');
        conObjectWrapperList.clear();
        totalAmount = 0;
        leadCount = 0;

        List<Custom_Opportunity__c> oppList = [
                SELECT Id, Name, VD_Commission_Ex_GST__c, VD_Worksheet__r.VD_Approver__c, Dealer_Name__c
                FROM Custom_Opportunity__c
                WHERE Date_Settled__c >= :StartDate AND Date_Settled__c < :EndDate
                AND VD_Status__c = 'Send back to Sales Consultant'
                AND Status__c = 'Settled'
                AND VD_Is_Old_Process__c = false

            ];
        Set<Id> whIds = new Set<Id>();
        Set<Id> approverIds = new Set<Id>();
        Map<Id, ConWrapper> wrapMap = new Map<Id, ConWrapper>();
        for (Custom_Opportunity__c o : oppList) {
            
            if (!whIds.contains(o.VD_Worksheet__c)) {
                whIds.add(o.VD_Worksheet__c);
                Id vdWsApproverId = o.VD_Worksheet__r.VD_Approver__c;
                approverIds.add(vdWsApproverId);
                ConWrapper c = wrapMap.get(vdWsApproverId);
                if (c == null) {
                    c = new ConWrapper();
                    wrapMap.put(vdWsApproverId, c);
                }
                c.ldCount++;
                c.totalAmtVal += o.VD_Commission_Ex_GST__c;

                leadCount++;
                totalAmount += o.VD_Commission_Ex_GST__c;
            }
        }

        Map<Id, User> ValidUsers = new Map<Id, User> ([
                SELECT Id, Name, State, isActive FROM User 
                WHERE (Id in :approverIds OR (userrole.name = 'Vehicles Direct Sales' AND isActive = true))
                ORDER BY Name]);
        System.debug('Valid users >> ' + ValidUsers.size());
        for (Id key : ValidUsers.keySet()) {
            System.debug('Finding data for key >> ' + key);
            ConWrapper c = wrapMap.get(key);
            if (c == null) {
                c = new ConWrapper(ValidUsers.get(key));
                wrapMap.put(key, c);
            } else {
                c.userObj = ValidUsers.get(key);
            }
        }

        conObjectWrapperList.addAll(wrapMap.values());

        
        System.debug('Total record to show >> ' + conObjectWrapperList.size());

        

        return null;

    }

    // 'ConWrapper' wrapper class initialization.
    // The lower part of the report
    public class ConWrapper {
        // The user object instance to get the consultant name
        public User userObj {get; set;}
        
        // Total Commission
        public Decimal totalAmtVal{get;set;}
        
        // Number of leads
        public Integer ldCount{get;set;}
        
        // ConWrapper class Constructor
        public ConWrapper() {
            this.userObj = null;
            this.totalAmtVal = 0.0;
            this.ldCount = 0;
        }

        public ConWrapper(User u) {
            this();
            this.userObj = u;
        }
                
    }
    
}