class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!, :except => [:new,:create]
  before_filter :load_user, :only =>[:show,:edit,:destroy]
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    url = if @user.save && @user.active_for_authentication?
      sign_in(resource_name, resource)
      user_path(@user)
    else
      flash[:alert] = @user.errors.values.sum
      new_user_registration_path
    end
    redirect_to url
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if resource.update_with_password(resource_params)
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      #respond_with resource, :location => after_update_path_for(resource)
      redirect_to profile_users_path(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  def cancel
  end
  
  def destroy
    User.destroy_account(@user)
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message :notice, :destroyed if is_navigational_format?
      respond_with_navigational(@user){ redirect_to after_sign_out_path_for(resource_name) }
  end
  
  private
  
  def load_user
    @user = User.find_by_id(params[:id]) 
  end
  
  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    hash ||= resource_params || {}
    self.resource = resource_class.new_with_session(hash, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    respond_to?(:root_path) ? root_path : "/"
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", :force => true)
    self.resource = send(:"current_#{resource_name}")
  end
end
