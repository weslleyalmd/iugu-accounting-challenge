class CompleteAccountSerializer < ActiveModel::Serializer
  include ActionView::Helpers::NumberHelper

  attributes :id, :name, :balance

  def balance
    number_to_currency(object.balance.to_f / 100, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end