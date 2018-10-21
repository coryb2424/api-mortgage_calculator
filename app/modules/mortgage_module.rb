module MortgageModule
  # Validates the params, return comprehensive errors
  def validate_params(params)
    errors = ''

    # Validate Asking Price and Down Payment
    errors += validate_ap_and_dp(params['asking_price'], params['down_payment'])

    # Validate Payment Schedule
    errors += validate_payment_schedule(params['payment_schedule'])

    # Validate Amortization Period
    errors += validate_amortization_period(params['amortization_period'])

    errors = "Validation failed: #{errors}" if errors.present?
    errors.strip.gsub('  ', ', ')
  end

  def validate_ap_and_dp(asking_price, down_payment)
    errors = ''
    if asking_price.nil?
      errors += ' missing params asking_price '
    elsif down_payment.nil?
      errors += ' missing params down_payment '
    else
      minimum_dp = minimum_down_payment(asking_price.to_f)
      unless down_payment.to_f.zero? || down_payment.to_f >= minimum_dp
        errors += " down payment needs to be at least #{minimum_dp} "
      end
    end
    errors
  end

  def validate_payment_schedule(payment_schedule)
    errors = ''
    schedule = %w[weekly biweekly monthly]
    if payment_schedule.nil?
      errors += ' missing params payment_schedule '
    else
      unless schedule.include? payment_schedule
        errors += " payment schedule can only be: #{schedule.join(', ')} "
      end
    end
    errors
  end

  def validate_amortization_period(amortization_period)
    errors = ''
    if amortization_period.nil?
      errors += ' missing params payment_schedule '
    else
      unless amortization_period.to_f > 5 && amortization_period.to_f <= 25
        errors += " amortization period needs to be betwenn 5 and 25 years, inclusive "
      end
    end
    errors
  end

  def minimum_down_payment(asking_price)
    minimum_dp = 0.05 * 500_000
    minimum_dp +=  0.1 * (asking_price - 500_000) unless asking_price < 500_000
    minimum_dp
  end
end
