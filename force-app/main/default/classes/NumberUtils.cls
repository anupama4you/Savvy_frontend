public class NumberUtils {
  public static Decimal convertToDecimal(String value, Boolean isNullable) {
    Decimal r = 0;
    Decimal tmp = 0;
    if (String.isNotBlank(value)) {
      String n = value.remove('$').remove(',').remove(' ');
      try {
        r += Decimal.valueOf(n);
      } catch (Exception ignore) {
        if (isNullable) {
          r = null;
        }
      }
    } else {
      if (isNullable) {
        r = null;
      }
    }
    return r;
  }

  public static Decimal convertDecimalToScale(Decimal value, Integer scale) {
    if (value != null) {
      return value.setScale(scale);
    }
    return null;
  }

  public static Decimal convertStringToDecimal(String value, Integer scale) {
    if (value != null) {
      Decimal v = convertToDecimal(value, false);
      if (v != null) {
        return v.setScale(scale);
      }
    }
    return null;
  }

  public static Decimal convertToDecimal(Decimal value) {
    if (value == null) {
      return 0;
    }
    return value;
  }

  public static Decimal convertToDecimal(Decimal value, Integer scale) {
    return convertToDecimal(value).setScale(scale);
  }

  public static String formatCounter(Integer c, Integer length) {
    if (String.valueOf(c).length() < length) {
      return '0' + formatCounter(c, length - 1);
    }
    return String.valueOf(c);
  }

  public static Integer convertToInteger(Decimal value) {
    if (value == null) {
      return 0;
    }
    return value.intValue();
  }

  public static String intToString(Decimal value) {
    return value != null ? String.valueOf(value.intValue()) : '0';
  }

  public static String format(Decimal value) {
    String r = null;
    if (value != null) {
      r = value.format();
      String[] v = r.split('\\.');
      if (v.size() == 2 && v.get(1).length() == 1) {
        r = r + '0';
      } else if (v.size() == 1) {
        r = r + '.00';
      }
    }
    return r;
  }
}