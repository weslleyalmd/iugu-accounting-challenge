class Transfer < ApplicationRecord
  validates_presence_of :amount
  belongs_to :account

  validates_with DestinationAccountExistsValidator
  validates_with SourceAccountHasBalanceValidation
  validates_with SourceAccountDiffDestinationAccountValidator

  before_create :execute_transfer

  private

  def execute_transfer
    source_account = Account.find(account_id)
    destination_account = Account.find(destination_account_id)

    ### Withdraw money from source_account
    source_account.withdraw(amount)

    ### Deposit money to destination_account
    destination_account.deposit(amount)
  end
end
