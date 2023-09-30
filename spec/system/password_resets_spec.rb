require 'rails_helper'

RSpec.describe 'PasswordResets', type: :system do
  let(:user) { create(:user, email: 'test@example.com') }
  let(:user_having_token) { create(:user, email: 'test2@example.com', reset_password_token: 'token') }

  def send_reset_msg(email)
    visit new_password_reset_path
    fill_in 'メールアドレス', with: email
    click_button '送信'
  end

  def reset_password(token, email, password, password_confirmation = password)
    visit edit_password_reset_path(token)
    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: password
    fill_in 'パスワード確認', with: password_confirmation
    click_button '更新'
  end

  def assert_reset_msg
    expect(page).to have_content 'パスワード再設定メールを送信しました'
    expect(current_path).to eq root_path
  end

  def assert_reset_failed(token)
    expect(page).to have_content 'パスワード再設定に失敗しました'
    expect(current_path).to eq edit_password_reset_path(token)
  end

  before do
    create_init_data
  end

  describe 'パスワード再設定メール送信' do
    context '有効なメールアドレスを入力した場合' do
      it 'パスワード再設定メール送信のメッセージが表示されること' do
        send_reset_msg(user.email)
        assert_reset_msg
      end
    end

    context '未登録のメールアドレスを入力した場合' do
      it 'パスワード再設定メール送信のメッセージが表示されること' do
        send_reset_msg('invalid@example.com')
        assert_reset_msg
      end
    end

    context 'メールアドレスが未入力の場合' do
      it 'パスワード再設定メール送信のメッセージが表示されること' do
        send_reset_msg('')
        assert_reset_msg
      end
    end
  end

  describe 'パスワード再設定ページ' do
    describe '表示' do
      context '有効なトークンを入力した場合' do
        it 'パスワード再設定ページが表示されること' do
          visit edit_password_reset_path(user_having_token.reset_password_token)
          expect(page).to have_content 'パスワード再設定'
        end
      end

      context '無効なトークンを入力した場合' do
        it 'パスワード再設定ページが表示されないこと' do
          visit edit_password_reset_path('invalid_token')
          expect(page).to have_content 'ログインしてください'
          expect(current_path).to eq login_path
        end
      end
    end

    describe 'パスワード再設定' do
      new_password = 'NewPassword1'

      context '有効なメールアドレスとパスワードを入力した場合' do
        it 'パスワードが再設定されること' do
          reset_password(user_having_token.reset_password_token, user_having_token.email, new_password)
          expect(page).to have_content 'パスワードを再設定しました'
          expect(current_path).to eq root_path

          spec_login(user_having_token.email, new_password)
        end
      end

      context 'メールアドレスが未入力の場合' do
        it 'パスワードが再設定されないこと' do
          reset_password(user_having_token.reset_password_token, '', new_password)
          expect(page).to have_content 'メールアドレスを入力してください'
          assert_reset_failed(user_having_token.reset_password_token)
        end
      end

      context 'ユーザーのメールアドレスと異なるメールアドレスを入力した場合' do
        it 'パスワードが再設定されないこと' do
          reset_password(user_having_token.reset_password_token, 'different@example.com', new_password)
          expect(page).to have_content 'メールアドレスが一致しません'
          assert_reset_failed(user_having_token.reset_password_token)
        end
      end

      context 'パスワードが未入力の場合' do
        it 'パスワードが再設定されないこと' do
          reset_password(user_having_token.reset_password_token, user_having_token.email, '')
          expect(page).to have_content 'パスワードを入力してください'
          assert_reset_failed(user_having_token.reset_password_token)
        end
      end

      context 'パスワードが確認用パスワードと異なる場合' do
        it 'パスワードが再設定されないこと' do
          reset_password(user_having_token.reset_password_token, user_having_token.email, new_password, 'NewPassword2')
          expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
          assert_reset_failed(user_having_token.reset_password_token)
        end
      end

      context 'パスワードが8文字未満の場合' do
        it 'パスワードが再設定されないこと' do
          reset_password(user_having_token.reset_password_token, user_having_token.email, 'Pass1')
          expect(page).to have_content 'パスワードは8文字以上で入力してください'
          assert_reset_failed(user_having_token.reset_password_token)
        end
      end

      context 'パスワードに数字、大文字、小文字が含まれていない場合' do
        it 'パスワードが再設定されないこと' do
          reset_password(user_having_token.reset_password_token, user_having_token.email, 'password')
          expect(page).to have_content 'パスワードはアルファベット大文字、小文字、数字をそれぞれ１つ以上含む必要があります'
          assert_reset_failed(user_having_token.reset_password_token)
        end
      end
    end
  end
end
