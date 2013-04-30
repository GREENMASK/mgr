
function load_marker_photo(object){
  $("a.load_marker_photo").on("click",function(){
    get_marker_photo(object);
  });
}

function get_marker_photo(object){
  var path_tab =location.pathname.split("/");
  $.ajax({
    url:'/locations/show_photos',
    type:'GET',
    dataType:'json',
    data:{'id':object.id,'user_id':path_tab[2] },
    success:function(json){
      show_marker_gallery(json);
    }
  });
}

function show_marker_gallery(json){

  var list = create_images_list(json);
  $.fancybox(list,
    {
      'padding'       : 0,
      'transitionIn'  : 'none',
      'transitionOut' : 'none',
      'type'          : 'image',
      'changeFade'    : 0  
    });
}

function create_images_list(json){
 var str = [];
 for(i in json["data"]){
   str.push(json.data[i].url.toString());
 }
 return str;
}
