require 'rails_helper'

RSpec.describe Subject, type: :model do
  describe 'バリデーション' do
    context 'タイトルがある場合' do
      it '科目を登録できる' do
        subject = FactoryBot.build(:subject)
        expect(subject).to be_valid
      end
    end

    describe 'タイトル' do
      context 'ない場合' do
        it '科目を登録できない' do
          subject = FactoryBot.build(:subject, title: nil)
          expect(subject).to be_invalid
          subject = FactoryBot.build(:subject, title: '')
          expect(subject).to be_invalid
        end
      end

      context '255文字以下の場合' do
        it '科目を登録できる' do
          subject = FactoryBot.build(:subject, title: 'a' * 255)
          expect(subject).to be_valid
          subject = FactoryBot.build(:subject, title: 'あ' * 255)
          expect(subject).to be_valid
        end
      end

      context '256文字以上の場合' do
        it '科目を登録できない' do
          subject = FactoryBot.build(:subject, title: 'a' * 256)
          expect(subject).to be_invalid
          subject = FactoryBot.build(:subject, title: 'あ' * 256)
          expect(subject).to be_invalid
        end
      end
    end

    describe 'メモ' do
      context '65,535文字以下の場合' do
        it '科目を登録できる' do
          subject = FactoryBot.build(:subject, memo: 'a' * 65_535)
          expect(subject).to be_valid
          subject = FactoryBot.build(:subject, memo: 'あ' * 65_535)
          expect(subject).to be_valid
        end
      end

      context '65,536文字以上の場合' do
        it '科目を登録できない' do
          subject = FactoryBot.build(:subject, memo: 'a' * 65_536)
          expect(subject).to be_invalid
          subject = FactoryBot.build(:subject, memo: 'あ' * 65_536)
          expect(subject).to be_invalid
        end
      end
    end
  end
end
