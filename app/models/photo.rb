class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  
  skip_callback :destroy, :after, :remove_image!
  
  attr_accessible :description, :image, :name, :location_id
  mount_uploader :image, ImageUploader

end
