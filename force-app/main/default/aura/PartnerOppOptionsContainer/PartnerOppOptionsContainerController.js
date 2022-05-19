({
    doInit : function(component, event, helper) {
        console.log(' record Id', JSON.parse(JSON.stringify(component.get("v.recordId"))));
        const urlSearchParams = new URLSearchParams(window.location.search);
        let compSelected = urlSearchParams.get('selCmp');
        component.set('v.selCmp',compSelected);
        console.log(' record Id', JSON.parse(JSON.stringify(component.get("v.selCmp"))));
        component.set("v.renderNow", true);
    },
    handleComponentSelect: function(component, event, helper){
        let componentSelected = event.getParam('cmpName');
        component.set("v.selCmp", componentSelected);
    }
})