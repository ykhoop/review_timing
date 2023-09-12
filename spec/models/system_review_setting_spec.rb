require 'rails_helper'

RSpec.describe SystemReviewSetting, type: :model do
  describe 'バリデーション' do
    it 'レビュー回数、レビュー日数がある場合、登録できる' do
      system_review_setting = FactoryBot.build(:system_review_setting)
      expect(system_review_setting).to be_valid
    end

    it 'レビュー回数がない場合、登録できない' do
      system_review_setting = FactoryBot.build(:system_review_setting, review_number: nil)
      expect(system_review_setting).to be_invalid
    end

    it 'レビュー日数がない場合、登録できない' do
      system_review_setting = FactoryBot.build(:system_review_setting, review_days: nil)
      expect(system_review_setting).to be_invalid
    end
  end
end
