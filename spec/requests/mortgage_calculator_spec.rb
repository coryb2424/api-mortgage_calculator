require 'rails_helper'

RSpec.describe 'Mortgage Calculator', type: :request do
  context 'when the request is valid' do
    let(:valid_params) do
      {
        asking_price: '750000',
        down_payment: '50000',
        payment_schedule: 'biweekly',
        amortization_period: '10'
      }
    end

    describe 'GET /payment-amount' do
      before { get '/payment-amount', params: valid_params }

      it 'returns correct amount' do
        expect(json['amount']).to eq('3140.03')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  context 'when the request is invalid due to low down payment' do
    let(:invalid_params_down_payment) do
      {
        asking_price: '750000',
        down_payment: '10000',
        payment_schedule: 'biweekly',
        amortization_period: '10'
      }
    end

    describe 'GET /payment-amount' do
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
