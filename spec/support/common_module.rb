module CommonModule
  def create_init_data
    create(:document_with_additional_documents)
    create(:system_review_setting_with_additional_system_review_settings)
    create(:system_setting_with_additional_system_settings)
  end

  def spec_login(email, password)
    visit login_path
    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: password
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました'
  end
end