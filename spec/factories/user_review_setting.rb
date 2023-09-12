FactoryBot.define do
  trait :with_additional_user_review_settings do
    after(:create) do |user_review_setting|
      3.times do |n|
        create(:user_review_setting,
               user: user_review_setting.user,
               review_number: n + 2,
               review_days: n + 2)
      end
    end
  end

  factory :user_review_setting do
    user
    review_number { 1 }
    review_days { 1 }

    factory :user_review_setting_with_additional_user_review_settings, traits: [:with_additional_user_review_settings]
  end
end
