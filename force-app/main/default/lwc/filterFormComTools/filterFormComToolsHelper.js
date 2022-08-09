const assetAgeValues = () => {
  let v = [];
  v.push({ label: "New", value: "0" });
  for (let i = 1; i <= 20; i++) {
    v.push({ label: `${i}`, value: `${i}` });
  }
  return v;
}

const jobsAmount = () => {
  let v = [];
  for (let i = 1; i <= 10; i++) {
    v.push({ label: `${i}`, value: `${i}` });
  }
  return v;
}

const getCreditScoreValue = (score) => {
  let v = undefined;
  if (score > 0) {
    if (score >= 853) {
      v = "853 - 1200";
    } else if (score >= 735) {
      v = "735 - 852";
    } else if (score >= 661) {
      v = "661 - 734";
    } else if (score >= 500) {
      v = "500 - 660";
    } else {
      v = "0 - 499";
    }
  }  
  return v;
};

export const ComparisonOptions = {
  assetTypes: [
    { label: "Car", value: "Car" },
    { label: "Motorbike", value: "Motorbike" },
    { label: "Boat", value: "Boat" },
    { label: "Caravan", value: "Caravan" },
    { label: "Truck", value: "Truck" },
    { label: "Personal", value: "Personal" }
  ],

  loanTypes: [
    { label: "Personal", value: "Personal" },
    { label: "Business", value: "Business" }
  ],

  employmentTypes: [
    { label: "Full-Time", value: "Full-Time" },
    { label: "Permanent Part-Time", value: "Permanent Part-Time" },
    { label: "Casual > 12 months", value: "Casual > 12 months" },
    { label: "Casual < 12 months", value: "Casual < 12 months" },
    { label: "Casual < 6 months", value: "Casual < 6 months" }
  ],

  purchaseTypes: [
    { label: "Dealer", value: "Dealer" },
    { label: "Private", value: "Private" },
    { label: "Refinance", value: "Refinance" }
  ],

  creditHistories: [
    { label: "Good", value: "Good" },
    {
      label: "Credit Issues (defaults/bankruptcy)",
      value: "Credit Issues"
    }
  ],

  loanTerms: [
    { label: "6", value: "6" },
    { label: "12", value: "12" },
    { label: "24", value: "24" },
    { label: "36", value: "36" },
    { label: "48", value: "48" },
    { label: "60", value: "60" },
    { label: "72", value: "72" },
    { label: "84", value: "84" }
  ],

  residentialStatus: [
    { label: "Property Owner", value: "Property Owner" },
    { label: "Renting", value: "Renting" },
    { label: "Boarding", value: "Boarding" }
  ],

  creditScores: [
    { label: "853 - 1200 (Excellent)", value: "853 - 1200" },
    { label: "735 - 852 (Very Good)", value: "735 - 852" },
    { label: "661 - 734 (Good)", value: "661 - 734" },
    { label: "500 - 660 (Average)", value: "500 - 660" },
    { label: "0 - 499", value: "0 - 499" }
  ],

  savings: [
    { label: "<50k", value: "<50k" },
    { label: "50k-100K", value: "50k-100K" },
    { label: "100K+", value: "100K+" }
  ],

  ltvs: [
    { label: "<90", value: "<90" },
    { label: "90-99", value: "90-99" },
    { label: "100–109", value: "100–109" },
    { label: "120–129", value: "120–129" },
    { label: "130", value: "130" },
    { label: "131+", value: "131+" }
  ],

  yesNo: [
    { label: "Yes", value: "Yes" },
    { label: "No", value: "No" }
  ],

  businessAssetTypes: [
    { label: "Cars & Utes - P", value: "Cars" },
    { label: "Buses - P", value: "Buses" },
    { label: "Caravans - P", value: "Caravans" },
    { label: "Trucks & Trailers - P", value: "Trucks" },
    { label: "Vans - P", value: "Vans" },
    { label: "Yellow Goods - P", value: "Yellow Goods" },
    {
      label: "Industrial/Manufacturing Plant & Equipment - S",
      value: "Equipment"
    },
    { label: "Medical - S", value: "Medical" },
    { label: "Printing - S", value: "Printing" },
    { label: "Gym Equipment - T", value: "Gym Equipment" },
    { label: "Information IT - T", value: "Information IT" },
    { label: "Office Furniture & Equipment - T", value: "Office Furniture" },
    { label: "Software - T", value: "Software" },
    { label: "Solar - T", value: "Solar" },
    { label: "Telephony - T", value: "Telephony" }
  ],

  businessEmploymentTypes: [{ label: "Self-Employed", value: "Self-Employed" }],

  abnLengths: [
    { label: "0 - 1", value: "0" },
    { label: "1 - 2", value: "1" },
    { label: "2 - 3", value: "2" },
    { label: "3+", value: "3" }
  ],

  gstRegisteredOptions: [
    { label: "Yes", value: "Y" },
    { label: "No", value: "N" }
  ],

  assetAge: assetAgeValues(),

  jobs: jobsAmount(),

  getCreditScoreValue: getCreditScoreValue
  
};