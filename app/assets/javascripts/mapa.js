var mapa;
var markersArray = [];
var marker;

function mapaStart()   
{   
  var wspolrzedne = new google.maps.LatLng(50.064185236286325,19.962596130371094);
  var opcjeMapy = {
    zoom: 11,
    center: wspolrzedne,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  mapa = new google.maps.Map(document.getElementById("mapa"), opcjeMapy);
}   

// funkcja funkcja obsługuje stwrzonie markerów na mapie
function create_markers(ob_json){
  deleteOverlays();// usuwa poprzednie markery
  var points = create_points(ob_json);
  openMapaCenter(ob_json);

  for(i=0;i<(points.length);i++){
    add_marker(points[i],ob_json[i].id ,ob_json[i].photo);
  }
  right_click_marker_action();
}

// funkcja dodaje marker na obiekt mapy
function add_marker(point,id,type){
  markersArray.push(create_marker_object(point,id,type));
}

//funkcja tworzy strukutre marker
function create_marker_object(point,id,type){
  var icon,icon_s;
  var tab =[];
  tab = choose_type_marker(type);
  var markerOptions ={
   position: point,
   map:mapa,
   clickable:true,
   icon: tab[0],
   shadow:tab[1]
  }

  marker = new google.maps.Marker(markerOptions);
  marker.set("id",id);
  if(type == "photo"){
    marker.set("photo",true);
  }
  return marker;
}

// funkcja ustala icone,cień markera

function choose_type_marker(type){

 var url = document.location.protocol + "//"+document.location.host;
 var icon = "http://maps.google.com/mapfiles/kml/pal2/icon13.png";
 var shadow = "http://maps.google.com/mapfiles/kml/pal2/icon13s.png";

 if(type == "photo"){
    icon = url +"/assets/camera.png";
    shadow = url +"/assets/camera_s.png";
 }
 
 if(type == "new"){
    icon = "http://maps.google.com/mapfiles/kml/pal3/icon46.png";
    shadow = "http://maps.google.com/mapfiles/kml/pal3/icon46s.png";
 }

 return [icon,shadow];
}

//funkcja tworzy punkty z dwiema współrzednymi, z json
function create_points(loc){
  var points =new Array();
  for(i=0;i< (loc.length);i++){
    points.push(new google.maps.LatLng(loc[i].lat,loc[i].lng));
  }
 return points;
}

function openMapaCenter(json){
  var obj = createLatLng(json);
  var lats = search_max_min(obj[0]);
  var lngs = search_max_min(obj[1]);
  
  createBounds(lats,lngs);
}

function search_max_min(tab){
 var min =tab[0];
 var max = tab[0];
 for(i=0;i<(tab.length-1);i++){
   if (tab[i] > max){
     max = tab[i];
   }
   if (tab[i]< min){
     min = tab[i];
   }
 }
  return [max, min];
}

function createBounds(lat,lng){
  minLat = lat[1];
  maxLat = lat[0];
  minLng = lng[1];
  maxLng = lng[0];

  var square = new google.maps.LatLngBounds(
   new google.maps.LatLng(maxLat,minLng),
   new google.maps.LatLng(minLat,maxLng)
  );
  
        
  var center = square.getCenter();
  mapa.setCenter(center,7);
  
  mapa.fitBounds(square);
  
  
}

function createLatLng(json){
   var lats = new Array();
   var lngs = new Array();

  for(i=0;i<(json.length-1);i++){
     lats.push(parseFloat(json[i].lat));
     lngs.push(parseFloat(json[i].lng));
  }
  return [lats,lngs];
}

// usuwanie markerów
function deleteOverlays() {
  if (markersArray) {
    for (i in markersArray) {
      markersArray[i].setMap(null);
    }
    markersArray.length = 0;
    markersArray=[];
  }
}

// proces podmiany icony markera po dodaniu noweg image
function change_marker_icon(id){
  var mark;
  mark = find_marker(id);
  add_marker(mark.getPosition(),id,"photo");
}

// znajdowanie markera po id,usuniecie starego
function find_marker(id){
  var new_marker;
  if (markersArray){
      for(i in markersArray){
        var m = markersArray[i].get("id");
         if(m == id){
            new_marker = markersArray[i];
            markersArray[i].setMap(null);
        }
      }
  }
  return new_marker;
}
