//funkcja uruchamia akcje dodania fotografi pod danymi współrzednymi
function position_image_function(object){
  $("a.add_image_postion").on("click",function(){
      $.fancybox({
	'content': $("div#add_image").html()
      });
      $("input#photo_location_id").val(object.get("id"));
  });
}
