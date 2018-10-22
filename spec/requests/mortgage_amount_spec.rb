RSpec.describe 'Mortgage Amount', type: :request do
  before(:each) { MortgageCalculatorController.class_variable_set :@@interest_rate, 2.5 }

  context 'GET /mortgage-amount' do
    let(:valid_params) do
      {
        payment_amount: '1500',
        down_payment: '50000',
        payment_schedule: 'monthly',
        amortization_period: '10'
      }
    end

    let(:invalid_params_amort_period) do
      {
        payment_amount: '1500',
        down_payment: '50000',
        payment_schedule: 'monthly',
        amortization_period: '3'
      }
    end

    describe 'when the request is valid' do
      before { get '/mortgage-amount', params: valid_params }

      it 'returns correct amount' do
        expect(json['amount']).to eq(209117.59)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    describe 'when the request is invalid due to low down payment' do
      before { get '/mortgage-amount', params: invalid_params_amort_period }

      it 'returns validation error message' do
        expect(response.body)
          .to match(/Validation failed/)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
end
