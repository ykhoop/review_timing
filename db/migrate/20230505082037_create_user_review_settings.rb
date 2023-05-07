class CreateUserReviewSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :user_review_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :review_number, null: false
      t.integer :review_days, null: false

      t.timestamps
    end
  end
end
