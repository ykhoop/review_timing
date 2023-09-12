FactoryBot.define do
  factory :subject_detail do
    subject
    chapter { 'テスト章' }
    start_page { 1 }
    end_page { 10 }
    start_at { Time.zone.now }
  end
end
