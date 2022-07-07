@isTest
private class TestFieldValidationsHelper {
	
	@isTest static void testCase() {
		

		System.assertEquals(true, FieldValidationsHelper.isContainsValidCharacters('abc'));
		System.assertEquals(false, FieldValidationsHelper.isContainsValidCharacters(''));

		Decimal num = null;
		System.assertEquals(false, FieldValidationsHelper.isContainsValidCharacters(num));
		num = 123.0;
		System.assertEquals(true, FieldValidationsHelper.isContainsValidCharacters(num));

		System.assertEquals(false, FieldValidationsHelper.isDateFormatValid(null));
		System.assertEquals(false, FieldValidationsHelper.isDateFormatValid(''));
		System.assertEquals(false, FieldValidationsHelper.isDateFormatValid('        '));
		System.assertEquals(false, FieldValidationsHelper.isDateFormatValid('no data'));
		System.assertEquals(true, FieldValidationsHelper.isDateFormatValid('01/01/2018'));

		System.assertEquals(true, FieldValidationsHelper.isDateFormatValidOptional(null));
		System.assertEquals(true, FieldValidationsHelper.isDateFormatValidOptional('01/01/2018'));

		System.assertEquals(false, FieldValidationsHelper.isValueGreaterThanZero(null));
		System.assertEquals(false, FieldValidationsHelper.isValueGreaterThanZero(''));
		System.assertEquals(false, FieldValidationsHelper.isValueGreaterThanZero('eeee'));
		System.assertEquals(true, FieldValidationsHelper.isValueGreaterThanZero('2'));
		System.assertEquals(true, FieldValidationsHelper.isValueGreaterThanZero('2.5'));

		System.assertEquals(true, FieldValidationsHelper.isDecimalGreaterThanZero(2.5));

		FieldValidationsHelper.getYearsBetween('01/01/2016');
		FieldValidationsHelper.getYearsBetween('abc');
		FieldValidationsHelper.getMonthsBetween('01/01/2016');
		FieldValidationsHelper.getMonthsBetween('abc');

		List<Date> d1 = new List<Date>();
		List<Date> d2 = new List<Date>();

		d1.add(Date.newInstance(2018, 1, 1));
		d1.add(Date.newInstance(2017, 1, 1));

		d2.add(Date.newInstance(2018, 3, 1));
		d2.add(Date.newInstance(2017, 12, 31));

		FieldValidationsHelper.getYearsBetween(d1, d2);
		d2.add(Date.newInstance(2017, 12, 31));
		System.assertEquals(0.0, FieldValidationsHelper.getYearsBetween(d1, d2));

		FieldValidationsHelper.convertDate('abc');
		FieldValidationsHelper.convertDate('01/01/2018');

		FieldValidationsHelper.getMonthsBetween(Date.newInstance(2018, 1, 1), Date.newInstance(2018, 3, 1));

		FieldValidationsHelper.isDecimalFormatValid('1.25');
	}
		
}