class FriendshipsController < ApplicationController

  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    if @friendship.save
      flash[:notice] = "Wyslano zaproszenie."
    else	
      flash[:alert]  = "Blad wysylania zaproszenia."
    end
    redirect_to list_users_path
  end

  def destroy
    if Friendship.destroy_relation(current_user,params[:id])
      flash[:notice] = "Delete."
    end
    redirect_to list_users_path
  end
  
  def destroy_send_invite
    @friendship = current_user.friendships.find_by_friend_id(params[:id])
    @friendship.destroy
    flash[:notice] = "Usunieto wyslane zaproszenie."
    redirect_to list_users_path
  end
  
  def destroy_invited
    @friendship = current_user.inverse_friendships.find_by_user_id(params[:id])
    @friendship.destroy
    flash[:notice] = "Usunieto zaproszenie."
    redirect_to list_users_path
  end
end
