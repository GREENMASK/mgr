Mgr::Application.routes.draw do
  

  devise_for :users, 
  :controllers => { :sessions => "users/sessions",
                    :registrations => "users/registrations",
                    :passwords => "users/passwords"}

  root :to => "gpx#index"
  match '/about' ,:to => "gpx#about"
  match '/old_broswer', :to => "gpx#old_broswer"

  resources :locations do
   collection do 
    get 'load_location'
    delete 'destroy_checked'
    put 'update_location'
    get 'show_photos'
    post 'create_from_map'
    get 'check_name'
    get 'download_gpx'
   end 
 end
  
  resources :users,:only =>[:show,:index] do 
   collection do
    get 'profile'
   end
   resources :photos
  end
  
  resources :friendships, :only=>[:create, :destroy] do 
    collection do
      delete 'destroy_send_invite'
      delete 'destroy_invited'
    end
  end
end
