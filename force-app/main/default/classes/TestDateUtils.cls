@isTest
private class TestDateUtils {
	
	@isTest static void testGeneral() {
		Date d = null;
		Datetime dt = null;
		DateUtils.convertToString(d, DateUtils.ddMMyyyy);
		DateUtils.convertToString(dt, DateUtils.ddMMyyyy);
		DateUtils.formatDate(d, DateUtils.ddMMyyyy);
		DateUtils.formatDate(dt, DateUtils.ddMMyyyy);

		d = Date.today();
		dt = Datetime.now();
		DateUtils.convertToString(d, DateUtils.ddMMyyyy);
		DateUtils.convertToString(dt, DateUtils.ddMMyyyy);
		String s = null;
		DateUtils.formatDate(s, DateUtils.ddMMyyyy);
		try {
			s = 'Hello World!';
			DateUtils.formatDate(s, DateUtils.ddMMyyyy);
		} catch (GenericException e) {}
		s = '01/01/2019';
		DateUtils.formatDate(s, DateUtils.ddMMyyyy);
		DateUtils.formatDate(d, DateUtils.ddMMyyyy);
		DateUtils.formatDate(dt, DateUtils.ddMMyyyy);
		DateUtils.convertToDate(s);

		DateUtils.getHowManyYears(d, Date.newInstance(2019,12,31));
		DateUtils.getHowManyYears(Date.newInstance(2019,12,31), d);

		DateUtils.getHowManyYears('01/01/2000');
		s = null;
		DateUtils.getHowManyYears(s);

		DateUtils.getHowManyMonths(d, Date.newInstance(2019,12,31));
		DateUtils.getHowManyMonths(Date.newInstance(2019,12,31), d);

		DateUtils.convertToDate(2019,0,1);
		DateUtils.convertToDate(2019,20,1);
		DateUtils.convertToDate(2019,1,1);
		
		DateUtils.getTotalTimeInMonths(Date.newInstance(2019,12,31), d);
		DateUtils.getTotalTimeInMonths(s, null);
		s = '01/01/2019';
		String z = '01/01/2019';
		DateUtils.getTotalTimeInMonths(s, null);
		DateUtils.getTotalTimeInMonths(null, s);
		DateUtils.getTotalTimeInMonths(s, '31/12/2019');

		DateUtils.getTimeForFileName();

		DateUtils.getDateOfWorkingDay(dt, null);
		DateUtils.getDateOfWorkingDay(dt, 10);

		DateUtils.isWeekend();

	}
		
}