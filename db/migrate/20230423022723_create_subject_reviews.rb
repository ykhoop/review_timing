class CreateSubjectReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :subject_reviews do |t|
      t.references :subject_detail, null: false, foreign_key: true
      t.integer :review_type, null: false
      t.integer :review_number, null: false
      t.datetime :review_at

      t.timestamps
    end
  end
end
