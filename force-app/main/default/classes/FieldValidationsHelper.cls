public class FieldValidationsHelper {
	
    private static Pattern datePattern = Pattern.compile(
        '^(?:(?:31(\\/|-|\\.)(?:0?[13578]|1[02]))\\1|(?:(?:29|30)(\\/|-|\\.)(?:0?[1,3-9]|1[0-2])\\2))(?:(?:1[6-9]|[2-9]\\d)?\\d{2})$|' + 
        '^(?:29(\\/|-|\\.)0?2\\3(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|' + 
        '^(?:0?[1-9]|1\\d|2[0-8])(\\/|-|\\.)(?:(?:0?[1-9])|(?:1[0-2]))\\4(?:(?:1[6-9]|[2-9]\\d)?\\d{2})$'
    );

    private static Pattern decimalPattern = Pattern.compile('\\d+|\\d+\\.\\d+');

    public static boolean isContainsValidCharacters(String value) {
        if (value == null || String.isBlank(value) || String.isBlank(value.deleteWhitespace()) || String.isBlank(value.remove('.'))) {
            return false;
        }
        return true;
    }
    
    public static boolean isContainsValidCharacters(Decimal value) {
        if (value == null) {
            return false;
        }
        return true;
    }

    public static boolean isDateFormatValid(String value) {
   		return isInternalDateFormatValidation(value, false);
    }
    
    public static boolean isDateFormatValidOptional(String value) {
        return isInternalDateFormatValidation(value, true);
    }
	
    public static boolean isValueGreaterThanZero(String value) {
        boolean r = false;
        if (value != null) {
            try {
                Decimal d = Decimal.valueOf(value);
                if (d > 0) {
                    r = true;
                }
            } catch (Exception e) {}
        }
        return r;
    }

    public static boolean isDecimalGreaterThanZero(Decimal value) {
        boolean r = false;
        if (value != null && value > 0) {
            r = true;
        }
        return r;
    }

    private static boolean isInternalDateFormatValidation(String value, boolean optional) {
        return isFormatValid(datePattern, value, optional);
    }
    

    public static Integer getYearsBetween(Date d) {
        Integer r = null;
        if (d != null) {
            r = d.monthsBetween(Date.today()) / 12;
        }
        return r;
    }

    public static Integer getYearsBetween(String d) {
        if (!isInternalDateFormatValidation(d, false)) {
            return null;
        }
        Date t = Date.parse(d);
        return getYearsBetween(t);
    }

    public static Integer getMonthsBetween(Date d) {
        Integer r = null;
        if (d != null) {
            r = d.monthsBetween(Date.today());
        }
        return r;
    }

    public static Integer getMonthsBetween(String d) {
        if (!isInternalDateFormatValidation(d, false)) {
            return null;
        }
        Date t = Date.parse(d);
        return getMonthsBetween(t);
    }

    public static Decimal getYearsBetween(List<Date> startDate, List<Date> finishDate) {
        Decimal r = 0.0;
        if (startDate == null || startDate.isEmpty() || 
            finishDate == null || finishDate.isEmpty() ||
            startDate.size() != finishDate.size()) {
            return r;
        }
        /*
        Integer totalDays = 0;
        for (Integer i = 0; i < startDate.size();i++) {
            Date d1 = startDate.get(i);
            Date d2 = finishDate.get(i);

            if (d1 != null && d2 != null) {
                totalDays += Math.abs(d1.daysBetween(d2));
            }
            System.debug('getYearsBetween(' + i + ') ' + d1 + '|' + d2 + '|' + totalDays);
        }
        */
        startDate.sort();
        Integer totalDays = Math.abs(startDate.get(0).daysBetween(Date.today()));
        r = Decimal.valueOf(totalDays) / 365.0;
        System.debug('getYearsBetween: ' + startDate.get(0) + '|' + Date.today() + '|' + totalDays + '|' + r);
        return r;
    }

    public static Date convertDate(String d) {
        if (!isInternalDateFormatValidation(d, false)) {
            return null;
        }
        return Date.parse(d);
    }

    public static Decimal getMonthsBetween(Date d1, Date d2) {
        Decimal r = null;
        if (d1 != null && d2 != null) {
            r = Math.abs(d1.daysBetween(d2) / 30.0);
        }
        return r;
    }

    public static boolean isDecimalFormatValid(String value) {
        return isDecimalFormatValid(value, false);
    }

    private static boolean isDecimalFormatValid(String value, boolean optional) {
        return isFormatValid(decimalPattern, value, optional);
    }

    private static boolean isFormatValid(Pattern formatPattern, String value, boolean optional) {
        if (value == null) {
            if (optional) {
                return true;
            } else {
                return false;
            }
        }
        Matcher m = formatPattern.matcher(value);
        return m.matches();
    }
}