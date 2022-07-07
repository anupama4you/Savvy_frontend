public class ValidateFormalApprovalSubmitExtencion {
  private static String APROVAL_PROCESS_DEFINITION = ApprovalTools.FORMALAPPROVAL_PROCESS_DEFINITION;
  public Custom_Opportunity__c opp;
  public List<String> docsValidated { get; set; }
  public List<String> fieldsValidated { get; set; }
  public String msgInsurance { get; set; }
  public String msgSubmitProcess { get; set; }
  public String noteText { get; set; }
  public String noteTextLender { get; set; }
  //public String noteTextSettlement {set;get;}
  public String noteCategory { get; set; }
  public Boolean isReadeyToSubmit { get; set; }

  //Lelo              2017-06-30
  private static final String MSG_QUOTING = 'QT';
  public String lender { get; set; }
  private Map<String, List<String>> messagesMap;
  //-

  // Validation results
  private Map<String, List<String>> valResult;

  public ValidateFormalApprovalSubmitExtencion(ApexPages.StandardController c) {
    List<String> fields = new List<String>{
      'Application__c',
      'Status__c',
      'Insurance_Cover__c',
      'Purchase_Type__c',
      'Flag_Is_Note_for_Formal_Approval_Created__c',
      'Application__r.Business_Structure__c',
      'Application_AssetDetail__r.Type__c',
      'Application_AssetDetail__r.LVR__c',
      'Application__r.Application_Type__c',
      'Application__r.Type_of_Asset__c',
      'Application__r.No_of_People__c',
      'VD_Status_Process__c',
      'VD_Owner__r.Email',
      'VD_Owner__c',
      'Owner_Name__c',
      'ApplicationServicing__c'
    };
    if (!Test.isRunningTest()) c.addFields(fields);
    opp = (Custom_Opportunity__c) c.getRecord();
    fieldsValidated = new List<String>();
    isReadeyToSubmit = false;

    messagesMap = new Map<String, List<String>>();
    //-
  }

  public void validateApproval() {
    System.debug('New validateApproval method...');
    valResult = ApprovalValidations.validateFormalApproval(this.opp.Id);
    isReadeyToSubmit = valResult.isEmpty();
    if (!valResult.isEmpty()) {
      docsValidated = new List<String>();
      for (String k : valResult.keySet()) {
        if (!ApprovalValidations.WARN_MSG.equals(k)) {
          for (String m : valResult.get(k)) {
            docsValidated.add(m);
          }
        }
      }
      isReadeyToSubmit = docsValidated.isEmpty();
    }
  }

  public List<String> getWarningMessages() {
    return (this.valResult != null &&
      this.valResult.containsKey(ApprovalValidations.WARN_MSG))
      ? this.valResult.get(ApprovalValidations.WARN_MSG)
      : new List<String>();
  }

  private Boolean isValidForm() {
    Boolean r = true;
    if (Opp.Application__c == null) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please save an Application form before submitting.'
        )
      );
      r = false;
    }
    if (String.isBlank(noteTextLender)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please fill a note for Lender before submitting.'
        )
      );
      r = false;
    }
    if (String.isBlank(noteText)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please fill a note for processing team before submitting.'
        )
      );
      r = false;
    }
    //if (String.isBlank(noteTextSettlement)) {
    if (String.isBlank(this.opp.Notes_to_Settlement_Officer__c)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please fill a note for settlement team before submitting.'
        )
      );
      r = false;
    }
    return r;
  }

  public PageReference submit() {
    if (!isValidForm()) {
      return null;
    }

    try {
      //Submit
      submitForFormalApproval();
      //Save Note
      ApplicationExtraDataHelper.addPlainData(
        opp.Application__c,
        'Note',
        'Notes (Formal Approval)',
        noteText,
        true,
        'Processing'
      );
      ApplicationExtraDataHelper.addPlainData(
        opp.Application__c,
        'Note',
        'Notes (Formal Approval)',
        noteTextLender,
        true,
        'Lender'
      );
      //ApplicationExtraDataHelper.addPlainData(opp.Application__c, 'Note', 'Notes (Formal Approval)', noteTextSettlement, true, 'Settlement');
      ApplicationExtraDataHelper.addPlainData(
        opp.Application__c,
        'Note',
        'Notes (Formal Approval)',
        opp.Notes_to_Settlement_Officer__c,
        true,
        'Settlement'
      );
      generateDocuments();
      return new PageReference('/' + opp.Id);
    } catch (Exception e) {
      String err = e.getMessage();
      if (e.getMessage().contains('NO_APPLICABLE_PROCESS')) {
        err = 'No applicable approval process was found.';
      } else if (e.getMessage().contains('ALREADY_IN_PROCESS')) {
        err = 'This record is currently in an approval process. A record can be in only one approval process at a time';
      }
      ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            err
          )
        );
      System.debug('Error: ' + e.getMessage());
    }
    return null;
  }

  /**
   * This method will submit the opportunity automatically
   **/
  public void submitForFormalApproval() {
    String comments =
      'Submitting request for Formal Approval.\n\nLender: ' +
      noteTextLender +
      '\nProcessing: ' +
      noteText +
      '\nSettlement: ' +
      this.opp.Notes_to_Settlement_Officer__c;
    if (!this.opp.Notes_to_Settlement_Officer__c.endsWith('===\n')) {
      this.opp.Notes_to_Settlement_Officer__c += '\n===========================================\n';
    }
    update this.opp;
    ApprovalTools.submittForApproval(
      APROVAL_PROCESS_DEFINITION,
      opp.Id,
      comments,
      true
    );

    // VD Notification
    this.checkVDNotification();
  }

  private void generateDocuments() {
    try {
      System.debug('Generating documents...');
      CloudDocsHelper.deleteCloudDocument(opp.Id, 'DOF Invoice');
      CloudDocGeneratorBatch.createBatch(
        Opp.Id,
        CloudDocGeneratorBatch.DOF_INVOICE_DOC,
        0
      );
    } catch (Exception e) {
      System.debug('DOF_INVOICE_DOC failed >> ' + e);
    }
  }

  public List<String> getQuotingMessages() {
    return messagesMap.get(MSG_QUOTING);
  }

  public Boolean getIsQuotingMessages() {
    return messagesMap.containsKey(MSG_QUOTING);
  }

  public void checkVDNotification() {
    if (
      'Car'.equals(opp.Application_AssetDetail__r.Type__c) &&
      opp.VD_Owner__c != null &&
      String.isNotBlank(opp.VD_Status_Process__c) &&
      String.isNotBlank(opp.Purchase_Type__c) &&
      !'Dealer - Vehicles Direct'.equals(opp.Purchase_Type__c) &&
      !opp.VD_Status_Process__c.contains('Send back to Sales Consultant')
    ) {
      // Send notification to Neil
      List<String> vdEmails = new List<String>{ opp.VD_Owner__r.Email };
      EmailSender.sendEmailToVDFormalApproval(vdEmails, opp);
    }
  }
}