({
    doInit : function(component, event, helper) {
        component.set("v.isLoading", true);
        helper.setupTable(component);
    },
    
    saveTableRecords : function(component, event, helper) {
        var recordsData = event.getParam("recordsString");
        var tableAuraId = event.getParam("tableAuraId");
        var action = component.get("c.updateRecords");
        action.setParams({
            jsonString: recordsData
        });
        action.setCallback(this,function(response){
            var datatable = component.find(tableAuraId);
            datatable.finishSaving("SUCCESS");
        });
        $A.enqueueAction(action);        
    },
    
    handleUploadFinished : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        // alert("Files uploaded : " + uploadedFiles.length);
        component.set("v.isupload", true);
        component.set("v.isLoading", true);
		
        // Get the file name
        uploadedFiles.forEach(file => {
            //console.log('======File Id =====' + file.documentId + '======File Name =====' + file.name + '======Parent Opp Id =====' + component.get("v.recordId") + '====== File fileType =====' + JSON.stringify(file.type));
            //console.log('file =====>' + JSON.stringify(file));
            var action = component.get("c.insertCloudDoc");
            action.setParams({
                docId: file.documentId,
                docName: file.name,
                customOppId: component.get("v.recordId")
            });
            action.setCallback(this,function(response){
                if(response.getState() === "SUCCESS"){
                    component.set("v.isLoading", true);
        			      helper.setupTable(component);
                } else {
                    component.set("v.isLoading", false);
                    var errors = response.getError();
                    var message = "Error: Unknown error";
                    if(errors && Array.isArray(errors) && errors.length > 0)
                        message = "Error: "+errors[0].message;
                    component.set("v.error", message);
                    console.log("Error - loadRecords: "+message);
                }
            });
            $A.enqueueAction(action);
        });
    }
})