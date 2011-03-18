require 'sinatra'
 
Sinatra::Base.set(:run, false)
Sinatra::Base.set(:env, :development)
 
require './mail'
run Sinatra::Application
