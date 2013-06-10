module ApplicationHelper

  def show_info(info) 
    type , msg = info.first
    html = <<-HTML
    <ul class=#{type}>
      #{type_msg(msg)}
    </ul>
  HTML

  html.html_safe
  end
  
  def type_msg(msg)
    message = if msg.kind_of?(Array)
       msg.map { |m| "<li>#{m}</li>"}.join
    else 
      "<li>#{msg}</li>"
    end
  end 
  
  def authorize_user(user)
    b = case
        when user.nil? then false
	when user.id == current_user.id then true
	when User.using(:master).friends?(current_user,user) then true
        when user.id != current_user.id then false
    end
    unless b
      redirect_to user_path(current_user), alert: "Brak dostepu!"
    end
  end
end
