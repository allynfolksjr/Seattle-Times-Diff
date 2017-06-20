class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :guid
      t.string :title
      t.string :description
      t.integer :author_id

      t.timestamps
    end
    add_index :articles, :guid
    add_index :articles, :author_id
  end
end
