class DestinationAccountExistsValidator < ActiveModel::Validator
  def validate(record)
    unless Account.where(id: record.destination_account_id).any?
      record.errors.add(:destination_account_id, "destination account must exist.")
    end
  end
end