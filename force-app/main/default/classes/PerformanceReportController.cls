public virtual class PerformanceReportController {
	
	public PerformanceReportHelper.Parameter param {set;get;}
	public PerformanceReportResult report {set;get;}
	
	public PerformanceReportController() {
		init(null);
	}

	public PerformanceReportController(Integer reportType) {
		init(reportType);
	}

	public void init(Integer reportType) {
		param = new PerformanceReportHelper.Parameter();
		param.reportType = reportType;
		param.month = Date.today().month();
		param.year = Date.today().year();
		if (reportType == null) {
			String wepParam = System.currentPageReference().getParameters().get('RPT');
			param.reportType = PerformanceReportHelper.SALES_REPORT;
			if (String.isNotBlank(wepParam) && wepParam.isNumeric()) {
				param.reportType = Integer.valueOf(wepParam);
			}
		} else {
			param.reportType = reportType;
		}
		if (PerformanceReportHelper.SALES_REPORT == reportType) {
			param.groupName = 'Sales Consultants';
			param.displayInsurances = true;
		} else if (PerformanceReportHelper.SALES_3_REPORT == reportType) {
			param.groupName = 'Sales Consultants 3';
			param.displayInsurances = true;
		} else if (PerformanceReportHelper.SALES_3_INS_REPORT == reportType) {
			param.groupName = 'Sales Consultants 3';
			param.displayInsurances = true;
		} else if (PerformanceReportHelper.BROKER_SALES_REPORT == reportType) {
			param.displayInsurances = true;
		}
    String franchiseParam = System.currentPageReference().getParameters().get('FRANCHISE');
    param.showFranchisedUsers = 'ON'.equalsIgnoreCase(franchiseParam);
		// param.month = Date.today().month();
		// param.year = Date.today().year();
		this.executeReport();
	}

	public void executeReport() {
		this.report = PerformanceReportHelper.build(param);
	}

	public String getReportName() {
		return PerformanceReportHelper.getReportName(param.reportType);
	}

	public List<SelectOption> getYearOptions() {
		return PerformanceReportHelper.getYearOptions();
	}

	public void pollReport() {
		if (this.getIsCurrentPeriod()) {
			this.executeReport();
		}
	}

	public Integer getPollerTime() {
		return PerformanceReportHelper.getPollerTime(this.param);
	}

	public Boolean getIsCurrentPeriod() {
		if (this.param != null && this.param.isDateInPeriod(Date.today())) {
			return true;
		}
		return false;
	}
    
    public List<SelectOption> getCustomRangeOptions() {
		return PerformanceReportHelper.getCustomRangeOptions();
	}
}