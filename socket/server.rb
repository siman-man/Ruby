require 'socket'

port = 20000
server = TCPServer.new(port)
log = ServerLogStore.new('server')

puts "Start socket accept"

loop do
    Thread.fork(server.accept) do |socket|
        begin
            host = socket.peeraddr[2]
            ip = socket.peeraddr[3]
            message = socket.gets
            today, time, info = message.split() 
            file_name = "#{ip}_#{host}.log"

            file = log.open_log_file(file_name)
            data = sprintf("%s %s %s(%s)\n", time, info, host, ip)
            file.write(data)
            puts data
        ensure
            socket.close unless socket.closed?
            file.close unless file.closed?
        end
    end
end
