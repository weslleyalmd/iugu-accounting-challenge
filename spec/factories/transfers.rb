FactoryGirl.define do
  factory :transfer do
    association :account, factory: :account
    destination_account_id 2
    amount 10000
  end
end
