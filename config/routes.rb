Rails.application.routes.draw do

  root 'static#home'

  resources :prospects,                     only: [:create],           constraints: { format: 'html' }
  resources :offers,        path: :welcome, only: [:show],             constraints: { format: 'html' }

  get 'how-we-are-different',       to: 'static#how_we_are_different',   constraints: { format: 'html' }
  get 'how-it-works',               to: 'static#how_it_works',         constraints: { format: 'html' }
  get 'features',                   to: 'static#features',             constraints: { format: 'html' }
  get 'pricing',                    to: redirect('/features')
  get 'nucleus',                    to: 'static#nucleus',              constraints: { format: 'html' }
  get 'discussions',                to: 'static#discussions',          constraints: { format: 'html' }
  get 'about',                      to: 'static#about',                constraints: { format: 'html' }
  get 'faq',                        to: 'static#faq',                  constraints: { format: 'html' }
  get 'code_of_conduct',            to: 'static#code_of_conduct',      constraints: { format: 'html' }
  get 'commitment_pledge',          to: 'static#commitment_pledge',    constraints: { format: 'html' }
  get 'thanks_guest',               to: 'static#thanks_guest',         constraints: { format: 'html' }
  get 'thanks_join',                to: 'static#thanks_join',          constraints: { format: 'html' }
  get 'thanks_activate',            to: 'static#thanks_activate',      constraints: { format: 'html' }
  get 'sponsorship',                to: 'static#sponsorship',          constraints: { format: 'html' }
  get 'foundation',                 to: 'static#foundation',           constraints: { format: 'html' }
  get 'privacy',                    to: 'static#privacy',              constraints: { format: 'html' }
  get 'terms',                      to: 'static#terms',                constraints: { format: 'html' }
  get 'quick_start',                to: 'static#quick_start',          constraints: { format: 'html' }
  get 'community_canvas',           to: 'static#community_canvas',     constraints: { format: 'html' }

  get 'members',                    to: 'static#members',              constraints: { format: 'html' }

  resources :quarks,                constraints: { format: 'html' }

  resources :pages, path: 'kb',     constraints: { format: 'html' } do
    member do
      get 'featured', to: 'pages#featured'
      put 'like',     to: 'pages#like'
      put 'dislike',  to: 'pages#dislike'
    end
  end
  resources :discussions,   constraints: { format: 'html' } do
    resources :topics,      constraints: { format: 'html' } do
      resources :posts,     constraints: { format: 'html' } do
        collection do
          post :mark_posts_read
        end
        member do
          post :mark_post_read
        end
      end
    end
    collection do
      get                   :search_results
    end
  end

  resources :events,        only: [:index, :create, :show, :update, :destroy], constraints: { format: 'html' } do
    member do
      post :clone,          to: 'events#clone'
    end
  end

  resources :classifieds,   only: [:index, :create, :update, :destroy], constraints: { format: 'html' } do
    member do
      post :ad_response,    to: 'classifieds#ad_response'
    end
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
  resources :okrs,  except: [:index]
  resources :cards, only:   [:new, :create, :destroy]

  resources :alliances do
    member do
      put     :join_alliance
      put     :add_alliance_member
      delete  :remove_alliance_member
    end
  end

  post  '/accept',              to: 'application#accept_invitation',  constraints: { format: 'html' }

  ActiveAdmin.routes(self)

  post :stripe_webhooks, to: 'cards#stripe_webhooks'

  devise_scope :user do
    get '/:username' => 'registrations#show', as: :vanity, constraints: { format: 'html'}
    # get '/:username/topics' => 'topics#index', as: :user_topics, constraints: { format: 'html'}
    put  :change_plan,                to: 'registrations#change_plan',    constraints: { format: 'html' }
    put  :declare_trait,              to: 'registrations#declare_trait',  constraints: { format: 'html' }
    put  :declare_skill,              to: 'registrations#declare_skill',  constraints: { format: 'html' }
    delete  :unset_trait,             to: 'registrations#unset_trait',    constraints: { format: 'html' }
    delete  :unset_skill,             to: 'registrations#unset_skill',    constraints: { format: 'html' }
  end

  devise_for :users, controllers: { confirmations: 'confirmations', registrations: 'registrations', sessions: 'sessions' , passwords: 'passwords' }
  as :user do
    get 'users/set_traits',         to: 'registrations#set_traits',    constraints: { format: 'html' }
    get 'users/set_skills',         to: 'registrations#set_skills',    constraints: { format: 'html' }
    get 'users/membership',         to: 'registrations#membership',    constraints: { format: 'html' }
    put 'users/confirmation',       to: 'confirmations#confirm',       constraints: { format: 'html' }
    put 'users/impersonate',        to: 'sessions#impersonate',        constraints: { format: 'html' }
    put 'users/stop_impersonating', to: 'sessions#stop_impersonating', constraints: { format: 'html' }
  end

end
