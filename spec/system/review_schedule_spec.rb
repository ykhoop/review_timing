require 'rails_helper'

RSpec.describe 'ReviewSchedule', type: :system do
  password = 'Password1'
  ym = Time.zone.now.strftime('%Y%m')
  let!(:user) { create(:user, email: 'test@example.com', password:) }
  let!(:subject) { create(:subject, user:, title: 'User科目') }
  let!(:subject_detail) { create(:subject_detail, subject:, chapter: 'User章') }
  let!(:subject_review) { create(:subject_review_with_additional_subject_reviews, subject_detail:) }
  let!(:other_user) { create(:user, email: 'other_test@example.com', password:) }
  let!(:other_subject) { create(:subject, user: other_user, title: 'OtherUser科目') }

  before do
    create_init_data
  end

  describe '復習スケジュールページ' do
    context 'ログインしていない場合' do
      it 'ページが表示されないこと' do
        visit review_schedule_users_path(ym)

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end
    end

    context 'ログインしている場合' do
      before do
        spec_login(user.email, password)
        visit review_schedule_users_path(ym)
      end

      it 'ユーザーの復習スケジュールが表示されること' do
        expect(page).to have_content subject.title
        expect(page).to have_content subject_detail.chapter
      end

      it '開始ページ・終了ページが表示されること' do
        value = find('tbody tr:first-child td:nth-child(3)').text
        expect(value).to eq subject_detail.start_page.to_s
        value = find('tbody tr:first-child td:nth-child(5)').text
        expect(value).to eq subject_detail.end_page.to_s
      end

      it '学習開始日が表示されること' do
        start_at_ym = subject_detail.start_at.strftime('%Y%m')
        start_at_d = subject_detail.start_at.strftime('%d')
        td_child_number = start_at_d.to_i + 5

        visit review_schedule_users_path(start_at_ym)
        value = find("tbody tr:first-child td:nth-child(#{td_child_number})").text
        expect(value).to eq('S')
      end

      it '復習予定日が表示されること' do
        4.times do |n|
          review_at_ym = subject_detail.subject_reviews[n].review_at.strftime('%Y%m')
          review_at_d = subject_detail.subject_reviews[n].review_at.strftime('%d')
          td_child_number = review_at_d.to_i + 5

          visit review_schedule_users_path(review_at_ym)
          value = find("tbody tr:first-child td:nth-child(#{td_child_number})").text
          expect(value).to eq("R#{n + 1}")
        end
      end

      it '他ユーザーの復習スケジュールが表示されないこと' do
        expect(page).not_to have_content other_subject.title
      end

      describe 'リンク' do
        context '前月ボタンを押した場合' do
          it '前月の復習スケジュールページに遷移すること' do
            last_month_ym = (Time.zone.now - 1.month).strftime('%Y%m')
            click_link '前月'

            expect(page).to have_current_path(review_schedule_users_path(last_month_ym))
          end
        end

        context '次月ボタンを押した場合' do
          it '次月の復習スケジュールページに遷移すること' do
            next_month_ym = (Time.zone.now + 1.month).strftime('%Y%m')
            click_link '次月'

            expect(page).to have_current_path(review_schedule_users_path(next_month_ym))
          end
        end
      end
    end
  end
end
