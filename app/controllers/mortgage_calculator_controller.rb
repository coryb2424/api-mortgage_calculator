class MortgageCalculatorController < ApplicationController
  include MortgageModule
  include InsuranceModule

  INTEREST_RATE = 2.5

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
    payment_amount = calculate_payment_amount(params, insurance_cost, INTEREST_RATE)
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

    max_mortgage_amount = calculate_max_mortgage(params, INTEREST_RATE)

    json_response(amount: max_mortgage_amount)
  end
end
