public virtual class NPSReportController {
    String userId = null;
    String status = 'Settled';
    String OPP_SOQL = 'SELECT OwnerId, NPS__c, Status__c, Date_Closed_or_Settled__c, Lead_Loan_Type__c'+ 
                    ' FROM Custom_Opportunity__c ';
    String wh = ' Status__c = :status ' + ' AND NPS__c != Null';
    String whdate = ' AND Date_Closed_or_Settled__c = LAST_N_DAYS:30';
    String whUser = ' AND OwnerId = :userId';
    String whOrder = ' ORDER BY Date_Closed_or_Settled__c  ASC';
    String sql = '';
    public String rangedate {get; set;}
    public Date datbeg {get;set;}
    public Date datend {get;set;}

    List<Custom_Opportunity__c> squery;
    List<Custom_Opportunity__c> squeryAdmin;
    List<Custom_Opportunity__c> squeryService;
    public NPSReportHelper.Result total {set;get;}
   
    public NPSReportHelper.Parameter param {set;get;}

  public NPSReportController() {
    init();
  }
/*
  public NPSReportController(Integer reportType) {
    init(reportType);
  }
    */

  public void init() {
        //this.rangedate = '1';
        this.total = new NPSReportHelper.Result();
        param = new NPSReportHelper.Parameter();
        
        userId = System.currentPageReference().getParameters().get('UID');
        String sDatbeg = System.currentPageReference().getParameters().get('datbeg');
        String sDatend = System.currentPageReference().getParameters().get('datend');

        this.rangedate = '1';
        this.datbeg = DateTime.now().date() - 30;
        this.datend = DateTime.now().date();

        if (sDatbeg != null && sDatend != null){
            this.datbeg = DateUtils.convertToDate(sDatbeg);
            this.datend = DateUtils.convertToDate(sDatend);
            this.rangedate = '2';
        }

        if (userId == null) { 
            userId = UserInfo.getUserID();
        }
        this.whUser = ' AND OwnerId = :userId';

        User currentUser = [SELECT id, Name FROM User WHERE Id = :userId];
        param.UserName = currentUser.Name;

        param.month = Date.today().month();
        param.year = Date.today().year();
        
        param.DateBegin = DateUtils.convertToString(DateTime.now() - 30, DateUtils.ddMMyyyy);
        param.DateToday = DateUtils.convertToString(Date.today(), DateUtils.ddMMyyyy);
        
        
        executeReport();
        executeReportConsultant();
        System.debug('***********');
    
  }

    public void executeReport(){
        if (this.rangedate == '2'){
            this.squery = null;
            DateTime dtIni = null;
            DateTime dtEnd = null;
            if (this.datbeg != null && this.datend != null){
                dtIni = DateTime.newInstance(this.datbeg.year(), this.datbeg.month(), this.datbeg.day());
                dtEnd = DateTime.newInstance(this.datend.year(), this.datend.month(), this.datend.day());
            }else{
                dtIni = DateTime.now() - 30;
                dtEnd = DateTime.now();
                this.datbeg = dtIni.date();
                this.datend = dtEnd.date();
            }

            String sDtIni = dtIni.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
            String sDtEnd = (dtEnd + 1).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');

            this.whdate = ' AND Date_Closed_or_Settled__c >= ' + sDtIni + ' AND Date_Closed_or_Settled__c < '+ sDtEnd;
            this.sql = this.OPP_SOQL + ' WHERE ' + this.wh + this.whdate;
            //System.debug('The value is this.sql: ' + this.sql);
            this.squeryService = Database.query(this.sql);
            this.squeryAdmin = Database.query(this.sql);

            param.DateBegin = DateUtils.convertToString(dtIni, DateUtils.ddMMyyyy);
            param.DateToday = DateUtils.convertToString(dtEnd, DateUtils.ddMMyyyy);
        } else {            
            this.whdate = ' AND Date_Closed_or_Settled__c = LAST_N_DAYS:30';  
            this.sql = this.OPP_SOQL + ' WHERE ' + this.wh + this.whdate;  
            //System.debug(this.sql);     
            this.squeryService = Database.query(this.sql);
            this.squeryAdmin = Database.query(this.sql);
        }
    }
    
    public void executeReportConsultant() {

        

        if (this.rangedate == '2'){
            this.squery = null;
            DateTime dtIni = null;
            DateTime dtEnd = null;
            if (this.datbeg != null && this.datend != null){
                dtIni = DateTime.newInstance(this.datbeg.year(), this.datbeg.month(), this.datbeg.day());
                dtEnd = DateTime.newInstance(this.datend.year(), this.datend.month(), this.datend.day());
            }else{
                dtIni = DateTime.now() - 30;
                dtEnd = DateTime.now();
                this.datbeg = dtIni.date();
                this.datend = dtEnd.date();
            }

            String sDtIni = dtIni.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
            String sDtEnd = (dtEnd + 1).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');

            this.whdate = ' AND Date_Closed_or_Settled__c >= ' + sDtIni + ' AND Date_Closed_or_Settled__c < '+ sDtEnd;
            this.sql = this.OPP_SOQL + ' WHERE ' + this.wh + this.whUser + this.whdate;
            //System.debug('The value is this.sql: ' + this.sql);
            this.squery = Database.query(this.sql);       

            param.DateBegin = DateUtils.convertToString(dtIni, DateUtils.ddMMyyyy);
            param.DateToday = DateUtils.convertToString(dtEnd, DateUtils.ddMMyyyy);
            
        } else {            
            this.whdate = ' AND Date_Closed_or_Settled__c = LAST_N_DAYS:30';  
            this.sql = this.OPP_SOQL + ' WHERE ' + this.wh + this.whUser + this.whdate;  
            //System.debug(this.sql);     
            this.squery = Database.query(this.sql);
            
        }
        this.getResultData();
    }
 
    public String getUserId() {
        return param.userId;
    }
    
    public List<NPSReportHelper.Result> getResultData(){


       // this.whdate = ' AND Date_Closed_or_Settled__c = LAST_N_DAYS:30';
       // this.sql = this.OPP_SOQL + ' WHERE ' + this.wh + this.whUser + this.whdate;
       // System.debug('The value is datend: ' + this.whdate);
       // this.squery = Database.query(this.sql);
        this.total.fback = 0;
        this.total.promoter = 0;
        this.total.detractor = 0;
        this.total.pasive = 0;

        List<NPSReportHelper.Result> r = new List<NPSReportHelper.Result>();
        Map<String, NPSReportHelper.Result> mrs = new Map<String, NPSReportHelper.Result>();
        if (this.squery != null){
            for (Custom_Opportunity__c a : this.squery){
                String dt = DateUtils.convertToString(a.Date_Closed_or_Settled__c, DateUtils.ddMMyyyy);
                NPSReportHelper.Result rs = mrs.get(dt);
                if (rs == null) {
                    rs = new NPSReportHelper.Result();
                    rs.sdate = dt;
                    mrs.put(dt, rs);
                    r.add(rs);
                }
                rs.fback += 1;
                this.total.fback += 1;
                if (a.NPS__c != null) {
                    if (a.NPS__c >= 9) { 
                        rs.promoter += 1;
                        this.total.promoter += 1;
                        rs.porpromoter =  10/100;
                    } else if (a.NPS__c <= 6) { 
                        rs.detractor += 1;
                        this.total.detractor += 1;
                    } else {
                        rs.pasive += 1;
                        this.total.pasive += 1;
                    }                
                    rs.nps = rs.getNpsscore(rs.promoter, rs.detractor);
                    rs.ppromoter = rs.getPorcent(rs.fback, rs.promoter );
                    rs.ppasive = rs.getPorcent(rs.fback, rs.pasive );
                    rs.pdetractor = rs.getPorcent(rs.fback, rs.detractor );
                    rs.pnps = rs.getPorcent(rs.fback, rs.nps );
                    
                    this.total.nps = this.total.getNpsscore(this.total.promoter, this.total.detractor);
                    this.total.tpnps = this.total.getPorcent(this.total.fback, this.total.nps);
                    this.total.tppromoter = this.total.getPorcent(this.total.fback,this.total.promoter);
                    this.total.tppasive = this.total.getPorcent(this.total.fback,this.total.pasive);
                    this.total.tpdetractor = this.total.getPorcent(this.total.fback,this.total.detractor);
                }
            }
            //return r;
        }
        return r;
        
    }
   
    public List<NPSReportHelper.Result> getResultReportAdmin(){

        this.total.fback = 0;
        this.total.promoter = 0;
        this.total.detractor = 0;
        this.total.pasive = 0;


        List<User> currentUsers = [SELECT Name FROM User];
        Map<Id, User> usersMap = new Map<Id, User>();
        for (User u : currentUsers){
            usersMap.put(u.id, u);
        }

        List<NPSReportHelper.Result> r = new List<NPSReportHelper.Result>();
        Map<String, NPSReportHelper.Result> mrs = new Map<String, NPSReportHelper.Result>();

        
        if (this.squeryAdmin != null){
            for (Custom_Opportunity__c a : this.squeryAdmin){     

                String currentName = '';

                if (usersMap.containsKey(a.OwnerId)){
                    currentName = usersMap.get(a.OwnerId).Name;
                }

                String dt = currentName;

                NPSReportHelper.Result rs = mrs.get(dt);
                if (rs == null) {
                    rs = new NPSReportHelper.Result();
                    // rs.name = dt;
                    // rs.id = a.OwnerId;
                    mrs.put(dt, rs);
                    r.add(rs);
                }
                rs.name = currentName;
                rs.id = a.OwnerId;
                rs.fback += 1;
                this.total.fback += 1;
                           
                if (a.NPS__c != null) {
                    
                    if (a.NPS__c >= 9) { 
                      rs.promoter += 1;
                        this.total.promoter += 1;
                        rs.porpromoter =  10/100;
                    } else if (a.NPS__c <= 6) { 
                        rs.detractor += 1;
                        this.total.detractor += 1;
                    } else {
                     rs.pasive += 1;
                        this.total.pasive += 1;
                    }                
                    rs.nps = rs.getNpsscore(rs.promoter, rs.detractor);
                    rs.ppromoter = rs.getPorcent(rs.fback, rs.promoter );
                    rs.ppasive = rs.getPorcent(rs.fback, rs.pasive );
                    rs.pdetractor = rs.getPorcent(rs.fback, rs.detractor );
                    rs.pnps = rs.getPorcent(rs.fback, rs.nps );
                    
                    this.total.nps = this.total.getNpsscore(this.total.promoter, this.total.detractor);
                    this.total.tpnps = this.total.getPorcent(this.total.fback, this.total.nps);
                    this.total.tppromoter = this.total.getPorcent(this.total.fback,this.total.promoter);
                    this.total.tppasive = this.total.getPorcent(this.total.fback,this.total.pasive);
                    this.total.tpdetractor = this.total.getPorcent(this.total.fback,this.total.detractor);
                }
            }
        }
        return r;
    }
    
     public List<NPSReportHelper.Result> getResultReportService(){

        this.total.fback = 0;
        this.total.promoter = 0;
        this.total.detractor = 0;
        this.total.pasive = 0;

        
         List<NPSReportHelper.Result> r = new List<NPSReportHelper.Result>();
        Map<String, NPSReportHelper.Result> mrs = new Map<String, NPSReportHelper.Result>();
        if (this.squeryService != null){
            for (Custom_Opportunity__c a : this.squeryService){
                //String dt = DateUtils.convertToString(a.Date_Closed_or_Settled__c, DateUtils.ddMMyyyy);
                String dt = a.Lead_Loan_Type__c;
                NPSReportHelper.Result rs = mrs.get(dt);
                if (rs == null) {
                    rs = new NPSReportHelper.Result();
                    rs.sdate = dt;
                    mrs.put(dt, rs);
                    r.add(rs);
                }
                
                rs.fback += 1;
                this.total.fback += 1;           
                rs.loan_Type = a.Lead_Loan_Type__c;
                
                if (a.NPS__c != null) {
                    
                    if (a.NPS__c >= 9) { 
                      rs.promoter += 1;
                        this.total.promoter += 1;
                        rs.porpromoter =  10/100;
                    } else if (a.NPS__c <= 6) { 
                        rs.detractor += 1;
                        this.total.detractor += 1;
                    } else {
                     rs.pasive += 1;
                        this.total.pasive += 1;
                    }                
                    rs.nps = rs.getNpsscore(rs.promoter, rs.detractor);
                    rs.ppromoter = rs.getPorcent(rs.fback, rs.promoter );
                    rs.ppasive = rs.getPorcent(rs.fback, rs.pasive );
                    rs.pdetractor = rs.getPorcent(rs.fback, rs.detractor );
                    rs.pnps = rs.getPorcent(rs.fback, rs.nps );
                    
                    this.total.nps = this.total.getNpsscore(this.total.promoter, this.total.detractor);
                    this.total.tpnps = this.total.getPorcent(this.total.fback, this.total.nps);
                    this.total.tppromoter = this.total.getPorcent(this.total.fback,this.total.promoter);
                    this.total.tppasive = this.total.getPorcent(this.total.fback,this.total.pasive);
                    this.total.tpdetractor = this.total.getPorcent(this.total.fback,this.total.detractor);
                }
            }
        }
        return r;
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','Last 30 Days'));
        options.add(new SelectOption('2','Specific Days'));
        return options;
    }
    /*
    public String getFilterId() {
        return NPSReportHelper.getFilter();
    }
    */
}