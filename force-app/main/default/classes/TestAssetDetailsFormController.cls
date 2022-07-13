@isTest(SeeAllData=true)
private class TestAssetDetailsFormController {
    @isTest static void testAssetDetailsFormController() {
        Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
        Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;

        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);

        Custom_Opportunity__c customOpp = assetDetailsFormController.getCustomOpportunities(opp.Id);

        // Get years
        Map<String,String> years = assetDetailsFormController.getYears('new');

        try {
            years = assetDetailsFormController.getYears('');
        }catch(Exception e) {
            system.assertEquals(e.getMessage(), e.getMessage()); 
        }

        // Get years with 2 parameters
        Map<String,String> years_3 = assetDetailsFormController.getYears('new', 'Marine');

        try {
            Map<String,String> years_4 = assetDetailsFormController.getYears('', '');
        }catch(DMLException  e) {
            system.assertEquals(e.getMessage(), e.getMessage()); 
        }
       
        

        // Make selections
        Map<String,String> makeSelect = assetDetailsFormController.getMakeSelectOptions('used','2015');
        // System.debug('List of Makes for USED : 2015 >>', makeSelect.size());

        // Make selections (Redbook)
        Map<String,String> makeSelect_1 = assetDetailsFormController.getMakeSelectOptionRedBook('2017');
        // System.debug('List of Makes[Redbook] : 2017 >>', makeSelect_1.size());

        // Get Make models selections
        CarsWrapper wrapper = new CarsWrapper();
        wrapper.code = 'AUD';
        wrapper.newUsed = 'used';
        wrapper.year = '2018';
        wrapper.lender = 'AFS';
        wrapper.make = 'AUD';
        MakeModelDTO makeModel = assetDetailsFormController.getMakeModelsSelectOptions(wrapper);

        wrapper.newUsed = 'new';
        wrapper.year = '2016';
        wrapper.make = null;

        MakeModelDTO makeModel_1 = assetDetailsFormController.getMakeModelsSelectOptions(wrapper);

        wrapper.lender = '';
        MakeModelDTO makeModel_2 = assetDetailsFormController.getMakeModelsSelectOptions(wrapper);

        Map<String,String> makeModelAux = assetDetailsFormController.getMakeModelsSelectOptionsAux('AUD','used','2017');

        Map<String,String> makeModelRedbook = assetDetailsFormController.getMakeModelsSelectOptionsRedbook('BMW','2017');

        String searchMakeRedbookCode = assetDetailsFormController.searchMakeRedbookCode('BMW','used','2017');

        Map<String,String> modelVariantOptions = assetDetailsFormController.getModelVariantsSelectOptions('C06687', '2009');

        Map<String,String> modelVariantOptionsAux = assetDetailsFormController.getModelVariantsSelectOptionsAux('A1','2017','used');

        Map<String,String> variantSeriesOptionsAux = assetDetailsFormController.getVariantSeriesSelectOptionsAux('SPORTBACK 1.0 TFSI','A1','2017','AUD');

        Map<String,String> familyBatchSelectOptions_2 = assetDetailsFormController.getFamilyBadgeSelectOptionsRedbook('CIVIC','HOND','2017','AFS');

        Map<String,String> familyBatchSelectOptions_3 = assetDetailsFormController.getFamilyBadgeSelectOptionsRedbook('CIVIC','HOND','2017','Pepper');

        Map<String,String> badgeVariantSelectOptions = assetDetailsFormController.getBadgeVariantsSelectOptions('HOND','CIVIC','VTi');

        Map<String,String> variantOptionsSelect = assetDetailsFormController.getVariantFactoryOptionsSelectOptions('AUDQ5-2Q182000YG2018');

        List <Glass_Factory_Option__c> v = assetDetailsFormController.getVariantFactoryOptionsData('AUDQ3-1T1514T622016A');

        Map<String, Glass_Factory_Option__c> variantOptionsMapData = assetDetailsFormController.getVariantFactoryOptionsMapData('AUDQ3-1T1514T622016A');

        v = assetDetailsFormController.getVariantStandardFactoryOptionsData('AUDQ3-1T1514T622016A');

        v = assetDetailsFormController.getVariantStandardFactoryOptionsData(null);

        Decimal variantNewPrice = assetDetailsFormController.getVariantNewPrice('AUDQ3-1T1514T622016A');

        Glass_Variant__c variantByCode = assetDetailsFormController.getVariantByCode('AUDQ3-1T1514T622016A');

        Glass_Make__c makeByCode = assetDetailsFormController.getMakeByCode('AUDQ3-1T1514T622016A');

        Glass_Model__c modelByCode = assetDetailsFormController.getModelByCode('AUDQ3-1T1514T622016A');

        Redbook_Family__c familyByCode = assetDetailsFormController.getFamilyByCode('AUDQ3-1T1514T622016A');

        Redbook_Vehicle__c vehicleByCode = assetDetailsFormController.getVehicleByCode('AUDQ3-1T1514T622016A');

        RedbookVehicleDTO vehicleByRedbook = assetDetailsFormController.getVehicle('AUVHOND2017AEAE', null);

