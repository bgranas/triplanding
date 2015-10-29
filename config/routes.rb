Rails.application.routes.draw do


  devise_for :users, controllers: {registrations: 'registrations', sessions: 'sessions'}, :path_prefix => 'd'
  #resources :users

  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end

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
  get 'users' => 'users#index' #creates users_path and users_url pointing to /users/index
  get 'admin' => 'users#index' #creates admin_path and admin_url pointing to /users/index




  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
