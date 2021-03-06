Rails.application.routes.draw do

  post '/login' => 'login#login'

  patch '/edit_profile' => 'users#update'
  post '/change_password' => 'users#update_password'
  post '/change_privacy' => 'users#update_privacy'
  
  get '/events/:index' => 'events#index'
  post '/events' => 'events#create'
  post '/events/:id/toggle_assistance' => 'events#toggle_assistance'
  post '/addEventPic' => 'events#add_event_pic'

  get '/profile/:id' => 'profile#show'
  post '/profile/:id/toggle_follow' => 'profile#toggle_follow'
  post '/addProfilePic' => 'profile#add_profile_pic'
  post '/removeProfilePic' => 'profile#remove_profile_pic'
 
  get '/notifications' => 'notifications#show'
  post '/notifications/:id/accept_request' => 'notifications#accept_request'
  post '/notifications/:id/decline_request' => 'notifications#decline_request'



  # with_options except: [:new, :edit] do |api_methods|
  #   api_methods.resources :events
  #   api_methods.resources :users
  # end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
