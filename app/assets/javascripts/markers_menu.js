function markers_menu(object){
  showContextMenu(object);
  remove_one_point(object);
  start_move_marker(object);// move_marker.js
  update_move_marker_position(object);// move_marker.js
}

function showContextMenu(object) {
  var caurrentLatLng = object.getPosition();
  var projection;
  var contextmenuDir;
  projection = mapa.getProjection() ;
  $('.contextmenu').remove();
  contextmenuDir = document.createElement("div");
  contextmenuDir.className  = 'contextmenu';
  contextmenuDir.innerHTML = menuContextString(object);

  $(mapa.getDiv()).append(contextmenuDir);
  setMenuXY(caurrentLatLng);
  
  $('.contextmenu').css("visibility","visible");
  $('.contextmenu').mouseleave(function(){
    $('.contextmenu').css("visibility","hidden");
  });


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
  var mapWidth = $('#map_canvas').width();
  var mapHeight = $('#map_canvas').height();
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

  $('.contextmenu').css('left',x  );
  $('.contextmenu').css('top',y );
};


function menuContextString(object){
 var str = '<ul>'
 str = str + '<li><a class="menu_context_destroy">Usuń<\/a><\/li>';
 if(object.getDraggable()){
   str = str + '<li><a class="update_move_marker_position">Zapisz<\/a><\/li>';
 }
 else{
   str = str + '<li><a class="start_move_marker">Zmień pozycje<\/a><\/li>';
 }

 str = str +'<\/ul>';
 return str;
}


