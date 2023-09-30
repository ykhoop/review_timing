FactoryBot.define do
  factory :user do
    first_name { 'テスト' }
    last_name { 'ユーザー' }
    email { 'testuser@example.com' }
    password { 'Password1' }
    password_confirmation { 'Password1' }
    reset_password_token { 'testtoken' }
  end
end
