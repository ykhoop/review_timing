require 'rails_helper'

RSpec.describe UserReviewSetting, type: :model do
  describe 'バリデーション' do
    context 'ユーザー、レビュー回数、レビュー日数がある場合' do
      it '復習設定を登録できる' do
        user_review_setting = FactoryBot.build(:user_review_setting)
        expect(user_review_setting).to be_valid
      end
    end

    context 'ユーザーがない場合' do
      it '復習設定を登録できない' do
        user_review_setting = FactoryBot.build(:user_review_setting, user: nil)
        expect(user_review_setting).to be_invalid
      end
    end

    context 'レビュー回数がない場合' do
      it '復習設定を登録できない' do
        user_review_setting = FactoryBot.build(:user_review_setting, review_number: nil)
        expect(user_review_setting).to be_invalid
      end
    end

    context 'レビュー日数がない場合' do
      it '復習設定を登録できない' do
        user_review_setting = FactoryBot.build(:user_review_setting, review_days: nil)
        expect(user_review_setting).to be_invalid
      end
    end
  end

  describe 'メソッド' do
    describe 'self.create_review_days!' do
      it 'ユーザーにレビュー設定を作成すると、システムレビュー設定と同じレビュー日数が登録される' do
        FactoryBot.create(:system_review_setting_with_additional_system_review_settings)
        user = FactoryBot.create(:user)
        UserReviewSetting.create_review_days!(user)

        expect(user.user_review_settings.count).to eq 4

        review_days = SystemReviewSetting.order(:review_number).first.review_days
        expect(user.user_review_settings.order(:review_number).first.review_days).to eq review_days

        review_days = SystemReviewSetting.order(:review_number).second.review_days
        expect(user.user_review_settings.order(:review_number).second.review_days).to eq review_days

        review_days = SystemReviewSetting.order(:review_number).third.review_days
        expect(user.user_review_settings.order(:review_number).third.review_days).to eq review_days

        review_days = SystemReviewSetting.order(:review_number).fourth.review_days
        expect(user.user_review_settings.order(:review_number).fourth.review_days).to eq review_days
      end
    end
  end
end
