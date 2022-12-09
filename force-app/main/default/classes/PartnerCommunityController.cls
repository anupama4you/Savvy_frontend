public with sharing class PartnerCommunityController {
  
  public static String BUCKET = 'mybucket';
  public static String BASE_FOLDER = 'my-folder';
  public static String userrId = UserInfo.getUserId();
  static {
    Parameters_Service__c p = Parameters_Service__c.getInstance(S3Utils.PARAM_PARTNERBUCKET);
    BUCKET = p != null? p.value__c : BUCKET;
    p = Parameters_Service__c.getInstance(S3Utils.PARAM_PARTNERBUCKET);
    BASE_FOLDER = p != null? p.value__c : BASE_FOLDER;
    // BUCKET = Parameters_Service__c.getInstance(S3Utils.PARAM_PARTNERFOLDER).value__c;
    // BASE_FOLDER = Parameters_Service__c.getInstance(S3Utils.PARAM_PARTNERFOLDER).value__c;
  }

  @AuraEnabled(cacheable=true)
  public static List<RecentlyViewed> getRecentItems(Integer numItems){
    List<RecentlyViewed> r = [SELECT Id, Name FROM RecentlyViewed 
            WHERE Type IN ('Account', 'Lead__c','Custom_Opportunity__c')
            ORDER BY LastViewedDate DESC
            LIMIT :numItems
    ];
    System.debug('total records: ' + r.size());
    return r;
  }

  @AuraEnabled(cacheable=true)
  public static List<Lead__c> getRecentLeads(Integer numItems){
    List<Lead__c> r = [SELECT Id, Name, Loan_Type__c FROM Lead__c 
            ORDER BY LastModifiedDate DESC
            LIMIT :numItems
    ];
    System.debug('total records: ' + r.size());
    return r;
  }

  @AuraEnabled(cacheable=false)
  public static List<Lead__c> getUnassignedLeadList() {
    System.debug('getUnassignedLeadList...');
    // String userrId= UserInfo.getUserId();
    User sg = SOQLSingletonQueries.recs().sysGenUser;
    System.debug('system gen => ' + sg.Id);
    return [
      select 
        id,name,Home_Phone__c,Mobile_Number__c,
        Email_Address__c,createdDate, Owner.Alias
      from Lead__c 
      where  Owner.Type = 'Queue'
      and status__c = 'New Lead'
      Order by createdDate asc limit 5 ];
  }

  @AuraEnabled
  public static Map<String, List<Custom_Opportunity__c>> getPipelineOpportunities() {
    Id userId = UserInfo.getUserId();
    Map<String, List<Custom_Opportunity__c>> tmp = new Map<String, List<Custom_Opportunity__c>>();
    
     // Include default statuses
    Set<String> ds = new Set<String>{
      'Become Opportunity', 'Quote Sent', 'Application Form Sent', 'Application Form Received', 
      'Awaiting Further Information', 'Pre-Approved', 'Sent to Lender for Pre-Approval'
    };
    for (String k : ds) {
      tmp.put(k, new List<Custom_Opportunity__c>());
    }    

    List<Custom_Opportunity__c> d = [
      SELECT 
        Id, Name, Total_Commission__c, Status__c, NAF_Net_Amount_Financed__c, 
        Mobile_Number__c, LastModifiedDate
      FROM Custom_Opportunity__c 
      WHERE status__c not in ('Settled','Closed Opportunity', null)
      AND Ownerid = :UserInfo.getUserId()
      ORDER BY Status__c DESC
    ];
    for (Custom_Opportunity__c o : d) {
      List<Custom_Opportunity__c> opps = tmp.get(o.Status__c);
      if (opps == null) {
        opps = new List<Custom_Opportunity__c>();
        tmp.put(o.Status__c, opps);
      }
      opps.add(o);
    }
   
    // List<String> keys = new List<String>(tmp.keySet());
    // keys.sort();
    // Map<String, List<Custom_Opportunity__c>> r = new Map<String, List<Custom_Opportunity__c>>();
    // for (String k: keys) {
    //   r.put(k, tmp.get(k));
    // }
    return tmp;
  }

  @AuraEnabled
  public static void uploadFileOrFail(Id parentId, String fileName, String fileType, String fileContent) {
      if (filename == null) {
          throw new GenericException('Filename is empty');
      }
      String fn = S3Utils.cleanFileName(fileName);
      String folder = getMyS3Folder() + '/' + parentId;
      String objectName = S3Utils.cleanFileName(folder) + '/' + fn;
      //  file
      objectName = S3Utils.renameS3Filename(objectName, true, 255);
      S3Utils.saveFileOrFail(BUCKET, objectName, fileContent, fileType);
      insertOppDocument(parentId, objectName, fn, null);
  }

  public static void uploadFileOrFail(Id parentId, String fileName, String fileType, Blob fileContent) {
      if (filename == null) {
          throw new GenericException('Filename is empty');
      }
      String fn = S3Utils.cleanFileName(fileName);
      String folder = getMyS3Folder() + '/' + parentId;
      String objectName = S3Utils.cleanFileName(folder) + '/' + fn;
      //  file
      objectName = S3Utils.renameS3Filename(objectName, true, 255);
      S3Utils.saveFileOrFail(BUCKET, objectName, fileContent, fileType);
      insertOppDocument(parentId, objectName, fn, null);
  }

  private static Cloud_Documents__c insertOppDocument(Id oppId, String s3FileObject, String fileName, String documentType) {
    String fn = S3Utils.renameS3Filename(fileName, false, 80);
    Cloud_Documents__c c = new Cloud_Documents__c();
    c.Name = fn;
    c.Bucket_Name__c = BUCKET;
    c.Custom_Opportunity__c = oppId;
    c.Access_Level__c = 'private';
    c.File_Name__c = fileName;
    c.Folder_Id__c = s3FileObject;
    insert c;
    System.debug('Inserted cloud document =====>' + JSON.serializePretty(c));
    return c;
  }

  @AuraEnabled
  public static List<Cloud_Documents__c> listCloudDocuments(Id oppId) {
    return [
      Select Id, Name, Document_Type__c, Send_To_Lender__c, File_Name__c From Cloud_Documents__c 
      Where Custom_Opportunity__c = :oppId Order By CreatedDate DESC
    ];
  }
  
  public class DocWrapper {
      public String Id;
      public String Send_To_Lender;
      public String Document_Type;
  }
  
  @AuraEnabled
  public static Boolean updateCloudDocuments(String updatedDocList) {
    List<Cloud_Documents__c> updatecloudDocList = new List<Cloud_Documents__c>();
    updatedDocList = updatedDocList.remove('[');
    updatedDocList = updatedDocList.remove(']');
    updatedDocList = updatedDocList.replaceAll('__c', '');
    System.debug('updatedDocList =====>' + updatedDocList);
    try {
        if (updatedDocList != Null) {
            List<DocWrapper> wrapList = new List<DocWrapper>();
            List<String> strList = updatedDocList.split('},');
            System.debug('strList =====>' + strList);
            for ( String str : strList ) {
                DocWrapper wrap = new DocWrapper();
                if ( !str.endsWith('}') ) {
                    str += '}';
                }
                System.debug('str =====>' + str);
                wrap = (DocWrapper)System.JSON.deserialize( str, DocWrapper.class);
                wrapList.add(wrap);
            }
            
            System.debug('wrapList size =====>' + wrapList.size());
            System.debug('wrapList =====>' + wrapList);
            
            for ( DocWrapper  wrapperRecord : wrapList ) {
                if (wrapperRecord.Send_To_Lender != null || wrapperRecord.Document_Type != null) {
                    Cloud_Documents__c rec = new Cloud_Documents__c();
                    rec.Id = wrapperRecord.Id;
                    if (wrapperRecord.Send_To_Lender != null) {
                        rec.Send_To_Lender__c = Boolean.valueOf(wrapperRecord.Send_To_Lender);
                    }
                    
                    if (wrapperRecord.Document_Type != null) {
                        rec.Document_Type__c = wrapperRecord.Document_Type;
                    }
                    updatecloudDocList.add(rec);
                }
            }
        }
        
        if (updatecloudDocList != Null) {
            System.debug('updatecloudDocList =====>' + updatecloudDocList);
            update updatecloudDocList;
        }
        return true;
    } catch(Exception e) {
        return false;
    }
  }

  @AuraEnabled
  public static String signCloudDocument(String docId) {
    return S3Utils.getSignedURL(docId);
  }

  @AuraEnabled
  public static Boolean deleteCloudDocument(Id docId) {
    System.debug('Deleting file Id: ' + docId);
    if (docId == null) return false;
    delete [Select Id From Cloud_Documents__c Where id= :docId];
    return true;
  }

  private static String getMyS3Folder() {
    String r = BASE_FOLDER;
    String partnerFolder = '';
    Contact c = SOQLSingletonQueries.recs().myContact;
    if (c != null) {
      if (String.isNotBlank(c.Account.S3_Folder__c)) {
        partnerFolder = (String.isNotBlank(c.Account.S3_Folder__c)? c.Account.S3_Folder__c : c.AccountId);
      }
    }
    if (String.isNotBlank(partnerFolder)) {
      r += '/' + partnerFolder;
    // } else if (SOQLSingletonQueries.recs().isSavvyAdmin()) {
    } else if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {      
      r += '/savvy';
    } else {
      throw new GenericException('Partner S3 folder not found, please contact support.');
    }
    return r;
  }

  @AuraEnabled
  public static Custom_Opportunity__c convertToOpportunity(Id leadId, Custom_Opportunity__c data) {
    System.debug('Converting to opp: ' + leadId);
    System.debug(JSON.serializePretty(data));
    
    // Load lead data
    Lead__c lead = [
      Select 
        Id, Status__c, Application__c, OwnerType__c
      From Lead__c Where Id = :leadId];

    System.debug(JSON.serializePretty(lead));

    // Search an account
    Account acc = searchMostRecentAccount(data.Email_Address__c, data.Mobile_Number__c);
    if (acc == null) {
      // Create account
      acc = createDefaultAccount(data);
    }

    // Link Account
    data.Account__c = acc.Id;    
    // Link Application
    data.Application__c = lead.Application__c;

    // Update 
    dataCheckerOpps(new List<Custom_Opportunity__c>{data});

    // Validate data
    insert data;

    // Update Laed
    lead.Status__c = 'Become Opportunity';
    lead.Account__c = data.Account__c;
    if ('Queue'.equals(lead.OwnerType__c)) {
      // Ownership adjustment
      lead.OwnerId = UserInfo.getUserId();
    }
    update lead;

    if (String.isNotBlank(lead.Application__c)) {
      // Upload Opportunity documents
      OpportunityService.uploadS3ApplicationDocs(
        new List<Custom_Opportunity__c>{data}, null
      );
    }

    return data;
  }

  private static Account searchMostRecentAccount(String email, String mobile) {
    Account r = null;
    Id personRecordTypeId  = SOQLSingletonQueries.recs().recordTypes.get('Person Account');
    List<Account> accs = [
      Select Id From Account 
      Where PersonEmail = :email 
      And RecordTypeId =: personRecordTypeId
      Order By LastModifiedDate DESC
    ];
    if (accs.isEmpty()) {
      accs = [
        Select Id From Account 
        Where PersonMobilePhone = :mobile 
        And RecordTypeId =: personRecordTypeId
        Order By LastModifiedDate DESC
      ];
    }
    // Associate Lead
    if (!accs.isEmpty()) {
      r = accs.get(0);
    }
    return r;
  }

  private static Account createDefaultAccount(Custom_Opportunity__c opp) {
    Id personRecordTypeId  = SOQLSingletonQueries.recs().recordTypes.get('Person Account');
    Account a = new Account (
      RecordTYpeId = personRecordTypeId,
      FirstName = opp.First_Name__c,
      LastName = opp.Last_Name__c,
      PersonMobilePhone = opp.Mobile_Number__c,
      PersonEmail = opp.Email_Address__c
    );
    dataCheckerAccounts(new List<Account>{a});
    insert a;
    return a;
  }

  @AuraEnabled
  public static TodoStatus getOppTodoListStatuses(Id oppId) {
    TodoStatus r = new TodoStatus();
    System.debug('getOppTodoListStatuses... ' + oppId);
    // Validate parameter
    if (oppId == null) return r;
    // Find Opportunity
    List<Custom_Opportunity__c> opps = [
      Select Application__c, Application__r.Status__c From Custom_Opportunity__c
      Where Id = :oppId
    ];
    if (!opps.isEmpty()) {
      Custom_Opportunity__c o = opps.get(0);
      if (o.Application__c != null) {
        // App form
        r.appFormStatus = o.Application__r.Status__c;
        
        // Load data
        Set<String> dataTypes = ApplicationExtraDataHelper.getAllExtraDataTypesSaved(o.Application__c);
        // YTD
        r.ytdPA = dataTypes.contains('YTD Calculation');
        // Servicing
        r.servPA = dataTypes.contains('Servicing Calculation');
        // Asset Details Pre-approval
        r.assetPA = dataTypes.contains('Asset Detail - LTV (Pre-approval)');
        // Asset Details Formal-approval
        r.assetFA = dataTypes.contains('Asset Detail - LTV (Formal Approval)');
        // Quoting Pre-approval\
        r.quotingPA = dataTypes.contains('Quoting Calculation');
        // Quoting Formal-approval
        r.quotingFA = dataTypes.contains('Quoting Calculation (Formal Approval)') && QuotingToolHelper.isForcedCalculation(oppId);
      }
    }
    System.debug(JSON.serializePretty(r));
    return r;
  }

  @AuraEnabled(cacheable=true)
  public static Application_Quoting__c getOppQuoting(Id oppId, List<String> fields) {
    String sql = 'Select ' + buildFields(fields) + ' From Application_Quoting__c ';
    sql += 'Where Opportunity__c = :oppId ';
    sql += 'Order By LastModifiedDate DESC';

    List<Application_Quoting__c> d = Database.query(sql);

    Application_Quoting__c r = null;
    if (!d.isEmpty()) {
      r = d.get(0);
    }
    // System.debug('getOppQuoting... ' + oppId + ' | ' + !d.isEmpty());
    return r;
  }

  public static String buildFields(List<String> fields) {
    String r = '';
    if (fields != null && !fields.isEmpty()) {
      for (String a : fields) {
        if (String.isNotBlank(r)) { r += ','; }
        r += a;
      }
    }
    return r;
  }

  @AuraEnabled
  public static Id createTask (MyTask task) {
    if (task == null) {
      throw new GenericException('not found any task detail');
    }

    Task a = new Task();
    a.OwnerId = UserInfo.getUserId();
    a.WhatId = task.whatId;
    a.Subject = task.subject;
    a.Status = task.status;
    a.Priority = task.priority;
    a.Description = task.comments;
    a.ActivityDate = task.dueDate;

    a.TaskSubtype = 'Task';
    a.IsReminderSet = false;

    insert a;
    return a.Id;
  }

  public class TodoStatus {
    @AuraEnabled public String appFormStatus {set;get;}
    @AuraEnabled public Boolean quotingPA {set;get;}
    @AuraEnabled public Boolean quotingFA {set;get;}
    @AuraEnabled public Boolean ytdPA {set;get;}
    @AuraEnabled public Boolean servPA {set;get;}
    @AuraEnabled public Boolean assetPA {set;get;}
    @AuraEnabled public Boolean assetFA {set;get;}

    public TodoStatus () {
      this.quotingPA = false;
      this.quotingFA = false;
      this.ytdPA = false;
      this.servPA = false;
      this.assetPA = false;
      this.assetFA = false;
    }

  }

  public class MyTask {
    @AuraEnabled public Id whatId {set;get;}
    @AuraEnabled public String subject {set;get;}
    @AuraEnabled public String comments {set;get;}
    @AuraEnabled public String priority {set;get;}
    @AuraEnabled public String status {set;get;}
    @AuraEnabled public Date dueDate {set;get;}

  }

  // Trigger handler 
  public static void dataCheckerOpps(List<Custom_Opportunity__c> opps) {
    System.debug('dataCheckerOpps... ' + opps.size());
    if (
      opps != null &&
      !opps.isEmpty() &&
      SOQLSingletonQueries.recs().isBrokerPartnerUser &&
      SOQLSingletonQueries.recs().myContact != null &&
      SOQLSingletonQueries.recs().myContact.AccountId != null
    ) {
      System.debug('dataCheckerOpps => adding ownership');
      Id accId = SOQLSingletonQueries.recs().myContact.AccountId;
      for (Custom_Opportunity__c o: opps) {
        o.Partner_Owner__c = accId;
      }
    }
  }

  public static void dataCheckerLeads(List<Lead__c> leads) {
    if (
      leads != null &&
      !leads.isEmpty() &&
      SOQLSingletonQueries.recs().isBrokerPartnerUser &&
      SOQLSingletonQueries.recs().myContact != null &&
      SOQLSingletonQueries.recs().myContact.AccountId != null
    ) {
      Id accId = SOQLSingletonQueries.recs().myContact.AccountId;
      for (Lead__c ld: leads) {
        ld.Partner_Owner__c = accId;
      }
    }
  }

  public static void dataCheckerApplications(List<Application__c> apps) {
    if (
      apps != null &&
      !apps.isEmpty() &&
      SOQLSingletonQueries.recs().isBrokerPartnerUser &&
      SOQLSingletonQueries.recs().myContact != null &&
      SOQLSingletonQueries.recs().myContact.AccountId != null
    ) {
      Id accId = SOQLSingletonQueries.recs().myContact.AccountId;
      for (Application__c a: apps) {
        a.Partner_Owner__c = accId;
      }
    }
  }

  public static void dataCheckerAccounts(List<Account> accs) {
    if (
      accs != null &&
      !accs.isEmpty() &&
      SOQLSingletonQueries.recs().isBrokerPartnerUser &&
      SOQLSingletonQueries.recs().myContact != null &&
      SOQLSingletonQueries.recs().myContact.AccountId != null
    ) {
      Id accId = SOQLSingletonQueries.recs().myContact.AccountId;
      for (Account a: accs) {
        a.Partner_Owner__c = accId;
      }
    }
  }

  public static Id getPartnerDefaultOwner(Id accountId) {
    Id r = null;
    if (accountId != null) {
      List<Account> d = [
        SELECT Default_Ownership__c 
        FROM Account
        WHERE Id = :accountId
      ];
      r = !d.isEmpty()? d.get(0).Default_Ownership__c : r;
    }
		return r;
	}

  @AuraEnabled
  public static Id cloneOpportunity(Id oppId) {
    Id newOppId = null;
    if (String.isNotBlank(oppId)) {
      Custom_Opportunity__c opp = null;
      try {
        // Select what data is going to be cloned
        opp = [
          SELECT 
            Id, Name, Account__c, First_Name__c, Last_Name__c, Notes__c,
            Mobile_Number__c, Email_Address__c, Home_Phone__c, Work_Phone__c,
            Second_Applicant_First_Name__c, Second_Applicant_Last_Name__c,
            Second_Applicant_Email__c, State__c, Application__c
          FROM Custom_Opportunity__c
          WHERE Id = :oppId
        ];
      } catch (Exception e) {
        System.debug('Error searching the opportunity: ' + oppId);
        System.debug(e.getStackTraceString());
        throw new GenericException('Opportunity not found [' + oppId + ']');
      }
      if (opp != null) {
        Custom_Opportunity__c newOpp = opp.clone(false, true, false, false);
        try {
          insert newOpp;
          newOppId = newOpp.Id;
        } catch (Exception e) {
          System.debug('Error cloning the opportunity: ' + oppId);
          System.debug(e.getStackTraceString());
          throw new GenericException('Opportunity not cloned [' + oppId + ']. ' + e.getMessage());
        }

      }
    }
    return newOppId;
  }
}