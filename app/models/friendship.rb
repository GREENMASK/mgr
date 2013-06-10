class Friendship < ActiveRecord::Base

  belongs_to :user 
  belongs_to :friend, :class_name => "User"
  
  
  attr_accessible :friend_id, :user_id
  
  def self.destroy_relation(user,id)
    fs  = user.friendships.find_by_friend_id(id)
    ifs = user.inverse_friendships.find_by_user_id(id)
    Friendship.transaction do 
      fs.destroy
      ifs.destroy
    end
  end
end
