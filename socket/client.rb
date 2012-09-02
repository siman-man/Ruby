require 'socket'
require './getinfo'

port = 20000
wimax = GetWimaxInfo.new
log = LogStore.new('client')
file_name = "localhost.log"

loop do
    # Get today and time
    # today [ YYYY/mm/dd ] [ ex 2012/09/02 ]
    # time [ HH:MM:SS ] [ ex 10:32:45 ]
    today, time = Time.now.strftime("%Y/%m/%d %H:%M:%S").split()

    dir_check(today)
    file = log.log_file_open(file_name)

    begin
        # socket open 
        socket = TCPSocket.open("localhost", port)
        data = wimax.get
        socket.write("#{today} #{time} #{data}")
        file.write(data + "\n")
    rescue
        # if connect failed, create error message.
        puts "TCPSocket.open failed : #$!\n"
    ensure
        socket.close unless socket.closed?
        file.close unless file.closed?
    end
    sleep 2
end

