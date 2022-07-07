public with sharing class LenderLoginsExtension {

	public List<RowDTO> data {set;get;}
	public Lender_Login__c objLogin {set;get;}
	public Boolean isShowForm {set;get;}
	public Boolean isShareCredentials {set;get;}

	public LenderLoginsExtension() {
		loadForm();
		loadData();
	}

	private void loadData() {

		data = new List<RowDTO>();
		
		List<Lender_Login__c> tmpList = [
			SELECT 
        Id, Lender__c, Password__c, Password_Two__c, State__c, 
        User_Linked__c, User_Name__c, Owner.Id, Owner.Name, 
        User_Linked__r.Name 
			FROM Lender_Login__c 
      WHERE Owner.Id = :UserInfo.getUserId()
      ORDER BY Lender__c, User_Name__c
    ];

		//Check share
		for (Lender_Login__c c : tmpList) {
			RowDTO r = new RowDTO(c);
			if (c.User_Linked__c != null) {
				r.shareData = getSharedLenderLogin(c);
			}
			data.add(r);
		}

	}

	private void loadForm() {
		isShowForm = false;
		String loginId = System.currentPageReference().getParameters().get('ID');
		if (!String.isBlank(loginId)) {
			objLogin = [SELECT Id, Lender__c, Password__c, Password_Two__c, State__c, 
			                   User_Linked__c, User_Name__c, Owner.Id, Owner.Name 
						FROM Lender_Login__c WHERE Id = :loginId];
			//Load for updating
			isShowForm = true;
			if (objLogin.User_linked__c != null) {
				isShareCredentials = true;
			}
		}
	}

	private Lender_Login__c getSharedLenderLogin(Lender_Login__c c) {
		Lender_Login__c r = null;
		if (c != null) {
			List<Lender_Login__c> tmp = null;
			if ('ANZ'.equals(c.Lender__c)) {
				tmp = [SELECT Id, Lender__c, Password__c, Password_Two__c, State__c, 
				              User_Linked__c, User_Name__c, Owner.Id, Owner.Name 
				       FROM Lender_Login__c WHERE Owner.Id = :c.User_Linked__c 
					   AND Lender__c = :c.Lender__c AND State__c = :C.State__c];
			} else {
				tmp = [SELECT Id, Lender__c, Password__c, Password_Two__c, State__c, 
				              User_Linked__c, User_Name__c, Owner.Id, Owner.Name 
				       FROM Lender_Login__c WHERE Owner.Id = :c.User_Linked__c 
					   AND Lender__c = :c.Lender__c];
			}
			if (!tmp.isEmpty()) {
				r = tmp.get(0);
			}
		}
		return r;
	}

	public PageReference newLogin () {
		isShowForm = true;
		isShareCredentials = false;
		objLogin = new Lender_Login__c();
		return null;
	}

	public PageReference cancel () {
		isShowForm = false;
		objLogin = null;
		return null;
	}

	public PageReference save () {
		if (isFormValid()) {
			if (!isShareCredentials) {
				objLogin.User_Linked__c = null;	
			}
			upsert objLogin;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'The record has been saved.'));
			loadData();
			isShowForm = false;
			objLogin = null;
			isShareCredentials = false;
		}
		return null;
	}	

	public PageReference deleteRecord() {
		if (objLogin != null && objLogin.Id != null) {
			delete objLogin;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'The record has been deleted.'));
			loadData();
		}
		return cancel();
	}

	private Boolean isFormValid() {
		Boolean r = true;
		if (isShareCredentials) {
			if (objLogin.User_Linked__c == null) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a Consultant.'));
				r = false;
			} else {
				//Only Sale Consultants
				//if (objLogin.User_Linked__r.)
			}
		} else {
			if (String.isBlank(objLogin.User_Name__c)) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill the Username field.'));
				r = false;	
			}
			if (String.isBlank(objLogin.Password__c)) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill the Password field.'));
				r = false;	
			}
			if ('ANZ'.equals(objLogin.Lender__c)) {
				if (String.isBlank(objLogin.State__c)) {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a State.'));
					r = false;	
				}
				if (String.isBlank(objLogin.Password_Two__c)) {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill the Password Two field. (ANZ, Abacus / AFS)'));
					r = false;	
				}
			}
		}
		return r;
	}

	public class RowDTO {

		public Lender_Login__c data {set;get;}
		public Lender_Login__c shareData {set;get;}

		public RowDTO (Lender_Login__c data) {
			this.data = data;
		}

		public Lender_Login__c getDto() {
			if (shareData != null) {
				return shareData;
			}
			return data;
		}

		public String getSharedUserName() {
			String r = 'N/A';
			if (data.User_Linked__c != null) {
				r = data.User_Linked__r.Name;
			}
			return r;
		}

		public Id getId() {
			if (data != null) return data.Id;
			return null;
		}

	}

  public Boolean getIsBrokerPartnerUser() {
    return SOQLSingletonQueries.recs().isBrokerPartnerUser;
  }

}