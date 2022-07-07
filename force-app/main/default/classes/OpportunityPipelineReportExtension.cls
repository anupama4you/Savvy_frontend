public class OpportunityPipelineReportExtension {

    public List<Custom_Opportunity__c> opportunityList = new List<Custom_Opportunity__c>(); 
    public Map<String, List<Custom_Opportunity__c>> mapOpportunity = new Map<String, List<Custom_Opportunity__c>>();
    
    public Integer currentPage {set;get;}
    public Integer totalPages {set;get;}
    private Integer offsetRecords = 50;
    
    public List <SelectOption> statesOptions {get;set;}
    public List<Custom_Opportunity__c> listState;
    public String stateSelected {get; set;}
    
    public OpportunityPipelineReportExtension (){
        loadOpportunitiesPipeline();
        //Pagination
        chooseState();
        loadPagination();
        
    }
    
    public Map<String, List<Custom_Opportunity__c>> getMapOpportunity(){
        return mapOpportunity;
    }
    
    private void loadOpportunitiesPipeline(){
        System.debug('loadOpportunities pipeline...');
        mapOpportunity.clear();
        opportunityList = [select id, opp.name, CreatedBy.name, createddate,  lastmodifieddate,
                           Total_Commission__c, status__c, NAF_Net_Amount_Financed__c , Application__r.Mobile_Number__c 
                           from Custom_Opportunity__c opp 
                           where status__c not in ('Settled','Closed Opportunity') and 
                           //owner.name  in ('Savvy Admin')  
                           ownerid=:UserInfo.getUserId()
                           order by status__c desc];
        statesOptions = new List <SelectOption> ();
        //statesOptions.add(new SelectOption ('-', 'Select..'));
        for (Custom_Opportunity__c opp : opportunityList){
            String st = opp.status__c;
            if (StringUtils.isNullOrEmpty(st)){
                st = '-';
            }
            if (mapOpportunity.get(st) != null){
                mapOpportunity.get(st).add(opp);
            }else{
                List<Custom_Opportunity__c> l = new List<Custom_Opportunity__c>();
                l.add(opp);
                mapOpportunity.put(st, l);
                statesOptions.add(new SelectOption (StringUtils.validateNull(st),StringUtils.validateNull(st)));
            }
        }
        updateLabelStates();
        if (!statesOptions.isEmpty()) {
            stateSelected = ((SelectOption)statesOptions.get(0)).getValue();
        }
    }
    
    private void updateLabelStates(){
        for (SelectOption s : statesOptions){
            List<Custom_Opportunity__c> l = mapOpportunity.get(s.getValue());
            s.setLabel(s.getLabel() + ' (' + l.size() + ')');
        }
    }
    
    public PageReference chooseState(){
        listState = mapOpportunity.get(stateSelected);
        loadPagination();
        return null;
    }
    
    public void goNext() {
        if (currentPage < totalPages) {
            currentPage++;
        }
    }

    public void goBack() {
        if (currentPage > 1) {
            currentPage--;
        }   
    }
    
    private void loadPagination(){
        currentPage = 1;
        totalPages = 1;
        if (listState != null && listState.size() > 0) {
            Decimal tmpPages = Decimal.valueOf(listState.size()) / Decimal.valueOf(offsetRecords);
            if (tmpPages > 0) {
                totalPages = tmpPages.round(System.RoundingMode.CEILING).intValue();
            }
            //System.debug(listState.size() + '|' + tmpPages + '|' + totalPages + '|' + offsetRecords);
        }
    }
    
    public List<Custom_Opportunity__c> getListState (){
        System.debug('getOpportunities state...');
        List<Custom_Opportunity__c> r = new List<Custom_Opportunity__c>(); 
        if (listState != null) {
            Integer idxA = offsetRecords * (currentPage - 1);
            for (Integer i = 0; i < offsetRecords ; i++) {
                if ((idxA+i) < listState.size()) {
                    r.add(listState.get(idxA+i));
                }
            }
        }
        return r;
    }
    
    /**
    public List<Custom_Opportunity__c> getOpportunitiesPipelie(){
        System.debug('getOpportunities pipeline...');
        List<Custom_Opportunity__c> r = new List<Custom_Opportunity__c>(); 
        Integer idxA = offsetRecords * (currentPage - 1);
        for (Integer i = 0; i < offsetRecords ; i++) {
            if ((idxA+i) < opportunityList.size()) {
                r.add(opportunityList.get(idxA+i));
            }
        }
        return r;
    }**/
}