require 'rubygems'
require 'sinatra'
require_relative './page_weight'

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
end

get '/' do
  erb :url_form
end

post '/calculate' do
  url = params[:url]
  @summary, @output = PageWeight.new(url).calculate
  erb :listing
end