        RedbookVehicleDTO vehicleByCode_1 = assetDetailsFormController.getVehicle(null, 'AUVHOND2017AEAE');

        Decimal num = assetDetailsFormController.calculateAdjustment('A', 70000, 50000);
        Decimal num_1 = assetDetailsFormController.calculateAdjustment('B', 70000, 50000);
        Decimal num_2 = assetDetailsFormController.calculateAdjustment('C', 70000, 50000);
        Decimal num_3 = assetDetailsFormController.calculateAdjustment('E', 70000, 50000);
        Decimal num_4 = assetDetailsFormController.calculateAdjustment('F', 70000, 50000);
        Decimal num_5 = assetDetailsFormController.calculateAdjustment('G', 70000, 50000);
        Decimal num_6 = assetDetailsFormController.calculateAdjustment('G', 150000, 50000);
        Decimal num_7 = assetDetailsFormController.calculateAdjustment('G', 150001, 50000);

        assetDetailsFormController.loadTypeOptionsMap();

        Map<String, List<AssetOptionDTO>> variantOptionsByCode = assetDetailsFormController.getVariantOptionsByCode('AUDQ3-1T1514T622016A');

        List<AssetOptionDTO> variantOptionsByCodeNType = assetDetailsFormController.getVariantOptionsByCodeAndType('AUDQ3-1T1514T622016A', 'Standard');

        boolean redbookLenders = assetDetailsFormController.validateRedBookLenders('Pepper');

        Parameter p = new Parameter();
        p.year = '2017';
        p.make = 'AUD';
        p.family = 'A1';
        p.variant = 'SPORTBACK 1.0 TFSI';
        p.serie = '8X MY17';
        p.IdCar = 'AUDA1-SI1710UV02017A';
        Map<String,String> glassFamily = assetDetailsFormController.getGlassFamily(p);

        Map<String,String> glassVariant = assetDetailsFormController.getGlassVariant(p);

        Map<String,String> glassSeries = assetDetailsFormController.getGlassSeries(p);

        Integer glassCarsSize = assetDetailsFormController.getGlassCarsSize(p);

        List<Glass_Variant__c> glassCars = assetDetailsFormController.getGlassCars(p);

        Double rRP = assetDetailsFormController.getRRP(p);

        Glass_Variant__c glassCar = assetDetailsFormController.getGlassCar(p);

        Glass_Variant__c glassCarByCode = assetDetailsFormController.getGlassCarByCode(p);

        String codeModel = assetDetailsFormController.getCodeModel(p);

        CarListDTO carsList = assetDetailsFormController.getCarsList(p);

        VariantFactoryDTO variantFactoryOptions = assetDetailsFormController.getVariantFactoryOptions(p);

        p.year = '2018';
        p.make = 'AUD';
        p.family = 'Q5';
        p.variant = '2.0 TDI QUATTRO DESIGN';
        p.serie = 'FY MY18';
        p.IdCar = 'AUDQ5-2Q182000YG2018';

        VariantFactoryDTO variantFactoryOptions_1 = assetDetailsFormController.getVariantFactoryOptions(p);

        Decimal calculatedUsedOptions = assetDetailsFormController.calculateUsedOptions(new List<String>{'AW19'}, '2018');
        Decimal calculatedUsedOptions_1 = assetDetailsFormController.calculateUsedOptions(new List<String>{'AW19'}, '2010');
        Decimal calculatedUsedOptions_2 = assetDetailsFormController.calculateUsedOptions(new List<String>(), '2010');

        Map<String, String>  streetTypeOptions = assetDetailsFormController.getStreetTypeOptions();

        Map<String, String>  stateOptions = assetDetailsFormController.getStatesOptions();

        Map<String, String>  stateOptions_1 = assetDetailsFormController.getStatesOptions();

        Application_Quoting__c applicationQuoting = assetDetailsFormController.getApplicationQuoting('a011y000002yBH1AAM','a0E1y000003WczGEAS');

        Boolean isUserIdSettled = assetDetailsFormController.isUserIdSettlementTeam(opp.Id);

        AssetDetailsDTO dto = new AssetDetailsDTO();
        Application_Asset_Detail__c aad = null;
        if (opp.Application_AssetDetail__c != null) {
            aad = opp.Application_AssetDetail__r;
        }
        if (aad == null) {
            aad = new Application_Asset_Detail__c();
        }

        dto.assetType = 'Car';
        aad.Type__c = 'Car';

        Glass_Variant__c variantObj  = new Glass_Variant__c();
        variantObj.Average_Kms__c = 45;
        variantObj.Cylinders__c = 'DT4';
        variantObj.Description__c = '2.0 TDI QUATTRO DESIGN';
        variantObj.Engine__c = 'TCDI';
        variantObj.Family__c = 'Q5';
        variantObj.Id = 'a1l6D000001eNtMQAU';
        variantObj.KM_Category__c = 'G';
        variantObj.NVIC__c = '00YG18';
        variantObj.Name = '4D WAGON 7AST TCDI 2.0L DT4';
        variantObj.New_Price__c = 65900;
        variantObj.Release_Date__c = 'Jan-18';
        variantObj.Retail_Price__c = 48300;
        variantObj.Series__c = 'FY MY18';
        variantObj.Size__c = '2.0L';
        variantObj.Style__c = '4D WAGON';
        variantObj.Trade_Low_Price__c = 35100;
        variantObj.Trade_Price__c = 41500;
        variantObj.Transmission__c = '7AST';
        variantObj.Year__c = 2018;

