require 'socket'
require './get_wimax_info'
require './log_store'

port = 20000
wimax = GetWimaxInfo.new
log = LogStore.new('client')
host = Socket.gethostname

loop do
    begin
        # Get today and time
        # today [ YYYY/mm/dd ] [ ex 2012/09/02 ]
        # time [ HH:MM:SS ] [ ex 10:32:45 ]
        today, time = Time.now.strftime("%Y/%m/%d %H:%M:%S").split()

        # socket open 
        socket = TCPSocket.open("localhost", port)
        data = wimax.get_wimax_info(time)
        message = "#{today}<>#{time}<>#{data}"
        puts "send message #{message}"
        socket.write("#{message}")
    rescue
        # if connect failed, create error message.
        puts "TCPSocket.open failed : #$!\n"
        puts $@ 
        sleep 300
        retry
    ensure
        socket.close unless socket.closed?
    end
    sleep 2
end

