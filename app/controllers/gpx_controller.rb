class GpxController < ApplicationController
  before_filter :load_user
  layout :determine_layout
 
  def index
  end
  
  def about
  end
  
  def old_broswer
  end

  private
  
  def load_user
    @user = current_user
  end

  def determine_layout
    if (params[:action].to_s == "old_broswer")
      "old_broswer"
    else 
      "application"
    end 
  end
end
