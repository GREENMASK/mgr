module GpxHelper

 def mapa_load
  html = if params[:action] =="show"
    'onload="mapaStart()"'
  else
    ''
  end
  html.html_safe
 end
end
