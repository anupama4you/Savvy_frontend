import { LightningElement, track, api } from "lwc";
import getPipelineOpportunities from "@salesforce/apex/PartnerCommunityController.getPipelineOpportunities";

const MAX_OPP_NAME = 19;
// const COLS = [
//   {
//     label: "Opportunity Name",
//     fieldName: "OppLink",
//     type: "url",
//     editable: false,
//     sortable: true,
//     typeAttributes: { label: { fieldName: "Name" } }
//   },
//   {
//     label: "Comm",
//     fieldName: "Total_Commission__c",
//     editable: false,
//     type: "currency",
//     cellAttributes: { alignment: "right" }
//   },
//   {
//     label: "NAF",
//     fieldName: "NAF_Net_Amount_Financed__c",
//     editable: false,
//     type: "currency",
//     cellAttributes: { alignment: "right" }
//   }
// ];
export default class MyOppPipelineReport extends LightningElement {
  @api portalName;

  activeSections = [];
  // columns = COLS;

  @track myRecords;

  connectedCallback() {
    this.reloadOpps();
  }

  reloadOpps() {
    // console.log(`Reloading opps...`);
    getPipelineOpportunities()
      .then((results) => {
        // console.log("🚀 ~ file: myOppPipelineReport.js ~ line 45 ~ MyOppPipelineReport ~ .then ~ results", JSON.stringify(results, null, 2));        
        this.myRecords = results;
      })
      .catch((error) => {
        console.log("error:", error);
      })
      .finally(() => {
        console.log(`Opps reloaded!`);
      });
  }

  get listOpportunities() {
    var r = new Array();
    if (this.myRecords) {
      console.log(`records:`, JSON.stringify(this.myRecords, null, 2));
      if (this.myRecords) {
        let baseUrl = "";
        if (this.portalName) {
          baseUrl = this.portalName;
        }
        for (let key in this.myRecords) {
          if ({}.hasOwnProperty.call(this.myRecords, key)) {
            let d = [];
            this.myRecords[key].forEach((o) => {
              let tempOpp = Object.assign({}, o);
              tempOpp.OppLink = `${baseUrl}/${o.Id}`;
              tempOpp.OppLabel = this.formatOppLabel(o.Name);
              tempOpp.OppModDate = o.LastModifiedDate;
              // tempOpp.OppLink = `https://dev-quantumsavvy.cs6.force.com/holabroker/s/custom-opportunity/${o.Id}`;
              d.push(tempOpp);
            });
            r.push({
              key: key,
              label: `${key} (${this.myRecords[key].length})`,
              values: d
            });
          }
        }
        return r;
      }
    }
    return [];
  }

  // handleSectionToggle(event) {
  //   // const openSections = event.detail.openSections;
  //   // if (openSections.length === 0) {
  //   //   // this.activeSectionsMessage = "All sections are closed";
  //   //   console.log(`All sections are closed`);
  //   // } else {
  //   //   // this.activeSectionsMessage = "Open sections: " + openSections.join(", ");
  //   //   console.log(`open sections: ${openSections.join(", ")}`);
  //   // }
  // }

  formatOppLabel(label) {
    let r = label;
    if (label && label.length > MAX_OPP_NAME) {
      r = label.substr(0, MAX_OPP_NAME - 3);
      r += "...";
    }
    return r;
  }

  handleSectionClieck(event) {
    console.log(`Section click...`);
    // console.log(`${JSON.stringify(event.details, null, 2)}`);
  }
}