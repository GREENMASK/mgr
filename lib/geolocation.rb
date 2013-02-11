module Geolocation
 
 # metoda separuje lokalizacje zanajdujace się min 50m od siebie.
 def self.separation(tab,range=50)
    
     range = check_range_value(range)
     new_tab=[]
     d=0
     new_tab[0]=tab[0]
     
     tab.each do |t|
      new_tab.each do |nt|
        d = distance(nt[:lat],nt[:lon],t[:lat],t[:lon])
        if d<50
          d=0
          break
        end
      end # new_tab.each
      
      if d>range
        new_tab.push(t)
      end
     end # tab.each 
     
    new_tab
  end
  
  # sprawdzam czy nie przekorczyło zakresu[50 - 1000m]
  def self.check_range_value(range)
     range  = if range > 49 && range < 1001
                 range
              elsif range <50
                    50
              elsif range > 1000
                    1000
              end
  end
  
  #metoda oblicza odleglosc miedzy współrzędnymi
  def self.distance(lat1,lng1,lat2,lng2)
    dtor = Math::PI/180
    r = 6378.14*1000

    rlat1 = lat1.to_f * dtor
    rlng1 = lng1.to_f * dtor
    rlat2 = lat2.to_f * dtor
    rlng2 = lng2.to_f * dtor
    
    nlat = rlat1 - rlat2
    nlng = rlng1 - rlng2
    
    a = power(Math::sin(nlat/2), 2) + Math::cos(rlat1) * Math::cos(rlat2) * power(Math::sin(nlng/2), 2)
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    d = r * c
  end
  
  def self.power(a,b)
    result=a**b
  end

end
