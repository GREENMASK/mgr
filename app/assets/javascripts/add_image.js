//funkcja uruchamia akcje dodania fotografi pod danymi współrzednymi
function position_image_function(object){
  $("a.add_image_postion").on("click",function(){
      action_on_markers("get_image_position");
      $("div#overlay").css("display","block");
      $("div#add_image").css("display","block");
      $("input#photo_location_id").val(object.get("id"));
  });
}


$(document).ready(function(){
  close_overlay();
})

function close_overlay(){
  $(".close_overlay").on("click",function(){
    $("div#overlay").css("display","none");
  });
}
