public with sharing class GlassServicesHelper {

    public static Integer sizeCarsVD {set; get;}
    public static Map<String, Glass_Variant__c> recordGlassVariant {set; get;}
    private static Map<String, String> typeOptionsMap;
    
    private static List<String> redBookLenders = new List<String> {'Pepper', 'RateSetter'};

        public static List <SelectOption> getMakeSelectOptions(String newUsed, String year) {
            String yearFilter = '%' + year + '%';
            List<Glass_Make__c> makes = new List<Glass_Make__c>();
            Decimal paramYear = Decimal.valueOf(year);
            // Load makers
            List<AggregateResult> md = [Select Make__c From Glass_Variant__c Where Year__c = :paramYear group by Make__c];
            if (!md.isEmpty()) {
              Set<String> mcodes = new Set<String>();
              for (AggregateResult a: md) {
                mcodes.add((String)a.get('Make__c'));
              }
              makes =  [Select o.Code__c, o.Name From Glass_Make__c o Where o.Code__c in :mcodes Order by o.Name];      
            }

            // if ('new'.equals(newused) || 'demo'.equals(newused)) {
            //     makes = [Select o.Code__c, o.Name From Glass_Make__c o Where o.New_Years__c like :yearFilter Order by o.Name];      
            // } else if ('used'.equals(newused)) {
            //     List<Glass_Make__c> tmp = [Select o.Code__c, o.Name, o.Used_Years__c From Glass_Make__c o Order by o.Name];
            //     makes = new List<Glass_Make__c>();
            //     for (Glass_Make__c m : tmp) {
            //         if (m.Used_Years__c != null && m.Used_Years__c.contains(year)) {
            //             makes.add(m);
            //         }
            //     }
            // }
            List <SelectOption> r = new List <SelectOption> ();
            r.add(new SelectOption ('', '--None--'));
            for (Glass_Make__c d: makes) {
                r.add(new SelectOption(d.Code__c, d.Name));
            }
            return r;
        }
    
    public static List <SelectOption> getMakeSelectOptionRedBook(String year) {
        
        Integer yearFilter = Integer.valueOf(year);
        List<Redbook_Make__c> makesRedbook = null;
        makesRedbook = [Select o.Code__c, o.Name From Redbook_Make__c o Where o.Latest_Year__c = :yearFilter Order by o.Name];
        
        List <SelectOption> r = new List <SelectOption> ();
        r.add(new SelectOption ('', '--None--'));
        for (Redbook_Make__c d: makesRedbook) {
            r.add(new SelectOption(d.Code__c, d.Name));
        }
        return r;    
    }
    
    public static List <SelectOption> getMakeModelsSelectOptions(String code, String newUsed, String year) {
        if (String.isBlank(code)) {
            return null;
        }
        List <SelectOption> r = new List <SelectOption> ();
        List<Glass_Model__c> data = null;
        String yearFilter = '%' + year + '%';

        if ('new'.equals(newused) || 'demo'.equals(newused)) {
            data = [Select o.Code__c, o.Name From Glass_Model__c o Where Make__r.Code__c = :code And o.New_Years__c like :yearFilter Order by o.Name];
        } else if ('used'.equals(newused)) {
            data = [Select o.Code__c, o.Name From Glass_Model__c o Where Make__r.Code__c = :code And o.Used_Years__c like :yearFilter Order by o.Name];
        }
        if (data != null) {
            r.add(new SelectOption ('', '--None--'));
            for (Glass_Model__c m : data) {
                r.add(new SelectOption(m.Code__c, m.Name));
            }
        } else {
            r.add(new SelectOption ('', '--No Models Found--'));
        }
        return r;
    }
    
    public static List <SelectOption> getMakeModelsSelectOptionsAux(String code, String newUsed, String year) {
        List <SelectOption> r = new List <SelectOption> ();
        Decimal y = Decimal.valueOf(year);
        // List<Glass_Model__c> data = null;
        List<AggregateResult> f = [
            SELECT Family__c FROM Glass_Variant__c
            where Make__c = :code AND Year__c = :y GROUP BY Family__c ORDER BY Family__c ASC
        ];
        // String yearFilter = '%' + year + '%';
        // if ('new'.equals(newused) || 'demo'.equals(newused)) {
        //     data = [Select o.Id, o.Code__c, o.Name, o.New_Years__c, o.Used_Years__c From Glass_Model__c o Where Make__r.Code__c = :code And o.New_Years__c like :yearFilter Order by o.Name];
        //     if (!data.isEmpty()) {
        //         Set<Id> modelIds = new Set<Id>();
        //         for (Glass_Model__c m: data) {
        //             modelIds.add(m.Id);
        //         }
        //         f = [
        //             SELECT Family__c FROM Glass_Variant__c
        //             where Model__c in :modelIds GROUP BY Family__c ORDER BY Family__c ASC
        //         ];
        //     }
        // } else if ('used'.equals(newused)) {
        //     data = [Select o.Id, o.Code__c, o.Name, o.New_Years__c, o.Used_Years__c From Glass_Model__c o Where Make__r.Code__c = :code And o.Used_Years__c like :yearFilter Order by o.Name];
        //     if (!data.isEmpty()) {
        //         Set<Id> modelIds = new Set<Id>();
        //         for (Glass_Model__c m: data) {
        //             modelIds.add(m.Id);
        //         }
        //         f = [
        //             SELECT Family__c FROM Glass_Variant__c
        //             where Model__c in :modelIds GROUP BY Family__c ORDER BY Family__c ASC
        //         ];
        //     }
        // }
        if (!f.isEmpty()) {
            r.add(new SelectOption ('', '--None--'));
            for(AggregateResult o : f){
                r.add(new SelectOption((String)o.get('Family__c'), (String)o.get('Family__c')));
            }
        } else {
            r.add(new SelectOption ('', '--No Models Found--'));
        }
        return r;
    }
    
    public static List <SelectOption> getMakeModelsSelectOptionsRedbook(String code, String year){
        if (String.isBlank(code)) {
            return null;
        }
        List <SelectOption> r = new List <SelectOption> ();
        List<Redbook_Family__c> data = null;
        Integer yearFilter = Integer.valueOf(year);
        
        data = [Select o.Family_Code__c, o.Description__c From Redbook_Family__c o Where RB_Make_Code__c = :code And o.Latest_Year__c = :yearFilter Order by o.Description__c];
        
        if (data != null) {
            r.add(new SelectOption ('', '--None--'));
            for (Redbook_Family__c m : data) {
                if(m.Family_Code__c != ' ' && m.Description__c != ' '){
                    system.debug('getMakeModelsSelectOptionsRedbook: m.Family_Code__c ' + m.Family_Code__c);
                    r.add(new SelectOption(m.Family_Code__c, m.Description__c));
                }else{
                    r.add(new SelectOption ('', '--No Families Found--'));
                }
            }
        } else {
            r.add(new SelectOption ('', '--No Families Found--'));
        }
        return r;
    }
    
    public static String searchMakeRedbookCode(String code, String newUsed, String year){
        if (String.isBlank(code)) {
            return null;
        }
        String makeRedbookAux;
        String yearFilter = '%' + year + '%';
        List<Redbook_Make__c> listRedbookAux = null;
        List<Glass_Make__c> data = null;
        List <SelectOption> r = new List <SelectOption> ();
        
        if ('new'.equals(newused) || 'demo'.equals(newused)) {
            data = [Select o.Name From Glass_Make__c o Where o.Code__c = :code AND o.New_Years__c like :yearFilter Order by o.Name];
        } else if ('used'.equals(newused)) {
            data = [Select o.Name From Glass_Make__c o Where o.Code__c = :code AND o.Used_Years__c like :yearFilter Order by o.Name];
        }
        if (data != null) {
            for (Glass_Make__c m : data) {
                listRedbookAux = [Select o.Code__c, o.Name From Redbook_Make__c o Where o.Name = :m.Name];
                if(listRedbookAux.isEmpty()){
                    makeRedbookAux = '';
                }else{
                    for(Redbook_Make__c n : listRedbookAux){
                        makeRedbookAux = n.Code__c;
                    }  
                }
            }
        } else {
            makeRedbookAux = '';
        }
        
        return makeRedbookAux;
    }
    
    public static List <SelectOption> getModelVariantsSelectOptions(String code, String year) {
        if (String.isBlank(code)) {
            return null;
        }
        List <SelectOption> r = new List <SelectOption> ();
        List<Glass_Variant__c> data = [Select o.Code__c, o.Name From Glass_Variant__c o Where Model__r.Code__c = :code And o.Year__c = :Integer.valueOf(year) ];
        if (data != null) {
            r.add(new SelectOption ('', '--None--'));
            for (Glass_Variant__c m : data) {
                r.add(new SelectOption(m.Code__c, m.Name));
            }
        } else {
            r.add(new SelectOption ('', '--No Variants Found--'));
        }
        
        return r;
    }
    
    public static List <SelectOption> getModelVariantsSelectOptionsAux(String code, String year, String make) {
        List <SelectOption> r = new List <SelectOption> ();
                        
        List<AggregateResult> data = [SELECT Description__c 
                                  FROM Glass_Variant__c
                                  WHERE Year__c = :Integer.valueOf(year) 
                                  AND Family__c = :code 
                                  AND Make__c = :make
                                  GROUP BY Description__c
                                  ORDER BY Description__c];

        if (!data.isEmpty()) {
            r.add(new SelectOption ('', '--None--'));
            for (AggregateResult o : data) {
                if((String)o.get('Description__c') != null){
                    r.add(new SelectOption((String)o.get('Description__c'), (String)o.get('Description__c')));
                }
            }
            
        } else {
            r.add(new SelectOption ('', '--No Variants Found--'));
        }
        
        return r;
    }
    
    public static List <SelectOption> getVariantSeriesSelectOptionsAux(String variantDesc, String model, String year, String make) {
        List <SelectOption> r = new List <SelectOption> ();
                
        List<AggregateResult> data = [SELECT Series__c 
                FROM Glass_Variant__c
                WHERE Year__c = :Integer.valueOf(year) 
                AND Make__c = :make
                AND Family__c = :model 
                AND Description__c = :variantDesc
                GROUP BY Series__c
                ORDER BY Series__c];
        
        if (!data.isEmpty()) {
            r.add(new SelectOption ('', '--None--'));
            for (AggregateResult o : data) {
                if((String)o.get('Series__c') != null){
                    r.add(new SelectOption((String)o.get('Series__c'), (String)o.get('Series__c')));
                }
            }
            
        } else {
            r.add(new SelectOption ('', '--No Variants Found--'));
        }
        
        return r;
    }
    
    public static List <SelectOption> getFamilyBadgeSelectOptionsRedbook(String code, String make, String year){
        if (String.isBlank(code)) {
            return null;
        }
        Integer yearFilter = Integer.valueOf(year);
        List <SelectOption> r = new List <SelectOption> ();
        List<AggregateResult> data = [Select o.Badge_Description__c From Redbook_Vehicle__c o Where o.Family_Code__c = :code And o.RB_Make_Code__c = :make AND o.Year_Group__c = :yearFilter group by o.Badge_Description__c];
        if (data != null) {
            r.add(new SelectOption ('', '--None--'));
            for (AggregateResult m : data) {
                if(m.get('Badge_Description__c')!=null){
                    r.add(new SelectOption(String.valueOf(m.get('Badge_Description__c')), String.valueOf(m.get('Badge_Description__c'))));
                }else{
                    r.add(new SelectOption ('', '--No Badge Found--'));
                }
            }
        } else {
            r.add(new SelectOption ('', '--No Badge Found--'));
        }
        return r;
    }
    
    public static List <SelectOption> getBadgeVariantsSelectOptions(String makeRedbook, String model, String badge){
        if (String.isBlank(badge)) {
            return null;
        }
        List <SelectOption> r = new List <SelectOption> ();
        List<Redbook_Vehicle__c> dataVariant = [Select o.Name, o.Description__c, Family_Code__c From Redbook_Vehicle__c o Where o.Badge_Description__c = :badge And Family_Code__c = :model And o.RB_Make_Code__c = :makeRedbook];
        
        if (dataVariant != null) {
            r.add(new SelectOption ('', '--None--'));
            for (Redbook_Vehicle__c m : dataVariant) {
                r.add(new SelectOption(m.Name, m.Description__c));
            }
        } else {
            r.add(new SelectOption ('', '--No Variants Found--'));
        }
        return r;
    }
    
    public static List <SelectOption> getVariantFactoryOptionsSelectOptions(String code) {
        if (String.isBlank(code)) {
            return null;
        }
        List <SelectOption> r = new List <SelectOption> ();
        List<Glass_Factory_Option__c> data = getVariantFactoryOptionsData(code);
        if (data != null) {
            for (Glass_Factory_Option__c m : data) {
                r.add(new SelectOption(m.Option__r.Code__c, (m.Option__r.Name + ' ($' + m.Price__c.format() + ')')));
            }
        } else {
            r.add(new SelectOption ('', '--No Variants Found--'));
        }
        
        return r;
    }
    
    public static List <Glass_Factory_Option__c> getVariantFactoryOptionsData(String code) {
        return getVariantFactoryOptionsData(code, 'Optional');
    }
    
    public static List <Glass_Factory_Option__c> getVariantFactoryOptionsData(String code, String typeFeature) {
        if (String.isBlank(code)) {
            return null;
        }
        return 
            [Select Option__r.Code__c, Option__r.Name, o.Price__c, o.Type__c 
             From Glass_Factory_Option__c o Where Variant__r.Code__c = :code And Type__c = :typeFeature];
    }
    
    public static Map<String, Glass_Factory_Option__c> getVariantFactoryOptionsMapData(String code) {
        if (String.isBlank(code)) {
            return null;
        }
        Map<String, Glass_Factory_Option__c> r = null;
        List <Glass_Factory_Option__c> d = getVariantFactoryOptionsData(code);
        if (d != null) {
            r = new Map<String, Glass_Factory_Option__c>();
            for (Glass_Factory_Option__c o : d) {
                r.put(o.Option__r.Code__c, o);
            }
        }
        
        return r;
    }
    
    public static List<Glass_Factory_Option__c> getVariantStandardFactoryOptionsData(String code) {
        if (String.isBlank(code)) {
            return null;
        }
        return getVariantFactoryOptionsData(code, 'Standard');
    }
    
    public static Decimal getVariantNewPrice(String code) {
        if (code != null) {
            Glass_Variant__c d = null;
            try {
                d = [Select o.New_Price__c From Glass_Variant__c o Where o.Code__c = :code limit 1];
            } catch (QueryException e) {}
            if (d != null) {
                return d.New_Price__c;
            }
        }
        return 0.0;
    }
    
    public static Glass_Variant__c getVariantByCode(String code) {
        Glass_Variant__c r = null;
        if (code != null) {
            try {
                r = [Select o.NVIC__c, o.New_Price__c, o.Retail_Price__c,  
                     o.Trade_Price__c, o.Trade_Low_Price__c, o.Year__c,
                     o.Code__c, o.Family__c, o.Description__c, o.Style__c,
                     o.Series__c, o.Release_Date__c, o.Engine__c, o.CC__c,
                     o.Transmission__c, o.Average_Kms__c, KM_Category__c, Name, 
                     Cylinders__c, Size__c, Type_Source__c
                     From Glass_Variant__c o Where o.Code__c = :code limit 1];
            } catch (QueryException e) {}
        }
        return r;
    }
   
    public static List <SelectOption> getYears(String newUsed) {
        return getYears(newUsed.toLowerCase(), 'Car');
    }
    
    public static List <SelectOption> getYears(String newUsed, String assetType) {
        List <SelectOption> r = new List <SelectOption>();
        Integer yActual = Date.today().year();
        if (newUsed != null) {
            r.add(new SelectOption ('', '--None--'));
            if ('new'.equals(newused) || 'demo'.equals(newused)) {
                for (Integer y = yActual; y >= yActual-2;y--) {
                    r.add(new SelectOption(String.valueOf(y),String.valueOf(y)));
                }
            } else if ('used'.equals(newused)) {
                Integer z = 1960; //Limit for Cars
                if (!'Car'.equalsIgnoreCase(assetType)) {
                    z = yActual - 30;
                }
                // for (Integer y=yActual; y > (yActual - z);y--) {
                for (Integer y=yActual; y >= z;y--) {
                    r.add(new SelectOption(String.valueOf(y),String.valueOf(y)));
                }
            }
        }
        return r;
    }
    
    public static Glass_Make__c getMakeByCode(String code) {
        if (String.isBlank(code)) {
            return null;
        }
        Glass_Make__c r = null;
        try {
            r = [Select o.Code__c, o.Name From Glass_Make__c o Where o.Code__c = :code limit 1];
        } catch (QueryException e) {}
        
        return r;
    }
    
    public static Glass_Model__c getModelByCode(String code) {
        if (String.isBlank(code)) {
            return null;
        }
        Glass_Model__c r = null;
        try {
            r = [Select o.Code__c, o.Name, o.Type_Source__c From Glass_Model__c o Where o.Code__c = :code limit 1];
        } catch (QueryException e) {}
        
        return r;            
    }
    
    public static Redbook_Family__c getFamilyByCode(String code) {
        if (String.isBlank(code)) {
            return null;
        }
        Redbook_Family__c r = null;
        try {
            r = [Select o.Family_Code__c, o.Description__c, o.Vehicle_Type_Code__c, o.Latest_Year__c From Redbook_Family__c o Where o.Family_Code__c = :code limit 1];
        } catch (QueryException e) {}
        
        return r;            
    }
    
    public static Redbook_Vehicle__c getVehicleByCode(String code) {
        if (String.isBlank(code)) {
            return null;
        }
        Redbook_Vehicle__c r = null;
        try {
            r = [Select o.Name, o.Description__c, o.Badge_Description__c, o.Year_Group__c From Redbook_Vehicle__c o Where o.Name = :code limit 1];
        } catch (QueryException e) {}
        
        return r;            
    }
    
    public static Redbook_Vehicle__c getVehicleByRedbookKey(String redbookKey){
        if (String.isBlank(redbookKey)) {
            return null;
        }
        Redbook_Vehicle__c r = null;
        try {
            r = [Select o.Name, o.RB_Make_Code__c, o.Family_Code__c, o.Badge_Description__c, o.Description__c 
                 from Redbook_Vehicle__c o
                 where o.Name = :redbookKey
                 limit 1];
        } catch (QueryException e) {}
        return r;           
    }
    
    public static Decimal calculateAdjustment(String category, Double kms, Double average) {
        System.debug(category + '|' + kms + '|' + average);
        Decimal r = 0;
        if (String.isBlank(category) || kms == null || average == null || average == 0.0) {
            return r;
        }
        
        Decimal factor = 0;
        Decimal startPrice = 0;
        if ('A'.equalsIgnoreCase(category)) {
            factor = 30;
            startPrice = 330;
        } else if ('B'.equalsIgnoreCase(category)) {
            factor = 40;
            startPrice = 500;
        } else if ('C'.equalsIgnoreCase(category)) {
            factor = 65;
            startPrice = 900;
        } else if ('E'.equalsIgnoreCase(category)) {
            factor = 40;
            startPrice = 600;
        } else if ('F'.equalsIgnoreCase(category)) {
            factor = 50;
            startPrice = 800;
        } else if ('G'.equalsIgnoreCase(category)) {
            factor = 70;
            startPrice = 1000;
        }
        
        Double diff = average - kms;
        System.debug('Diff 1 >> ' + diff);
        if (Math.abs(diff) >= 10000) {
            if (Math.abs(diff) > 100000) {
                Double max = average + 100000;
                //throw new Exception('Maximum allowable Range from 0 to ' + max.format());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Actual KM must be allowable in a range from 0 to ' + max.format() + ', please check that information and try again.'));
            } else {
                System.debug('Diff 2 >> ' + diff);
                Double tmp = Double.valueOf(String.valueOf(Math.abs(diff)).left(2));
                if (Math.abs(diff) == 100000) {
                    tmp = Double.valueOf(String.valueOf(Math.abs(diff)).left(3));
                }
                System.debug('tmp >> ' + tmp);
                tmp = (tmp - 10);
                r = (tmp * factor) + startPrice;
                if (average < kms) {
                    r = r * (-1);
                }
            }
        }
        
        return r;
    }
    
    //Lelo                      2016-12-30
    public static void loadTypeOptionsMap() {
        typeOptionsMap = new Map<String, String>();
        List<Glass_Option__c> data = [SELECT Code__c, Name FROM Glass_Option__c ORDER BY Name];
        for (Glass_Option__c o : data) {
            typeOptionsMap.put(o.Code__c, o.Name);
        }
    }
    
    public static Map<String, List<AssetOptionDTO>> getVariantOptionsByCode(String code) {
        Map<String, List<AssetOptionDTO>> r = new Map<String, List<AssetOptionDTO>>();
        if(!String.isBlank(code)){
            List<Glass_Variant_Option__c> data = [SELECT Type_Option__c, Options__c FROM Glass_Variant_Option__c 
                                                  WHERE Variant_Code__c = :code];
            loadTypeOptionsMap();
            for (Glass_Variant_Option__c v : data) {
                List<AssetOptionDTO> dtos = AssetOptionDTO.build(v.Type_Option__c, v.Options__c);
                for (AssetOptionDTO a : dtos) {
                    a.name = typeOptionsMap.get(a.code);
                }
                r.put(v.Type_Option__c, dtos);
            }
        }
        return r;
    }
    
    public static List<AssetOptionDTO> getVariantOptionsByCodeAndType(String code, String typeOption) {
        List<AssetOptionDTO> r = new List<AssetOptionDTO>();
        List<Glass_Variant_Option__c> d = [SELECT Type_Option__c, Options__c FROM Glass_Variant_Option__c 
                                           WHERE Variant_Code__c = :code AND Type_Option__c = :typeOption];
        System.debug(code + '|' + typeOption);
        if (!d.isEmpty()) {
            r = AssetOptionDTO.build(typeOption, d.get(0).Options__c);
            loadTypeOptionsMap();
            for (AssetOptionDTO a : r) {
                a.name = typeOptionsMap.get(a.code);
            }
        }
        return r;
    }
    
    public static boolean validateRedBookLenders(String lender){
        Boolean r = false;
        for (Integer i = 0; i<redBookLenders.size(); i++) {
            if(redBookLenders[i].equalsIgnoreCase(lender)){
                r = true;
            }
        }
        return r;
    }
    
    public static List <SelectOption> getGlassFamily(Parameter param) {
        if (String.isBlank(param.make) || param.year == null) {
            return null;
        }
        List <SelectOption> r = new List <SelectOption> ();
        AggregateResult[] data = [SELECT Family__c 
                                  FROM Glass_Variant__c  
                                  WHERE Make__c = :param.make 
                                  AND Year__c = :Decimal.valueOf(param.year)
                                  GROUP BY Family__c
                                  ORDER BY Family__c
                                 ];
        
        if (data != null) {
            r.add(new SelectOption ('', '--None--'));
            for (AggregateResult m : data) {
                r.add(new SelectOption((String)m.get('Family__c'), (String)m.get('Family__c')));
            }
        } else {
            r.add(new SelectOption ('', '--No Models Found--'));
        }
        r.sort();
        return r;
    }
    
    public static List <SelectOption> getGlassVariant(Parameter param) {
        if (String.isBlank(param.make) || param.year == null) {
            return null;
        }
        List <SelectOption> r = new List <SelectOption> ();
        
        AggregateResult[] data = [SELECT Description__c 
                                  FROM Glass_Variant__c
                                  WHERE Year__c = :Decimal.valueOf(param.year) 
                                  AND Family__c = :param.family 
                                  AND Make__c = :param.make
                                  GROUP BY Description__c
                                  ORDER BY Description__c
                                 ];
        
        if (data != null) {
            r.add(new SelectOption ('', '--None--'));
            for (AggregateResult m : data) {
                if((String)m.get('Description__c') != null){
                    r.add(new SelectOption((String)m.get('Description__c'), (String)m.get('Description__c')));
                }
            }
        } else {
            r.add(new SelectOption ('', '--No Variants Found--'));
        }
        r.sort();
        return r;
    }
    
    public static List <SelectOption> getGlassSeries(Parameter param) {
        if (String.isBlank(param.make) || param.year == null) {
            return null;
        }
        List <SelectOption> r = new List <SelectOption> ();
        AggregateResult[] data = [SELECT t.Series__c 
                                  FROM Glass_Variant__c t 
                                  WHERE t.Year__c = :Decimal.valueOf(param.year) 
                                  AND t.Family__c = :param.family 
                                  AND t.Make__c = :param.make 
                                  AND t.Description__c =:param.variant
                                  GROUP BY t.Series__c
                                  ORDER BY t.Series__c
                                 ];
        if (data != null) {
            r.add(new SelectOption ('', '--None--'));
            for (AggregateResult m : data) {
                if((String)m.get('Series__c') != null){
                    r.add(new SelectOption((String)m.get('Series__c'), (String)m.get('Series__c')));
                }
            }
        } else {
            r.add(new SelectOption ('', '--No Series Found--'));
        }
        r.sort();
        return r;
    }
    
    public static List<Glass_Variant__c> getGlassCarsList(Parameter param) {
        System.debug('>>>>>>>>>>>>>>>>>>>>   getGlassCarsList');
        return getGlassCars(param);
    }
    
    public static Integer getGlassCarsSize(Parameter param) {
        System.debug('>>>>>>>>>>>>>>>>>>>>   getGlassCarsSize');
		getGlassCars(param);
        return sizeCarsVD;
    }
    
    public static List<Glass_Variant__c> getGlassCars(Parameter param) {
        List<Glass_Variant__c> vdCars;
        recordGlassVariant = new Map<String, Glass_Variant__c>();
        if (String.isBlank(param.make) || param.year == null) {
            sizeCarsVD = 0;
            return null;
        }
        Decimal year = Decimal.valueOf(param.year);
        String make = param.make;
        String family = param.family;
        
        String sq = 'SELECT Id, Name, Average_Kms__c, Engine__c, KM_Category__c, CC__c, Code__c, Model__r.Type_Source__c, '+
                    'New_Price__c, NVIC__c, Release_Date__c, Retail_Price__c, Style__c, Trade_Low_Price__c, '+
                    'Trade_Price__c, Transmission__c, Year__c, Make__c, Family__c, Description__c, Series__c, '+
                    'Cylinders__c, Size__c, Type_Source__c FROM Glass_Variant__c t WHERE t.Year__c = :year '+
                    'AND t.Make__c = :make AND t.Family__c = :family';
        
        if(param.variant != null){
            String variant = param.variant;
            sq += ' AND t.Description__c = :variant';
        }
        
        if(param.serie != null){
            String serie = param.serie;
            sq += ' AND t.Series__c = :param.serie';
        }
        
        System.debug('GlassServicesHelper.getGlassCars  SQ >>> ' + sq);
        vdCars = new List<Glass_Variant__c>();
        vdCars = Database.query(sq);
        for (Glass_Variant__c r: vdCars){
            if(r.Id != null){
                recordGlassVariant.put(r.Id, r);
            }
        }
        sizeCarsVD = vdCars.size();
		return vdCars;
    }
        
    public static Double getRRP(Parameter param){
    	Glass_Variant__c variantObj = getVariantByCode(param.variantCode);
        if(variantObj != null){
        	return variantObj.New_Price__c;    
        }
        return 0;
    }
    
    public static Glass_Variant__c getGlassCar(Parameter param) {
        List<Glass_Variant__c> r = [SELECT Id, Name, Average_Kms__c, Engine__c, KM_Category__c, CC__c, Code__c, Model__r.Type_Source__c,
                                    New_Price__c, NVIC__c, Release_Date__c, Retail_Price__c, Style__c, Trade_Low_Price__c,
                                    Trade_Price__c, Transmission__c, Year__c, Make__c, Family__c, Description__c, Series__c,
                                    Cylinders__c, Size__c, Type_Source__c
                                    FROM Glass_Variant__c t 
                                    WHERE t.Id = :param.IdCar
                                   ];
        for(Glass_Variant__c g : r){
            return g;
        }
        return null;
    }
    
    public static Glass_Variant__c getGlassCarAux(Parameter param) {
        List<Glass_Variant__c> r = [SELECT Id, Name, Average_Kms__c, Engine__c, KM_Category__c, CC__c, Code__c, Model__r.Type_Source__c,
                                    New_Price__c, NVIC__c, Release_Date__c, Retail_Price__c, Style__c, Trade_Low_Price__c,
                                    Trade_Price__c, Transmission__c, Year__c, Make__c, Family__c, Description__c, Series__c,
                                    Cylinders__c, Size__c, Type_Source__c FROM Glass_Variant__c t 
                                    WHERE t.Code__c = :param.IdCar
                                   ];
        for(Glass_Variant__c g : r){
            return g;
        }
        return null;
    }
        
    // public String model(String type){
    //     if('PVG'.equals(type)){
    //         return 'PASSENGER VEHICLES';
    //     }else if('CVG'.equals(type)){
    //         return 'LIGHT COMMERCIAL VEHICLES';
    //     }else if('OCG'.equals(type)){
    //         return 'OLDER CARS';
    //     }
    //     return 'OLDER LIGHT COMMERCIAL';
    // }
    
    public class Parameter {
        public String condition {get;set;}
        public String year {set; get;}
        public String make {set; get;}
        public String family {set; get;}
        public String variantCode {set; get;}
        public String variant {set; get;}
        public String serie {set; get;}
        public String color {set; get;}
        public String accesories {set; get;}
        public String state {set; get;}
        public String IdCar {set; get;}
        public String idOpp {set; get;}
        public Integer sizeCars {set; get;}
        public Parameter(){}
    }
    
    //By Yohan Villamizar 10-04-2019
    public static Glass_Variant__c getGlassCarByCode(Parameter param) {
        List<Glass_Variant__c> r = [SELECT Id, Name, Average_Kms__c, Engine__c, KM_Category__c, CC__c, Code__c, Model__r.Type_Source__c,
                                    New_Price__c, NVIC__c, Release_Date__c, Retail_Price__c, Style__c, Trade_Low_Price__c,
                                    Trade_Price__c, Transmission__c, Year__c, Make__c, Family__c, Description__c, Series__c,
                                    Type_Source__c, Size__c, Cylinders__c
                                    FROM Glass_Variant__c t 
                                    WHERE Code__c = :param.IdCar
                                   ];
        for(Glass_Variant__c g : r){
            return g;
        }
        return null;
    }
    
    public static String getCodeModel(Parameter param) {
        Decimal year = Decimal.valueOf(param.year);
        String make = param.make;
        String family = param.family;
        String variant = param.variant;
        String serie = param.serie;
        String model;
        List<Glass_Variant__c> r = [SELECT Model__r.Code__c
                                    FROM Glass_Variant__c t WHERE t.Year__c = :year
                                    AND t.Make__c = :make AND t.Family__c = :family
                                    AND t.Description__c = :variant AND t.Series__c = :param.serie limit 1];
        
        for(Glass_Variant__c g: r){
            model = g.Model__r.Code__c;
        }
        
        return model;
    }

    public static Decimal calculateUsedOptions(List<String> options, String year) {
      if(options == null || options.isEmpty() || String.isBlank(year)){
        return 0;
      }

      Integer yearOptions = Date.today().year() - Integer.valueOf(year);
    
      if(yearOptions > 10){
        yearOptions = 10;
      }
      
      List<AggregateResult> total = [
          SELECT SUM(Amount__c)total 
          FROM Glass_Option_Adjustment__c 
          WHERE Years__c =: yearOptions AND Option__c IN:options
      ];
      
      return (Decimal)total.get(0).get('total') != null?(Decimal)total.get(0).get('total'):0;
    }
}