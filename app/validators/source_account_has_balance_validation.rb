class SourceAccountHasBalanceValidation < ActiveModel::Validator
  def validate(record)
    source_account = Account.where(id: record.account_id).first 
    if source_account && record.amount
      if source_account.balance < record.amount
        record.errors.add(:source_acount_balance, "source acount doesn't have enough balance.")
      end
    end
  end
end