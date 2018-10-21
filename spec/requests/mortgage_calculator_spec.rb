require 'rails_helper'

RSpec.describe 'Mortgage Calculator', type: :request do
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

  context 'PATCH /interest-rate' do
    let(:params) do
      {
        interest_rate: '3.5'
      }
    end

    let(:invalid_params) do
      {
        interest_rate: ''
      }
    end

    describe 'when the request is valid' do
      before { patch '/interest-rate', params: params }

      it 'returns old interest rate' do
        expect(json['old_rate']).to eq(2.5)
      end

      it 'returns new interest rate' do
        expect(json['new_rate']).to eq(3.5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    describe 'when the request is invalid due to missing params' do
      before { patch '/interest-rate', params: invalid_params }

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
