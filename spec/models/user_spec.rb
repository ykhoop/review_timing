require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it 'メールアドレス、名、姓、パスワードがある場合、登録できる' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    describe 'メールアドレスのバリデーション' do
      it 'メールアドレスがない場合、登録できない' do
        user = FactoryBot.build(:user, email: nil)
        expect(user).to be_invalid
        user = FactoryBot.build(:user, email: '')
        expect(user).to be_invalid
      end

      it '同一メールアドレスの場合、登録できない' do
        user1 = FactoryBot.create(:user, email: 'mail@example.com', first_name: '1', last_name: '11',
                                         password: 'Password1', password_confirmation: 'Password1')
        expect(user1).to be_valid
        user2 = FactoryBot.build(:user, email: 'mail@example.com', first_name: '2', last_name: '22',
                                        password: 'Password2', password_confirmation: 'Password2')
        expect(user2).to be_invalid
      end

      it 'メールアドレスが255文字以下の場合、登録できる' do
        user = FactoryBot.build(:user, email: 'a' * 243 + '@example.com')
        expect(user).to be_valid
      end

      it 'メールアドレスが256文字以上の場合、登録できない' do
        user = FactoryBot.build(:user, email: 'a' * 244 + '@example.com')
        expect(user).to be_invalid
      end
    end

    describe '姓のバリデーション' do
      it '姓がない場合、登録できない' do
        user = FactoryBot.build(:user, last_name: nil)
        expect(user).to be_invalid
        user = FactoryBot.build(:user, last_name: '')
        expect(user).to be_invalid
      end

      it '姓が255文字以下の場合、登録できる' do
        user = FactoryBot.build(:user, last_name: 'a' * 255)
        expect(user).to be_valid
        user = FactoryBot.build(:user, last_name: 'あ' * 255)
        expect(user).to be_valid
      end

      it '姓が256文字以上の場合、登録できない' do
        user = FactoryBot.build(:user, last_name: 'a' * 256)
        expect(user).to be_invalid
        user = FactoryBot.build(:user, last_name: 'あ' * 256)
        expect(user).to be_invalid
      end
    end

    describe '名のバリデーション' do
      it '名がない場合、登録できない' do
        user = FactoryBot.build(:user, first_name: nil)
        expect(user).to be_invalid
        user = FactoryBot.build(:user, first_name: '')
        expect(user).to be_invalid
      end

      it '名が255文字以下の場合、登録できる' do
        user = FactoryBot.build(:user, first_name: 'a' * 255)
        expect(user).to be_valid
        user = FactoryBot.build(:user, first_name: 'あ' * 255)
        expect(user).to be_valid
      end

      it '名が256文字以上の場合、登録できない' do
        user = FactoryBot.build(:user, first_name: 'a' * 256)
        expect(user).to be_invalid
        user = FactoryBot.build(:user, first_name: 'あ' * 256)
        expect(user).to be_invalid
      end
    end

    describe 'パスワードのバリデーション' do
      it 'パスワードがない場合、登録できない' do
        user = FactoryBot.build(:user, password: nil)
        expect(user).to be_invalid
        user = FactoryBot.build(:user, password: '')
        expect(user).to be_invalid
      end

      it 'パスワードが7文字以下の場合、登録できない' do
        user = FactoryBot.build(:user, password: 'a' * 5 + 'A1', password_confirmation: 'a' * 5 + 'A1')
        expect(user).to be_invalid
      end

      it 'パスワードが8文字以上の場合、登録できる' do
        user = FactoryBot.build(:user, password: 'a' * 6 + 'A1', password_confirmation: 'a' * 6 + 'A1')
        expect(user).to be_valid
      end

      it 'パスワードが255文字以下の場合、登録できる' do
        user = FactoryBot.build(:user, password: 'a' * 253 + 'A1', password_confirmation: 'a' * 253 + 'A1')
        expect(user).to be_valid
      end

      it 'パスワードが256文字以上の場合、登録できない' do
        user = FactoryBot.build(:user, password: 'a' * 254 + 'A1', password_confirmation: 'a' * 254 + 'A1')
        expect(user).to be_invalid
      end

      it 'パスワードが確認パスワードと一致しない場合、登録できない' do
        user = FactoryBot.build(:user, password: 'a' * 6 + 'A1', password_confirmation: 'a' * 6 + 'A2')
        expect(user).to be_invalid
      end

      it 'パスワードに数字を含まない場合、登録できない' do
        user = FactoryBot.build(:user, password: 'a' * 6 + 'AA', password_confirmation: 'a' * 6 + 'AA')
        expect(user).to be_invalid
      end

      it '英字大文字を含まない場合、登録できない' do
        user = FactoryBot.build(:user, password: 'a' * 6 + 'a1', password_confirmation: 'a' * 6 + 'a1')
        expect(user).to be_invalid
      end

      it '英字小文字を含まない場合、登録できない' do
        user = FactoryBot.build(:user, password: 'A' * 6 + 'A1', password_confirmation: 'A' * 6 + 'A1')
        expect(user).to be_invalid
      end
    end
  end

  describe 'メソッド' do
    describe 'own?メソッド' do
      it 'オブジェクトがユーザーのもの場合、Trueを返す' do
        user = FactoryBot.create(:user)
        subject = FactoryBot.create(:subject, user:)
        expect(user.own?(subject)).to be_truthy
      end

      it 'オブジェクトがユーザーのものでない場合、Falseを返す' do
        user1 = FactoryBot.create(:user, email: 'user1@example.com')
        user2 = FactoryBot.create(:user, email: 'user2@example.com')
        subject = FactoryBot.create(:subject, user: user1)
        expect(user2.own?(subject)).to be_falsey
      end
    end

    describe 'has_line?メソッド' do
      it 'ユーザーがLINE認証をしている場合、Trueを返す' do
        user = FactoryBot.create(:user)
        authentication = FactoryBot.create(:authentication, user:)
        expect(user.has_line?).to be_truthy
      end

      it 'ユーザーがLINE認証をしていない場合、Falseを返す' do
        user = FactoryBot.create(:user)
        expect(user.has_line?).to be_falsey
      end
    end
  end
end
