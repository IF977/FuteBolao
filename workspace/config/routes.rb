Bolao::Application.routes.draw do
  # Admin
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  
  get  '/palpites', to: 'guesses#my_guesses', as: :my_guesses
  post '/palpites', to: 'guesses#update',     as: :my_guesses_form

  get  '/meu-historico',  to: 'users#history',      as: :my_history
  get  '/perfil/:id',     to: 'users#profile',      as: :user_profile

  get  '/jogo/:id',       to: 'matches#show',       as: :match_details

  get  '/regras', to: 'rules#index', as: :rules

  root to: 'dashboard#index'
end