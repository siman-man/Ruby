require 'socket'
require './log_store'

port = 20000
server = TCPServer.new(port)
log = LogStore.new('server')

puts "Start socket accept"

loop do
    Thread.fork(server.accept) do |socket|
        begin
            host = socket.peeraddr[2]
            ip = socket.peeraddr[3]
            print "#{host} #{ip} send data : "
            while message = socket.gets
                puts message
                today, time, info = message.split(/<>/) 
                log.dir_check(today)
                file_name = "#{ip}_#{host}.log"

                file = log.log_file_open(file_name)
                data = sprintf("%s\n", info)
                file.write(data)
                puts data
            end
        rescue
            puts "TCPServer ERROR : #$!\n"
            puts $@
        ensure
            socket.close unless socket.closed?
            file.close unless file.closed?
        end
    end
end
