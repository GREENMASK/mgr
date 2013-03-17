class LocationsController < ApplicationController
  require 'json'
  before_filter :load_user
  
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
      flash[:alert] = @location_file.errors.full_messages
    end
    redirect_to user_path(@user)
  end
  
  def destroy #cały plik GPX
    if @user.locations.with_name(params[:id]).delete_all
      flash[:notice] = "Poprawnie usunieto plik: #{params[:id]}"
    else
      flash[:alert] = "Blad usuwania pliku #{params[:id]}"
    end
    redirect_to profile_user_index_path(:id => @user.id)
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
      @photos = @location.photos
      unless @photos.empty?
        format.js{render :json => {data: photo_url(@photos)}}
      end
    end
  end
  
  private 
  
  def photo_url(photo)
    tab=[]
    photo.each do |p|
      p[:url]=p.image_url
      tab.push(p)
    end
    tab
  end
  
  def load_user
   @user = current_user
  end
  
  def photo_include?(loc)
    new_loc = []
    loc.each do |l|
     l[:photo] = l.photos.empty? ? 0 : "photo"
     new_loc.push(l)
    end
    new_loc
  end
end
