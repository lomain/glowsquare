# myapp.rb
 require 'sinatra'
 require 'json'
 require 'net/http'
 require 'uri'
 require 'open-uri'
 require 'logger' 
 require 'erb' 

 set :checkins, 0
 set :activity, 0

 get '/' do
   #count = 300 #checkin_count("39.743824%2C-105.02019")
   #inc_checkin_count()
   erb :index
 end

 post '/venueCheckin' do 
   inc_venue_checkin_count()
 end

 get '/venueCheckin' do 
   count = venue_checkin_count()
   reset_checkin_count()
   content_type :json
    { :count => count }.to_json
 end

 get '/venueCheckinTest' do 
   count = venue_checkin_count()
   content_type :json
    { :count => count }.to_json
 end
 
 get '/venueActivityUp' do 
   inc_venue_activity_count()
 end 

 get '/venueActivityDown' do 
   dec_venue_activity_count()
 end
 
 get '/venueActivity' do 
  count = venue_activity_count()
  content_type :json
    { :count => count }.to_json
 end

 def checkin_count(ll) 
   4sq_oauth = "FOURSQUARE-OAUTH-TOKEN"
   url = "https://api.foursquare.com/v2/venues/search?ll=#{ll}&oauth_token=#{4sq_oauth}&v=20110917&limit=50"
   output = nil
   open(url) {|f|
      output = f.read()
   }
   checkinData = JSON.parse(output)
   checkinData["response"]["venues"].inject(0) { |sum, venue|
      sum + (venue["hereNow"]["count"] || 0)
   }
 end

 def venue_checkin_count()
   settings.checkins
 end

 def inc_venue_checkin_count()
   settings.checkins = settings.checkins + 1
 end

 def inc_venue_activity_count()
   settings.activity += 20
 end

 def dec_venue_activity_count()
   settings.activity -= 20
 end

 def venue_activity_count()
   settings.activity
 end

 def reset_checkin_count()
   settings.checkins = 0
 end


