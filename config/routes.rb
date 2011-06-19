Sibjob::Application.routes.draw do
  devise_for :parents

  devise_for :siblings

  resources :job_records
  resources :jobs

  resources :parents

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
