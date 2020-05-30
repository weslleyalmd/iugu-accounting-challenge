require 'rails_helper'
RSpec.describe "/transfers", type: :request do
  let!(:transfers) { create_list(:transfer, 10) }
  let(:transfer_id) { transfers.first.id }
  let(:source_account) { create(:account) }

  # Test suite for GET /transfers
  describe 'GET /transfers' do
    # make HTTP get request before each example
    before { get '/transfers' }

    it 'returns transfers' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code :ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  # Test suite for GET /transfers/:id
  describe 'GET /transfers/:id' do
    before { get "/transfers/#{transfer_id}" }

    context 'when the record exists' do
      it 'returns the transfer' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(transfer_id)
      end

      it 'returns status code :ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the record does not exist' do
      let(:transfer_id) { 100 }

      it 'returns status code :not_found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Transfer/)
      end
    end
  end

  # Test suite for POST /transfers
  describe 'POST /transfers' do
    # valid payload
    let(:valid_attributes) { { transfer: { account_id: source_account.id, destination_account_id: 2, amount: 10000 } } }

    context 'when the request is valid' do
      before { post '/transfers', params: valid_attributes }

      it 'creates a transfer' do
        expect(json['account']['id']).to eq(source_account.id)
        expect(json['destination_account_id']).to eq(2)
        expect(json['amount']).to eq(10000)
      end

      it 'returns status code :created' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid - amount blank' do
      before { post '/transfers', params: { transfer: { account_id: source_account.id, destination_account_id: 2 } } }

      it 'returns status code :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("{\"amount\":[\"can't be blank\"]}")
      end
    end

    context 'when the request is invalid - source_account_id blank' do
      before { post '/transfers', params: { transfer: { destination_account_id: 2, amount: 10000 } } }

      it 'returns status code :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("{\"account\":[\"must exist\"]}")
      end
    end

    context 'when the request is invalid - destination_account_id blank' do
      before { post '/transfers', params: { transfer: { account_id: source_account.id, amount: 10000 } } }

      it 'returns status code :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("{\"destination_account_id\":[\"can't be blank\"]}")
      end
    end
  end

  # Test suite for DELETE /transfers/:id
  describe 'DELETE /transfers/:id' do
    before { delete "/transfers/#{transfer_id}" }

    it 'returns status code :no_content' do
      expect(response).to have_http_status(:no_content)
    end
  end
end
