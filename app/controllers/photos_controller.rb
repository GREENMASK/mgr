class PhotosController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :load_photo, :only=>[:show,:destroy,:edit,:update]

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
  
  def update
 
    if @photo.update_attributes(params[:photo])
      flash[:notice]="Poprawnie zapisano zmiany."
    else
      flash[:alert] ="Blad akutalizacji."
    end
    redirect_to user_photos_path(:user_id => @user.id)
  end
  
  def destroy
    if @photo.destroy
      flash[:notice] = I18n.t(:success, :scope => [:controller, :photo, :destroy]) 
    else
      flash[:alert] = I18n.t :faild, :scope => [:controller, :photo, :destroy]
    end
    redirect_to user_photos_path(@user)
  end
  
  private
  
  def load_user
    @user = User.find(params[:user_id])
    authorize_user(@user)
  end

  def load_photo
    @photo = @user.photos.find(params[:id])
  end
end
