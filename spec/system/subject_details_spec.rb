require 'rails_helper'

RSpec.describe 'SubjectDetails', type: :system do
  password = 'Password1'
  let!(:user) { create(:user, email: 'test@example.com', password:) }
  let!(:user_review_settings) { create(:user_review_setting_with_additional_user_review_settings, user:) }
  let!(:subject) { create(:subject, user:, title: 'User科目') }
  let!(:subject_detail) { create(:subject_detail, subject:, chapter: 'User章') }
  let!(:subject_review) { create(:subject_review_with_additional_subject_reviews, subject_detail:) }
  let!(:other_user) { create(:user, email: 'other_test@example.com', password:) }
  let!(:other_subject) { create(:subject, user: other_user, title: 'OtherUser科目') }
  let!(:other_subject_detail) { create(:subject_detail, subject: other_subject, chapter: 'OtherUser章') }
  let!(:other_subject_review) do
    create(:subject_review_with_additional_subject_reviews, subject_detail: other_subject_detail)
  end

  def set_fields(chapter, start_page, end_page, start_at)
    fill_in '章', with: chapter unless chapter.nil?
    fill_in '開始ページ', with: start_page unless start_page.nil?
    fill_in '終了ページ', with: end_page unless end_page.nil?
    page.execute_script("document.querySelector('#subject_detail_start_at').value = '#{start_at}';") unless start_at.nil?
  end

  def assert_fields(subject_detail, chapter, start_page, end_page, start_at)
    expect(subject_detail.chapter).to eq chapter unless chapter.nil?
    expect(subject_detail.start_page.to_s).to eq start_page unless start_page.nil?
    expect(subject_detail.end_page.to_s).to eq end_page unless end_page.nil?
    expect(subject_detail.start_at.strftime('%Y-%m-%dT%H:%M')).to eq start_at unless start_at.nil?
  end

  before do
    create_init_data
  end

  describe '科目詳細一覧ページ' do
    context 'ログインしていない場合' do
      it 'ページが表示されないこと' do
        visit subject_subject_details_path(subject)

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end
    end

    context 'ログインしている場合' do
      before do
        spec_login(user.email, password)
      end

      it 'ユーザーの科目詳細一覧が表示されること' do
        visit subject_subject_details_path(subject)

        expect(page).to have_content subject_detail.chapter
        expect(page).to have_content subject_detail.start_page
        expect(page).to have_content subject_detail.end_page
        expect(page).to have_content I18n.ln(subject.start_at)
      end

      it '他のユーザーの科目詳細一覧が表示されないこと' do
        visit subject_subject_details_path(subject)

        expect(page).not_to have_content other_subject_detail.chapter
      end

      it '他のユーザーの科目詳細一覧にアクセスできないこと' do
        visit subject_subject_details_path(other_subject)

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end

      describe 'リンク' do
        before do
          visit subject_subject_details_path(subject)
        end

        context '科目詳細追加ボタンを押した場合' do
          it '科目詳細追加ページに遷移すること' do
            click_link '追加'
            page_title = find(:xpath, '//h3[text()="科目詳細作成"]', wait: 10)

            expect(page_title).to be_truthy
            expect(current_path).to eq new_subject_subject_detail_path(subject)
          end
        end

        context '戻るボタンを押した場合' do
          it '科目一覧ページに遷移すること' do
            click_link '戻る'
            page_title = find(:xpath, '//h3[text()="科目一覧"]', wait: 10)

            expect(page_title).to be_truthy
            expect(current_path).to eq subjects_path
          end
        end

        context '編集ボタンを押した場合' do
          it '科目詳細編集ページに遷移すること' do
            click_link '編集', href: edit_subject_detail_path(subject_detail)
            page_title = find(:xpath, '//h3[text()="科目詳細編集"]', wait: 10)

            expect(page_title).to be_truthy
            expect(current_path).to eq edit_subject_detail_path(subject_detail)
          end
        end

        context '復習時間ボタンを押した場合' do
          it '復習時間ページに遷移すること' do
            click_link '復習時間', href: review_time_subject_detail_path(subject_detail)
            page_title = find(:xpath, '//h3[text()="復習時間"]', wait: 10)

            expect(page_title).to be_truthy
            expect(current_path).to eq review_time_subject_detail_path(subject_detail)
          end
        end

        context '削除ボタンを押した場合' do
          it '科目詳細が削除されること' do
            click_link '削除', href: subject_detail_path(subject_detail)
            page.driver.browser.switch_to.alert.accept

            expect(page).to have_content "科目詳細 #{subject_detail.chapter} を削除しました"
            expect(page).to have_content '科目詳細がありません'
          end
        end
      end
    end
  end

  describe '科目詳細作成ページ' do
    context 'ログインしていない場合' do
      it 'ページが表示されないこと' do
        visit new_subject_subject_detail_path(subject)

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end
    end

    context 'ログインしている場合' do
      before do
        spec_login(user.email, password)
      end

      it '他のユーザーの科目詳細作成ページにアクセスできないこと' do
        visit new_subject_subject_detail_path(other_subject)

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end

      describe '追加' do
        context '正しい値を入力し、追加した場合' do
          it '科目詳細が追加されること' do
            chapter = 'あ'
            start_page = '1'
            end_page = '1'
            start_at = '2020-01-02T03:04'

            visit new_subject_subject_detail_path(subject)
            set_fields(chapter, start_page, end_page, start_at)
            click_button '登録'

            expect(page).to have_content '科目詳細を作成しました'
            expect(current_path).to eq subject_subject_details_path(subject)

            added_subject_detail = SubjectDetail.where(subject:).last
            assert_fields(added_subject_detail, chapter, start_page, end_page, start_at)
          end
        end

        describe 'バリデーション' do
          describe '章' do
            context '未入力の場合' do
              it '科目詳細が追加されないこと' do
                chapter = ''
                start_page = '1'
                end_page = '1'
                start_at = '2020-01-02T03:04'

                visit new_subject_subject_detail_path(subject)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '登録'

                expect(page).to have_content '章を入力してください'
                expect(page).to have_content '科目詳細作成に失敗しました'
                expect(current_path).to eq new_subject_subject_detail_path(subject)

                added_subject_detail = SubjectDetail.find_by(subject:, chapter:)
                expect(added_subject_detail).to be_falsey
              end
            end

            context '255文字の場合' do
              it '科目詳細が追加されること' do
                chapter = 'あ' * 255
                start_page = '1'
                end_page = '1'
                start_at = '2020-01-02T03:04'

                visit new_subject_subject_detail_path(subject)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '登録'

                expect(page).to have_content '科目詳細を作成しました'
                visit subject_subject_details_path(subject)

                added_subject_detail = SubjectDetail.where(subject:).last
                assert_fields(added_subject_detail, chapter, start_page, end_page, start_at)
              end
            end

            context '256文字の場合' do
              it '科目詳細が追加されないこと' do
                chapter = 'あ' * 256
                start_page = '1'
                end_page = '1'
                start_at = '2020-01-02T03:04'

                visit new_subject_subject_detail_path(subject)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '登録'

                expect(page).to have_content '章は255文字以内で入力してください'
                expect(page).to have_content '科目詳細作成に失敗しました'
                expect(current_path).to eq new_subject_subject_detail_path(subject)

                added_subject_detail = SubjectDetail.find_by(subject:, chapter:)
                expect(added_subject_detail).to be_falsey
              end
            end
          end

          describe '開始ページ' do
            context '未入力の場合' do
              it '科目詳細が追加されないこと' do
                chapter = 'あ'
                start_page = ''
                end_page = '1'
                start_at = '2020-01-02T03:04'

                visit new_subject_subject_detail_path(subject)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '登録'

                expect(page).to have_content '開始ページは数値で入力してください'
                expect(page).to have_content '科目詳細作成に失敗しました'
                expect(current_path).to eq new_subject_subject_detail_path(subject)

                added_subject_detail = SubjectDetail.find_by(subject:, chapter:)
                expect(added_subject_detail).to be_falsey
              end
            end

            context '0の場合' do
              it '科目詳細が追加されないこと' do
                chapter = 'あ'
                start_page = '0'
                end_page = '1'
                start_at = '2020-01-02T03:04'

                visit new_subject_subject_detail_path(subject)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '登録'

                expect(page).to have_content '開始ページは 1 ～ 10000 の値を入力してください'
                expect(page).to have_content '科目詳細作成に失敗しました'
                expect(current_path).to eq new_subject_subject_detail_path(subject)

                added_subject_detail = SubjectDetail.find_by(subject:, chapter:)
                expect(added_subject_detail).to be_falsey
              end
            end

            context '10000の場合' do
              it '科目詳細が追加されること' do
                chapter = 'あ'
                start_page = '10000'
                end_page = '1'
                start_at = '2020-01-02T03:04'

                visit new_subject_subject_detail_path(subject)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '登録'

                expect(page).to have_content '科目詳細を作成しました'
                visit subject_subject_details_path(subject)

                added_subject_detail = SubjectDetail.where(subject:).last
                assert_fields(added_subject_detail, chapter, start_page, end_page, start_at)
              end
            end

            context '10001の場合' do
              it '科目詳細が追加されないこと' do
                chapter = 'あ'
                start_page = '10001'
                end_page = '1'
                start_at = '2020-01-02T03:04'

                visit new_subject_subject_detail_path(subject)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '登録'

                expect(page).to have_content '開始ページは 1 ～ 10000 の値を入力してください'
                expect(page).to have_content '科目詳細作成に失敗しました'
                expect(current_path).to eq new_subject_subject_detail_path(subject)

                added_subject_detail = SubjectDetail.find_by(subject:, chapter:)
                expect(added_subject_detail).to be_falsey
              end
            end
          end

          describe '終了ページ' do
            context '未入力の場合' do
              it '科目詳細が追加されないこと' do
                chapter = 'あ'
                start_page = '1'
                end_page = ''
                start_at = '2020-01-02T03:04'

                visit new_subject_subject_detail_path(subject)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '登録'

                expect(page).to have_content '終了ページは数値で入力してください'
                expect(page).to have_content '科目詳細作成に失敗しました'
                expect(current_path).to eq new_subject_subject_detail_path(subject)

                added_subject_detail = SubjectDetail.find_by(subject:, chapter:)
                expect(added_subject_detail).to be_falsey
              end
            end

            context '0の場合' do
              it '科目詳細が追加されないこと' do
                chapter = 'あ'
                start_page = '1'
                end_page = '0'
                start_at = '2020-01-02T03:04'

                visit new_subject_subject_detail_path(subject)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '登録'

                expect(page).to have_content '終了ページは 1 ～ 10000 の値を入力してください'
                expect(page).to have_content '科目詳細作成に失敗しました'
                expect(current_path).to eq new_subject_subject_detail_path(subject)

                added_subject_detail = SubjectDetail.find_by(subject:, chapter:)
                expect(added_subject_detail).to be_falsey
              end
            end

            context '10000の場合' do
              it '科目詳細が追加されること' do
                chapter = 'あ'
                start_page = '1'
                end_page = '10000'
                start_at = '2020-01-02T03:04'

                visit new_subject_subject_detail_path(subject)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '登録'

                expect(page).to have_content '科目詳細を作成しました'
                visit subject_subject_details_path(subject)

                added_subject_detail = SubjectDetail.where(subject:).last
                assert_fields(added_subject_detail, chapter, start_page, end_page, start_at)
              end
            end

            context '10001の場合' do
              it '科目詳細が追加されないこと' do
                chapter = 'あ'
                start_page = '1'
                end_page = '10001'
                start_at = '2020-01-02T03:04'

                visit new_subject_subject_detail_path(subject)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '登録'

                expect(page).to have_content '終了ページは 1 ～ 10000 の値を入力してください'
                expect(page).to have_content '科目詳細作成に失敗しました'
                expect(current_path).to eq new_subject_subject_detail_path(subject)

                added_subject_detail = SubjectDetail.find_by(subject:, chapter:)
                expect(added_subject_detail).to be_falsey
              end
            end
          end

          describe '学習開始日時' do
            context '未入力の場合' do
              it '科目詳細が追加されないこと' do
                chapter = 'あ'
                start_page = '1'
                end_page = '1'
                start_at = ''

                visit new_subject_subject_detail_path(subject)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '登録'

                expect(page).to have_content '学習開始日時を入力してください'
                expect(page).to have_content '科目詳細作成に失敗しました'
                expect(current_path).to eq new_subject_subject_detail_path(subject)

                added_subject_detail = SubjectDetail.find_by(subject:, chapter:)
                expect(added_subject_detail).to be_falsey
              end
            end
          end
        end

        context '戻るボタンをクリックした場合' do
          it '科目詳細が追加されないこと' do
            chapter = 'あ'
            start_page = '1'
            end_page = '1'
            start_at = '2020-01-02T03:04'

            visit new_subject_subject_detail_path(subject)
            set_fields(chapter, start_page, end_page, start_at)
            click_link '戻る'

            expect(page).not_to have_content '科目詳細を作成しました'
            expect(page).to have_current_path(subject_subject_details_path(subject))

            added_subject_detail = SubjectDetail.find_by(subject:, chapter:)
            expect(added_subject_detail).to be_falsey
          end
        end
      end
    end
  end

  describe '科目詳細編集ページ' do
    context 'ログインしていない場合' do
      it 'ページが表示されないこと' do
        visit edit_subject_detail_path(subject_detail)

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end
    end

    context 'ログインしている場合' do
      before do
        spec_login(user.email, password)
      end

      it '他のユーザーの科目詳細編集ページにアクセスできないこと' do
        visit edit_subject_detail_path(other_subject_detail)

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end

      describe '更新' do
        context '正しい値を入力し、更新した場合' do
          it '科目詳細が更新されること' do
            chapter = 'あ'
            start_page = '1'
            end_page = '1'
            start_at = nil

            visit edit_subject_detail_path(subject_detail)
            set_fields(chapter, start_page, end_page, start_at)
            click_button '更新'

            expect(page).to have_content '科目詳細を更新しました'
            expect(current_path).to eq subject_subject_details_path(subject)

            updated_subject_detail = SubjectDetail.find(subject_detail.id)
            assert_fields(updated_subject_detail, chapter, start_page, end_page, start_at)
          end
        end

        describe 'バリデーション' do
          describe '章' do
            context '未入力の場合' do
              it '科目詳細が更新されないこと' do
                chapter = ''
                start_page = '1'
                end_page = '1'
                start_at = nil

                visit edit_subject_detail_path(subject_detail)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '更新'

                expect(page).to have_content '章を入力してください'
                expect(page).to have_content '科目詳細更新に失敗しました'
                expect(current_path).to eq edit_subject_detail_path(subject_detail)

                updated_subject_detail = SubjectDetail.find(subject_detail.id)
                expect(updated_subject_detail.chapter).to eq subject_detail.chapter
              end
            end

            context '255文字の場合' do
              it '科目詳細が更新されること' do
                chapter = 'あ' * 255
                start_page = '1'
                end_page = '1'
                start_at = nil

                visit edit_subject_detail_path(subject_detail)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '更新'

                expect(page).to have_content '科目詳細を更新しました'
                visit subject_subject_details_path(subject)

                updated_subject_detail = SubjectDetail.find(subject_detail.id)
                assert_fields(updated_subject_detail, chapter, start_page, end_page, start_at)
              end
            end

            context '256文字の場合' do
              it '科目詳細が更新されないこと' do
                chapter = 'あ' * 256
                start_page = '1'
                end_page = '1'
                start_at = nil

                visit edit_subject_detail_path(subject_detail)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '更新'

                expect(page).to have_content '章は255文字以内で入力してください'
                expect(page).to have_content '科目詳細更新に失敗しました'
                expect(current_path).to eq edit_subject_detail_path(subject_detail)

                updated_subject_detail = SubjectDetail.find(subject_detail.id)
                expect(updated_subject_detail.chapter).to eq subject_detail.chapter
              end
            end
          end

          describe '開始ページ' do
            context '未入力の場合' do
              it '科目詳細が更新されないこと' do
                chapter = 'あ'
                start_page = ''
                end_page = '1'
                start_at = nil

                visit edit_subject_detail_path(subject_detail)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '更新'

                expect(page).to have_content '開始ページは数値で入力してください'
                expect(page).to have_content '科目詳細更新に失敗しました'
                expect(current_path).to eq edit_subject_detail_path(subject_detail)

                updated_subject_detail = SubjectDetail.find(subject_detail.id)
                expect(updated_subject_detail.chapter).to eq subject_detail.chapter
              end
            end

            context '0の場合' do
              it '科目詳細が更新されないこと' do
                chapter = 'あ'
                start_page = '0'
                end_page = '1'
                start_at = nil

                visit edit_subject_detail_path(subject_detail)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '更新'

                expect(page).to have_content '開始ページは 1 ～ 10000 の値を入力してください'
                expect(page).to have_content '科目詳細更新に失敗しました'
                expect(current_path).to eq edit_subject_detail_path(subject_detail)

                updated_subject_detail = SubjectDetail.find(subject_detail.id)
                expect(updated_subject_detail.chapter).to eq subject_detail.chapter
              end
            end

            context '10000の場合' do
              it '科目詳細が更新されること' do
                chapter = 'あ'
                start_page = '10000'
                end_page = '1'
                start_at = nil

                visit edit_subject_detail_path(subject_detail)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '更新'

                expect(page).to have_content '科目詳細を更新しました'
                visit subject_subject_details_path(subject)

                updated_subject_detail = SubjectDetail.find(subject_detail.id)
                assert_fields(updated_subject_detail, chapter, start_page, end_page, start_at)
              end
            end

            context '10001の場合' do
              it '科目詳細が更新されないこと' do
                chapter = 'あ'
                start_page = '10001'
                end_page = '1'
                start_at = nil

                visit edit_subject_detail_path(subject_detail)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '更新'

                expect(page).to have_content '開始ページは 1 ～ 10000 の値を入力してください'
                expect(page).to have_content '科目詳細更新に失敗しました'
                expect(current_path).to eq edit_subject_detail_path(subject_detail)

                updated_subject_detail = SubjectDetail.find(subject_detail.id)
                expect(updated_subject_detail.chapter).to eq subject_detail.chapter
              end
            end
          end

          describe '終了ページ' do
            context '未入力の場合' do
              it '科目詳細が更新されないこと' do
                chapter = 'あ'
                start_page = '1'
                end_page = ''
                start_at = nil

                visit edit_subject_detail_path(subject_detail)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '更新'

                expect(page).to have_content '終了ページは数値で入力してください'
                expect(page).to have_content '科目詳細更新に失敗しました'
                expect(current_path).to eq edit_subject_detail_path(subject_detail)

                updated_subject_detail = SubjectDetail.find(subject_detail.id)
                expect(updated_subject_detail.chapter).to eq subject_detail.chapter
              end
            end

            context '0の場合' do
              it '科目詳細が更新されないこと' do
                chapter = 'あ'
                start_page = '1'
                end_page = '0'
                start_at = nil

                visit edit_subject_detail_path(subject_detail)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '更新'

                expect(page).to have_content '終了ページは 1 ～ 10000 の値を入力してください'
                expect(page).to have_content '科目詳細更新に失敗しました'
                expect(current_path).to eq edit_subject_detail_path(subject_detail)

                updated_subject_detail = SubjectDetail.find(subject_detail.id)
                expect(updated_subject_detail.chapter).to eq subject_detail.chapter
              end
            end

            context '10000の場合' do
              it '科目詳細が更新されること' do
                chapter = 'あ'
                start_page = '1'
                end_page = '10000'
                start_at = nil

                visit edit_subject_detail_path(subject_detail)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '更新'

                expect(page).to have_content '科目詳細を更新しました'
                visit subject_subject_details_path(subject)

                updated_subject_detail = SubjectDetail.find(subject_detail.id)
                assert_fields(updated_subject_detail, chapter, start_page, end_page, start_at)
              end
            end

            context '10001の場合' do
              it '科目詳細が更新されないこと' do
                chapter = 'あ'
                start_page = '1'
                end_page = '10001'
                start_at = nil

                visit edit_subject_detail_path(subject_detail)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '更新'

                expect(page).to have_content '終了ページは 1 ～ 10000 の値を入力してください'
                expect(page).to have_content '科目詳細更新に失敗しました'
                expect(current_path).to eq edit_subject_detail_path(subject_detail)

                updated_subject_detail = SubjectDetail.find(subject_detail.id)
                expect(updated_subject_detail.chapter).to eq subject_detail.chapter
              end
            end
          end

          describe '学習開始日時' do
            context '未入力の場合' do
              it '科目詳細が更新されないこと' do
                chapter = 'あ'
                start_page = '1'
                end_page = '1'
                start_at = ''

                visit edit_subject_detail_path(subject_detail)
                set_fields(chapter, start_page, end_page, start_at)
                click_button '更新'

                expect(page).to have_content '学習開始日時を入力してください'
                expect(page).to have_content '科目詳細更新に失敗しました'
                expect(current_path).to eq edit_subject_detail_path(subject_detail)

                updated_subject_detail = SubjectDetail.find(subject_detail.id)
                expect(updated_subject_detail.chapter).to eq subject_detail.chapter
              end
            end
          end
        end

        context '戻るボタンをクリックした場合' do
          it '科目詳細が追加されないこと' do
            chapter = 'あ'
            start_page = '1'
            end_page = '1'
            start_at = nil

            visit edit_subject_detail_path(subject_detail)
            set_fields(chapter, start_page, end_page, start_at)
            click_link '戻る'

            expect(page).not_to have_content '科目詳細を更新しました'
            expect(page).to have_current_path(subject_subject_details_path(subject))

            updated_subject_detail = SubjectDetail.find(subject_detail.id)
            expect(updated_subject_detail.chapter).to eq subject_detail.chapter
          end
        end
      end
    end
  end

  describe '復習時間ページ' do
    context 'ログインしていない場合' do
      it 'ページが表示されないこと' do
        visit review_time_subject_detail_path(subject_detail)

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end
    end

    context 'ログインしている場合' do
      before do
        spec_login(user.email, password)
      end

      it '他のユーザーの復習時間ページにアクセスできないこと' do
        visit review_time_subject_detail_path(other_subject_detail)

        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq login_path
      end

      context 'ページから科目詳細を作成した場合' do
        it '復習時間が作成されること' do
          chapter = '追加科目詳細'
          start_page = '1'
          end_page = '1'
          start_at = '2020-01-02T03:04'

          visit new_subject_subject_detail_path(subject)
          set_fields(chapter, start_page, end_page, start_at)
          click_button '登録'

          expect(page).to have_content '科目詳細を作成しました'
          expect(current_path).to eq subject_subject_details_path(subject)

          added_subject_detail = SubjectDetail.find_by(subject:, chapter:)
          expect(added_subject_detail.subject_reviews.count).to eq 8
        end
      end

      describe '更新' do
        context '正しい値を入力し、更新した場合' do
          it '復習時間が更新されること' do
            visit review_time_subject_detail_path(subject_detail)
            4.times do |i|
              fill_in "subject_detail[subject_reviews_attributes][#{i}][review_at]", with: ''
            end
            click_button '更新'

            expect(page).to have_content '復習時間を更新しました'
            expect(current_path).to eq subject_subject_details_path(subject)

            updated_subject_reviews_plan = subject_detail.subject_reviews.where(review_type: :plan)
            4.times do |i|
              expect(updated_subject_reviews_plan[i].review_at).to eq nil
            end
          end
        end

        context '戻るボタンをクリックした場合' do
          it '科目詳細が追加されないこと' do
            visit review_time_subject_detail_path(subject_detail)
            4.times do |i|
              fill_in "subject_detail[subject_reviews_attributes][#{i}][review_at]", with: ''
            end
            click_link '戻る'

            expect(page).not_to have_content '復習時間を更新しました'
            expect(page).to have_current_path(subject_subject_details_path(subject))

            updated_subject_reviews_plan = subject_detail.subject_reviews.where(review_type: :plan)
            4.times do |i|
              expect(updated_subject_reviews_plan[i].review_at).not_to eq nil
            end
          end
        end
      end
    end
  end
end
