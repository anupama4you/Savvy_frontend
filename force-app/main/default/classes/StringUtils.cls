public class StringUtils {

  public static String validateNull (String value){
    if (value != null){
      return value.trim();
    }
    return '';
  }

  public static String convertToString (Object obj){
    if (obj != null){
      return String.valueOf(obj).trim();
    }
    return null;
  }
  
  public static Boolean isNullOrEmpty (String value){
    if (value != null && !value.trim().equalsIgnoreCase('')){
      return false;
    }
    return true;
  }

  public static String removeSpaces (String value){
    if (value != null){
      return value.remove(' ');
    }
    return null;
  }

  public static String getFrequencyType(String value, String defaultValue) {
    String r = null;
    if (value != null) {
      if ('Monthly'.equalsIgnoreCase(value)) {
        r = 'Monthly';
      } else if ('Fortnightly'.equalsIgnoreCase(value)) {
        r = 'Fortnightly';
      }  else if ('Weekly'.equalsIgnoreCase(value)) {
        r = 'Weekly';
      } else if ('Yearly'.equalsIgnoreCase(value)) {
        r = 'Yearly';
      }
    } else {
      r = defaultValue;
    }
    return r;
  }
  
  public static String removeAllCharacters (String s){
    if (StringUtils.isNullOrEmpty(s)){
      return '';
    }
    return s.replaceAll('[^\\d.]', '');
  }

  public static String getLocalPhoneFormat(String phone) {
    if (String.isBlank(phone)) return null;
    String r = phone;
    String a = '';
    if (r.startsWith('+61')) {
      a = '+61';
    } else if (r.startsWith('61')) {
      a = '61';
    }
    if (String.isNotBlank(a)) {
      r = r.removeStart(a);
      r = '0' + r;
    }
    return r;
  }

  public static Boolean isTestData(String value) {
    Boolean r = false;
    if (String.isNotBlank(value) && 'Test'.equalsIgnoreCase(value)) {
      r = true;
    }
    return r;
  }

  public static String convertToInt(String value) {
    String a = validateNull(value);
    if (String.isNotBlank(a)) {
      try {
        return String.valueOf(Decimal.valueOf(a).intValue());
      } catch(Exception e) {
        System.debug('Cannot convert to integer '+value);
      }
    }
    return '0';
  }

  public static String maxLength(String value, Integer maxChars) {
    return (
      String.isNotBlank(value) &&
      maxChars > 0 &&
      value.length() > maxChars 
        ? value.substring(0, maxChars)
        : value
    );
  }

  public static String convertToString(List<String> values) {
    if (values == null) return null;
    String r = '';
    for (String v: values) {
      String x = v.trim();
      if (String.isNotBlank(x)) {
        if (String.isNotBlank(r)) r += ',';
        r += x;
      }
    }
    return r;
  }
}