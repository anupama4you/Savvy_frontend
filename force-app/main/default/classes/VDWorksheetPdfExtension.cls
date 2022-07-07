public with sharing class VDWorksheetPdfExtension {

	public Boolean isPreviewMode {set;get;}

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public VDWorksheetPdfExtension(ApexPages.StandardController stdController) {
        isPreviewMode = false;
        String preview = System.currentPageReference().getParameters().get('PV');
        if ('1'.equals(preview)) {
            isPreviewMode = true;
        }
    }
    
}