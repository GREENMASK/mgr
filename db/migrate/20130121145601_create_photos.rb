class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :name
      t.text :description
      t.string :image
      t.integer :user_id
      t.integer :location_id
      
      t.timestamps
    end
  end
end
