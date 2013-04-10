class UserController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!
  before_filter :load_user, :only =>[:show,:profile]


  def show
    @location_file = @user.locations.new
    @location_name = locations_name_to_array
    @photo = @user.photos.new
  end
  
  def profile
    @location_name = locations_name_to_array
  end
  
  private
  
  def load_user
    @user = User.find_by_id(params[:id])
    authorize_user(@user)
  end

  
  def locations_name_to_array
    loc_name = @user.locations.select('DISTINCT name')
    name_array = []
    loc_name.each do |ln|
      name_array.push(ln.name)
    end
    name_array
  end
end
