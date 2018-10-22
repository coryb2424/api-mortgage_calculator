module MortgageModule
  SCHEDULE_MAP = {
    'monthly'=> 12,
    'biweekly'=> 26,
    'weekly'=> 52
  }

  # Run the given params through validations
  def validate_params(params)
    errors = []
    errors << if params.key?('asking_price') && params.key?('down_payment')
                validate(asking_price: params['asking_price'], down_payment: params['down_payment']) do |val_errors|
                  val_errors << validate_minimum_down_payment(params['asking_price'], params['down_payment'])
                end
              end

    errors << if params.key?('payment_schedule')
                validate(payment_schedule: params['payment_schedule']) do |val_errors|
                  val_errors << validate_payment_schedule_types(params['payment_schedule'])
                end
              end

    errors << if params.key?('amortization_period')
                validate(amortization_period: params['amortization_period']) do |val_errors|
                  val_errors << validate_amortization_period(params['amortization_period'])
                end
              end

    errors << if params.key?('payment_amount')
                validate(payment_amount: params['payment_amount'])
              end

    errors << if params.key?('interest_rate')
                validate(interest_rate: params['interest_rate'])
              end

    errors = errors.flatten.compact
    errors.blank? ? [] : "Validation failed: #{errors.join(', ')}"
  end

  # Validates params for blanks and calls custom validations if given
  def validate(params)
    val_errors = []
    params.each do |param, value|
      val_errors << "missing params #{param}" if value.blank?
    end
    yield(val_errors) if block_given? && val_errors.blank?
    val_errors.compact
  end

  # Validate Minimum Down Payment
  def validate_minimum_down_payment(asking_price, down_payment)
    minimum_dp = minimum_down_payment(asking_price.to_f)
    unless down_payment.to_f.zero? || down_payment.to_f >= minimum_dp
      "down payment needs to be at least #{minimum_dp}"
    end
  end

  # Validate Payment Schedule Types
  def validate_payment_schedule_types(payment_schedule)
    schedule = %w[weekly biweekly monthly]
    unless schedule.include? payment_schedule
      "payment schedule can only be: #{schedule.join(', ')}"
    end
  end

  # Validate Amortization period
  def validate_amortization_period(amortization_period)
    unless amortization_period.to_f > 5 && amortization_period.to_f <= 25
      "amortization period needs to be betwenn 5 and 25 years inclusive"
    end
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

    numerator = (mortgage_principle * nominal_interest_rate * (1 + nominal_interest_rate)**number_of_payments)
    denominator = (1 + nominal_interest_rate)**number_of_payments - 1

    (numerator / denominator).round(2)
  end

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
