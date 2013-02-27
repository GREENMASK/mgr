
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

//// Prawe klikniecie na marker ///////////////////////

var right_handle;

function right_click_marker_action(){
  if(typeof(right_handle)=='object'){
    for(i in markersArray){
      google.maps.event.clearListeners(markersArray[i],'rightclick');
    }
  }
  
  for(i in markersArray){
    google.maps.event.addListener(markersArray[i],'rightclick',function(){
      markers_menu(this);
    });
  }
}
