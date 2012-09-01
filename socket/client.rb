require 'socket'
require './getinfo'

obj = WiMAX.new
time = nil
before = nil

while true 
    # Get Day YY_MM_DD style
    time = Time.now.strftime("%Y_%m_%d")

    if File.exist?(time + ".log") then
        log = File.open(time + ".log", "a")
    else
        log = File.open(time + ".log", "w")
    end

    begin
        # socket open in port 20000 
        sock = TCPSocket.open("localhost", 20000)
    rescue
        # if connect failed, create error message.
        puts "TCPSocket.open failed : #$!\n"
    else
        puts obj.get
        sock.write(obj.get.chomp)
        sock.close
    end
    log.write(obj.get)
    log.close
    before = time
    sleep 2
end

