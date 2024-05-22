class AddTypeIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_reference :posts, :type, null: false, foreign_key: true
  end
end
