require 'sinatra/base'
require 'sinatra/flash'
require_relative './lib/dm'
require_relative './lib/helpers'
require 'bcrypt'

class Chitter < Sinatra::Base
	enable :sessions
	register Sinatra::Flash

  get '/' do
    redirect(:peep_feed)
  end

  get '/peep_feed' do
  	@peeps = Peep.all(:order => [:created_at.desc], :limit => 10)
  	erb(:peep_feed)
  end

  get '/new_peep' do
  	erb(:new_peep)
  end

  post '/new_peep' do
  	Peep.create(
  		message_content: params[:message_content],
  		created_at: Time.now,
  		author: "Testing",
  		user_id: 1
  	)
  	redirect(:peep_feed)
  end

  get '/create_peep' do
  	if session[:id] == nil
  		redirect(:sign_in)
  	end
  	redirect(:new_peep)
  end

  get '/sign_in' do
  	erb(:sign_in)
  end

  post '/sign_up' do
  	user = User.create(
  		username: params[:username],
  		email: params[:email],
  		first_name: params[:first_name],
  		last_name: params[:last_name],
  		password: params[:password]
  	)
		session[:id] = user.id
  	redirect(:peep_feed)
  end

  run! if app_file == $0
end