module MortgageModule
  SCHEDULE_MAP = {
    'monthly'=> 12,
    'biweekly'=> 26,
    'weekly'=> 52
  }

  def validate(params)
    errors = []
    params.each do |param, value|
      errors << "missing params #{param}" if value.blank?
    end
    yield(errors) if block_given? && errors.blank?
    errors
  end

  # Validate Asking Price and Down Payment Params
  def validate_ap_and_dp(asking_price, down_payment)
    validate(asking_price: asking_price, down_payment: down_payment) do |errors|
      minimum_dp = minimum_down_payment(asking_price.to_f)
      unless down_payment.to_f.zero? || down_payment.to_f >= minimum_dp
        errors << "down payment needs to be at least #{minimum_dp}"
      end
    end
  end

  # Validate Payment Schedule Param
  def validate_payment_schedule(payment_schedule)
    validate(payment_schedule: payment_schedule) do |errors|
      schedule = %w[weekly biweekly monthly]
      unless schedule.include? payment_schedule
        errors << "payment schedule can only be: #{schedule.join(', ')}"
      end
    end
  end

  # Validate Amortization Period Param
  def validate_amortization_period(amortization_period)
    validate(amortization_period: amortization_period) do |errors|
      unless amortization_period.to_f > 5 && amortization_period.to_f <= 25
        errors << "amortization period needs to be betwenn 5 and 25 years inclusive"
      end
    end
  end

  # Validate Payment Amount Param
  def validate_payment_amount(payment_amount)
    validate(payment_amount: payment_amount)
  end

  # Validate Interest Rate Param
  def validate_interest_rate(interest_rate)
    validate(interest_rate: interest_rate)
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
