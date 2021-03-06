class LocationsController < ApplicationController
  require 'json'
  include ApplicationHelper
  include Gpx # ./lib/gpx.rb
  before_filter :load_user
  before_filter :authenticate_user!  

  def load_location
    @locations = @user.locations.find_all_by_name(params[:name])
    @new_locations = photo_include?(@locations)
    respond_to do |format|
      format.js{render :json => @new_locations}
    end
  end

  def create
    @location_file = @user.locations.new
    if @location_file.save_location(params[:location])
      flash[:notice] = "Poprawnie dodano plik"
    else
      flash[:alert] = @location_file.errors.values.sum
    end
    redirect_to user_path(@user)
  end
  
  def create_from_map
    @locations = params[:data].inspect
     respond_to do |format| 
       if @user.locations.create_new_file_from_map(@locations)
         format.js{ render :json => {odp: "ok"}}
       else
         format.js{ render :json => {odp: "wrong"}}
       end
     end
  end
  
  def check_name
    @name = Location.find_by_name(params[:name])
    answer = @name.nil? ? "ok":"wrong"
    respond_to do |format|
      format.js{render :json =>{odp: answer}}
    end
  end
  
  def destroy #cały plik GPX
    if @user.locations.with_name(params[:id]).delete_all
      flash[:notice] = "Poprawnie usunieto plik: #{params[:id]}"
    else
      flash[:alert] = "Blad usuwania pliku #{params[:id]}"
    end
    redirect_to profile_users_path(:id => @user.id)
  end
  
  def destroy_checked
    @makrers_id = params[:markers]
    respond_to do |format|
      if @user.locations.destroy_checekd_location(@makrers_id.split(','))
        format.js {render :json => {odp:"ok"}}
      else
        format.js{ render :json => {odp: "wrong"}}
      end
    end
  end
  
  def update_location
    @locations = params[:data].inspect
     respond_to do |format| 
       if @user.locations.update_old_location_file(@locations)
         format.js{ render :json => {odp: "ok"}}
       else
         format.js{ render :json => {odp: "wrong"}}
       end
     end
  end

  def update
    @location = Location.find(params[:id])
    respond_to do |format|
      if @location.update_attributes(params[:position])
        format.js{ render :json => {odp:"ok"}}
      else
        format.js{ render :json => {odp:"wrong"}}
      end
    end
  end
  
  def show_photos 
    respond_to do |format| 
      @location = Location.find(params[:id])
      @photos = Photo.using(:shard_1).find_all_by_location_id(@location.id)
      unless @photos.empty?
        format.js{render :json => {data: photo_url(@photos)}}
      end
    end
  end
  
  def download_gpx
    @location = Location.find_all_by_name(params[:format])
    send_data(Gpx.creator(@location),:type=>"text/xml",:filename=>"#{@location.first.name}.gpx")
  end

  private 
  
  def photo_url(photo)
    tab=[]
    photo.each do |p|
      if p.public_status
	 p[:url]=p.image_url
         tab.push(p)
      elsif !p.public_status && @user == current_user
	 p[:url]=p.image_url
         tab.push(p)
      end
    end
    tab
  end
  
  def load_user
   if params[:user_id]
    @user = User.using(:master).find(params[:user_id])
   end
   @user ||= current_user
  end
  
  def photo_include?(loc)
    new_loc = []
    loc.each do |l|
      l[:photo] = Photo.using(:shard_1).find_all_by_location_id(l.id).empty? ? 0 : "photo"
      l[:current_user] = @user == current_user ? true : 0
     new_loc.push(l)
    end
    new_loc
  end
  
end
