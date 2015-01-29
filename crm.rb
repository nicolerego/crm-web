require_relative 'rolodex'
require_relative 'contact'
require 'sinatra'

$rolodex= Rolodex.new

$rolodex.add_contact(Contact.new("Johnny", "Bravo", "johnny@bitmakerlabs.com", "Rockstar"))

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

get "/contacts/1000" do
  @contact = $rolodex.find(1000)
  erb :show_contact
end

post '/contacts' do
	@crm_app_name = "My CRM"
  new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
  $rolodex.add_contact(new_contact)
  redirect to('/contacts')
end