require 'rails_helper'
RSpec.describe "/transfers", type: :request do
  let(:source_account) { create(:account) }
  let(:destination_account) { create(:account) }
  let!(:transfers) { create_list(:transfer, 10, account: source_account, destination_account_id: destination_account.id) }
  let(:transfer_id) { transfers.first.id }

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
    let(:valid_attributes) { { transfer: { account_id: source_account.id, destination_account_id: destination_account.id, amount: 10000 } } }
    let(:valid_auth) { { authorization: "Token token=#{source_account.access_token}" } }
    let(:invalid_auth) { { authorization: "Token token=invalid_auth" } }

    context 'when the request is valid' do
      before { post '/transfers', params: valid_attributes, headers: valid_auth }

      it 'creates a transfer' do
        expect(json['source_account_id']).to eq(source_account.id)
        expect(json['destination_account_id']).to eq(destination_account.id)
        expect(json['amount']).to eq(10000)
      end

      it 'returns status code :created' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is valid but source account does not have enough balance' do
      before { post '/transfers', headers: valid_auth, 
        params: { transfer: { account_id: source_account.id, destination_account_id: destination_account.id, amount: 99999 } } }

      it 'returns status code :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/source acount doesn't have enough balance/)
      end
    end

    context 'check that the balance has been updated' do
      let(:s_account) {create(:account)}
      let(:d_account) {create(:account)}

      before { post '/transfers', headers: { authorization: "Token token=#{s_account.access_token}" },
        params: { transfer: {account_id: s_account.id, destination_account_id: d_account.id, amount: 100} }}

        it 'should withdraw transfer amount from source_account' do
          ### Get updated source account
          account = Account.find(s_account.id)

          ### Balance should be s_account.balance - 100
          expect(account.balance).to eq(s_account.balance - 100)
        end

        it 'should deposit transfer amount from destination_account' do
          ### Get updated destination account
          account = Account.find(d_account.id)

          ### Balance should be d_account.balance + 100
          expect(account.balance).to eq(d_account.balance + 100)
        end
    end

    context 'when the request is valid but source_account_id is equals to destination_account_id' do
      before { post '/transfers', headers: valid_auth, 
        params: { transfer: { account_id: source_account.id, destination_account_id: source_account.id, amount: 1000 } } }

      it 'returns status code :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/source account and destination account must be different/)
      end
    end

    context 'when the request is invalid - valid authorization but without source_account id' do
      before { post '/transfers', headers: valid_auth,
        params: { transfer: { destination_account_id: destination_account.id, amount: 10000 } } }

      it 'returns status code :unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Bad credentials/)
      end
    end

    context 'when the request is invalid - valid transfer invalid auth' do
      before { post '/transfers', headers: invalid_auth,
        params: valid_attributes }

      it 'returns status code :unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Bad credentials/)
      end
    end

    context 'when the request is invalid - amount blank' do
      before { post '/transfers', headers: valid_auth,
        params: { transfer: { account_id: source_account.id, destination_account_id: destination_account.id } } }

      it 'returns status code :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("{\"amount\":[\"can't be blank\"]}")
      end
    end

    context 'when the request is invalid - destination_account_id blank (should not find an account' do
      before { post '/transfers', headers: valid_auth, 
        params: { transfer: { account_id: source_account.id, amount: 10000 } } }

      it 'returns status code :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("{\"destination_account_id\":[\"destination account must exist.\"]}")
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
