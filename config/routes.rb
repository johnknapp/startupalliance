Rails.application.routes.draw do

  resources :alliances
  resources :okrs
  resources :companies
  root 'pages#home'

  get 'activate_thanks',            to: 'pages#activate_thanks',      constraints: { format: 'html' }
  get 'faq',                        to: 'pages#faq',                  constraints: { format: 'html' }
  get 'join_thanks',                to: 'pages#join_thanks',          constraints: { format: 'html' }

  devise_for :users, controllers: { confirmations: 'confirmations', registrations: 'registrations', sessions: 'sessions' , passwords: 'passwords' }
  as :user do
    put 'users/confirmation',       to: 'confirmations#confirm',       constraints: { format: 'html' }
    put 'users/impersonate',        to: 'sessions#impersonate',        constraints: { format: 'html' }
    put 'users/stop_impersonating', to: 'sessions#stop_impersonating', constraints: { format: 'html' }
  end

  devise_scope :user do
    get '/:username' => 'registrations#show', as: :vanity, constraints: { format: 'html'}
  end

end
