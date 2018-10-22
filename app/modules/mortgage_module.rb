# Module which contain all the Mortgage logic
module MortgageModule
  SCHEDULE_MAP = {
    'monthly'   => 12,
    'biweekly'  => 26,
    'weekly'    => 52
  }

  # Calculates the minimum down payment for the given asking price
  def minimum_down_payment(asking_price)
    minimum_dp = 0.05 * 500_000
    minimum_dp +=  0.1 * (asking_price - 500_000) unless asking_price < 500_000
    minimum_dp
  end

  # Calculates the payment amount for the given schedule and parameters
  def calculate_payment_amount(params, insurance_cost, interest_rate)
    mortgage_principle = params['asking_price'] - params['down_payment'] + insurance_cost
    number_of_payments = SCHEDULE_MAP[params['payment_schedule']] * params['amortization_period']
    nominal_interest_rate = (interest_rate / SCHEDULE_MAP[params['payment_schedule']]) / 100

    numerator = (mortgage_principle * nominal_interest_rate * (1 + nominal_interest_rate)**number_of_payments)
    denominator = (1 + nominal_interest_rate)**number_of_payments - 1

    (numerator / denominator).round(2)
  end

  # Calculate the maximum mortgage possible from the given parameters
  def calculate_max_mortgage(params, interest_rate)
    number_of_payments = SCHEDULE_MAP[params['payment_schedule']] * params['amortization_period']
    nominal_interest_rate = (interest_rate / SCHEDULE_MAP[params['payment_schedule']]) / 100

    numerator = params['payment_amount'] * ((1 + nominal_interest_rate)**number_of_payments - 1)
    denominator = nominal_interest_rate * (1 + nominal_interest_rate)**number_of_payments

    max_mortgage = (numerator / denominator).round(2)
    max_mortgage += params['down_payment'] if params['down_payment'].present?
    max_mortgage
  end
end
