require 'rails_helper'

RSpec.describe 'Subjects', type: :system do
  password = 'Password1'
  let!(:user) { create(:user, email: 'test@example.com', password:) }
  let!(:user_setting) { create(:user_setting, user:) }
  let!(:user_review_settings) { create(:user_review_setting_with_additional_user_review_settings, user:) }
  let!(:subject) { create(:subject, user:, title: 'User科目') }
  let!(:other_user) { create(:user, email: 'other_test@example.com', password:) }
  let!(:other_user_setting) { create(:user_setting, user: other_user) }
  let!(:other_user_review_settings) do
    create(:user_review_setting_with_additional_user_review_settings, user: other_user)
  end
  let!(:other_subject) { create(:subject, user: other_user, title: 'OtherUser科目') }

  def set_fields(title, start_at, limit_at, memo)
    fill_in 'タイトル', with: title unless title.nil?
    page.execute_script("document.querySelector('#subject_start_at').value = '#{start_at}';") unless start_at.nil?
    page.execute_script("document.querySelector('#subject_limit_at').value = '#{limit_at}';") unless limit_at.nil?
    fill_in 'メモ', with: memo unless memo.nil?
  end

  def assert_fields(subject, title, start_at, limit_at, memo)
    expect(subject.title).to eq title unless title.nil?
    expect(subject.start_at.strftime('%Y-%m-%dT%H:%M')).to eq start_at unless start_at.nil?
    expect(subject.limit_at.strftime('%Y-%m-%dT%H:%M')).to eq limit_at unless limit_at.nil?
    expect(subject.memo).to eq memo unless memo.nil?
  end

  before do
    create_init_data
  end

  describe '科目一覧ページ' do
    context 'ログインしていない場合' do
      it 'ページが表示されないこと' do
        visit subjects_path

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end
    end

    context 'ログインしている場合' do
      before do
        spec_login(user.email, password)
        visit subjects_path
      end

      it 'ユーザーの科目一覧が表示されること' do
        expect(page).to have_content subject.title
        expect(page).to have_content I18n.ln(subject.start_at)
        expect(page).to have_content I18n.ln(subject.limit_at)
      end

      it '他のユーザーの科目一覧が表示されないこと' do
        expect(page).not_to have_content other_subject.title
      end

      describe 'リンク' do
        context '科目追加ボタンを押した場合' do
          it '科目追加ページに遷移すること' do
            click_link '追加'
            page_title = find(:xpath, '//h3[text()="科目作成"]', wait: 10)

            expect(page_title).to be_truthy
            expect(current_path).to eq new_subject_path
          end
        end

        context '編集ボタンを押した場合' do
          it '科目編集ページに遷移すること' do
            click_link '編集', href: edit_subject_path(subject)
            page_title = find(:xpath, '//h3[text()="科目編集"]', wait: 10)

            expect(page_title).to be_truthy
            expect(current_path).to eq edit_subject_path(subject)
          end
        end

        context '詳細ボタンを押した場合' do
          it '科目詳細ページに遷移すること' do
            click_link '詳細', href: subject_subject_details_path(subject)
            page_title = find(:xpath, '//h3[text()="科目詳細一覧"]', wait: 10)

            expect(page_title).to be_truthy
            expect(current_path).to eq subject_subject_details_path(subject)
          end
        end

        context '削除ボタンを押した場合' do
          it '科目が削除されること' do
            click_link '削除', href: subject_path(subject)
            page.driver.browser.switch_to.alert.accept

            expect(page).to have_content "科目 #{subject.title} を削除しました"
            expect(page).to have_content '科目がありません'
          end
        end
      end
    end
  end

  describe '科目作成ページ' do
    context 'ログインしていない場合' do
      it 'ページが表示されないこと' do
        visit new_subject_path

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end
    end

    context 'ログインしている場合' do
      before do
        spec_login(user.email, password)
      end

      describe '追加' do
        context '正しい値を入力し、追加した場合' do
          it '科目が追加されること' do
            title = 'あ'
            start_at = '2020-01-02T03:04'
            limit_at = '2021-02-03T04:05'
            memo = 'あ'

            visit new_subject_path
            set_fields(title, start_at, limit_at, memo)
            click_button '登録'

            expect(page).to have_content '科目を作成しました'
            expect(current_path).to eq subjects_path

            added_subject = Subject.where(user:).order(:id).last
            assert_fields(added_subject, title, start_at, limit_at, memo)
          end
        end

        describe 'バリデーション' do
          describe 'タイトル' do
            context '未入力の場合' do
              it '科目が追加されないこと' do
                title = ''
                start_at = '2020-01-02T03:04'
                limit_at = '2021-02-03T04:05'
                memo = 'あ'

                visit new_subject_path
                set_fields(title, start_at, limit_at, memo)
                click_button '登録'

                expect(page).to have_content 'タイトルを入力してください'
                expect(page).to have_content '科目作成に失敗しました'
                expect(current_path).to eq new_subject_path

                added_subject = Subject.find_by(user:, title:)
                expect(added_subject).to be_falsey
              end
            end

            context '255文字の場合' do
              it '科目が追加されること' do
                title = 'あ' * 255
                start_at = '2020-01-02T03:04'
                limit_at = '2021-02-03T04:05'
                memo = 'あ'

                visit new_subject_path
                set_fields(title, start_at, limit_at, memo)
                click_button '登録'

                expect(page).to have_content '科目を作成しました'
                expect(current_path).to eq subjects_path

                added_subject = Subject.where(user:).order(:id).last
                assert_fields(added_subject, title, start_at, limit_at, memo)
              end
            end

            context '256文字の場合' do
              it '科目が追加されないこと' do
                title = 'あ' * 256
                start_at = '2020-01-02T03:04'
                limit_at = '2021-02-03T04:05'
                memo = 'あ'

                visit new_subject_path
                set_fields(title, start_at, limit_at, memo)
                click_button '登録'

                expect(page).to have_content 'タイトルは255文字以内で入力してください'
                expect(page).to have_content '科目作成に失敗しました'
                expect(current_path).to eq new_subject_path

                added_subject = Subject.find_by(user:, title:)
                expect(added_subject).to be_falsey
              end
            end
          end

          describe 'メモ' do
            context '20,000文字の場合' do
              it '科目が追加されること' do
                title = 'あ'
                start_at = '2020-01-02T03:04'
                limit_at = '2021-02-03T04:05'
                memo = 'あ' * 20_000

                visit new_subject_path
                set_fields(title, start_at, limit_at, memo)
                click_button '登録'

                expect(page).to have_content '科目を作成しました'
                expect(current_path).to eq subjects_path

                added_subject = Subject.where(user:).order(:id).last
                assert_fields(added_subject, title, start_at, limit_at, memo)
              end
            end

            context '20,001文字の場合' do
              it '科目が追加されないこと' do
                title = 'あ'
                start_at = '2020-01-02T03:04'
                limit_at = '2021-02-03T04:05'
                memo = 'あ' * 20_001

                visit new_subject_path
                set_fields(title, start_at, limit_at, memo)
                click_button '登録'

                expect(page).to have_content 'メモは20000文字以内で入力してください'
                expect(page).to have_content '科目作成に失敗しました'
                expect(current_path).to eq new_subject_path

                added_subject = Subject.find_by(user:, title:)
                expect(added_subject).to be_falsey
              end
            end
          end
        end

        context '戻るボタンをクリックした場合' do
          it '科目が追加されないこと' do
            title = 'あ'
            start_at = '2020-01-02T03:04'
            limit_at = '2021-02-03T04:05'
            memo = 'あ'

            visit new_subject_path
            set_fields(title, start_at, limit_at, memo)
            click_link '戻る'

            expect(page).not_to have_content '科目を作成しました'
            expect(page).to have_current_path(subjects_path)

            added_subject = Subject.find_by(user:, title:)
            expect(added_subject).to be_falsey
          end
        end
      end
    end
  end

  describe '科目編集ページ' do
    context 'ログインしていない場合' do
      it 'ページが表示されないこと' do
        visit edit_subject_path(subject)

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end
    end

    context 'ログインしている場合' do
      before do
        spec_login(user.email, password)
      end

      it 'ユーザーの科目編集が表示されること' do
        visit edit_subject_path(subject)

        expect(find('#subject_title').value).to eq subject.title
        expect(find('#subject_start_at').value).to eq I18n.ln(subject.start_at, format: :custom)
        expect(find('#subject_limit_at').value).to eq I18n.ln(subject.limit_at, format: :custom)
        expect(find('#subject_memo').value).to eq subject.memo
      end

      it '他のユーザーの科目編集が表示されないこと' do
        visit edit_subject_path(other_subject)

        expect(page).to have_content 'ログインしてください'
      end

      describe '更新' do
        context '正しい値を入力し、更新した場合' do
          it '科目が更新されること' do
            title = 'あ'
            start_at = nil
            limit_at = nil
            memo = 'あ'

            visit edit_subject_path(subject)
            set_fields(title, start_at, limit_at, memo)
            click_button '更新'

            expect(page).to have_content '科目を更新しました'
            expect(current_path).to eq subjects_path

            updated_subject = Subject.find(subject.id)
            assert_fields(updated_subject, title, start_at, limit_at, memo)
          end
        end

        describe 'バリデーション' do
          describe 'タイトル' do
            context '未入力の場合' do
              it '科目が更新されないこと' do
                title = ''
                start_at = nil
                limit_at = nil
                memo = 'あ'

                visit edit_subject_path(subject)
                set_fields(title, start_at, limit_at, memo)
                click_button '更新'

                expect(page).to have_content 'タイトルを入力してください'
                expect(page).to have_content '科目更新に失敗しました'
                expect(current_path).to eq edit_subject_path(subject)

                updated_subject = Subject.find(subject.id)
                expect(updated_subject.title).to eq subject.title
              end
            end

            context '255文字の場合' do
              it '科目が更新されること' do
                title = 'あ' * 255
                start_at = nil
                limit_at = nil
                memo = 'あ'

                visit edit_subject_path(subject)
                set_fields(title, start_at, limit_at, memo)
                click_button '更新'

                expect(page).to have_content '科目を更新しました'
                expect(current_path).to eq subjects_path

                updated_subject = Subject.find(subject.id)
                assert_fields(updated_subject, title, start_at, limit_at, memo)
              end
            end

            context '256文字の場合' do
              it '科目が更新されないこと' do
                title = 'あ' * 256
                start_at = nil
                limit_at = nil
                memo = 'あ'

                visit edit_subject_path(subject)
                set_fields(title, start_at, limit_at, memo)
                click_button '更新'

                expect(page).to have_content 'タイトルは255文字以内で入力してください'
                expect(page).to have_content '科目更新に失敗しました'
                expect(current_path).to eq edit_subject_path(subject)

                updated_subject = Subject.find(subject.id)
                expect(updated_subject.title).to eq subject.title
              end
            end
          end

          describe 'メモ' do
            context '20,000文字の場合' do
              it '科目が更新されること' do
                title = 'あ'
                start_at = nil
                limit_at = nil
                memo = 'あ' * 20_000

                visit edit_subject_path(subject)
                set_fields(title, start_at, limit_at, memo)
                click_button '更新'

                expect(page).to have_content '科目を更新しました'
                expect(current_path).to eq subjects_path

                updated_subject = Subject.find(subject.id)
                assert_fields(updated_subject, title, start_at, limit_at, memo)
              end
            end

            context '20,001文字の場合' do
              it '科目が更新されないこと' do
                title = 'あ'
                start_at = nil
                limit_at = nil
                memo = 'あ' * 20_001

                visit edit_subject_path(subject)
                set_fields(title, start_at, limit_at, memo)
                click_button '更新'

                expect(page).to have_content 'メモは20000文字以内で入力してください'
                expect(page).to have_content '科目更新に失敗しました'
                expect(current_path).to eq edit_subject_path(subject)

                updated_subject = Subject.find(subject.id)
                expect(updated_subject.title).to eq subject.title
              end
            end
          end
        end

        context '戻るボタンをクリックした場合' do
          it '科目が更新されないこと' do
            title = '更新科目'
            start_at = nil
            limit_at = nil
            memo = '更新メモ'

            visit edit_subject_path(subject)
            set_fields(title, start_at, limit_at, memo)
            click_link '戻る'

            expect(page).not_to have_content '科目を更新しました'
            expect(page).to have_current_path(subjects_path)

            updated_subject = Subject.find(subject.id)
            expect(updated_subject.title).to eq subject.title
          end
        end
      end
    end
  end
end
