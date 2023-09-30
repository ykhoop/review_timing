require 'rails_helper'

RSpec.describe 'Profiles', type: :system do
  password = 'Password1'
  let(:user) { create(:user, email: 'test@example.com', password:) }

  def update_profile(last_name, first_name)
    visit profile_users_path
    fill_in '姓', with: last_name
    fill_in '名', with: first_name
    click_button '更新'
  end

  before do
    create_init_data
  end

  describe 'プロフィールページ' do
    context 'ログインしていない場合' do
      it 'ページが表示されないこと' do
        visit profile_users_path

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end
    end

    context 'ログインしている場合' do
      it '姓、名が表示されること' do
        spec_login(user.email, password)
        visit profile_users_path

        expect(find_field('姓').value).to eq user.last_name
        expect(find_field('名').value).to eq user.first_name
      end
    end

    describe '更新' do
      before do
        spec_login(user.email, password)
      end

      context '姓，名を入力した場合' do
        it 'プロフィールが更新されること' do
          update_profile("#{user.last_name} updated", "#{user.first_name} updated")

          expect(page).to have_content 'プロフィールを更新しました'
          updated_user = User.find(user.id)
          expect(updated_user.last_name).to eq "#{user.last_name} updated"
          expect(updated_user.first_name).to eq "#{user.first_name} updated"
        end
      end

      context '姓が未入力の場合' do
        it 'プロフィールが更新されないこと' do
          update_profile('', "#{user.first_name} updated")

          expect(page).to have_content 'プロフィール更新に失敗しました'
          expect(page).to have_content '姓を入力してください'
          updated_user = User.find(user.id)
          expect(updated_user.last_name).to eq user.last_name
          expect(updated_user.first_name).to eq user.first_name
        end
      end

      context '名が未入力の場合' do
        it 'プロフィールが更新されないこと' do
          update_profile("#{user.last_name} updated", '')

          expect(page).to have_content 'プロフィール更新に失敗しました'
          expect(page).to have_content '名を入力してください'
          updated_user = User.find(user.id)
          expect(updated_user.last_name).to eq user.last_name
          expect(updated_user.first_name).to eq user.first_name
        end
      end
    end
  end
end
