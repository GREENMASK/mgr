var newMarkersArray=[];

$(document).ready(function(){
  start_action_create();
  add_new_markers();
  clear_all_new_markers();
  save_new_file_on_base();
})

// funkcja wyłącza funkcje dodwania nowych pkt na mapie
function remove_action_add_new_markers(){
  google.maps.event.clearListeners(mapa,'click');
}

function start_create_new_point(){
  if(typeof(handle)=="object"){
      clear_action_on_markers();
    }
  deleteOverlays();//mapa.js
  
  var str = $("div.load_gpx_name").text("");
  google.maps.event.addListener(mapa,'click',function(event){
      create_new_location(event);
  });
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
     if($('div.load_gpx_name').text().length > 0){
       put_update_new_markers();
     }
     else{
       get_new_name_to_gpx_file();
     }
     
  });
}

function get_new_name_to_gpx_file(){
         $.fancybox( body_fancybox(),
		{  
		  'autoDimensions'	: false,
			'width'           : 350,
			'height'          : 'auto',
			'transitionIn'		: 'none',
			'transitionOut'		: 'none',
			'showCloseButton'	: true,
			'onComplete'      : function(content){
			  show_input_value();
			}
		}
	);
}

function body_fancybox(){
  var str="";
  str = "<spam class='new_name'>Name:</spam></br>";
  str = str + '<input type="text" name= "new_name" class="new_file_name"></input><spam class="answer"> </spam></br>';
  str = str + '<input type="submit" value="Zapisz" name="save_new_file" disabled ="disabled">'
 
 return str;
}

///
var time = null;
function show_input_value(){
  $("input[name='new_name']").keyup(function(e){
      $("input[name='save_new_file']").attr('disabled',true);
      if(time !=null){
        clearTimeout(time);
      }
      time = setTimeout(function(){
        time =null;
        check_name_on_base($("input[name='new_name']").val());
      },2000);
  });
}
// sprawdza czy podana nazwa nowego pliku nie istnieje w bazie
function check_name_on_base(name){
  $.ajax({
   type:'GET',
   url:'/locations/check_name',
   data:{'name': name},
   dataType: 'json',
   success: function(json){
     if(json["odp"]=="wrong"){
       $("spam.answer").css("color","red");
       $("spam.answer").text("Name istnieje.");
     }
     if(json["odp"]=="ok"){
       $("spam.answer").css("color","green");
       $("spam.answer").text("Ok");
       $("input[name='save_new_file']").attr('disabled',false);
       save_new_file_on_base(name);
     }
   }
  });
}

function save_new_file_on_base(name){
  $("input[name='save_new_file']").on("click",function(){
    post_create_new_gpx_file(name);
  });
}

function create_data_to_update(name2){

  var name="";
  if(name2 == ""){
    name = $('div.load_gpx_name').text().split(': ')[1].toString();
  }
  else{
   name = name2;
  }
  
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

  return data;
}


function put_update_new_markers(){

  if(newMarkersArray.length > 0){
     var tab = create_data_to_update("");
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

function post_create_new_gpx_file(name){
  if(newMarkersArray.length > 0){
     var tab = create_data_to_update(name);
    $.ajax({
            traditional:true,
            url:'/locations/create_from_map',
            type:'POST',
            dataType:'json',
            data:{'data':tab},
            success: function(data){
                      after_create_new_locations(data,name);
            }
  });
  }
  else{
    $("spam.answer").css("color","red");
    $("spam.answer").text("Brak punktów na mapie!");
  }
}

function after_create_new_locations(data,name){
  if(data["odp"] == "ok"){
    clear_new_markers_from_map();
    get_ajax(name);// location.js
    $.fancybox.close();
    $("spam.new_gpx_points").css("display","none");
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
