class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :code
      t.string :description
      t.text :content

      t.timestamps
    end
  end
end
