({
  doInit: function (component, event, helper) {
    helper.setupTable(component);
  },

  sortTable: function (component, event, helper) {
    component.set("v.isLoading", true);
    setTimeout(function () {
      var childObj = event.target;
      var parObj = childObj.parentNode;
      while (parObj.tagName != "TH") {
        parObj = parObj.parentNode;
      }
      var sortBy = parObj.name, //event.getSource().get("v.name"),
        sortDirection = component.get("v.sortDirection"),
        sortDirection = sortDirection === "asc" ? "desc" : "asc"; //change the direction for next time

      component.set("v.sortBy", sortBy);
      component.set("v.sortDirection", sortDirection);
      helper.sortData(component, sortBy, sortDirection);
      component.set("v.isLoading", false);
    }, 0);
  },

  calculateWidth: function (component, event, helper) {
    var childObj = event.target;
    var parObj = childObj.parentNode;
    var startOffset = parObj.offsetWidth - event.pageX;
    component.set("v.startOffset", startOffset);
  },

  setNewWidth: function (component, event, helper) {
    var childObj = event.target;
    var parObj = childObj.parentNode;
    while (parObj.tagName != "TH") {
      parObj = parObj.parentNode;
    }
    var startOffset = component.get("v.startOffset");
    var newWidth = startOffset + event.pageX;
    parObj.style.width = newWidth + "px";
  },

  editField: function (component, event, helper) {
    var field = event.getSource(),
      indexes = field.get("v.name"),
      rowIndex = indexes.split("-")[0],
      colIndex = indexes.split("-")[1];

    var data = component.get("v.tableData");
    data[rowIndex].fields[colIndex].mode = "edit";
    data[rowIndex].fields[colIndex].tdClassName =
      "slds-cell-edit slds-is-edited";
    component.set("v.tableData", data);
    component.set("v.isEditModeOn", true);
  },

  onInputChange: function (component, event, helper) {
    var field = event.getSource(),
      value = field.get("v.value"),
      indexes = field.get("v.name"),
      rowIndex = indexes.split("-")[0],
      colIndex = indexes.split("-")[1];

    helper.updateTable(component, rowIndex, colIndex, value);
  },

  onRowAction: function (component, event, helper) {
    var actionEvent = component.getEvent("dataTableRowActionEvent"),
      indexes = event.target.id, //rowIndex-colIndex-actionName
      params = indexes.split("-"),
      data = component.get("v.dataCache");

    actionEvent.setParams({
      actionName: params[2],
      rowData: data[params[0]]
    });
    actionEvent.fire();
  },

  closeEditMode: function (component, event, helper) {
    component.set("v.buttonsDisabled", true);
    component.set("v.buttonClicked", "Cancel");
    component.set("v.isLoading", true);
    setTimeout(function () {
      var dataCache = component.get("v.dataCache");
      var originalData = component.get("v.tableDataOriginal");
      component.set("v.data", JSON.parse(JSON.stringify(dataCache)));
      component.set("v.tableData", JSON.parse(JSON.stringify(originalData)));
      component.set("v.isEditModeOn", false);
      component.set("v.isLoading", false);
      component.set("v.error", "");
      component.set("v.buttonsDisabled", false);
      component.set("v.buttonClicked", "");
    }, 0);
  },

  saveRecords: function (component, event, helper) {
    component.set("v.buttonsDisabled", true);
    component.set("v.buttonClicked", "Save");
    component.set("v.isLoading", true);
    setTimeout(function () {
      var saveEvent = component.getEvent("dataTableSaveEvent");
      saveEvent.setParams({
        tableAuraId: component.get("v.auraId"),
        recordsString: JSON.stringify(component.get("v.modifiedRecords"))
      });
      saveEvent.fire();
    }, 0);
  },

  finishSaving: function (component, event, helper) {
    var params = event.getParam("arguments");
    if (params) {
      var result = params.result, //Valid values are "SUCCESS" or "ERROR"
        data = params.data, //refreshed data from server
        message = params.message;

      if (result === "SUCCESS") {
        //success
        if (data) {
          helper.setupData(component, data);
        } else {
          var dataCache = component.get("v.dataCache"),
            updatedData = component.get("v.updatedTableData");
          component.set("v.data", JSON.parse(JSON.stringify(dataCache)));
          component.set(
            "v.tableDataOriginal",
            JSON.parse(JSON.stringify(updatedData))
          );
          component.set("v.tableData", JSON.parse(JSON.stringify(updatedData)));
        }
        component.set("v.isEditModeOn", false);
      } else {
        if (message) component.set("v.error", message);
      }
    }
    component.set("v.isLoading", false);
    component.set("v.buttonsDisabled", false);
    component.set("v.buttonClicked", "");
  },

  deleteDocc: function (component, event, helper) {
    //console.log('TEsttttttttt'+JSON.stringify(component.get("v.data")));
    var field = event.getSource(),
      indexes = field.get("v.name"),
      rowIndex = indexes.split("-")[0],
      colIndex = indexes.split("-")[1];

    var data = component.get("v.tableData");
    var delCloudDocId = JSON.stringify(data[rowIndex].id);
    console.log("delCloudDocId Child =====" + delCloudDocId);
    var action = component.get("c.deleteCloudDoc");
    action.setParams({
      deleteDocId: delCloudDocId
    });
    component.set("v.isLoading", true);
    action.setCallback(this, function (response) {
      if (response.getState() === "SUCCESS") {
        var parentComponent = component.get("v.parentLoadRec");
        parentComponent.loadParentRec();
        var tableData = [],
          cols = component.get("v.columns");
        tableData = component.get("v.tableData");
        tableData.forEach(function (row, index, object) {
          var rowIdd = JSON.stringify(row.id);
          rowIdd = rowIdd.replace('"', "");
          rowIdd = rowIdd.replace('"', "");
          var delId = delCloudDocId;
          delId = delId.replace('"', "");
          delId = delId.replace('"', "");
          if (rowIdd === delId) {
            tableData.splice(index, 1);
          }
        });
        component.set("v.tableData", tableData);
      } else {
        var errors = response.getError();
        var message = "Error: Unknown error";
        if (errors) {
          console.log(`errors => ${JSON.stringify(errors)}`);
        }
        if (errors && Array.isArray(errors) && errors.length > 0)
          message = "Error: " + errors[0].message;
        component.set("v.error", message);
        console.log("Error - deleteDocc: " + message);
      }
      component.set("v.isLoading", false);
    });
    $A.enqueueAction(action);
  },

  openDocRec: function (component, event, helper) {
    component.set("v.isLoading", true);
    var field = event.getSource(),
      indexes = field.get("v.name"),
      rowIndex = indexes.split("-")[0],
      colIndex = indexes.split("-")[1];

    var data = component.get("v.tableData");
    var openCloudDocId = JSON.stringify(data[rowIndex].id);
    openCloudDocId = openCloudDocId.replace('"', "");
    openCloudDocId = openCloudDocId.replace('"', "");
    // window.open("/apex/ViewCloudDocument?id=" + openCloudDocId, "_blank");

    // Lelo     - open file from amazon S3
     var action = component.get("c.signCloudDocument");
     action.setParams({
       docId: openCloudDocId
     });
     action.setCallback(this, function (response) {
       if (response.getState() === "SUCCESS") {
         response.get
         window.open(response.getReturnValue(), "_blank");
       } else {
         var errors = response.getError();
         var message = "Error: Unknown error";
         if (errors && Array.isArray(errors) && errors.length > 0)
           message = "Error: " + errors[0].message;
         component.set("v.error", message);
         console.log("Error - openDocRec: " + message);
       }
       component.set("v.isLoading", false);
     });
     $A.enqueueAction(action);

  },

  refreshTable: function (component, event, helper) {
    var params = event.getParam("arguments");
    if (params) {
      var param1 = params.refreshedData;
      component.set("v.data", param1);
      helper.setupTable(component);
    }
  },

});