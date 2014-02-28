Inquestion::Application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  get 'elements' => 'application#elements'

  resources :questions do
    resources :answers do
      resources :comments
    end
    post 'vote' => 'questions#vote', as: :do_vote
    resources :comments
  end

  resources :users do
    put 'update/employer' => 'users#update_employer', as: :update_employer
    put 'update/assessor' => 'users#update_assessor', as: :update_assessor
    put 'update/coordinator' => 'users#update_coordinator', as: :update_coordinator
    get 'make/assessor' => 'users#make_assessor', as: :make_assessor
    get 'make/coordinator' => 'users#make_coordinator', as: :make_coordinator
    get 'make/user' => 'users#make_user', as: :make_user
    get 'ban' => 'users#ban', as: :ban
    post 'tags' => 'users#update_knowledge', as: :update_knowledge
  end
  resources :employers do
    resources :users
  end

  resources :tags

  root 'application#index'
  get 'about' => 'application#about', as: :about_page
  get 'terms' => 'application#terms', as: :terms_page
  get 'privacy' => 'application#privacy', as: :privacy_page

  get 'notifications/check' => 'notifications#check', as: :notification_check
  get 'notifications' => 'notifications#index', as: :notification_index
  post 'notifications/clear' => 'notifications#clear', as: :notification_clear

  namespace :admin do
    get '/' => 'admin#admin', as: :index
    resources :users
    resources :questions
    resources :employers
  end


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
