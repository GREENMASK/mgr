$(document).ready(function(){
  load_locations();
  show_list_locations();
  show_add_file_gpx();
  show_profile_buttons();
});

function load_locations(){
  $("select#name").on("click",function(){
     var name = $(this).find("option:selected").text();
     
     get_ajax(name);
  });
}

function get_ajax(value){

  $('div.load_gpx_name').text("");
  $('div.load_gpx_name').text("Wczytano: "+value);

  var parametr = {'name':value };
  $.ajax({
		type: 'GET',
		url: '/locations/load_location',
		data: parametr,
		contentType: 'application/json; charset=utf-8', 
		dataType: 'json',
		success: function(html) {
                 create_markers(html);// mapa.js
		},
		beforeSend: function() {
		},
		error: function() {
		}
	});  

}


function show_list_locations(){
  $("a.load_list_gpx").on("click",function(){
    $("ul.list_locations").css("display","block");
  });
}

function show_add_file_gpx(){
 $("a.add_gpx").on("click",function(){
    $("#add_gpx").css("display","block");
 });
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

