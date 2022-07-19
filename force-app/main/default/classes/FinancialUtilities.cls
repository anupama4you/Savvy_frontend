public class FinancialUtilities {
    
    private static Decimal FINANCIAL_PRECISION = 0.0000000001;      //0.000001 original
    private static Double FINANCIAL_PRECISION2 = 0.0000000001;      //0.000001 original
    private static Integer FINANCIAL_MAX_ITERATIONS = 256;      //128 original value   256
    
    public static Decimal fv (Decimal rate, Integer term, Decimal pv) {
        decimal bigRate = Math.pow((double)(1+rate), (double)term);
        Decimal fv = pv * bigRate;
        return fv;
    }
    
    public static decimal rate (decimal amount, decimal term, decimal payment, decimal residual, decimal interest, boolean type) {
        decimal error = 0.000001;
        decimal rate = interest;
        decimal bigRate = Math.pow((double)(1+rate), (double)term);
        if (rate > 0.00) {
          if (type == true) {
              decimal temp = amount * bigRate - payment * (bigRate -1) * (1 + rate) / rate;
              
              while (temp < residual) {
                  rate = rate + error;
                  bigRate = Math.pow((double)(1+rate), (double)term);
                  temp = amount * bigRate - payment * (bigRate -1) * (1 + rate) / rate;
              }
          } else {
              decimal temp = amount * bigRate - payment * (bigRate -1) / rate;
              
              while (temp < residual) {
                  rate = rate + error;
                  bigRate = Math.pow((double)(1+rate), (double)term);
                  temp = amount * bigRate - payment * (bigRate -1) / rate;
              }
          }
        }
      return rate;
    }
    
    public static decimal pmt (decimal amount, decimal rate, decimal term, decimal residual, boolean type) {
      if (residual == null) {
          residual = 0;
      }
      if (rate > 0.00) {
        if (type == true) {
            decimal r = math.pow((double)(1+rate), (double)term);
            decimal pmt = ((amount*r-residual)*rate/((r-1)*(1+rate)));
            return pmt;
        } else {
            decimal r = math.pow((double)(1+rate), (double)term);
            decimal pmt = ((amount*r-residual)*rate/(r-1));
            return pmt;
        }
      }
      return 0.00;
    }
    
    public static decimal taxCalculate (decimal income) {
        decimal tax = 0.0;
        if (income <= 18200) {
            tax = 0.0;
        } else if (income <= 37000) {
            tax = (income - 18200) * 0.19;
        } else if (income <= 80000) {
            tax = 3572 + ((income - 37000) * 0.325);
        } else if (income <= 180000) {
            tax = 17547 + ((income - 80000) * 0.37);
        } else {
            tax = 54547 + ((income - 180000) * 0.45);
        }
        return tax;
    }
	
    /**
     * Rate2 description
     * @param  npr  Term
     * @param  pmt  Rental
     * @param  pv   Finance Amount
     * @param  fv   Residual
     * @param  type Advance=1, Arrears=0
     * @return      Client rate
     */
    public static decimal rate2(Integer npr, decimal pmt, decimal pv, decimal fv, integer type){
		decimal rate = 0.1;
		decimal y;
		Double f = 0.0;
		if (Math.abs(rate) < FINANCIAL_PRECISION) {
	        y = pv * (1 + npr * rate) + pmt * (1 + rate  * type) * npr + fv;
	    } else {
	        f = Math.exp(npr * Math.log(1 + rate));
	        y = pv * f + pmt * (1 / rate + type) * (f - 1) + fv;
	    }
		
		decimal y0 = pv + pmt * npr + fv;
	    decimal y1 = pv * f + pmt * (1 / rate + type) * (f - 1) + fv;

	    // find root by secant method
		integer i = 0;
	    decimal x0 = 0.0;
	    decimal x1 = rate;
        //System.debug(i + ') Math.abs(y0 - y1) = (' + y0 + ' - ' + y1 + ') = ' + Math.abs(y0 - y1));
		while ((Math.abs(y0 - y1) > FINANCIAL_PRECISION) && (i < FINANCIAL_MAX_ITERATIONS)) {
            //System.debug(i + ') Math.abs(y0 - y1) = (' + y0 + ' - ' + y1 + ') = ' + Math.abs(y0 - y1));
			rate = (y1 * x0 - y0 * x1) / (y1 - y0);
            //System.debug(i + ') ' + rate);
			x0 = x1;
			x1 = rate;

			if (Math.abs(rate) < FINANCIAL_PRECISION) {
	            y = pv * (1 + npr * rate) + pmt * (1 + rate  * type) * npr + fv;
			} else {
                //try {
					f = Math.exp(npr * Math.log(1 + rate));
                //} catch (MathException e) {
                //    System.debug('Error: ' + e.getMessage());
                //}
				y = pv * f + pmt * (1 / rate + type) * (f - 1) + fv;
			}

			y0 = y1;
			y1 = y;
			i++;
	    }
		return rate;
	}
    
    public static decimal pmt2(decimal r, integer nper, decimal pv, decimal fv, integer type) {
        Double amount  = Double.valueOf(String.valueOf(r));
	    decimal result = -r * (pv * Math.pow(1 + amount, nper) + fv) / ((1 + r*type) * (Math.pow(1 + amount, nper) - 1));
	    return result;
	}
    
}