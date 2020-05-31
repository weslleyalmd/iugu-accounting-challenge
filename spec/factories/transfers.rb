FactoryGirl.define do
  factory :transfer do
    association :account, factory: :account
    destination_account_id 1
    amount 10000
  end
end
