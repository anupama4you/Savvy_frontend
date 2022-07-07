public class CommissionConversionReport
{
    public CommissionConversionReport()
    {
        // default the month and year to now
        Month = Date.today().month();
        Year = Date.today().year();                
    }

    public Integer Month { get; set; }
    public Integer Year { get; set; }
    
      public Set<Id> usrIds
    {
        get
        {
            if (usrIds == null)
            {

                usrIds = new Set<Id>();
                for (Group g : [SELECT Id
                    FROM Group
                    WHERE DeveloperName = 'Sales_Consultants' and Type = 'Regular'
                    LIMIT 1])
                {
                    
                    for (GroupMember gm : [SELECT UserOrGroupId
                                           FROM GroupMember
                                           WHERE GroupId = :g.Id])
                    {
                        usrIds.add(gm.UserOrGroupId);
                    } 
                    
                }

                // Add Franchised consultants
                List<User> fu = SOQLSingletonQueries.recs().franchisedCounsultantList;
                if (fu != null && !fu.isEmpty()) {
                  for (User x : fu) {
                    usrIds.add(x.Id);
                  }
                }

            }
            return usrIds;
        }
        set;
    }
    
    
    
    public Map<Id, User> ValidUsers
    {
        get
        {
            if(usrIds != null && usrIds.size()>0){
            
                if (ValidUsers == null)
                {
                    
                    ValidUsers = new Map<Id, User> ([SELECT Id
                                                     FROM User WHERE ID IN: usrIds]);
                                                     
                                                   /*  RoleIds OR UserRole.Name ='Settlement_Team']); 
                                                     
                                                   WHERE UserRoleId IN :RoleIds
                                                   AND UserRole.Name != 'Peter_Team'
                                                     AND UserRole.Name != 'Phil_Team'
                                                     AND UserRole.Name != 'Settlement_Team'
                                                     AND UserRole.Name != 'System_Generated'
                                                     AND UserRole.Name != 'Director' 
                                                     AND UserRoleId !='00EN0000000M1yR' 
                                                     ]); */   
                }
                return ValidUsers;
                
            }
            return null;
        }
        set;    
    }
        
       
    public Decimal OverallLoanSales { get; set; }
    public Decimal OverallPctBudget { get; set; }
    public Decimal OverallInsuranceSales { get; set; }
    public Decimal OverallInsuranceConversion { get; set; }
    public Decimal OverallCommission {get; set; }
    public Decimal OverallBudget {get; set; }
    public Decimal OverallNAF {get; set; }
    public Decimal OverallInsuranceCommission {get; set; }
    public Decimal OverallBrokerageAndDOF {get; set; }
    public Integer OverallVDLeads {get; set;}
    
    public Integer OverallLeads 
    { 
        get
        {
            OverallLeads = 0;
            
            if(ValidUsers != null && !ValidUsers.isEmpty()){
            
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
    
    
    
    public Decimal OverallLeadConversion { get; set; }

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

    public List<Consultant> Consultants
    {
        get
        {
            Set<Id> userIds = new Set<Id>();
            Map<Id, Consultant> consMap = new Map<Id, Consultant>();            
            OverallLoanSales = 0;
            OverallPctBudget = 0;
            OverallInsuranceSales = 0;
            OverallInsuranceConversion = 0;        
            OverallLeadConversion = 0;
            OverallCommission = 0;
            OverallBudget =0;
            OverallNAF =0;
            OverallInsuranceCommission =0;
            OverallBrokerageAndDOF =0;
            OverallVDLeads = 0;
            
            // find the consultants that looked at at least one lead for the month
                      
          if(ValidUsers != null && !ValidUsers.isEmpty() && StartDate!= null && EndDate != null ){
            
                for (Lead__c l : [SELECT Id,
                                         OwnerId,
                                         Owner.Name
                                  FROM Lead__c
                                  WHERE Date_Lead_to_Consultant__c >= :StartDate
                                  AND Date_Lead_to_Consultant__c < :EndDate
                                  AND OwnerId IN :ValidUsers.keySet()])
                {             
                    if(l.OwnerId != null){
                    
                        userIds.add(l.OwnerId);
                                
                        // see if the consultant already exists in the map
                        if (!consMap.containsKey(l.OwnerId))
                        {
                            consMap.put(l.OwnerId, new Consultant(l.Owner.Name));           
                        }  
                        
                       // increment the lead count                
                        consMap.get(l.OwnerId).NumLeads += 1;
                    }
                     
                }
            
            }                           
                                                                                       
            // loop through the products for opportunities for the leads
            for (Product__c p : [SELECT Id, Insurer__c,
                                        Opportunity_Name__r.Lead__c, 
                                        Opportunity_Name__r.Lead__r.OwnerId,          
                                        Opportunity_Name__r.Lead__r.Owner.Name,                                            
                                        Opportunity_Name__r.Name,
                                        RecordType.Name, Insurance_Commission_2__c,
                                        Opportunity_Name__r.Ownerid,
                                        // finance fields
                                        Opportunity_Name__r.NAF_Net_Amount_Financed__c,
                                        Lender__c,
                                        Brokerage_2__c,
                                        DOF_2__c,
                                        // insurance fields
                                        Insurance_Type__c,
                                        Opportunity_Name__r.NAP_Net_Amount_Policy__c,
                                        Opportunity_Name__r.VD_Commission_Ex_GST__c,
                                        Opportunity_Name__r.VD_Status__c,
                                        Opportunity_Name__r.VD_Is_Old_Process__c       
                                 FROM Product__c 
                                 WHERE 
                                   Opportunity_Name__r.Owner.Name != 'System Generated'
                                 AND Opportunity_Name__r.Date_Settled__c >= :StartDate
                                 AND Opportunity_Name__r.Date_Settled__c < :EndDate
                                 AND Opportunity_Name__r.Status__c = 'Settled'])
            {                                                                                                                    
                
                if(consMap != null && !consMap.isEmpty() && p.Opportunity_Name__c != null){
                    
                    // see if the client already exists for the consultant
                    if(consMap.ContainsKey(p.Opportunity_Name__r.OwnerId)){
                    
                        if ( consMap.get(p.Opportunity_Name__r.OwnerId) != null){
                        
                            if(!consMap.get(p.Opportunity_Name__r.OwnerId).Rows.containsKey(p.Opportunity_Name__c)){
                            
                                consMap.get(p.Opportunity_Name__r.OwnerId).Rows.put(p.Opportunity_Name__c, new Row(p.Opportunity_Name__r.Name));
                                /*if ('Send back to Sales Consultant'.equals(p.Opportunity_Name__r.VD_Status__c) &&
                                    !p.Opportunity_Name__r.VD_Is_Old_Process__c) {
                                    consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).vdCommission = p.Opportunity_Name__r.VD_Commission_Ex_GST__c;
                                    OverallVDLeads++;
                                }*/
                            }
                            
                        }

                        // add the data as required
                        if (p.RecordType.Name == 'Finance')
                        {
                            consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).AmountFinanced += p.Opportunity_Name__r.NAF_Net_Amount_Financed__c;
                            consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).Lender = p.Lender__c;
                            consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).BrokerageDOF += p.Brokerage_2__c;
                            consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).BrokerageDOF += p.DOF_2__c;

                            
                            
                        }                     
                        else if (p.RecordType.Name == 'Insurance')
                        {
                            if (p.Insurance_Type__c == 'Gap Insurance' || p.Insurance_Type__c == 'VEI')
                            {
                                consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).GAPPPI += p.Insurance_Commission_2__c;    
                            }
                            else if (p.Insurance_Type__c == 'PPI')
                            {
                                consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).GAPPPI += p.Insurance_Commission_2__c;
                            }  
                            else if (p.Insurance_Type__c == 'Warranty')
                            {
                                if ('NWC'.equals(p.Insurer__c)) {
                                    consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).NationalWarranty += p.Insurance_Commission_2__c;     
                                } else {
                                    consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).Warranty += p.Insurance_Commission_2__c;     
                                }
                            }
                            else if (p.Insurance_Type__c == 'Full Comprehensive')
                            {
                                consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).Comprehensive += p.Insurance_Commission_2__c;     
                            }
                            /*else if (p.Insurance_Type__c == 'Loan Protection')
                            {
                                consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).LPI += p.Insurance_Commission_2__c;     
                            }*/
                            else if (p.Insurance_Type__c == 'Tyre and Rim Insurance')
                            {
                                consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).TyreRim += p.Insurance_Commission_2__c;     
                            }
                             else if (p.Insurance_Type__c == 'FPA')
                            {
                                consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).FPA += p.Insurance_Commission_2__c;     
                            }
                             else if (p.Insurance_Type__c == 'ISP')
                            {
                                consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).ISP += p.Insurance_Commission_2__c;     
                            }
                             else if (p.Insurance_Type__c == 'LTI')
                            {
                                consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).LTI += p.Insurance_Commission_2__c;     
                            }
                             else if (p.Insurance_Type__c == 'CCI' || p.Insurance_Type__c == 'Loan Protection')
                            {
                                consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).CCI += p.Insurance_Commission_2__c;     
                            }
                             else if (p.Insurance_Type__c == 'Truck Gap Insurance')
                            {
                                consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).TruckGAP += p.Insurance_Commission_2__c;     
                            }
                             else if (p.Insurance_Type__c == 'Type and Rim Insurance')
                            {
                                consMap.get(p.Opportunity_Name__r.OwnerId).Rows.get(p.Opportunity_Name__c).TAI += p.Insurance_Commission_2__c;     
                            }
                        }
                
                    }
                
                }
                          
           }
            
            Map<Id, User> users;
            
            if(userIds != null && userIds.size()>0){
                
                // get the user records
                users = new Map<Id, User> ([SELECT Id, 
                                                          Monthly_Commission_Target__c
                                                          FROM User
                                                          WHERE Id = :userIds ]);
                                                      
            }
         
            Decimal overallTotal = 0;
            Decimal overallMonthlyTarget = 0;
                                                            
            if(consMap!=null && consMap.size()>0){
            // loop through the results to construct the total rows   
            for (String k : consMap.keySet())                                  
            {   
                Consultant con = consMap.get(k);
                    
                // calculate the total rows                
                Row total = new Row('Total');                
                total.style = 'background-color: LemonChiffon;';
                
                Row numLoanSales = new Row('# of Loan sales');                
                numLoanSales.style = 'background-color: Plum;';                
                numLoanSales.Total = 0;
                numLoanSales.TotalFormat = '{0, number, #,###}';
                
                //Total Commission
                Row numTotalCommission = new Row('Total Commission');
                numTotalCommission.style = 'background-color: LemonChiffon;';
                numTotalCommission.Total = 0;
                numTotalCommission.TotalFormat = '{0, number, $##,###,###.00}';
                
                //Total Budget
                Row numTotalBudget = new Row('Total budget (ex GST)');
                numTotalBudget.style = 'background-color: LemonChiffon;';
                numTotalBudget.Total = 0;
                numTotalBudget.TotalFormat = '{0, number, $##,###,###.00}';
                
                
                //Total NAF
                Row numTotalNAF = new Row('Total Net Amount Financed');
                numTotalNAF.style = 'background-color : Plum;';
                numTotalNAF.Total= 0;
                numTotalNAF.TotalFormat = '{0, number, $##,###,###.00}';
                
                //Total Insurance Commission
                Row numTotalInsuranceCommission = new Row('Total Insurance Commission (ex GST)');
                numTotalInsuranceCommission.Total = 0;
                numTotalInsuranceCommission.TotalFormat = '{0, number, $##,###,###.00}';
                
                //Total Brokerage and DOF
                Row numTotalBrokerageDOF = new Row('Total Brokerage/DOF (ex GST');
                numTotalBrokerageDOF.Total = 0;
                numTotalBrokerageDOF.TotalFormat = '{0, number, $##,###,###.00}';
                
                //Insurance Sales
                Row numInsuranceSales = new Row('# Insurance Sales');
                numInsuranceSales.style = 'background-color: lightgray;';
                numInsuranceSales.GAPPPI = 0;
                numInsuranceSales.Warranty = 0;
                numInsuranceSales.NationalWarranty = 0;
                numInsuranceSales.Comprehensive = 0;
                numInsuranceSales.LPI = 0;
                numInsuranceSales.LTI = 0;          //Lelo          2016-10-10
                numInsuranceSales.CCI = 0;          //Lelo          2016-10-11
                numInsuranceSales.TAI = 0;          //Lelo          2016-10-11
                numInsuranceSales.TruckGAP = 0;          //Lelo          2016-10-11
                numInsuranceSales.TyreRim = 0;
                numInsuranceSales.FPA = 0;
                numInsuranceSales.ISP = 0;
                numInsuranceSales.Total = 0;
                numInsuranceSales.GAPPPIFormat = '{0, number, #,###}';
                numInsuranceSales.WarrantyFormat = '{0, number, #,###}';
                numInsuranceSales.NationalWarrantyFormat = '{0, number, #,###}';
                numInsuranceSales.ComprehensiveFormat = '{0, number, #,###}';
                numInsuranceSales.LPIFormat = '{0, number, #,###}';
                numInsuranceSales.LTIFormat = '{0, number, #,###}';
                numInsuranceSales.CCIFormat = '{0, number, #,###}';
                numInsuranceSales.TAIFormat = '{0, number, #,###}';
                numInsuranceSales.TruckGAPFormat = '{0, number, #,###}';
                numInsuranceSales.TyreRimFormat = '{0, number, #,###}';
                numInsuranceSales.FPAFormat = '{0, number, #,###}';
                numInsuranceSales.ISPFormat = '{0, number, #,###}';
                numInsuranceSales.TotalFormat = '{0, number, #,###}';
                                                
                Row numLeadsRow = new Row('# Leads');
                numLeadsRow.style = 'background-color: LemonChiffon;';
                numLeadsRow.Total = con.NumLeads;
                numLeadsRow.TotalFormat = '{0, number, #,###}';                
                                                                                
                for (Row r : con.RowValues)
                {
                    total.AmountFinanced += r.AmountFinanced;
                    total.BrokerageDOF += r.BrokerageDOF;
                    total.GAPPPI += r.GAPPPI;
                    total.Warranty += r.Warranty;
                    total.NationalWarranty += r.NationalWarranty;
                    total.Comprehensive += r.Comprehensive;
                    total.LPI += r.LPI;
                    total.LTI += r.LTI;             //Lelo 2016-10-10
                    total.CCI += r.CCI;             //Lelo 2016-10-11
                    total.TAI += r.TAI;             //Lelo 2016-10-11
                    total.TruckGAP += r.TruckGAP;             //Lelo 2016-10-11
                    total.TyreRim += r.TyreRim;      
                    total.FPA += r.FPA;
                    total.ISP += r.ISP;
                    total.vdCommission += r.vdCommission;       //Lelo      2016-12-07
                                       
                    numLoanSales.Total += (r.AmountFinanced > 0 || r.BrokerageDOF > 0 ? 1 : 0); 
                                        
                    numInsuranceSales.GAPPPI += (r.GAPPPI > 0 ? 1 : 0);
                    numInsuranceSales.Warranty += (r.Warranty > 0 ? 1 : 0);
                    numInsuranceSales.NationalWarranty += (r.NationalWarranty > 0 ? 1 : 0);
                    numInsuranceSales.Comprehensive += (r.Comprehensive > 0 ? 1 : 0);
                    numInsuranceSales.LPI += (r.LPI > 0 ? 1 : 0);
                    numInsuranceSales.LTI += (r.LTI > 0 ? 1 : 0);               //Lelo 2016-10-10
                    numInsuranceSales.CCI += (r.CCI > 0 ? 1 : 0);               //Lelo 2016-10-11
                    numInsuranceSales.TAI += (r.TAI > 0 ? 1 : 0);               //Lelo 2016-10-11
                    numInsuranceSales.TruckGAP += (r.TruckGAP > 0 ? 1 : 0);               //Lelo 2016-10-11
                    numInsuranceSales.TyreRim += (r.TyreRim > 0 ? 1 : 0);
                    numInsuranceSales.FPA += (r.FPA > 0 ? 1 : 0);
                    numInsuranceSales.ISP += (r.ISP > 0 ? 1 : 0);
                    numInsuranceSales.Total += (r.GAPPPI > 0 ? 1 : 0) + (r.Warranty > 0 ? 1 : 0) + (r.NationalWarranty > 0 ? 1 : 0) + 
                                               (r.Comprehensive > 0 ? 1 : 0) + (r.LPI > 0 ? 1 : 0) + (r.TyreRim > 0 ? 1 : 0) + (r.FPA > 0 ? 1 : 0) + 
                                               (r.ISP > 0 ? 1 : 0) + (r.LTI > 0 ? 1 : 0) + (r.CCI > 0 ? 1 : 0) + (r.TruckGAP > 0 ? 1 : 0) + 
                                               (r.TAI > 0 ? 1 : 0);
                    
                }                
                   
                Row pctBudget = new Row('% of Budget');
                pctBudget.style = 'background-color: Plum;';                
                pctBudget.Total = null;
                pctBudget.TotalFormat = '{0, number, #,###.##%}';   
                overallTotal += total.Total;                
                
                // only find the actual % of budget if the monthly commission target is defined as greater than zero for the user
                if (users.get(k).Monthly_Commission_Target__c > 0)
                {
                    pctBudget.Total = total.Total / users.get(k).Monthly_Commission_Target__c;
                    overallMonthlyTarget += users.get(k).Monthly_Commission_Target__c;
                }
                        
                Row insuranceConversion = new Row('Insurance Conversion');
                insuranceConversion.style = 'background-color: lightgray;';   
                insuranceConversion.GAPPPI = numLoanSales.Total > 0 ? numInsuranceSales.GAPPPI / numLoanSales.Total : 0; 
                insuranceConversion.Warranty = numLoanSales.Total > 0 ? numInsuranceSales.Warranty / numLoanSales.Total : 0;
                insuranceConversion.NationalWarranty = numLoanSales.Total > 0 ? numInsuranceSales.NationalWarranty / numLoanSales.Total : 0;    //Lelo 2016-10-11
                insuranceConversion.Comprehensive = numLoanSales.Total > 0 ? numInsuranceSales.Comprehensive / numLoanSales.Total : 0;
                insuranceConversion.LPI = numLoanSales.Total > 0 ? numInsuranceSales.LPI / numLoanSales.Total : 0;
                insuranceConversion.LTI = numLoanSales.Total > 0 ? numInsuranceSales.LTI / numLoanSales.Total : 0;              //Lelo      2016-10-10
                insuranceConversion.CCI = numLoanSales.Total > 0 ? numInsuranceSales.CCI / numLoanSales.Total : 0;              //Lelo      2016-10-11
                insuranceConversion.TAI = numLoanSales.Total > 0 ? numInsuranceSales.TAI / numLoanSales.Total : 0;              //Lelo      2016-10-11
                insuranceConversion.TruckGAP = numLoanSales.Total > 0 ? numInsuranceSales.TruckGAP / numLoanSales.Total : 0;              //Lelo      2016-10-11
                insuranceConversion.TyreRim = numLoanSales.Total > 0 ? numInsuranceSales.TyreRim / numLoanSales.Total : 0;
                insuranceConversion.FPA = numLoanSales.Total > 0 ? numInsuranceSales.FPA / numLoanSales.Total : 0;
                insuranceConversion.ISP = numLoanSales.Total > 0 ? numInsuranceSales.ISP / numLoanSales.Total : 0;
                insuranceConversion.Total = numLoanSales.Total > 0 ? numInsuranceSales.Total / numLoanSales.Total : 0;
                insuranceConversion.GAPPPIFormat = '{0, number, #,###%}'; 
                insuranceConversion.WarrantyFormat = '{0, number, #,###%}'; 
                insuranceConversion.NationalWarrantyFormat = '{0, number, #,###%}';     //Lelo 2016-10-11
                insuranceConversion.ComprehensiveFormat = '{0, number, #,###%}'; 
                insuranceConversion.LPIFormat = '{0, number, #,###%}'; 
                insuranceConversion.LTIFormat = '{0, number, #,###%}'; 
                insuranceConversion.CCIFormat = '{0, number, #,###%}'; 
                insuranceConversion.TAIFormat = '{0, number, #,###%}'; 
                insuranceConversion.TruckGAPFormat = '{0, number, #,###%}'; 
                insuranceConversion.TyreRimFormat = '{0, number, #,###%}'; 
                insuranceConversion.FPAFormat = '{0, number, #,###%}';
                insuranceConversion.ISPFormat = '{0, number, #,###%}';
                insuranceConversion.TotalFormat = '{0, number, #,###%}'; 
                
                Row leadConversion = new Row('Lead Conversion');  
                leadConversion.style = 'background-color: LemonChiffon;';           
                leadConversion.Total = con.NumLeads > 0 ? numLoanSales.Total / con.NumLeads : 0;
                leadConversion.TotalFormat = '{0, number, #,###.##%}'; 
                                                
                // add the totals row on to the end
                con.RowValues.add(total);
                con.RowValues.add(numLoanSales);
                con.RowValues.add(pctBudget);
                con.RowValues.add(numInsuranceSales);
                con.RowValues.add(insuranceConversion);
                con.RowValues.add(numLeadsRow);
                con.RowValues.add(leadConversion);
                           
                // add to the overall totals
                OverallLoanSales += numLoanSales.Total;
                OverallInsuranceSales += numInsuranceSales.Total; 
                //OverallCommission += (total.BrokerageDOF + total.GAPPPI + total.Warranty + total.Comprehensive + total.LPI + total.TyreRim + total.FPA + total.ISP);              //Lelo 2016-10-10
                OverallCommission += (total.BrokerageDOF + total.GAPPPI + total.Warranty + total.NationalWarranty + 
                                      total.Comprehensive + total.LPI + total.TyreRim + total.FPA + total.ISP + 
                                      total.LTI + total.CCI + total.TruckGAP + total.TAI + total.vdCommission);    //Lelo 2016-12-07
                OverallNAF += total.AmountFinanced;    
                OverallBudget =overallMonthlyTarget; 
                //OverallInsuranceCommission += (total.GAPPPI + total.Warranty + total.Comprehensive + total.LPI + total.TyreRim + total.FPA + total.ISP);              //Lelo      2016-10-10
                OverallInsuranceCommission += (total.GAPPPI + total.Warranty + total.NationalWarranty + 
                                               total.Comprehensive + total.LPI + total.TyreRim + total.FPA + total.ISP + 
                                               total.LTI + total.CCI + total.TruckGAP + total.TAI);    //Lelo      2016-10-10
                OverallBrokerageAndDOF += total.BrokerageDOF;                                                                    
            }
            
 
            
            Consultants = consMap.values(); 
            
            // find the overall percentages
            OverallInsuranceConversion = (OverallLoanSales > 0 ? OverallInsuranceSales / OverallLoanSales : 0);
            OverallLeadConversion = (OverallLeads > 0 ? OverallLoanSales / OverallLeads : 0); 
            if (overallMonthlyTarget > 0)
            {                                              
                OverallPctBudget = overallTotal / overallMonthlyTarget;
            }
            
            return Consultants;
            
            }
            return null;
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
            AmountFinanced = 0;
            Lender = '';
            BrokerageDOF = 0;
            GAPPPI = 0;
            Warranty = 0;
            Comprehensive = 0;
            LPI = 0;
            TyreRim = 0;  
            FPA = 0;  
            ISP = 0;  
            LTI = 0;        //Lelo      2016-10-10
            CCI = 0;        //Lelo      2016-10-11
            TAI = 0;        //Lelo      2016-10-11
            TruckGAP = 0;   //Lelo      2016-10-11
            NationalWarranty = 0;   //Lelo      2016-10-11
            vdCommission = 0;       //Lelo      2016-12-07

            // set up the default formatting
            AmountFinancedFormat = '{0, number, $#,###,###.00}';
            BrokerageDOFFormat = '{0, number, $#,###,###.00}';
            GAPPPIFormat = '{0, number, $#,###,###.00}';
            WarrantyFormat = '{0, number, $#,###,###.00}';
            NationalWarrantyFormat = '{0, number, $#,###,###.00}';      //Lelo 2016-10-11
            ComprehensiveFormat = '{0, number, $#,###,###.00}';
            LPIFormat = '{0, number, $#,###,###.00}';
            LTIFormat = '{0, number, $#,###,###.00}';           //Lelo      2016-10-10
            CCIFormat = '{0, number, $#,###,###.00}';           //Lelo      2016-10-11
            TAIFormat = '{0, number, $#,###,###.00}';           //Lelo      2016-10-11
            TruckGAPFormat = '{0, number, $#,###,###.00}';           //Lelo      2016-10-11
            TyreRimFormat = '{0, number, $#,###,###.00}';
            FPAFormat = '{0, number, $#,###,###.00}';
            ISPFormat = '{0, number, $#,###,###.00}';
            vdCommissionFormat = '{0, number, $#,###,###.00}';      //Lelo      2016-12-07
            TotalFormat = '{0, number, $#,###,###.00}';
        }
            
        public String Client { get; set; }        
        public Decimal AmountFinanced { get; set; }        
        public String Lender { get; set; }
        public Decimal BrokerageDOF { get; set; }        
        public Decimal GAPPPI { get; set; }        
        public Decimal Warranty { get; set; }
        public Decimal NationalWarranty { get; set; }   //Lelo      2016-10-11
        public Decimal Comprehensive { get; set; }
        public Decimal LPI { get; set; }
        public Decimal LTI { get; set; }                //Lelo      2016-10-10
        public Decimal CCI { get; set; }                //Lelo      2016-10-11
        public Decimal TruckGAP { get; set; }                //Lelo      2016-10-11
        public Decimal TAI { get; set; }                //Lelo      2016-10-11
        public Decimal TyreRim { get; set; }
        public Decimal FPA { get; set; }
        public Decimal ISP { get; set; }
        public Decimal vdCommission { get; set; }                //Lelo      2016-12-07
        
        public String AmountFinancedFormat { get; set; }
        public String BrokerageDOFFormat { get; set; }
        public String GAPPPIFormat { get; set; }
        public String WarrantyFormat { get; set; }
        public String NationalWarrantyFormat { get; set; }    //Lelo      2016-10-11
        public String ComprehensiveFormat { get; set; }
        public String LPIFormat { get; set; }
        public String LTIFormat { get; set; }           //Lelo      2016-10-10
        public String CCIFormat { get; set; }           //Lelo      2016-10-11
        public String TruckGAPFormat { get; set; }           //Lelo      2016-10-11
        public String TAIFormat { get; set; }           //Lelo      2016-10-11
        public String TyreRimFormat { get; set; }
        public String FPAFormat { get; set; }
        public String ISPFormat { get; set; }
        public String vdCommissionFormat { get; set; }   //Lelo      2016-12-07
        public String TotalFormat { get; set; }
        


        public Decimal Total 
        { 
            get
            {
                if (Total == null)
                {
                    return (BrokerageDOF + GAPPPI + Warranty + NationalWarranty + Comprehensive + 
                            LPI + TyreRim + FPA + ISP + LTI + CCI + TruckGAP + TAI + vdCommission);
                }
                return Total;
            }  
            set;          
        }
        
        public String Style { get; set; }
    
     
   }     
  
}