FactoryBot.define do
  trait :with_additional_system_review_settings do
    after(:create) do |_system_review_setting|
      3.times do |n|
        create(:system_review_setting,
               review_number: n + 2,
               review_days: n + 2)
      end
    end
  end

  factory :system_review_setting do
    review_number { 1 }
    review_days { 1 }

    factory :system_review_setting_with_additional_system_review_settings,
            traits: [:with_additional_system_review_settings]
  end
end
