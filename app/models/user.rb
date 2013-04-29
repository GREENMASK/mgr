class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  has_many :locations
  has_many :photos
  has_many :friendships
  has_many :friends, :through => :friendships 
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name,:second_name
  # attr_accessible :title, :body
  
  def location_exist?(name)
    object = self.locations.find_by_name(name)
    object.nil? ? true : false
  end
  # czy ma przyjaźń
  def self.friends?(user1,user2)
    user1.friendships.where(friend_id: user2.id).exists? && user2.friendships.where(friend_id: user1.id).exists?
  end
  # czy current_user został zaproszony przez usera
  def invited?(user)
    inverse_friendships.where(user_id: user.id).empty?
  end
  
  # czy current_user wysłał zaproszenie
  def send_invite?(user)
    friendships.where(friend_id: user.id).exists?
  end
  
  def self.destroy_all(user)
    User.transaction do 
      user.locations.destroy_all
      user.photos.destroy_all
      user.destroy
    end
  end
end
