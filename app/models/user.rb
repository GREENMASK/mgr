class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  has_many :locations
  has_many :photos
  
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  def location_exist?(name)
    object = self.locations.find_by_name(name)
    object.nil? ? true : false
  end

  def self.destroy_all(user)
    User.transaction do 
      user.locations.destroy_all
      user.photos.destroy_all
      user.destroy
      false
    end
  end
end
