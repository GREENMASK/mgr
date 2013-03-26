require 'rubygems'
require 'libxml'

module Gpx
 
 def self.creator(data)

   doc  = XML::Document.new
   doc.root = XML::Node.new("gpx")
   root = doc.root
   root.attributes['creator'] = "gpx.pl"
   root.attributes['version'] ='1.0'
   root.attributes['xmlns']="http://www.topografix.com/GPX/1/0"
   root.attributes['xmlns:xsi']="http://www.w3.org/2001/XMLSchema-instance"

   i=0# kolejny numer w nazwie gpx/wpt/name
   data.each do |d|
	  wpt  = XML::Node.new("wpt")
      wpt.attributes['lat']=d.lat.to_s
   	  wpt.attributes['lon']=d.lat.to_s
    ele  = XML::Node.new("ele")
      wpt << ele 
        ele.content="0.000000"
    time = XML::Node.new("time")
      wpt << time
        time.content=d.created_at.to_time.to_s
    name = XML::Node.new("name")
      wpt << name
        name.content="#{d.name}_#{i}" 
    desc = XML::Node.new("desc")
      wpt << desc
        desc.content=""
    sym  = XML::Node.new("sym")
      wpt << sym
        sym.content ="Waypoint"
    
   	root << wpt
    i=i+1
   end

   doc
 end

end
