class SourceAccountDiffDestinationAccountValidator < ActiveModel::Validator
  def validate(record)
    if record.account_id == record.destination_account_id
      record.errors.add(:error, "source account and destination account must be different.")
    end
  end
end