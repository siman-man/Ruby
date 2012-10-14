require 'socket'
require './get_wimax_info'
require './log_store'

wimax = GetWimaxInfo.new
log = LogStore.new('client_local')
host = wimax.get_host_name
ip = wimax.get_ip
file_name = "#{ip}_#{host}.log"

loop do
    begin
        # Get today and time
        # today [ YYYY/mm/dd ] [ ex 2012/09/02 ]
        # time [ HH:MM:SS ] [ ex 10:32:45 ]
        today, time = Time.now.strftime("%Y/%m/%d %H:%M:%S").split()

        log.dir_check(today)
        file = log.log_file_open(file_name)
        data = wimax.get_wimax_info(time)
        file.write(data + "\n")
    rescue
        # if connect failed, create error message.
        puts "TCPSocket.open failed : #$!\n"
        puts $@ 
        sleep 300
        retry
    ensure
        file.close unless file.closed?
    end
    sleep 2
end

