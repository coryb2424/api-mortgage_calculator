class MortgageCalculatorController < ApplicationController
  include MortgageModule
  include InsuranceModule

  @@interest_rate = 2.5

  def payment_amount
    errors = []
    errors << validate_ap_and_dp(params['asking_price'], params['down_payment'])
    errors << validate_payment_schedule(params['payment_schedule'])
    errors << validate_amortization_period(params['amortization_period'])
    errors = errors.flatten
    return json_response("Validation failed: #{errors.join(', ')}", :unprocessable_entity) if errors.present?

    params['asking_price'] = params['asking_price'].to_f
    params['down_payment'] = params['down_payment'].to_f
    params['amortization_period'] = params['amortization_period'].to_f

    insurance_cost = calculate_insurance_amount(params)
    payment_amount = calculate_payment_amount(params, insurance_cost, @@interest_rate)
    json_response(amount: payment_amount)
  end

  def mortgage_amount
    errors = []
    errors << validate_payment_schedule(params['payment_schedule'])
    errors << validate_amortization_period(params['amortization_period'])
    errors << validate_payment_amount(params['payment_amount'])
    errors = errors.flatten
    return json_response("Validation failed: #{errors.join(', ')}", :unprocessable_entity) if errors.present?

    params['payment_amount'] = params['payment_amount'].to_f
    params['amortization_period'] = params['amortization_period'].to_f
    params['down_payment'] = params['down_payment'].to_f if params['down_payment'].present?

    max_mortgage_amount = calculate_max_mortgage(params, @@interest_rate)

    json_response(amount: max_mortgage_amount)
  end

  def interest_rate
    errors = []
    errors << validate_interest_rate(params['interest_rate'])
    errors = errors.flatten
    return json_response("Validation failed: #{errors.join(', ')}", :unprocessable_entity) if errors.present?

    params['interest_rate'] = params['interest_rate'].to_f

    old_rate = @@interest_rate
    @@interest_rate = params['interest_rate']
    json_response(old_rate: old_rate, new_rate: @@interest_rate)
  end
end
