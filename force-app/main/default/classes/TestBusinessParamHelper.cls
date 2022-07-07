@isTest(SeeAllData=true)
private class TestBusinessParamHelper {
	
	@isTest static void testOptions() {
		BusinessParamHelper.getParameterOptions(BusinessParamHelper.PARAM_LEAD_REDIRECT_ACTIVE);
		BusinessParamHelper.getParameterOptions(BusinessParamHelper.PARAM_LEAD_REDIRECT_ACTIVE, true);
		BusinessParamHelper.getParameter(BusinessParamHelper.PARAM_LEAD_REDIRECT_PROFILES);

		BusinessParamHelper.getParameterObj(BusinessParamHelper.PARAM_LEAD_REDIRECT_ACTIVE);
		BusinessParamHelper.getParameterObj('SOMETHINGELSE');

	}
	
	
}