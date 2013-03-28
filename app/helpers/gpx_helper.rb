module GpxHelper

 def mapa_load
  html = if params[:action] =="show"
    'onload="mapaStart()"'
  else
    'onload="check_broswer_type()"'
  end
  html.html_safe
 end
end
