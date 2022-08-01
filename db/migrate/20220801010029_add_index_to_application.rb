class AddIndexToApplication < ActiveRecord::Migration[5.2]
  def change
    add_index :applications, :access_token
  end
end
