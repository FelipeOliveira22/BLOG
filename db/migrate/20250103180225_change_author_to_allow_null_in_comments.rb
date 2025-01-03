class ChangeAuthorToAllowNullInComments < ActiveRecord::Migration[8.0]
  def change
    change_column_null :comments, :author, true
  end
end
