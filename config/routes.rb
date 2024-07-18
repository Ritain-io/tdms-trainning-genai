# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  authenticate :admin_user, lambda(&:present?) do
    mount Sidekiq::Web => '/sidekiq'
    mount Maily::Engine, at: '/maily' unless Rails.env.test?
  end

  concern :api_endpoints do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'users/registrations',
      sessions:      'users/sessions',
      passwords:     'users/passwords'
    }
  end

  namespace :api do
    scope :v1, module: 'v1', as: 'v1' do
      concerns :api_endpoints

      resources :addresses, only: %i[index show create update] do
        delete :delete, on: :collection
        get :basic_info, on: :collection
        post :import, on: :collection
        get :get_graph, on: :collection
      end

      resources :customers, only: %i[index show create update] do
        delete :delete, on: :collection
        get :full_info, on: :collection
        get :basic_info, on: :collection
        post :import, on: :collection
        get :get_graph, on: :collection
      end

      resources :environments, only: %i[index show create update] do
        get :basic_info, on: :collection
        delete :delete, on: :collection
        get :environments_detail, on: :collection
        get :activity, on: :collection
        get :environment_activity, on: :collection
        get :resource_availability, on: :collection
        get :versions, on: :collection
        get :table_column_names, on: :collection
      end

      resources :permissions, only: %i[index show] do
        delete :delete, on: :collection
      end

      resources :role_permissions, only: %i[index show create] do
        put :update, on: :collection
        delete :delete, on: :collection
      end

      resources :roles, only: %i[index show create update] do
        get :basic_info, on: :collection
        delete :delete, on: :collection
      end

      resources :user_roles, only: %i[index show create update] do
        post :associate_user_environment, on: :collection
        delete :delete, on: :collection
      end

      resources :users, only: %i[index show create update] do
        delete :delete, on: :collection
        get :profile, on: :collection
      end

      resources :services, only: %i[index show create update] do
        delete :delete, on: :collection
        get :basic_info, on: :collection
        get :get_graph, on: :collection
      end

      resources :products, only: %i[index show create update] do
        delete :delete, on: :collection
        get :basic_info, on: :collection
        get :get_graph, on: :collection
        post :import, on: :collection
      end

      resources :external_jobs, only: %i[index show create update destroy] do
        post :build, on: :collection
      end

      resources :notifications, only: %i[index update] do
        get :basic_info, on: :collection
        post :set_active, on: :collection
      end
    end
  end
end
