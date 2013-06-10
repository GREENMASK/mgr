class Photo < ActiveRecord::Base

  belongs_to :user
  belongs_to :location
  skip_callback :destroy, :after, :remove_image!
  
  attr_accessible :description, :image, :name, :location_id,:public_status
  mount_uploader :image, ImageUploader
  
  validates :name,    presence: true
  validates :image,    presence: true
  validates :description,    presence: true
  validates :location_id,    presence: true 
end