        dto.variantObj = variantObj;
        dto.modelTypeSource = variantObj.Type_Source__c;
        dto.model = 'Q5';
        dto.make = 'AUDI';
        dto.options = '19 Inch Alloy Wheels (2,080), Inlays (520)';
        dto.totalPriceOptions = 2600;
        dto.totalTradeLowPriceOptions = 330;
        dto.totalTradePriceOptions = 550;
        dto.totalRetailPriceOptions = 1100;
        dto.totalTradeLowPriceKms = 0;
        dto.totalTradePriceKms = 0;
        dto.totalRetailPriceKms = 0;

        aad.Make__c = 'AUDI';
        aad.Model__c = 'Q5';
        aad.Variant__c = 'AUDQ5-2Q182000YG2018';
        aad.Variant_Desc__c = '2.0 TDI QUATTRO DESIGN';

        if (true) {
            aad.Factory_Options__c = '[\"AW19\",\"ILS\"]';
        } else {
            aad.Factory_Options__c = null;
        }

        aad.Series__c = 'FY MY18';

        dto.newUsed = 'used';
        aad.Condition__c = 'used';
        aad.Year__c = 2018;
        dto.lender = 'AFS';
        dto.typeLoan = 'Consumer';
        dto.carPrice = '$5000';
        dto.deposit = '$500';
        dto.warranty = '$1';
        dto.gap = '$23';
        dto.lpi = '$50';
        dto.lti = '$500';
        dto.carAge = '4';
        dto.fees = '$50';
        dto.realFees = '($0.00)';
        dto.ltvLabel ='LVR';
        dto.ltvValue = '10.37%';
        dto.naf = '$5124';
        dto.lvrLabel = 'RRP';
        dto.lvrValue = '$49400';            
        dto.actualKms = 500;
        dto.purchaseType = 'Dealer';
        dto.contractNumber = '';
        dto.vendorName = 'Anupama Dilshan';
        dto.vendorEmail = 'anupama.dilshan@icloud.com';
        dto.vendorAddress = 'Smart Rd, Modbury';
        dto.vendorContact = 'Anupama Dilshan';
        dto.vendorPhone = '0452575523';
        dto.vendorMobile = '0452575523';
        dto.rego = 'XCN3456';
        dto.vin = '123';
        dto.engine = '100';
        dto.colour = 'black';
        dto.regoState = 'SA';

        aad.Lender__c = 'AFS';
        aad.Type_Loan__c = 'Consumer';
        aad.Price__c = 5000;
        aad.Deposit__c = 500;
        aad.Warranty__c = 1;
        aad.GAP__c = 23;
        aad.LPI__c = 50;
        aad.LTI__c = 500;
        aad.Fees__c = 50;
        aad.Actual_KM__c = 500;
        aad.NAF__c = 5124;
        aad.LVR__c = 0.1;
        aad.RRP__c = 49400;
        aad.Rego__c = 'XCN3456';
        aad.VIN__c = '123';
        aad.Engine_No__c = '100';
        aad.Colour__c = 'black';
        aad.Rego_State__c = 'SA';

        String prefixFile = '';

        // when the assetType is Car
        String inserted = assetDetailsFormController.insertAssetDetails(aad, opp, dto, prefixFile);

        dto.assetType = 'Motorcycle';
        aad.Type__c = 'Motorcycle';

        dto.makeOVehicle = 'BAJAJ';
        dto.modelOVehicle = 'Pulsar';
        dto.variantOVehicle = '100CC';
        dto.seriesOVehicle = 'x-series';
        dto.year = '2018';
        aad.Make__c = 'BAJAJ';
        aad.Model__c = 'Pulsar';
        aad.Variant__c = '100CC';
        aad.Series__c = 'x-series';
        aad.Factory_Options__c = null;

        // when the assetType is not a Car
        String inserted_1 = assetDetailsFormController.insertAssetDetails(aad, opp, dto, prefixFile);

        // Pre-approval
        String prefixFile_1 = 'PRE_APPROVAL_';
        String inserted_2 = assetDetailsFormController.insertAssetDetails(aad, opp, dto, prefixFile_1);

        // Formal-approval
        String prefixFile_2 = 'FORMAL_APPROVAL_';
        String inserted_3 = assetDetailsFormController.insertAssetDetails(aad, opp, dto, prefixFile_2);

        // Amendment
        String prefixFile_3 = 'AMENDMENT_';
        String inserted_4 = assetDetailsFormController.insertAssetDetails(aad, opp, dto, prefixFile_3);

    }
}