public with sharing class ApprovalSummaryTmplExtension {
    
    private final Custom_Opportunity__c o;
    private Id PROCESS_PREAPPROVAL_ID = null;
    private Id PROCESS_AMENDMENT_ID = null;
    private Id PROCESS_FORMAL_APPROVAL_ID = null;
    private Id CURRENT_PROCESS = null;
    public Boolean isActiveProcess {set;get;}
    private Application_Quoting__c quoting = null;
    public List<Application_Extra_Data__c> notes {set;get;}
    private Map<String, List<Application_Employment__c>> prevEmplMap;
    private Map<String, List<ApplicationService.Asset>> assetList = new Map<string, List<ApplicationService.Asset>>();
    public List<Application_Loan__c> loanList {set;get;}
    private Map < String, List< Application_Income__c >> incomeMap = null;
    private Map < String, List< YTD_Income__c >> YTDincomeMap = null;
    
    public Application_Employment__c secondJobApplic1 {set;get;}
    public Application_Employment__c secondJobApplic2 {set;get;}
    public boolean isSecondJobApplic1 {set;get;}
    public boolean isSecondJobApplic2 {set;get;}
    public boolean hasYTDIncome {set;get;}
    // Lelo                 2019-03-15
    public List<Application_Credit_Card__c> creditCardsList {set;get;}
    private Map<String, List<PersonalAssetDTO>> otherAssetMap;
    public Decimal otherAssetsTotal {
        set;
        get { 
            Decimal r = 0.0;
            for (PersonalAssetDTO a: this.otherAssetMap.get(ApplicationService.OTHER_ASSET_TYPE)) {
                r += (Decimal)a.data.get('Value__c');
            }
            return r; 
        }
    }
    //public List<PersonalAssetDTO> propertyList {
    //    set;
    //    get { return this.otherAssetMap.get(ApplicationService.PROPERTY_ASSET_TYPE); }
    //}
    //public List<PersonalAssetDTO> vehicleList {
    //    set;
    //    get { return this.otherAssetMap.get(ApplicationService.VEHICLE_ASSET_TYPE); }
    //}
    //-
    
    public ApprovalSummaryTmplExtension(ApexPages.StandardController ctrl) {
        secondJobApplic1 = new Application_Employment__c();
        secondJobApplic2 = new Application_Employment__c();
        isSecondJobApplic1 = false;
        isSecondJobApplic2 = false;
        this.o = (Custom_Opportunity__c)ctrl.getRecord();
        
        //isActiveProcess = Approval.isLocked(o.Id);
        isActiveProcess = false;
        
        //if (isActiveProcess) {
        //Proces definition
        List<ProcessDefinition> tmpDef = [SELECT Id, Name FROM ProcessDefinition WHERE State = 'Active'];
        for(ProcessDefinition n : tmpDef) {
            if (ApprovalTools.PREAPPROVAL_PROCESS_DEFINITION.equals(n.Name)) {
                PROCESS_PREAPPROVAL_ID = n.Id;
                System.debug('PROCESS_PREAPPROVAL_ID >> ' + PROCESS_PREAPPROVAL_ID);
            } else if (ApprovalTools.AMENDMENT_PROCESS_DEFINITION.equals(n.Name)) {
                PROCESS_AMENDMENT_ID = n.Id;
                System.debug('PROCESS_AMENDMENT_ID >> ' + PROCESS_AMENDMENT_ID);
            } else if (ApprovalTools.FORMALAPPROVAL_PROCESS_DEFINITION.equals(n.Name)) {
                PROCESS_FORMAL_APPROVAL_ID = n.Id;
                System.debug('STEP_FORMAL_APPROVAL >> ' + PROCESS_FORMAL_APPROVAL_ID);
            }
        }
        
        List<ProcessInstance> pi = [SELECT ProcessDefinitionID FROM ProcessInstance 
                                    WHERE TargetObjectId = :o.Id AND Status = 'Pending'];
        if (!pi.isEmpty()) {
            CURRENT_PROCESS = pi.get(0).ProcessDefinitionID;
            isActiveProcess = true;
        }
        
        //}
        findLastApplicationNotes();
        loadPreviousEmployments();
        loadAssetList();
        this.loanList = ApplicationService.getApplicationLoans(this.o.Application__c);
        this.incomeMap = ApplicationService.getApplicationIncomeMap(this.o.Application__c);
        this.creditCardsList = ApplicationService.getApplicationCreditCards(this.o.Application__c);
        this.YTDincomeMap = getYTDIncomeMap(this.o.Id);
        hasYTDIncome = !YTDincomeMap.isEmpty(); 
    }
    
    public AssetDetailsDTO getAssetDetail() {
        AssetDetailsDTO r = null;
        String typeData = 'Asset Detail - LTV (Pre-approval)';
        if (CURRENT_PROCESS == PROCESS_FORMAL_APPROVAL_ID) {
            typeData = 'Asset Detail - LTV (Formal Approval)';
        } else if (CURRENT_PROCESS == PROCESS_AMENDMENT_ID) {
            typeData = 'Asset Detail - LTV (Amendment)';
        }
        System.debug('typeData >> ' + typeData + ' appId >> ' + o.Application__c);
        Application_Extra_Data__c a = ApplicationExtraDataHelper.getApplicationExtraDataId(o.Application__c, typeData);
        if (a == null) {
            System.debug('asset not found >> ' + typeData);
            if (CURRENT_PROCESS != PROCESS_PREAPPROVAL_ID) {
                typeData = 'Asset Detail - LTV (Pre-approval)';
                a = ApplicationExtraDataHelper.getApplicationExtraDataId(o.Application__c, typeData);
            }
        }
        
        if (a != null) {
            r = (AssetDetailsDTO)JSON.deserialize(a.Data__c, AssetDetailsDTO.class);
            if (r != null) {
                //assetDetail.assetStandardFeautersData = GlassServicesHelper.getVariantStandardFactoryOptionsData(assetDetail.variantObj.Code__c);
                r.assetStandardFeautersData2 = GlassServicesHelper.getVariantOptionsByCodeAndType(r.variantObj.Code__c, 'Standard');
            }
            System.debug('Asset >> ' + r.assetType);
        }
        
        if (r == null) {
            r = new AssetDetailsDTO();
            System.debug('creating a default asset');
        }
        return r;
    }
    
    public Application_Quoting__c getQuoting() {
        Application_Quoting__c r = null;
        String typeData = 'Quoting Calculation';
        if (CURRENT_PROCESS == PROCESS_FORMAL_APPROVAL_ID) {
            typeData = 'Quoting Calculation (Formal Approval)';
        } else if (CURRENT_PROCESS == PROCESS_AMENDMENT_ID) {
            typeData = 'Quoting Calculation (Amendment)';
        }
        Application_Extra_Data__c a = ApplicationExtraDataHelper.getApplicationExtraDataId(o.Application__c, typeData);
        if (a != null) {
            r = (Application_Quoting__c) JSON.deserialize(a.Data__c, Application_Quoting__c.class);
        }
        return r;
    }
    
    private void findLastApplicationNotes() {
        
        String[] typeData = new String[]{'Notes','Notes (Amendment)','Notes (Formal Approval)'};
            
            notes = [SELECT Data__c, Type_of_Data__c, LastModifiedDate, Category__c FROM Application_Extra_Data__c WHERE Application__c IN (
                SELECT Application__c FROM Custom_Opportunity__c WHERE ID = :o.Id
            ) AND Type_of_Data__c IN :typeData ORDER BY LastModifiedDate DESC, Category__c];
    }
    
    private void loadPreviousEmployments() {
        prevEmplMap = new Map<String, List<Application_Employment__c>>();
        List<Application_Employment__c> lst = [
            SELECT Name, Applicant__c, Application__c, Contact_Name__c, Country__c, Employer_Name__c,
            Employment_Type__c, Finish_Date__c, Occupation__c, Start_Date__c,
            Work_Address__c, Phone__c, Income__c, Frequency__c, Monthly_Income__c, 
            Unit_Number__c, Street_Number__c, Street_Type__c, Employer_ABN_1__c, 
            Suburb__c, Postcode__c, State__c, Address_Line_1__c, Overseas_State__c,
            Overseas_City__c, Address_Line_2__c, Type__c 
            FROM Application_Employment__c WHERE Application__c = :o.Application__c
        ];
        System.debug('Total prev employ >> ' + lst.size());
        for (Application_Employment__c e : lst) {
            if('Second Job'.equals(e.Type__c)){
                if('1'.equals(e.Applicant__c)){
                    this.secondJobApplic1 = e;
                    this.isSecondJobApplic1 = true;
                } else if('2'.equals(e.Applicant__c)){
                    this.secondJobApplic2 = e;
                    this.isSecondJobApplic2 = true;
                }
            }else{
                List<Application_Employment__c> empList = prevEmplMap.get(e.Applicant__c);
                if (empList == null) {
                    empList = new List<Application_Employment__c>();
                    prevEmplMap.put(e.Applicant__c, empList);
                }
                empList.add(e);
            }
        }
        System.debug('Total map prev employ >> ' + prevEmplMap.size());
    }
    
    private AppEmploymentList getPrevEmployApp(String applicant) {
        AppEmploymentList r = new AppEmploymentList();
        List<Application_Employment__c> empList = prevEmplMap.get(applicant);
        if (empList != null) {
            r.applicant = applicant;
            r.data = empList;
        }
        System.debug('Returning applicant ' + applicant + ' >> ' + r.data.size());
        return r;
    }
    
    public AppEmploymentList getPrevEmployApp1() {
        return getPrevEmployApp('1');
    }
    
    public AppEmploymentList getPrevEmployApp2() {
        return getPrevEmployApp('2');
    }
    
    private void loadAssetList() {
        List<Application_Other_Asset__c> d = ApplicationService.getApplicationOtherAssets(this.o.Application__c);
        this.otherAssetMap = new Map<String, List<PersonalAssetDTO>>();
        this.otherAssetMap.put(ApplicationService.PROPERTY_ASSET_TYPE, new List<PersonalAssetDTO>());
        this.otherAssetMap.put(ApplicationService.VEHICLE_ASSET_TYPE, new List<PersonalAssetDTO>());
        this.otherAssetMap.put(ApplicationService.OTHER_ASSET_TYPE, new List<PersonalAssetDTO>());
        for (Application_Other_Asset__c a : d) {
            List<PersonalAssetDTO> m = this.otherAssetMap.get(a.RecordType.Name);
            if (m != null) {
                PersonalAssetDTO oa = new PersonalAssetDTO(a, m.size()+1);
                m.add(oa);
            }
        }
    }
    
    public List<PersonalAssetDTO> getAssetLoanList() {
        List<PersonalAssetDTO> r = new List<PersonalAssetDTO>();
        if (this.getPropertyList() != null) {
            for (PersonalAssetDTO a : this.getPropertyList()) {
                if ('Y'.equals(a.data.get('Has_Loan__c'))) {
                    r.add(a);
                }
            }
        }
        if (this.getVehicleList() != null) {
            for (PersonalAssetDTO a : this.getVehicleList()) {
                if ('Y'.equals(a.data.get('Has_Loan__c'))) {
                    r.add(a);
                }
            }
        }
        return r;
    }
    
    public List<Application_Income__c> getIncomesApp1() {
        return this.getIncomesApp('1');
    }
    
    public List<Application_Income__c> getIncomesApp2() {
        return this.getIncomesApp('2');
    }
    
    private List<Application_Income__c> getIncomesApp(String applicant) {
        List<Application_Income__c> r = null;
        if (incomeMap.containsKey(applicant)) {
            r = incomeMap.get(applicant);
        }
        return r;
    }
    
    //Assets: Properties and Vehicles
    public List<PersonalAssetDTO> getPropertyList() {
        return this.otherAssetMap.get(ApplicationService.PROPERTY_ASSET_TYPE);
    }
    
    public List<PersonalAssetDTO> getVehicleList() {
        return this.otherAssetMap.get(ApplicationService.VEHICLE_ASSET_TYPE);
    }
    
    public Map < String, List < YTD_Income__c >> getYTDIncomeMap(Id oppId) {
        Map < String, List < YTD_Income__c >> YTDincomeMap = new Map <String,List <YTD_Income__c>>();
        if (oppId != null) {
            List < YTD_Income__c > lst = [SELECT Applicant_Type__c, Type__c, Start_Date__c, End_Date__c, Net_Annual_Income__c,
                                          Gross_YTD_Income__c, Gross_Net_Income__c, Difference__c, 
                                          Net_Income__c, Net_Last_Income__c, Net_YTD_Salary_Monthly__c, Pay_Period_Monthly__c, 
                                          Annualised_Income__c, Net_Monthly_Income__c, Gross_Annual_Income__c, Net_Profit_Calc__c,
                                          Self_Employed_Type__c, Self_Employed_Class__c, Trustees_Number__c, Net_Profit_Calc_2__c
                                          FROM YTD_Income__c WHERE Opportunity__c =: oppId
                                         ];
            
            for (YTD_Income__c ytd: lst) {
                if (String.isNotBlank(ytd.Applicant_Type__c)) {
                    List<YTD_Income__c> income = YTDincomeMap.get(ytd.Applicant_Type__c);
                    if (income == null) {
                        income = new List < YTD_Income__c > ();
                        YTDincomeMap.put(ytd.Applicant_Type__c, income);
                    }
                    income.add(ytd);
                }
            }
        }
        return YTDincomeMap;
    }
    
    private List<YTD_Income__c> getYTDincomesApp(String applicant) {
        List<YTD_Income__c> r = null;
        if (YTDincomeMap.containsKey(applicant)) {
            r = YTDincomeMap.get(applicant);
        }
        return r;
    }
    
    public List<YTD_Income__c> getYTDincomesApp1() {
        return this.getYTDincomesApp('Applicant 1');
    }
    
    public List<YTD_Income__c> getYTDincomesApp2() {
        return this.getYTDincomesApp('Applicant 2');
    }
    
    public List<YTD_Income__c> getYTDincomesApp1SecondJob() {
        return this.getYTDincomesApp('Applicant 1 Second Job');
    }
    
    public List<YTD_Income__c> getYTDincomesApp2SecondJob() {
        return this.getYTDincomesApp('Applicant 2 Second Job');
    }
}