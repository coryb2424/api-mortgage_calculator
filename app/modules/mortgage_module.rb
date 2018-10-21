module MortgageModule
  SCHEDULE_MAP = {
    'monthly'=> 12,
    'biweekly'=> 26,
    'weekly'=> 52
  }

  # Validate Asking Price and Down Payment Params
  def validate_ap_and_dp(asking_price, down_payment)
    errors = []
    if asking_price.blank?
      errors << 'missing params asking_price'
    elsif down_payment.blank?
      errors << 'missing params down_payment'
    else
      minimum_dp = minimum_down_payment(asking_price.to_f)
      unless down_payment.to_f.zero? || down_payment.to_f >= minimum_dp
        errors << "down payment needs to be at least #{minimum_dp}"
      end
    end
    errors
  end

  # Validate Payment Schedule Param
  def validate_payment_schedule(payment_schedule)
    errors = []
    schedule = %w[weekly biweekly monthly]
    if payment_schedule.blank?
      errors << 'missing params payment_schedule'
    else
      unless schedule.include? payment_schedule
        errors << "payment schedule can only be: #{schedule.join(', ')}"
      end
    end
    errors
  end

  # Validate Amortization Period Param
  def validate_amortization_period(amortization_period)
    errors = []
    if amortization_period.blank?
      errors << 'missing params payment_schedule'
    else
      unless amortization_period.to_f > 5 && amortization_period.to_f <= 25
        errors << "amortization period needs to be betwenn 5 and 25 years inclusive"
      end
    end
    errors
  end

  # Validate Payment Amount Param
  def validate_payment_amount(payment_amount)
    errors = []
    errors << 'missing params payment_amount' if payment_amount.blank?
    errors
  end

  # Validate Interest Rate Param
  def validate_interest_rate(interest_rate)
    errors = []
    errors << 'missing params interest_rate' if interest_rate.blank?
    errors
  end

  def minimum_down_payment(asking_price)
    minimum_dp = 0.05 * 500_000
    minimum_dp +=  0.1 * (asking_price - 500_000) unless asking_price < 500_000
    minimum_dp
  end

  def calculate_payment_amount(params, insurance_cost, interest_rate)
    mortgage_principle = params['asking_price'] - params['down_payment'] + insurance_cost
    number_of_payments = SCHEDULE_MAP[params['payment_schedule']] * params['amortization_period']
    nominal_interest_rate = (interest_rate / SCHEDULE_MAP[params['payment_schedule']]) / 100

    numerator = (mortgage_principle * nominal_interest_rate * (1 + nominal_interest_rate) ** number_of_payments)
    denominator = (1 + nominal_interest_rate) ** number_of_payments - 1

    (numerator / denominator).round(2)
  end

  def calculate_max_mortgage(params, interest_rate)
    number_of_payments = SCHEDULE_MAP[params['payment_schedule']] * params['amortization_period']
    nominal_interest_rate = (interest_rate / SCHEDULE_MAP[params['payment_schedule']]) / 100

    numerator = params['payment_amount'] * ((1 + nominal_interest_rate) ** number_of_payments - 1)
    denominator = nominal_interest_rate * (1 + nominal_interest_rate) ** number_of_payments

    max_mortgage = (numerator / denominator).round(2)
    max_mortgage += params['down_payment'] if params['down_payment'].present?
    max_mortgage
  end
end
