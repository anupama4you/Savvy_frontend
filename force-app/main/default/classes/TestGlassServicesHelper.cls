@isTest(SeeAllData=true)
public class TestGlassServicesHelper {
	
    public static testMethod void testGetMakeSelectOptions(){
        List<String> makeList = new List<String>{'AUDI','BMW','MER'};
        
        List <SelectOption> d = GlassServicesHelper.getMakeSelectOptions('used','2015');
        System.debug('Makes size >> ' + d.size());
        
        //Null make code
        List <SelectOption> m = GlassServicesHelper.getMakeModelsSelectOptions(null, 'new', '2016');
        //System.assert(d == null);
        //Wrong make code
        m = GlassServicesHelper.getMakeModelsSelectOptions('wrong make code', 'new', '2016');
        //System.assert(d.size() == 1);
                
        for (String makeCode : makeList) {
            if (!String.isBlank(makeCode)) {
                m = GlassServicesHelper.getMakeModelsSelectOptions(makeCode, 'new', '2016');
                System.debug(makeCode + ' total new models >> ' + m.size());
                m = GlassServicesHelper.getMakeModelsSelectOptions(makeCode, 'used', '2016');
                System.debug(makeCode + ' total used models >> ' + m.size());
            }
        }
        
        //Variants
        List <SelectOption> v = GlassServicesHelper.getModelVariantsSelectOptions('C06687', '2009');
        if (v != null)
        	System.debug('C06687 total variants >> ' +v.size());
        
        //Factory options 
         v = GlassServicesHelper.getVariantFactoryOptionsSelectOptions('AUDQ3-1T1514T622016A');
        if (v != null)
        	System.debug('C06687 total options >> ' +v.size());
        List<Glass_Factory_Option__c> fo = GlassServicesHelper.getVariantStandardFactoryOptionsData('AUDQ3-1T1514T622016A');
        if (fo != null)
        	System.debug('total factory options >> ' + fo.size());
        
        //Model
        Glass_Model__c mO =  GlassServicesHelper.getModelByCode('C10467');
        if (mO != null) 
            System.debug('Model >> ' + mO.Name);
        
        //Make
        Glass_Make__c mk = GlassServicesHelper.getMakeByCode('MER');
        if (mK != null) 
            System.debug('Model >> ' + mK.Name);
        
        System.debug('Years new >> ' + GlassServicesHelper.getYears('new'));
        System.debug('Years used >> ' + GlassServicesHelper.getYears('used'));
        System.debug('Years used >> ' + GlassServicesHelper.getYears('new','Marine'));
        System.debug('Years used >> ' + GlassServicesHelper.getYears('used','Marine'));
        
        
        
        //Variant
        Glass_Variant__c vr = GlassServicesHelper.getVariantByCode('AUDQ3-1T1514T622016A') ;
        vr = GlassServicesHelper.getVariantByCode('AUDQ3-1T1514T622016AXXXX') ;
        System.debug(GlassServicesHelper.getVariantNewPrice('AUDQ3-1T1514T622016A'));
        
        Map<String, Glass_Factory_Option__c> mfo = GlassServicesHelper.getVariantFactoryOptionsMapData('AUDQ3-1T1514T622016A');
        
        GlassServicesHelper.calculateAdjustment('A', 70000, 50000);
        GlassServicesHelper.calculateAdjustment('B', 70000, 50000);
        GlassServicesHelper.calculateAdjustment('C', 70000, 50000);
        GlassServicesHelper.calculateAdjustment('E', 70000, 50000);
        GlassServicesHelper.calculateAdjustment('F', 70000, 50000);
        GlassServicesHelper.calculateAdjustment('G', 70000, 50000);
        
        GlassServicesHelper.calculateAdjustment('G', 150000, 50000);
        GlassServicesHelper.calculateAdjustment('G', 150001, 50000);
                
        GlassServicesHelper.loadTypeOptionsMap();
        GlassServicesHelper.getVariantOptionsByCode('AUDQ3-1T1514T622016A');
        GlassServicesHelper.getVariantOptionsByCodeAndType('AUDQ3-1T1514T622016A', 'Standard');

        //Redbook
        GlassServicesHelper.getMakeSelectOptionRedBook('2017');
        GlassServicesHelper.getMakeModelsSelectOptionsRedbook('BMW','2017');
        GlassServicesHelper.searchMakeRedbookCode('BMW','used','2017');
        GlassServicesHelper.getFamilyBadgeSelectOptionsRedbook('CIVIC','HOND','2017');
        GlassServicesHelper.getBadgeVariantsSelectOptions('HOND','CIVIC','VTi');
        GlassServicesHelper.getFamilyByCode('CIVIC');
        GlassServicesHelper.getVehicleByCode('AUVHOND2017AEAE');
        GlassServicesHelper.getVehicleByRedbookKey('AUVHOND2017AEAE');

        List<Glass_Variant__c> dvrs = [
          Select Id, Code__c From Glass_Variant__c Order By lastModifiedDate DESC LIMIT 1
        ];
        System.assert(!dvrs.isEmpty(), 'Most recent Variant not found!');
        vr = dvrs.get(0);

        // Other methods
        GlassServicesHelper.Parameter param = new GlassServicesHelper.Parameter();
        param.condition  = '';
        param.year = '';
        param.make = '';
        param.family = '';
        param.variantCode = '';
        param.variant = '';
        param.serie = '';
        param.color = '';
        param.accesories = '';
        param.state = '';
        param.IdCar = '';
        param.idOpp = '';
        param.sizeCars = 0;

        param = new GlassServicesHelper.Parameter();
        param.IdCar = vr.Code__c;
        vr = GlassServicesHelper.getGlassCarByCode(param);
        param.IdCar = vr.Id;
        vr = GlassServicesHelper.getGlassCar(param);
        param.variantCode = vr.Code__c;
        GlassServicesHelper.getRRP(param);
        GlassServicesHelper.calculateUsedOptions(new List<String>{'AW19'}, '2018');
        GlassServicesHelper.calculateUsedOptions(new List<String>{'AW19'}, '2010');
        GlassServicesHelper.calculateUsedOptions(new List<String>(), '2010');
    }
    
    public static testMethod void testGetMakeModelsSelectOptionsAux(){
        GlassServicesHelper.getMakeModelsSelectOptionsAux('AUD','used','2017');
        GlassServicesHelper.getModelVariantsSelectOptionsAux('A1','2017','used');
        GlassServicesHelper.getVariantSeriesSelectOptionsAux('SPORTBACK 1.0 TFSI','A1','2017','AUD');
        GlassServicesHelper.validateRedBookLenders('Pepper');
        GlassServicesHelper.Parameter p = new GlassServicesHelper.Parameter();
        p.year = '2017';
        p.make = 'AUD';
        p.family = 'A1';
        p.variant = 'SPORTBACK 1.0 TFSI';
        p.serie = '8X MY17';
        p.IdCar = 'AUDA1-SI1710UV02017A';
        GlassServicesHelper.getCodeModel(p);
        GlassServicesHelper.getGlassCarsSize(p);
        GlassServicesHelper.getGlassFamily(p);
        GlassServicesHelper.getGlassVariant(p);
        GlassServicesHelper.getGlassSeries(p);
        GlassServicesHelper.getGlassCarAux(p);
        GlassServicesHelper.getGlassCarsList(p);
    }
    
}