class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.integer :log_level, null: false
      t.string :program, null: false
      t.text :log_content, null: false

      t.timestamps
    end
  end
end
