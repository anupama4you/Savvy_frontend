public with sharing class ViewCloudDocumentController {
  private Id recordId;
  public ViewCloudDocumentController() {
    this.recordId = ApexPages.currentPage().getParameters().get('id');
  }

  public PageReference init() {
    if (this.recordId != null) {
      String url = S3Utils.getSignedURL(this.recordId);
      PageReference pageRef = new PageReference(url);
      return pageRef.setRedirect(true);
    }
    return null;
  }
}