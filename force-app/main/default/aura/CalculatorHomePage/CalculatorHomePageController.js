({
	doInit : function(component, event, helper) {
		var action = component.get("c.callCalculater");
        action.setParams({
            opportunityId: component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
              //  response.getReturnValue()
               
                component.set("v.redirectUrlWrapper", response.getReturnValue());
                console.log('::: '+JSON.stringify(component.get("v.redirectUrlWrapper")));
               // this.loadRecords(component);
            }else{
                var errors = response.getError();
                var message = "Error: Unknown error";
                if(errors && Array.isArray(errors) && errors.length > 0)
                    message = "Error: "+errors[0].message;
               // component.set("v.error", message);
                console.log("Error - setupTable: "+message);
            }
        });
        $A.enqueueAction(action);
	},
    OpenOppApplicationForm : function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/partner/s/sfdcpage/%2Fapex%2FOppApplication%3Fid%3D"+component.get("v.recordId")+"%26isdtp%3Dp1"
        });
        urlEvent.fire();
    },
    OpenLender_Comparison : function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/partner/s/sfdcpage/%2Fapex%2FLenderComparisonFilter%3Fid%3D"+component.get("v.recordId")+"%26isdtp%3Dp1"
        });
        urlEvent.fire();
    },
    OpenQuoting_Tools : function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/partner/s/sales-tools/quoting-tools?recordId="+component.get("v.recordId")
        });
        urlEvent.fire();
    },
    OpenYTD_Income_Calculator : function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/partner/s/sfdcpage/%2Fapex%2FYTDCalculator%3Fid%3D"+component.get("v.recordId")+"%26isdtp%3Dp1"
        });
        urlEvent.fire();
    },
    OpenServicing_Calculator :  function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/partner/s/sfdcpage/%2Fapex%2FServicingCalculator%3Fid%3D"+component.get("v.recordId")+"%26isdtp%3Dp1"
        });
        urlEvent.fire();
    },
    OpenAsset_Details_LTV : function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/partner/s/sfdcpage/%2Fapex%2FGlassServiceEstimator%3Fid%3D"+component.get("v.recordId")+"%26isdtp%3Dp1"
        });
        urlEvent.fire();
    },
    OpenNotes : function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/partner/s/sfdcpage/%2Fapex%2FOppApplication%3Fid%3D"+component.get("v.recordId")+"%26sec%3DNTS%26isdtp%3Dp1"
        });
        urlEvent.fire();
    },
    CreditHistory :  function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/partner/s/sfdcpage/%2Fapex%2FCreditHistory%3Fid%3D"+component.get("v.recordId")+"%26isdtp%3Dp1"
        });
        urlEvent.fire();
    },
    OpenPreApproval :  function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/apex/ValidatePreApprovalSubmit?id="+component.get("v.recordId"),
            "isredirect": true
        });
        urlEvent.fire();
    },
    OpenAmendment :  function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/apex/ValidateAmendmentSubmit?id="+component.get("v.recordId"),
            "isredirect": true
        });
        urlEvent.fire();
    },
    OpenFormalApproval :  function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/apex/ValidateFormalApprovalSubmit?id="+component.get("v.recordId"),
            "isredirect": true
        });
        urlEvent.fire();
    },
    
    
})