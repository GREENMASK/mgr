
function start_move_marker(object){
  $("a.start_move_marker").on("click",function(){
    object.setDraggable(true);
  });
}

function update_move_marker_position(object){
  $("a.update_move_marker_position").on("click",function(){
    update_marker_position(object);

  });
}

function update_marker_position(object){
  var data = {"position":{
    "lat":object.getPosition().lat(),
    "lng":object.getPosition().lng()
  }};
  $.ajax({
    url: '/locations/'+object.get("id").toString(),
    type: 'PUT',
    dataType:'json',
    data:data,
    success:function(json){
      action_after_update_marker(json.odp,object)
    }
  })
}

function action_after_update_marker(odp,object){
  if(odp == "ok"){
    object.setDraggable(false);
  }
}
