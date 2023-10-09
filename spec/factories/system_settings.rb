FactoryBot.define do
  factory :system_setting do
    code { "MyString" }
    description { "MyString" }
    int_value { 1 }
    str_value { "MyString" }
    text_value { "MyText" }
  end
end
