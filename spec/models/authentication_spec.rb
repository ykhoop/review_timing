require 'rails_helper'

RSpec.describe Authentication, type: :model do
  describe 'バリデーション' do
    context 'プロバイダー、UIDがある場合' do
      it '認証情報を登録できる' do
        authentication = FactoryBot.build(:authentication)
        expect(authentication).to be_valid
      end
    end

    context 'プロバイダーがない場合' do
      it '認証情報を登録できない' do
        authentication = FactoryBot.build(:authentication, provider: nil)
        expect(authentication).to be_invalid
        authentication = FactoryBot.build(:authentication, provider: '')
        expect(authentication).to be_invalid
      end
    end

    context 'UIDがない場合' do
      it '認証情報を登録できない' do
        authentication = FactoryBot.build(:authentication, uid: nil)
        expect(authentication).to be_invalid
        authentication = FactoryBot.build(:authentication, uid: '')
        expect(authentication).to be_invalid
      end
    end
  end
end
