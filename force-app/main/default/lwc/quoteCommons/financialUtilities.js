const FINANCIAL_PRECISION = 0.0000000001; //0.000001 original
const FINANCIAL_PRECISION2 = 0.0000000001; //0.000001 original
const FINANCIAL_MAX_ITERATIONS = 256; //128 original value   256

/**
 * Returns the value of Future Value
 * @param {number} rate - Client rate
 * @param {number} term - Number of months for repayments
 * @param {number} pv -
 * @returns {number} - Future Value
 */
const fv = (rate, term, pv) => {
  return pv * Math.pow(1 + rate, term);
};

/**
 *
 * @param {number} amount - car price
 * @param {number} term - Number of months for repayments
 * @param {number} payment
 * @param {number} residual
 * @param {number} interest
 * @param {boolean} type
 * @returns {number} - Returns rate
 */
const rate = (amount, term, payment, residual, interest, type) => {
  const error = 0.000001;
  let rate = interest;
  let bigRate = Math.pow(1 + rate, term);
  let temp =
    amount * bigRate - (payment * (bigRate - 1) * (type ? 1 + rate : 1)) / rate;
  while (temp < residual) {
    rate = rate + error;
    bigRate = Math.pow(1 + rate, term);
    temp =
      amount * bigRate -
      (payment * (bigRate - 1) * (type ? 1 + rate : 1)) / rate;
  }
  return rate;
};

/**
 *
 * @param {number} amount
 * @param {number} rate
 * @param {number} term
 * @param {number} residual
 * @param {boolean} type
 * @returns {number}
 */
const pmt = (amount, rate, term, residual, type) => {
  if (residual) residual = 0;
  const r = math.pow(1 + rate, term);
  return ((amount * r - residual) * rate) / ((r - 1) * (type ? 1 + rate : 1));
};

/**
 *
 * @param {number} income
 * @returns Resturns tax
 */
const taxCalculate = (income) => {
  let tax = 0.0;
  if (income <= 18200) {
    tax = 0.0;
  } else if (income <= 37000) {
    tax = (income - 18200) * 0.19;
  } else if (income <= 80000) {
    tax = 3572 + (income - 37000) * 0.325;
  } else if (income <= 180000) {
    tax = 17547 + (income - 80000) * 0.37;
  } else {
    tax = 54547 + (income - 180000) * 0.45;
  }
  return tax;
};

/**
 *
 * @param {number} npr
 * @param {number} pmt
 * @param {number} pv
 * @param {number} fv
 * @param {number} type - Advance=1, Arrears=0
 * @returns {number} Returns Client rate
 */
const rate2 = (npr, pmt, pv, fv, type) => {
  let rate = 0.1;
  let y;
  let f = 0.0;
  if (Math.abs(rate) < FINANCIAL_PRECISION) {
    y = pv * (1 + npr * rate) + pmt * (1 + rate * type) * npr + fv;
  } else {
    f = Math.exp(npr * Math.log(1 + rate));
    y = pv * f + pmt * (1 / rate + type) * (f - 1) + fv;
  }

  let y0 = pv + pmt * npr + fv;
  let y1 = pv * f + pmt * (1 / rate + type) * (f - 1) + fv;
  // find root by secant method
  let i = 0;
  let x0 = 0.0;
  let x1 = rate;
  while (
    Math.abs(y0 - y1) > FINANCIAL_PRECISION &&
    i < FINANCIAL_MAX_ITERATIONS
  ) {
    rate = (y1 * x0 - y0 * x1) / (y1 - y0);

    x0 = x1;
    x1 = rate;

    if (Math.abs(rate) < FINANCIAL_PRECISION) {
      y = pv * (1 + npr * rate) + pmt * (1 + rate * type) * npr + fv;
    } else {
      f = Math.exp(npr * Math.log(1 + rate));

      y = pv * f + pmt * (1 / rate + type) * (f - 1) + fv;
    }

    y0 = y1;
    y1 = y;
    i++;
  }
  return rate;
};

/**
 *
 * @param {number} r - base rate
 * @param {number} nper
 * @param {number} pv
 * @param {number} fv
 * @param {number} type
 * @returns Returns
 */
const pmt2 = (r, nper, pv, fv, type) => {
  return (
    (-r * (pv * Math.pow(1 + r, nper) + fv)) /
    ((1 + r * type) * (Math.pow(1 + r, nper) - 1))
  );
};

const FinancialUtilities = {
  fv: fv,
  rate: rate,
  pmt: pmt,
  taxCalculate: taxCalculate,
  rate2: rate2,
  pmt2: pmt2
};

export { FinancialUtilities };