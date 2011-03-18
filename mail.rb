require 'yaml'
require 'sinatra'
require 'skinny'

require_relative 'lib/imap'

class Sinatra::Request
  include Skinny::Helpers
end

set :haml, :format => :html5

get '/' do
  haml :index
end

get '/folders' do
  list = IMAP.open do |s|
    s.get_folders
  end
  @folders = list.collect( &:name )
  haml :folders
end

get '/messages/:folder' do
  messages = IMAP.open do |s|
    s.get_messages(params[:folder])
  end
  @messages = messages.collect do |m|
    env =  m.attr["ENVELOPE"]
    [m.seqno, env.subject, env.date, env.from.first.name]
  end
  haml :messages
end

get '/messages/:folder/:id' do
  message = IMAP.open do |s|
    s.get_message(params[:folder], params[:id])
  end.inspect
end

get '/config' do
  config.inspect
end

get '/capabilities' do
  IMAP.open do |s|
    s.capabilities
  end.inspect
end
