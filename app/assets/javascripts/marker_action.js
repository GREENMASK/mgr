//////////////////////PROFIL TERENU /////////////////////

$(document).ready(function(){
  profile_function();
  position_image_function();
})

var chart;
var elevator; // obiekt odp za w.n.p.m
function profile_function(){
   
  $("a.check_marker").on("click",function(){
    action_on_markers("get_position_to_profile");
    elevator = new google.maps.ElevationService();
  });
}

// funkcja sprawdza czy wyswietlone markery,aby dodac image
function position_image_function(){
  $("a.add_image_postion").on("click",function(){
    if(markersArray.length > 0){
      action_on_markers("get_image_position");
      $("div#add_image").css("display","block");
    }
    else{
      alert("Nie wczytano pliku gpx");
    }
  });
}
// pobieranie współrzednych dwóch pkt
var  clickNumber=0;
var p1,p2;
get_position_to_profile = function(object){
      clickNumber++;
      if(clickNumber%2 == 1){
         p1 = object.getPosition();
      }
      if(clickNumber%2 == 0){
         p2 = object.getPosition();
      }
      if(clickNumber >=2 && typeof(p1)=='object' && typeof(p2)=='object'){
        draw_polyline(p1,p2);
      }
  $('a.draw_chart').on('click',function(){
    if(typeof(p1)=='object' && typeof(p2)=='object'){
      drawPath(p1,p2);
    }
  });
}

// Rysuje polilinie między dwoma pkt,
var polyline;
function draw_polyline(p1,p2){
  clear_all_from_map();
  polyline = new google.maps.Polyline({
    path:[p1,p2],
    strokeColor: "#FF0000",
    strokeOpacity: 1.0,
    strokeWeight: 2
  });
  polyline.setMap(mapa);
}

function clear_all_from_map(){
  if(typeof(polyline) == 'object'){
    polyline.setMap(null);
  } 
}

// funkcja inicializuje zapytanie o elevation_chart

function drawPath(p1,p2){
  var path = [p1,p2];// pkt miedzy którymi będą pobierane wnpm.
  var pathRequest ={
    'path':path,
    'samples': 301
  }
  
  elevator.getElevationAlongPath(pathRequest, plotElevation);
}

// funkcja sprawdzajaca poprawność pobrania Elevation
function plotElevation(results,status){
  if(status == google.maps.ElevationStatus.OK){
    drawChart(results);
  }
}
// Funckja rysuje wykres w nowym oknie.
function drawChart(results){
  
  var elevations  = new Array();
  var locations   = new Array();
  var distances = new Array();
  
  for(i=0;i<results.length;i++){
    elevations.push(results[i].elevation);
    locations.push(results[i].location);
  }
  for(i=0;i<results.length;i++){
     if(i== 150 || i == 300){
       distances.push(get_distance(locations[0],locations[i]));
     }
     else{
       distances.push("0");
     }
  }

  var okno = chart_popup();
  var div = okno.document.body.childNodes[0];
  var chart = new Highcharts.Chart({
    chart:{
      renderTo:div,
      type:'column'
    },
    title:{
      text: 'Profil Terenu'
    },
    xAxis:{
      title:{
       text:'odległość'
      },
      categories:distances,
      tickInterval:150,
      labels:{
        align:'right'
      }
    },
    plotOptions:{
      series:{
        color:'#4ac2ed',
        borderColor:'#4ac2ed',
        borderRadius:5
      }
    
    },
    yAxis:{
      title:{
        text:'w.n.p.m'
      }
    },
    series:[{
      name:'W.N.P.M',
      data:elevations
    }]
  });
  okno.focus();
}

/// Tworzymy okienko gdzie zostanie wyświetolny wykres
function chart_popup(){
 var popup = window.open('','wykres','width=800 height=420');
 var div = document.createElement('div');
 div.id = "elevation_chart";
 popup.document.body.appendChild(div);
 return popup;
}

// funckja zwraca odległosc w lini miedzy dwoma pkt w 'metrach'
function get_distance(point1,point2){
  var a = google.maps.geometry.spherical.computeDistanceBetween(point1,point2);
  a = Math.round(a);
  var str =""; 
  if (a > 1000){
    a = (a/1000);
    a = a.toFixed(2);
    str = a.toString() + " km";
  }
  else{
    str = a.toString() +" m";
  }
  return str;
}

// funkcja podaje wspórzedne markerach dla nowego zdjecia
get_image_position = function(object){
  $("input#photo_location_id").val(object.get("id"));
}

// funkcja obsługje zdarzenia na markerach
var handle;
function action_on_markers(str){
  if(typeof(handle)=='object'){
    for(i in markersArray){
      clear_all_from_map();
      google.maps.event.clearListeners(markersArray[i],'click');
    }
  }
  var switch_method;
  switch(str){
    case "get_position_to_profile":
      switch_method = get_position_to_profile;
    break;
    case "get_image_position":
      switch_method = get_image_position;
    break;
    case "get_markers_id_to_destroy":
      switch_method = get_markers_id_to_destroy; 
      // remove_checked_markers.js
    break;
    case "create_new_location":
        switch_method = create_new_location;//create_new_location.js
    break
  }
  
    for(i in markersArray){
      handle = google.maps.event.addListener(markersArray[i],'click',function(){switch_method(this);});
    }
}
