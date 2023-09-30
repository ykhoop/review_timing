require 'rails_helper'

RSpec.describe 'Login', type: :system do
  password = 'Password1'
  let(:user) { create(:user, last_name: 'テスト', first_name: '太郎', email: 'test@example.com', password:) }

  def set_fields(email, password)
    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: password
  end

  def assert_login_failed
    expect(page).to have_content 'ログインに失敗しました'
    expect(current_path).to eq login_path
  end

  before do
    create_init_data
  end

  describe 'ログインページ' do
    describe 'ログイン' do
      context '有効なユーザー情報を入力した場合' do
        it 'ログインが成功すること' do
          visit login_path
          set_fields(user.email, password)
          click_button 'ログイン'

          expect(page).to have_content 'ログインしました'
          expect(current_path).to eq root_path
        end
      end

      context '無効なユーザー情報を入力した場合' do
        context 'メールアドレスが未入力の場合' do
          it 'ログインが失敗すること' do
            visit login_path
            set_fields('', password)
            click_button 'ログイン'

            assert_login_failed
          end
        end

        context 'パスワードが未入力の場合' do
          it 'ログインが失敗すること' do
            visit login_path
            set_fields(user.email, '')
            click_button 'ログイン'

            assert_login_failed
          end
        end

        context 'メールアドレスが存在しない場合' do
          it 'ログインが失敗すること' do
            visit login_path
            set_fields('invalid@example.com', password)
            click_button 'ログイン'

            assert_login_failed
          end
        end

        context 'パスワードが間違っている場合' do
          it 'ログインが失敗すること' do
            visit login_path
            set_fields(user.email, 'invalid')
            click_button 'ログイン'

            assert_login_failed
          end
        end
      end
    end

    describe 'ログアウト' do
      it '成功すること' do
        visit login_path
        set_fields(user.email, password)
        click_button 'ログイン'

        expect(page).to have_content 'ログインしました'
        expect(current_path).to eq root_path

        menu_button = find('button.navbar-toggler', wait: 10)
        menu_button.click

        user_link = find('a', text: "#{user.last_name} #{user.first_name}", wait: 10)
        user_link.click

        logout_link = find('a', text: 'ログアウト', wait: 10)
        logout_link.click

        expect(page.driver.browser.switch_to.alert.text).to eq 'ログアウトしますか？'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content 'ログアウトしました'

        visit profile_users_path
        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end
    end

    describe 'リンク' do
      context '「ユーザー登録」リンクをクリックした場合' do
        it 'ユーザー登録ページに遷移すること' do
          visit login_path
          click_link 'ユーザー登録'
          page_title = find(:xpath, '//h3[text()="ユーザー登録"]', wait: 10)

          expect(page_title).to be_truthy
          expect(current_path).to eq new_user_path
        end
      end

      context '「パスワードをお忘れの方」リンクをクリックした場合' do
        it 'パスワード再設定ページに遷移すること' do
          visit login_path
          click_link 'パスワードをお忘れの方'
          page_title = find(:xpath, '//h3[text()="パスワード再設定"]', wait: 10)

          expect(page_title).to be_truthy
          expect(current_path).to eq new_password_reset_path
        end
      end
    end
  end
end
