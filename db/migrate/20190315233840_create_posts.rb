class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :category_id
      t.string :image
      t.string :author

      t.timestamps
    end
  end
end
