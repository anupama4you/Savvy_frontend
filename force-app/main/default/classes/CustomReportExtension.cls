public with sharing class CustomReportExtension {
	public CustomReportExtension() {
		
	}

	public Integer getTotalUnassignedLeads() {
		if (SOQLSingletonQueries.isHomeLoanUser()) {
			return this.getTotalHomeUnassignedLeads();
		}
		return getTotalSalesUnassignedLeads();
	}

	public Integer getTotalSalesUnassignedLeads() {
		Integer r = 0;
		List<AggregateResult> d = [SELECT COUNT(Id) TOTAL
					FROM Lead__c
					WHERE CreatedDate=LAST_N_DAYS:10
					AND Owner.Name = 'System Generated'
					AND Employment_Status__c != 'Unemployed'
					AND Status__c = 'New Lead'
					AND Is_Call_Center__c = false
					AND Loan_Type__c != 'Bad Credit Car Loan'
					AND (NOT(
						(Loan_Type__c like 'Personal%' OR Loan_Type__c like '%Car%') AND 
						Finance_Amount__c <= 5000 AND 
						(Credit_History__c = 'Bad' OR Credit_History__c = 'Not Sure' OR Credit_History__c = 'Poor')
						))
					AND (Bucket_Type__c = null OR Bucket_Type__c = 'Sales' OR Bucket_Type__c = '8k PL')
                ];
		if (!d.isEmpty()) {
			r = (Integer)d.get(0).get('TOTAL');
		}
		return r;
	}

	public Integer getTotalHomeUnassignedLeads() {
		Integer r = 0;
		List<AggregateResult> d = [
			SELECT COUNT(Id) TOTAL
			FROM Lead__c
			WHERE Owner.Name = 'System Generated'
			AND Status__c = 'New Lead'
			AND (Bucket_Type__c = 'Home Loan')
        ];
		if (!d.isEmpty()) {
			r = (Integer)d.get(0).get('TOTAL');
		}
		return r;
	}

	public Integer getTotalUnassignedBCCLLeads() {
		Integer r = 0;
		List<AggregateResult> d = [
			SELECT COUNT(Id) TOTAL
			FROM Lead__c
			WHERE CreatedDate=LAST_N_DAYS:10
			AND Owner.Name = 'System Generated'
			AND Employment_Status__c != 'Unemployed'
			AND Status__c = 'New Lead'
			AND Loan_Type__c = 'Bad Credit Car Loan'
			AND Is_Call_Center__c = false
			AND (NOT(
					(Loan_Type__c like 'Personal%' OR Loan_Type__c like '%Car%') AND 
					Finance_Amount__c <= 5000 AND 
					(Credit_History__c = 'Bad' OR Credit_History__c = 'Not Sure' OR Credit_History__c = 'Poor')
				))
			AND (Bucket_Type__c = null OR Bucket_Type__c = 'Sales' OR Bucket_Type__c = '8k PL')
        ];
		if (!d.isEmpty()) {
			r = (Integer)d.get(0).get('TOTAL');
		}
		return r;
	}

	public Integer getTotalUnassignedMoney3Leads() {
		Integer r = 0;
		List<AggregateResult> d = [
			SELECT COUNT(Id) TOTAL
			FROM Lead__c
			WHERE CreatedDate=LAST_N_DAYS:10
			AND Owner.Name = 'System Generated'
			AND Employment_Status__c != 'Unemployed'
			AND Status__c = 'New Lead'
			AND Is_Call_Center__c = false
			AND Bucket_Type__c = 'Money3'
        ];
		if (!d.isEmpty()) {
			r = (Integer)d.get(0).get('TOTAL');
		}
		return r;
	}



	public List<Custom_Opportunity__c> getMachineLearningItems() {
		Date startDate = Date.newInstance(2017, 1, 1);
		List<Custom_Opportunity__c> r = [
					select Application__r.Mode_of_Employment_1__c, Application__r.Net_Income_1__c, Application_AssetDetail__r.Type__c, 
						   Opp_Loan_Term__c, Application__r.Application_Type__c, Loan_Product__r.Quoting_Source__c, 
						   Loan_Product__r.Cost_of_Goods__c
                    from custom_opportunity__c 
                    WHERE Date_Settled__c >= :startDate
                    AND Status__c = 'Settled'
                    AND Loan_Product__r.Quoting_Source__c != null
                    AND Application_AssetDetail__r.Type__c != null
		];
		return r;
	}

}