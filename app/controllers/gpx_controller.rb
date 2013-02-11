class GpxController < ApplicationController
  before_filter :load_user
  
  def index
  end
  
  def about
  end
  
  private
  
  def load_user
    @user = current_user
  end
end
