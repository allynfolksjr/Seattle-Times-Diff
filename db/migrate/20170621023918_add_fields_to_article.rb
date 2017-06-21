class AddFieldsToArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :updated, :boolean, default: false
    add_column :articles, :first_appearance, :boolean, default: false
  end
end
