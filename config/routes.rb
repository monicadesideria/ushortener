class ShortenerConstraint
  # def matches?(request)
  # 	binding.pry
  #   request.base_url.sub(/.*:\/\//, '') == ENV['SHORTENER_DOMAIN']
  # end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'short_urls#new'
  resources :short_urls
  # constraints(ShortenerConstraint.new) do
    get '/:short_uid' => 'short_urls#generate_short_url', as: :shorten
  # end 
end