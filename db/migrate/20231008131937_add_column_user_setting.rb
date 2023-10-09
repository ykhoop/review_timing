class AddColumnUserSetting < ActiveRecord::Migration[7.0]
  def change
    add_column :user_settings, :max_subjects, :integer, null: false, default: 0
    add_column :user_settings, :max_subject_details, :integer, null: false, default: 0
  end
end
