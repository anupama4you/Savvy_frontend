public with sharing class OppApprovalLenderLoginsExtension {

	private Map<Id, LoginConsultant> data = null;

	public OppApprovalLenderLoginsExtension() {
		loadData();
	}

	private void loadData() {
		data = new Map<Id, LoginConsultant>();
		
		// Lelo 			2018-08-28
		Set<Id> activeUserIds = SOQLSingletonQueries.recs().lenderLoginConsultans;
		// -

		List<Lender_Login__c> tmpList = [
			SELECT Id, Lender__c, Password__c, Password_Two__c, State__c, User_Linked__c, User_Name__c, Owner.Id, Owner.Name, User_Linked__r.Name 
			FROM Lender_Login__c 
			WHERE Owner.Id IN :activeUserIds
			ORDER BY Owner.Name];

		//Check share
		for (Lender_Login__c c : tmpList) {
			LoginConsultant d = data.get(c.Owner.Id);
			if (d == null) {
				d = new LoginConsultant();
				d.name = c.Owner.Name;
				data.put(c.Owner.Id, d);
			}

			RowDTO r = new RowDTO(c);
			if (c.User_Linked__c != null) {
				r.shareData = getSharedLenderLogin(c);
			}
			d.rows.add(r);
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

	public List<LoginConsultant> getDataList() {
		return data.values();
	}

	public class LoginConsultant {
		public String name {set;get;}
		public List<RowDTO> rows {set;get;}
		public LoginConsultant() {
			rows = new List<RowDTO>();
		}
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

		public String getSahedUserName() {
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

}