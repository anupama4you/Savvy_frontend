public with sharing class NPSReportHelper {
   
    public class Parameter {
		
        public Integer month {set;get;}
        public Integer year {set;get;}
        public String UserName {set;get;}
        public String UserId {set;get;}  
        public String DateBegin {set;get;}
        public String DateToday {set;get;}
        public String customRange {set;get;}

        public Parameter(){            
        }
	}
   
    public class Result {
        
        public String sdate {set;get;}
        public String name {set; get;}
        public String id {set;get;}
        public String loan_Type {set;get;}
        public Integer fback {set;get;}
        public Integer promoter {set;get;}
        public Integer pasive {set;get;}
        public Integer detractor {set;get;}
        public Integer nps {set;get;}   
        
        public Integer tfback {set;get;}
        public Integer tpromoter {set;get;}
        public Integer tpasive {set;get;}
        public Integer tdetractor {set;get;}
       
        public Decimal ppromoter {set;get;}
        public Decimal ppasive {set;get;}
        public Decimal pdetractor {set;get;}
        public Decimal pnps {set;get;}
        
        public Integer tnps {set;get;}   
        public Decimal porpromoter {set;get;}
        public Decimal tppromoter {set;get;}
        public Decimal tppasive {set;get;}
        public Decimal tpdetractor {set;get;}
        public Decimal tpnps {set;get;}
        public String fecha;
        
        public Result () {
            this.fback = 0;
            this.promoter = 0;
            this.pasive = 0;
            this.detractor = 0;
            
            this.tfback = 0;
            this.tpasive = 0;
            this.tdetractor = 0;
            this.tpromoter = 0;
            
            this.ppromoter = 0.00;
            this.ppasive = 0.00;
            this.pdetractor = 0.00;
            this.pnps = 0.00;
            
            this.tppromoter = 0.00;
            this.tppasive = 0.00;
            this.tpdetractor = 0.00;
            this.tpnps = 0.00;
            
            
        }
        
        public Integer getNpsscore(Integer prm, Integer det){
           return (prm - det);
        }
        public Decimal getPorcent(Decimal total, Decimal partial){
            Decimal e = partial * 100;
            Decimal v = e.divide(total, 2);
           return v;
        }
        
    }  
}