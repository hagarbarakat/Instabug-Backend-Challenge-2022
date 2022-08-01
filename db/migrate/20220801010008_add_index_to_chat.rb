class AddIndexToChat < ActiveRecord::Migration[5.2]
  def change
    add_index :chats, :number
  end
end
