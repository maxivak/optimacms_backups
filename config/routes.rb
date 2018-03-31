OptimacmsBackups::Engine.routes.draw do
#Rails.application.routes.draw do
  scope '/'+Optimacms.config.admin_namespace do
    scope module: 'admin', as: 'admin' do
      # options
      resources :backups do
        collection do
          get 'perform'
          get 'download'
          get 'delete'
        end
      end
    end
  end
end
