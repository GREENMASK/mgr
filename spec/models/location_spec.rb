require 'spec_helper'
require 'faker'
include ActionDispatch::TestProcess

describe Location do 
 
 describe "Validations" do 
   context "success" do 
     before(:each) do
       @location = FactoryGirl.build(:location)
     end
    it{@location.should be_valid}
   end
   
   context "failed" do 
     before(:each) do 
       @location = FactoryGirl.create(:location) 
     end
     
     it "empty name" do 
       @location[:name]= nil
       @location.should_not be_valid 
     end
     
     it "empty lat" do 
       @location[:lat]= nil
       @location.should_not be_valid
     end
     
     it "empty lng" do 
       @location[:lng]= nil
       @location.should_not be_valid
     end
     
     it "empty user_id" do 
       @location[:user_id] = nil
       @location.should_not be_valid
     end
   end
 end
  
 describe "destroy_checekd_location" do 
   before(:each) do 
     (1..5).each do 
       FactoryGirl.create(:location)
     end
   end
   
   it "count should be equal 5" do
      Location.all.count.should be_eql(5)
   end
  
   it "delete 2 locations" do
     expect{Location.destroy_checekd_location([1,2])}.should change(Location,:count).by(-2)
   end
   
   it "should not be delete" do
     expect{Location.destroy_checekd_location([6])}.should change(Location,:count).by(0)
   end
 end
 
 describe "update_old_location_file" do 
    before(:each) do 
      @user = FactoryGirl.create(:user)
      @str = create_json_string
    end
    
    it "should be create new 3 point" do
       expect{@user.locations.update_old_location_file(@str)}.should change(Location,:count).by(3)
    end
    
    it "should no be create any point,wrong string" do
      expect{@user.locations.update_old_location_file("wrong")}.should_not change(Location,:count)
    end
    
 end
 
 describe "save_location" do 
   before(:each) do 
     @user = FactoryGirl.create(:user)
     @location = FactoryGirl.build(:location)
     @gpx={}
     @gpx[:gpx] = fixture_file_upload('/file.gpx')
     @gpx[:name] = "name"
     @gpx[:range]= 50
   end
   
   it "should create 4 points" do
     @data = @user.locations.new
     expect{@data.save_location(@gpx)}.should change(Location ,:count)
     
   end
   
 end
 
 
 # file gpx/string_json
 def create_json_string
   str = "\"{\\\"name\\\":\\\"clementine\\\",\\\"locations\\\":{ \\\"position0\\\":{\\\"lat\\\":\\\"38.676933444637925\\\",\\\"lng\\\":\\\"-121.2945556640625\\\"},\\\"position1\\\":{\\\"lat\\\":\\\"38.67907761983558\\\",\\\"lng\\\":\\\"-120.99517822265625\\\"},\\\"position2\\\":{\\\"lat\\\":\\\"38.71551876930462\\\",\\\"lng\\\":\\\"-120.6134033203125\\\"}}}\""
 end
 
 
 def create_gpx_file
  gpx ='<gpx xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.topografix.com/GPX/1/0" xmlns:topografix="http://www.topografix.com/GPX/Private/TopoGrafix/0/2" version="1.0" creator="ExpertGPS 1.2 - http://www.topografix.com" xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd http://www.topografix.com/GPX/Private/TopoGrafix/0/2 http://www.topografix.com/GPX/Private/TopoGrafix/0/2/topografix.xsd">
<time>2003-02-05T19:17:02Z</time>
<bounds minlat="38.625526" minlon="-121.516943" maxlat="38.937285" maxlon="-121.011830"/>
<wpt lat="38.916370006" lon="-121.035340039">
<ele>182.775024</ele>
<time>2003-02-05T18:19:15Z</time>
<name>CLEMEN TR</name>
<desc>CLEMEN TR</desc>
<sym>Trail Head</sym>
<type>Trail Head</type>
</wpt>
<wpt lat="38.920639999" lon="-121.012300031">
<ele>313.993896</ele>
<time>2003-02-05T18:19:15Z</time>
<name>CONFL TR</name>
<desc>CONFL TR</desc>
<sym>Trail Head</sym>
<type>Trail Head</type>
</wpt>
<wpt lat="38.932889983" lon="-121.011829974">
<ele>437.041748</ele>
<time>2003-02-05T18:19:15Z</time>
<name>CULVERT TR</name>
<desc>CULVERT TR</desc>
<sym>Trail Head</sym>
<type>Trail Head</type>
</wpt>
<wpt lat="38.905900003" lon="-121.055939991">
<ele>371.912964</ele>
<time>2003-02-04T21:14:35Z</time>
<name>MANZANITA</name>
<desc>MANZANITA</desc>
<sym>Trail Head</sym>
<type>Trail Head</type>
</wpt>
<wpt lat="38.911470029" lon="-121.054369977">
<ele>405.318481</ele>
<time>2003-02-04T21:14:35Z</time>
<name>STAGECOACH</name>
<desc>STAGECOACH</desc>
<sym>Trail Head</sym>
<type>Trail Head</type>
</wpt>
</gpx>' 
 end
end
