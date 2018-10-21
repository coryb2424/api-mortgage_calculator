Rails.application.routes.draw do
  get '/payment-amount', to: 'mortgage_calculator#payment_amount'
  get '/mortgage-amount', to: 'mortgage_calculator#mortgage_amount'

  patch '/interest-rate', to: 'mortgage_calculator#interest_rate'
end
