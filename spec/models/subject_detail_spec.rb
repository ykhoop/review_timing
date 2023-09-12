require 'rails_helper'

RSpec.describe SubjectDetail, type: :model do
  describe 'バリデーション' do
    it '章、学習開始日時がある場合、登録できる' do
      subject_detail = FactoryBot.build(:subject_detail)
      expect(subject_detail).to be_valid
    end

    describe '章' do
      it '章がない場合、登録できない' do
        subject_detail = FactoryBot.build(:subject_detail, chapter: nil)
        expect(subject_detail).to be_invalid
        subject_detail = FactoryBot.build(:subject_detail, chapter: '')
        expect(subject_detail).to be_invalid
      end

      it '章が255文字以下の場合、登録できる' do
        subject_detail = FactoryBot.build(:subject_detail, chapter: 'a' * 255)
        expect(subject_detail).to be_valid
        subject_detail = FactoryBot.build(:subject_detail, chapter: 'あ' * 255)
        expect(subject_detail).to be_valid
      end

      it '章が256文字以上の場合、登録できない' do
        subject_detail = FactoryBot.build(:subject_detail, chapter: 'a' * 256)
        expect(subject_detail).to be_invalid
        subject_detail = FactoryBot.build(:subject_detail, chapter: 'あ' * 256)
        expect(subject_detail).to be_invalid
      end
    end

    describe '開始ページ' do
      it '開始ページがマイナスの場合、登録できない' do
        subject_detail = FactoryBot.build(:subject_detail, start_page: -1)
        expect(subject_detail).to be_invalid
      end

      it '開始ページが0の場合、登録できない' do
        subject_detail = FactoryBot.build(:subject_detail, start_page: 0)
        expect(subject_detail).to be_invalid
      end

      it '開始ページが1以上の場合、登録できる' do
        subject_detail = FactoryBot.build(:subject_detail, start_page: 1)
        expect(subject_detail).to be_valid
      end

      it '開始ページが10,000以下の場合、登録できる' do
        subject_detail = FactoryBot.build(:subject_detail, start_page: 10_000)
        expect(subject_detail).to be_valid
      end

      it '開始ページが10,001以上の場合、登録できない' do
        subject_detail = FactoryBot.build(:subject_detail, start_page: 10_001)
        expect(subject_detail).to be_invalid
      end
    end

    describe '終了ページ' do
      it '終了ページがマイナスの場合、登録できない' do
        subject_detail = FactoryBot.build(:subject_detail, end_page: -1)
        expect(subject_detail).to be_invalid
      end

      it '終了ページが0の場合、登録できない' do
        subject_detail = FactoryBot.build(:subject_detail, end_page: 0)
        expect(subject_detail).to be_invalid
      end

      it '終了ページが1以上の場合、登録できる' do
        subject_detail = FactoryBot.build(:subject_detail, end_page: 1)
        expect(subject_detail).to be_valid
      end

      it '終了ページが10,000以下の場合、登録できる' do
        subject_detail = FactoryBot.build(:subject_detail, end_page: 10_000)
        expect(subject_detail).to be_valid
      end

      it '終了ページが10,001以上の場合、登録できない' do
        subject_detail = FactoryBot.build(:subject_detail, end_page: 10_001)
        expect(subject_detail).to be_invalid
      end
    end

    describe '学習開始日時' do
      it '学習開始日時がない場合、登録できない' do
        subject_detail = FactoryBot.build(:subject_detail, start_at: nil)
        expect(subject_detail).to be_invalid
      end
    end
  end
end
