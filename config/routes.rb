Mgr::Application.routes.draw do
  devise_for :users, 
  :controllers => { :sessions => "users/sessions",
                    :registrations => "users/registrations" }

  root :to => "gpx#index"
  match '/about' ,:to => "gpx#about"
  
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
  
  resources :user,:only =>[:show], :path =>"users" do 
   collection do
    get 'profile'
   end
   resources :photos
  end

end
