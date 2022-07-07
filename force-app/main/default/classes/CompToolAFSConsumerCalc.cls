public class CompToolAFSConsumerCalc extends CompToolLenderCalcAbstract {

  public CompToolAFSConsumerCalc(Calculator__c calc, FilterParams param) {
    SUPER(calc, param);
  }

  public override CompToolLenderResult calculate() {

    // ---------------
    // Find base rates
    this.quoteParam.ltv = '100';
    this.quoteParam.productLoanType = 'Consumer Loan';

    // - Prepare parameters
    this.quoteParam.assetType = param.assetType;
    if ('Property Owner'.equals(param.residentialStatus)) {
      this.quoteParam.residency = 'Property Owner';
    } else if (
      'Renting Real Estate'.equals(param.residentialStatus) ||
      'Renting Other'.equals(param.residentialStatus)
    ) {
      this.quoteParam.residency = 'Renting';
    } else if ('Boarding'.equals(param.residentialStatus)) {
      this.quoteParam.residency = 'Boarding/Other';
    }

    this.quoteParam.condition = param.assetAge > 0? 'Used' : 'New/Demo';
    if (param.assetAge <= 3) {
      this.quoteParam.vehicleYear = '0-3 years';
    } else if (param.assetAge <= 7) {
      this.quoteParam.vehicleYear = '4-7 years';
    } else if (param.assetAge <= 10) {
      this.quoteParam.vehicleYear = '8-10 years';
    } else if (param.assetAge <= 20) {
      this.quoteParam.vehicleYear = '11-20 years';
    } else if (param.assetAge <= 30) {
      this.quoteParam.vehicleYear = '21-30 years';
    } else {
      this.quoteParam.vehicleYear = '30+ years';
    }

    this.quoteParam.bankrupt = param.creditHistory.containsIgnoreCase('Defaults')
      ? 'Y' : 'N';
    // this.quoteParam.riskGrade = this.payDayEnquiries;
    // this.quoteParam.hasImports = this.hasImports;
    this.quoteParam.vehiclePrice = param.getNetVehiclePrice();
    // this.quoteParam.vehiclesProfile = this.odometer;
    this.quoteParam.term = param.term;
    this.quoteParam.privateSales = 'Private'.equals(param.purchaseType)? 'Y' : 'N';
    
    this.quoteParam.customerProfile = param.employmentType.containsIgnoreCase('casual')
      ? 'Y' : 'N';

    if ('Car'.equals(param.assetType)) {
      this.quoteParam.assetType = 'Car';
    } else if ('Motorbike'.equals(param.assetType)) {
      this.quoteParam.assetType = 'Bikes / Scooters';
    } else if ('Boat'.equals(param.assetType)) {
      this.quoteParam.assetType = 'Boats / Personal Watercraft';
    } else if ('Caravan'.equals(param.assetType)) {
      this.quoteParam.assetType = 'Caravans / Motorhomes';
    }

    // - get base rates
    this.baseRateCalc(null);

    this.quoteParam.commRate = QuotingCalculation.getAFSRateCommission(this.quoteParam);

    // Calculation    
    CompToolLenderResult r = this.calculateRepayments();
    r.details = this.quoteParam.loanTypeDetail;
    return r;
  }
  
}