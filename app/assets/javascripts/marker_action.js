//// DODAWANIE ID do ZDJECIA///////////

$(document).ready(function(){
  position_image_function();
})

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

// funkcja podaje wspórzedne markerach dla nowego zdjecia
get_image_position = function(object){
  $("input#photo_location_id").val(object.get("id"));
}


//// TWORZENIE AKCJI NA markerach lewy click///////////////////////////

// funkcja obsługje zdarzenia na markerach
var handle;
function action_on_markers(str){
  if(typeof(handle)=='object'){
    clear_action_on_markers();
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
// usuwa akcje na markerach
function clear_action_on_markers(){
  for(i in markersArray){
    clear_all_from_map();
    google.maps.event.clearListeners(markersArray[i],'click');
  }
}
