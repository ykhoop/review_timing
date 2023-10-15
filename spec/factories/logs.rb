FactoryBot.define do
  factory :log do
    log_level { :debug }
    program { 'Program' }
    log_content { 'Processing starts' }
  end
end
