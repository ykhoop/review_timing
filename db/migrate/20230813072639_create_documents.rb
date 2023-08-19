class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :code, null: false
      t.string :description, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
