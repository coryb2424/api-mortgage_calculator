RSpec.describe 'Payment Amount', type: :request do
  before(:each) { MortgageCalculatorController.class_variable_set :@@interest_rate, 2.5 }

  context 'GET /payment-amount' do
    let(:valid_params) do
      {
        asking_price: '750000',
        down_payment: '50000',
        payment_schedule: 'biweekly',
        amortization_period: '10'
      }
    end

    let(:invalid_params_down_payment) do
      {
        asking_price: '750000',
        down_payment: '10000',
        payment_schedule: 'biweekly',
        amortization_period: '10'
      }
    end

    describe 'when the request is valid' do
      before { get '/payment-amount', params: valid_params }

      it 'returns correct amount' do
        expect(json['amount']).to eq(3140.03)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    describe 'when the request is invalid due to low down payment' do
      before { get '/payment-amount', params: invalid_params_down_payment }

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
