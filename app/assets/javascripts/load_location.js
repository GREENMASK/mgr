$(document).ready(function(){
  load_locations();
});

function load_locations(){
  $("select#name").on("click",function(){
     var name = $(this).find("option:selected").text();
     var path_tab =location.pathname.split("/");
     get_ajax(name,path_tab[2]);
  });
}

function get_ajax(value,id){

  $('div.load_gpx_name').text("");
  $('div.load_gpx_name').text("Wczytano: "+value);
  $("ul.list_locations").css("display","none");
  var parametr = {'name':value,'user_id':id };
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

