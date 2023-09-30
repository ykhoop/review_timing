require 'rails_helper'

RSpec.describe 'UserSettings', type: :system do
  password = 'Password1'
  review_days = []
  old_review_days = []
  let!(:user) { create(:user, email: 'test@example.com', password:) }
  let!(:user_setting) { create(:user_setting, user:) }
  let!(:user_review_settings) { create(:user_review_setting_with_additional_user_review_settings, user:) }

  def update_user_setting(review_days, mail_receive, line_receive)
    str_review_days = review_days.map { |review_day| review_day.to_s }

    visit user_setting_users_path
    4.times do |i|
      fill_in "user_user_review_settings_attributes_#{i}_review_days", with: str_review_days[i]
    end
    choose mail_receive
    choose line_receive
    click_button '更新'
  end

  def assert_values(user, review_days, bool_mail_receive, bool_line_receive)
    updated_user_setting = UserSetting.find_by(user:)
    updated_user_review_settings = UserReviewSetting.where(user:).order(:review_number)

    4.times do |i|
      expect(updated_user_review_settings[i].review_days).to eq review_days[i]
    end
    expect(updated_user_setting.mail_receive?).to be bool_mail_receive
    expect(updated_user_setting.line_receive?).to be bool_line_receive
  end

  before do
    create_init_data
  end

  describe '設定ページ' do
    context 'ログインしていない場合' do
      it 'ページが表示されないこと' do
        visit user_setting_users_path

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end
    end

    context 'ログインしている場合' do
      it 'ユーザー設定、復習設定が表示されること' do
        spec_login(user.email, password)
        visit user_setting_users_path

        4.times do |i|
          expect(find("#user_user_review_settings_attributes_#{i}_review_days").value).to eq user.user_review_settings.order(:review_number)[i].review_days.to_s
        end

        mail_radio_id = if user.user_setting.mail_receive?
                          '#mail_receive'
                        else
                          '#mail_not_receive'
                        end
        expect(find(mail_radio_id).checked?).to be true

        line_radio_id = if user.user_setting.line_receive?
                          '#line_receive'
                        else
                          '#line_not_receive'
                        end
        expect(find(line_radio_id).checked?).to be true

        browser_radio_id = if user.user_setting.browser_receive?
                             '#browser_receive'
                           else
                             '#browser_not_receive'
                           end
        expect(find(browser_radio_id).checked?).to be true
      end
    end

    describe '更新' do
      before do
        spec_login(user.email, password)
      end

      context '正しい値を入力した場合' do
        it 'ユーザー設定、復習設定が更新されること' do
          review_days = [51, 52, 53, 54]
          update_user_setting(review_days, 'mail_receive', 'line_receive')

          expect(page).to have_content 'ユーザー設定を更新しました'
          assert_values(user, review_days, true, true)
        end
      end

      describe '復習期間' do
        before do
          old_review_days = user.user_review_settings.order(:review_number).pluck(:review_days)
        end

        context '未入力の場合' do
          it '更新されないこと' do
            4.times do |i|
              review_days = [51, 52, 53, 54]
              review_days[i] = nil
              update_user_setting(review_days, 'mail_receive', 'line_receive')

              expect(page).to have_content '復習日数を入力してください'
              expect(page).to have_content 'ユーザー設定更新に失敗しました'
              assert_values(user, old_review_days, user_setting.mail_receive?, user_setting.line_receive?)
            end
          end
        end

        context '0の場合' do
          it '更新されないこと' do
            4.times do |i|
              review_days = [51, 52, 53, 54]
              review_days[i] = 0
              update_user_setting(review_days, 'mail_receive', 'line_receive')

              assert_values(user, old_review_days, user_setting.mail_receive?, user_setting.line_receive?)
            end
          end
        end

        context '1の場合' do
          it '更新されること' do
            4.times do |i|
              review_days = [51, 52, 53, 54]
              review_days[i] = 1
              update_user_setting(review_days, 'mail_receive', 'line_receive')

              expect(page).to have_content 'ユーザー設定を更新しました'
              assert_values(user, review_days, true, true)
            end
          end
        end

        context '99の場合' do
          it '更新されること' do
            4.times do |i|
              review_days = [51, 52, 53, 54]
              review_days[i] = 99
              update_user_setting(review_days, 'mail_receive', 'line_receive')

              expect(page).to have_content 'ユーザー設定を更新しました'
              assert_values(user, review_days, true, true)
            end
          end
        end

        context '100の場合' do
          it '更新されないこと' do
            4.times do |i|
              review_days = [51, 52, 53, 54]
              review_days[i] = 100
              update_user_setting(review_days, 'mail_receive', 'line_receive')

              assert_values(user, old_review_days, user_setting.mail_receive?, user_setting.line_receive?)
            end
          end
        end
      end
    end
  end
end
