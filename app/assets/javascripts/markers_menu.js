function markers_menu(object){
  showContextMenu(object,'contextmenu');
  remove_one_point(object);
  start_move_marker(object);// move_marker.js
  update_move_marker_position(object);// move_marker.js
  position_image_function(object); // add_image.js
  load_marker_photo(object);
}

function showContextMenu(object,class_name) {
  var caurrentLatLng = object.getPosition();
  var projection;
  projection = mapa.getProjection();
  
  $("."+class_name).remove();
  var object_to_show = create_object_to_show_on_map(object,class_name);

  $(mapa.getDiv()).append(object_to_show);
  setMenuXY(caurrentLatLng);
  
  $("."+class_name).css("visibility","visible");
  $('.contextmenu').mouseleave(function(){
  $('.contextmenu').css("visibility","hidden");
  });
}

function create_object_to_show_on_map(object,class_name){
  var show_dir;
  show_dir = document.createElement("div");
  if(class_name =="contextmenu"){
    show_dir.className  = class_name;
    show_dir.innerHTML = menuContextString(object);
  }
  if(class_name == "form_image"){
    show_dir.className  = class_name;
    show_dir.innerHTML = menuContextString(object);
  }

  return show_dir;
}

function getCanvasXY(caurrentLatLng){
  var scale = Math.pow(2, mapa.getZoom());
  var nw = new google.maps.LatLng(
    mapa.getBounds().getNorthEast().lat(),
    mapa.getBounds().getSouthWest().lng()
  );
  var worldCoordinateNW = mapa.getProjection().fromLatLngToPoint(nw);
  var worldCoordinate = mapa.getProjection().fromLatLngToPoint(caurrentLatLng);
  var caurrentLatLngOffset = new google.maps.Point(
    Math.floor((worldCoordinate.x - worldCoordinateNW.x) * scale),
    Math.floor((worldCoordinate.y - worldCoordinateNW.y) * scale)
  );
  return caurrentLatLngOffset;
}


function setMenuXY(caurrentLatLng){
  var mapWidth = $('#mapa').width();
  var mapHeight = $('#mapa').height();
  var menuWidth = $('.contextmenu').width();
  var menuHeight = $('.contextmenu').height();
  var clickedPosition = getCanvasXY(caurrentLatLng);
  var x = clickedPosition.x ;
  var y = clickedPosition.y ;

  if((mapWidth - x ) < menuWidth){
    x = x - menuWidth;
  }

  if((mapHeight - y ) < menuHeight){
    y = y - menuHeight;
  }

  $('.contextmenu').css('left',x + 10);
  $('.contextmenu').css('top' ,y - 20);
};


function menuContextString(object){
 var str = '<ul>';
 
 if(object.get("cu")){
   str = str + '<li><a class="menu_context_destroy">Usuń marker<\/a><\/li>';
   if(object.getDraggable()){
      str = str + '<li><a class="update_move_marker_position">Zapisz<\/a><\/li>';
    }
   else{
      str = str + '<li><a class="start_move_marker">Zmień pozycje<\/a><\/li>';
    }
   str = str+ '<li><a class="add_image_postion">Dodaj zdjęcie<\/a></li>'; 
 }
 
 
 if(object.get("photo")){
   str= str + '<li><a class="load_marker_photo">Pokaż zdjecia<\/a><\/li>' 
 }
 if(str.length < 5){ 
   str = '<li><a>Brak dostępu<\/a><\/li>';  
 }
 str = str +'<\/ul>';
 
 return str;
}


