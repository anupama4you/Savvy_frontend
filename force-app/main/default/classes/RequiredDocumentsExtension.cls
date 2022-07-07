global class RequiredDocumentsExtension {
  public Custom_Opportunity__c record;
	public List<Cloud_Documents__c> requiredDocList {get;set;}
	public Boolean refreshPage {get; set;}
	public String accessKey{get;set;}
	public String accessSecKey{get;set;}
	public String buckName{get;set;}
	private String typeUpload = null;		//Lelo 				2016-11-15
	public Id itemSelected {set;get;}

	public RequiredDocumentsExtension(ApexPages.StandardController controller){
		
		typeUpload = System.currentPageReference().getParameters().get('TYPE');			//Lelo 				2016-11-15
		System.debug('typeUpload >> ' + typeUpload);

		this.record = (Custom_Opportunity__c)controller.getRecord();
		this.refreshPage=false;
		
		this.loadRequiredDocuments();
		
		if(accessKey == null){
      accessKey = S3Utils.s3AccessKey;
		}
		if(accessSecKey == null){
      accessSecKey = S3Utils.s3SecretKey;
		}
		if(buckName == null){
      buckName = S3Utils.s3DefaultBucket;
		}
	}

	public void loadRequiredDocuments() {
		if (getIsVDType()) {
			requiredDocList = [
        Select File_Name__c, Document_Type__c, 
          Preview_Link__c, VD_Opportunity_Document__c, Is_VD_Type__c, Send_To_Lender__c
        from Cloud_Documents__c where VD_Opportunity_Document__c = :record.Id
        ORDER BY CreatedDate DESC];
		} else {
			requiredDocList = [
        Select File_Name__c, Document_Type__c, 
          Preview_Link__c, Custom_Opportunity__c, Is_VD_Type__c, Send_To_Lender__c
        from Cloud_Documents__c where Custom_Opportunity__c = :record.Id 
        ORDER BY CreatedDate DESC];
		}
		
		if(requiredDocList == null){
			requiredDocList = new List<Cloud_Documents__c>();
		}
	}
	
	public PageReference doRefresh(){
		refreshPage=true;
		return null;
	}
    
	public PageReference SaveAndSubmitChanges(){
		SaveInlineChanges();
		if (getIsVDType()) {
			return new PageReference('/apex/ValidateSubmit?id=' + record.Id + '&TYPE=VD');
		} else {
			return new PageReference('/apex/ValidateSubmit?id=' + record.Id);
		}
	}
	
	public void SaveInlineChanges(){
		update requiredDocList;
	}
	
	@RemoteAction
	global static void insertCloudDocs(List<Cloud_Documents__c> recordList){
		Set<String> docName = new Set<String>();
		Id docOpp;
		for(Cloud_Documents__c recToAdd : recordList){
			docName.add(recToAdd.Name);
			//Lelo 				2016-11-15
			docOpp = recToAdd.Custom_Opportunity__c;
			if (docOpp == null && recToAdd.VD_Opportunity_Document__c != null) {
				docOpp = recToAdd.VD_Opportunity_Document__c;
			}
			//-
		}
		
		Map<String, Boolean> nameExistingMap = new Map<String, Boolean>();
		List<Cloud_Documents__c> newDocs = new List<Cloud_Documents__c>();

		//Lelo 			2016-11-15
		List<Cloud_Documents__c> tmpDocs = 
					  [Select Id, Name from Cloud_Documents__c 
					   where Name in: docName and (Custom_Opportunity__c =: docOpp or VD_Opportunity_Document__c =: docOpp)];
		//-

		for(Cloud_Documents__c existingDoc : tmpDocs){
			nameExistingMap.put(existingDoc.Name, true);
		}

		for(Cloud_Documents__c recToAdd : recordList){
			if(nameExistingMap.get(recToAdd.Name) == null || (!nameExistingMap.get(recToAdd.Name))){
				newDocs.add(recToAdd);
			} 
		}
		insert newDocs;
	}

	//Lelo 				2016-11-15
	public Boolean getIsVDType() {
		System.debug('typeUpload 2 >> ' + typeUpload);
		if ('VD'.equals(typeUpload)) return true;
		return false;
	}
	//-

	public PageReference deleteDocument() {
		PageReference r = null;
		System.debug('Opening >> ' + this.itemSelected);
		if (this.itemSelected != null) {
			List<Cloud_Documents__c> doc = [
				SELECT Folder_Id__c, Bucket_Name__c, File_Name__c, Document_Type__c
				FROM Cloud_Documents__c WHERE Id = :this.itemSelected
			];
			if (!doc.isEmpty()) {
				try {
					delete doc;
				} catch (Exception e) {
					if (!e.getMessage().contains('ENTITY_IS_DELETED')) {
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Error deleting: ' + doc.get(0).File_Name__c + ' | ' + doc.get(0).Document_Type__c));
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
					}
				}
			}
			loadRequiredDocuments();
		}
		return r;
	}

	public PageReference goApplication() {
		return goPage(Page.OppApplication);
	}

	public PageReference submitPreApproval() {
		return goPage(Page.ValidatePreApprovalSubmit);
	}

	public PageReference submitAmendment() {
		return goPage(Page.ValidateAmendmentSubmit);
	}

	public PageReference submitFormalApproval() {
		return goPage(Page.ValidateFormalApprovalSubmit);
	}

	private PageReference goPage(PageReference pageRef) {
		if (pageRef != null) {
			pageRef.getParameters().put('id', record.Id);
		}
		return pageRef;
	}
}