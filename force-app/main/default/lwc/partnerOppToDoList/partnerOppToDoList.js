import { LightningElement, api, track, wire } from "lwc";
import { NavigationMixin, CurrentPageReference } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getOppTodoListStatuses from "@salesforce/apex/PartnerCommunityController.getOppTodoListStatuses";
import getLenderSettings from "@salesforce/apex/PartnerCommunityApprovals.getLenderSettings";
// import getOppQuoting from "@salesforce/apex/PartnerCommunityController.getOppQuoting";
import { getQuotingPageName } from "c/partnerJsUtils";

export default class PartnerOppToDoList extends NavigationMixin(LightningElement) {
  @api recordId;
  @api quoting;
  @track displayComp = false;
  @api isExternal = false;
  appFormUrl;
  compToolUrl;
  quotingToolUrl;
  quotingToolPageUrl;
  ytdCalcUrl;
  servicingUrl;
  assetDetUrl;
  todoStatus = {};
  lenderSettings;

  cpr;
  selectedApplicationTab = false;
  selectedComparisonToolTab = false;

  // @wire(getOppQuoting, { oppId: "$recordId", fields: ["Id", "Name"] })
  // wireQuoting({ error, data }) {
  //   console.log(`wiring quoting...`);
  //   if (data) {
  //     console.log(JSON.stringify(data, null, 2));
  //     this.quoting = data;
  //     const pageRef = this.buildPageRef(this.findQuotingPage());
  //     this[NavigationMixin.GenerateUrl](pageRef)
  //       .then((url) => {
  //         this.quotingToolUrl = url;
  //       })
  //       .catch((err) => console.log(err));
  //   } else if (error) {
  //     console.log(error);
  //     this.quoting = undefined;
  //   }
  // }

  @wire(CurrentPageReference)
  getPageRef(pageRef) {
    // console.log("getPageRef data => ", JSON.stringify(pageRef));
    this.cpr = pageRef;
    // TODO: identify the url, so use it to check if the current page is a calculator, it should be a instance variable to be used in displayAllLenderButton method
  }

  @wire(getLenderSettings, { oppId: "$recordId" })
  wireLenderSettings({ error, data }) {
    // console.log(`wiring lender settings...`);
    if (data) {
      // console.log(JSON.stringify(data));
      this.lenderSettings = data;
    } else if (error) {
      console.log(error);
      this.lenderSettings = undefined;
    }
  }

  connectedCallback() {
    if (this.recordId && this.recordId != null && this.recordId !== "null") {
      this.displayComp = true;

      let pageRef = this.buildPageRef("Sales_Tools__c");
      this[NavigationMixin.GenerateUrl](pageRef)
        .then((url) => {
          this.appFormUrl = url;
          // this.appFormUrl = this.appFormUrl + '&p=OppApplication';
        })
        .catch((err) => console.log(err));

      let pageRefCt = this.buildPageRef("Comparison_Tool__c");
      this[NavigationMixin.GenerateUrl](pageRefCt)
        .then((url) => {
          this.compToolUrl = url;
        })
        .catch((err) => {
          console.log(err);
        });

      let pageRefQt = this.buildPageRef(this.findQuotingPage());
      this[NavigationMixin.GenerateUrl](pageRefQt)
        .then((url) => {
          this.quotingToolUrl = url;
          console.log(`this.quotingToolUrl 1: ${this.quotingToolUrl}`);
        })
        .catch((err) => console.error(err));

      let pageRefQtp = this.buildPageRef("Quoting_Tools__c");
      this[NavigationMixin.GenerateUrl](pageRefQtp)
        .then((url) => {
          this.quotingToolPageUrl = url;
        })
        .catch((err) => console.log(err));

      let pageRefYtd = this.buildPageRef("YTD_Income_Calculator__c");
      this[NavigationMixin.GenerateUrl](pageRefYtd)
        .then((url) => {
          this.ytdCalcUrl = url;
        })
        .catch((err) => console.log(err));

      let pageRefSer = this.buildPageRef("Servicing_Calculator__c");
      this[NavigationMixin.GenerateUrl](pageRefSer)
        .then((url) => {
          this.servicingUrl = url;
        })
        .catch((err) => console.log(err));

      let pageRefAd = this.buildPageRef("Asset_Details_LTV__c");
      this[NavigationMixin.GenerateUrl](pageRefAd)
        .then((url) => {
          this.assetDetUrl = url;
        })
        .catch((err) => console.log(err));

      this.loadStatuses();
    }
  }

  get quotingLabel() {
    let r = "Quote - Select Lender";
    if (this.lenderSettings && this.lenderSettings.Label__c) {
      r = `Quote - ${this.lenderSettings.Label__c}`;
      console.log('label@', JSON.stringify(this.lenderSettings, null, 2))
    } else if (this.quoting) {
      r = `Quote - ${this.quoting.Name}`;
      console.log('label1@', this.quoting.Name)
    }
    this.loadQuotingUrl();
    return r;
  }

  get displayAllLenderButton() {
    if (this.quoting && this.cpr && this.cpr.attributes) {
      const pn = this.cpr.attributes.name;
      if (pn && pn.startsWith("PARTNER_QT_")) {
        return true;
      }
    }
    return false;
  }

  buildPageRef(pageName, params) {
    let myState = {
      recordId: this.recordId,
      oppName: this.oppName
    };
    if (params) {
      myState = Object.assign(myState, params);
    }
    return {
      type: "comm__namedPage",
      attributes: {
        name: pageName
      },
      state: myState
    };
  }

  handleSelect(event) {
    const selected = event.detail.name;
    if (selected === "Application_form") {
      this.selectedApplicationTab = true;
    }
    if (selected === "Comparison_Tool") {
      this.selectedComparisonToolTab = true;
    }
    //selectedTab
  }

  displayToast(title, message, variant) {
    const evt = new ShowToastEvent({
      title: `${title}`,
      message: `${message}`,
      variant: `${variant ? variant : "info"}`
    });
    this.dispatchEvent(evt);
  }

  loadStatuses() {
    getOppTodoListStatuses({ oppId: this.recordId })
      .then((data) => {
        // console.log(`getOppTodoListStatuses...`);
        // console.log(JSON.stringify(data));
        this.todoStatus = data;
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error in displaying data!!",
            message: error.message,
            variant: "error"
          })
        );
      });
  }

  findQuotingPage() {
    return getQuotingPageName(
      this.quoting ? this.quoting.Name : undefined
    );
  }

  loadQuotingUrl() {
    if (this.quoting) {
      const pageRef = this.buildPageRef(this.findQuotingPage());
      this[NavigationMixin.GenerateUrl](pageRef)
        .then((url) => {
          this.quotingToolUrl = url;
          // console.log(`this.quotingToolUrl 2: ${this.quotingToolUrl}`);
        })
        .catch((err) => console.log(err));
    }
  }
}