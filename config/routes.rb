Rails.application.routes.draw do
	root 'welcome#index'
	get 'welcome/index'
	mount Flipkey::API => '/'
end
