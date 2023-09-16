FactoryBot.define do
  trait :with_additional_subject_reviews do
    after(:create) do |subject_review|
      3.times do |n|
        create(:subject_review,
               subject_detail: subject_review.subject_detail,
               review_type: :plan,
               review_number: n + 2,
               review_at: subject_review.subject_detail.start_at + (n + 2).days)
      end

      4.times do |n|
        create(:subject_review,
               subject_detail: subject_review.subject_detail,
               review_type: :actual,
               review_number: n + 1,
               review_at: nil)
      end
    end
  end

  factory :subject_review do
    subject_detail
    review_type { :plan }
    review_number { 1 }
    review_at { subject_detail.start_at + 1.day }

    factory :subject_review_with_additional_subject_reviews, traits: [:with_additional_subject_reviews]
  end
end
