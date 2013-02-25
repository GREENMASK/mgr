var newMarkersArray=[];

$(document).ready(function(){
  start_action_create();
  add_new_markers();
  clear_all_new_markers();
})

// funkcja wyłącza funkcje dodwania nowych pkt na mapie
function remove_action_add_new_markers(){
  google.maps.event.clearListeners(mapa,'click');
}


function start_action_create(){

  $("a.create_new_markers").on("click",function(){
    if(typeof(handle)=="object"){
      clear_action_on_markers();
    }
    var str = $("div.load_gpx_name").text();
    google.maps.event.addListener(mapa,'click',function(event){
      create_new_location(event);
    });
  });
}


create_new_location = function(event){
  if(event.latLng){
    var new_marker;
    //var point = new google.maps.LatLng(event.latLng);
    new_marker = create_marker_object(event.latLng,0,"new");//mapa.js
    new_marker.set("create",true);
    newMarkersArray.push(new_marker);
    action_on_new_markers();
  }
}

// tworzy akcje click,na nowych markerach
var handle2;
function action_on_new_markers(){
  if(typeof(handle2)=="object"){
    for(i in newMarkersArray){
      google.maps.event.clearListeners(newMarkersArray[i],'click');
    }
  }
  
  for(i in newMarkersArray){
    handle2 = google.maps.event.addListener(newMarkersArray[i],'click',function(){unchecked_to_create_new_marker(this);});
  }
}
 
 // odznacza nowy marker do stworzenia
unchecked_to_create_new_marker = function(object){
 
   var temp =[];
   if(object.get("create") == true){
      object.set("create",false);
      object.setMap(null);
   }

   for(i in newMarkersArray){
     if(newMarkersArray[i].get("create")){
       temp.push(newMarkersArray[i]);
     }
   }
   newMarkersArray = temp;
}

function add_new_markers(){
  $('a.add_new_markers').on('click',function(){
     put_update_new_markers();
  });
}

function create_data_to_update(){
  var name = $('div.load_gpx_name').text().split(': ')[1].toString();
  var data='{\"name\":\"'+name+'\",\"locations\":{ ';
  for(i in newMarkersArray){
    if(newMarkersArray[i].get("create")){
      data += 
      '\"position'+ i +'\":{'+
      '\"lat\":\"' + newMarkersArray[i].getPosition().lat().toString() +'\",'
     +'\"lng\":\"' + newMarkersArray[i].getPosition().lng().toString() +'\"}';
       if((newMarkersArray.length-1) != i){
         data+=','
       }
    }
  }
  data+='}}';
  
  //var jsonOb = jQuery.parseJSON(data);
  return data;
}


function put_update_new_markers(){
  
  
  if(newMarkersArray.length > 0){
     var tab = create_data_to_update();
    $.ajax({
            traditional:true,
            url:'/locations/update_location',
            type:'PUT',
            dataType:'json',
            data:{'data':tab},
            success: function(data){
                      after_upadate_locations(data);
            }
  });
  
  
  }

}

function after_upadate_locations(txt){
  if(txt["odp"] == "ok"){
    clear_new_markers_from_map();
    reload_locations_on_map();
  }
  else{
    
  }
}

function clear_new_markers_from_map(){
  for(i in newMarkersArray){
    newMarkersArray[i].setMap(null);
  }
  newMarkersArray=[];
}

function reload_locations_on_map(){
  var name = $("div.load_gpx_name").text().split(": ");
  get_ajax(name[1]);// location.js
}

// funckja usuwa z mapy nowe punkty po kliknieciu wyczyśc
function clear_all_new_markers(){
  $("a.clear_all_new_markers").on("click",function(){
    clear_new_markers_from_map();
  });
}
