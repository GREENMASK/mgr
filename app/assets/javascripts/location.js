$(document).ready(function(){
  load_locations();
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
  $("ul.list_locations").css("display","none");
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

