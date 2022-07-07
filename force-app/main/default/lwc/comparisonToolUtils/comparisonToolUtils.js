import LOGO_AFFORDABLE from "@salesforce/resourceUrl/ACLLogo";
import LOGO_AFS from "@salesforce/resourceUrl/AFSLogo";
import LOGO_AMMF from "@salesforce/resourceUrl/YamahaLogo";
import LOGO_ANGLE from "@salesforce/resourceUrl/AngleFinanceLogo";
import LOGO_ANZ from "@salesforce/resourceUrl/ANZLogo";
import LOGO_APF from "@salesforce/resourceUrl/APFLogo";
import LOGO_AZORA from "@salesforce/resourceUrl/AzoraLogo";
import LOGO_BOQ from "@salesforce/resourceUrl/BOQLogo";
import LOGO_CAPITAL_FINANCE from "@salesforce/resourceUrl/CapitalFinanceLogo";
import LOGO_CARSTART from "@salesforce/resourceUrl/CarStartFinanceLogo";
import LOGO_COMMERCIAL_EQUITY_GROUP from "@salesforce/resourceUrl/CommercialEquityGroupLogo";
import LOGO_FINANCE_ONE from "@salesforce/resourceUrl/FinanceOneLogo";
import LOGO_FIRSTMAC from "@salesforce/resourceUrl/FirstmacLogo";
import LOGO_FLEET_PARTNERS from "@salesforce/resourceUrl/FleetPartnersLogo";
import LOGO_GREEN_LIGHT from "@salesforce/resourceUrl/GreenLightLogo";
import LOGO_GROUP_GENERAL from "@salesforce/resourceUrl/GroupAndGeneralLogo";
import LOGO_GROW from "@salesforce/resourceUrl/GrowLogo";
import LOGO_LATITUDE from "@salesforce/resourceUrl/LatitudeLogo3";
import LOGO_LIBERTY from "@salesforce/resourceUrl/LibertyLogo";
import LOGO_MACQUARIE from "@salesforce/resourceUrl/MacquarieLogo";
import LOGO_METRO from "@salesforce/resourceUrl/MetroLogo";
import LOGO_MONEY_PLACE from "@salesforce/resourceUrl/MoneyPlaceLogo";
import LOGO_MONEY3 from "@salesforce/resourceUrl/Money3Logo";
import LOGO_MORRIS from "@salesforce/resourceUrl/MorrisLogo";
import LOGO_NOW_FINANCE from "@salesforce/resourceUrl/NowFinanceLogo";
import LOGO_PEPPER from "@salesforce/resourceUrl/PepperLogo";
import LOGO_PLENTI from "@salesforce/resourceUrl/PlentiLogo";
import LOGO_SELFCO from "@salesforce/resourceUrl/SelfcoLogo";
import LOGO_SHIFT from "@salesforce/resourceUrl/ShiftLogo";
import LOGO_SILVER_CHEF from "@salesforce/resourceUrl/SilverChefLogo";
import LOGO_SOCIETY_ONE from "@salesforce/resourceUrl/SocietyOneLogo";
import LOGO_UME_LOANS from "@salesforce/resourceUrl/UMELoansLogo";
import LOGO_WESTPAC from "@salesforce/resourceUrl/WestpacLogo";
import LOGO_WISR from "@salesforce/resourceUrl/WisrLogo";

const INTEGER_PARAMS = ["term", "assetAge", "jobsLast3Years", "creditScore"];
const DECIMAL_PARAMS = ["price", "deposit", "residual"];

const convertNumbers = (params) => {
  let p = JSON.parse(JSON.stringify(params));
  for (const a of INTEGER_PARAMS) {
    p[a] = parseInt(p[a]);
  }
  for (const a of DECIMAL_PARAMS) {
    p[a] = parseFloat(p[a]);
  }
  return p;
};

const lenderLogo = (lender) => {
  if (lender === "Affordable") {
    return LOGO_AFFORDABLE;
  } else if (lender === "AFS") {
    return LOGO_AFS;
  } else if (lender === "AMMF") {
    return LOGO_AMMF;
  } else if (lender === "Angle Finance") {
    return LOGO_ANGLE;
  } else if (lender === "ANZ") {
    return LOGO_ANZ;
  } else if (lender === "APF") {
    return LOGO_APF;
  } else if (lender === "Azora") {
    return LOGO_AZORA;
  } else if (lender === "BOQ") {
    return LOGO_BOQ;
  } else if (lender === "Capital Finance") {
    return LOGO_CAPITAL_FINANCE;
  } else if (lender === "CarStart") {
    return LOGO_CARSTART;
  } else if (lender === "Commercial Equity Group") {
    return LOGO_COMMERCIAL_EQUITY_GROUP;
  } else if (lender === "Finance One") {
    return LOGO_FINANCE_ONE;
  } else if (lender === "Firstmac") {
    return LOGO_FIRSTMAC;
  } else if (lender === "Fleet Partners") {
    return LOGO_FLEET_PARTNERS;
  } else if (lender === "Green Light") {
    return LOGO_GREEN_LIGHT;
  } else if (lender === "Group And General") {
    return LOGO_GROUP_GENERAL;
  } else if (lender === "Grow Finance") {
    return LOGO_GROW;
  } else if (lender === "Latitude") {
    return LOGO_LATITUDE;
  } else if (lender === "Liberty") {
    return LOGO_LIBERTY;
  } else if (lender === "Macquarie") {
    return LOGO_MACQUARIE;
  } else if (lender === "Metro") {
    return LOGO_METRO;
  } else if (lender === "Money3") {
    return LOGO_MONEY3;
  } else if (lender === "Money Place") {
    return LOGO_MONEY_PLACE;
  } else if (lender === "Morris") {
    return LOGO_MORRIS;
  } else if (lender === "Now Finance") {
    return LOGO_NOW_FINANCE;
  } else if (lender === "Pepper") {
    return LOGO_PEPPER;
  } else if (lender === "Plenti") {
    return LOGO_PLENTI;
  } else if (lender === "Selfco") {
    return LOGO_SELFCO;
  } else if (lender === "Shift") {
    return LOGO_SHIFT;
  } else if (lender === "Silver Chef") {
    return LOGO_SILVER_CHEF;
  } else if (lender === "Society One") {
    return LOGO_SOCIETY_ONE;
  } else if (lender === "Society One") {
    return LOGO_UME_LOANS;
  } else if (lender === "UME Loans") {
    return LOGO_UME_LOANS;
  } else if (lender === "Westpac") {
    return LOGO_WESTPAC;
  } else if (lender === "Wisr") {
    return LOGO_WISR;
  }
  return undefined;
};

export { convertNumbers, lenderLogo };