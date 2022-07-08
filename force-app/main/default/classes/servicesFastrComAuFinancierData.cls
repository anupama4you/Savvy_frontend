//Generated by wsdl2apex

public class servicesFastrComAuFinancierData {
    public class RetrieveFinanciersResponse {
        public servicesFastrComAuFinancierData.ArrayOfFinancier Financiers;
        private String[] Financiers_type_info = new String[]{'Financiers','http://services.fastr.com.au/Financier/Data',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Financier/Data','true','false'};
        private String[] field_order_type_info = new String[]{'Financiers'};
    }
    public class Financier {
        public String Id;
        public String Name;
        private String[] Id_type_info = new String[]{'Id','http://services.fastr.com.au/Financier/Data',null,'1','1','false'};
        private String[] Name_type_info = new String[]{'Name','http://services.fastr.com.au/Financier/Data',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Financier/Data','true','false'};
        private String[] field_order_type_info = new String[]{'Id','Name'};
    }
    public class ArrayOfFinancier {
        public servicesFastrComAuFinancierData.Financier[] Financier;
        private String[] Financier_type_info = new String[]{'Financier','http://services.fastr.com.au/Financier/Data',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Financier/Data','true','false'};
        private String[] field_order_type_info = new String[]{'Financier'};
    }
}