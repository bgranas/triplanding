Rails.application.routes.draw do


  devise_for :users, controllers: {registrations: 'registrations', sessions: 'sessions',
                                   omniauth_callbacks: 'omniauth_callbacks'},
                                  :path_prefix => 'd'
  #resources :users

  devise_scope :user do
    get "/login" => "sessions#new"
    get "/signup" => "registrations#new"
    get "/logout" => "sessions#destroy"
  end


  get 'beta' => 'beta#index'
  get 'beta/index' => 'beta#index', as: 'home' #creates helper home_path and home_url pointing to /beta/index
  get 'beta/about' => 'beta#about', as: 'about' #creates helper about_path and about_url pointing to /beta/about
  get 'beta/help' => 'beta#help', as: 'help' #creates help_path and help_url pointing to /beta/help
  get 'beta/blog' => 'beta#blog', as: 'blog' #creates blog_path and blog_url pointing to /beta/blog
  get 'beta/contact' => 'beta#contact', as: 'contact' #creates contact_path and contact_url pointing to /beta/contact
  get 'beta/how_it_works' => 'beta#how_it_works', as: 'how_it_works' #creates how_it_works_path and how_it_works_url pointing to /beta/how_it_works
  get 'beta/policies' => 'beta#policies', as: 'policies' #creates policies_path and policies_url pointing to /beta/policies
  get 'beta/privacy' => 'beta#privacy', as: 'privacy' #creates privacy_path and privacy_url pointing to /beta/privacy
  get 'beta/terms' => 'beta#terms', as: 'terms' #creates terms_path and terms_url pointing to /beta/terms
  get 'leads' => 'leads#index' #creates leads_path and leads_url pointing to /leads/index
  get 'admin' => 'admin#index' #creates admin_path and admin_url pointing to /admin/index
  get 'admin/users' => 'admin#all_users' #creates admin_users_path and admin_users_url pointing to /admin/all_users
  get 'trips/new' => 'trips#new' #creates trips_new_path and trips_new_url pointing to /trips/new/
  get '/blank/add_destination_helper' => 'blank#add_destination_helper', as: 'add_destination_lightbox'
  get 'blank/snapshot_demo' => 'blank#snapshot_demo'
  get 'destinations' => 'destinations#index', as: 'destinations'

  #for capturing information after signup
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  #for creating or updating destinations
  match "/destinations" => "destinations#create", :via => [:post, :patch], :as => :create_destination

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

   #matching profile_url
  match "/:profile_url" => "users#show", :via => [:get]

  #Default as specified in Lynda
  match ':controller(/:action(/:id))', :via => [:get, :post] #---!!!!! DANGER !!!! SHOULD REPLACE

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
