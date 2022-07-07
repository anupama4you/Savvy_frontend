public with sharing class OptionsLinksFooterController {
	
	public Boolean isReportManager {set;get;}

	public OptionsLinksFooterController() {
		this.isReportManager = SOQLSingletonQueries.isReportManager(UserInfo.getUserId());
	}

}