require 'rails_helper'

RSpec.describe UserSetting, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe 'バリデーション' do
    context 'ユーザー、メール通知、LINE通知、ブラウザ通知、最大科目数、最大科目詳細数がある場合' do
      it 'ユーザー設定を登録できる' do
        user_setting = FactoryBot.build(:user_setting, user:)
        expect(user_setting).to be_valid
      end
    end

    context 'ユーザーがない場合' do
      it 'ユーザー設定を登録できない' do
        user_setting = FactoryBot.build(:user_setting, user: nil)
        expect(user_setting).to be_invalid
      end
    end

    context 'メール通知がない場合' do
      it 'ユーザー設定を登録できない' do
        user_setting = FactoryBot.build(:user_setting, user:, remind_mail: nil)
        expect(user_setting).to be_invalid
      end
    end

    context 'LINE通知がない場合' do
      it 'ユーザー設定を登録できない' do
        user_setting = FactoryBot.build(:user_setting, user:, remind_line: nil)
        expect(user_setting).to be_invalid
      end
    end

    context 'ブラウザ通知がない場合' do
      it 'ユーザー設定を登録できない' do
        user_setting = FactoryBot.build(:user_setting, user:, remind_browser: nil)
        expect(user_setting).to be_invalid
      end
    end

    context '最大科目数がない場合' do
      it 'ユーザー設定を登録できない' do
        user_setting = FactoryBot.build(:user_setting, user:, max_subjects: nil)
        expect(user_setting).to be_invalid
      end
    end

    context '最大科目数がマイナスの場合' do
      it 'ユーザー設定を登録できない' do
        user_setting = FactoryBot.build(:user_setting, user:, max_subjects: -1)
        expect(user_setting).to be_invalid
      end
    end

    context '最大科目数が0の場合' do
      it 'ユーザー設定を登録できる' do
        user_setting = FactoryBot.build(:user_setting, user:, max_subjects: 0)
        expect(user_setting).to be_valid
      end
    end

    context '最大科目詳細数がない場合' do
      it 'ユーザー設定を登録できない' do
        user_setting = FactoryBot.build(:user_setting, user:, max_subject_details: nil)
        expect(user_setting).to be_invalid
      end
    end

    context '最大科目詳細数がマイナスの場合' do
      it 'ユーザー設定を登録できない' do
        user_setting = FactoryBot.build(:user_setting, user:, max_subject_details: -1)
        expect(user_setting).to be_invalid
      end
    end

    context '最大科目詳細数が0の場合' do
      it 'ユーザー設定を登録できる' do
        user_setting = FactoryBot.build(:user_setting, user:, max_subject_details: 0)
        expect(user_setting).to be_valid
      end
    end
  end
end
