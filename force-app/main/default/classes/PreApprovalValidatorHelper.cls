public class PreApprovalValidatorHelper {
  
  public static List<String> validateDocumentsUploaded(
    Id oppId,
    List<String> documentTypes
  ) {
    List<String> r = new List<String>();
    if (oppId != null && documentTypes != null) {
      Set<String> tmpDocTypes = new Set<String>();
      for (String a : documentTypes) {
        tmpDocTypes.add(a);
      }
      System.debug('docs => ' + JSON.serializePretty(tmpDocTypes));
      List<Cloud_Documents__c> docs = [
        SELECT id, Document_Type__c
        FROM Cloud_Documents__c
        WHERE
          Custom_Opportunity__c = :oppId
          AND Document_Type__c IN :tmpDocTypes
      ];
      Set<String> oppDocs = new Set<String>();
      for (Cloud_Documents__c c : docs) {
        oppDocs.add(c.Document_Type__c);
      }
      for (String dt : tmpDocTypes) {
        if (!oppDocs.contains(dt)) {
          //Check policy douments
          if ('Insurance Policies'.equals(dt)) {
            if (!hasAnyPolicyDocument(oppId)) {
              r.add(dt + ' hasn\'t generated/uploaded yet.');
            }
          } else {
            r.add(dt + ' hasn\'t generated/uploaded yet.');
          }
        }
      }
    } else {
      r.add('No documents to be checked');
    }
    return r;
  }

  public static Boolean hasAnyPolicyDocument(Id oppId) {
    List<Cloud_Documents__c> d = [
      SELECT id, Document_Type__c
      FROM Cloud_Documents__c
      WHERE
        Custom_Opportunity__c = :oppId
        AND Document_Type__c LIKE '%Policy Document%'
    ];
    if (!d.isEmpty()) {
      return true;
    }
    return false;
  }

  public static Boolean validateADocumentUploaded(
    Id oppId,
    String documentType
  ) {
    Boolean r = false;
    if (oppId != null && String.isNotBlank(documentType)) {
      List<Cloud_Documents__c> docs = [
        SELECT id, Document_Type__c
        FROM Cloud_Documents__c
        WHERE
          Custom_Opportunity__c = :oppId
          AND Document_Type__c = :documentType
      ];
      r = !docs.isEmpty();
    }
    return r;
  }

  public static List<Product__c> getProductList(Id oppId, String recordType) {
    List<Product__c> r = null;
    if (oppId != null) {
      if (String.isBlank(recordType)) {
        r = [
          SELECT
            id,
            Loan_Purpose__c,
            Lender__c,
            Repayment_Regularity__c,
            Loan_Type__c,
            Loan_Term__c,
            Balloon_Residual_Requested__c,
            Client_Rate__c,
            Payments__c,
            Cost_of_Goods__c,
            Deposit__c,
            Brokerage__c,
            Lender_App_Fee__c,
            Equalisation_Fee_PPSR__c,
            DOF__c,
            Quoting_Source__c,
            Loan_Product__c,
            Loan_Type_Detail__c
          FROM Product__c
          WHERE Opportunity_Name__c = :oppId
        ];
      } else {
        r = [
          SELECT
            id,
            Loan_Purpose__c,
            Lender__c,
            Repayment_Regularity__c,
            Loan_Type__c,
            Loan_Term__c,
            Balloon_Residual_Requested__c,
            Client_Rate__c,
            Payments__c,
            Cost_of_Goods__c,
            Deposit__c,
            Brokerage__c,
            Lender_App_Fee__c,
            Equalisation_Fee_PPSR__c,
            DOF__c,
            Quoting_Source__c,
            Loan_Product__c,
            Loan_Type_Detail__c
          FROM Product__c
          WHERE Opportunity_Name__c = :oppId AND RecordType.Name = :recordType
        ];
      }
    }
    if (r == null) {
      r = new List<Product__c>();
    }
    return r;
  }

  public static List<String> validatePreliminaryAssessmentSurplus(
    Custom_Opportunity__c o
  ) {
    // System.debug('validatePreliminaryAssessmentSurplus... ' + o.Name);
    List<String> r = new List<String>();
    Id appId = o.Application__c;
    Application_Extra_Data__c d = ApplicationExtraDataHelper.getApplicationExtraDataId(
      appId,
      'Servicing Calculation'
    );
    AppServicingCalculatorDTO s = null;
    // Application_Quoting__c quo = null;

    Product__c p = getFinanceProduct(o.Id);

    if (d != null && String.isNotBlank(d.Data__c)) {
      s = (AppServicingCalculatorDTO) JSON.deserialize(d.Data__c, AppServicingCalculatorDTO.class);
      if (s != null && s.isLowDocSelfEmployed == null) {
        s.isLowDocSelfEmployed = false;
      }
    }
    
    if (s != null && p != null && !s.isLowDocSelfEmployed) {
      //Excluding Self Employed
      Decimal surplus = 0.0;
      surplus += NumberUtils.convertToDecimal(s.netMonthlyIncome, false);
      surplus -= NumberUtils.convertToDecimal(s.rentMtgePaid, false);
      surplus -= NumberUtils.convertToDecimal(s.livingExpenses, false);
      surplus -= NumberUtils.convertToDecimal(s.totLiabilities, false);
      surplus -= NumberUtils.convertToDecimal(s.otherDebts, false);
      surplus -= (p.Payments__c > 0.00) ? p.Payments__c : 0.00;

      if (surplus < 0) {
        r.add(
          'Preliminary Assessment document can not proceed due to Monthly Surplus does not exist. Please adjust Servicing and/or Quoting calculation. Current value calculated: (' +
          surplus.format() + ')'
        );
      }
      System.debug('Calculating Surplus... ' + surplus.format() + ' >> ' + r.size());
    }
    return r;
  }

  public static Boolean isInsuranceProducts(Id oppId) {
    List<Product__c> d = getProductList(oppId, 'Insurance');
    return !d.isEmpty();
  }

  public static Boolean isESignLivePackageCompleted(Id oppId) {
    Boolean r = false;
    List<ESL__Package__c> p = [
      SELECT Name
      FROM ESL__Package__c
      WHERE
        ESL__Status__c = 'Completed'
        AND eSignLive_Opportunity_Lookup__c = :oppId
    ];
    if (p != null && !p.isEmpty()) {
      r = true;
    }
    return r;
  }

  public static Boolean hasSavvyConsentUploaded(Custom_Opportunity__c opp) {
    List<Cloud_Documents__c> savvyConsentDocs = [
      SELECT Id
      FROM Cloud_Documents__c
      WHERE
        Custom_Opportunity__c = :opp.id
        AND Document_Type__c = 'Consent'
    ];

    if (!savvyConsentDocs.isEmpty()) {
      if (savvyConsentDocs.size() < opp.Application__r.No_of_People__c) {
        ApexPages.addMessage(
          new ApexPages.Message(
            ApexPages.Severity.WARNING,
            'There are two applicants in this deal, but there is only one Consent in Cloud Documents section. Please be sure that all applicants have signed a consent before proceeding with a credit file assessment.'
          )
        );
      }
      return true;
    }
    return false;
  }

  public static Boolean hasDocumentsToLender(Id oppId) {
    List<Cloud_Documents__c> d = [
      SELECT Id
      FROM Cloud_Documents__c
      WHERE Custom_Opportunity__c = :oppId AND Send_To_Lender__c = TRUE
    ];
    return !d.isEmpty();
  }

  public static Boolean hasBankStatements(Id oppId) {
    List<Cloud_Documents__c> d = [
      SELECT Id
      FROM Cloud_Documents__c
      WHERE
        Custom_Opportunity__c = :oppId
        AND Document_Type__c LIKE '%Bank Statements'
    ];
    return !d.isEmpty();
  }

  public static Product__c getFinanceProduct(Id oppId) {
    List<Product__c> d = [
      SELECT Id, Payments__c
      FROM Product__c
      WHERE Opportunity_Name__c = :oppId AND RecordType.name = 'Finance'
      ORDER BY LastModifiedDate DESC
    ];
    return !d.isEmpty() ? d.get(0) : null;
  }
}