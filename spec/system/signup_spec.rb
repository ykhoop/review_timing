require 'rails_helper'

RSpec.describe 'Signup', type: :system do
  last_name = 'テスト'
  first_name = '太郎'
  email = 'test@example.com'
  password = 'Password1'
  password_confirmation = 'Password1'

  def set_fields(last_name, first_name, email, password, password_confirmation = password)
    fill_in '姓', with: last_name
    fill_in '名', with: first_name
    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: password
    fill_in 'パスワード確認', with: password_confirmation
  end

  def assert_reg_failed(email)
    expect(page).to have_content 'ユーザー登録に失敗しました'
    expect(User.find_by(email:)).to be_falsey
    expect(current_path).to eq new_user_path
  end

  before do
    create_init_data
  end

  describe 'ユーザー登録ページ' do
    context '有効なユーザー情報を入力した場合' do
      it 'ユーザー登録が成功すること' do
        visit new_user_path
        set_fields(last_name, first_name, email, password)
        click_button '登録'

        expect(page).to have_content 'ユーザー登録が完了しました'
        user = User.find_by(email:)
        expect(user).to be_truthy
        expect(user.user_review_settings.count).to eq 4
        expect(user.user_setting).to be_truthy
        expect(current_path).to eq login_path
      end
    end

    context '無効なユーザー情報を入力した場合' do
      context '姓が未入力の場合' do
        it 'ユーザー登録が失敗すること' do
          visit new_user_path
          set_fields('', first_name, email, password)
          click_button '登録'

          expect(page).to have_content '姓を入力してください'
          assert_reg_failed(email)
        end
      end

      context '名が未入力の場合' do
        it 'ユーザー登録が失敗すること' do
          visit new_user_path
          set_fields(last_name, '', email, password)
          click_button '登録'

          expect(page).to have_content '名を入力してください'
          assert_reg_failed(email)
        end
      end

      context 'メールアドレスが未入力の場合' do
        it 'ユーザー登録が失敗すること' do
          visit new_user_path
          set_fields(last_name, first_name, '', password)
          click_button '登録'

          expect(page).to have_content 'メールアドレスを入力してください'
          assert_reg_failed(email)
        end
      end

      context 'メールアドレスの形式が不正な場合' do
        it 'ユーザー登録が失敗すること' do
          visit new_user_path
          set_fields(last_name, first_name, 'yamada', password)
          click_button '登録'

          expect(User.find_by(email: 'yamada')).to be_falsey
          expect(current_path).to eq new_user_path
        end
      end

      context 'メールアドレスが既に登録されている場合' do
        it 'ユーザー登録が失敗すること' do
          create(:user, email:)
          visit new_user_path
          set_fields(last_name, first_name, email, password)
          click_button '登録'

          expect(page).to have_content 'メールアドレスはすでに存在します'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(current_path).to eq new_user_path
        end
      end

      context 'パスワードが未入力の場合' do
        it 'ユーザー登録が失敗すること' do
          visit new_user_path
          set_fields(last_name, first_name, email, '')
          click_button '登録'

          expect(page).to have_content 'パスワードを入力してください'
          assert_reg_failed(email)
        end
      end

      context 'パスワードとパスワード確認が一致しない場合' do
        it 'ユーザー登録が失敗すること' do
          visit new_user_path
          set_fields(last_name, first_name, email, password, 'Password2')
          click_button '登録'

          expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
          assert_reg_failed(email)
        end
      end

      context 'パスワードが8文字未満の場合' do
        it 'ユーザー登録が失敗すること' do
          visit new_user_path
          set_fields(last_name, first_name, email, 'Pass1')
          click_button '登録'

          expect(page).to have_content 'パスワードは8文字以上で入力してください'
          assert_reg_failed(email)
        end
      end

      context 'パスワードに数字、大文字、小文字が含まれていない場合' do
        it 'ユーザー登録が失敗すること' do
          visit new_user_path
          set_fields(last_name, first_name, email, 'password')
          click_button '登録'

          expect(page).to have_content 'パスワードはアルファベット大文字、小文字、数字をそれぞれ１つ以上含む必要があります'
          assert_reg_failed(email)
        end
      end
    end
  end
end
