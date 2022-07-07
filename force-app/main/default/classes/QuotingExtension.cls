public virtual class QuotingExtension extends QuotingExtensionAbstract {

  public QuotingExtension quotingExt {
      get {
          return this;
      }
  }

  public QuotingExtension() {
    super();
  }

  public QuotingExtension(ApexPages.StandardController controller) {
    super(controller);
    System.debug('Creating QuotingExtension controller...');
  }

  public QuotingExtension(ApexPages.StandardController controller, Set<String> extraFields) {
    super(controller, extraFields);
    System.debug('Creating QuotingExtension controller + extraFields...');
  }

  public virtual override void calculateQuote() {

  } 

  public virtual override Boolean hasValidQuotation() {
    System.debug('QuotingExtension default methid hasValidQuotation!');
    return false;
  }

  public virtual override void storeQuotingData() {

  } 

}