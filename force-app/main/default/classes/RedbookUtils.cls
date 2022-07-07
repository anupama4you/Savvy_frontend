public with sharing class RedbookUtils {
	

	public static Redbook_Make__c getMake(String glassMakeCode) {
		List<Redbook_Make__c> d = [SELECT Id, Name, Code__c, Glass_Make_Code__c, Latest_Year__c, Start_Year__c
								   FROM Redbook_Make__c WHERE Glass_Make_Code__c = :glassMakeCode];
		if (!d.isEmpty()) {
			return d.get(0);
		}
		return null;
	}

	public static List<Redbook_Family__c> getMakeFamilies(String rbMakeCode, Decimal year) {
		return [
			SELECT Id, Name, Description__c, Family_Code__c, Latest_Year__c, RB_Make_Code__c, 
			       Start_Year__c, Vehicle_Type_Code__c
			FROM Redbook_Family__c
			WHERE RB_Make_Code__c = :rbMakeCode
			AND  Start_Year__c <= :year AND Latest_Year__c >= :year
			ORDER BY Description__c
		];
	}

	public static List<Redbook_Vehicle__c> getVehicles(String rbFamilyCode, String rbBadge, Decimal year) {
		String sql = 'SELECT Id, Name, Badge_Description__c, Badge_Secondary_Description__c, Body_Config_Description__c, Body_Style_Description__c, ' +
		 			 '       Current_Release__c, Cylinders__c, Description__c, Door_Num__c, Drive_Description__c, Engine_Description__c, Engine_Size__c, ' +
		 			 '       Extra_Identification__c, Family_Code__c, Fuel_Type_Description__c, Gear_Location_Description__c, Gear_Num__c, Gear_Type_Description__c, ' +
		 			 '       Import_Flag__c, Induction_Description__c, Limited_Edition__c, Month_Group__c, Option_Category__c, RB_Family_Code__c, RB_Make_Code__c, ' +
		 			 '       Roofline__c, Sequence_Num__c, Series_Model_Year__c, Series_Public__c, Vehicle_Type_Code__c, Wheel_Base_Config__c, Year_Group__c ' +
		 			 'FROM Redbook_Vehicle__c ' +
		 			 'WHERE RB_Family_Code__c = :rbFamilyCode AND Year_Group__c = :year';
		if ('(NO BADGE)'.equals(rbBadge)) {
			sql += ' AND Badge_Description__c = null';
		} else if (String.isNotBlank(rbBadge)) {
			sql += ' AND Badge_Description__c = :rbBadge';
		}
		sql += ' ORDER BY Description__c';
		return Database.query(sql);
	}

	public static List<SelectOption> getFamilyOptions(List<Redbook_Family__c> familyList) {
        List<SelectOption> r =  new List<SelectOption>();
        r.add(new SelectOption('','--None--'));
        if (familyList != null) {
        	for (Redbook_Family__c a: familyList) {
        		r.add(new SelectOption(a.Name, a.Description__c));
        	}
        }
        return r;
    }

    public static List<String> getFamilyBadges(String rbFamilyCode, Decimal year) {
    	List<String> r = new List<String>();
    	List<AggregateResult> d = [
		    	SELECT Badge_Description__c FROM Redbook_Vehicle__c
				WHERE RB_Family_Code__c = :rbFamilyCode 
				AND Year_Group__c = :year
				GROUP BY Badge_Description__c
				ORDER BY Badge_Description__c
		];
		if (!d.isEmpty()) {
			for (AggregateResult a : d) {
				String b = (String)a.get('Badge_Description__c');
				if (String.isNotBlank(b)) {
					r.add(b);
				} else {
					r.add('(NO BADGE)');
				}
			}
		}
    	return r;
    }

}