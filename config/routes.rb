Sibjob::Application.routes.draw do
  devise_for :siblings

  resources :job_records

  authenticate :sibling do
    resources :siblings do
      member do
        get :jobs
      end
    end
  end

  get "pages/home"

  get "pages/contact"

  match '/contact', :to => 'pages#contact'

  root :to => "pages#home"
end
