public class ApprovalValidations {
  public static final String PREAPPROVAL = 'PA';
  public static final String AMENDMENT = 'AM';
  public static final String FORMALAPPROVAL = 'FA';
  public static final String SETTLEMENT = 'ST';
  public static final String MANUAL_SETTLEMENT = 'MST';

  public static final String DOCUMENT_MSG = 'DOC';
  public static final String APPFORM_MSG = 'APP';
  public static final String QUOTING_MSG = 'QUO';
  public static final String ASSETDET_MSG = 'ASD';
  public static final String OTHER_MSG = 'OTH';
  public static final String ERROR_MSG = 'ERR';
  public static final String WARN_MSG = 'WAR';

  private static ApprovalValidations instance;

  //Instance variables
  private Map<String, List<String>> msgMap;

  private Boolean hasDriverLicenceApp1 = false;
  private Boolean hasDriverLicenceApp2 = false;
  private Boolean hasPayslipsApp1 = false;
  private Boolean hasPayslipsApp2 = false;

  private Set<String> cloudDocsList;

  private ApprovalValidations() {
    this.reset();
  }

  private Map<String, List<String>> validateApproval(Id oppId, String typeApp) {
    this.reset();
    if (oppId == null) {
      this.addMessage(ERROR_MSG, 'Opportunity Id not provided');
      return this.msgMap;
    }
    Custom_Opportunity__c opp = this.getOppData(oppId);
    if (opp == null) {
      this.addMessage(ERROR_MSG, 'Opportunity not found');
      return this.msgMap;
    }
    // load cloud docs
    this.loadCloudDocsTypes(oppId);

    Application_Quoting__c quoting = QuotingToolHelper.getApplicationQuoting(
      opp.Id,
      opp.Application__c
    );
    Application_InsuranceQuote__c quote = null;
    if (quoting != null) {
      quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteById(
        quoting.App_Insurance_Quote__c
      );
    }
    Boolean hasBankStatements = PreApprovalValidatorHelper.hasBankStatements(
      opp.Id
    );
    Product__c p = null;
    String productLoanType = null;
    Boolean skipServicingCalculator = false;
    Boolean checkSendToLenderDocs = false;
    Boolean checkBankStatements = false;
    Boolean displaySoleTraderWarning = false;
    String lender = null;
    String quotingCalc = null;
    Boolean isConsumerLoan = false;

    //Docs
    List<String> docs = new List<String>();

    // Driver's licence
    if (!this.hasDriverLicenceApp1) {
      this.addMessage(DOCUMENT_MSG, 'Drivers License - Front');
      this.addMessage(DOCUMENT_MSG, 'Drivers License - Back');
    }

    if (PREAPPROVAL.equals(typeApp)) {
      docs.add('Quoting Calculation (Pre-approval)');
    }

    //Product
    List<Product__c> productList = PreApprovalValidatorHelper.getProductList(
      opp.Id,
      'Finance'
    );

    String ytdType = '';
    String ytdSelfEmpType = '';
    String ytdSelfEmpClass = '';

    // Application_Servicing__c srv = OppApplicationServCalculatorUtils.getApplicationServicing(opp.ApplicationServicing__c);
    Application__c app = opp.Application__c != null
      ? opp.Application__r
      : new Application__c();
    app = app == null ? new Application__c() : app;
    Application_Servicing__c srv = opp.ApplicationServicing__r;

    if (
      (
        srv != null &&
        srv.Is_Self_Employed__c != null &&
        srv.Is_Self_Employed__c
      ) || 
      (
        'Self Employed'.equals(app.Mode_of_Employment_1__c)
      )
    ) {
      ytdType = 'Self-Employed';
    }

    if (
      'Business'.equals(app.Application_Type__c) &&
      'Individual or Sole Trader'.equals(app.Business_Structure__c)
    ) {
      ytdSelfEmpType = 'Sole Trader';
    }

    if (
      quoting != null &&
      String.isNotBlank(quoting.Loan_Product__c) &&
      quoting.Loan_Product__c.contains('Low-Doc')
    ) {
      ytdSelfEmpClass = 'Low-Doc';
    }

    if (productList.isEmpty()) {
      this.addMessage(
        OTHER_MSG,
        'A Finance Product is required, please create it in Products section'
      );
    } else if (productList.size() > 1) {
      this.addMessage(
        OTHER_MSG,
        'There are more than one Finance Product (' +
        productList.size() +
        '), please check and leave just one of them in Products section'
      );
    } else {
      p = productList.get(0);
      lender = p.Lender__c;
      quotingCalc = p.Quoting_Source__c;
      productLoanType = p.Loan_Type__c;
      isConsumerLoan = ('Consumer Loan'.equalsIgnoreCase(productLoanType) ||
      'Consumer Loan'.equalsIgnoreCase(p.Loan_Product__c));

      // Tax documents
      if (
        'Chattel Mortgage-Full-Doc'.equalsIgnoreCase(productLoanType) ||
        'Chattel Mortgage-Full-Doc'.equalsIgnoreCase(p.Loan_Product__c)
      ) {
        docs.add('Tax Returns');
      }
      // Payslip/s
      if (
        'Consumer Loan'.equalsIgnoreCase(productLoanType) ||
        'Re-Finance'.equalsIgnoreCase(productLoanType) ||
        'Consumer Loan'.equalsIgnoreCase(p.Loan_Product__c) ||
        'Refinance'.equalsIgnoreCase(productLoanType)
      ) {
        if (
          !'Self-Employed'.equals(ytdType) ||
          ('Self-Employed'.equals(ytdType) &&
          'Full-Doc'.equals(ytdSelfEmpClass))
        ) {
          if (!this.hasPayslipsApp1) {
            this.addMessage(DOCUMENT_MSG, 'Payslip 1');
            this.addMessage(DOCUMENT_MSG, 'Payslip 2');
          }
        }
      }

      // Lelo             2019-06-06
      // if ('Pepper'.equals(p.Lender__c)) {
      //   docs.add('NCCP requirements');
      // }

      // Servicing Calculation document in cloud documents
      // if ('Wisr'.equals(quotingCalc) || 'BOQ'.equals(quotingCalc)) {
      //   docs.add('Servicing Calculation');
      // }

      // Medicare
      if (
        'Pepper PL'.equals(quotingCalc) ||
        'Now Finance'.equals(quotingCalc) ||
        'Wisr VL'.equals(quotingCalc) ||
        'Wisr'.equals(quotingCalc)
      ) {
        docs.add('Medicare Card');
      }

      // Spouse Information
      if (
        srv != null &&
        srv.Is_Splitting_Expenses__c &&
        ('Macquarie Leasing'.equals(p.Lender__c) ||
        'Pepper'.equals(p.Lender__c) ||
        'Pepper PL'.equals(quotingCalc) ||
        'Yamaha'.equals(p.Lender__c))
      ) {
        if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {
          docs.add('Spouse Information');
        }
      }

      // Skip Servicing calculation
      if (!'Consumer Loan'.equalsIgnoreCase(p.Loan_Product__c)) {
        skipServicingCalculator = true;
      }
      // if(
      //   'Pepper Commercial'.equals(p.Quoting_Source__c) &&
      //   ('Chattel Mortgage-Low-Doc'.equals(p.Loan_Product__c) ||
      //   'Car Lease-Low-Doc'.equals(p.Loan_Product__c))
      // ){
      //   skipServicingCalculator = true;
      // }

      if ('Macquarie Leasing'.equals(p.Lender__c)) {
        List<String> tmpDocs = new List<String>{ 'Servicing Calculation' };
        List<String> macqServDocs = PreApprovalValidatorHelper.validateDocumentsUploaded(
          opp.Id,
          tmpDocs
        );
        if (macqServDocs.isEmpty()) {
          skipServicingCalculator = true;
        }
      }

      if ('Finance One'.equals(quotingCalc)) {
        if (PREAPPROVAL.equals(typeApp)) {
          checkSendToLenderDocs = true;
        }
        if (!'Consumer Loan'.equalsIgnoreCase(p.Loan_Product__c)) {
          docs.add('Statement of Position');
        }
      }
      System.debug(quotingCalc +'|'+app.No_of_People__c);
      if (
        'RateSetter'.equals(quotingCalc) &&
        app.No_of_People__c == 2
      ) {
        this.addMessage(
        OTHER_MSG,
        'Joined applications are not allowed by Plenti'
      );
      }
    }

    //Adding Consent doc type
    docs.add('Consent');
    
    //YTD - Sole Trader / Low Doc
    if (
      'Self-Employed'.equals(ytdType) && 
      (
        'Sole Trader'.equals(ytdSelfEmpType) ||
        'Personal'.equals(app.Application_Type__c)
      )
    ) {
      displaySoleTraderWarning = true;
    }

    if (
      'Business'.equals(app.Application_Type__c) &&
      !'Individual or Sole Trader'.equals(app.Business_Structure__c)
    ) {
      skipServicingCalculator = true;
    }

    // Bank statements
    if (
      'Personal'.equals(app.Type_of_Asset__c) &&
      !'Latitude Personal Loan'.equals(quotingCalc)
    ) {
      checkBankStatements = true;
    }

    // Bank statements validation
    if (checkBankStatements) {
      if (!hasBankStatements) {
        docs.add('Bank Statements');
      }
    }

    // Second job
    if (String.isNotBlank(app.Id)) {
      List<Application_Employment__c> appEmpl = [
        SELECT Id, Type__c, Applicant__c
        FROM Application_Employment__c
        WHERE Application__c = :app.Id AND Type__c = 'Second Job'
      ];
      if (!appEmpl.isEmpty()) {
        for (Application_Employment__c x : appEmpl) {
          if ('1'.equals(x.Applicant__c)) {
            docs.add('Applicant 1 Second Job Payslip');
          } else if ('2'.equals(x.Applicant__c) && app.No_of_People__c == 2) {
            docs.add('Applicant 2 Second Job Payslip');
          }
        }
      }
    }

    // Lelo                 2019-11-20 -> Application type filter added
    if (app.No_of_People__c == 2) {
      if ('Personal'.equals(app.Application_Type__c)) {
        if (!this.hasPayslipsApp1) {
          this.addMessage(DOCUMENT_MSG, 'Applicant 2 - Payslip 1');
          this.addMessage(DOCUMENT_MSG, 'Applicant 2 - Payslip 2');
        }
      }
      // Driver's licence
      if (!this.hasDriverLicenceApp1) {
        this.addMessage(DOCUMENT_MSG, 'Applicant 2 - Drivers License - Front');
        this.addMessage(DOCUMENT_MSG, 'Applicant 2 - Drivers License - Back');
      }

      docs.add('Applicant 2 Consent');
    }

    // Preliminary Assessment Surplus
    if (!skipServicingCalculator) {
      List<String> tmpDocs = PreApprovalValidatorHelper.validatePreliminaryAssessmentSurplus(
        opp
      );
      if (tmpDocs != null && !tmpDocs.isEmpty()) {
        addMessage(OTHER_MSG, tmpDocs);
      }
    }

    // Asset detail validations
    if (!'Personal'.equals(app.Type_of_Asset__c)) {
      if (
        !ApplicationExtraDataHelper.isExistApplicationExtraDataId(
          opp.Application__c,
          'Asset Detail - LTV (Pre-approval)'
        )
      ) {
        addMessage(
          ASSETDET_MSG,
          'An Asset Detail - LTV Calculation should be generated for Pre-approval'
        );
      } else if (
        quoting != null &&
        opp.Application_AssetDetail__c != null &&
        'Car'.equals(opp.Application_AssetDetail__r.Type__c) &&
        opp.Application_AssetDetail__r.LVR__c != null &&
        String.isNotBlank(quoting.LTV__c) &&
        ('ANZ Consumer'.equals(quotingCalc) ||
        'ANZ Commercial'.equals(quotingCalc) ||
        'Macquarie Consumer'.equals(quotingCalc) ||
        'Liberty Drive'.equals(quotingCalc))
      ) {
        String lvr = String.valueOf(
          opp.Application_AssetDetail__r.LVR__c.intValue()
        );
        if (String.isNotBlank(lvr) && !lvr.equals(quoting.LTV__c)) {
          addMessage(
            ASSETDET_MSG,
            'LVR is not identical between Asset Detail - LTV [' +
            lvr +
            '%] and Quoting tool [' +
            quoting.LTV__c +
            '%]'
          );
        }
      }
    }
    if (PREAPPROVAL.equals(typeApp)) {
      if (displaySoleTraderWarning) {
        if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {
          this.addMessage(
            WARN_MSG,
            'Secondary evidence of income will be required for Amendment/Formal approvals. Please obtain from client.'
          );
        }
      }

      //Documents for Lenders
      if (
        checkSendToLenderDocs &&
        !PreApprovalValidatorHelper.hasDocumentsToLender(opp.Id)
      ) {
        this.addMessage(
          DOCUMENT_MSG,
          'Please mark what documents should be sent to the lender in Upload Files'
        );
      }
    }

    // Validate for any active approval process
    if (
      PREAPPROVAL.equals(typeApp) || 
      AMENDMENT.equals(typeApp)    
    ) {
      String currentApprovalProcess = ApprovalTools.checkRecordForApprovalProcess(
        opp.Id
      );
      if (!String.isBlank(currentApprovalProcess)) {
        this.addMessage(
          OTHER_MSG,
          'There is a current Approval Process pending [' +
          currentApprovalProcess +
          ']. Please check out it before continuing.'
        );
      }
    }
    // End Pre-Approval

    // Amendment
    if (AMENDMENT.equals(typeApp)) {
      if (
          !'Pre-Approved'.endsWithIgnoreCase(opp.Status__c) && 
          !'Submitted for Amendment'.endsWithIgnoreCase(opp.Status__c)
      ) {
        addMessage(
          OTHER_MSG, 
          'Opportunity\'s status must be "Pre-Approved" or "Submitted for Amendment"' + 
          ' to submit for an amendment, current status: ' 
          + opp.Status__c
        );
      }
    }
    // End Amendment

    // Asset Details
    Boolean hasAssetDetails = false;
    if (
      (
      'Money3'.equals(quotingCalc) &&
      'Asset Finance'.equals(quoting.Customer_Profile__c)
      ) ||
      'Car'.equalsIgnoreCase(app.Type_of_Asset__c) ||
      'Bike'.equalsIgnoreCase(app.Type_of_Asset__c) ||
      'Boat'.equalsIgnoreCase(app.Type_of_Asset__c) ||
      'Caravan'.equalsIgnoreCase(app.Type_of_Asset__c) ||
      'JetSki'.equalsIgnoreCase(app.Type_of_Asset__c)
    ) {
      hasAssetDetails = true;
    }

    // Formal approval rules
    if (FORMALAPPROVAL.equals(typeApp) || SETTLEMENT.equals(typeApp)) {
      docs.addAll(
        new List<String>{
          'Application Form (Pre-approval)',
          'Quoting Calculation (Formal Approval)',
          'Preliminary Assessment'
        }
      );
      if (p != null) {
        // Second evidence of income
        if (
          ('Re-Finance'.equalsIgnoreCase(productLoanType) ||
          'Refinance'.equalsIgnoreCase(productLoanType)) ||
          (isConsumerLoan && !hasBankStatements)
        ) {
          if (!SOQLSingletonQueries.recs().isBrokerPartnerUser) {
            docs.add('Secondary Evidence of Income');
          }
        }
        //Secondary Evidence of Income for PAYG
        if (
          'Full Time'.equals(app.Mode_of_Employment_1__c) ||
          'Part Time'.equals(app.Mode_of_Employment_1__c) ||
          'Casual'.equals(app.Mode_of_Employment_1__c)
        ) {
          //Check for other incomes
          Map<String, List<Application_Income__c>> d = ApplicationService.getApplicationIncomeMap(
            app.Id
          );
          if (
            !d.isEmpty() &&
            (!isConsumerLoan || (isConsumerLoan && !hasBankStatements)) &&
            !SOQLSingletonQueries.recs().isBrokerPartnerUser
          ) {
            docs.add('Secondary Evidence of Income');
          }
        }
        // Secondary evidence for Commercials
        //YTD - Sole Trader / Low Doc
        if (
          'Self-Employed'.equals(ytdType) &&
          'Sole Trader'.equals(ytdSelfEmpType) &&
          'Low-Doc'.equals(ytdSelfEmpClass) &&
          !SOQLSingletonQueries.recs().isBrokerPartnerUser
        ) {
          docs.add('Secondary Evidence of Income');
        }

        // Partner Evidence of Income
        if (srv != null && srv.Is_Splitting_Expenses__c) {
          docs.add('Partner Evidence of Income');
        }

        // insurance product is created and saved, please create validation in required docs for Insurance Policy/s
        if (PreApprovalValidatorHelper.isInsuranceProducts(opp.Id)) {
          docs.add('Insurance Policies');
        }

        
        //Lelo              2017-06-29
        //Check for a Quote and presentation
        if (quoting != null) {
          if (hasAssetDetails) {
            docs.add('Asset Detail - LTV (Formal Approval)');
            if (QuotingToolHelper.validateInsuranceProduct(quoting.Name)) {
              Boolean checkQuote = true;
              Boolean checkPres = true;
              Boolean checkCusChoice = true;
              if (quoting.Name.startsWith('AFS ')) {
                checkCusChoice = false;
                if (!'Car'.equalsIgnoreCase(app.Type_of_Asset__c)) {
                  checkQuote = false;
                  checkPres = false;
                }
              }
              if ('Money3'.equals(quoting.Name)) {
                if (!'Asset Finance'.equals(quoting.Customer_Profile__c)) {
                  checkPres = false;
                  checkQuote = false;
                }
              }
              if (checkQuote && quoting.App_Insurance_Quote__c == null) {
                addMessage(QUOTING_MSG, 'An Insurance Quote is required.');
              }
              //Presentation sent it
              if (checkPres && quoting.Presentation_Email_Date__c == null) {
                addMessage(
                  QUOTING_MSG,
                  'Customer presentation has not been sent yet.'
                );
              } else if (
                checkCusChoice &&
                checkPres &&
                quoting.Insurance_Customer_Choice__c == null
              ) {
                addMessage(
                  QUOTING_MSG,
                  'Customer has not responded to the insurance presentation yet.'
                );
              } else {
                if (checkPres && quote != null) {
                  if (
                    !InsuranceQuoteUtils.CUSCHOICE_FINISHED.equals(
                      quote.Customer_Choice_Status__c
                    )
                  ) {
                    addMessage(
                      QUOTING_MSG,
                      'Customer has not finished their insurance presentation yet.'
                    );
                  }
                }
              }
            }
          }
          // Refinance validatios
          System.debug(app.Type_of_Asset__c + '|' + quoting.Loan_Type__c);
          if (
            'Car'.equalsIgnoreCase(app.Type_of_Asset__c) &&
            'Refinance'.equals(quoting.Loan_Type__c)
          ) {
            docs.add('PPSR Form completed – Private');
            if (
              !RateSetterCalculatorExtension.LENDER_QUOTING.equals(
                quotingCalc
              ) &&
              String.isNotBlank(opp.Purchase_Type__c) &&
              opp.Purchase_Type__c.contains('Private')
            ) {
              docs.add('Vehicle Inspection/Roadworthy');
            }
          }
        }

        if (hasAssetDetails) {
          //Worksheet Details - Validation
          if (String.isBlank(opp.Purchase_Type__c)) {
            addMessage(ASSETDET_MSG, 'Purchase Type is required');
          } else {
            if (
              opp.Purchase_Type__c.contains('Private')
            ) {
              if ('Private Sale - Verimoto'.equals(opp.Purchase_Type__c)) {
                docs.add('Verimoto Report');
              } else {
                docs.add('Vehicle Inspection/Roadworthy');
                docs.add('Vendor Registration');
                docs.add('Vendor Banking Details');
                docs.add('Vendor ID');
                docs.add('PPSR Form completed – Private');
              }
              if (
                'Re-Finance'.equalsIgnoreCase(productLoanType) ||
                'Refinance'.equalsIgnoreCase(productLoanType)
              ) {
                docs.add('Payout Letter');
              }
            } else if ('Dealer'.equalsIgnoreCase(opp.Purchase_Type__c)) {
              docs.add('Tax Invoice/COS/ Rego Papers');
            } else if (
              'Refinance'.equalsIgnoreCase(opp.Purchase_Type__c) ||
              'Sale and Leaseback'.equalsIgnoreCase(opp.Purchase_Type__c)
            ) {
              docs.add('Payout Letter');
              docs.add('Vendor Registration');
            }
          }
        }
      }
      // Lelo             2022-03-21
      // Validate Personal References
      String quotingName = quoting != null && String.isNotBlank(quoting.Name)
        ? quoting.Name : '';
      if (quotingName.equalsIgnoreCase('Latitude')) {
        if (
          opp.Application__r != null &&
          (
            String.isBlank(opp.Application__r.Personal_Reference_1_Full_Name__c) ||
            String.isBlank(opp.Application__r.Personal_Reference_1_Phone__c) ||
            String.isBlank(opp.Application__r.Personal_Reference_1_Relationship__c) ||
            String.isBlank(opp.Application__r.Personal_Reference_2_Full_Name__c) ||
            String.isBlank(opp.Application__r.Personal_Reference_2_Phone__c) ||
            String.isBlank(opp.Application__r.Personal_Reference_2_Relationship__c)
          )
        ) {
          this.addMessage(
            ERROR_MSG,
            'Two references not living with customer required for loan documents.'
          );
        }
      }
    }
    // End Formal Approval

    // Setlement rules
    if (
      // MANUAL_SETTLEMENT.equals(typeApp) ||
      SETTLEMENT.equals(typeApp)
    ) {
      docs.add('Approval/Assessment Advice');
      if (hasAssetDetails) {
        docs.add('Asset Detail - LTV (Formal Approval)');
      }
    }
    // End Settlement rules

    // Manual Settlement
    if (MANUAL_SETTLEMENT.equals(typeApp)) {
      // if (p != null) {
      //   // Partner Evidence of Income
      //   if (srv != null && srv.Is_Splitting_Expenses__c) {
      //     docs.add('Partner Evidence of Income');
      //   }
      //   // insurance product is created and saved, please create validation in required docs for Insurance Policy/s
      //   if (PreApprovalValidatorHelper.isInsuranceProducts(opp.Id)) {
      //     docs.add('Insurance Policies');
      //   }

      //   if (hasAssetDetails) {
      //     if (
      //       'Car'.equalsIgnoreCase(app.Type_of_Asset__c) &&
      //       'Refinance'.equals(quoting.Loan_Type__c)
      //     ) {
      //       docs.add('PPSR Form completed – Private');
      //       if (
      //         !RateSetterCalculatorExtension.LENDER_QUOTING.equals(
      //           quotingCalc
      //         ) &&
      //         String.isNotBlank(opp.Purchase_Type__c) &&
      //         opp.Purchase_Type__c.contains('Private')
      //       ) {
      //         docs.add('Vehicle Inspection/Roadworthy');
      //       }
      //     }

      //     //Worksheet Details - Validation
      //     if (String.isBlank(opp.Purchase_Type__c)) {
      //       addMessage(ASSETDET_MSG, 'Purchase Type is required');
      //     } else {
      //       if (
      //         opp.Purchase_Type__c.contains('Private')
      //       ) {
      //         if ('Private Sale - Verimoto'.equals(opp.Purchase_Type__c)) {
      //           docs.add('Verimoto Report');
      //         }
      //       } else if ('Dealer'.equalsIgnoreCase(opp.Purchase_Type__c)) {
      //         docs.add('Tax Invoice/COS/ Rego Papers');
      //       }
      //     }
      //   }
      // }

      docs.add('Final Signed Documents');
      if (!'Personal'.equals(app.Type_of_Asset__c)) {
        docs.add('Tax Invoice/COS/ Rego Papers');
      }
      // TODO: autogenerate Broker Invoice document
      // docs.add('Lender Settlement Confirmation');
    }

    // Verify listed documents
    List<String> docsValidated = PreApprovalValidatorHelper.validateDocumentsUploaded(
      opp.Id,
      docs
    );
    this.addMessage(DOCUMENT_MSG, docsValidated);

    if ('Prospa'.equals(lender)) {
      this.reset();
    }

    return this.msgMap;
  }

