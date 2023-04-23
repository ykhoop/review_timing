class CreateSubjectDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :subject_details do |t|
      t.references :subject, null: false, foreign_key: true
      t.string :chapter
      t.integer :start_page
      t.integer :end_page
      t.datetime :start_at, null: false

      t.timestamps
    end
  end
end
