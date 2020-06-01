class TransferSerializer < ActiveModel::Serializer
  attributes :id, :source_account_id, :destination_account_id, :amount
  
  def source_account_id
    object.account_id
  end
end
