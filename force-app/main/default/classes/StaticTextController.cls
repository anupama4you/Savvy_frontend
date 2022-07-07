public with sharing class StaticTextController {

	private String codeParam;
	public Static_Content__c contentObj {set;get;}
	private Map<String, String> attrMap;

	public StaticTextController() {
		attrMap = new Map<String, String>();
		contentObj = null;
	}

	private void init() {
		if (contentObj == null)	 {
			if (String.isNotBlank(codeParam)) {
				List<Static_Content__c> d = [SELECT Name, Category__c, Code__c, Content__c, Order__c 
				                             FROM Static_Content__c 
				                             WHERE Code__c = :codeParam
				                             AND Status__c = 'A'];
				if (!d.isEmpty()) {
					contentObj = d.get(0);
				}
			}
			System.debug('code >> ' + codeParam);
		} 
		
		if (contentObj != null)	 {
			for (String k : attrMap.keySet()) {
				if (String.isNotBlank(attrMap.get(k))) {
					contentObj.Content__c = contentObj.Content__c.replace(k, attrMap.get(k));
				}
			}
		}
		
	}

	public void setCodeParam(String s) {
		codeParam = s;
		init();
	}

	public String getCodeParam() {
		return codeParam;
	}

	private void addAttribute(Integer attr, String v) {
		attrMap.put('[ATTRIBUTE' + attr + ']', v);
	}

	public void setAttr1(String a) {
		addAttribute(1, a);
		init();
	}

	public String getAttr1() {
		return attrMap.get('[ATTRIBUTE' + 1 + ']');
	}

	public void setAttr2(String a) {
		addAttribute(2, a);
		init();
	}

	public String getAttr2() {
		return attrMap.get('[ATTRIBUTE' + 2 + ']');
	}

}