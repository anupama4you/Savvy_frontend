public class PerformanceReportHelper {

	public static final Integer SALES_REPORT = 0;
	public static final Integer INSURANCE_REPORT = 1;
	public static final Integer HOME_REPORT = 2;
	public static final Integer SALES_3_REPORT = 3;
	public static final Integer SALES_3_INS_REPORT = 4;
  public static final Integer BROKER_SALES_REPORT = 5;      // Partner Portal

	public static final Integer DEFAULT_POLLER_TIME = 60;
	public static final String SALES_POLLER_TIME_PARAMETER = 'SALES_POLLER_TIME';
	public static final String INSURANCE_POLLER_TIME_PARAMETER = 'INSURA_POLLER_TIME';
	public static final String HOME_POLLER_TIME_PARAMETER = 'HOME_POLLER_TIME';

	private static final String OPP_SOQL = '' + 
    'SELECT Id, Name, Owner_Name__c, OwnerType__c, OwnerId, Total_Commission__c, NAF_Net_Amount_Financed__c, ' + 
    '       Number_Insurance_Sales__c, Total_Insurance_Commission__c, Total_Brokerage__c, ' + 
    '       Total_DOF__c, Lead__r.Loan_Type__c, Status__c, CreatedByID, ' + 
    '       Date_Pre_Approved__c, Date_Closed_or_Settled__c, CreatedDate, ' +
    '       Number_FullComp_Ins_Sales__c, Number_Other_Ins_Sales__c, VD_Worksheet__c ' +
		'FROM Custom_Opportunity__c ';
    
  public static final List<String> customsRanges = new List<String> {
    'Current Financial Qtr', 'Last Financial Qtr', 'Calendar YTD', 'Financial YTD'
  };
	
  public static final List<String> status = new List<String> {
    'Invoice requested', 'Invoice Received', 'Sent for Settlement', 'Documents Sent', 'Documents Received', 
    'Awaiting Further Information', 'Settlement Rejected', 'Sent to Lender for Settlement', 'Internal Settlement',
    'Submitted for Formal Approval', 'Sent to Lender for Formal Approval','Formal Approved'
  };

	public class Parameter {
		public Integer reportType {set;get;}
		public Integer month {set;get;}
		public Integer year {set;get;}
		public Boolean displayInsurances {set;get;}
		public String groupName {set;get;}
    public String customRange {set;get;}
    public Set<Id> groupMembers {set;get;}
    public Set<Id> profileMembers {set;get;}
    public Boolean showFranchisedUsers {set;get;}

		public Datetime startDate {
	    get {
				Datetime r = null;
        //Yohan VillaLeal   05/08/2018  >>> This code looking for the Start Date 
        //who can filter the data with the Customs Ranges
				if('None'.equals(customRange)){
          return Datetime.newInstanceGmt(this.year, this.month, 1, 0, 0, 0);
        }else if('Last Financial Qtr'.equals(customRange)){
          if(Date.today().month() < 4) {
            return Date.newInstance(Date.today().year(), 10, 1);
          }else if(Date.today().month() >= 4 && Date.today().month() < 7) {
            return Date.newInstance(Date.today().year(), 1, 1);
          }else if(Date.today().month() >= 7 && Date.today().month() < 10) {
            return Date.newInstance(Date.today().year(), 4, 1);
          }else if(Date.today().month() >= 10 && Date.today().month() < 13) {
            return Date.newInstance(Date.today().year(), 7, 1);
          }
        }else if('Current Financial Qtr'.equals(customRange)){
          if(Date.today().month() < 4) {
            return Date.newInstance(Date.today().year(), 1, 1);
          }else if(Date.today().month() >= 4 && Date.today().month() < 7) {
            return Date.newInstance(Date.today().year(), 4, 1);
          }else if(Date.today().month() >= 7 && Date.today().month() < 10) {
            return Date.newInstance(Date.today().year(), 7, 1);
          }else if(Date.today().month() >= 10 && Date.today().month() < 13) {
            return Date.newInstance(Date.today().year(), 10, 1);
          }
        }else if('Calendar YTD'.equals(customRange)){
          return Date.newInstance(Date.today().year(), 1, 1);
        }else if('Financial YTD'.equals(customRange)){
          if(Date.today().month() > 6){
            return Date.newInstance(Date.today().year(), 7, 1);
          }else{
            return Date.newInstance(Date.today().year()-1, 7, 1);
          }
        }
        return r;
      }
    }
    
    public Datetime endDate {
      get {          
        //Yohan VillaLeal   05/08/2018  >>> This code looking for the End Date 
        //who can filter the data with the Customs Ranges
        if('None'.equals(customRange)){
        return this.startDate.addMonths(1);
        }else if('Last Financial Qtr'.equals(customRange)){
          return this.startDate.addMonths(3);
        }else if('Current Financial Qtr'.equals(customRange)){
          return this.startDate.addMonths(3);
        }else if('Calendar YTD'.equals(customRange)){
          return this.startDate.addYears(1);
        }else if('Financial YTD'.equals(customRange)){
          if(Date.today().month() > 6){
            return this.startDate.addYears(1);
          }else{
            return Datetime.newInstanceGmt(Date.today().year(), 7, 1);
          }
        }
        return null;
      }
    }
      
    public Parameter(){
      this.customRange = 'None';
      this.displayInsurances = false;
      this.showFranchisedUsers = false;
    }
      
    public Boolean isDateInPeriod(Date d) {
      Boolean r = false;
      if (d != null) {
        if (d >= this.startDate && d < this.endDate) {
          r = true;
        }
      }
      return r;
    }
      
    public Boolean isDateInPeriod(Datetime d) {
      if (d != null) {
        Datetime t = Datetime.newInstanceGmt(d.year(),d.month(), d.day(), d.hour(), d.minute(), d.second());
        if (t >= this.startDate && t < this.endDate) {
          return true;
        }
      }
      return false;
    }
	}

	public class Record implements Comparable {
		public String  state {set;get;}
		public String  ownerName {set;get;}
    public Integer totalLeads {set;get;}
    public Integer totalOpps {set;get;}
		public Integer currentPreApprals {set;get;}
		public Integer totalPreApprals {set;get;}
		public Decimal budget {set;get;}
		public Integer totalLoanSales {set;get;}
		public Decimal commission {set;get;}
		public Decimal totalNAF {set;get;}
		public Decimal totalBrokerageDOF {set;get;}
		public Integer totalComp {set;get;}
		public Integer totalInsurance {set;get;}
		public Decimal totalPipeline {set;get;}
		public Integer totalPreAppVd {set;get;}
    public Decimal totalOppsPipeline {set;get;}
    
		public Record () {
      this.totalLeads = 0;
			this.totalOpps = 0;
			this.currentPreApprals = 0;
			this.totalPreApprals = 0;
			this.budget = 0.00;
			this.totalLoanSales = 0;
			this.commission = 0.00;
			this.totalNAF = 0.00;
			this.totalBrokerageDOF = 0.00;
			this.totalComp = 0;
			this.totalInsurance = 0;
      this.totalPipeline = 0.00;
      this.totalPreAppVd = 0;
      this.totalOppsPipeline = 0;
		}

		public Decimal getBudgetConvertion() {
			Decimal r = 0.00;
			if (this.budget != null && this.budget > 0 && this.commission != null) {
				r = (this.commission / this.budget) * 100.00;
				r = r.setScale(2);
			}
			return r;
		}
        
		public Decimal getOppConvertion() {
			Decimal r = 0.00;
			if (this.totalOpps != null && this.totalOpps > 0 && this.totalLoanSales != null) {
				r = (this.totalLoanSales / Decimal.valueOf(this.totalOpps)) * 100.00;
				r = r.setScale(2);
			}
			return r;
		}
		public Decimal getCompConvertion() {
			Decimal r = 0.00;
			if (this.totalLoanSales != null && this.totalLoanSales > 0 && this.totalComp != null) {
				r = (this.totalComp / Decimal.valueOf(this.totalLoanSales)) * 100.00;
				r = r.setScale(2);
			}
			return r;
		}
		public Decimal getInsuranceConvertion() {
			Decimal r = 0.00;
			if (this.totalLoanSales != null && this.totalLoanSales > 0 && this.totalInsurance != null) {
				r = (this.totalInsurance / Decimal.valueOf(this.totalLoanSales)) * 100.00;
				r = r.setScale(2);
			}
			return r;
		}
		public Decimal getPreAppVDConvertion() {
			Decimal r = 0.00;
			if (this.totalPreApprals != null && this.totalPreApprals > 0 && this.totalPreAppVd != null) {
				r = (this.totalPreAppVd / Decimal.valueOf(this.totalPreApprals)) * 100.00;
				r = r.setScale(2);
			}
			return r;
		}

		public Integer compareTo(Object o) {
			Record r = (Record)o;
			Integer returnValue = 0;
			if (String.isNotBlank(this.state) && String.isNotBlank(r.state)) {
				returnValue = this.state.compareTo(r.state);
			} else if (String.isNotBlank(this.state) && String.isBlank(r.state)) {
				returnValue = -1;
			} else if (String.isBlank(this.state) && String.isNotBlank(r.state)) {
				returnValue = 1;
			}
			if (returnValue == 0) {
				if (String.isNotBlank(this.ownerName) && String.isNotBlank(r.ownerName)) {
					returnValue = this.ownerName.compareTo(r.ownerName);
				} else if (String.isNotBlank(this.ownerName) && String.isBlank(r.ownerName)) {
					returnValue = -1;
				} else if (String.isBlank(this.ownerName) && String.isNotBlank(r.ownerName)) {
					returnValue = 1;
				}	
			}
			return returnValue;
		}

    //Yohan VillaLeal   07/08/2018  >>>
    public Decimal getCalcProjection(){
      return this.commission + this.totalPipeline;
    }

	}

	public static List<Custom_Opportunity__c> search(Parameter param) {
		List<Custom_Opportunity__c> r = null;
		if (param != null) {
			Datetime startDate = param.startDate;
			Datetime endDate = param.endDate;
			Date startDate2 = param.startDate.date();
			Date endDate2 = param.endDate.date();
			String settledAppStatus = 'Settled';
			String preAppStatus = 'Pre-Approved';
      List<String> statusOpp = new List<String>();
      statusOpp.addAll(status);
      statusOpp.add(preAppStatus);
      String sd = DateUtils.convertToString(startDate.dateGmt(), DateUtils.FORMAT_QUERY2);
      String ed = DateUtils.convertToString(endDate.dateGmt(), DateUtils.FORMAT_QUERY2);
			String wh = '((Date_Closed_or_Settled__c >= '+sd+' AND Date_Closed_or_Settled__c < '+ed+' AND Status__c = :settledAppStatus) OR ' +
			            '(Date_Pre_Approved__c >= :startDate2 AND Date_Pre_Approved__c < :endDate2) OR ' +
			            '(Status__c IN :statusOpp) OR ' + 
			            '(CreatedDate >= '+sd+' AND CreatedDate < '+ed+')) ';
			List<String> loanTypes = getLoanTypesByReportType(param.reportType);
			if (INSURANCE_REPORT == param.reportType || HOME_REPORT == param.reportType) {
				if (!loanTypes.isEmpty()) {
					wh += ' AND (Lead__r.Loan_Type__c = :loanTypes)';
				}
			} else if (
        SALES_REPORT == param.reportType || 
        SALES_3_REPORT == param.reportType || 
        SALES_3_INS_REPORT == param.reportType
        
      ) {
				if (!loanTypes.isEmpty()) {
					wh += ' AND (NOT(Lead__r.Loan_Type__c IN :loanTypes))';
				}
				String homeLoanQueue = 'Home Loans';
				wh += ' AND (Owner_Name__c != :homeLoanQueue)'; //exclude home loans by OwnerName
				//if (SALES_3_REPORT == param.reportType || SALES_3_INS_REPORT == param.reportType) {
					loadGroupMembers(param);
					loadProfileMembers(param);
					Set<Id> owners = param.groupMembers;
					Set<Id> uprofiles = param.profileMembers;
					if (uprofiles != null && !uprofiles.isEmpty()) {
						owners.addAll(uprofiles);
					} 
					if (owners != null && !owners.isEmpty()) {
						wh += ' AND ((OwnerType__c = \'User\' AND OwnerId in :owners) OR (OwnerType__c = \'Queue\' AND CreatedByID in :owners))' ;
					}
					//if (uprofiles != null && !uprofiles.isEmpty()) {
					//	if (String.isNotBlank(whUsers)) {
					//		whUsers += ' OR '	
					//	}	
					//	whUsers = ' ((OwnerType__c = \'User\' AND OwnerId in :owners) OR (OwnerType__c = \'Queue\' AND CreatedByID in :owners))' ;
					//}
					//if (String.isNotBlank(whUsers)) {
					//	wh += ' AND (' + whUsers + ')';
					//}

				//}
				//if (SALES_3_INS_REPORT == param.reportType) {
				//	wh += ' AND (Total_Insurance_Commission__c > 0)';
				//}
			} else if (BROKER_SALES_REPORT == param.reportType) {
        if (!loanTypes.isEmpty()) {
					wh += ' AND (NOT(Lead__r.Loan_Type__c IN :loanTypes))';
				}
        Id accountId = SOQLSingletonQueries.recs().myAccountId;
        System.debug('accountId => ' + accountId);
        if (accountId != null) {
          wh += ' AND (Partner_Owner__c = :accountId)';
        } else {
          wh += ' AND (OwnerType__c = \'NONE\')';
        }
      }

			if (String.isNotBlank(wh)) {
				wh = 'WHERE ' + wh;
				if(Test.isRunningTest()){
					wh += ' LIMIT 100';
				}
			}
			//String sql = OPP_SOQL + wh + ' ORDER BY LastModifiedDate DESC';
			String sql = OPP_SOQL + wh;
			System.debug('Date range A: ' + startDate + ' - ' + endDate);
			System.debug('Date range B1: ' + DateUtils.convertToString(startDate, DateUtils.FORMAT_QUERY) + ' - ' + DateUtils.convertToString(endDate, DateUtils.FORMAT_QUERY));
			System.debug('Date range B2: ' + DateUtils.convertToString(startDate.dateGmt(), DateUtils.FORMAT_QUERY2) + ' - ' + DateUtils.convertToString(endDate.dateGmt(), DateUtils.FORMAT_QUERY2));
			System.debug('Date range2: ' + param.startDate.dateGmt() + ' - ' + param.endDate.dateGmt());
			System.debug('Date range3: ' + param.startDate + ' - ' + param.endDate);
			System.debug('loanTypes: ' + loanTypes);
			System.debug('statusOpp: ' + statusOpp);
			System.debug('settledAppStatus: ' + settledAppStatus);
			System.debug('Query: ' + sql);
			System.debug('Where: ' + wh);
			r = Database.query(sql);
      System.debug('Total records: ' + r.size());
		}
		return r;
	}

	private static List<String> getLoanTypesByReportType(Integer reportType) {
		List<String> r = new List<String>();
		if (INSURANCE_REPORT == reportType) {
			r.add('Insurance');
		} else if (HOME_REPORT == reportType) {
			r.add('Home Loan');
		} else if (SALES_REPORT == reportType || SALES_3_REPORT == reportType || SALES_3_INS_REPORT == reportType) {
			r.add('Insurance');
			r.add('Home Loan');
		}
		return r;
	}

	private static Set<String> getProfilesByReportType(Integer reportType) {
		Set<String> r = new Set<String>();
		if (INSURANCE_REPORT == reportType) {
			r.add('Insurance - Sales');
		} else if (HOME_REPORT == reportType) {
			r.add('Home Loan - Sales');
		} else if (SALES_REPORT == reportType) {
			r.add('Sales Consultant');
			r.add('Sales Consultant 2');
		} else if (SALES_3_REPORT == reportType || SALES_3_INS_REPORT == reportType) {
			r.add('Sales Consultant 3');
		} else if (BROKER_SALES_REPORT == reportType) {
			r.add('Broker Community User');
		}
		return r;
	}

	public static PerformanceReportResult build(Parameter param) {
		PerformanceReportResult res = new PerformanceReportResult();
		if (param == null) return res;
		res.displayInsurances = param.displayInsurances;
		res.reportType = param.reportType;
		List<Record> r = new List<Record>();
		List<Custom_Opportunity__c> opps = search(param);

		Id sysGenId = SOQLSingletonQueries.recs().sysGenUser.Id;
		if (opps != null)  {
			// Getting all owners
			Set<Id> allOwners = new Set<Id>();
			for (Custom_Opportunity__c o : opps) {
				if ('User'.equals(o.OwnerType__c)) {
					allOwners.add(o.OwnerId);
				}
			}
			// Defining valid owners
			Set<String> validProfiles = getProfilesByReportType(param.reportType);
      
      List<User> userList = null;
      if (SOQLSingletonQueries.recs().isBrokerPartnerUser) {
        Id accId = SOQLSingletonQueries.recs().myAccountId;
        userList = [
          SELECT Id, Name, State, Monthly_Commission_Target__c  
          FROM User 
          WHERE ContactId In (
            SELECT Id FROM Contact WHERE AccountId = :accId
          )
        ];
      } else {
        userList = [
          SELECT Id, Name, State, Monthly_Commission_Target__c 
          FROM User 
          WHERE (Id in :allOwners)
          AND IsActive = true 
          AND ProfileId IN (
            SELECT Id FROM Profile WHERE (Name IN :validProfiles)
          )
        ];

        if (param.showFranchisedUsers) {
          List<User> franchisedUsers = SOQLSingletonQueries.recs().franchisedCounsultantList;
          if (franchisedUsers != null && !franchisedUsers.isEmpty()) {
            System.debug('adding franchised users... ' + userList.size() + '|' + franchisedUsers.size());
            userList.addAll(franchisedUsers);
          }
        }
      }
      System.debug('total valid users: ' + userList.size());
			Map<Id, User> validUsersMap = new Map<Id, User>();
			for (User u : userList) {
				validUsersMap.put(u.Id, u);
			}
			Map<Id, Integer> vdProcesses = new Map<Id, Integer>();
			if (SALES_REPORT == param.reportType || SALES_3_REPORT == param.reportType) {
				vdProcesses = getVDProcesses(param);	
			}
      
			Map<Id, Record> resultMap = new Map<Id, Record>();
			for(Custom_Opportunity__c o : opps) {
        System.debug('Processing opp: ' + o.Name);
				if (('Queue'.equals(o.OwnerType__c) && validUsersMap.containsKey(o.CreatedByID)) || (validUsersMap.containsKey(o.OwnerId))) {
          System.debug('adding opp... ' + o.Name);
					Record a = null;
					if ('Closed Opportunity'.equals(o.Status__c) && 'Queue'.equals(o.OwnerType__c) && validUsersMap.containsKey(o.CreatedByID)) {
						a = resultMap.get(o.CreatedByID);
					} else {
						a = resultMap.get(o.OwnerId);
					}
					if (a == null) {
            System.debug('creating record... ' + o.Name + ' | ' + o.Owner_Name__c + ' | ' + o.OwnerType__c);
						a = new Record();
						a.ownerName = o.Owner_Name__c;
						if (
              'User'.equals(o.OwnerType__c) || 
              (
                'Closed Opportunity'.equals(o.Status__c) && 
                'Queue'.equals(o.OwnerType__c) && 
                validUsersMap.containsKey(o.CreatedByID)
              )
            ) {
              System.debug('filling data record... ' + o.Name);
							Id userId = o.OwnerId;
							if ('Closed Opportunity'.equals(o.Status__c) && 'Queue'.equals(o.OwnerType__c)) {
								userId = o.CreatedByID;
							}
							User u = validUsersMap.get(userId);
							a.ownerName = u.Name;
							a.state = u.State;
							a.budget = u.Monthly_Commission_Target__c;
							//Overall
							if (u.Monthly_Commission_Target__c != null){
								res.budget += u.Monthly_Commission_Target__c;
							}
							Integer vdp = vdProcesses.get(userId);
							if (vdp != null) {
								a.totalPreAppVd = vdp;
								res.totalPreAppVd += vdp;
							}
							resultMap.put(userId, a);	
						} else {
							a.ownerName += ' (Group)';
							resultMap.put(o.OwnerId, a);
						}
					}
					if (param.isDateInPeriod(o.CreatedDate)) {
						a.totalOpps += 1;
						// Overalls
						res.totalOpps += 1;
					}
					// Settled opps 
					if ('Settled'.equals(o.Status__c)) {
						if (param.isDateInPeriod(o.Date_Closed_or_Settled__c)) {
							if (SALES_3_INS_REPORT == param.reportType) {
								if (o.Total_Insurance_Commission__c > 0) {
									a.totalLoanSales += 1;
								}
							} else {
								a.totalLoanSales += 1;
							}
							// if (SALES_3_REPORT == param.reportType) {
							// 	a.commission += (o.Total_Commission__c - o.Total_Insurance_Commission__c);
							// } else 
							if (SALES_3_INS_REPORT == param.reportType) {
								a.commission += o.Total_Insurance_Commission__c;
							} else {
								a.commission += o.Total_Commission__c;
							}
							a.totalNAF += o.NAF_Net_Amount_Financed__c;
							Decimal brokeDof = 0.0;
							if (o.Total_Brokerage__c != null) {
								brokeDof += o.Total_Brokerage__c;
							}
							if (o.Total_DOF__c != null) {
								brokeDof += o.Total_DOF__c;
							}
							if (SALES_3_INS_REPORT == param.reportType) {
								a.totalBrokerageDOF = 0;
							} else {
								a.totalBrokerageDOF += brokeDof;
							}
							if (o.Number_FullComp_Ins_Sales__c != null) {
								a.totalComp += Integer.valueOf(o.Number_FullComp_Ins_Sales__c);
							}
							if (o.Number_Other_Ins_Sales__c != null) {
								a.totalInsurance += Integer.valueOf(o.Number_Other_Ins_Sales__c);
							}
							// Overalls
							if (SALES_3_INS_REPORT == param.reportType) {
								if (o.Total_Insurance_Commission__c > 0) {
									res.totalLoanSales += 1;
								}
							} else {
								res.totalLoanSales += 1;
							}
							//res.totalLoanSales += 1;
							// if (SALES_3_REPORT == param.reportType) {
							// 	res.commission += (o.Total_Commission__c - o.Total_Insurance_Commission__c);
							// } else 
							if (SALES_3_INS_REPORT == param.reportType) {
								res.commission += o.Total_Insurance_Commission__c;
							} else {
								res.commission += o.Total_Commission__c;
							}
							res.totalNAF += o.NAF_Net_Amount_Financed__c;
							if (SALES_3_INS_REPORT == param.reportType) {
								res.totalBrokerageDOF = 0;
							} else {
								res.totalBrokerageDOF += brokeDof;
							}
							if (o.Number_FullComp_Ins_Sales__c != null) {
								res.totalComp += Integer.valueOf(o.Number_FullComp_Ins_Sales__c);
							}
							if (o.Total_Insurance_Commission__c != null) {
								res.commissionInsurance += o.Total_Insurance_Commission__c;
							}
							if (o.Number_Other_Ins_Sales__c != null) {
								res.totalInsurance += Integer.valueOf(o.Number_Other_Ins_Sales__c);
							}
						}
					}
					if ('Pre-Approved'.equals(o.Status__c)) {
						a.currentPreApprals += 1;
	                    res.currentPreApprals += 1;
					}
					//System.debug('Opp Status: ' + o.Status__c + '|' + a.currentPreApprals);
					//Pre-Approvals
					if (param.isDateInPeriod(o.Date_Pre_Approved__c)) {
						a.totalPreApprals += 1;
						// Overalls
						res.totalPreApprals += 1;
					}
          //Yohan VillaLeal   07/08/2018  >>> Looking for if the opportunity's status exist in the list
          // Pipeline
          if(searchStatus(o.Status__c)){
            // if (SALES_3_REPORT == param.reportType) {
            // 	a.totalPipeline += (o.Total_Commission__c - o.Total_Insurance_Commission__c);
            // 	res.totalPipeline += (o.Total_Commission__c - o.Total_Insurance_Commission__c);
						// } else 
            if (SALES_3_INS_REPORT == param.reportType) {
              a.totalPipeline += o.Total_Insurance_Commission__c;
              res.totalPipeline += o.Total_Insurance_Commission__c;
            } else {
              a.totalPipeline += o.Total_Commission__c;
              res.totalPipeline += o.Total_Commission__c;
            }
            a.totalOppsPipeline ++;
            res.totalOppsPipeline ++;
	        }
	      }
			}
			//Get current users
			//Set<Id> userIds = resultMap.keySet();
			//List<User> userList = [SELECT Id, Name, State, Monthly_Commission_Target__c 
			//	            FROM User 
			//	            WHERE (Id in :userIds)
			//	           ];
			//Date currDate = Date.today();
			//for (User u : userList) {
			//	Record a = resultMap.get(u.Id);
			//	if (a != null) {
			//		a.ownerName = u.Name;
			//		a.state = u.State;
			//		a.budget = u.Monthly_Commission_Target__c;
			//		//Overall
			//		if (u.Monthly_Commission_Target__c != null){
			//			res.budget += u.Monthly_Commission_Target__c;
			//		}
			//	}
			//}
			// Check for current users
			Date currDate = Date.today();
			if (param.isDateInPeriod(currDate) || param.isDateInPeriod(currDate.addMonths(-1))) {
				loadGroupMembers(param);
				//Set<Id> groupMembers = getGroupMembers(param.groupName);
        if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {
          userList = [
            SELECT Id, Name, State, Monthly_Commission_Target__c
            FROM User 
            WHERE Id IN :param.groupMembers
            AND Id != :sysGenId
          ];
        }
			
				for (User u : userList) {
					Record a = resultMap.get(u.Id);
					if (a == null) {
						a = new Record();
						a.ownerName = u.Name;
						a.state = u.State;
						a.budget = u.Monthly_Commission_Target__c;
						//Overall
						if (u.Monthly_Commission_Target__c != null){
							res.budget += u.Monthly_Commission_Target__c;
						}
						resultMap.put(u.Id, a);
					}
				}
			}

      if (
        SOQLSingletonQueries.recs().isBrokerPartnerUser &&
        !SOQLSingletonQueries.recs().isFranchised
      ) {
        Map<Id, Integer> leads = getTotalLeads(param, validUsersMap.keySet());
        system.debug('@@leads: ' + JSON.serialize(leads));
        for (Id userId: leads.keySet()) {
          Record rcd = resultMap.get(userId);
          if (rcd != null) {
            rcd.totalLeads = leads.get(userId);
            res.totalLeads += rcd.totalLeads;
          }          
        }
      }
      System.debug('@@result: ' + JSON.serialize(resultMap));

			//Check for groups
			//List<Group> groupList = [SELECT Id, Name FROM Group WHERE (Id in :allOwners)];
			//for (Group g : groupList) {
			//	Record a = resultMap.get(g.Id);
			//	if (a != null) {
			//		a.ownerName = g.Name + ' (Group)';
			//	}
			//}
			if (!resultMap.isEmpty()) {
				r = resultMap.values();
			}
		}
		res.data = r;
		if (!res.data.isEmpty()) {
			res.data.sort();
		}
		//System.debug(res);
		return res;
	}

	public static String getReportName(Integer reportType) {
		String r = null;
		if (SALES_REPORT == reportType) {
			r = 'Sales';
		} else if (INSURANCE_REPORT == reportType) {
			r = 'Insurance';
		} else if (HOME_REPORT == reportType) {
			r = 'Home Sales';
		} else if (SALES_3_REPORT == reportType) {
			r = 'Sales (3)';
		} else if (SALES_3_INS_REPORT == reportType) {
			r = 'Insurance Sales (3)';
		} else if (BROKER_SALES_REPORT == reportType) {
			r = 'Broker - Sales ';
		}
    System.debug('reportType: ' + reportType + ' [' + r + ']');
		return r;
	}

	public static List<SelectOption> getYearOptions() {
		List<SelectOption> r = new List<SelectOption>();
        Integer y = 2013;
        while (y <= Date.today().year()){
            r.add(new SelectOption(String.valueOf(y), String.valueOf(y)));
            y++;
        }
        return r;
	}

	public static Integer getPollerTime(Parameter param) {
		Integer r = DEFAULT_POLLER_TIME;
		if (param != null) {
			String busParam = null;
			if (SALES_REPORT == param.reportType) {
				busParam = SALES_POLLER_TIME_PARAMETER;
			} else if (INSURANCE_REPORT == param.reportType) {
				busParam = INSURANCE_POLLER_TIME_PARAMETER;
			} else if (HOME_REPORT == param.reportType) {
				busParam = HOME_POLLER_TIME_PARAMETER;
			} else if (SALES_3_REPORT == param.reportType) {
				busParam = SALES_POLLER_TIME_PARAMETER;
			} else if (SALES_3_INS_REPORT == param.reportType) {
				busParam = SALES_POLLER_TIME_PARAMETER;
			}
			if (String.isNotBlank(busParam)) {
				Business_Parameters__c p = BusinessParamHelper.getParameterObj(busParam);
				if (p != null) {
					r = Integer.valueOf(p.Number_Value__c);
				}
			}
		}
		return r;
	}

	public static void loadGroupMembers(Parameter param) {
		if (param == null) return;
		if (param.groupMembers == null) {
			param.groupMembers = getGroupMembers(param);
		}
	}

  public static Set<Id> getGroupMembers(Parameter param) {
		Set<Id> r = new Set<Id>();
		if (param != null && String.isNotBlank(param.groupName)) {
			List<GroupMember> groupMembers = [
				SELECT Id, group.type, UserOrGroupId 
        FROM GroupMember 
        WHERE group.Name= :param.groupName 
        AND group.Type = 'Regular'
			];
			for(GroupMember gm : groupMembers){
				r.add(gm.UserOrGroupId);
			}
      if (param.showFranchisedUsers) {
        if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {
          List<User> x = SOQLSingletonQueries.recs().franchisedCounsultantList;
          if (x != null) {
            for(User u : x){
              r.add(u.Id);
            }
          }
        }
      }
		}
		return r;
	}

	public static void loadProfileMembers(Parameter param) {
		if (param == null || param.reportType == null) return;
		Set<String> profiles = getProfilesByReportType(param.reportType);
		if (profiles != null && !profiles.isEmpty()) {
			List<User> uLst = [
				SELECT Id, Name, State, Monthly_Commission_Target__c 
	            FROM User 
	            WHERE ProfileId IN (SELECT Id FROM Profile WHERE (Name IN :profiles))
                AND IsActive = true
	        ];
	        param.profileMembers = new Set<Id>();
	        for (User u: uLst) {
	        	param.profileMembers.add(u.Id);
	        }
		}
	}

    public static List<SelectOption> getCustomRangeOptions() {
		List<SelectOption> r = new List<SelectOption>();
        r.add(new SelectOption ('None', 'By Month'));
        for (String value : customsRanges) {
            r.add(new SelectOption (value, value));
        }
        return r;
	}
    
    //Yohan VillaLeal   07/08/2018  >>> To search if the Opportunity's status exist in the List.
    public static boolean searchStatus(String statusOpp){
        for (String value : status) {
            if(value.equals(statusOpp)){
                return true;
            }
        }
        return false;
    }

    public static Map<Id, Integer> getVDProcesses(Parameter param) {
    	Map<Id, Integer> r = new Map<Id, Integer>();
    	if (param == null || param.startDate == null) return r;
      // System.debug(
      //   'Date range B2: ' + 
      //   DateUtils.convertToString(startDate.dateGmt(), DateUtils.FORMAT_QUERY2) + ' - ' + 
      //   DateUtils.convertToString(endDate.dateGmt(), DateUtils.FORMAT_QUERY2)
      // );

    	// Datetime startDate = param.startDate.dateGmt();
		  // Datetime endDate = param.endDate.dateGmt();

      String d1 = DateUtils.convertToString(param.startDate.dateGmt(), DateUtils.FORMAT_QUERY2);
      String d2 = DateUtils.convertToString(param.endDate.dateGmt(), DateUtils.FORMAT_QUERY2);

      String sql = 'SELECT OwnerId, count(Id) TOTAL FROM VD_Worksheet__c';
      sql += ' WHERE CreatedDate >= ' + d1 + ' AND CreatedDate < ' + d2;
      sql += ' GROUP BY OwnerId ORDER BY count(Id) DESC';
      System.debug('sql => ' + sql);
      List<AggregateResult> result  = Database.query(sql);
    	// List<AggregateResult> result  = [
      //       SELECT OwnerId, count(Id) TOTAL 
      //       FROM VD_Worksheet__c 
      //       WHERE CreatedDate >= :d1 AND CreatedDate < :d2
			// GROUP BY OwnerId
			// ORDER BY count(Id) DESC
      //   ];
        for (AggregateResult a: result) {
        	r.put((Id)a.get('OwnerId'), (Integer)a.get('TOTAL'));
        }
        return r;
    }

    public static Map<Id, Integer> getTotalLeads(Parameter param, Set<Id> userIds) {
    	Map<Id, Integer> r = new Map<Id, Integer>();
    	if (userIds == null || userIds.isEmpty()) return r;
      
      String d1 = DateUtils.convertToString(param.startDate.dateGmt(), DateUtils.FORMAT_QUERY2);
      String d2 = DateUtils.convertToString(param.endDate.dateGmt(), DateUtils.FORMAT_QUERY2);
      
      String sql = 'SELECT OwnerId, count(Id) TOTAL FROM Lead__c';
      sql += ' WHERE CreatedDate >= ' + d1 + ' AND CreatedDate < ' + d2;
      sql += ' AND OwnerType__c = \'User\'';
      sql += ' AND Reason_for_closure__c != \'Duplicate Lead\'';
      sql += ' AND OwnerId IN :userIds';
      sql += ' GROUP BY OwnerId ORDER BY count(Id) DESC';
      System.debug('sql => ' + sql);
      List<AggregateResult> result  = Database.query(sql);
      for (AggregateResult a: result) {
        r.put((Id)a.get('OwnerId'), (Integer)a.get('TOTAL'));
      }
      return r;
    }
}