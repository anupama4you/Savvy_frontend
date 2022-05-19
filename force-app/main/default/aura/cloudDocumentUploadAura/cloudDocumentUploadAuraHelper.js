({
    setupTable : function(component) {
        var action = component.get("c.getPicklistValues");
        action.setParams({
            objectAPIName: "Cloud_Documents__c",
            fieldAPIName: "Document_Type__c"
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                var types = [];
                var typesYesNo = [];
                var actionVal = component.get("c.getYesNoPicklistValues");
                actionVal.setParams({
                    objectAPIName: "Cloud_Documents__c",
                    fieldAPIName: "SendToLender__c"
                });
                 
                actionVal.setCallback(this,function(response){
                    if(response.getState() === "SUCCESS"){
                        Object.entries(response.getReturnValue()).forEach(([key, value]) => typesYesNo.push({label:key,value:value}));
                    }
                 });
        		$A.enqueueAction(actionVal);
                
                Object.entries(response.getReturnValue()).forEach(([key, value]) => types.push({label:key,value:value}));
                var cols = [
                    {label: "File Name", fieldName: "accountLink", type:"link", sortable: true, resizable:true, 
                     attributes:{label:{fieldName:"Name"}, title:"Click to View(New Window)", target:"_blank"}},
                    {label: "Document Type", fieldName: "Document_Type__c", editable: true, type:"picklist", selectOptions:types},            
                    {label: "Send To Lender", fieldName: "SendToLender__c", editable: true, type:"picklist", selectOptions:typesYesNo},
                    {
                        label: 'Download',
                        type: 'button-icon',
                        initialWidth: 135,
                        typeAttributes: { iconName: 'utility:download', name: 'download_file', title: 'Click to download' }
                    },
                    {
                        label: 'Delete',
                        type: 'button-iconDel',
                        initialWidth: 135,
                        typeAttributes: { iconName: 'action:delete', name: 'delete_file', title: 'Delete' }
                    },
                ];
                  /*   {label: "Download File", fieldName: "downloadLink", type:"link", sortable: true, resizable:true, 
                     attributes:{label:{fieldName:"Preview_Link__c"}, title:"Click to Download", target:"_blank"}}, */
                    
                component.set("v.columns", cols);
                this.loadRecords(component);
            }else{
                var errors = response.getError();
                var message = "Error: Unknown error";
                if(errors && Array.isArray(errors) && errors.length > 0)
                    message = "Error: "+errors[0].message;
                component.set("v.error", message);
                console.log("Error - setupTable: "+message);
            }
        });
        $A.enqueueAction(action);
    },
                    
    loadRecords : function(component) {
        var action = component.get("c.getRecords");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                var allRecords = response.getReturnValue();
                allRecords.forEach(rec => {
                    rec.accountLink = '/'+rec.Id;
                    rec.downloadLink ='/apex/ViewCloudDocument?id='+rec.Id;
                });
                component.set("v.data", allRecords);
                component.set("v.isLoading", false);
                
                if (component.get("v.isupload") === true) {
                    component.set("v.isupload", false);
                    var childCmp = component.find('datatableId');
                    childCmp.refreshTable(allRecords);
                }
            }else{
                var errors = response.getError();
                var message = "Error: Unknown error";
                if(errors && Array.isArray(errors) && errors.length > 0)
                    message = "Error: "+errors[0].message;
                component.set("v.error", message);
                console.log("Error - loadRecords: "+message);
            }
        });
        $A.enqueueAction(action);
    },
})