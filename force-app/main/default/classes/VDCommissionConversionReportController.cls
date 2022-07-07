public with sharing class VDCommissionConversionReportController {

    public VDCommissionConversionReportController()
    {
        // default the month and year to now
        Month = Date.today().month();
        Year = Date.today().year();                
    }

    public Integer Month { get; set; }
    public Integer Year { get; set; }
    
    
    /*public Set<Id> usrIds {
        get
        {
            if (usrIds == null)
            {

                usrIds = new Set<Id>();
                for (Group g : [SELECT Id
                    FROM Group
                    WHERE DeveloperName = 'Vehicles_Direct' AND Type = 'Regular' 
                    LIMIT 1])
                {
                    
                    for (GroupMember gm : [SELECT UserOrGroupId
                                           FROM GroupMember
                                           WHERE GroupId = :g.Id])
                    {
                        usrIds.add(gm.UserOrGroupId);
                    } 
                    
                }

            }
            return usrIds;
        }
        set;
    }*/
    
    
    
    /*public Map<Id, User> ValidUsers {
        get
        {
            if(usrIds != null && usrIds.size()>0){
            
                if (ValidUsers == null)
                {
                    
                    ValidUsers = new Map<Id, User> ([SELECT Id
                                                     FROM User WHERE ID IN: usrIds]);
                                                     
                                                  
                }
                return ValidUsers;
                
            }
            return null;
        }
        set;    
    }*/
        
       
    public Decimal OverallLoanSales { get; set; }
    public Decimal OverallPctBudget { get; set; }
    public Decimal OverallInsuranceSales { get; set; }
    public Decimal OverallInsuranceConversion { get; set; }
    public Decimal OverallCommission {get; set; }
    public Decimal OverallBudget {get; set; }
    public Decimal OverallNAF {get; set; }
    public Decimal OverallInsuranceCommission {get; set; }
    public Decimal OverallBrokerageAndDOF {get; set; }
        
    
    public Integer OverallLeads {set;get;}
    
    public Decimal OverallLeadConversion { get; set; }

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

    public List<Consultant> Consultants {
        get {

            Set<Id> userIds = new Set<Id>();
            Map<Id, Consultant> consMap = new Map<Id, Consultant>();            


            List<Custom_Opportunity__c> oppList = [
            	SELECT Id, Name, VD_Commission_Ex_GST__c, VD_Worksheet__r.VD_Approver__c, Dealer_Name__c
            	FROM Custom_Opportunity__c
            	WHERE Date_Settled__c >= :StartDate AND Date_Settled__c < :EndDate
                AND VD_Status_Process__c = 'Send back to Sales Consultant'
                AND Status__c = 'Settled'
                AND VD_Is_Old_Process__c = false
                AND Loan_Product__r.Quoting_Source__c != 'Latitude Personal Loan'
                AND Loan_Product__r.Loan_Type__c != 'Refinance'
                AND Loan_Product__r.Loan_Type__c != 'Sale & Lease Back'
            ];

            Set<Id> whIds = new Set<Id>();
            for (Custom_Opportunity__c o : oppList) {
                
                if (!whIds.contains(o.VD_Worksheet__c)) {
                    whIds.add(o.VD_Worksheet__c);
                	Id vdWsApproverId = o.VD_Worksheet__r.VD_Approver__c;
                	userIds.add(vdWsApproverId);
                	Row r = new Row(o.Name);
                	r.vdCommissionExGST = o.VD_Commission_Ex_GST__c;
                	r.dealerName = o.Dealer_Name__c;
                	Consultant c = consMap.get(vdWsApproverId);
                	if (c == null) {
                		c = new Consultant('');
                		consMap.put(vdWsApproverId, c);
                	}
                	c.Rows.put(o.Id, r);
                }
            }
            System.debug('oppList >> ' + oppList.size());
            System.debug('consMap >> ' + consMap.size());
            System.debug('userIds >> ' + userIds.size());

            if (!userIds.isEmpty()) {
            	List<User> userList = [SELECT Id, Name FROM User WHERE Id in :userIds];
            	for (User u : userList) {
            		Consultant c = consMap.get(u.Id);
            		if (c != null) {
            			c.Name = u.Name;
            		}
            	}
            }

            OverallCommission = 0;
            OverallLeads = 0;
            
            // loop through the results to construct the total rows   
            for (Id k : consMap.keySet()) {   
                Consultant con = consMap.get(k);
                    
                // calculate the total rows                
                Row total = new Row('Total');                
                total.style = 'background-color: LemonChiffon;';
                
                Row numLoanSales = new Row('# of Leads');                
                numLoanSales.Style = 'background-color: Plum;';                
                numLoanSales.vdCommissionExGST = 0;
                numLoanSales.vdCommissionExGSTFormat = '{0, number, #,###}';
                                                                                
                for (Row r : con.RowValues) {
                    total.vdCommissionExGST += r.vdCommissionExGST;                   
                    numLoanSales.vdCommissionExGST++;
                    OverallLeads++;
                }                
                                                                
                // add the totals row on to the end
                con.RowValues.add(total);
                con.RowValues.add(numLoanSales);
                           
                // add to the overall totals
                OverallCommission += total.vdCommissionExGST;
            }
            
            Consultants = consMap.values(); 
            
            return Consultants;
            
        }
        set;     
    }
  
    public List<SelectOption> Years
    {
        get
        {
            if (Years == null)
            {
                Years = new List<SelectOption>();
                Integer y = 2016;
                
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
  
    private class Consultant
    {
        public Consultant(String n)
        {        
            Name = n;
            Rows = new Map<Id, Row>();
            NumLeads = 0;            
        }
    
        public String Name { get; set; }
        public Map<Id, Row> Rows { get; set; }        
        public Integer NumLeads { get; set; }        
        
        public List<Row> RowValues
        {
            get
            {
                if (RowValues == null)
                {
                    RowValues = Rows.values();                                                
                }
                return RowValues;
            }
            set;
        }                                                       
    }
    
    private class Row
    {
        public Row(String c)
        {            
            Client = c;            
            // initialise the properties
            vdCommissionExGST = 0.0;
            dealerName = '';
            // set up the default formatting
            vdCommissionExGSTFormat = '{0, number, $#,###,###.00}';
        }
            
        public String Client { get; set; }     
        public Decimal vdCommissionExGST { get; set; }        
        public String vdCommissionExGSTFormat { get; set; }
        public String dealerName { get; set; }
        
        public String Style { get; set; }
    
     
   }     
  
}