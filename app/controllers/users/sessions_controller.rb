class Users::SessionsController<Devise::SessionsController

  before_filter :authenticate_user!, :only => [:destroy]
  
  def new
  end
  
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    sign_in(resource_name,resource)
    flash[:notice] = "Sign in"
    redirect_to user_path(current_user)
  end
  
  def destroy
    sign_out(@user)
    redirect_to root_path
  end
end
