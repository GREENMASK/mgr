class Location < ActiveRecord::Base
  require 'xml/libxml'
  require 'xml'
  require 'pp'

  include Geolocation # ./lib/geolocation.rb
  
  belongs_to :user
  has_many :photos
  
  #attr_accessible :name,:lat,:lng,:user_id
  attr_accessor :gpx,:range

  
  #walidacje
  validates :name,    presence: true
  validates :lat,     presence: true
  validates :lng,     presence: true
  validates :user_id, presence: true
  
  #zapisywanie współrzednych gps z pliku gxp
  def save_location(gpx2)
    file_name = gpx2[:name].downcase.to_s
    return false unless file_submited?(gpx2) && file_name_exist?(file_name) && user_loaction_exist?(file_name)
    file = read_file(gpx2)
    hash = gpx_to_hash(file)
    return false unless hash
    return false unless correct_hash?(hash)
    new_hash = Geolocation.separation(hash,gpx2[:range].to_i)
      Location.transaction do 
        new_hash.each do |nh|
        Location.create(:name => file_name,
                      :lat=>nh[:lat],
                      :lng=>nh  [:lon],
                      :user_id => self.user.id )
        end
      end
  end
  
  #usuwanie pliku gpx dla danego użytkownika
  def self.with_name(value)
    where(name: value)
  end
  
    #usuwamy zaznaczone prze user'a punkty
  def self.destroy_checekd_location(tab)
    Location.transaction do
      tab.each do |t|
        begin
          Location.find(t).delete
        rescue ActiveRecord::RecordNotFound
          false
        end
      end
    end
  end
  
  # dodaje do istniejacego pliku nowe współrzedne
  def self.update_old_location_file(string)
    
    string[0]=""
    string[string.size - 1]=""
     
    json = begin
      JSON.parse(string.gsub("\\\"","\""))
    rescue  JSON::ParserError
      false 
    end
    
     return false unless json
     name = json["name"]

     Location.transaction do 
       json["locations"].each do |l|
         Location.create(:name=> name,
                         :lat => l[1]["lat"].to_f,
                         :lng => l[1]["lng"].to_f)
       end
     end
  end
  
  # tworzy nowa grupe wspórzednych na podsatwie mapy
  def self.create_new_file_from_map(string)
    
    string[0]=""
    string[string.size - 1]=""
     
    json = begin
      JSON.parse(string.gsub("\\\"","\""))
    rescue  JSON::ParserError
      false 
    end
    
    return false unless json
    name = json["name"]
        
    Location.transaction do 
    json["locations"].each do |l|
      Location.create(:name=> name,
                         :lat => l[1]["lat"].to_f,
                         :lng => l[1]["lng"].to_f)
      end
    end
  end
  
  
  private 
  
  # sprawdzam czy plik został wysłany
  def file_submited?(file)
   return true if (!file[:gpx].nil?)
   errors.add(:gpx, "Nie wybrano pliku GPX!" )
   false
  end
  
  #sprawdza czy nazwa pliku nie jeste pusta
  def file_name_exist?(name)
    return true if !name.blank?
    errors.add(:name, "Nazwa nie moze byc pusta!")
    false
  end
  
  # sprawdza czy dany user posiada współrzedne o takiej nazwie
  def user_loaction_exist?(name)
    return true if self.user.location_exist?(name)
    errors.add(:name, "Wspolrzedne o podanej nazwie istnieja" )
    false
  end
   #zczytuje plik xml
  def read_file(gpx)
    gpx[:gpx].read
  end
  
  #zamieniam plik na hash wyodrebniajac zakladke wpt
  def gpx_to_hash(file)
   data = begin
      Hash.from_xml(file).with_indifferent_access[:gpx][:wpt]
    rescue
      false
    end
  end
  
  def correct_hash?(tab)
    s = true
    tab.each do |t|
       s = t.is_a?(Hash)
    end
    s
  end
end
