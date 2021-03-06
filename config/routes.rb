Rails.application.routes.draw do
  get 'borrows' => 'borrows#index', as: :borrows
  delete 'borrows/:id' => 'borrows#delete', as: :borrow
  get 'borrows/confirm/:id' => 'borrows#confirm', as: :confirm_borrow

  resources :books
  root 'home#index'
  get 'books/update_from_douban/:id' => 'books#update_from_douban', as: :update_from_douban
  get 'books/return_back/:id' => 'books#return_back', as: :return_back
  devise_for :users

  namespace :api do
    get 'books' => 'mobile#books'
    get 'book' => 'mobile#book'
    post 'borrow/:id' => 'mobile#borrow'
  end
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
