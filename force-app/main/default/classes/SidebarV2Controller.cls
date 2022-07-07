public with sharing class SidebarV2Controller {

	private static final String ICO_PREAPPROVAL = 'PreapprovalStatus';
	private static final String ICO_AMENDMENT = 'AmendmentStatus';
	private static final String ICO_FORMALAPPROVAL = 'FormalApprovalStatus';

	public Id opportunityId {set;get;}
	public Id applicationId {set;get;}
	private Set<String> dataTypes = null;

  private Custom_Opportunity__c opp;

  public Boolean isPartnerExternal {
    get {
      this.loadData();
      return this.opp != null && this.opp.Partner_Is_External__c;
    }
  }

  public String oppName {
    get {
      this.loadData();
      return this.opp != null? this.opp.Name : null;
    }
  }

  public String oppStatus {
    get {
      this.loadData();
      return this.opp != null? this.opp.Status__c : null;
    }
  }

	public SidebarV2Controller() {}

	public String getLenderQuoting() {
		System.debug('dataTypes 2 >> ' + applicationId + '|' + dataTypes);
		Application_Quoting__c q = QuotingToolHelper.getApplicationQuoting(opportunityId, null);
		if (q != null) {
			return q.Name;
		}
		return 'NOQUOTING';
	}

	private void loadExtraDataTypesSaved() {
		dataTypes = ApplicationExtraDataHelper.getAllExtraDataTypesSaved(applicationId);
		System.debug('dataTypes >> ' + applicationId + '|' + dataTypes);
	}

	private String getStatusDataType(String docType) {
		String r = '0';
		//if (dataTypes == null) {
			loadExtraDataTypesSaved();
		//}
		if (dataTypes.contains(docType)) {
			r = '1';
		}
		System.debug('docType >> ' + docType + ' >> ' + r);
		return r;
	}

	/* Pre Approval */
	public String getAppFormPreaprovalStatus() {
		return ICO_PREAPPROVAL + getStatusDataType('Application Form (Pre-approval)');
	}

	public String getYtdPreaprovalStatus() {
		return ICO_PREAPPROVAL + getStatusDataType('YTD Calculation');
	}

	public String getServPreaprovalStatus() {
		return ICO_PREAPPROVAL + getStatusDataType('Servicing Calculation');
	}

	public String getQuotingPreaprovalStatus() {
		return ICO_PREAPPROVAL + getStatusDataType('Quoting Calculation');
	}

	public String getAssetLTVPreaprovalStatus() {
		return ICO_PREAPPROVAL + getStatusDataType('Asset Detail - LTV (Pre-approval)');
	}

	/* Amendment */

	public String getQuotingAmendmentStatus() {
		return ICO_AMENDMENT + getStatusDataType('Quoting Calculation (Amendment)');
	}

	public String getAssetLTVAmendmentStatus() {
		return ICO_AMENDMENT + getStatusDataType('Asset Detail - LTV (Amendment)');
	}

	/* Formal Approval */

	public String getQuotingFormalAprovalStatus() {
		String r = getStatusDataType('Quoting Calculation (Formal Approval)');
		if ('1'.equals(r)) {
			if (QuotingToolHelper.isForcedCalculation(this.opportunityId)) {
				r = '0';
			}
		}
		return ICO_FORMALAPPROVAL + r;
	}

	public String getAssetLTVFormalAprovalStatus() {
		return ICO_FORMALAPPROVAL + getStatusDataType('Asset Detail - LTV (Formal Approval)');
	}

  public void submitForApproval() {
    System.debug('submitForApproval...');
    // Validations
    // Approval validations
    // Has API
    // processing or go manual

    // Submission

    // result

  }

  public void loadData() {
    if (this.opp == null) {
      System.debug('@@opportunityId: ' + this.opportunityId);
      List<Custom_Opportunity__c> d = [
        SELECT Name, Status__c, Partner_Is_External__c
        FROM Custom_Opportunity__c
        WHERE Id =: this.opportunityId
      ];
      this.opp = !d.isEmpty() ? d.get(0) : null;
    }
  }

  

}