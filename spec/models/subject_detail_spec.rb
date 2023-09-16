require 'rails_helper'

RSpec.describe SubjectDetail, type: :model do
  describe 'バリデーション' do
    context '章、開始ページ、終了ページ、学習開始日時がある場合' do
      it '科目詳細を登録できる' do
        subject_detail = FactoryBot.build(:subject_detail)
        expect(subject_detail).to be_valid
      end
    end

    describe '章' do
      context 'ない場合' do
        it '科目詳細を登録できない' do
          subject_detail = FactoryBot.build(:subject_detail, chapter: nil)
          expect(subject_detail).to be_invalid
          subject_detail = FactoryBot.build(:subject_detail, chapter: '')
          expect(subject_detail).to be_invalid
        end
      end

      context '255文字以下の場合' do
        it '科目詳細を登録できる' do
          subject_detail = FactoryBot.build(:subject_detail, chapter: 'a' * 255)
          expect(subject_detail).to be_valid
          subject_detail = FactoryBot.build(:subject_detail, chapter: 'あ' * 255)
          expect(subject_detail).to be_valid
        end
      end

      context '256文字以上の場合' do
        it '科目詳細を登録できない' do
          subject_detail = FactoryBot.build(:subject_detail, chapter: 'a' * 256)
          expect(subject_detail).to be_invalid
          subject_detail = FactoryBot.build(:subject_detail, chapter: 'あ' * 256)
          expect(subject_detail).to be_invalid
        end
      end
    end

    describe '開始ページ' do
      context 'マイナスの場合' do
        it '科目詳細を登録できない' do
          subject_detail = FactoryBot.build(:subject_detail, start_page: -1)
          expect(subject_detail).to be_invalid
        end
      end

      context '0の場合' do
        it '科目詳細を登録できない' do
          subject_detail = FactoryBot.build(:subject_detail, start_page: 0)
          expect(subject_detail).to be_invalid
        end
      end

      context '1以上の場合' do
        it '科目詳細を登録できる' do
          subject_detail = FactoryBot.build(:subject_detail, start_page: 1)
          expect(subject_detail).to be_valid
        end
      end

      context '10,000以下の場合' do
        it '科目詳細を登録できる' do
          subject_detail = FactoryBot.build(:subject_detail, start_page: 10_000)
          expect(subject_detail).to be_valid
        end
      end

      context '10,001以上の場合' do
        it '科目詳細を登録できない' do
          subject_detail = FactoryBot.build(:subject_detail, start_page: 10_001)
          expect(subject_detail).to be_invalid
        end
      end
    end

    describe '終了ページ' do
      context 'マイナスの場合' do
        it '科目詳細を登録できない' do
          subject_detail = FactoryBot.build(:subject_detail, end_page: -1)
          expect(subject_detail).to be_invalid
        end
      end

      context '0の場合' do
        it '科目詳細を登録できない' do
          subject_detail = FactoryBot.build(:subject_detail, end_page: 0)
          expect(subject_detail).to be_invalid
        end
      end

      context '1以上の場合' do
        it '科目詳細を登録できる' do
          subject_detail = FactoryBot.build(:subject_detail, end_page: 1)
          expect(subject_detail).to be_valid
        end
      end

      context '10,000以下の場合' do
        it '科目詳細を登録できる' do
          subject_detail = FactoryBot.build(:subject_detail, end_page: 10_000)
          expect(subject_detail).to be_valid
        end
      end

      context '10,001以上の場合' do
        it '科目詳細を登録できない' do
          subject_detail = FactoryBot.build(:subject_detail, end_page: 10_001)
          expect(subject_detail).to be_invalid
        end
      end
    end

    describe '学習開始日時' do
      context 'ない場合' do
        it '科目詳細を登録できない' do
          subject_detail = FactoryBot.build(:subject_detail, start_at: nil)
          expect(subject_detail).to be_invalid
        end
      end
    end
  end
end
