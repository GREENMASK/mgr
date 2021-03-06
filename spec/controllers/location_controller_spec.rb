require 'spec_helper'
require 'faker'

describe LocationsController do 
 
    before(:each) do
     @user = FactoryGirl.create(:user)
     @location1 = FactoryGirl.create(:location)
   end
   
 describe "load_location" do 
 
   it "should get locations" do
     sign_in @user
     xhr :get, :load_location, :name => "name1", :format=>:js
     response.status.should be(200)
   end
   
   
   it "should not get location" do 
     sign_in @user
     xhr :get, :load_location, :name => "wrong", :format =>:js
     response.body.should be_eql("[]")
     response.status.should be(200)
   end
 end
 
 describe "create" do 
   before(:each) do 
     sign_in @user
     @gpx ={}
     @gpx[:range] = 50
     @gpx[:name] = "name"
   end
   
   it "should be create" do
     @gpx[:gpx] =  fixture_file_upload('/file.gpx')
     expect{post :create, 
           :location => @gpx}.should change(Location,:count)
   end
   
   it "should not be create" do
     @gpx[:gpx] =  fixture_file_upload('/wrong.gpx') 
     expect{post :create, 
            :location => @gpx}.should_not change(Location,:count)
   end
 end
 
 describe "destroy" do 
   before(:each) do 
     sign_in @user
   end
   
   it "should be success" do 
     expect { delete :destroy, 
              :id => @location1.name }.should change(Location,:count)
   end
   
   it "should not be success" do 
     expect { delete :destroy, 
              :id => "wrong" }.should_not change(Location,:count)
   end
 end
 
 describe "destroy checked" do 
    before(:each) do 
      sign_in @user
      @locs=[]
      (1..5).each do |u|
        @locs[u] = FactoryGirl.create(:location)
      end
    end
    
    it "should destroy two point" do 
      expect{ delete :destroy_checked, 
      :markers => "#{@locs[1].id},#{@locs[2].id}"}.should change(Location, :count).by(-2)
    end
    
    it "should destroy one point" do 
      expect{ delete :destroy_checked,
      :markers =>"#{@locs[4].id}"}.should change(Location,:count).by(-1)
    end
    
    it "should not destroy any point" do 
      expect{ delete :destroy_checked,
      :markers =>""}.should_not change(Location, :count)
    end
 end
 
 describe "update_location" do 
 
   before(:each) do 
     sign_in @user
   end
   
   it "should update old gpx" do 
     expect{put :update_location,
            :data => update_data_location}.should change(Location,:count).by(4)
   end
   
   it "should not update old gpx" do 
     expect{put :update_location,
            :data => ""}.should_not change(Location, :count)
   end
 end
 
 
 def update_data_location
   data = "{\"name\":\"#{@location1.name }\",\"locations\":{ \"position0\":{\"lat\":\"43.80009302166679\",\"lng\":\"-116.06060028076172\"},\"position1\":{\"lat\":\"43.82412443010574\",\"lng\":\"-116.00566864013672\"},\"position2\":{\"lat\":\"43.80455318899776\",\"lng\":\"-115.99571228027344\"},\"position3\":{\"lat\":\"43.795632521357085\",\"lng\":\"-116.04000091552734\"}}}"
 end
end
