class Transfer < ApplicationRecord
  validates_presence_of :destination_account_id, :amount
  belongs_to :account
end
