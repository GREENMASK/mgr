$(document).ready(function(){
  get_markers_to_remove();// zbiera info o markerach do usuniecia
  set_markers_to_remove();// wykonuje akcje usuniecia oznaczonych markerow
  clear_all_markers_to_remove();// odznacza wszystkie markery do usuniecia
})

  function get_markers_to_remove(){
    $('a.get_markers_to_remove').on("click",function(){
       action_on_markers("get_markers_id_to_destroy");
    })
  }
  

  get_markers_id_to_destroy = function(object){

    var destroy = object.get("destroy");
    if(destroy =="undefined" || destroy == 0);
    {  
       object.set("destroy",1);
       change_marcker_icon(object,"destroy");
    }
    
    if(destroy == 1){
      object.set("destroy",0);
      change_marcker_icon(object,"no");
    }
  }
  
  
  // funkcja podmienia ikone, cień markera,oznacza marker do usuniecia.
  function change_marcker_icon(object,id){
   var ic;
   var sh;
   
   
   // definiuje adres starej icony markera
   if(typeof(object.get("old_icon")) == "undefined"){
      object.set("old_icon",object.getIcon());
      object.set("old_shadow",object.getShadow());
   }

   if(id == "destroy"){
     ic = "http://maps.google.com/mapfiles/kml/pal3/icon39.png";
     sh = "http://maps.google.com/mapfiles/kml/pal3/icon39s.png";
   }
   
   if(id == "no"){
     if(object.get("old_icon") == null){
       ic = "http://www.google.com/intl/en_ALL/mapfiles/marker.png";
       sh = "http://www.google.com/intl/en_ALL/mapfiles/shadow50.png";
     }
     
     else{
       ic = object.get("old_icon");
       sh = object.get("old_shadow");
     }
   }

    object.setIcon(ic);
    object.setShadow(sh);
  }
  // funckcja usuwa tylko jeden pkt z mapy przy użyciu contextmenu 
  function remove_one_point(object){
    $("a.menu_context_destroy").on("click",function(){
      object.set("destroy",1);
      start_remove_markers();
      $(".contextmenu").css("visibility","hidden");
    });
  }

  function set_markers_to_remove(){
    $("a.set_markers_to_remove").on("click",function(){
       start_remove_markers();
    });
  }
  
  
  var remove_markers =[];
  function start_remove_markers(){

    remove_markers =[];
    for(i in markersArray){
      if(markersArray[i].get("destroy")==1){
        remove_markers.push(markersArray[i].get("id"));
      }
    }
   
   if(remove_markers.length >0){
     ajax_remove(remove_markers);
   }
   else{
     alert("nie wybrano żadnego markera do usunięcia");
   }
  }
  
  function ajax_remove(data){

   var myObject ={
     markers:[data]
   };
   
   $.ajax({
    traditional: true,
    url:'/locations/destroy_checked',
    type:"DELETE",
    dataType: 'json',
    data:myObject,
    success: function(odp){
      if(odp.odp == "ok"){
        remove_checed_marker_from_map();
        flash_message("notice",["Poprawnie usunięto punkty."]);
	// flash.js
      }
      else{
        flash_message("alert",["Bład usuwania punktów."]);
      }
    }
   });
  }
  
  // usuwa markery z mapy, oraz podmienia stara tablice na nowe z markerami
  function remove_checed_marker_from_map(){
    var temp =[];
    for(i in markersArray){
      if(markersArray[i].get("destroy")==1){
        markersArray[i].setMap(null);
      }
      else{
        temp.push(markersArray[i]);
      }
    }
    markersArray = temp;
    remove_markers =[];
  }
  
  // funckja odznacza wszystkie markery do usuniecia
  function clear_all_markers_to_remove(){
    $("a.clear_all_markers_to_remove").on("click",function(){
       remove_checked_markers_from_map();
    });
  }
  
  function remove_checked_markers_from_map(){
    for(i in markersArray){
      markersArray[i].set("destroy","0");
      change_marcker_icon(markersArray[i],"no");
    }
  }
  
