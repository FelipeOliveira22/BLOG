class AddSlugColumnToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :slug, :string, unique: true
  end
end
