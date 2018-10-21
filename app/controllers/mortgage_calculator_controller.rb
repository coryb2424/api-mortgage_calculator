class MortgageCalculatorController < ApplicationController
  include MortgageModule

  INTEREST_RATE = 2.5

  def payment_amount
    errors = validate_params(params)
    return json_response(errors, :unprocessable_entity) if errors.present?

    json_response('test')
  end

end
