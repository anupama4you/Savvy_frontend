public with sharing class BusinessParamHelper {

	public static final String PARAM_LEAD_REDIRECT_ACTIVE = 'LEAD_REDIRECT_ACTIVE';
	public static final String PARAM_LEAD_REDIRECT_PROFILES = 'LEADREDIRECTPROFILES';
	public static final String PARAM_ACTIVATE_PREAUTHORISATION = 'ACTIVE_PREAPP_AUTHPR';
	private static Map<String, List<Business_Parameters__c>> params;

	private static void init() {
		if (params == null) {
			params = new Map<String, List<Business_Parameters__c>>();
			List<Business_Parameters__c> d = [SELECT Parameter__c, Name, Label__c, Text_Value__c, Number_Value__c 
			                                  FROM Business_Parameters__c ORDER BY Parameter__c, Name];
			for (Business_Parameters__c p : d) {
				List<Business_Parameters__c> a = params.get(p.Parameter__c);
				if (a == null) {
					a = new List<Business_Parameters__c>();
					params.put(p.Parameter__c, a);
				}
				a.add(p);
			}
		}
	}

	public static List<SelectOption> getParameterOptions(String param) {
		return getParameterOptions(param, false);
	}

	public static List<SelectOption> getParameterOptions(String param, Boolean isNullable) {
		List<SelectOption> r = new List<SelectOption>();
		if (isNullable) {
			r.add(new SelectOption('','-- None --'));
		}
		init();
		List<Business_Parameters__c> d = params.get(param);
		if (d != null) {
			for (Business_Parameters__c a : d) {
				r.add(new SelectOption(a.Text_Value__c, a.Label__c));
			}
		}
		return r;
	}

	public static String getParameter(String param) {
		init();
		List<Business_Parameters__c> bp = params.get(param);
		String r = null;
		if (bp != null && !bp.isEmpty()) {
			r = bp.get(0).Text_Value__c;
		}
		return r;
	}

	public static Business_Parameters__c getParameterObj(String param) {
		init();
		List<Business_Parameters__c> bp = params.get(param);
		if (bp != null && !bp.isEmpty()) {
			return bp.get(0);
		}
		return null;	
	}

}