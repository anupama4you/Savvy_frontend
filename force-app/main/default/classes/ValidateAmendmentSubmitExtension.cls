public class ValidateAmendmentSubmitExtension {
  private static String APROVAL_PROCESS_DEFINITION = ApprovalTools.AMENDMENT_PROCESS_DEFINITION;
  public Custom_Opportunity__c opp;
  public String msgSubmitProcess { get; set; }
  public Boolean isReadeyToSubmit { get; set; }
  public String noteText { get; set; }
  public String noteTextLender { get; set; }
  public String noteCategory { get; set; }
  public List<String> docsValidated { get; set; }
  public List<String> fieldsValidated { get; set; }
  public String lender { get; set; }

  private Application_Quoting__c quoting;

  // Validation results
  private Map<String, List<String>> valResult;

  public ValidateAmendmentSubmitExtension(ApexPages.StandardController c) {
    List<String> fields = new List<String>{
      'Application__c',
      'Status__c',
      'Flag_Is_Note_for_Amendment_Created__c',
      'Application__r.Business_Structure__c',
      'Application_AssetDetail__r.Type__c',
      'Application_AssetDetail__r.LVR__c',
      'Application__r.Application_Type__c',
      'Application__r.Type_of_Asset__c',
      'Application__r.No_of_People__c',
      'ApplicationServicing__c'
    };
    if (!Test.isRunningTest()) c.addFields(fields);
    opp = (Custom_Opportunity__c) c.getRecord();
    isReadeyToSubmit = false;
    fieldsValidated = new List<String>();
    docsValidated = new List<String>();
    //Lelo                      2015-05-14
    this.quoting = quoting = QuotingToolHelper.getApplicationQuoting(
      this.opp.Id,
      this.opp.Application__c
    );
  }

  public void validateApproval() {
    System.debug('New validateApproval method...');
    valResult = ApprovalValidations.validateAmendment(this.opp.Id);
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
    return r;
  }

  public PageReference submit() {
    if (!isValidForm()) {
      return null;
    }

    try {
      //Submit
      submitForApproval();
      //Save Note
      ApplicationExtraDataHelper.addPlainData(
        opp.Application__c,
        'Note',
        'Notes (Amendment)',
        noteText,
        true,
        'Processing'
      );
      ApplicationExtraDataHelper.addPlainData(
        opp.Application__c,
        'Note',
        'Notes (Amendment)',
        noteTextLender,
        true,
        'Lender'
      );
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
    String comments =
      'Submitting request for Amendment.\n\nLender: ' +
      noteTextLender +
      '\nProcessing: ' +
      noteText;
    ApprovalTools.submittForApproval(
      APROVAL_PROCESS_DEFINITION,
      opp.Id,
      comments,
      true
    );
  }
}