  public void reset() {
    this.msgMap = new Map<String, List<String>>();
  }

  public void addMessage(String typeMsg, List<String> messages) {
    if (messages != null && !messages.isEmpty()) {
      for (String m : messages) {
        addMessage(typeMsg, m);
      }
    }
  }

  public void addMessage(String typeMsg, String message) {
    List<String> lst = this.msgMap.get(typeMsg);
    if (lst == null) {
      lst = new List<String>();
      this.msgMap.put(typeMsg, lst);
    }
    lst.add(message);
  }

  private Custom_Opportunity__c getOppData(Id oppId) {
    List<Custom_Opportunity__c> d = [
      SELECT
        Id,
        Name,
        Application__c,
        Status__c,
        Insurance_Cover__c,
        Flag_Is_Note_for_Pre_Approval_Created__c,
        Preapproval_Auth_Date__c,
        Purchase_Type__c,
        ApplicationYTD__c,
        ApplicationYTD__r.Type__c,
        ApplicationYTD__r.Self_Employed_Type__c,
        ApplicationYTD__r.Self_Employed_Class__c,
        Application__r.Business_Structure__c,
        Application__r.Application_Type__c,
        Application__r.Type_of_Asset__c,
        Application__r.No_of_People__c,
        Application__r.Email_Address__c,
        Application__r.Email_Address_2__c,
        Application__r.Mode_of_Employment_1__c,
        Application_AssetDetail__r.Type__c,
        Application_AssetDetail__r.LVR__c,
        ApplicationServicing__r.Is_Splitting_Expenses__c,
        ApplicationServicing__r.Is_Self_Employed__c,
        Application__r.Personal_Reference_1_Full_Name__c,
        Application__r.Personal_Reference_1_Phone__c,
        Application__r.Personal_Reference_1_Relationship__c,
        Application__r.Personal_Reference_2_Full_Name__c,
        Application__r.Personal_Reference_2_Phone__c,
        Application__r.Personal_Reference_2_Relationship__c
      FROM Custom_Opportunity__c
      WHERE Id = :oppId
    ];
    return d.isEmpty() ? null : d.get(0);
  }

