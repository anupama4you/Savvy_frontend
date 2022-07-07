public with sharing class LenderQuotingWrapperDTO implements Comparable {

    public static final String ORD_BASE_RATE = 'BA';
    public static final String ORD_CLIENT_RATE = 'CL';
    public static final String ORD_COMMISSION = 'CO';
    public static final String ORD_REPAYMENT = 'RE';
    public static final String ORD_TOTALCOMM = 'TC';

	public Lenders__c info {set;get;}
    public Decimal baseRate {set;get;}
    
    //Get Capital
    public String assetType {get;set;}
    public Decimal equifaxScore {get;set;}
    public String abnLength {get;set;}
    public String gstLength {get;set;}
    public String assetAge {get;set;}    

    //Gereic
    public Decimal carPrice {set;get;}
    public Decimal deposit {set;get;}
    public Decimal residual {set;get;}

    //Lender calculator fields
    public String productLoanType {get;set;}		//ANZ Consumer, ANZ Commercial, ANZ Others, Macquarie Consumer, Macquarie Commercial, Pepper MV
    public String productGoodsType {get;set;}		//ANZ Consumer, ANZ Commercial, ANZ Others, Macquarie Consumer, Macquarie Commercial, Pepper MV
    public String productGoodsSubType {get;set;}	//Macquarie Consumer (MacLEase Partner)
    public String loanFrequency {get;set;}	        //Macquarie Consumer (MacLEase Partner)
    public Integer term {set;get;}					//ANZ Consumer, ANZ Commercial, ANZ Others, Macquarie Consumer, Macquarie Commercial, Pepper MV
    
    public String customerProfile {set;get;}		//ANZ Consumer, ANZ Commercial, Yamaha Marine
    public String adverseCredit {set;get;}			//ANZ Consumer, ANZ Commercial
    public String ltv {set;get;}					//ANZ Consumer, ANZ Commercial

    public String goodsType {set;get;}				//ANZ Others
    public String vehiclesProfile {set;get;}		//ANZ Others

    public Integer carAge {set;get;}				//Macquarie Consumer, Macquarie Commercial
    public String privateSales {set;get;}			//Macquarie Consumer, Macquarie Commercial
    public String motorCycles {set;get;}			//Macquarie Consumer
    public String caravanCampervans {set;get;}		//Macquarie Consumer
    
    public String loanType {set;get;}               //St George MV, Liberty Drive, Liberty Options
    public String carType {set;get;}                //St George MV

    public String rateOption {set;get;}             //Liberty Options

    public String clientTier {set;get;}             //Pepper MV, Pepper Leisure, Pepper Seasonal

    public String additionalInfo {set;get;}         //Latitude

    //Lelo                  2017-08-21
    public QuotingCalculation.CalcParam param {set;get;}                  //
    public Application_Quoting_Result__c quotingResult {set;get;}         //    
    //Lelo                      2017-09-21
    public Decimal clientRate {set;get;}
    public Decimal clientRateFactor {set;get;}
    public Decimal brokerageBase {set;get;}    

    public Boolean hasClientRate {set;get;}
    public Boolean hasBrokerage {set;get;}

    public Decimal dofBase {set;get;}    

    public String sortBy {set;get;}
    //Lelo                  2017-12-12
    public String condition {set;get;}        //Anz Consumer: New/Demo or Used
    //Lelo                  2018-01-04
    public String vehicleYear {set;get;}
    //Lelo                  2018-05-24
    public Decimal maxClientRate {set;get;}
    // Yohan Villamizar     2019-07-09
    public String loanTypeDetail {set;get;}
    public String purchaseType {set; get;}   // Dealer, Private, Refinance
    public String residentialStatus {set; get;}
    public String riskGrade {set; get;}
    public String bankrupt {set; get;}
    public String hasDefault {set; get;}
    //Lelo                  2018-05-24
    public ServicingCalcHelper.Result servicing {set;get;}
    //Yohan Villamizar      2019-07-17
    public Decimal appFeeVal {set; get;}
    public Decimal riskFeeBase {set; get;}
    
	public LenderQuotingWrapperDTO() {
		this.sortBy = ORD_BASE_RATE;
	}

	public LenderQuotingWrapperDTO(Lenders__c lenderParam) {
        info = lenderParam;
		
        //Lelo                                2017-09-21
        //Preset figures
        this.clientRateFactor = 0.0;
        this.brokerageBase = 0.0;
        this.hasClientRate = false;
        this.hasBrokerage = false;
        if (info != null) {
            this.clientRateFactor = info.Client_Rate_Factor__c;
            this.brokerageBase = info.Brokerage_Base__c;
            if ('B'.equals(info.Client_Rate_Type__c)) {
                this.hasBrokerage = true;
            } else {
                this.hasClientRate = true;
            }
        }
    }

    public List<String> getCreditGuidelineList() {
        List<String> r = new List<String>();

        if (!String.isBlank(info.Credit_Guidelines_1__c)) {
            r.addAll(info.Credit_Guidelines_1__c.split('\n'));
        }
        if (!String.isBlank(info.Credit_Guidelines_2__c)) {
            r.addAll(info.Credit_Guidelines_2__c.split('\n'));
        }
        if (!String.isBlank(info.Credit_Guidelines_3__c)) {
            r.addAll(info.Credit_Guidelines_3__c.split('\n'));
        }
        return r;
    }

    public String getExtraInfo() {
        String r = null;
        if (info != null) {
            if ('PEMV'.equals(info.Code__c) || 'PELE'.equals(info.Code__c) || 'PESE'.equals(info.Code__c) || 'PESU'.equals(info.Code__c)) {
                if (clientTier != null) {
                    r = 'Tier ' + clientTier;
                }
            } else if (!String.isBlank(additionalInfo)) {
                r = additionalInfo;
            }
        }
        if(r==null){
            r='None';
        }
        return r;
    }

    public Integer compareTo(Object compareTo) {
        LenderQuotingWrapperDTO o = (LenderQuotingWrapperDTO)compareTo;

        Integer r = 0;
        Decimal valA = null;
        Decimal valB = null;

        if (o == null) {
        	r = -1;
        } else {
            if (String.isBlank(this.sortBy) || ORD_BASE_RATE.equals(this.sortBy)) {
                valA = this.baseRate;
                valB = o.baseRate;
            } else if (ORD_CLIENT_RATE.equals(this.sortBy)) {
                valA = this.clientRate;
                valB = o.clientRate;
            } else if (ORD_COMMISSION.equals(this.sortBy)) {
                if (this.quotingResult != null) {
                    valB = this.quotingResult.Estimated_Commission__c;
                }
                if (o.quotingResult != null) {
                    valA = o.quotingResult.Estimated_Commission__c;
                }
            } else if (ORD_TOTALCOMM.equals(this.sortBy)) {
                if (this.quotingResult != null) {
                    valB = this.quotingResult.Total_Commission__c;
                }
                if (o.quotingResult != null) {
                    valA = o.quotingResult.Total_Commission__c;
                }
            } else if (ORD_REPAYMENT.equals(this.sortBy)) {
                if (this.quotingResult != null) {
                    valA = this.quotingResult.Weekly_Payment__c;
                }
                if (o.quotingResult != null) {
                    valB = o.quotingResult.Weekly_Payment__c;
                }
            }
            if (valA == null) {
                if (valB != null) {
                    r = 1;
                }
            } else if (valB == null) {
                r = -1;
            } else if (valA < valB) {
                r = -1;
            } else if (valA > valB) {
                r = 1;
            }
        }
        return r;
    }
}