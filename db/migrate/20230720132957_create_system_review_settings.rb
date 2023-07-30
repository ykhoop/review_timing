class CreateSystemReviewSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :system_review_settings do |t|
      t.integer :review_number
      t.integer :review_days

      t.timestamps
    end
  end
end
