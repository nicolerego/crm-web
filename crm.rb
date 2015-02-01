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

end

DataMapper.finalize
DataMapper.auto_upgrade!

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
  @contact = Contact.get(params[:id].to_i)
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
	@contact = Contact.get(params[:id].to_i)
	if @contact
		erb :edit_contact
	else
		raise Sinatra::NotFound
	end
end 

put "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    @contact.first_name = params[:first_name]
    @contact.last_name = params[:last_name]
    @contact.email = params[:email]
    @contact.note = params[:note]

    @contact.save

    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end

# DELETE CONTACT

delete "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    @contact.destroy
    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end

# SEARCH CONTACT

get '/search' do
    @crm_app_name = "CRM WEB APP"
    erb :search
end 
 
get '/results' do
  @crm_app_name = "CRM WEB APP"
  @results_title = params[:query]

  @query = "%#{params[:query]}%"
  @results = Contact.all({
    :conditions => [
      "first_name LIKE ? OR last_name LIKE ?",
      @query,
      @query,
    ]
    })
  erb :results
end 