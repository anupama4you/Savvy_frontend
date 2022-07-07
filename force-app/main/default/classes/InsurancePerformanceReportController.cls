public class InsurancePerformanceReportController extends PerformanceReportController {

	public InsurancePerformanceReportController() {
		super(PerformanceReportHelper.INSURANCE_REPORT);
		/*String wepParam = System.currentPageReference().getParameters().get('RPT');
		param = new PerformanceReportHelper.Parameter();
		param.reportType = PerformanceReportHelper.INSURANCE_REPORT;
		if (String.isNotBlank(wepParam) && wepParam.isNumeric()) {
			param.reportType = Integer.valueOf(wepParam);
		}
		param.month = Date.today().month();
		param.year = Date.today().year();
		System.debug(param);
		this.executeReport();*/
	}

}