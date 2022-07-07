public class GenerateAppPdfExtension {
	
    public AppServicingCalculatorDTO servCalc {set;get;} 
    public AssetDetailsDTO assetDetail {set;get;}
    public List<Application_Extra_Data__c> notes {set;get;}
    public Boolean isPreApproval {set;get;} 
    public Integer idxSection {set;get;} 
    private Map<String, List<Application_Employment__c>> prevEmplMap;
    public Custom_Opportunity__c Opp;

    public List<Application_Loan__c> loanList {set;get;}
    private Map < String, List < Application_Income__c >> incomeMap = null;
    // Lelo                 2019-03-14
    public List<Application_Credit_Card__c> creditCards {set;get;}
    public Decimal totalCreditCards {set;get;}
    private Map<String, List<Application_Other_Asset__c>> otherAssetMap;
    public List<Application_Other_Asset__c> otherAssetList {
        set;
        get { return this.otherAssetMap.get(ApplicationService.OTHER_ASSET_TYPE); }
    }
    public List<Application_Other_Asset__c> propertyList {
        set;
        get { return this.otherAssetMap.get(ApplicationService.PROPERTY_ASSET_TYPE); }
    }
    public List<Application_Other_Asset__c> vehicleList {
        set;
        get { return this.otherAssetMap.get(ApplicationService.VEHICLE_ASSET_TYPE); }
    }
    // -
    public Application_Employment__c secondJobApplic1 {set;get;}
    public Application_Employment__c secondJobApplic2 {set;get;}
    public boolean isSecondJobApplic1 {set;get;}
    public boolean isSecondJobApplic2 {set;get;}
    
    public GenerateAppPdfExtension (ApexPages.StandardController controller) {
        secondJobApplic1 = new Application_Employment__c();
        secondJobApplic2 = new Application_Employment__c();
        isSecondJobApplic1 = false;
        isSecondJobApplic2 = false;
        String preapp = System.currentPageReference().getParameters().get('IS_PREAPPROVAL');
        //controller.addFields(new List<String>{'Application__c'});
        Set<String> fields = new Set<String>{
          'OwnerId'
        };
        if (!Test.isRunningTest()) controller.addFields(new List<String>(fields));
        this.Opp = (Custom_Opportunity__c)controller.getRecord ();
        isPreApproval = false;
        idxSection = 1;
        if (preapp != null) {
            isPreApproval = Boolean.valueOf(preapp);
            if (isPreApproval) {
                loadPreApprovalData(Opp.Application__c);
            }
        }
        loadPreviousEmployments();
        loadAssetList();
        this.loanList = ApplicationService.getApplicationLoans(this.Opp.Application__c);
        this.incomeMap = ApplicationService.getApplicationIncomeMap(this.Opp.Application__c);
        this.loadMoreDetails(Opp.Application__c);
    }

    public Double offset {
        get{
            TimeZone tz = UserInfo.getTimeZone();
            //Milliseconds to Day
            return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
        }
    }

    private void loadPreApprovalData(Id appId) {
        
        Application_Extra_Data__c a = ApplicationExtraDataHelper.getApplicationExtraDataId(appId, 'Servicing Calculation');
        if (a != null) {
            servCalc = (AppServicingCalculatorDTO)JSON.deserialize(a.Data__c, AppServicingCalculatorDTO.class);
        }
        
        a = ApplicationExtraDataHelper.getApplicationExtraDataId(appId, 'Asset Detail - LTV (Pre-approval)');
        if (a != null) {
        	assetDetail = (AssetDetailsDTO)JSON.deserialize(a.Data__c, AssetDetailsDTO.class);
            if (assetDetail != null) {
            	//assetDetail.assetStandardFeautersData = GlassServicesHelper.getVariantStandardFactoryOptionsData(assetDetail.variantObj.Code__c);
                assetDetail.assetStandardFeautersData2 = GlassServicesHelper.getVariantOptionsByCodeAndType(assetDetail.variantObj.Code__c, 'Standard');
            }
        }
        
        List<String> params = new List<String>();
        params.add('Notes');
        params.add('Notes (Amendment)');
        params.add('Notes (Formal Approval)');
        notes = ApplicationExtraDataHelper.getApplicationExtraDataList(appId, params);
        
    }

    private void loadAssetList() {
        List<Application_Other_Asset__c> d = ApplicationService.getApplicationOtherAssets(this.Opp.Application__c);
        this.otherAssetMap = new Map<String, List<Application_Other_Asset__c>>();
        for (Application_Other_Asset__c a : d) {
            List<Application_Other_Asset__c> m = this.otherAssetMap.get(a.RecordType.Name);
            if (m == null) {
                m = new List<Application_Other_Asset__c>();
                this.otherAssetMap.put(a.RecordType.Name, m);
            }
            m.add(a);
        }
    }
    
    public Integer getNumberForNotes() {
        return idxSection++;
    }

    public Integer getNumberForTypeAsset() {
        return idxSection++;
    }

    public Integer getNumberForCompanyDetails() {
        return idxSection++;
    }

    public Integer getNumberForApplicantDetails() {
        return idxSection++;
    }

    public Integer getNumberForCurrentResidential() {
        return idxSection++;
    }

    public Integer getNumberForPreviousResidential() {
        return idxSection++;
    }

    public Integer getNumberForEmploymentIncome() {
        return idxSection++;
    }

    public Integer getNumberForAssetDetailLTV() {
        return idxSection++;
    }

    public Integer getNumberForOtherIncome() {
        return idxSection++;
    }

    public Integer getNumberForServicingCalc() {
        return idxSection++;
    }

    public Integer getNumberForFinanceDetailLivingExp() {
        return idxSection++;
    }

    public Integer getNumberForFinanceDetailAssets() {
        return idxSection++;
    }

    public Integer getNumberForFinanceDetailLiabilities() {
        return idxSection++;
    }

    public Integer getNumberForPersonalReferences() {
        return idxSection++;
    }

    public Integer getNumberForDeclaration() {
        return idxSection++;
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
            FROM Application_Employment__c 
            WHERE Application__c = :this.Opp.Application__c
            ];
        System.debug('Total prev employ >> ' + lst.size());
        for (Application_Employment__c e : lst) {
            if('Second Job'.equals(e.Type__c)){
                if('1'.equals(e.Applicant__c)){
                    this.secondJobApplic1 = e;
                    isSecondJobApplic1 = true;
                }else if('2'.equals(e.Applicant__c)){
                    this.secondJobApplic2 = e;
                    isSecondJobApplic2 = true;
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

    //Assets: Properties and Vehicles
    // public List<ApplicationService.Asset> getpropertyList() {
    //     return getAssetList('P');
    // }

    // public List<ApplicationService.Asset> getVehicleList() {
    //     return getAssetList('V');
    // }

    // private List<ApplicationService.Asset> getAssetList(String assetType) {
    //     return assetList.get(assetType);
    // }

    public Boolean getHasAssetProperties() {
        if (this.propertyList != null && !this.propertyList.isEmpty()) {
            return true;
        }
        return false;
    }

    public Boolean getHasAssetVehicles() {
        if (this.vehicleList != null && !this.vehicleList.isEmpty()) {
            return true;
        }
        return false;
    }

    public Boolean getHasOtherLoans() {
        Boolean r = false;
        if (this.loanList != null && !this.loanList.isEmpty()) {
            r = true;
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

    private void loadMoreDetails(Id appId) {
        this.creditCards = ApplicationService.getApplicationCreditCards(appId);
        this.totalCreditCards = 0.0;
        for (Application_Credit_Card__c a : this.creditCards) {
            if(!a.Is_Payout__c){
            	this.totalCreditCards += a.Monthly_Payment__c;
            }
        }
        this.totalCreditCards = this.totalCreditCards.setScale(2);
    }

  public Account getAccountVar() {
    return SOQLSingletonQueries.getPartnerAccount(this.Opp.OwnerId);
  } 
   
}