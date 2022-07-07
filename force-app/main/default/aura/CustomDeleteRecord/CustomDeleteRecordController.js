/*quickAddController.js*/
({
  "deleteRecord": function (component, event, helper) {
    console.log(`recordId:`, component.get("v.recordId"));
    var action = component.get("c.deleteRecord");
    action.setParams({ recordId: component.get("v.recordId") });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state == "SUCCESS") {
        console.log(JSON.stringify(response.getReturnValue(), null, 2));
        component.set("v.isRecordDeleted", true);
      }
    });
    $A.enqueueAction(action);
  }
});