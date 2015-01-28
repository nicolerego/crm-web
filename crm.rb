require_relative 'rolodex'
require_relative 'contact'
require 'sinatra'

$rolodex= Rolodex.new

get '/' do
	@crm_app_name = "My CRM"
 	erb :index
end


get '/contacts' do
	@crm_app_name = "My CRM"
 	erb :contacts
end

get '/contacts/new' do
	@crm_app_name = "My CRM"
 	erb :new_contact
end

post '/contacts' do
	@crm_app_name = "My CRM"
  new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
  $rolodex.add_contact(new_contact)
  redirect to('/contacts')
end