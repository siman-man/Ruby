require 'socket'

port = TCPServer.open(20000)

puts "Start socket accept"


while true 
    sock = port.accept

    host = sock.peeraddr[2]
    ip = sock.peeraddr[3]

    if File.exist?("server.log") then
        log = File.open("server.log", "a")
    else
        log = File.open("server.log", "w")
    end

    while data = sock.gets
        state = sprintf("%s %s(%s)\n", data, host, ip)
        log.write(state)
        puts state
    end

    log.close
    sock.close
end


port.close
