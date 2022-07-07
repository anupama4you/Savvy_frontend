import { LightningElement, api, track, wire } from "lwc";
import { NavigationMixin, CurrentPageReference } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getOppTodoListStatuses from "@salesforce/apex/PartnerCommunityController.getOppTodoListStatuses";
import getLenderSettings from "@salesforce/apex/PartnerCommunityApprovals.getLenderSettings";
// import getOppQuoting from "@salesforce/apex/PartnerCommunityController.getOppQuoting";

export default class PartnerOppToDoList extends NavigationMixin(LightningElement) {
  @api recordId;
  @api quoting;
  @track displayComp = false;
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
    if (this.lenderSettings) {
      r = `Quote - ${this.lenderSettings.Label__c}`;
    } else if (this.quoting) {
      r = `Quote - ${this.quoting.Name}`;      
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
    let r = "Quoting_Tools__c";
    if (this.quoting) {
      // console.log(`Quoting Name => ${this.quoting.Name}`);
      if (this.quoting.Name === "Affordable") {
        r = "PARTNER_QT_Affordable__c";
      } else if (this.quoting.Name === "AFS Commercial") {
        r = "PARTNER_QT_AFS_Commercial__c";
      } else if (this.quoting.Name === "AFS Consumer") {
        r = "PARTNER_QT_AFS_Consumer__c";
      } else if (this.quoting.Name === "Yamaha Marine") {
        r = "PARTNER_QT_AMMF__c";
      } else if (this.quoting.Name === "ANZ Commercial") {
        r = "PARTNER_QT_ANZ_Comm__c";
      } else if (this.quoting.Name === "ANZ Others") {
        r = "PARTNER_QT_ANZ_Others__c";
      } else if (this.quoting.Name === "APF") {
        r = "PARTNER_QT_APF__c";
      } else if (this.quoting.Name === "Azora Consumer") {
        r = "PARTNER_QT_Azora__c";
      } else if (this.quoting.Name === "BOQ") {
        r = "PARTNER_QT_BOQ__c";
      } else if (this.quoting.Name === "Finance One") {
        r = "PARTNER_QT_Finance1__c";
      } else if (this.quoting.Name === "Finance One Commercial") {
        r = "PARTNER_QT_Finance1_Comm__c";
      } else if (this.quoting.Name === "Finance One PL") {
        r = "PARTNER_QT_Finance1_PL__c";
      } else if (this.quoting.Name === "Firstmac") {
        r = "PARTNER_QT_Firstmac__c";
      } else if (this.quoting.Name === "General") {
        r = "PARTNER_QT_General__c";
      } else if (this.quoting.Name === "Green Light") {
        r = "PARTNER_QT_Green_Light__c";
      } else if (this.quoting.Name === "Latitude") {
        r = "PARTNER_QT_Latitude__c";
      } else if (this.quoting.Name === "Latitude Personal Loan") {
        r = "PARTNER_QT_Latitude_PL__c";
      } else if (this.quoting.Name === "Liberty Drive") {
        r = "PARTNER_QT_Liberty__c";
      } else if (this.quoting.Name === "Liberty Leisure") {
        r = "PARTNER_QT_Liberty_Leisure__c";
      } else if (this.quoting.Name === "Liberty Commercial") {
        r = "PARTNER_QT_Liberty_Comm__c";
      } else if (this.quoting.Name === "Macquarie Commercial") {
        r = "PARTNER_QT_Macquarie_Commercial__c";
      } else if (this.quoting.Name === "Macquarie Consumer") {
        r = "PARTNER_QT_Macquarie_Consumer__c";
      } else if (this.quoting.Name === "Metro") {
        r = "PARTNER_QT_Metro__c";
      } else if (this.quoting.Name === "Money Place") {
        r = "PARTNER_QT_Money_Place__c";
      } else if (this.quoting.Name === "Money3") {
        r = "PARTNER_QT_Money3__c";
      } else if (this.quoting.Name === "Now Finance") {
        r = "PARTNER_QT_Now_Finance__c";
      } else if (this.quoting.Name === "Pepper Leisure") {
        r = "PARTNER_QT_Pepper_Leisure__c";
      } else if (this.quoting.Name === "Pepper MV") {
        r = "PARTNER_QT_Pepper_MV__c";
      } else if (this.quoting.Name === "Pepper PL") {
        r = "PARTNER_QT_Pepper_PL__c";
      } else if (this.quoting.Name === "Pepper Commercial") {
        r = "PARTNER_QT_Pepper_Comm__c";
      } else if (this.quoting.Name === "RateSetter") {
        r = "PARTNER_QT_Plenti__c";
      } else if (this.quoting.Name === "Plenti Commercial") {
        r = "PARTNER_QT_Plenti_Comm__c";
      } else if (this.quoting.Name === "RateSetter PL") {
        r = "PARTNER_QT_Plenti_PL__c";
      } else if (this.quoting.Name === "Prospa") {
        r = "PARTNER_QT_Prospa__c";
      } else if (this.quoting.Name === "Society One") {
        r = "PARTNER_QT_Society_One__c";
      } else if (this.quoting.Name === "UME Loans") {
        r = "PARTNER_QT_UME_Loans__c";
      } else if (this.quoting.Name === "Wisr VL") {
        r = "PARTNER_QT_Wisr__c";
      } else if (this.quoting.Name === "Westpac") {
        r = "PARTNER_QT_Westpac__c";
      } else if (this.quoting.Name === "Wisr") {
        r = "PARTNER_QT_Wisr_PL__c";
      } else if (this.quoting.Name === "Azora") {
        r = "PARTNER_QT_Azora__c";
      } else if (this.quoting.Name === "Shift Asset") {
        r = "PARTNER_QT_Shift_Asset__c";
      } else if (this.quoting.Name === "Shift ODR") {
        r = "PARTNER_QT_Shift_ODR__c";
      } else if (this.quoting.Name === "Grow Asset") {
        r = "PARTNER_QT_Grow_Asset__c";
      } else if (this.quoting.Name === "Grow Business Loan") {
        r = "PARTNER_QT_Grow_Business__c";
      } else if (this.quoting.Name === "Angle Finance") {
        r = "PARTNER_QT_Angle_Finance__c";
      } else if (this.quoting.Name === "Morris") {
        r = "PARTNER_QT_Morris__c";
      } else if (this.quoting.Name === "Selfco") {
        r = "PARTNER_QT_Selfco__c";
      } else if (this.quoting.Name === "Silver Chef") {
        r = "PARTNER_QT_Silver_Chef__c";
      } else if (this.quoting.Name === "Capital Finance") {
        r = "PARTNER_QT_Capital_Finance__c";
      } else if (this.quoting.Name === "Fleet Partners") {
        r = "PARTNER_QT_Fleet_Partners__c";
      } else if (this.quoting.Name === "Group and General") {
        r = "PARTNER_QT_Group_General__c";
      } else if (this.quoting.Name === "Commercial Equity Group") {
        r = "PARTNER_QT_Commercial_Equity_Group__c";
      }
      
    }
    // console.log(`Quoting tool page => ${r}`);
    return r;
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