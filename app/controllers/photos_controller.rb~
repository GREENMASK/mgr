class PhotosController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :load_photo, :only=>[:show,:destroy,:edit]
  
  def index
    @photos = @user.photos
  end
  
  def new
  end
  
  def show
  end
  
  def create
    respond_to do |format| 
    @photo = @user.photos.new(params[:photo])
    @photo_id = @photo.location_id
    
      if @photo.save
        format.js 
      end
    end
  end
  
  def edit
  end
  
  def destroy
    if @photo.destroy
      flash[:notice] ="Deleting a successful"
    else
      flash[:alert] = "Removing is failed"
    end
    redirect_to user_photos_path(@user)
  end
  
  private
  
  def load_user
    @user = User.find(params[:user_id]) 
  end
  
  def load_photo
    @photo = @user.photos.find(params[:id])
  end
end
