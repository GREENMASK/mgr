class AddPublicStatusToPhotos < ActiveRecord::Migration
  using(:shard_1)
  def up
    add_column :photos, :public_status, :boolean, :default => true
  end
  
  def down
    remove_column :photos, :public_status
  end
end
