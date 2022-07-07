public with sharing class FixCostReport {
	
	public FixCostReport() {
		Month = Date.today().month();
        Year = Date.today().year();
        Month1 = Date.today().month()+1;
        Year1 = Date.today().year();
        getMyConsultants();
        
	}
    
	public Integer Month { get; set; }
    public Integer Year { get; set; }
    public Integer Month1 { get; set; }
    public Integer Year1 { get; set; }
    public List<FillData> datatable = new List<FillData>();
     public decimal totalAmount{get;set;}
    public decimal totalReal{get;set;}
    public PageReference getDataOfUser() {
    	
    	return null;
    }
    
     public List<FillData> getdataList()         
    {   
        system.debug('@@@@Fist name: '+datatable.isEmpty());
        //system.debug('######## conObjectWrapperList -'+conObjectWrapperList);
        return datatable;
    }
    
    
    public Map<Id, User> ValidUsers
    {
        get
        {
            if (ValidUsers == null)
            {
                ValidUsers = new Map<Id, User> ([SELECT Id
                                                 FROM User
                                                 WHERE Id IN :userIds]);                
            }
            return ValidUsers;
        }
        set;    
    }

 public Set<Id> userIds
    {
        get
        {
            if (userIds == null)
            {

                userIds = new Set<Id>();
                for (UserRole g : [SELECT Id
                    FROM UserRole WHERE (DeveloperName = 'Sales_Consultants' OR DeveloperName = 'Customer_Loyalty') 
                    ORDER BY DeveloperName ASC                   ])
                {
                    
                    for (User gm : [SELECT Id
                                           FROM User
                                           WHERE UserRoleId = :g.Id])
                    {
                        userIds.add(gm.Id);
                     //   system.debug('@@@@Amanda '+gm.Id  );
                    } 
                    
                }

            }
            return userIds;
        }
        set;
    }
    
     private Date StartDate
    {
        get
        {
            return Date.newInstance(Year, Month, 1);
        }
    }
    
    private Date EndDate
    {
        get
        {
            return Date.newInstance(Year1, Month1, 1);
        }
    }
    
     public List<SelectOption> Years
    {
        get
        {
            if (Years == null)
            {
                Years = new List<SelectOption>();
                Integer y = 2013;
                
                while (y <= Date.today().year())
                {
                    Years.add(new SelectOption(String.valueOf(y), String.valueOf(y)));
                    y++;
                }
            }
            return Years;    
        }
        set;
    }
    
    public PageReference getMyConsultants() {
        Decimal sallic, esl, lic, ren, adm, pro, gle, bsa, su, inp, dil, gas, tfc, adt, ect, psr, vda, adf, bst, pri, sms, comme, socm, tvari, tcta, totAmount;
        Double sum, tsum;
        Id ids;
        String name, last, tocc;
        totalReal=0;
           datatable=new List<FillData>();
            List<User> userList = new List<User>();
            Set<Id> userIds = new Set<Id>();
         Map<id,List<Custom_Opportunity__c>> userToOppMap = new Map<id,List<Custom_Opportunity__c>>();
         
        if(validUsers!= null && validUsers.size()>0){
            
            for(custom_opportunity__c oppObj:[
                    select id, name,Owner.Name, ownerId,Total_Commission__c,NAF_Net_Amount_Financed__c,
                           Number_Insurance_Sales__c,Total_Insurance_Commission__c,Total_Brokerage__c,
                           Total_DOF__c, VD_Status__c, VD_Is_Old_Process__c, Number_FullComp_Ins_Sales__c,
                           Number_Other_Ins_Sales__c 
                    from custom_opportunity__c 
                    WHERE Owner.Name != 'System Generated' AND Date_Settled__c >= :StartDate AND Date_Settled__c < :EndDate 
                    AND Status__c = 'Settled' AND ownerId in:validUsers.keyset()]){
                        system.debug(' Claudita@@@ '+ EndDate );
                  // Owner.Name != 'System Generated' AND     
           		
               userIds.add(oppObj.OwnerId);
               
               if(userToOppMap.containsKey(oppObj.OwnerId)){
                
                  system.debug(' Celena '+ EndDate );
                     userToOppMap.get(oppObj.OwnerId).add(oppObj);
                                
                }else{
                    
                      system.debug(' Celena2 '+ EndDate );       
                    userToOppMap.Put(oppObj.OwnerId, new List<Custom_Opportunity__c>{oppObj}); 
                         
                }            
           
             }
           
           }
       
            Map<id,List<Lead__c>> leadCountMap = new Map<id,List<Lead__c>>();
        //    
       	 
     
        for (Lead__c l : [SELECT Id,
                                     OwnerId,
                                     Owner.Name
                              FROM Lead__c
                              WHERE OwnerId IN :ValidUsers.keySet()])
            {             
                userIds.add(l.OwnerId); 
               
            }
  //       for(User ur: [Select id,Monthly_Commission_Target__c,name,State from User where id In:validUsers.keyset() ORDER BY State ASC] ){
  //       system.debug('@@@@Amanda '+ValidUsers.keySet()  );
        for (User Usue:[Select Id, FirstName, LastName, Salesforce_License__c, E_sign_Live_License__c, 
                       Rent__c, Admin__c, Processing__c, Google_Email__c, Base_Salary2__c, Super2__c, 
                       Internet_and_phone__c, Dialer_LIcense__c, Gamification_software__c, 
                        Total_Fixed_cost2__c, Advertising__c, Electricity__c, PPSR__c, VEDA__c, 
                        Address_Finder__c, Bank_Statement__c, Printing__c, SMS_Magic__c, Commision_Est__c, Super_on_Commision2__c, Type_of_consultant__c from User where Id IN :ValidUsers.keySet()]) { 
                           sum=0;
                           ids=Usue.Id;
                           
                          for (Lead__c le :[SELECT Id FROM Lead__c
                              WHERE Date_Lead_to_Consultant__c >= :StartDate
                              AND Date_Lead_to_Consultant__c < :EndDate
                                             AND OwnerId = :Usue.Id]) {
                                                 sum+=1;
                                             }
                            totalAmount=0;
                    //        system.debug('@@@@Usuarios '+Usue.Id+ ' '+Usue.FirstName );
                          if(userToOppMap.containskey(Usue.Id)) {
                  
                    
                      for(Custom_opportunity__c csOpp:userToOppMap.get(Usue.Id)){
                          
                           
                           
                           List<custom_opportunity__c> oppCountLst = new List<custom_opportunity__c>();
                           oppCountLst.add(csOpp);	
                           totalAmount +=  csOpp.Total_Commission__c;
                     //     system.debug('@@@@Usuarios222 '+ totalAmount );
                          }
                           
                              } 
                          
                                 
                           name=Usue.FirstName;
                           last=Usue.LastName;
                           if (Usue.Salesforce_License__c== null) 
                               sallic=0;
                           else
                               sallic=Usue.Salesforce_License__c;
                           
                           if (Usue.E_sign_Live_License__c== null)
                               esl=0;
                           else
                               esl= Usue.E_sign_Live_License__c;
                           
                           if (Usue.Rent__c== null) 
                               ren=0;
                           else
                               ren=Usue.Rent__c;
                           	
                           if (Usue.Admin__c== null) 
                               adm=0;
                           else
                               adm=Usue.Admin__c;
                           
                           if (Usue.Processing__c== null) 
                               pro=0;
                           else
                               pro=Usue.Processing__c;
                           
                           if (Usue.Google_Email__c== null)
                               gle=0;
                           else
                               gle=Usue.Google_Email__c;
                           
                           if (Usue.Base_Salary2__c== null) 
                               bsa=0;
                           else
                               bsa=Usue.Base_Salary2__c;
                           
                           if (Usue.Super2__c== null) 
                               su=0;
                           else
                               su=Usue.Super2__c;
                           
                           if (Usue.Internet_and_phone__c== null) 
                               inp=0;
                           else
                               inp= Usue.Internet_and_phone__c;
                           
                           if (Usue.Dialer_LIcense__c== null) 
                               dil=0;
                           else
                               dil=Usue.Dialer_LIcense__c;
                           
                           if (Usue.Gamification_software__c== null) 
                               gas=0;
                           else
                               gas=Usue.Gamification_software__c;
                           
                           if (Usue.Total_Fixed_cost2__c== null) 
                               tfc=0;
                           else
                               tfc=Usue.Total_Fixed_cost2__c;
                           
                            if (Usue.Advertising__c== null) 
                               adt=0;
                           else
                               adt=Usue.Advertising__c;
                            
                            if (Usue.Electricity__c== null) 
                               ect=0;
                           else
                               ect=Usue.Electricity__c;
                            
                            if (Usue.PPSR__c== null) 
                               psr=0;
                           else
                               psr=Usue.PPSR__c;
                            
                            if (Usue.VEDA__c== null) 
                               vda=0;
                           else
                               vda=Usue.VEDA__c;
                            
                            if (Usue.Address_Finder__c== null) 
                               adf=0;
                           else
                               adf=Usue.Address_Finder__c;
                            
                            if (Usue.Bank_Statement__c== null) 
                               bst=0;
                           else
                               bst=Usue.Bank_Statement__c;
                            
                            if (Usue.Printing__c== null) 
                               pri=0;
                           else
                               pri=Usue.Printing__c;
                            
                           if (Usue.SMS_Magic__c== null) 
                               sms=0;
                           else
                               sms=Usue.SMS_Magic__c; 
                            
                           if (Usue.Commision_Est__c==null) 
                               comme=0;
                            else
                                comme=Usue.Commision_Est__c;
                            
                            if (Usue.Super_on_Commision2__c==null)
                                socm=0;
                            else
                                socm=Usue.Super_on_Commision2__c;
                            
                            if (Usue.Type_of_consultant__c==null)
                                tocc='null';
                            else
                                tocc=Usue.Type_of_consultant__c;
                                
                                                   
                           tsum=sum*40;  
                            totAmount=totalAmount;
                            if (totalAmount>=5000)
                            totalAmount=totalAmount-5000;
                            if (tocc.equals('Junior - SA') || tocc.equals('Junior - NSW')) {
                                if (totalAmount>=30000)
                                    totalReal= totalAmount*0.2; 
                                else if (totalAmount>=25000 && totalAmount<=29999)
                                    totalReal=totalAmount*0.175;
                                else if (totalAmount>=20000 && totalAmount<=24999)
                                    totalReal=totalAmount*0.15;
                                else if (totalAmount>=15000 && totalAmount<=19999)
                                    totalReal=totalAmount*0.125;
                                else if (totalAmount>=5000 && totalAmount<=14999)
                                    totalReal=totalAmount*0.1;
                                else
                                    totalReal=0;
                            } 
                            
                            if (tocc.equals('Senior - SA') || tocc.equals('Senior - NSW')) {
                                if (totalAmount>=25000)
                                    totalReal= totalAmount*0.225;
                                else if (totalAmount>=20000 && totalAmount<=24999)
                                    totalReal=totalAmount*0.175;
                                else if (totalAmount>=10000 && totalAmount<=19999)
                                    totalReal=totalAmount*0.15;
                                else if (totalAmount>=5000 && totalAmount<=9999)
                                    totalReal=totalAmount*0.1;                               
                                else
                                    totalReal=0;
                            }
                            if (tocc.equals('Team Leader - National')) {
                                if (totalAmount>=25000)
                                    totalReal= totalAmount*0.25;
                                else if (totalAmount>=20000 && totalAmount<=24999)
                                    totalReal=totalAmount*0.2;
                                else if (totalAmount>=10000 && totalAmount<=19999)
                                    totalReal=totalAmount*0.15;
                                else if (totalAmount>=5000 && totalAmount<=9999)
                                    totalReal=totalAmount*0.1;                               
                                else
                                    totalReal=0;
                            } 
                            
                            socm=totalReal*0.19;
                            tvari=totalReal+socm+tsum;
                            tcta=totalAmount-totalReal;
                           system.debug('@@@@totalAmount '+ totalReal );	//  totalAmount
                          FillData regis = new FillData(ids, name, last, sallic, esl, ren, adm, pro, gle, bsa, su, inp, dil, gas, tfc, tsum, adt, ect, psr, vda, adf, bst, pri, sms, totalReal, socm, tvari, tcta, totAmount);
                           datatable.add(regis);
                           
               //        }
             
       } 
        return null;
    }
    
    public List<FillData> getDatainPage() {        
        return datatable;
    }


    


public class FillData {
    public Id Id {get; set;}
    public String FirstName {get; set;}
    public String LastName {get; set;}
	public Decimal SalForLic {get; set;}
	public Decimal EsigLivLic {get; set;}
	public Decimal Rent {get; set;}
	public Decimal Admin {get; set;}
	public Decimal Processing {get; set;}
	public Decimal GooEma {get; set;}
	public Decimal BasSal {get; set;}
	public Decimal Sup {get; set;}
	public Decimal IntPhon {get; set;}
	public Decimal DialLic {get; set;}
	public Decimal GamSoft {get; set;}
	public Decimal TotFix {get; set;}
    public Double SumLead {get; set;}
    public Decimal Advert {get; set;}
    public Decimal Electric {get; set;}
    public Decimal Ppsr {get; set;}
    public Decimal Veda {get; set;}
    public Decimal Addfind {get; set;}
    public Decimal BankStat {get; set;}
    public Decimal Print {get; set;}
    public Decimal SmsMag {get; set;} 
    public Decimal ComEst {get; set;}
    public Decimal SupCom {get; set;}
    public Decimal TotVari {get; set;}
    public Decimal tcmTa {get; set;}
    public Decimal totCost {get; set;}
    public Decimal totAmt {get; set;}
    public Decimal result {get; set;}
    
    
    public FillData (Id Ide, String FiNa, String LaNa, Decimal sfl, Decimal ell, Decimal re,
                     Decimal ad, Decimal pro, Decimal goe, Decimal bs, Decimal supe, Decimal ip, 
                     Decimal dl, Decimal gs, Decimal tf, Double sl, Decimal adv, Decimal elc, 
                     Decimal psr, Decimal vda, Decimal af, Decimal banS, Decimal pri, Decimal sms, Decimal cet, Decimal spm, Decimal tvar, Decimal tca, Decimal Toa) {
                         Id=Ide;
                         FirstName=FiNa;
                         LastName=LaNa;
                         SalForLic=sfl;
                         EsigLivLic=ell;
        				 Rent=re;
                         Admin=ad;
                         Processing=pro;
                         GooEma=goe;
                         BasSal=bs;
                         Sup=supe;
                         IntPhon=ip;
                         DialLic=dl;
                         GamSoft=gs;
                         TotFix=tf;
                         SumLead=sl;
                         Advert=adv;
                         Electric=elc;
                         Ppsr=psr;
                         Veda=vda;
                         Addfind = af;
                         BankStat=banS;
                         Print=pri;
                         SmsMag=sms;
                         ComEst=cet;
                         ComEst=ComEst.SetScale(2);
                         SupCom=spm;
                         SupCom=SupCom.SetScale(2);
                         TotVari=tvar;
                         TotVari=totVari.SetScale(2);
                         tcmTa=tca;
                         totCost = totVari+TotFix; //totVari+TotFix
                         totCost= totCost.SetScale(2);
                         totAmt=Toa; 
                         result=(totAmt-totCost);
                         
    }
    
	
}
}