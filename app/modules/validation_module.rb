# Module which contain all the Parameter Validation logic
module ValidationModule
  include MortgageModule

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

end
