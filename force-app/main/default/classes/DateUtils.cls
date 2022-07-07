public class DateUtils {

    public static final String ddMMyyyy = 'dd/MM/yyyy';
    public static final String ddMMYYYY_hhmmss = 'dd-MM-yyyy / hh:mm:ss';
    public static final String FORMAT_LOCAL_FULL = 'dd/MM/yyyy hh:mm a';
    public static final String YYYY_MM_DD = 'yyyy-MM-dd';
    public static final String hhmmss_sssZ = 'hh:mm:ss.sssZ';
    public static final String hhmmss = 'hh:mm:ss';
    public static final String FORMAT_QUERY = 'yyyy-MM-dd\'T\'HH:mm:ssZ';
    public static final String FORMAT_QUERY2 = 'yyyy-MM-dd\'T\'HH:mm:ss\'+1030\'';  //Adelaide time

    public static String convertToString (Date dDate, String sFormat){
        if (dDate != null && sFormat != null){
            Datetime dt = Datetime.newInstance(dDate.year(), dDate.month(), dDate.day());
			return dt.format(sFormat);
        }
        return '-';
    }
    
    public static String convertToString (DateTime dt, String sFormat){
        if (dt != null && sFormat != null){
			return dt.format(sFormat);
        }
        return '-';
    }
    
    public static String formatDate (String sDate, String sFormat){
        try{
            if (sDate != null && sFormat != null){
                Date d = Date.parse(sDate);
                Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day());
                return dt.format(sFormat);
            }
            return '-';
        }catch (Exception ex){
            throw new GenericException ('Invalid date: ' + sDate + '. Please check it and submit again.[dd/MM/yyyy]', ex);   
        }
    }
    
    public static String formatDate (Date d, String sFormat){
        if (d != null && sFormat != null){
            Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day());
            System.debug('formatDate: ' + d + '|' + dt + '|' + sFormat);
			return dt.format(sFormat);
        }
        return '-';
    }
    
    public static String formatDate (Datetime d, String sFormat){
        if (d != null && sFormat != null){
            return d.format(sFormat);
        }
        return '-';
    }

    public static Date convertToDate (String sDate){
        try{
            if (sDate != null){
            	return Date.parse(sDate);
            }
            return null;
        }catch (Exception ex){
            throw new GenericException ('Invalid date: ' + sDate + '. Please check it and submit again. [dd/MM/yyyy]', ex);   
        }
    }
    
    public static Integer getHowManyYears (Date dStart, Date dEnd){
        Integer monthStart = dStart.month();
        Integer monthEnd = dEnd.month();
        if (monthStart > monthEnd){
            return dEnd.year() - dStart.year() -1;
        }
        return dEnd.year() - dStart.year();
    }

    public static Integer getHowManyYears (String dStart){
        Date a = convertToDate(dStart);
        if (a != null) {
            return getHowManyYears(a, Date.today());
        }
        return 0;
    }
    
    public static Integer getHowManyMonths (Date dStart, Date dEnd){
        Integer monthStart = dStart.month();
        Integer monthEnd = dEnd.month();
        if (monthStart > monthEnd){
            return 12 - (monthStart - monthEnd);
        }
        return monthEnd - monthStart;
    }

    public static Date convertToDate (Integer y, Integer m, Integer d){ 
        Date r = Date.newInstance(y, m, d);
        if (r.month() != m) {
            r = null;
        }
        return r;
    }
    
    public static Decimal getTotalTimeInMonths (Date dStart, Date dEnd){
        Decimal timeInMonths = null;
        if (dStart != null && dEnd != null){
            Integer movedInYears = DateUtils.getHowManyYears(dStart, dEnd);
            Integer movedInMonths = DateUtils.getHowManyMonths(dStart, dEnd);
            timeInMonths = (movedInYears * 12) + movedInMonths;
        }
        return timeInMonths;
    }
    
    public static Decimal getTotalTimeInMonths (String dStart, String dEnd){
        if (dStart != null  && !StringUtils.isNullOrEmpty(dStart) 
           && dEnd != null  && !StringUtils.isNullOrEmpty(dEnd)){
            return getTotalTimeInMonths (DateUtils.convertToDate(dStart), DateUtils.convertToDate(dEnd));
        }
        return null;
    }

    public static String getTimeForFileName() {
        return Datetime.now().format('yyyyMMddHHmmss');
    }

    public static Map<String, Date> holidayDays = null;

    public static Datetime getDateOfWorkingDay (DateTime d, Integer howManyDaysToAdd){
        if (d == null || !(howManyDaysToAdd != null && howManyDaysToAdd >= 0)){
            return d;
        }
        
        if (holidayDays == null){
            List<Holiday_Days__c> holidays;
            holidays = Holiday_Days__c.getAll().values();
            holidayDays = new Map<String, Date>();
            for (Holiday_Days__c h : holidays){
                holidayDays.put(convertToString (h.Date__c, YYYY_MM_DD), h.Date__c);
            }
        }

        DateTime newDate = d;
        Integer i = 0;
        Integer countDays = 0;
        while (countDays!= howManyDaysToAdd){
            newDate = newDate + 1;
            i++;
            if (holidayDays.containsKey(convertToString(newDate, YYYY_MM_DD)) 
                || '6'.equalsIgnoreCase(newDate.format('u')) //Saturday
                || '7'.equalsIgnoreCase(newDate.format('u')) ){ //Sunday
                continue;
            }
            countDays++;
        }
        return newDate;
    }

    /*******************************************************************************************************
    * @author Lelo
    * @description format a date using a given pattern
    * @param sDate date to be formated, it must be a string type value
    * @param format pattern to format a given date
    * @return date in given format
    */
    public static String convertToDateToFormat (String sDate, String format){
      Date d = convertToDate(sDate);
      String r = null;
      if (d != null) {
        return convertToString(d, format);
      }
      return r;
    }

    /*******************************************************************************************************
    * @author Lelo
    * @description verify if today is weekend
    * @return true is the current day is Saturday or Sunday
    */
    public static Boolean isWeekend(){
      String d = Datetime.now().format('E');
      return 'Sat'.equalsIgnoreCase(d) || 'Sun'.equalsIgnoreCase(d);
    }
}