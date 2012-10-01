# serial.rb
 require 'sinatra'
 require 'serialport'
 
 #params for serial port
 port_str = "/dev/ttyUSB0"  #may be different for you
 baud_rate = 9600
 data_bits = 8
 stop_bits = 1
 parity = SerialPort::NONE
 
 get '/' do
   sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

   #just read forever
   #while true do
    # printf("%c", sp.getc)
   #end
   
   #write a character
   sp.putc 'a'
   
   # write a string
   sp.puts "string"

   sp.close
   
 end