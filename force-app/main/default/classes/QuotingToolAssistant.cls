public class QuotingToolAssistant {
    public class CalcParam {
        public String lender { get; set; }
        
        public Decimal totalAmount { get; set; }
        public Decimal totalInsurance { get; set; }
        public Decimal totalInsuranceIncome { get; set; }
        public Decimal clientRate { get; set; }
        public Decimal baseRate { get; set; }
        public String paymentType { get; set; }
        public Decimal term { get; set; }
        public Decimal dof { get; set; }
        public Decimal monthlyFee { get; set; }
        public Decimal docFees { get; set; }
        public Decimal residualValue { get; set; }
        public Decimal brokeragePer { get; set; }
        //Pepper / Liberty
        public Decimal commRate { get; set; }
        //Macquarie
        public Decimal amountBasePmt { get; set; }
        public Decimal amountBaseComm { get; set; }
        //Finance One
        public Decimal nafCommission { get; set; }
        //Liberty Options
        public Decimal riskFeeBase { get; set; }
        public String ltv { get; set; }
        public String customerProfile { get; set; }
        public String adverseCredit { get; set; } //Y / N
        public String clientTier { get; set; }
        public String loanType { get; set; }
        public String loanTypeDetail { get; set; }
        public String productLoanType { get; set; }
        public Integer carAge { get; set; }
        public String assetType { get; set; }
        public String privateSales { get; set; }
        public String saleBacksPurchased { get; set; } //Metro
        public String goodsType { get; set; } //Anz Others
        public String goodsSubType { get; set; } //Macquarie
        public String vehiclesProfile { get; set; } //Anz Others
        public String condition { get; set; } //Anz Consumer: New/Demo or Used
        public String vehicleYear { get; set; } //Macquarie
        public String lpiLevel { get; set; } //Liberty LPI
        public String state { get; set; } //Liberty LPI
        public Integer vedascore { get; set; } //Wisr
        public String greenCar { get; set; } //firstmac
        public String riskGrade { get; set; } // AFS
        public String bankrupt { get; set; } // AFS
        public String residency { get; set; } // AFS
        public Decimal maxRate { get; set; }
        public String hasDefault { get; set; }
        public String hasImports { get; set; }
        public Decimal rental { get; set; }
        public Decimal vehiclePrice { get; set; }
        public Decimal commBonus { get; set; }
        public String commType { get; set; }
        public Decimal commPayable { get; set; }
        
        public CalcParam(String lender) {
            this.lender = lender;
            this.totalAmount = 0.0;
            this.totalInsurance = 0.0;
            this.totalInsuranceIncome = 0.0;
            this.clientRate = 0.0;
            this.baseRate = 0.0;
            this.term = 0.0;
            this.dof = 0.0;
            this.monthlyFee = 0.0;
            this.docFees = 0.0;
            this.residualValue = 0.0;
            this.brokeragePer = 0.0;
            this.commRate = 0.0;
            this.amountBasePmt = 0.0;
            this.amountBaseComm = 0.0;
            this.nafCommission = 0.0;
            this.carAge = 0;
            this.riskFeeBase = 0.0;
            this.vedascore = 0;
            this.greenCar = 'N';
            this.rental = 0.0;
            this.commBonus = 0.0;
        }
        
        /*public Decimal getNaf() {
            Decimal r = 0.0;
            if (this.totalAmount != null)
                r += this.totalAmount;
            if (this.totalInsurance != null)
                r += this.totalInsurance;
            return r;
        }*/
        
        public Boolean getPaymentTypeBoolean() {
          return 'Advance'.equals(paymentType); 
        }
    }
    
    public static List<SelectOption> getLoanTypeOptions(String LENDER_QUOTING) {
        List<SelectOption> r = new List<SelectOption> ();
        if(LENDER_QUOTING == 'Shift Asset' || LENDER_QUOTING == 'Selfco' || LENDER_QUOTING == 'Commercial Equity Group'){
            r.add(new SelectOption ('Purchase', 'Purchase'));
            r.add(new SelectOption ('Refinance', 'Refinance'));
            r.add(new SelectOption ('Sale and Leaseback', 'Sale and Leaseback'));
            r.add(new SelectOption ('Equity Raise', 'Equity Raise'));
        }else if(LENDER_QUOTING == 'Shift ODR' || LENDER_QUOTING == 'Grow Business Loan'){
            r.add(new SelectOption ('Term Loan', 'Term Loan'));
        }else if(LENDER_QUOTING == 'Grow Asset'){
            r.add(new SelectOption ('Full Doc', 'Full Doc'));
            r.add(new SelectOption ('Low Doc', 'Low Doc'));
            r.add(new SelectOption ('Easy Doc', 'Easy Doc'));
        }else if(LENDER_QUOTING == 'Angle Finance'){
            r.add(new SelectOption ('Purchase', 'Purchase')); 
        }else if(LENDER_QUOTING == 'Morris'){
            r.add(new SelectOption ('Purchase', 'Purchase')); 
            r.add(new SelectOption ('Refinance', 'Refinance'));
            r.add(new SelectOption ('Sale and Leaseback', 'Sale and Leaseback'));
        }else if(LENDER_QUOTING == 'Silver Chef'){
            r.add(new SelectOption ('Rental', 'Rental')); 
        }else if(LENDER_QUOTING == 'Capital Finance'){
            r.add(new SelectOption ('Purchase', 'Purchase'));
            r.add(new SelectOption ('Refinance', 'Refinance'));
            r.add(new SelectOption ('Sale and Leaseback', 'Sale and Leaseback'));
            r.add(new SelectOption ('Novated Lease', 'Novated Lease'));
            r.add(new SelectOption ('Small Ticket', 'Small Ticket'));
        }else if(LENDER_QUOTING == 'Group and General'){
            r.add(new SelectOption ('Chattel Mortgage', 'Chattel Mortgage'));
            r.add(new SelectOption ('Replacement loan', 'Replacement loan'));
            r.add(new SelectOption ('Courier/Uber', 'Courier/Uber'));
        }
        return r;
    }
    
    public static List<SelectOption> getassetTypeOptions(String LENDER_QUOTING) {
        List<SelectOption> r = new List<SelectOption> ();
        if(LENDER_QUOTING == 'Shift Asset'){
            r.add(new SelectOption ('Primary Assets', 'Primary Assets'));
            r.add(new SelectOption ('Secondary Assets', 'Secondary Assets'));
            r.add(new SelectOption ('Tertiary assets', 'Tertiary assets'));
            r.add(new SelectOption ('Fitout Finance', 'Fitout Finance'));
        }else if(LENDER_QUOTING == 'Grow Asset'){
            //r.add(new SelectOption ('Auto', 'Auto'));
            //r.add(new SelectOption ('Cars/Vans/Utes', 'Cars/Vans/Utes'));
          r.add(new SelectOption ('Tier 1 - Cars', 'Tier 1 - Cars'));
          r.add(new SelectOption ('Tier 2 - Trucks yellow goods', 
            'Tier 2 - Trucks yellow goods'));
          r.add(new SelectOption ('Tier 3 - Specialised', 'Tier 3 - Specialised'));
        }else if(LENDER_QUOTING == 'Morris'){
            r.add(new SelectOption ('Motor Vehicle', 'Motor Vehicle')); 
            r.add(new SelectOption ('Trucks/Yellow/Buses/Trailers/Caravans', 'Trucks/Yellow/Buses/Trailers/Caravans')); 
        }else if(LENDER_QUOTING == 'Selfco'){
            r.add(new SelectOption ('Tier 1 - Auto', 'Tier 1 - Auto'));
             r.add(new SelectOption ('Tier 2 - Trucks/Medical equip', 'Tier 2 - Trucks/Medical equip'));
             r.add(new SelectOption ('Tier 3 - Office /IT/Solar', 'Tier 3 - Office /IT/Solar'));
             r.add(new SelectOption ('Tier 4 - Fitouts', 'Tier 4 - Fitouts'));
        }else if(LENDER_QUOTING == 'Silver Chef'){  
            r.add(new SelectOption ('Kitchen equipment', 'Kitchen equipment'));
        }else if(LENDER_QUOTING == 'Capital Finance'){
            r.add(new SelectOption ('MV < 4.5T', 'MV < 4.5T'));
            r.add(new SelectOption ('Trucks/Agri/Yellow goods', 'Trucks/Agri/Yellow goods'));
        }else if(LENDER_QUOTING == 'Fleet Partners'){
            r.add(new SelectOption ('Motor Vehicle','Motor Vehicle'));
            r.add(new SelectOption ('Trucks/Yellow/Buses/Trailers/Caravans', 'Trucks/Yellow/Buses/Trailers/Caravans'));
         }else if(LENDER_QUOTING == 'Group and General'){
             r.add(new SelectOption ('Cars/Vans/Utes', 'Cars/Vans/Utes'));
             r.add(new SelectOption ('Trucks/Trailers', 'Trucks/Trailers'));
             r.add(new SelectOption ('Yellow goods', 'Yellow goods'));
         }else if(LENDER_QUOTING == 'Angle Finance'){
           r.add(new SelectOption ('MV & Primary', 'MV & Primary'));
           r.add(new SelectOption ('Secondary', 'Secondary'));
           r.add(new SelectOption ('Tertiary', 'Tertiary'));
         }
        return r;
    }
    
    public static List<SelectOption> gettermOptions(String LENDER_QUOTING) {
        List<SelectOption> r = new List<SelectOption> ();
        if(LENDER_QUOTING == 'Shift Asset' || LENDER_QUOTING == 'Grow Asset' || LENDER_QUOTING == 'Morris' || LENDER_QUOTING == 'Selfco'
          || LENDER_QUOTING =='Silver Chef' || LENDER_QUOTING =='Capital Finance' || LENDER_QUOTING == 'Commercial Equity Group'
          || LENDER_QUOTING == 'Group and General'){
            r.add(new SelectOption ('0', '0'));
            r.add(new SelectOption ('12', '12'));
            r.add(new SelectOption ('24', '24'));
            r.add(new SelectOption ('36', '36'));
            r.add(new SelectOption ('48', '48'));
            r.add(new SelectOption ('60', '60'));
          if (LENDER_QUOTING == 'Grow Asset') {
            r.add(new SelectOption ('72', '72'));
            r.add(new SelectOption ('84', '84'));
          }
        }else if(LENDER_QUOTING == 'Shift ODR'){
            r.add(new SelectOption ('0', '0'));
            r.add(new SelectOption ('12', '12'));
            r.add(new SelectOption ('24', '24'));
        }else if(LENDER_QUOTING == 'Angle Finance'){
            r.add(new SelectOption ('36', '36'));
            r.add(new SelectOption ('48', '48'));
            r.add(new SelectOption ('60', '60'));
        }
        return r;
    }
    
    public static List<SelectOption> getabnLengthOptions(String LENDER_QUOTING) {
        List<SelectOption> r = new List<SelectOption> ();
        if(LENDER_QUOTING == 'Shift Asset' || LENDER_QUOTING == 'Grow Business Loan' || LENDER_QUOTING == 'Capital Finance'
          || LENDER_QUOTING == 'Group and General'){
            r.add(new SelectOption ('< 2 years', '< 2 years'));
            r.add(new SelectOption ('> 2 years', '> 2 years'));
        }else if(LENDER_QUOTING == 'Shift ODR'){
            r.add(new SelectOption ('> 1 years', '> 1 years'));
            r.add(new SelectOption ('> 3 years', '> 3 years'));
        }else if(LENDER_QUOTING == 'Grow Asset' || LENDER_QUOTING == 'Selfco'){
            r.add(new SelectOption ('> 12 months', '> 12 months'));
            r.add(new SelectOption ('> 24 months', '> 24 months'));
            //r.add(new SelectOption ('> 36 months', '> 36 months'));
        }else if(LENDER_QUOTING == 'Angle Finance'){
            /*r.add(new SelectOption ('ABN < 2 years,  GST < 1 year', 'ABN < 2 years,  GST < 1 year'));
            r.add(new SelectOption ('ABN 0-2 years,  GST > 1 year', 'ABN 0-2 years,  GST > 1 year'));
            r.add(new SelectOption ('ABN 2 years,  GST < 1 year', 'ABN 2 years,  GST < 1 year'));
            r.add(new SelectOption ('ABN 2 years,  GST > 1 year', 'ABN 2 years,  GST > 1 year'));
            r.add(new SelectOption ('ABN 5 years, GST > 3 years', 'ABN 5 years, GST > 3 years'));*/
            r.add(new SelectOption ('ABN 0-2','ABN 0-2'));
            //r.add(new SelectOption ('ABN 1-2','ABN 1-2'));
            r.add(new SelectOption ('ABN 2+','ABN 2+'));
            r.add(new SelectOption ('ABN no GST','ABN no GST'));
        }else if(LENDER_QUOTING == 'Morris'){
            r.add(new SelectOption ('> 12 months', '> 12 months'));
            r.add(new SelectOption ('< 12 months', '< 12 months'));
        }else if(LENDER_QUOTING == 'Fleet Partners'){
            r.add(new SelectOption ('> 24 months', '> 24 months'));
        }
        return r;
    }
    
    public static List<SelectOption> getgstLengthOptions(String LENDER_QUOTING) {
        List<SelectOption> r = new List<SelectOption> ();
        if(LENDER_QUOTING == 'Shift Asset' || LENDER_QUOTING == 'Grow Asset' || LENDER_QUOTING == 'Grow Business Loan' || LENDER_QUOTING == 'Selfco'){
            r.add(new SelectOption ('', 'No GST'));
            r.add(new SelectOption ('< 2 years', '< 2 years'));
            r.add(new SelectOption ('> 2 years', '> 2 years'));
        }else if(LENDER_QUOTING == 'Morris' || LENDER_QUOTING == 'Group and General' ){
            r.add(new SelectOption ('N', 'No'));
            r.add(new SelectOption ('Y', 'Yes'));
        }else if(LENDER_QUOTING == 'Capital Finance'){
            r.add(new SelectOption ('', 'No GST'));
            r.add(new SelectOption ('> 1 day', '> 1 day'));
        }else if(LENDER_QUOTING == 'Fleet Partners'){
            r.add(new SelectOption ('> 24 months', '> 24 months'));
        }
        return r;
    }
    
    public static List<SelectOption> getassetAgeOptions(String LENDER_QUOTING) {
        List<SelectOption> r = new List<SelectOption> ();
        if(LENDER_QUOTING == 'Shift Asset'){
            r.add(new SelectOption ('New to 4 years', 'New to 4 years'));
            r.add(new SelectOption ('5 - 10 years', '5 - 10 years'));
            r.add(new SelectOption ('11+ years', '11+ years'));
            r.add(new SelectOption ('20+ years (age and term)', '20+ years'));
        }else if(LENDER_QUOTING == 'Grow Asset' || LENDER_QUOTING == 'Selfco'){
            r.add(new SelectOption ('1', '1'));
            r.add(new SelectOption ('2', '2'));
            r.add(new SelectOption ('3', '3'));
            r.add(new SelectOption ('4', '4'));
            r.add(new SelectOption ('5', '5'));
            r.add(new SelectOption ('6', '6'));
            r.add(new SelectOption ('7', '7'));
            r.add(new SelectOption ('8', '8'));
            r.add(new SelectOption ('9', '9'));
            r.add(new SelectOption ('10', '10'));
            r.add(new SelectOption ('11', '11'));
            r.add(new SelectOption ('12', '12'));
            r.add(new SelectOption ('13', '13'));
            r.add(new SelectOption ('14', '14'));
            r.add(new SelectOption ('15', '15'));
            r.add(new SelectOption ('16', '16'));
            r.add(new SelectOption ('17', '17'));
            r.add(new SelectOption ('18', '18'));
            r.add(new SelectOption ('19', '19'));
            r.add(new SelectOption ('20', '20'));
            r.add(new SelectOption ('21', '21'));
            r.add(new SelectOption ('22', '22'));
            r.add(new SelectOption ('23', '23'));
            r.add(new SelectOption ('24', '24'));
        }else if(LENDER_QUOTING == 'Angle Finance' || LENDER_QUOTING == 'Morris'){
            r.add(new SelectOption ('1', '1'));
            r.add(new SelectOption ('2', '2'));
            r.add(new SelectOption ('3', '3'));
            r.add(new SelectOption ('4', '4'));
            r.add(new SelectOption ('5', '5'));
            r.add(new SelectOption ('6', '6'));
            r.add(new SelectOption ('7', '7'));
            r.add(new SelectOption ('8', '8'));
            r.add(new SelectOption ('9', '9'));
            r.add(new SelectOption ('10', '10'));
            r.add(new SelectOption ('11', '11'));
            r.add(new SelectOption ('12', '12'));
            r.add(new SelectOption ('13', '13'));
            r.add(new SelectOption ('14', '14'));
            r.add(new SelectOption ('15', '15'));
            r.add(new SelectOption ('16', '16'));
            r.add(new SelectOption ('17', '17'));
            r.add(new SelectOption ('18', '18'));
            r.add(new SelectOption ('19', '19'));
        }else if(LENDER_QUOTING == 'Capital Finance'){
            r.add(new SelectOption ('New - 4 years', 'New - 4 years'));
            r.add(new SelectOption ('> 4 years', '> 4 years'));
            r.add(new SelectOption ('> 6 years', '> 6 years'));
        }else if(LENDER_QUOTING == 'Fleet Partners'){
            r.add(new SelectOption ('New/Demo','New/Demo'));
        }
        return r;
    }
    
    public static List<SelectOption> getpropertyOwnerOptions(String LENDER_QUOTING) {
        List<SelectOption> r = new List<SelectOption> ();
        if(LENDER_QUOTING == 'Shift Asset'){
            //r.add(new SelectOption ('', '--None--'));
            r.add(new SelectOption ('N', 'No'));
            r.add(new SelectOption ('Y', 'Yes'));
            
        }
        return r;
    }
    
    public static List<SelectOption> getprivateSalesOptions(String LENDER_QUOTING) {
        List<SelectOption> r = new List<SelectOption> ();
        if(LENDER_QUOTING == 'Shift Asset'){
            //r.add(new SelectOption ('', '--None--'));
            r.add(new SelectOption ('N', 'No'));
            r.add(new SelectOption ('Y', 'Yes'));
        }
        return r;
    }
    
    public static List<SelectOption> getpaymentTypeOptions(String LENDER_QUOTING) {
        List<SelectOption> r = new List<SelectOption> ();
        if(LENDER_QUOTING == 'Shift Asset' || LENDER_QUOTING == 'Grow Asset'){
            r.add(new SelectOption ('Advance', 'Advance'));
        }else if(LENDER_QUOTING == 'Morris'){
            r.add(new SelectOption ('Arrears', 'Arrears'));
        }else if(LENDER_QUOTING == 'Selfco' || LENDER_QUOTING == 'Capital Finance'){
            r.add(new SelectOption ('Arrears', 'Arrears'));
            r.add(new SelectOption ('Advance', 'Advance'));
        }else if(LENDER_QUOTING == 'Silver Chef' || LENDER_QUOTING == 'Commercial Equity Group' || LENDER_QUOTING == 'Group and General'){
            r.add(new SelectOption ('', 'None'));
        }else if(LENDER_QUOTING == 'Angle Finance'){
          r.add(new SelectOption ('Arrears', 'Arrears'));
          r.add(new SelectOption ('Advance', 'Advance'));
        }
        return r;
    }
    
    public static List<SelectOption> getproductTypeOptions(String LENDER_QUOTING) {
        List<SelectOption> r = new List<SelectOption> ();
        if(LENDER_QUOTING == 'Morris'){
            r.add(new SelectOption ('Streamline', 'Streamline'));
            r.add(new SelectOption ('Primary or Premium', 'Primary or Premium'));
        }
        return r;
    }
    
    public static List<SelectOption> gettierOptions(String LENDER_QUOTING) {
        List<SelectOption> r = new List<SelectOption> ();
        if(LENDER_QUOTING == 'Selfco'){
            r.add(new SelectOption ('A', 'A'));
            r.add(new SelectOption ('B', 'B'));
            r.add(new SelectOption ('C', 'C'));
        }
        return r;
    }
    
    public static List<SelectOption> getloanProductOptions(String LENDER_QUOTING) {
        List<SelectOption> r = new List<SelectOption> ();
        if(LENDER_QUOTING == 'Commercial Equity Group'){
            r.add(new SelectOption ('Low Doc', 'Low Doc'));
            r.add(new SelectOption ('Full Doc', 'Full Doc'));
        }
        return r;
    }

}