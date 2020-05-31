class Transfer < ApplicationRecord
  validates_presence_of :amount
  belongs_to :account

  validates_with DestinationAccountExistsValidator
  validates_with SourceAccountHasBalanceValidation
  validates_with SourceAccountDiffDestinationAccountValidator
end
