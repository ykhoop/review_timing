class CreateSystemSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :system_settings do |t|
      t.string :code, null: false
      t.string :description, null: false
      t.integer :int_value
      t.string :str_value
      t.text :text_value

      t.timestamps
    end
  end
end
