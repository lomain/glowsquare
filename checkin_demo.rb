
require 'net/http'
require 'uri'
require 'open-uri'
require 'json'
require 'serialport'



def checkin_count(ll) 
  4sq_oauth = "FOURSQUARE-OAUTH-TOKEN"
  url = "https://api.foursquare.com/v2/venues/trending?ll=#{ll}&radius=500&oauth_token=#{4sq_oauth}&v=20110917&limit=50"
  output = nil
  open(url) {|f|
     output = f.read()
  }
  checkinData = JSON.parse(output)
  checkinData["response"]["venues"].inject(0) { |sum, venue|
     sum + venue["hereNow"]["count"] 
  }
end

def poll_venue_checkin() 
  url = "https://glowsquare.herokuapp.com/venueCheckin"
  output = nil
  open(url) {|f|
     output = f.read()
  }
  checkinData = JSON.parse(output)
  checkins = checkinData["count"]
  puts "New Checkins at Closely HQ: #{checkins}"
  
  if (checkinData["count"] > 0)
    # trigger a 'pulse' on the cube
    set_pulse()
  end
end

def poll_activity_demo() 
  url = "https://glowsquare.herokuapp.com/venueActivity"
  output = nil
  open(url) {|f|
     output = f.read()
  }
  checkinData = JSON.parse(output)

  checkinData["count"]
end

def set_pulse()
  hueVal = 345
  satVal = 204
  brtVal = 255
  write_serial('p', hueVal, satVal, brtVal)
end

def set_activity(count)
  now = Time.now.strftime(" %m/%d/%Y %I:%M:%S %p") 
  
  #log = Logger.new(STDOUT)
  #log.level = Logger::DEBUG
  #log.info("Number of checkins around Mile High #{count} #{now}")
  
  puts "Number of Checkins around Closely HQ: #{count} #{now}"
  
  hueVal = 240
  satVal = 255
  
  #randomize the count for testing color values (remove)
  #count += rand(255)
  count += 50
  
  #super secret activity color algorithm *patent pending
  if (count > 255)
    brtVal = 255;
  else 
    brtVal = count;
  end
  write_serial('a', hueVal, satVal, brtVal)
end

def write_serial(command, hue, sat, brt)
  #params for serial port
  port_str = "/dev/tty.usbmodemfa131"  #may be different for you
  baud_rate = 9600
  data_bits = 8
  stop_bits = 1
  parity = SerialPort::NONE
  
  sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

  #write command and args to serial port
  sp.putc command
  sp.putc hue
  sp.putc sat
  sp.putc brt
   
  # example: write a string
  #sp.puts "string"
   
  #example: just read forever
  #while true do
    # printf("%c", sp.getc)
  #end

  sp.close
  
end

# main loop
while true
  #count = checkin_count("39.752501%2C-104.996418")
  set_activity(0)
  sleep 3
  set_activity(20)
  sleep 3
  set_activity(40)
  sleep 3
  set_activity(60)
  sleep 3
  set_activity(120)
  sleep 3
  set_pulse
  set_activity(120)
  sleep 5
  set_activity(150)
  sleep 3
  set_activity(200)
  sleep 3
  set_activity(200)
  sleep 20
  set_activity(190)
  sleep 3
  set_pulse
  set_activity(160)
  sleep 3
  set_pulse
  set_activity(160)
  sleep 3
  set_activity(130)  
  sleep 3
  set_activity(80)
  sleep 3
  set_activity(60)
  sleep 3
  set_activity(20)

end


