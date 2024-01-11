Rails.application.routes.draw do
  post 'upload/index', to: 'upload#parse'
  get 'upload/index', to: 'upload#index'

  resources :quizzes, only: [:index, :show, :new, :create]
  get 'home/index'
  get 'upload', to: 'upload#index'

  post 'quizzes/:id', to:'quizzes#show'

  #devise_for :users

  resources :courses
  namespace :courses do
    resources :history, only: [:show]
  end

  resources :student_courses

  resources :students
  get 'students/:id/quiz', to: 'students#quiz', as: 'quiz_students'
  # config/routes.rb
  # config/routes.rb

  #get 'students/:id/add_notes', to: 'notes#new', as: 'add_notes'

  resources :students do
    resources :notes, only: [:new, :create, :edit, :update, :destroy]
    get 'students/:id/add_notes', to: 'notes#new', as: 'add_notes'
    post 'create_note/:student_id', to: 'notes#create', on: :member, as: 'create_note'
  end
  # Define a resource for students
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  # root 'home#index'

  resources :students do
    collection do
      get 'search'
      get 'getDueStudentQuiz'
    end
  end
   
  passwordless_for :users
  resources :users
  root to: 'static#index'

  get '/home', to: 'home#index'
  # devise_for :users, controllers: {
  #   registrations: 'users/registrations',
  #   sessions: 'users/sessions',
  #   omniauth_callbacks: 'users/omniauth_callbacks'
  # }
  # devise_scope :user do
  #   authenticated :user do
  #       root 'home#index', as: :authenticated_root
  #   end

  #   unauthenticated do
  #       root 'devise/sessions#new', as: :unauthenticated_root
  #   end
  # end
  # archive functionality
  resources :courses do
    member do
      get 'archive'  
    end
  end

  get '/auth/google_oauth2/callback', to: 'sessions#create'
  get 'users/auth/google_oauth2/callback', to: 'sessions#create'
  ##getting archived
  get 'archived_courses', to: 'courses#archived_courses'
  post 'courses/:id/unarchive', to: 'courses#unarchive', as: 'unarchive_course'
end
