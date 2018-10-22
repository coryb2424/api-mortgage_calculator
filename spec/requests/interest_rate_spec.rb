require 'rails_helper'

RSpec.describe 'Interest Rate', type: :request do
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
