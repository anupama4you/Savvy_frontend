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
    { label: "Casual < 6 months", value: "Casual < 6 months" },
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

  assetAge: assetAgeValues(),

  jobs: jobsAmount()
};