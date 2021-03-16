class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.references :category, index: true, foreign_key: true
      t.references :author, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end