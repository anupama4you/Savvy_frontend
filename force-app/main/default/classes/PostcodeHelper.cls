public class PostcodeHelper {
	
	public static final String NSW = 'NSW';
	public static final String VIC = 'VIC';
	public static final String QLD = 'QLD';
	public static final String SA = 'SA';
	public static final String WA = 'WA';
	public static final String TAS = 'TAS';
	public static final String ACT = 'ACT';
	public static final String NT = 'NT';

	public static String getState(String postcode) {
		String r = null;
		if (String.isBlank(postcode)) return r;

		String p = postcode.trim();
		Integer postNum = 0;
		if (p.isNumeric()) {
			postNum = Integer.valueOf(p);
		}

		//NSW
		if ((postNum >= 1000 && postNum <= 2599)  || 
		    (postNum >= 2620 && postNum <= 2899)  ||
		    (postNum >= 2921 && postNum <= 2999)) {
			r = NSW;
		} else if ((postNum >= 3000 && postNum <= 3999)  ||
			       (postNum >= 8000 && postNum <= 8999)) {
			r = VIC;
		} else if ((postNum >= 4000 && postNum <= 4999)  ||
			       (postNum >= 9000 && postNum <= 9999)) {
			r = QLD;
		} else if (postNum >= 5000 && postNum <= 5999) {
			r = SA;
		} else if (postNum >= 6000 && postNum <= 6999) {
			r = WA;
		} else if (postNum >= 7000 && postNum <= 7999) {
			r = TAS;
		} else if (postNum >= 800 && postNum <= 999) {
			r = NT;
		} else if ((postNum >= 200 && postNum <= 299)  || 
			       (postNum >= 2600 && postNum <= 2619)  ||
			       (postNum >= 2900 && postNum <= 2920)) {
			r = ACT;
		}

		return r;
	}

	public static String getTimezone(String state) {
		String r = null;
		if (NSW.equals(state) || ACT.equals(state)) {
			r = 'Australia/Sydney';
		} else if (QLD.equals(state)) {
			r = 'Australia/Brisbane';
		} else if (VIC.equals(state) || TAS.equals(state)) {
			r = 'Australia/Melbourne';
		} else if (SA.equals(state) || NT.equals(state)) {
			r = 'Australia/Adelaide';
		} else if (WA.equals(state)) {
			r = 'Australia/Perth';
		}
		return r;
	}

}