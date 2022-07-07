public class StaticInfoController {

    private Map<String, List<Static_Content__c>> content;
    public List<Static_Content__c> contentLst {set;get;}

    private list<Static_Content__c> tabList = null;

    public String cat {set;get;} //Category

    public StaticInfoController() {
        init();
    }

    private void init() {
        content = new Map<String, List<Static_Content__c>>();
        List<Static_Content__c> d = [SELECT Id, Name, Category__c, Code__c, Content__c, Order__c 
                                     FROM Static_Content__c WHERE Status__c = 'A' ORDER BY Order__c ];
        for (Static_Content__c a : d) {
            List<Static_Content__c> m = content.get(a.Category__c);
            if (m == null) {
                m = new List<Static_Content__c>();
                content.put(a.Category__c, m);
            }
            m.add(a);
        }
        tabList = [SELECT Id, Name, Category__c, Code__c, Content__c, Order__c 
                    FROM Static_Content__c 
                    WHERE Code__c = 'STATIC_CONTENT' AND Status__c = 'A' 
                    ORDER BY Order__c ];
    }

    public void showObjections() {
        preSetContent('OBJ');
    }

    public void showFollow() {
        preSetContent('FFC');   
    }

    public void showRealLife() {
        preSetContent('RLIFE');      
    }

    public void showInsuranceObjetions() {
        preSetContent('OBJINS');      
    }

    public void showInvoiceRequest() {
        preSetContent('IRVDR');      
    }

    public void showPreApprovalCall() {
        preSetContent('PAVDPR');      
    }

    public void showRapportBuilding() {
        preSetContent('RAB');      
    }

    private void preSetContent(String section) {
        contentLst = content.get(section);
        if (contentLst == null) {
            contentLst = new List<Static_Content__c>();
        }
    }

    public Static_Content__c getFirstTab() {
        Static_Content__c r = null;
        if (!this.tabList.isEmpty()) {
            r = this.tabList.get(0);
        }
        return r;
    }
    
    public List<Static_Content__c> getTabs() {
        List<Static_Content__c> r = new List<Static_Content__c>();
        if (!this.tabList.isEmpty()) {
            r.addAll(this.tabList);
            r.remove(0);
        }
        return r;
    }

    public Static_Content__c getCategoryContent() {
        Static_Content__c r = null;
        if (this.cat != null) {
            for (Static_Content__c a : this.tabList) {
                if (a.Category__c.equals(this.cat)) {
                    r = a;
                    break;
                }
            }
        }
        //System.debug('Static content >> ' + r.Code__c);
        return r;
    }
}