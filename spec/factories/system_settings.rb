FactoryBot.define do
  trait :with_additional_system_settings do
    after(:create) do |_system_setting|
      create(:system_setting,
             code: 'max_user_subjects',
             description: 'ユーザーごとに登録可能な最大科目数',
             int_value: 6)

      create(:system_setting,
             code: 'max_user_subject_details',
             description: 'ユーザー、科目ごとに登録可能な最大科目数',
             int_value: 7)

      create(:system_setting,
             code: 'notification_interval',
             description: '通知ジョブの各通知のインターバル（ミリ秒）',
             int_value: 1000)
    end
  end

  factory :system_setting do
    code { 'max_users' }
    description { '登録可能な最大ユーザ-数' }
    int_value { 5 }

    factory :system_setting_with_additional_system_settings,
            traits: [:with_additional_system_settings]
  end
end
