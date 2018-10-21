Rails.application.routes.draw do
  get "/payment-amount", to: 'mortgage_calculator#payment_amount'
  get "/mortgage-amount", to: 'mortgage_calculator#mortgage_amount'
end
