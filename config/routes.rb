Rails.application.routes.draw do

  root 'static#home'

  get 'nucleus',                    to: 'static#nucleus',              constraints: { format: 'html' }
  get 'faq',                        to: 'static#faq',                  constraints: { format: 'html' }
  get 'code_of_conduct',            to: 'static#code_of_conduct',      constraints: { format: 'html' }
  get 'join_thanks',                to: 'static#join_thanks',          constraints: { format: 'html' }
  get 'activate_thanks',            to: 'static#activate_thanks',      constraints: { format: 'html' }
  get 'pricing',                    to: 'static#pricing',              constraints: { format: 'html' }
  get 'privacy',                    to: 'static#privacy',              constraints: { format: 'html' }
  get 'terms',                      to: 'static#terms',                constraints: { format: 'html' }
  get 'learn_more',                 to: 'static#learn_more',           constraints: { format: 'html' }
  get 'quick_start',                to: 'static#quick_start',          constraints: { format: 'html' }
  get 'community_canvas',           to: 'static#community_canvas',     constraints: { format: 'html' }

  get 'members',                    to: 'static#members',              constraints: { format: 'html' }

  resources :pages, path: 'nucleus/kb' do
    member do
      post :undo,                 to: 'pages#undo_last_audit'
    end
  end

  # resources :discussions, except: [:index],        constraints: { format: 'html' } do
  #   resources :comments,  except: [:index],        constraints: { format: 'html' }
  # end

  resources :discussions do
    resources :comments
  end

  resources :conversations, only: [:index, :create, :destroy],        constraints: { format: 'html' } do
    resources :messages,    only: [:index, :new, :create, :destroy],  constraints: { format: 'html' }
  end

  resources :companies do
    member do
      get     :dashboard
      put     :add_team_member
      put     :update_team_member
      delete  :remove_team_member
      put     :set_sakpi
      delete  :unset_sakpi
    end
  end

  resources :fasts, except: [:index, :show]
  resources :okrs, except: [:index]

  resources :alliances do
    member do
      put     :add_alliance_member
      delete  :remove_alliance_member
    end
  end

  post  '/accept',              to: 'application#accept_invitation',  constraints: { format: 'html' }
  ActiveAdmin.routes(self)

  devise_scope :user do
    get '/:username' => 'registrations#show', as: :vanity, constraints: { format: 'html'}
    put  :change_plan,                to: 'registrations#change_plan',    constraints: { format: 'html' }
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

  mount StripeEvent::Engine, at: 'stripe_webhooks'

end
