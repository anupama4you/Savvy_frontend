global class CloudDocGeneratorBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
	
	public static final Integer APP_PREAPPROVAL_DOC = 1;
	public static final Integer DOF_INVOICE_DOC = 2;
    public static final Integer VD_FLEETREFERRAL = 3;

	String query;
	global final Id oppId;
	global final Integer typeDocProcess;

	
	global CloudDocGeneratorBatch(Id oppId, Integer typeProcess) {
		query = 'Select Id, VD_Worksheet__r.Type_of_Process__c From Custom_Opportunity__c Where id = \'' + oppId + '\'';
		this.oppId = oppId;		
		this.typeDocProcess = typeProcess;
		System.debug('Params: ' + this.oppId + '|' + this.typeDocProcess);
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		for(Sobject s : scope){
        	Custom_Opportunity__c o = (Custom_Opportunity__c)s;
        	if (APP_PREAPPROVAL_DOC == typeDocProcess) {
        		appPreApprovalPdfDoc(o);
        	} else if (DOF_INVOICE_DOC == typeDocProcess) {
        		dofInvoicePdfDoc(o);
        	} else if (VD_FLEETREFERRAL == typeDocProcess) {
                vdFleetReferralPdfDoc(o);
            }
        }
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
	private void appPreApprovalPdfDoc(Custom_Opportunity__c o) {
		System.debug('appPreApprovalPdfDoc: ' + o.Id);
		PageReference pdf = Page.GenerateAppPdf;
        pdf.getParameters().put('id', o.Id);
        pdf.getParameters().put('IS_PREAPPROVAL', String.valueOf(true));
        String prefixName = 'App_PRE_APPROVAL_';
        System.debug('Saving the file...');
        Blob body = Test.isRunningTest()? Blob.valueOf('a') : pdf.getContent();
        String fileName = prefixName + '_' + o.Id + '_' + Datetime.now().format('yyyyMMddHHmmss') + '.pdf';
        String docType = 'Application Form (Pre-approval)';

        CloudRequiredDocument d = new CloudRequiredDocument(docType);
        d.blobFile = body;
        d.contentType = 'application/pdf';
        d.docName = fileName;
        d.fileName = fileName;
        d.oppId = o.Id;
        CloudDocsHelper.saveToCloud(d);
	}

	private void dofInvoicePdfDoc(Custom_Opportunity__c o) {
		System.debug('dofInvoicePdfDoc: ' + o.Id);
		PageReference pdf = Page.dofInvoice;
        pdf.getParameters().put('id', o.Id);
        String prefixName = 'DOF_Invoice_';
        System.debug('Saving the file...');
        Blob body = Test.isRunningTest()? Blob.valueOf('a') : pdf.getContent();
        String fileName = prefixName + '_' + o.Id + '_' + Datetime.now().format('yyyyMMddHHmmss') + '.pdf';
        String docType = 'DOF Invoice';

        CloudRequiredDocument d = new CloudRequiredDocument(docType);
        d.blobFile = body;
        d.contentType = 'application/pdf';
        d.docName = fileName;
        d.fileName = fileName;
        d.oppId = o.Id;
        CloudDocsHelper.saveToCloud(d);
	}

    private void vdFleetReferralPdfDoc(Custom_Opportunity__c o) {
        System.debug('vdFleetReferralPdfDoc: ' + o.Id);
        PageReference pdf = Page.FleetReferralPdf;
        pdf.getParameters().put('id', o.Id);
        // String prefixName = 'Fleet_Referral_Form_';
        // if (o.VD_Worksheet__c != null && ''.equals(o.VD_Worksheet__r.Type_of_Process__c)) {
        //     prefixName = 'NewCarDemo_Form_';
        // }
        String prefixName = (o.VD_Worksheet__c != null && ''.equals(o.VD_Worksheet__r.Type_of_Process__c)) 
        ? 'NewCarDemo_Form_' : 'Fleet_Referral_Form_';
        System.debug('Saving the file...');
        Blob body = Test.isRunningTest()? Blob.valueOf('a') : pdf.getContent();
        String fileName = prefixName + '_' + o.Id + '_' + Datetime.now().format('yyyyMMddHHmmss') + '.pdf';
        String docType = 'VD - Fleet Referral Form';

        CloudRequiredDocument d = new CloudRequiredDocument(docType);
        d.blobFile = body;
        d.contentType = 'application/pdf';
        d.docName = fileName;
        d.fileName = fileName;
        d.oppId = o.Id;
        d.isVDType = true;
        CloudDocsHelper.saveToCloud(d);
    }


	public static void createBatch(Id oppId, Integer typeProcess, Integer minutes) {
        // Datetime d = Datetime.now();
        // String jobName = 'CloudDoc:' + oppId + '|' + typeProcess + '|' + d.format('yyyy.MM.dd.HH.mm.ss');
        String jobName = 'CloudDoc:' + oppId + '|' + typeProcess + '|' + Utilities.getGUID();
        
        //Schedule a new job
        System.scheduleBatch(
            				new CloudDocGeneratorBatch(oppId, typeProcess), 
            				jobName, minutes);
    }

}