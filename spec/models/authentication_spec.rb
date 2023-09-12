require 'rails_helper'

RSpec.describe Authentication, type: :model do
  describe 'バリデーション' do
    it 'プロバイダー、UIDがある場合、登録できる' do
      authentication = FactoryBot.build(:authentication)
      expect(authentication).to be_valid
    end

    it 'プロバイダーがない場合、登録できない' do
      authentication = FactoryBot.build(:authentication, provider: nil)
      expect(authentication).to be_invalid
      authentication = FactoryBot.build(:authentication, provider: '')
      expect(authentication).to be_invalid
    end

    it 'UIDがない場合、登録できない' do
      authentication = FactoryBot.build(:authentication, uid: nil)
      expect(authentication).to be_invalid
      authentication = FactoryBot.build(:authentication, uid: '')
      expect(authentication).to be_invalid
    end
  end
end
