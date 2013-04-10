$(document).ready(function(){
  home_animation();
});


// zmienia foto na stronie głownej
function home_animation(){
  $("div#animation").cycle({
  fx: "uncover", 
  delay: 2000  
 });
}

