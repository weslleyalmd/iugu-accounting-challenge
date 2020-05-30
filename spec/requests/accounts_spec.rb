require 'rails_helper'

RSpec.describe "/accounts", type: :request do
  let!(:accounts) { create_list(:account, 10) }
  let(:account_id) { accounts.first.id }

  # Test suite for GET /accounts
  describe 'GET /accounts' do
    # make HTTP get request before each example
    before { get '/accounts' }

    it 'returns accounts' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code :ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  # Test suite for GET /accounts/:id
  describe 'GET /accounts/:id' do
    before { get "/accounts/#{account_id}" }

    context 'when the record exists' do
      it 'returns the account' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(account_id)
      end

      it 'returns status code :ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the record does not exist' do
      let(:account_id) { 100 }

      it 'returns status code :not_found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Account/)
      end
    end
  end

  # Test suite for POST /accounts
  describe 'POST /accounts' do
    # valid payload
    let(:valid_attributes) { { account: { name: 'Test 1', balance: 10000 } } }

    context 'when the request is valid' do
      before { post '/accounts', params: valid_attributes }

      it 'creates a account' do
        expect(json['access_token']).not_to be_empty
        expect(json['access_token'].size).to eq(20)
      end

      it 'returns status code :created' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid - balance blank' do
      before { post '/accounts', params: { account: { name: 'Foobar' } } }

      it 'returns status code :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("{\"balance\":[\"can't be blank\"]}")
      end
    end

    context 'when the request is invalid - name blank' do
      before { post '/accounts', params: { account: { balance: 100 } } }

      it 'returns status code :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("{\"name\":[\"can't be blank\"]}")
      end
    end
  end

  # Test suite for PUT /accounts/:id
  describe 'PUT /accounts/:id' do
    let(:valid_attributes) { { account: { balamce: 2000 } } }

    context 'when the record exists' do
      before { put "/accounts/#{account_id}", params: valid_attributes }

      it 'returns status code :ok' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # Test suite for DELETE /accounts/:id
  describe 'DELETE /accounts/:id' do
    before { delete "/accounts/#{account_id}" }

    it 'returns status code :no_content' do
      expect(response).to have_http_status(:no_content)
    end
  end
end