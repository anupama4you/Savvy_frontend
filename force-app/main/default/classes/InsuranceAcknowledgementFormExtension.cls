public without sharing class InsuranceAcknowledgementFormExtension {
	
	private final Custom_Opportunity__c o;
	//public Application__c app {set;get;}
	public Application_Quoting__c quoting {set;get;}
	public Application_InsuranceQuote__c quote {set;get;}
	public Application_Additional_Driver__c mainDriver {set;get;}

	public List<Insurance_Quote_Annotation__c> offenceList {set;get;}
  public List<Insurance_Quote_Annotation__c> licencetList {set;get;}
  public List<Insurance_Quote_Annotation__c> accidentList {set;get;}
  public List<Insurance_Failure_Reason__c> reasons {set;get;}

  public Account ownerAccount {set;get;}
  public Application__c app {set;get;}

	public InsuranceAcknowledgementFormExtension(ApexPages.StandardController ctrl) {
    Set<String> fields = new Set<String>{
      'OwnerId'
    };
    if (!Test.isRunningTest()) ctrl.addFields(new List<String>(fields));
		this.o = (Custom_Opportunity__c)ctrl.getRecord();
    this.quoting = QuotingToolHelper.getApplicationQuoting(this.o.Id, this.o.Application__c);
    if (this.quoting != null)  {
      this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteById(this.quoting.App_Insurance_Quote__c);
      if (this.quote != null) {
        this.mainDriver = InsuranceQuoteUtils.getMainDriver(this.quote.Id);
        }
    }
    this.reasons = this.getInsuranceFailureReasons();

    loadMVAnnotations();
    this.ownerAccount = this.getAccountVar();

    Id appId = this.o.Application__c;
    if (appId != null) {
      List<Application__c> apps = [
        SELECT
          First_Name__c, Last_Name__c
        FROM Application__c
        WHERE Id = :appId
      ];
      this.app = apps.isEmpty()? null : apps.get(0);
    }

	}

  public Boolean getDisplayMV() {
    return (
      InsuranceQuoteUtils.displayMVProduct(this.quoting) &&
      this.quoting.Insurance_MV_Retail_Price__c > 0
    );
	}

	public Boolean getDisplayGAPRTI() {
    return (
      InsuranceQuoteUtils.displayGAPProduct(this.quoting) &&
      this.quoting.Insurance_GAP_Retail_Price__c > 0
    );
	}

	public Boolean getDisplayLTI() {
		return false;
	}

	public Boolean getDisplayLPI() {
    return (
      InsuranceQuoteUtils.displayLPIProduct(this.quoting) &&
      this.quoting.Insurance_AIC_Retail_Price__c > 0
    );
	}

	public Boolean getDisplayWARR() {
    return (
      (
        InsuranceQuoteUtils.displayEricWARRProduct(this.quoting) &&
        this.quoting.Insurance_Warranty_Retail_Price__c > 0
      ) ||
      (
        InsuranceQuoteUtils.displayIntegrityWARRProduct(this.quoting) &&
        this.quoting.Insurance_NWC_Retail_Price__c > 0
      )
    );
	}

	// Policy accepted
  public Boolean getAcceptedMV() {
    return (
      getDisplayMV() && 'A'.equals(this.quoting.Insurance_MV_Acceptance__c)
    );
	}

	public Boolean getAcceptedGAPRTI() {
    return (
      getDisplayGAPRTI() && 'A'.equals(this.quoting.Insurance_GAP_Acceptance__c)
    );
	}

	public Boolean getAcceptedLPI() {
    return (
      getDisplayLPI() && 'A'.equals(this.quoting.Insurance_AIC_Acceptance__c)
    );
	}

	public Boolean getAcceptedWARR() {
    return (
      (
        InsuranceQuoteUtils.displayEricWARRProduct(this.quoting) &&
        'A'.equals(this.quoting.Insurance_Warranty_Acceptance__c)
      ) ||
      (
        InsuranceQuoteUtils.displayIntegrityWARRProduct(this.quoting) &&
        'A'.equals(this.quoting.Insurance_NWC_Acceptance__c)
      )
    );
	}

	// Policy Declined
  public Boolean getDeclinedMV() {
    return (
      getDisplayMV() && 'D'.equals(this.quoting.Insurance_MV_Acceptance__c)
    );
	}

	public Boolean getDeclinedGAPRTI() {
    return (
      getDisplayGAPRTI() && 'D'.equals(this.quoting.Insurance_GAP_Acceptance__c)
    );
	}

	public Boolean getDeclinedLPI() {
		return (
      getDisplayLPI() && 'D'.equals(this.quoting.Insurance_AIC_Acceptance__c)
    );
	}

	public Boolean getDeclinedWARR() {
		return (
      (
        InsuranceQuoteUtils.displayEricWARRProduct(this.quoting) &&
        'D'.equals(this.quoting.Insurance_Warranty_Acceptance__c)
      ) ||
      (
        InsuranceQuoteUtils.displayIntegrityWARRProduct(this.quoting) &&
        'D'.equals(this.quoting.Insurance_NWC_Acceptance__c)
      )
    );
	}

	public boolean getIsThereAdditionalInfo() {
		Boolean r = false;
		if (this.quote != null) {
			if (getIsLTIAdditionalInfo() || getIsMVAdditionalInfo() || getDisplayMV() || getIsFailureReasons()) {
				if (!this.getExcludeInsuranceProducts()) {
					r = true;
				}
			}
		}
		return r;
	}

	public boolean getIsLTIAdditionalInfo() {
		Boolean r = false;
		if (this.quote != null && !this.getExcludeInsuranceProducts()) {
			//if (String.isNotBlank(this.quote.LTI_BRI__c) && 'A'.equals(this.quote.LTI_Acceptance__c)) {
			//	r = true;
			//} else if (this.quoting.Insurance_AIC_Retail_Price__c > 0) && 'A'.equals(this.quoting.Insurance_AIC_Acceptance__c)) {
			//	r = true;
			//}
			if (String.isNotBlank(this.quote.LTI_BRI__c) || this.quoting.Insurance_AIC_Retail_Price__c > 0) {
				r = true;
			}
            
      if (InsuranceQuoteUtils.isLiberty(this.quoting) && 'A'.equals(this.quoting.Insurance_LPI_Acceptance__c)) {
				r = true;
			}
		}
		return r;
	}

	public boolean getIsMVAdditionalInfo() {
		Boolean r = false;
		if (this.quote != null) {
			if (String.isNotBlank(this.quote.Motor_Vehicle__c) && 'A'.equals(this.quote.MV_Acceptance__c)) {
				r = true;
			}
		}
		return r;
	}

	private void loadMVAnnotations() {
        this.offenceList = new List<Insurance_Quote_Annotation__c>();
        this.licencetList = new List<Insurance_Quote_Annotation__c>();
        this.accidentList = new List<Insurance_Quote_Annotation__c>();
        if (this.quote == null) return;
        List<Insurance_Quote_Annotation__c> d = InsuranceQuoteUtils.getInsuranceQuoteAnnotations(this.quote.Id);
        for (Insurance_Quote_Annotation__c a : d) {
            if (InsuranceQuoteUtils.MOTORING_OFFENCE_TYPE.equals(a.RecordType.Name)) {
                offenceList.add(a);
            } else if (InsuranceQuoteUtils.LICENCE_SANCTIONED_TYPE.equals(a.RecordType.Name)) {
                licencetList.add(a);
            } else if (InsuranceQuoteUtils.ACCIDENT_HISTORY_TYPE.equals(a.RecordType.Name)) {
                accidentList.add(a);
            }
        }        
    }

    public Boolean getIsMVExtraQuestions() {
    	Boolean r = false;
    	if (this.quote != null) {
			if (String.isNotBlank(this.quote.Motor_Vehicle__c) &&
				String.isNotBlank(this.quote.Is_Vehicle_MV_Commercial__c) || 
				String.isNotBlank(this.quote.Is_Vehicle_Modified__c)) {
				r = true;
			}
		}
		return r;
    }

    public List<Insurance_Failure_Reason__c> getInsuranceFailureReasons() {
        List<Insurance_Failure_Reason__c> r = new List<Insurance_Failure_Reason__c>();
        if (this.quote != null && this.quote.Id != null) {
            return InsuranceQuoteUtils.getInsuranceFailureReasons(this.quote.Id);
        }
        return r;
    }

    public Boolean getIsFailureReasons() {
    	if (this.quote != null && String.isNotBlank(this.quote.MV_Declining_Notes__c)) {
    		return true;
    	}
    	return !this.reasons.isEmpty();
    }

	public Boolean getExcludeInsuranceProducts() {
		return false;
	}

  public boolean getHasIntegrityAdditionalInfo() {
		return (
      InsuranceQuoteUtils.displayIntegrityWARRProduct(this.quoting) &&
      String.isNotBlank(this.quoting.Insurance_NWC_Qualifying__c)
    );
	}

  public String getIntegrityQ1() {
    return BusinessParamHelper.getParameter('INTEGRITY_QUESTION_1');
  }

  public String getIntegrityQ2() {
    return BusinessParamHelper.getParameter('INTEGRITY_QUESTION_2');
  }

  public String getIntegrityQ3() {
    return BusinessParamHelper.getParameter('INTEGRITY_QUESTION_3');
  }

  public String getIntegrityQ4() {
    return BusinessParamHelper.getParameter('INTEGRITY_QUESTION_4');
  }

  public String getIntegrityQ5() {
    return BusinessParamHelper.getParameter('INTEGRITY_QUESTION_5');
  }

  private String getIntegrityQuestionRespose(Integer question) {
    String r = '-none-';
    if (String.isNotBlank(this.quoting.Insurance_NWC_Qualifying__c)) {
      List<String> res = new List<String>(this.quoting.Insurance_NWC_Qualifying__c.split('\\|'));
      if (question <= res.size()) {
        r = res.get(question-1);
      }
    }
    return r;
  }

  public String getIntegrityQ1Res() {
    return getIntegrityQuestionRespose(1);
  }

  public String getIntegrityQ2Res() {
    return getIntegrityQuestionRespose(2);
  }

  public String getIntegrityQ3Res() {
    return getIntegrityQuestionRespose(3);
  }

  public String getIntegrityQ4Res() {
    return getIntegrityQuestionRespose(4);
  }

  public String getIntegrityQ5Res() {
    return getIntegrityQuestionRespose(5);
  }

  public Boolean getIsPartnerUser() {
    return this.ownerAccount != null && !this.ownerAccount.Franchised__c;
  }

  public String getBusinessLogo() {
    return this.ownerAccount != null
      ? this.ownerAccount.Business_Logo__c : null;
  }

  public String getBusinessABN() {
    return this.ownerAccount != null
      ? this.ownerAccount.ABN__c : null;
  }

  public String getBusinessACL() {
    return this.ownerAccount != null
      ? this.ownerAccount.ACL__c : null;
  }

  public String getBusinessACN() {
    return this.ownerAccount != null
      ? this.ownerAccount.ACN__c : null;
  }

  public String getBusinessName() {
    return this.ownerAccount != null
      ? this.ownerAccount.Business_Name__c : null;
  }

  public String getBusinessPhone() {
    return this.ownerAccount != null
      ? this.ownerAccount.Phone : null;
  }

  public String getBusinessFax() {
    return this.ownerAccount != null
      ? this.ownerAccount.Fax : null;
  }

  public String getBusinessAddress() {
    return this.ownerAccount != null
      ? this.ownerAccount.Business_Address__c : null;
  }

  public Account getAccountVar() {
    return SOQLSingletonQueries.getPartnerAccount(this.o.OwnerId);
    // Id userId = this.o != null 
    //   ? this.o.OwnerId : UserInfo.getUserId();
    
    // System.debug('@@userId: ' + userId);
    // List<Contact> contactList = [
    //   SELECT FirstName, LastName, Email, AccountId 
    //   FROM Contact WHERE Id IN (
    //     SELECT ContactId FROM User WHERE Id = :userId
    //   )
    // ];
    // System.debug('@@contactList:' + JSON.serializePretty(contactList));
    // if(!contactList.isEmpty() && contactList[0].AccountId != null){
    //   List<Account> accountList;
    //   accountList = [
    //     SELECT 
    //       Id, Name, Fax, Phone, Business_Address__c,
    //       Business_Name__c, Business_Logo__c, Franchised__c,
    //       ABN__c, ACL__c, ACN__c
    //     FROM Account WHERE Id =: contactList[0].AccountId limit 1
    //   ];
    //   System.debug('@@accountList[0]:' + JSON.serializePretty(accountList[0]));
    //   return accountList[0];
    // }
    // return null;
  }

  public String getCustomeFullname() {
    return this.app != null 
    ? this.app.First_Name__c + ' ' + this.app.Last_Name__c : null;
  }
  
}