//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)
	
public class servicesFastrComAuData {
	public class Date_x {
		public Integer Day;
		public Integer Month;
		public Integer Year;
		private String[] Day_type_info = new String[]{'Day','http://services.fastr.com.au/Data','int','1','1','false'};
		private String[] Month_type_info = new String[]{'Month','http://services.fastr.com.au/Data','int','1','1','false'};
		private String[] Year_type_info = new String[]{'Year','http://services.fastr.com.au/Data','int','1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Data','true','false'};
		private String[] field_order_type_info = new String[]{'Day','Month','Year'};
	}
	public class FinanceDetails {
		public Decimal AmountFinanced;
		public Decimal BallonAmount;
		public Decimal FinanceInterestRate;
		public Integer FinanceTerm;
		public String FinanceType;
		public String FinancierId;
		public String FinancierName;
		private String[] AmountFinanced_type_info = new String[]{'AmountFinanced','http://services.fastr.com.au/Data','decimal','0','1','false'};
		private String[] BallonAmount_type_info = new String[]{'BallonAmount','http://services.fastr.com.au/Data','decimal','0','1','false'};
		private String[] FinanceInterestRate_type_info = new String[]{'FinanceInterestRate','http://services.fastr.com.au/Data','decimal','0','1','true'};
		private String[] FinanceTerm_type_info = new String[]{'FinanceTerm','http://services.fastr.com.au/Data','short','0','1','false'};
		private String[] FinanceType_type_info = new String[]{'FinanceType','http://services.fastr.com.au/Data','FinanceType','0','1','false'};
		private String[] FinancierId_type_info = new String[]{'FinancierId','http://services.fastr.com.au/Data','guid','0','1','true'};
		private String[] FinancierName_type_info = new String[]{'FinancierName','http://services.fastr.com.au/Data','string','0','1','true'};
		private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Data','true','false'};
		private String[] field_order_type_info = new String[]{'AmountFinanced','BallonAmount','FinanceInterestRate','FinanceTerm','FinanceType','FinancierId','FinancierName'};
	}
}