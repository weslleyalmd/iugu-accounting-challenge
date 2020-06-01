FactoryGirl.define do
  factory :transfer do
    association :account, factory: :account
    destination_account_id 1
    amount 1000
  end
end
