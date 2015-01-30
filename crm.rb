require_relative 'rolodex'
require_relative 'contact'
require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3:database.sqlite3")


$rolodex= Rolodex.new

get '/' do
	@crm_app_name = "CRM WEB APP"
 	erb :index, :layout => false
end


get '/contacts' do
	@crm_app_name = "CRM WEB APP"
 	erb :contacts
end

get '/contacts/new' do
	@crm_app_name = "CRM WEB APP"
 	erb :new_contact
end

get "/contacts/:id" do
	@crm_app_name = "CRM WEB APP"
  @contact = $rolodex.find(params[:id].to_i)
  if @contact
  	erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

post '/contacts' do
  @crm_app_name = "CRM WEB APP"
  new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
  $rolodex.add_contact(new_contact)
  redirect to('/contacts')
end

# MODIFY CONTACT

get "/contacts/:id/edit" do 
	@crm_app_name = "CRM WEB APP"
	@contact = $rolodex.find(params[:id].to_i)
	if @contact
		erb :edit_contact
	else
		raise Sinatra::NotFound
	end
end 

put "/contacts/:id" do
  @contact = $rolodex.find(params[:id].to_i)
  if @contact
    @contact.first_name = params[:first_name]
    @contact.last_name = params[:last_name]
    @contact.email = params[:email]
    @contact.note = params[:note]

    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end

# DELETE CONTACT

delete "/contacts/:id" do
  @contact = $rolodex.find(params[:id].to_i)
  if @contact
    $rolodex.remove_contact(@contact)
    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end

