Rails.application.routes.draw do

  devise_for :users
  root 'static#index'

  resources :busy_intervals, only: [:index, :create, :edit, :destroy]
  get 'busy_intervals/import'
  get 'busy_intervals/destroy_all'

  resources :users, only: [:show]

  get  'interests/edit'
  post 'interests/update'
  get  'interests/map'
  get  'interests/list'
  post 'interests/toggle'

  get 'oauth/authorize'
  get 'oauth/request_access_token'

  resources :trips do
    get 'invite' => :create_invite
    post 'invite' => :send_invite
    get 'leave' => :leave
    post 'update_date_constraints' => :update_date_constraints
  end

  controller :sessions do
    get    'login'  => :new
    post   'login'  => :create
    delete 'logout' => :destroy
  end

  get 'about' => 'static#about', as: "about"

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
