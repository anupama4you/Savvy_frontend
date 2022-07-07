public class ServicingCalcHelper {
    
	public class Parameter {
		public Id appId {set;get;}
		public String lender {set;get;}
		public Decimal naf {set;get;}

		//Applicant 1
		public Decimal income1 {set;get;}
		public Decimal totalOtherIncome1 {set;get;}
		//Applicant 2
		public Decimal income2 {set;get;}
		public Decimal totalOtherIncome2 {set;get;}

		public String maritalStatus {set;get;}
		public Integer dependents {set;get;}
		public Boolean splitingExpenses {set;get;}
		public Decimal partnerIncome {set;get;}

		public Decimal totalRentMortgageBoard {set;get;}
		public Decimal totalLiabilities {set;get;}
		public Decimal totalCreditCards {set;get;}
		public Decimal repayment {set;get;}

		public Parameter() {
			this.naf = 0.0;
			this.income1 = 0.0;
			this.totalOtherIncome1 = 0.0;
			this.income2 = 0.0;
			this.totalOtherIncome2 = 0.0;
			this.partnerIncome = 0.0;
			this.maritalStatus = 'Single';
			this.splitingExpenses = false;
			this.totalRentMortgageBoard = 0.0;
			this.totalLiabilities = 0.0;
			this.totalCreditCards = 0.0;
			this.repayment = 0.0;
		}

		public Decimal getTotalIncome() {
			Decimal r = 0.0;
			//Applicant 1
			if (this.income1 != null) {
				r += this.income1;
			}
			if (this.totalOtherIncome1 != null) {
				r += this.totalOtherIncome1;
			}
			//Applicant 2
			if (this.income2 != null) {
				r += this.income2;
			}
			if (this.totalOtherIncome2 != null) {
				r += this.totalOtherIncome2;
			}
			return r;
		}

	}

	public class Result {
		public Decimal totalIncome {set;get;}
		public Decimal totalLiabilities {set;get;}
		public Decimal totalRentMortgageBoard {set;get;}
		public Decimal totalLivingExpenses {set;get;}
		public Decimal totalCreditCards {set;get;}
		public Decimal buffer {set;get;}
		public Decimal repayment {set;get;}

		public Result() {
			this.totalIncome = 0.0;
			this.totalLiabilities = 0.0;
			this.totalRentMortgageBoard = 0.0;
			this.totalLivingExpenses = 0.0;
			this.totalCreditCards = 0.0;
			this.buffer = 0.0;
			this.repayment = 0.0;
		}

		public Decimal getAmountAvailable() {
			Decimal r = this.totalIncome;
			r -= this.totalLiabilities;
			r -= this.totalRentMortgageBoard;
			r -= this.totalLivingExpenses;
			r -= this.totalCreditCards;
			r -= this.buffer;
			r -= this.repayment;
			return r;
		}
	}

	public static Result calculate(Parameter param) {
		Result r = null;
		if (param == null || String.isBlank(param.lender)) return r;
		r = new Result();
		/*
		Parameter tmpParam = ApplicationService.prepareServicingInfo(param.appId);
		System.debug(tmpParam);
		if (tmpParam != null) {
			param.maritalStatus = tmpParam.maritalStatus;
			param.dependents = tmpParam.dependents;

			param.income1 = tmpParam.income1;
			param.totalOtherIncome1 = tmpParam.totalOtherIncome1;
			param.income2 = tmpParam.income2;
			param.totalOtherIncome2 = tmpParam.totalOtherIncome2;

			param.totalRentMortgageBoard = tmpParam.totalRentMortgageBoard;
			param.totalLiabilities = tmpParam.totalLiabilities;
			param.totalCreditCards = tmpParam.totalCreditCards;

		}
		*/
		// Passing variables
		r.totalRentMortgageBoard = param.totalRentMortgageBoard;
		r.totalLiabilities = param.totalLiabilities;
		r.totalCreditCards = param.totalCreditCards;
		r.repayment = param.repayment;
		r.totalIncome = param.getTotalIncome();
		r.totalLivingExpenses = calculateLivingExpenses(param);
		r.buffer = calculateBuffer(param);

		//Spliting expenses
		if (param.splitingExpenses) {
			r.totalRentMortgageBoard = r.totalRentMortgageBoard / 2.0;
			Parameter p = new Parameter();
			p.lender = param.lender;
			p.maritalStatus = 'Single';
			p.dependents = param.dependents;
			p.naf = param.naf;
			Decimal sl = calculateLivingExpenses(p);
			if (sl > 0) {
				r.totalLivingExpenses = sl;
			}
		}

		if ('Finance One'.equals(param.lender)) {
			r.buffer = r.totalIncome * 0.05;
		} else if ('Green Light'.equals(param.lender)) {
			r.buffer = r.totalIncome * 0.03;
		} else if ('Macquarie Consumer'.equals(param.lender) ||
			       'Macquarie Commercial'.equals(param.lender)) {
			if ('Single'.equals(param.maritalStatus)) {
				r.buffer = 100;
			} else {
				r.buffer = 350;
			}
		}

		return r;
	}

	private static Decimal calculateLivingExpenses(Parameter param) {
		if (param == null) return 0.0;
		// Estimate living expenses
		ServicingCalculatorDTO s = new ServicingCalculatorDTO();
		s.lender = OppApplicationServCalculatorUtils.getLenderCode(param.lender);
		s.maritalStatus = param.maritalStatus;
		s.noDependents = param.dependents;
		s.naf = param.getTotalIncome() * 12;
		return OppApplicationServCalculatorUtils.getLivingExpensesLender(s);
	}

	private static Decimal calculateBuffer(Parameter param) {
		return 0.0;
	}
}