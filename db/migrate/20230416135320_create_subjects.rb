class CreateSubjects < ActiveRecord::Migration[7.0]
  def change
    create_table :subjects do |t|
      t.string :title, null: false
      t.datetime :start_at
      t.datetime :limit_at
      t.text :memo
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
