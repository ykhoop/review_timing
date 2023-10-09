FactoryBot.define do
  factory :log do
    log_level { 1 }
    program { "MyString" }
    log_content { "MyText" }
  end
end
