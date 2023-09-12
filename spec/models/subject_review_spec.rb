require 'rails_helper'

RSpec.describe SubjectReview, type: :model do
  describe 'バリデーション' do
    it '復習タイプ、復習回数がある場合、登録できる' do
      subject_review = FactoryBot.build(:subject_review)
      expect(subject_review).to be_valid
    end

    it '復習タイプがない場合、登録できない' do
      subject_review = FactoryBot.build(:subject_review, review_type: nil)
      expect(subject_review).to be_invalid
    end

    it '復習回数がない場合、登録できない' do
      subject_review = FactoryBot.build(:subject_review, review_number: nil)
      expect(subject_review).to be_invalid
    end
  end

  describe 'メソッド' do
    describe 'self.create_review_days' do
      it '復習時間を作成すると、科目詳細の学習開始日時からユーザーの復習日数を加算した日時が登録される' do
        FactoryBot.create(:system_review_setting_with_additional_system_review_settings)
        subject_detail = FactoryBot.create(:subject_detail)
        UserReviewSetting.create_review_days!(subject_detail.subject.user)
        SubjectReview.create_reviews!(subject_detail, subject_detail.subject.user)

        expect(subject_detail.subject_reviews.count).to eq 8
        expect(subject_detail.subject_reviews.where(review_type: :plan).count).to eq 4
        expect(subject_detail.subject_reviews.where(review_type: :actual).count).to eq 4

        review_days = subject_detail.subject.user.user_review_settings.order(:review_number).pluck(:review_days)
        review_ats = subject_detail.subject_reviews.where(review_type: :plan).order(:review_number).pluck(:review_at)
        expect(review_ats[0]).to eq subject_detail.start_at + review_days[0].days
        expect(review_ats[1]).to eq subject_detail.start_at + review_days[1].days
        expect(review_ats[2]).to eq subject_detail.start_at + review_days[2].days
        expect(review_ats[3]).to eq subject_detail.start_at + review_days[3].days
      end
    end
  end
end
