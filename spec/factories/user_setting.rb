FactoryBot.define do
  factory :user_setting do
    user
    remind_mail { :mail_not_receive }
    remind_line { :line_not_receive }
    remind_browser { :browser_not_receive }
  end
end
