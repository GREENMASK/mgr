module GpxHelper

 def mapa_load
  html = if params[:action] =="show"
    'onload="mapaStart()"'
  else
    ''
  end
  html.html_safe
 end
 
 def load_friend(user)
   html = '<table class="user_attributes">'
   html+='<spam class="table_title">Znajomi:</spam>'
   html+= '    
    <tr>
      <th><th>
      <th><th>
    </tr>'
  tab =[]   

  user.friendships.each do |fs|
    user.inverse_friends.each do |ifs|
     if ifs.email == fs.friend.email
       tab.push(fs.friend)
     end
    end  
  end 

  if tab.empty?
    html +='<tr><td>Brak znajomych</td></tr>'
  else
    tab.each do |us|
      html+="<tr>
		<td> #{ link_to us.email, profile_users_path(:id=> us.id) }</td>"
      if user == current_user
        html+=   "<td> #{ link_to t('view.link.delete') , friendship_path(us),:method => :delete }</td>"
      end      
      html+="</tr>"
    end
  end
  
  html +='</table>'
  html.html_safe
 end
 
 def load_user_list(users)
    html = ""
    users.each do |user|
      if user == current_user || User.friends?(user,current_user)
      elsif !current_user.invited?(user)	
	html += "
	<tr>
	  <td>#{link_to user.email.to_s, profile_users_path(:id => user.id)}</td>
	  <td>#{link_to t('view.link.accept_invition'),friendships_path(:friend_id => user.id), :method=> :post }</td>
	  <td>#{link_to t('view.link.reject_invation'), destroy_invited_friendships_path(:id => user.id),:method=> :delete}</td>
	</tr>"
     elsif current_user.send_invite?(user)	
	html += "
	<tr>
	  <td>#{link_to user.email.to_s, profile_users_path(:id => user.id)}</td>
	  <td>#{link_to t('view.link.remove_invation'),destroy_send_invite_friendships_path(:id => user.id), :method => :delete }</td>
	</tr>"
      else
	html += "
	<tr>
	  <td>#{link_to user.email.to_s, profile_users_path(:id => user.id)}</td>
	  <td>#{link_to t('view.link.add_to_friends'),friendships_path(:friend_id => user.id), :method=> :post }</td>
	</tr>"
      end 
    end
  html.html_safe
 end
 
end
