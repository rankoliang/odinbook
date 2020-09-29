class RenameProfileDescriptionOfUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :profile_description, :summary
  end
end
