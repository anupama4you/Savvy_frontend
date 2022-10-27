import { ShowToastEvent } from "lightning/platformShowToastEvent";

const buildErrorMessage = (err) => {
  console.log(`buildErrorMessage...`);
  let m = "";
  if (err) {
    if (err.body) {
      m += err.body.message ? `${err.body.message}` : "";
      m += err.body.exceptionType ? `<hr/>${err.body.exceptionType}: ` : "";
      m += err.body.stackTrace ? `<p><i>${err.body.stackTrace}</i><p>` : "";
    }
    m += err.status ? `[Status: ${err.status}] ` : "";
  }
  return m;
};

const displayToast = (comp, title, message, variant) => {
  const evt = new ShowToastEvent({
    title: `${title}`,
    message: `${message}`,
    variant: `${variant ? variant : "info"}`
  });
  comp.dispatchEvent(evt);
}

const getQuotingPageName = (calcName) => {
  console.log(`getQuotingPageName...`, calcName);
  let pageName = "Quoting_Tools__c";
  if (calcName) {
    // console.log(`Quoting Name => ${calcName}`);
    if (calcName === "Affordable") {
      pageName = "PARTNER_QT_Affordable__c";
    } else if (calcName === "AFS Commercial") {
      pageName = "PARTNER_QT_AFS_Commercial__c";
    } else if (calcName === "AFS Consumer") {
      pageName = "PARTNER_QT_AFS_Consumer__c";
    } else if (calcName === "AMMF" || calcName === "Yamaha Marine") {
      pageName = "PARTNER_QT_AMMF__c";
    } else if (calcName === "ANZ Commercial") {
      pageName = "PARTNER_QT_ANZ_Comm__c";
    } else if (calcName === "ANZ Others") {
      pageName = "PARTNER_QT_ANZ_Others__c";
    } else if (calcName === "APF") {
      pageName = "PARTNER_QT_APF__c";
    } else if (calcName === "Azora Consumer") {
      pageName = "PARTNER_QT_Azora__c";
    } else if (calcName === "Azora Consumer") {
      pageName = "PARTNER_QT_Azora__c";
    } else if (calcName === "BOQ") {
      pageName = "PARTNER_QT_BOQ__c";
    } else if (calcName === "CarStart") {
      pageName = "PARTNER_QT_CarStart__c";
    } else if (calcName === "Finance One") {
      pageName = "PARTNER_QT_Finance1__c";
    } else if (calcName === "Finance One Commercial") {
      pageName = "PARTNER_QT_Finance1_Comm__c";
    } else if (calcName === "Finance One PL") {
      pageName = "PARTNER_QT_Finance1_PL__c";
    } else if (calcName === "Firstmac") {
      pageName = "PARTNER_QT_Firstmac__c";
    } else if (calcName === "General") {
      pageName = "PARTNER_QT_General__c";
    } else if (calcName === "Green Light") {
      pageName = "PARTNER_QT_Green_Light__c";
    } else if (calcName === "Latitude") {
      pageName = "PARTNER_QT_Latitude__c";
    } else if (
      calcName === "Latitude PL" ||
      calcName === "Latitude Personal Loan"
    ) {
      pageName = "PARTNER_QT_Latitude_PL__c";
    } else if (calcName === "Liberty" || calcName === "Liberty Drive") {
      pageName = "PARTNER_QT_Liberty__c";
    } else if (calcName === "Liberty Leisure") {
      pageName = "PARTNER_QT_Liberty_Leisure__c";
    } else if (calcName === "Liberty Commercial") {
      pageName = "PARTNER_QT_Liberty_Comm__c";
    } else if (calcName === "Macquarie Commercial") {
      pageName = "PARTNER_QT_Macquarie_Commercial__c";
    } else if (calcName === "Macquarie Consumer") {
      pageName = "PARTNER_QT_Macquarie_Consumer__c";
    } else if (calcName === "Metro") {
      pageName = "PARTNER_QT_Metro__c";
    } else if (calcName === "Money Place") {
      pageName = "PARTNER_QT_Money_Place__c";
    } else if (calcName === "Money3") {
      pageName = "PARTNER_QT_Money3__c";
    } else if (calcName === "Now Finance") {
      pageName = "PARTNER_QT_Now_Finance__c";
    } else if (calcName === "Pepper Leisure") {
      pageName = "PARTNER_QT_Pepper_Leisure__c";
    } else if (calcName === "Pepper MV") {
      pageName = "PARTNER_QT_Pepper_MV__c";
    } else if (calcName === "Pepper PL") {
      pageName = "PARTNER_QT_Pepper_PL__c";
    } else if (calcName === "Pepper Commercial") {
      pageName = "PARTNER_QT_Pepper_Comm__c";
    } else if (calcName === "RateSetter") {
      pageName = "PARTNER_QT_Plenti__c";
    } else if (calcName === "Plenti Commercial") {
      pageName = "PARTNER_QT_Plenti_Comm__c";
    } else if (calcName === "RateSetter PL") {
      pageName = "PARTNER_QT_Plenti_PL__c";
    } else if (calcName === "Prospa") {
      pageName = "PARTNER_QT_Prospa__c";
    } else if (calcName === "Society One") {
      pageName = "PARTNER_QT_Society_One__c";
    } else if (calcName === "UME Loans") {
      pageName = "PARTNER_QT_UME_Loans__c";
    } else if (calcName === "Wisr VL") {
      pageName = "PARTNER_QT_Wisr__c";
    } else if (calcName === "Westpac") {
      pageName = "PARTNER_QT_Westpac__c";
    } else if (calcName === "Wisr") {
      pageName = "PARTNER_QT_Wisr_PL__c";
    } else if (calcName === "Azora") {
      pageName = "PARTNER_QT_Azora__c";
    } else if (calcName === "Shift Asset") {
      pageName = "PARTNER_QT_Shift_Asset__c";
    } else if (calcName === "Shift ODR") {
      pageName = "PARTNER_QT_Shift_ODR__c";
    } else if (calcName === "Grow Asset") {
      pageName = "PARTNER_QT_Grow_Asset__c";
    } else if (calcName === "Grow Business Loan") {
      pageName = "PARTNER_QT_Grow_Business__c";
    } else if (calcName === "Angle Finance") {
      pageName = "PARTNER_QT_Angle_Finance__c";
    } else if (calcName === "Morris") {
      pageName = "PARTNER_QT_Morris__c";
    } else if (calcName === "Selfco") {
      pageName = "PARTNER_QT_Selfco__c";
    } else if (calcName === "Silver Chef") {
      pageName = "PARTNER_QT_Silver_Chef__c";
    } else if (calcName === "Capital Finance") {
      pageName = "PARTNER_QT_Capital_Finance__c";
    } else if (calcName === "Fleet Partners") {
      pageName = "PARTNER_QT_Fleet_Partners__c";
    } else if (calcName === "Group and General") {
      pageName = "PARTNER_QT_Group_General__c";
    } else if (calcName === "Commercial Equity Group") {
      pageName = "PARTNER_QT_Commercial_Equity_Group__c";
    } else if (calcName === "Krisp") {
      pageName = "PARTNER_QT_Krisp__c";
    } else if (calcName === "Branded Consumer") {
      pageName = "PARTNER_QT_BRANDED_Consumer__c";
    } else if (calcName === "Branded Commercial") {
      pageName = "PARTNER_QT_branded_commercial__c";
    } else if (calcName === "Racv") {
      pageName = "PARTNER_QT_Racv__c";
    } 
  }

  return pageName;
};

export { buildErrorMessage, displayToast, getQuotingPageName };