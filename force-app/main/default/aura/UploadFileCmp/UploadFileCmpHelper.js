({
	toastMsg : function( strType, strMessage ) {
        var showToast = $A.get( "e.force:showToast" );
        showToast.setParams({
            message : strMessage,
            type : strType,
            mode : 'sticky',
            duration : 6000
        });
        showToast.fire();
    }
});