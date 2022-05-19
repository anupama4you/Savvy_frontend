({
	handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
        
        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
    },
    
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Id', fieldName: 'Id', type: 'text'},
            {label: 'File Name', fieldName: 'Name', type: 'text', editable: true},
            {label: "Document Type", fieldName: "Document_Type__c", editable: true, type:"picklist",
                typeAttributes: {
                    placeholder: 'Document Type',
                    selectOptions: [
                        { label: 'Certified ID', value: 'Certified ID' },
                        { label: 'Medicare Card', value: 'Medicare Card' }
                    ],
                    value: { fieldName: 'Document_Type__c' },
                    context: { fieldName: 'Document_Type__c' },
                    variant: 'label-hidden',
                    name: 'Stage',
                    label: 'Stage'
                },
             	cellAttributes: {
                    class: { fieldName: 'Document_Type__c' }
                }
            },
            {label: 'Send To Lender', fieldName: 'Send_To_Lender__c', type: 'boolean', editable: true },
            {label: 'File', fieldName: 'confidence', type: 'percent', editable: true },
        ]);
        
        var action = cmp.get("c.listCloudDocuments");
        action.setParams({ oppId : cmp.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.data", response.getReturnValue());
            	console.log("Success Data: " + state);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    handleSaveEdition: function (cmp, event, helper) {
        var drafts = event.getParam('draftValues');
        cmp.set('v.draftValues', event.getParam('draftValues'));
        console.log('drafts =====>' + JSON.stringify(drafts));
        
        var action = cmp.get("c.updateCloudDocuments");
        action.setParams({
            'updatedDocList' : JSON.stringify(drafts)
        });
        action.setCallback( this, function( response ) {
            var state = response.getState();
            if ( state === "SUCCESS" ) {
                if ( response.getReturnValue() === true ) {
                    helper.toastMsg( 'success', 'Records Saved Successfully.' );
                    cmp.find("doctTable").set("v.draftValues", null);
                } else {
                    helper.toastMsg( 'error', 'Something went wrong. Contact your system administrator.' );
                }
            } else {
                helper.toastMsg( 'error', 'Something went wrong. Contact your system administrator.' );
            }
        });
        $A.enqueueAction( action );
            
        var action2 = cmp.get("c.listCloudDocuments");
        action2.setParams({ oppId : cmp.get("v.recordId") });
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.data", response.getReturnValue());
            	console.log("Success Data: " + state);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action2);
    },
    
    handleCancelEdition: function (cmp) {
        // do nothing for now...
    }
});