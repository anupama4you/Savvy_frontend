public class PerformanceReportResult {
	public Integer reportType {set;get;}
  public Integer totalLeads {set;get;}
	public Integer totalOpps {set;get;}
	public Integer totalPreApprals {set;get;}
	public Integer totalLoanSales {set;get;}
	public Decimal commission {set;get;}
	public Decimal totalNAF {set;get;}
	public Decimal budget {set;get;}
	public Decimal totalBrokerageDOF {set;get;}
	public List<PerformanceReportHelper.Record> data {set;get;}
	public Boolean displayInsurances {set;get;}
	public Integer totalComp {set;get;}
	public Integer totalInsurance {set;get;}
	public Decimal commissionInsurance {set;get;}
	public Integer currentPreApprals {set;get;}
  public Decimal totalPipeline {set;get;}
  public Integer totalPreAppVd {set;get;}
  public Integer totalOppsPipeline {set;get;}
  public Boolean isLeadCount {
      get {
        return (
          SOQLSingletonQueries.recs().isBrokerPartnerUser &&
          !SOQLSingletonQueries.recs().isFranchised
        );
      }
    }
    
	public PerformanceReportResult () {
    this.totalLeads = 0;
		this.totalOpps = 0;
		this.totalPreApprals = 0;
		this.budget = 0.0;
		this.totalLoanSales = 0;
		this.commission = 0.0;
		this.totalNAF = 0.0;
		this.totalBrokerageDOF = 0.0;
		this.totalComp = 0;
		this.totalInsurance = 0;
		this.commissionInsurance = 0.0;
    this.currentPreApprals = 0;
    this.totalPipeline = 0.0;
    this.totalPreAppVd = 0;
    this.totalOppsPipeline = 0;
	}

	public Decimal getOppConvertion() {
		Decimal r = 0.0;
		if (this.totalOpps != null && this.totalOpps > 0 && this.totalLoanSales != null) {
			r = (this.totalLoanSales / Decimal.valueOf(this.totalOpps)) * 100.0;
			r = r.setScale(2);
		}
		return r;
	}

	public Decimal getBudgetConvertion() {
		Decimal r = 0.0;
		if (this.budget != null && this.budget > 0 && this.commission != null) {
			r = (this.commission / this.budget) * 100.0;
			r = r.setScale(2);
		}
		return r;
	}

	public Decimal getCompConvertion() {
		Decimal r = 0.0;
		if (this.totalLoanSales != null && this.totalLoanSales > 0 && this.totalComp != null) {
			r = (this.totalComp / Decimal.valueOf(this.totalLoanSales)) * 100.0;
			r = r.setScale(2);
		}
		return r;
	}

	public Decimal getInsuranceConvertion() {
		Decimal r = 0.0;
		if (this.totalLoanSales != null && this.totalLoanSales > 0 && this.totalInsurance != null) {
			r = (this.totalInsurance / Decimal.valueOf(this.totalLoanSales)) * 100.0;
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

  public Decimal getCalcProjection(){
    return this.commission + this.totalPipeline;
  }

  public Boolean getIsSalesReport() {
    return (
      PerformanceReportHelper.SALES_REPORT == this.reportType ||
      PerformanceReportHelper.SALES_3_REPORT == this.reportType ||
      PerformanceReportHelper.BROKER_SALES_REPORT == this.reportType
    );
  }

  public Boolean getIsInsSalesReport() {
    return (PerformanceReportHelper.SALES_3_INS_REPORT == this.reportType);
  }

}