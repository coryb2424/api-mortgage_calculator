class MortgageCalculatorController < ApplicationController
  include MortgageModule
  include InsuranceModule

  INTEREST_RATE = 2.5

  def payment_amount
    errors = validate_params(params)
    return json_response(errors, :unprocessable_entity) if errors.present?

    params['asking_price'] = params['asking_price'].to_f
    params['down_payment'] = params['down_payment'].to_f
    params['amortization_period'] = params['amortization_period'].to_f

    insurance_cost = calculate_insurance_amount(params)
    payment_amount = calculate_payment_amount(params, insurance_cost, INTEREST_RATE)
    json_response(amount: payment_amount)
  end

end
