require 'rails_helper'

RSpec.describe SystemSetting, type: :model do
  describe 'バリデーション' do
    context 'コード、説明がある場合' do
      it 'システム設定を登録できる' do
        document = FactoryBot.build(:system_setting)
        expect(document).to be_valid
      end
    end

    context 'コードがない場合' do
      it 'システム設定を登録できない' do
        document = FactoryBot.build(:system_setting, code: nil)
        expect(document).to be_invalid
      end
    end

    context 'コードが重複している場合' do
      it 'システム設定を登録できない' do
        system_setting = FactoryBot.create(:system_setting)
        system_setting2 = FactoryBot.build(:system_setting, code: system_setting.code)
        expect(system_setting2).to be_invalid
      end
    end

    context '説明がない場合' do
      it 'システム設定を登録できない' do
        system_setting = FactoryBot.build(:system_setting, description: nil)
        expect(system_setting).to be_invalid
      end
    end
  end

  describe 'メソッド' do
    describe 'max_users' do
      it 'ユーザー数の上限を返す' do
        FactoryBot.create(:system_setting, code: 'max_users', int_value: 10)
        system_setting = SystemSetting.find_by(code: 'max_users')
        expect(SystemSetting.max_users).to eq system_setting.int_value
      end
    end

    describe 'max_user_subjects' do
      it 'ユーザーごとの科目数の上限を返す' do
        FactoryBot.create(:system_setting, code: 'max_user_subjects', int_value: 20)
        system_setting = SystemSetting.find_by(code: 'max_user_subjects')
        expect(SystemSetting.max_user_subjects).to eq system_setting.int_value
      end
    end

    describe 'max_user_subject_details' do
      it 'ユーザー、科目ごとの科目詳細数の上限を返す' do
        FactoryBot.create(:system_setting, code: 'max_user_subject_details', int_value: 30)
        system_setting = SystemSetting.find_by(code: 'max_user_subject_details')
        expect(SystemSetting.max_user_subject_details).to eq system_setting.int_value
      end
    end

    describe 'notification_interval' do
      it '通知間隔を返す' do
        FactoryBot.create(:system_setting, code: 'notification_interval', int_value: 40)
        system_setting = SystemSetting.find_by(code: 'notification_interval')
        expect(SystemSetting.notification_interval).to eq system_setting.int_value
      end
    end
  end
end
