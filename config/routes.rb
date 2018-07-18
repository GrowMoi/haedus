Moi::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "api/registrations" }

  namespace :api, defaults: { format: :json } do
    resource :tree, only: :show
    resource :learn, controller: :learn, only: :create
    resources :tutor_plans, only: :index
    resources :search, only: :index
    resources :content_preferences, only: :update
    resources :sharings, only: :create
    resource :order_preferences, controller: :order, only: :update
    resources :quizzes, only: [] do
      resources :players,
                only: [:show] do
        member do
          post :answer
        end
      end
    end
    resources :notifications, only: [] do
      collection do
        get :index
      end
      member do
        post :read_notifications
        get :open
      end
    end
    resources :achievements, only: [] do
      collection do
        get :index
      end
    end
    resources :leaderboard, only: [] do
      collection do
        get :index
      end
    end
    resources :user_tutors, only: [] do
      member do
        post :respond
      end
    end
    resources :neurons,
              only: [:index, :show] do
      resources :recommended_contents,
                only: :show
      resources :contents,
                only: [:show] do
        member do
          post :read
          post :notes
          post :media_open
          post :tasks
          post :task_update
          post :reading_time
          post :favorites
        end
      end
    end

    resources :analytics,
                only: [:statistics] do
      collection do
        get :statistics
      end
    end

    resource :payments, only: [] do
      member do
        post :tutor_basic_account
        post :add_students
      end
    end

    resources :tutors, only: [] do
      collection do
        get :recommendations
        get :details
      end
    end

    namespace :users do
      resource :account,
                only: [:update]
      resource :tree_image,
                only: [:update]
      resource :profile,
                only: [:show]
      resource :recommended_neurons,
                only: [:show]
      resource :storage, only: [:show] do
        member do
          put :update
        end
      end
      resource :shared_contents, only: [] do
        collection do
          post :send
        end
      end
      resources :achievements, only: [:index] do
        member do
          put :active
        end
      end
      resources :final_test, only: [:create, :show] do
        member do
          post :answer
        end
      end
      resources :certificates, except: [:update, :edit]
    end

    match "users/search" => 'users#search', via: :get
    match "users/content_tasks" => 'users#content_tasks', via: :get
    match "users/content_notes" => 'users#content_notes', via: :get
    match "users/content_favorites" => 'users#content_favorites', via: :get
    match "users/shared_contents" => 'users#shared_contents', via: :post

    resources :users,
              only: [] do
      member do
        get :profile
      end
    end

    devise_scope :user do
      post "auth/user/key_authorize", to: "sessions#key_authorize"
    end

    namespace :auth do
      mount_devise_token_auth_for(
        "User",
        at: "user",
        controllers: {
          sessions: "api/sessions",
          token_validations: "api/token_validations",
          registrations: "api/registrations"
        }
      )
    end
  end

  namespace :admin do
    resource :dashboard, only: :index
    resources :users
    resources :profiles
    resources :notifications
    resources :quizzes
    resources :level_quizzes
    resources :achievements, except: [:create, :destroy]
    resources :admin_achievements, except: [:create, :destroy]

    # settings
    resources :settings, only: :index
    resources :search_engines, except: [:index, :destroy]

    # preview
    match "neurons/preview" => "neurons/preview#preview",
          via: [:post, :patch],
          as: :neuron_preview

    resources :neurons do
      resource :log, module: "neurons",
                     only: :show
      member do
        post :delete
        post :restore
      end
      collection do
        get :sort
        get :sorting_tree
        post :reorder
      end
    end

    resource :external_search, only: :create

    resources :contents do
      member do
        post :approve
      end
    end
    resources :content_importings

    root "dashboard#index"
  end

  namespace :tutor do
    resources :moi, only: :index
    resources :client, only: :index do
      collection do
        get :get_client_statistics
      end
    end
    resources :analysis, only: :index do
      collection do
        get :get_user_analysis
      end
    end
    resources :tree, only: :index
    resources :user_tutors, only: [:new, :create, :destroy, :delete] do
      member do
        put :remove_user
      end
    end
    resources :recommendations, only: [:new, :create] do
      collection do
        post :new_achievement
      end
    end
    resources :report, only: :index do
      collection do
        get :root_contents_learnt
        get :tutor_users_contents_learnt
        get :analytics_details
        get :time_reading
      end
    end
    resources :dashboard, only: [:index] do
      collection do
        get :achievements
        post :new_achievement
        put :update_achievement
        get :students
        get :get_clients
        get :download_tutor_analytics
        get :get_contents
        post :send_notification
        get :get_level_quizzes
        get :get_questions
        post :create_quiz
      end
    end

    resources :profile, only: [:index] do
      collection do
        get :info
        put :update_password
        put :update
      end
    end

    resources :notifications, only: [:index] do
      member do
        get :details
        delete :remove
      end
      collection do
        get :info
      end
    end

    root "dashboard#index"
  end

  resources :public_sharing, only: :show, path: "s"

  match "/delayed_job" => DelayedJobWeb,
        anchor: false,
        via: [:get, :post]

  root to: redirect("/apipie")
  apipie
end
