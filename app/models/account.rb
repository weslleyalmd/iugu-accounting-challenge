class Account < ApplicationRecord
  validates_presence_of :name, :balance
end