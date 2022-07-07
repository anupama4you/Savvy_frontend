public with sharing class SendEmailController {
  private static String EMAIL_FOLDER = 'Partner Manual Emails';
  @AuraEnabled
  public static List<EmailTemplate> getEmailTemplate() {
    return [
      SELECT Id, Name, Body, Subject, HtmlValue
      FROM EmailTemplate
      WHERE Folder.Name = :EMAIL_FOLDER
      AND IsActive = true
      ORDER BY Name
    ];
  }

  @AuraEnabled
  public static EmailMessage renderEmailTemplatewithMergeField(
    String templateId,
    String recordId
  ) {
    EmailMessage msg = null;
    try {
      Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(
        templateId,
        UserInfo.getUserId(),
        recordId
      );
      msg = new EmailMessage(
        message.getHtmlBody(),
        message.getSubject()
      );
      System.debug('msg-->' + msg);
    } catch (Exception e) {
      throwAuraException(e);
    }
    return msg;
  }
  @AuraEnabled
  public static List<String> getExistitingDocument(String oppId) {
    Set<String> relatedDocumentExistList = new Set<String>();
    if (!String.isempty(oppId)) {
      for (Required_Document__c opp : [
        SELECT ID, Name
        FROM Required_Document__c
        WHERE Opportunity__c = :oppId
      ]) {
        if (opp.Name != null) {
          relatedDocumentExistList.add(opp.Name.trim());
        }
      }
    }
    List<String> docList = new List<String>();
    if (relatedDocumentExistList.size() > 0) {
      docList.addall(relatedDocumentExistList);
    }
    return docList;
  }

  @AuraEnabled
  public static Map<String, String> getRequireDocumentList() {
    Map<String, String> returnAllDocumentList = new Map<String, String>();
    Schema.DescribeFieldResult fieldResult = Required_Document__c.Type__c.getDescribe();
    for (Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
      returnAllDocumentList.put(f.getLabel(), f.getValue());
    }
    return returnAllDocumentList;
  }

  @AuraEnabled
  public static List<SelectDocumentWrapper> allDocumentList(String oppId) {
    system.debug('::::: allDocumentList :::::' + oppId);
    List<SelectDocumentWrapper> SelectDocumentWrapperList = new List<SelectDocumentWrapper>();
    //String oppId = 'a0EN000000HR0f1MAD';
    try {
      if (!String.isEmpty(oppId)) {
        List<String> relatedDocumentExistList = SendEmailController.getExistitingDocument(
          oppId
        );
        Map<String, String> allreqDocList = SendEmailController.getRequireDocumentList();
        for (String str : allreqDocList.values()) {
          if (!relatedDocumentExistList.contains(str)) {
            SelectDocumentWrapperList.add(
              new SelectDocumentWrapper(false, str)
            );
          }
        }
      }
      // return SelectDocumentWrapperList;
    } catch (Exception e) {
      throwAuraException(e);
    }
    system.debug('SelectDocumentWrapperList ::::' + SelectDocumentWrapperList);
    return SelectDocumentWrapperList;
  }

  @AuraEnabled
  public static List<SelectDocumentWrapper> DocumentSave(
    Object docList,
    String recordIdd
  ) {
    system.debug('docList::' + docList);
    List<SelectDocumentWrapper> allDoc = new List<SelectDocumentWrapper>();
    try {
      system.debug('recordid ::::: ' + recordIdd);
      String jsonString = JSON.serialize(docList);
      List<SelectDocumentWrapper> deserializeddocList = (List<SelectDocumentWrapper>) JSON.deserialize(
        JSONString,
        List<SelectDocumentWrapper>.class
      );
      List<Required_Document__c> RequiredDocumentList = new List<Required_Document__c>();
      Map<String, String> requiredDocumentMap = new Map<String, String>();
      requiredDocumentMap = SendEmailController.getRequireDocumentList();
      // Custom_Opportunity__c  opp = new Custom_Opportunity__c (Id = recordIdd);
      // List<Custom_Opportunity__c> oppList = [
      //   SELECT Id, Related_Documents__c
      //   FROM Custom_Opportunity__c
      //   WHERE Id = :recordIdd
      // ];
      // String str = oppList[0].Related_Documents__c != null
      //   ? (oppList[0].Related_Documents__c)
      //   : '';
      String str = '';
      System.debug('requiredDocumentMap => ' + requiredDocumentMap.size());
      for (SelectDocumentWrapper s : deserializeddocList) {
        System.debug('DocWrapper => ' + JSON.serialize(s));
        if (s.flag) {
          str += '<li>' + s.documentName + ' </li>';
          system.debug('::::::' + s.documentName);
          if (requiredDocumentMap.containskey(s.documentName)) {
            //requiredDocumentMap.get(s.documentName)
            RequiredDocumentList.add(
              new Required_Document__c(
                Name = s.documentName,
                Type__c = s.documentName,
                Opportunity__c = recordIdd
              )
            );
          }
        }
      }
      str = String.isNotBlank(str) ? '<ul>' + str + '</ul>' : str;
      System.debug('req docs => ' + str);
      System.debug('RequiredDocumentList => ' + RequiredDocumentList.size());

      // opp.Related_Documents__c = str;
      try {
        if (RequiredDocumentList.size() > 0) {
          update new Custom_Opportunity__c(
            Id = recordIdd,
            Related_Documents__c = str
          );
          // insert RequiredDocumentList;
        }
      } catch (exception e) {
        system.debug('errrrrrrr:::::' + e.getMessage());
        throwAuraException(e);
      }
      System.debug('deserializeddocList  --- ' + deserializeddocList);
      system.debug('docList::::' + docList);
      //  SendEmailController.allDocumentList(recordIdd)
      // allDoc = SendEmailController.allDocumentList(recordIdd);
      // system.debug('selDoc:::::'+selDoc);
    } catch (Exception e) {
      throwAuraException(e);
    }
    return allDoc;
  }

  @AuraEnabled
  public static void sendEmail(
    String templateId,
    String recordId,
    String subject,
    String htmlBody,
    String toAddress,
    String ccAddress,
    String bccAddress,
    String additionalToAddress,
    String base64,
    String filename,
    Object docList
  ) {
    try {
      String[] contactEmail = new List<String>();
      List<Custom_Opportunity__c> opp = [
        SELECT Id, Email_Address__c, Related_Documents__c
        FROM Custom_Opportunity__c
        WHERE Id = :recordId
        LIMIT 1
      ];
      if (!opp.isEmpty()) {

        // Save required documents before sending the email
        saveRequiredDocs(opp.get(0).Id, docList);
        //--------------------------------

        if (String.isNotBlank(toAddress))
          contactEmail.add(toAddress);
        if (String.isNotBlank(additionalToAddress))
          contactEmail.add(additionalToAddress);
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        Messaging.SingleEmailMessage storedMessage = Messaging.renderStoredEmailTemplate(
          templateId,
          UserInfo.getUserId(),
          recordId
        );
        message.setToAddresses(contactEmail);
        if (String.isNotBlank(ccAddress)) {
          message.setCcAddresses(new List<String>{ ccAddress });
        }
        if (String.isNotBlank(bccAddress)) {
          message.setBccAddresses(new List<String>{ bccAddress });
        }
        message.setWhatId(recordId);
        // message.setSenderDisplayName('Savvy Support');
        message.setUseSignature(false);
        message.setBccSender(false);
        message.setSaveAsActivity(true);
        //message.setSubject(storedMessage.getSubject());
        //message.setHtmlBody(storedMessage.getHtmlBody());
        message.setSubject(subject);
        message.setHtmlBody(htmlBody);
        System.debug('base64--->' + base64 + '......' + filename);
        if (base64 != null && filename != null) {
          List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
          Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
          efa.setFileName(filename);
          efa.setBody(EncodingUtil.base64Decode(base64));
          //efa.setContentType(file.ContentType);
          attachments.add(efa);
          message.setFileAttachments(attachments);
        }
        messages.add(message);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
      }
    } catch (Exception e) {
      throwAuraException(e);
    }
  }

  public static void saveRequiredDocs(Id oppId, Object docList) {
    if (oppId != null && docList != null) {
      try {
        system.debug('Opp Id ::::: ' + oppId);
        String jsonString = JSON.serialize(docList);
        List<SelectDocumentWrapper> deserializeddocList = (List<SelectDocumentWrapper>) JSON.deserialize(
          JSONString,
          List<SelectDocumentWrapper>.class
        );
        List<Required_Document__c> docs = new List<Required_Document__c>();
        Map<String, String> requiredDocumentMap = SendEmailController.getRequireDocumentList();
        System.debug('requiredDocumentMap => ' + requiredDocumentMap.size());
        for (SelectDocumentWrapper s : deserializeddocList) {
          System.debug('DocWrapper => ' + JSON.serialize(s));
          if (s.flag) {
            system.debug('::::::' + s.documentName);
            if (requiredDocumentMap.containskey(s.documentName)) {
              docs.add(
                new Required_Document__c(
                  Name = s.documentName,
                  Type__c = s.documentName,
                  Opportunity__c = oppId
                )
              );
            }
          }
        }
        
        System.debug('RequiredDocumentList => ' + docs.size());

        if (!docs.isEmpty()) {
          update new Custom_Opportunity__c(
            Id = oppId,
            Related_Documents__c = null
          );
          insert docs;
        }
      } catch (exception e) {
        system.debug('errrrrrrr:::::' + e.getMessage());
        throwAuraException(e);
      }
    }
  }

  public static void throwAuraException(Exception err) {
    if (err != null) {
      AuraHandledException auEx = new AuraHandledException(err.getMessage());
      auEx.setMessage(err.getMessage());
      throw auEx;
    }
  }

  public class EmailMessage {
    @AuraEnabled
    public String emailBody { get; set; }
    @AuraEnabled
    public String subject { get; set; }
    public EmailMessage(String emailBody, String subject) {
      this.emailBody = emailBody;
      this.subject = subject;
    }
  }

  public class SelectDocumentWrapper {
    @AuraEnabled
    public Boolean flag;
    @AuraEnabled
    public string documentName;
    public SelectDocumentWrapper(Boolean flag, String documentName) {
      this.flag = flag;
      this.documentName = documentName;
    }
  }
}