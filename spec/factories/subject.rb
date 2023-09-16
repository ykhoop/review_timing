FactoryBot.define do
  factory :subject do
    title { 'テスト科目' }
    start_at { Time.zone.now }
    limit_at { Time.zone.now + 1.month }
    memo { 'テスト科目のメモ' }
    user
  end
end
