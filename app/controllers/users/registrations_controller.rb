class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!, :except => [:new,:create]
  before_filter :load_user, :only =>[:show,:edit,:destroy]
  
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    url = if @user.save && @user.active_for_authentication?
      sign_in(resource_name, resource)
      user_path(@user)
    else
      flash[:alert] = @user.errors.full_messages
      new_user_registration_path
    end
    redirect_to url
  end
  
  def show
  end
  
  def edit
  end
  
  def update
  end
  
  def cancel
  end
  
  def destroy
  end
  
  private
  
  def load_user
    @user = User.find_by_id(params[:id])
  end

end
