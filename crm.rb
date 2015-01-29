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

get "/contacts/:id" do
  @contact = $rolodex.find(params[:id].to_i)
  if @contact
  	erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

post '/contacts' do
  @crm_app_name = "My CRM"
  new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
  $rolodex.add_contact(new_contact)
  redirect to('/contacts')
end

get "/contacts/:id/edit" do 
	@contact = $rolodex.find(params[:id].to_i)
	if @contact
		erb :edit_contact
	else
		raise Sinatra::NotFound
	end
end 
