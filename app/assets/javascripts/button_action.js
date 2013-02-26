$(document).ready(function(){
  show_edit_buttons();
  show_remove_buttons();
  show_add_buttons();
  show_list_locations();
  show_add_file_gpx();
  show_profile_buttons();
})

function show_add_file_gpx(){
 $("a.add_gpx").on("click",function(){
   change_display_value("#add_gpx","block");
 });
}

function show_list_locations(){
  $("a.load_list_gpx").on("click",function(){
     change_display_value("ul.list_locations","block");
  });
}

function show_edit_buttons(){
  $("a.edit_gpx").on("click",function(){
     change_display_value("spam.edit_gpx_points","inline");
  });
}

function show_remove_buttons(){
  $("a.get_markers_to_remove").on("click",function(){
    $("spam.add_gpx_points").css("display","none");
    $("spam.remove_gpx_points").css("display","inline");
    remove_action_add_new_markers(); //create_new_location.js
    clear_new_markers_from_map();//create_new_location.js
  });
}

function show_add_buttons(){
  $("a.create_new_markers").on("click",function(){
    $("spam.add_gpx_points").css("display","inline");
    $("spam.remove_gpx_points").css("display","none");
    remove_checked_markers_from_map();//remove_checked_markers.js
  });
}


function change_display_value(object,value){
  var object_tab =["spam.add_gpx_points",
                   "spam.remove_gpx_points",
                   "spam.edit_gpx_points",
                   "ul.list_locations",
                   "#add_gpx"]
  var f_value ="";

 for(i in object_tab){
   if(object_tab[i] == object){
     f_value = value;
   }
   else{
     f_value = "none";
   }
   $(object_tab[i]).css("display",f_value);
 }
  remove_checked_markers_from_map();//remove_checked_markers.js
  remove_action_add_new_markers(); //create_new_location.js
  clear_new_markers_from_map();//create_new_location.js
}


function show_profile_buttons(){
  $("a.profile_area").on("click",function(){
      if (markersArray.length > 0){
        $("ul.profile_buttons").css("display","block");
      }
      else{
        alert("Nie wczytano pliku gpx.");
      }
  });
}

