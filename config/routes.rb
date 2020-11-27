Rails.application.routes.draw do

  root 'phones#index'
  get 'phones/import' => 'phones#my_import'

  resources :phones do
    collection {post :import}
  end
end
