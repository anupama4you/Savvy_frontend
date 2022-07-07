public class ValidatePreApprovalSubmitExtension {
  public static String APROVAL_PROCESS_DEFINITION = ApprovalTools.PREAPPROVAL_PROCESS_DEFINITION;

  public Custom_Opportunity__c opp;
  public List<String> docsValidated { get; set; }
  public List<String> fieldsValidated { get; set; }
  public String msgSubmitProcess { get; set; }
  public Boolean isReadeyToSubmit { get; set; }
  public String noteText { get; set; }
  public String noteTextLender { get; set; }
  public Boolean displaySoleTraderWarning { get; set; }
  public String lender { get; set; }
  public Boolean preApprovalAuth { get; set; }

  // Validation results
  private Map<String, List<String>> valResult;

  public ValidatePreApprovalSubmitExtension(ApexPages.StandardController c) {
    List<String> fields = new List<String>{
      'Application__c',
      'Status__c',
      'Insurance_Cover__c',
      'Flag_Is_Note_for_Pre_Approval_Created__c',
      'Application__r.Business_Structure__c',
      'Application_AssetDetail__r.Type__c',
      'Application_AssetDetail__r.LVR__c',
      'Application__r.Application_Type__c',
      'Application__r.Type_of_Asset__c',
      'Application__r.No_of_People__c',
      'Preapproval_Auth_Date__c',
      'Application__r.Email_Address__c',
      'Application__r.Email_Address_2__c',
      'ApplicationServicing__r.Is_Splitting_Expenses__c'
    };
    if (!Test.isRunningTest()) c.addFields(fields);
    this.opp = (Custom_Opportunity__c) c.getRecord();
    isReadeyToSubmit = false;
    fieldsValidated = new List<String>();
    this.displaySoleTraderWarning = false;
    docsValidated = new List<String>();

    String paramType = System.currentPageReference()
      .getParameters()
      .get('TYPE');
    preApprovalAuth = false;
    if ('AUTH'.equals(paramType)) {
      preApprovalAuth = true;
    }
  }

  public void validateApproval() {
    System.debug('New validateApproval method...');
    valResult = ApprovalValidations.validatePreApproval(this.opp.Id);
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
    if (this.opp.Application__c == null) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please save an Application form before submitting.'
        )
      );
      r = false;
    }
    if (this.preApprovalAuth) {
      if (String.isBlank(noteText)) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.ERROR,
            'Please fill a note for authorising team before submitting.'
          )
        );
        r = false;
      }
    } else {
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
    }
    return r;
  }

  public PageReference submit() {
    if (!isValidForm()) {
      return null;
    }

    //1. Generare the preliminary assessment
    // generatePreliminaryAssessmet();
    ApprovalTools.generatePreliminaryAssessmet(opp.Id);

    //2. Move Opportunity status
    opp.All_Documents_Attached__c = true;
    //opp.Status__c = 'Pre-Approved';
    //opp.Last_Submission_Date__c = System.now();
    update opp;

    try {
      //Submit
      submitForApproval();
      //Save Note
      if (!preApprovalAuth) {
        ApplicationExtraDataHelper.addPlainData(
          opp.Application__c,
          'Note',
          'Notes',
          noteText,
          true,
          'Processing'
        );
        ApplicationExtraDataHelper.addPlainData(
          opp.Application__c,
          'Note',
          'Notes',
          noteTextLender,
          true,
          'Lender'
        );
        ApprovalTools.generateApplicationFormDocument(opp.Id);
      }
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
  public void submitForApproval() {
    String comments = 'Submitting request for Pre-Approval';
    String approvalProcessName = APROVAL_PROCESS_DEFINITION;
    if (preApprovalAuth) {
      approvalProcessName = ApprovalTools.PREAPPROVAL_AUTHPROCESS_DEFINITION;
      comments += ' Authorisation';
      comments += '.\n\nConsultant comments: ' + noteText;
    } else {
      comments +=
        '.\n\nLender: ' +
        noteTextLender +
        '\nProcessing: ' +
        noteText;
    }
    ApprovalTools.submittForApproval(
      approvalProcessName,
      opp.Id,
      comments,
      false
    );
  }
}