require_relative 'rolodex'
require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3:database.sqlite3")

class Contact

  include DataMapper::Resource
  
  property :id, Serial
  property :first_name, String
  property :last_name, String
  property :email, String
  property :note, String

  # attr_accessor :id, :first_name, :last_name, :email, :note

  # def initialize(first_name, last_name, email, note)
  #   @first_name = first_name
  #   @last_name = last_name
  #   @email = email
  #   @note = note
  # end
end

DataMapper.finalize
DataMapper.auto_upgrade!

$rolodex= Rolodex.new

get '/' do
	@crm_app_name = "CRM WEB APP"
 	erb :index, :layout => false
end


get '/contacts' do
	@crm_app_name = "CRM WEB APP"
  @contacts = Contact.all
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
  
  contact = Contact.create(
    :first_name => params[:first_name],
    :last_name => params[:last_name],
    :email => params[:email],
    :note => params[:note]
  )
  
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

