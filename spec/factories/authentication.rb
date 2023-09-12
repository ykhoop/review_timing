FactoryBot.define do
  factory :authentication do
    user
    provider { 'line' }
    uid { 'test_uid' }
  end
end
