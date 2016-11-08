Rails.application.routes.draw do

  # optimacms devise
  devise_for :cms_admin_users, Optimacms::Devise.config


  get 'debug/:action', to: 'debug#action'


  # for names
  root to: "home#index"


  mount OptimacmsBackups::Engine => "/", :as => 'cms_backups'

  # !!! LAST row
  mount Optimacms::Engine => "/", :as => "cms"
end