  private void loadCloudDocsTypes(Id oppId) {
    // reseting variables
    this.cloudDocsList = new Set<String>();
    this.hasDriverLicenceApp1 = false;
    this.hasDriverLicenceApp2 = false;
    this.hasPayslipsApp1 = false;
    this.hasPayslipsApp2 = false;
    // Get documents
    List<AggregateResult> d = [
      SELECT Document_Type__c
      FROM Cloud_Documents__c
      WHERE Custom_Opportunity__c = :oppId
      AND Document_Type__c != null
      GROUP BY Document_Type__c
      ORDER BY Document_Type__c
    ];
    // 
    for (AggregateResult a : d) {
      String dt = (String)a.get('Document_Type__c');
      if (String.isNotBlank(dt)) {
        this.cloudDocsList.add(dt);
        // Check driver license
        if (dt.containsIgnoreCase('Drivers License')) {
          if (dt.startsWithIgnoreCase('Applicant 2')) {
            this.hasDriverLicenceApp2 = true;
          } else {
            this.hasDriverLicenceApp1 = true;
          }
        }
        // Check Payslips
        if (
          dt.containsIgnoreCase('Payslip') && 
          !dt.containsIgnoreCase('Second Job')
        ) {
          if (dt.startsWithIgnoreCase('Applicant 2')) {
            this.hasPayslipsApp2 = true;
          } else {
            this.hasPayslipsApp1 = true;
          }
        }
      }
    }
    System.debug('total cloud docs: ' + this.cloudDocsList.size());
    System.debug('hasDriverLicenceApp1: ' + this.hasDriverLicenceApp1);
    System.debug('hasDriverLicenceApp2: ' + this.hasDriverLicenceApp2);
    System.debug('hasPayslipsApp1: ' + this.hasPayslipsApp1);
    System.debug('hasPayslipsApp2: ' + this.hasPayslipsApp2);
  }

  private static ApprovalValidations getInstance() {
    return new ApprovalValidations();
    // if (instance == null) {
    //   instance = new ApprovalValidations();
    // }
    // return instance;
  }

  public static Map<String, List<String>> validatePreApproval(Id oppId) {
    return validate(oppId, PREAPPROVAL);
  }

  public static Map<String, List<String>> validateAmendment(Id oppId) {
    return validate(oppId, AMENDMENT);
  }

  public static Map<String, List<String>> validateFormalApproval(Id oppId) {
    return validate(oppId, FORMALAPPROVAL);
  }

  public static Map<String, List<String>> validateSettlement(Id oppId) {
    return validate(oppId, SETTLEMENT);
  }

  public static Map<String, List<String>> validateManualSettlement(Id oppId) {
    return validate(oppId, MANUAL_SETTLEMENT);
  }

  private static Map<String, List<String>> validate(Id oppId, String typeVal) {
    ApprovalValidations av = ApprovalValidations.getInstance();
    return av.validateApproval(oppId, typeVal);
  }
}