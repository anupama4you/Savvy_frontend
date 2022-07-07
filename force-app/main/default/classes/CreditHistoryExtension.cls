public class CreditHistoryExtension {
    
    public Custom_Opportunity__c opp;
    
    public String adverseEvent {set; get;}
    public List <SelectOption> adverseEventOptions {get;set;}
    public transient Component.Apex.PageBlock dynamicForm ;
    public List <SelectOption> bankruptcyTypeOptions {get;set;}
    public String bankruptcyType {set; get;}
    //-HJ  Credit History -F
    
    public List<Application_Credit_History__c> creditsHistory {set; get;}
    
    public CreditHistoryExtension(ApexPages.StandardController controller) {
        try {
            controller.addFields(new List<String>{'Application__c'});
        } catch (SObjectException e) {}
        this.opp = (Custom_Opportunity__c)controller.getRecord ();
        
        PageReference appPdf = Page.GenerateAppPdf;
        appPdf.getParameters().put('id',opp.Id);
        //-HJ  Credit History -I
        creditsHistory = new List<Application_Credit_History__c>();
        bankruptcyTypeOptions = UtilitiesList.getBankruptcyTypeOptions();
        adverseEventOptions = UtilitiesList.getAdverseEventOptions();
        loadCreditHistory();
        loadDynamicFields();
        //-HJ Credit History -F
    }
    
    private Component.Apex.OutputText getInitDivHtml(String titleSection){
        Component.Apex.OutputText htmlTxt = new Component.Apex.OutputText(); 
        htmlTxt.value = '<div class="LibertyTab"><h3> ' + titleSection +' </h3></div>';        
        htmlTxt.escape = false;  
        return htmlTxt;
    }
    
    private Component.Apex.OutputText getInitTableHtml(){
        Component.Apex.OutputText htmlTxt = new Component.Apex.OutputText(); 
        htmlTxt.value = '&nbsp<table class="LibertyDetails"><tr><td class="LibertyColumn">'; 
        //htmlTxt.value += 'Remove' + '</td><td class="LibertyColumn">';
        htmlTxt.value += '      ' + '</td><td class="LibertyColumn"> <h3>';
        htmlTxt.value += 'Creditor' + '</h3></td><td class="LibertyColumn"><h3>';
        htmlTxt.value += 'Worst Past' + '</h3></td><td class="LibertyColumn"><h3>';
        htmlTxt.value += 'Paid / UnPaid' + '</h3></td><td class="LibertyColumn"><h3>';
        htmlTxt.value += 'Date Incurred' + '</h3></td><td class="LibertyColumn"><h3>';
        htmlTxt.value += 'Date Rectified' + '</h3></td><td class="LibertyColumn"><h3>';
        htmlTxt.value += 'Amount' + '</h3></td><td class="LibertyColumn"><h3>';
        htmlTxt.value += 'Payments missed' + '</h3></td><td class="LibertyColumn"><h3>';
        htmlTxt.value += 'Reason' + '</h3></td>';
        htmlTxt.value += '</tr>';
        htmlTxt.value += '<tr><td colspan="9">&nbsp</td></tr>';
        htmlTxt.value += '<tr><td class="LibertyColumn">';        
        htmlTxt.escape = false;  
        return htmlTxt;
    }
    
    private Component.Apex.OutputText getInitTableHtml_Bankruptcy(){
        Component.Apex.OutputText htmlTxt = new Component.Apex.OutputText(); 
        htmlTxt.value = '&nbsp<table class="LibertyDetails"><tr><td class="LibertyColumn">'; 
        //htmlTxt.value += 'Remove' + '</td><td class="LibertyColumn">';
        htmlTxt.value += '      ' + '</td><td class="LibertyColumn"> <h3>';
        htmlTxt.value += 'Type' + '</h3></td><td class="LibertyColumn"><h3>';
        htmlTxt.value += 'List Date' + '</h3></td><td class="LibertyColumn"><h3>';
        htmlTxt.value += 'Discharge Date' + '</h3></td><td class="LibertyColumn"><h3>';
        htmlTxt.value += 'Reason' + '</h3></td>';
        htmlTxt.value += '</tr>';
        htmlTxt.value += '<tr><td colspan="9">&nbsp</td></tr>';
        htmlTxt.value += '<tr><td class="LibertyColumn">';        
        htmlTxt.escape = false;  
        return htmlTxt;
    }
    
    private Component.Apex.OutputText getMidRowsHtml(){
        Component.Apex.OutputText htmlTxt = new Component.Apex.OutputText(); 
        htmlTxt.value = '</td><td class="LibertyColumn">';        
        htmlTxt.escape = false;  
        return htmlTxt;
    }
    
    private Component.Apex.OutputText getEndTableHtml(){
        Component.Apex.OutputText htmlTxt = new Component.Apex.OutputText(); 
        htmlTxt.value = '</td></tr></table>';     
        htmlTxt.escape = false;  
        return htmlTxt;
    }
    
    public Component.Apex.PageBlock getDynamicForm() {
        return dynamicForm;
    }
    
    private Component.Apex.InputCheckBox getInputCheckBox (String isErased){
        Component.Apex.InputCheckBox chk = new Component.Apex.InputCheckBox();
        chk.expressions.value = isErased;
        return chk;
    }
    
    private Component.Apex.OutputLabel getOutputLabel (String label, Boolean isHtmlText){
        Component.Apex.OutputLabel  outputLabel = new Component.Apex.OutputLabel (styleClass='dataOutputD');
        outputLabel.value = label;
        if (isHtmlText){
            outputLabel.escape = false;
        }
        return outputLabel;
    }
    
    private Component.Apex.InputField getInputField (String value){
        Component.Apex.InputField inputField = new Component.Apex.InputField(styleClass='dataInputD');
        inputField.expressions.value = value;
        return inputField;
    }
    
    private Component.Apex.SelectList getSelectListWorstPast(String value, Integer index){
        Component.Apex.SelectList cmpSelectList = new Component.Apex.SelectList(multiselect = false, size = 1, styleClass='selectList3');
        cmpSelectList.expressions.value = value;
        cmpSelectList.expressions.rendered = '{!IF(ISBLANK(Custom_Opportunity__c.Application__c),false,true)}';
        cmpSelectList.onChange = 'action' + index +'()';
        for (SelectOption s : UtilitiesList.getWorstPastOptions()){
            Component.Apex.selectOption cmpOption = new Component.Apex.SelectOption();
            cmpOption.itemValue = s.getValue();
            cmpOption.itemLabel = s.getLabel();
            cmpSelectList.childComponents.add (cmpOption);
        }
        return cmpSelectList;
    }
    
    private Component.Apex.ActionFunction getActionFunction(Integer index, String component){
        Component.Apex.ActionFunction  a = new Component.Apex.ActionFunction (reRender = component, name = 'action' + index);
        a.expressions.action = '{!loadDynamicFields}';
        return a;
    }
    
    private Component.Apex.SelectList getSelectListBankruptcyType(String value){
        Component.Apex.SelectList cmpSelectList = new Component.Apex.SelectList(multiselect = false, size = 1, styleClass='selectList3');
        cmpSelectList.expressions.value = value;
        cmpSelectList.expressions.rendered = '{!IF(ISBLANK(Custom_Opportunity__c.Application__c),false,true)}';
        for (SelectOption s : UtilitiesList.getBankruptcyTypeOptions()){
            Component.Apex.selectOption cmpOption = new Component.Apex.SelectOption();
            cmpOption.itemValue = s.getValue();
            cmpOption.itemLabel = s.getLabel();
            cmpSelectList.childComponents.add (cmpOption);
        }
        return cmpSelectList;
    }
    
    private Component.Apex.SelectList getSelectListPaidUnPaid(String value){
        Component.Apex.SelectList cmpSelectList = new Component.Apex.SelectList(multiselect = false, size = 1, styleClass='selectList3');
        cmpSelectList.expressions.value = value;
        cmpSelectList.expressions.rendered = '{!IF(ISBLANK(Custom_Opportunity__c.Application__c),false,true)}';
        for (SelectOption s : UtilitiesList.getPaidUnpaidOptions()){
            Component.Apex.selectOption cmpOption = new Component.Apex.SelectOption();
            cmpOption.itemValue = s.getValue();
            cmpOption.itemLabel = s.getLabel();
            cmpSelectList.childComponents.add (cmpOption);
        }
        return cmpSelectList;
    }
    
    private Component.Apex.SelectList getPaymentsMissed(String value, String worstPast, String id){
        Component.Apex.SelectList cmpSelectList = new Component.Apex.SelectList(multiselect = false, size = 1, styleClass='selectList3');
        cmpSelectList.id = id;
        cmpSelectList.expressions.value = value;
        cmpSelectList.expressions.rendered = '{!IF(ISBLANK(Custom_Opportunity__c.Application__c),false,true)}';
        cmpSelectList.expressions.disabled = '{!IF (\'Arrears\'==\'' + worstPast +'\',false, true)}';
        for (SelectOption s : UtilitiesList.getPaymentsMissedOptions()){
            Component.Apex.selectOption cmpOption = new Component.Apex.SelectOption();
            cmpOption.itemValue = s.getValue();
            cmpOption.itemLabel = s.getLabel();
            cmpSelectList.childComponents.add (cmpOption);
        }
        return cmpSelectList;
    }
    
    private Component.Apex.SelectList getReason(String value){
        Component.Apex.SelectList cmpSelectList = new Component.Apex.SelectList(multiselect = false, size = 1, styleClass='selectList3');
        cmpSelectList.expressions.value = value;
        cmpSelectList.expressions.rendered = '{!IF(ISBLANK(Custom_Opportunity__c.Application__c),false,true)}';
        for (SelectOption s : UtilitiesList.getReasonOptions()){
            Component.Apex.selectOption cmpOption = new Component.Apex.SelectOption();
            cmpOption.itemValue = s.getValue();
            cmpOption.itemLabel = s.getLabel();
            cmpSelectList.childComponents.add (cmpOption);
        }
        return cmpSelectList;
    }
    
    private void loadCreditHistory (){
        if (this.Opp.Application__c != null) {
            List<Application_Credit_History__c> ch = [select Creditor_1__c,  
                                Worst_Past_1__c, 
                                Paid_Unpaid_1__c, 
                                Date_Incurred_1__c, 
                                Date_Rectified_1__c, 
                                Amount_1__c, 
                                Payments_Missed_1__c, 
                                Reason_1__c,
                             	Event_Name__c,
                                Is_Erased__c ,
                                Application__c                       
                            from Application_Credit_History__c WHERE Application__c = :this.Opp.Application__c];
            creditsHistory = new List<Application_Credit_History__c>();
            if (ch != null && !ch.isEmpty()){
                creditsHistory = ch;
            }
        }
    }
    
    private Component.Apex.OutputPanel loadAdversEventsDynamic(Integer i){
        //dynamicForm = new Component.Apex.PageBlock();
        Component.Apex.OutputPanel outputPanelFields = new Component.Apex.OutputPanel();
        outputPanelFields.childComponents.add (getActionFunction(i,'cmpPaymentMissed' + i));
        outputPanelFields.childComponents.add (getInitDivHtml('Credit History ' + (i + 1) + ' - ' + creditsHistory[i].Event_Name__c));
        outputPanelFields.childComponents.add (getInitTableHtml());
        outputPanelFields.childComponents.add (getInputCheckBox('{!creditsHistory[' + i + '].Is_Erased__c}'));
        outputPanelFields.childComponents.add (getMidRowsHtml());
        outputPanelFields.childComponents.add (getInputField('{!creditsHistory[' + i + '].Creditor_1__c}'));
        outputPanelFields.childComponents.add (getMidRowsHtml());
        outputPanelFields.childComponents.add (getSelectListWorstPast('{!creditsHistory[' + i + '].Worst_Past_1__c}', i));
        outputPanelFields.childComponents.add (getMidRowsHtml());
        outputPanelFields.childComponents.add (getSelectListPaidUnPaid('{!creditsHistory[' + i + '].Paid_Unpaid_1__c}'));
        outputPanelFields.childComponents.add (getMidRowsHtml());
        outputPanelFields.childComponents.add (getInputField('{!creditsHistory[' + i + '].Date_Incurred_1__c}'));
        outputPanelFields.childComponents.add (getMidRowsHtml());
        outputPanelFields.childComponents.add (getInputField('{!creditsHistory[' + i + '].Date_Rectified_1__c}'));
        outputPanelFields.childComponents.add (getMidRowsHtml());
        outputPanelFields.childComponents.add (getInputField('{!creditsHistory[' + i + '].Amount_1__c}'));
        outputPanelFields.childComponents.add (getMidRowsHtml());
        outputPanelFields.childComponents.add (getPaymentsMissed('{!creditsHistory[' + i + '].Payments_Missed_1__c}', creditsHistory[i].Worst_Past_1__c, 'cmpPaymentMissed' + i));
        outputPanelFields.childComponents.add (getMidRowsHtml());
        outputPanelFields.childComponents.add (getReason('{!creditsHistory[' + i + '].Reason_1__c}'));
        outputPanelFields.childComponents.add (getEndTableHtml());
        return outputPanelFields;
    }
    
    private Component.Apex.OutputPanel loadAdversEventsDynamic_Bankruptcy(Integer i){
        //dynamicForm = new Component.Apex.PageBlock();
        Component.Apex.OutputPanel outputPanelFields = new Component.Apex.OutputPanel();
        outputPanelFields.childComponents.add (getActionFunction(i,'cmpPaymentMissed' + i));
        outputPanelFields.childComponents.add (getInitDivHtml('Credit History ' + (i + 1) + ' - ' + creditsHistory[i].Event_Name__c));
        outputPanelFields.childComponents.add (getInitTableHtml_Bankruptcy());
        outputPanelFields.childComponents.add (getInputCheckBox('{!creditsHistory[' + i + '].Is_Erased__c}'));
        outputPanelFields.childComponents.add (getMidRowsHtml());
        outputPanelFields.childComponents.add (getSelectListBankruptcyType('{!creditsHistory[' + i + '].Worst_Past_1__c}'));
        outputPanelFields.childComponents.add (getMidRowsHtml());
        outputPanelFields.childComponents.add (getInputField('{!creditsHistory[' + i + '].Date_Incurred_1__c}'));
        outputPanelFields.childComponents.add (getMidRowsHtml());
        outputPanelFields.childComponents.add (getInputField('{!creditsHistory[' + i + '].Date_Rectified_1__c}'));
        outputPanelFields.childComponents.add (getMidRowsHtml());
        outputPanelFields.childComponents.add (getReason('{!creditsHistory[' + i + '].Reason_1__c}'));
        outputPanelFields.childComponents.add (getEndTableHtml());
        return outputPanelFields;
    }
    
    
    public void loadDynamicFields(){
        date dueDate = date.newInstance(2011, 7, 4);
        boolean overdue = date.today().daysBetween(dueDate) < 0;
        dynamicForm = new Component.Apex.PageBlock();
        dynamicForm.childComponents.clear();
        Integer i = 0;
        for (i = 0; i < creditsHistory.size(); i++){
            Application_Credit_History__c c = creditsHistory[i];
            if (c.Event_Name__c.equalsIgnoreCase('Bankruptcy')){
                dynamicForm.childComponents.add (loadAdversEventsDynamic_Bankruptcy(i));
                adverseEventOptions.remove(6);
            }else{
                dynamicForm.childComponents.add (loadAdversEventsDynamic(i));
            }
        }
    }
    
    public void addAdverseEvent(){
        if (adverseEvent != null){
            Application_Credit_History__c c = new Application_Credit_History__c();
            c.Event_Name__c = adverseEvent;
            c.Application__c = opp.Application__c;
            creditsHistory.add(c);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select one Adverse Event!'));
        }
        loadDynamicFields();
    }
    
    
    public void saveCreditHistory(){
        if (creditsHistory != null){
            for (Application_Credit_History__c creditHistory: creditsHistory){
                
                if (creditHistory.Id == null) {
                    creditHistory.Application__c = opp.Application__c;
                    insert creditHistory;
                }
                update creditHistory;
            }
            //update creditsHistory;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your Credits History has been saved successfully!'));
        }
        loadDynamicFields();
        
    }
    
    public void removeCreditHistory(){
        Integer index = 0;
        for (index = 0; index < creditsHistory.size(); index++){
            Application_Credit_History__c c = creditsHistory[index];

            if (c.Is_Erased__c) {
                creditsHistory.remove(index);
                if (c.Id != null) {
                    delete c;
                }
            }
            if (c.Event_Name__c.equalsIgnoreCase('Bankruptcy')){
                adverseEventOptions.add(new SelectOption('Bankruptcy', 'Bankruptcy'));
            }
        }
        loadDynamicFields();
    }
}