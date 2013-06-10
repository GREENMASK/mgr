class PhotosController < ApplicationController
  include ApplicationHelper
  
  around_filter :select_shard
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :load_photo, :only=>[:show,:destroy,:edit,:update]

  def index
    Octopus.using(:shard_1) do 
      @photos = Photo.find_all_by_user_id(@user.id)
    end
  end
  
  def new
  end
  
  def show
  end
  
  def create
    respond_to do |format| 
      @photo = Photo.using(:shard_1).new(params[:photo])
      @photo.user_id = @user.id
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
    redirect_to user_photos_path
  end
  
  def destroy
    if @photo.destroy
      flash[:notice] = t(:success, :scope => [:controller, :photo, :destroy]) 
    else
      flash[:alert] = t(:faild, :scope => [:controller, :photo, :destroy])
    end
    redirect_to user_photos_path
  end
  
  private
  
  def load_user
    Octopus.using(:master) do
      @user = User.find(params[:user_id])
    end
  end

  def load_photo
    @photo = Photo.using(:shard_1).find(params[:id])
  end
  
  
  def select_shard(&block)
    Octopus.using(:master, &block)
  end
end
