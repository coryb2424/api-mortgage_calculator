Rails.application.routes.draw do
  get "/payment-amount", to: 'mortgage_calculator#payment_amount'
end
