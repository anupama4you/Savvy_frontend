({
    setupTable : function(component) {
        var action = component.get("c.getPicklistValues");
        action.setParams({
            objectAPIName: "Account",
            fieldAPIName: "Type"
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                var types = [];
                Object.entries(response.getReturnValue()).forEach(([key, value]) => types.push({label:key,value:value}));
                var cols = [
                    {label: "Account Name", fieldName: "accountLink", type:"link", sortable: true, resizable:true, 
                     attributes:{label:{fieldName:"Name"}, title:"Click to View(New Window)", target:"_blank"}},
                    {label: "Created Date", fieldName: "CreatedDate", type:"date", sortable: true},
                    {label: "Type", fieldName: "Type", editable: true, type:"picklist", selectOptions:types},            
                    {label: "Shipping Street", fieldName: "ShippingStreet", sortable: true, },
                    {label: "Shipping City", fieldName: "ShippingCity", editable: true},            
                    {label: "Shipping State", fieldName: "ShippingState"},
                    {label: "Shipping PostalCode", fieldName: "ShippingPostalCode"},
                    {label: "Shipping Country", fieldName: "ShippingCountry"},                                
                    
                ];
                component.set("v.columns", cols);
                this.loadRecords(component);
            }else{
                var errors = response.getError();
                var message = "Error: Unknown error";
                if(errors && Array.isArray(errors) && errors.length > 0)
                    message = "Error: "+errors[0].message;
                component.set("v.error", message);
                console.log("Error: "+message);
            }
        });
        $A.enqueueAction(action);
    },
                    
    loadRecords : function(component) {
        var action = component.get("c.getRecords");
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                var allRecords = response.getReturnValue();
                allRecords.forEach(rec => {
                    rec.accountLink = '/'+rec.Id;
                });
                component.set("v.data", allRecords);
                component.set("v.isLoading", false);
            }else{
                var errors = response.getError();
                var message = "Error: Unknown error";
                if(errors && Array.isArray(errors) && errors.length > 0)
                    message = "Error: "+errors[0].message;
                component.set("v.error", message);
                console.log("Error: "+message);
            }
        });
        $A.enqueueAction(action);
    },
})