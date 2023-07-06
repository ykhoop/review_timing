class CreateUserSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :user_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :remind_mail, null: false, default: false
      t.boolean :remind_line, null: false, default: false
      t.boolean :remind_browser, null: false, default: false

      t.timestamps
    end
  end
end
