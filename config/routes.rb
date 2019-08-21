Workarea::Storefront::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    resource :search, only: :show do
      member do
        get :content
      end
    end
  end
end
