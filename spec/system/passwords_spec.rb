require 'rails_helper'

RSpec.describe 'Passwords', type: :system do
  password = 'Password1'
  let(:user) { create(:user, email: 'test@example.com', password:) }

  def update_password(current_password, new_password, new_password_confirmation = new_password)
    visit password_users_path
    fill_in '現在のパスワード', with: current_password
    fill_in 'パスワード', with: new_password
    fill_in 'パスワード確認', with: new_password_confirmation
    click_button '更新'
  end

  before do
    create_init_data
  end

  describe 'パスワード変更ページ' do
    context 'ログインしていない場合' do
      it 'ページが表示されないこと' do
        visit password_users_path

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end
    end

    describe '更新' do
      before do
        spec_login(user.email, password)
      end

      context '正しい現在のパスワード、新しいパスワード、新しいパスワード（確認）を入力した場合' do
        it 'パスワードが更新されること' do
          new_password = 'Password2'
          update_password(password, new_password)

          expect(page).to have_content 'パスワードを変更しました'
          spec_login(user.email, new_password)
        end
      end

      describe '現在のパスワード' do
        context '未入力の場合' do
          it 'パスワードが更新されないこと' do
            update_password('', 'Password2')

            expect(page).to have_content '現在のパスワードを入力してください'
            expect(page).to have_content 'パスワード変更に失敗しました'
            spec_login(user.email, password)
          end
        end

        context '間違ったパスワードを入力した場合' do
          it 'パスワードが更新されないこと' do
            update_password('WrongPassword1', 'Password2')

            expect(page).to have_content '現在のパスワードを入力してください'
            expect(page).to have_content 'パスワード変更に失敗しました'
            spec_login(user.email, password)
          end
        end
      end

      describe '新しいパスワード' do
        context '未入力の場合' do
          it 'パスワードが更新されないこと' do
            update_password(password, '')

            expect(page).to have_content '新しいパスワードを入力してください'
            expect(page).to have_content 'パスワード変更に失敗しました'
            spec_login(user.email, password)
          end
        end

        context '確認用パスワードと一致しない場合' do
          it 'パスワードが更新されないこと' do
            update_password(password, 'Password2', 'Password3')

            expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
            expect(page).to have_content 'パスワード変更に失敗しました'
            spec_login(user.email, password)
          end
        end

        context 'パスワードの文字数が8文字未満の場合' do
          it 'パスワードが更新されないこと' do
            update_password(password, 'Pass1')

            expect(page).to have_content 'パスワードは8文字以上で入力してください'
            expect(page).to have_content 'パスワード変更に失敗しました'
            spec_login(user.email, password)
          end
        end

        context 'パスワードに数字、大文字、小文字が含まれていない場合' do
          it 'パスワードが更新されないこと' do
            update_password(password, 'password')

            expect(page).to have_content 'パスワードはアルファベット大文字、小文字、数字をそれぞれ１つ以上含む必要があります'
            expect(page).to have_content 'パスワード変更に失敗しました'
            spec_login(user.email, password)
          end
        end

        context '現在のパスワードと同じパスワードを入力した場合' do
          it 'パスワードが更新されないこと' do
            update_password(password, password)

            expect(page).to have_content '現在のパスワードと同じパスワードは使用できません'
            expect(page).to have_content 'パスワード変更に失敗しました'
            spec_login(user.email, password)
          end
        end
      end
    end
  end
end
