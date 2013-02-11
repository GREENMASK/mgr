module ApplicationHelper

  def show_info(info)
    type , msg = info.first
    html = <<-HTML
  <div id="info">
    <ul class=#{type}>
      #{type_msg(msg)}
    </ul>
  </div>
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
    return false if user.nil?
    user.id == current_user.id
  end
     
end
