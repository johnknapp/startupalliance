Rails.application.routes.draw do

  root 'pages#home'
  resources :companies do
    member do
      put     :add_team_member
      delete  :remove_team_member
      put     :set_sakpi
      delete  :unset_sakpi
    end
  end
  resources :alliances do
    member do
      put     :add_member
      delete  :remove_member
    end
  end
  resources :okrs

  get 'activate_thanks',            to: 'pages#activate_thanks',      constraints: { format: 'html' }
  get 'faq',                        to: 'pages#faq',                  constraints: { format: 'html' }
  get 'join_thanks',                to: 'pages#join_thanks',          constraints: { format: 'html' }
  get 'matt_sandbox',               to: 'pages#matt_sandbox',         constraints: { format: 'html' }

  devise_scope :user do
    get '/:username' => 'registrations#show', as: :vanity, constraints: { format: 'html'}
    put  :declare_trait,              to: 'registrations#declare_trait',  constraints: { format: 'html' }
    put  :declare_skill,              to: 'registrations#declare_skill',  constraints: { format: 'html' }
    delete  :unset_trait,             to: 'registrations#unset_trait',    constraints: { format: 'html' }
    delete  :unset_skill,             to: 'registrations#unset_skill',    constraints: { format: 'html' }
  end

  devise_for :users, controllers: { confirmations: 'confirmations', registrations: 'registrations', sessions: 'sessions' , passwords: 'passwords' }
  as :user do
    put 'users/confirmation',       to: 'confirmations#confirm',       constraints: { format: 'html' }
    put 'users/impersonate',        to: 'sessions#impersonate',        constraints: { format: 'html' }
    put 'users/stop_impersonating', to: 'sessions#stop_impersonating', constraints: { format: 'html' }
  end

end
