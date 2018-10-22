class MortgageCalculatorController < ApplicationController
  include MortgageModule
  include InsuranceModule

  @@interest_rate = 2.5

  def payment_amount
    errors = validate_params(params)
    return json_response(errors, :unprocessable_entity) if errors.present?

    params['asking_price'] = params['asking_price'].to_f
    params['down_payment'] = params['down_payment'].to_f
    params['amortization_period'] = params['amortization_period'].to_f

    insurance_cost = calculate_insurance_amount(params)
    payment_amount = calculate_payment_amount(params, insurance_cost, @@interest_rate)
    json_response(amount: payment_amount)
  end

  def mortgage_amount
    errors = validate_params(params)
    return json_response(errors, :unprocessable_entity) if errors.present?

    params['payment_amount'] = params['payment_amount'].to_f
    params['amortization_period'] = params['amortization_period'].to_f
    params['down_payment'] = params['down_payment'].to_f if params['down_payment'].present?

    max_mortgage_amount = calculate_max_mortgage(params, @@interest_rate)

    json_response(amount: max_mortgage_amount)
  end

  def interest_rate
    errors = validate_params(params)
    return json_response(errors, :unprocessable_entity) if errors.present?

    params['interest_rate'] = params['interest_rate'].to_f

    old_rate = @@interest_rate
    @@interest_rate = params['interest_rate']
    json_response(old_rate: old_rate, new_rate: @@interest_rate)
  end
end
