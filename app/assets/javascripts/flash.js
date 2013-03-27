function flash_message(type,msg){

  var str = "<ul class='"+ type +"'>";
      for(i in msg){
        str +="<li>"+ msg[i] +"</li>";
      }
  $("div#info").show();
  $("div#info").html(str);
  $("div#info").delay(10000).fadeOut(400);
}
