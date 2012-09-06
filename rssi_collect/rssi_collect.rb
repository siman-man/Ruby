# encoding: utf-8


class CollectRSSI
    # Initialize value. 
    def initialize 
        @max        =    0.0             # RSSI max value (0.0dbm) 
        @minimam    = -100.0             # RSSI minimam value (-100dbm) 

        @hour       = 0
        @minute     = 0
        @second     = 0

        @span_time  = 120                # Time Interval(sec)
    end

    # 文字列で渡された時間を秒数に直す関数(HH:MM:SS -> Xsec)
    def string_time2seconds(time) 
        if( time =~ /^[0-2][0-4]:[0-9][0-9]:[0-9][0-9]$/)
            hour, minute, second = time.split(':')
            seconds = hour.to_i * 3600 + minute.to_i * 60 + second.to_i
            if(seconds > 86400)
                return "Invalid string time #{time}"
            else
                return seconds
            end
        else
            return "Invalid string time #{time}"
        end
    end

    # 渡された秒数を(Xsec -> HH:MM:SS)の表記に直してくれる関数
    def seconds2string_time(seconds)
        if(0 <= seconds && seconds <= 86400)
            hour = seconds / 3600
            seconds %= 3600

            minute = seconds / 60
            seconds %= 60

            second = seconds

            time = sprintf("%02d:%02d:%02d", hour, minute, second) 
        else
            return "Invalid seconds #{seconds}"
        end
    end

    # time update
    def increment_time
        @second += 1

        if(@second == 60) 
            @minute += 1
            @second  = 0
        end

        if(@minute == 60) 
            @hour   += 1
            @minute  = 0
        end

        if(@hour == 24) 
            @hour = 0
        end
    end

    # Return current time 
    def get_current_time
        time = sprintf("%02d:%02d:%02d", @hour, @minute, @second) 
    end

    def check_file_contents(data)
        if(data[0] =~ /^\d{2,2}:\d{2,2}:\d{2,2}$/ &&
           data[1] =~ /^-?\d{1,2}\.\d{1,2}$/ &&
           data[2] =~ /^\d{1,2}\.\d{1,2}$/)
            return true
        else
            return false
        end
    end

    def calc_array_average(list)
        sum = 0.0
        count = list.size
        sum = list.inject(0){|sum, value| sum += value}
        return sum/count
    end

    def create_result_text(rssi, snr)
        time = get_current_time
        sprintf("%s %4.2f %4.2f\n", time, rssi, snr)
    end

    def generate_csv_file(filename)
        dir = File.dirname(filename)
        name = File.basename(filename, ".*")
        File.open(dir + '/' + filename + '.csv', 'w')
    end

    def collect_rssi(filename)
        time        = ""
        rssi        = 0.0
        snr         = 0.0
        seconds     = 0
        sum_rssi    = 0.0
        count_time  = 0
        before_rssi = 0.0
        before_snr  = 0.0
        loss_time   = 0
        rssi_list   = []
        snr_list    = []
        target_time = @span_time 
        begin
            log = File.open(filename, "r")
            file = generate_csv_file(filename) 
        rescue
            printf("No such file or directory %s is sunny day.\n", filename)
            exit 1
        end


        while line = log.gets
            data = line.split(',')
            if(check_file_contents(data))
                time = data[0]
                rssi = data[1].to_f
                snr  = data[2].to_f
                seconds = string_time2seconds(time)

                rssi_list << rssi
                snr_list << snr

                while count_time != seconds
                    increment_time
                    count_time = string_time2seconds(get_current_time)
                    if(count_time == target_time) 
                        if(rssi_list.size != 0 && snr_list.size != 0) 
                            rssi_average = calc_array_average(rssi_list) 
                            snr_average = calc_array_average(snr_list)

                            file.write(create_result_text(rssi_average, snr_average))
                            before_rssi = rssi_average
                            before_snr  = snr_average
                            loss_time = 0
                        else
                            file.write(create_result_text(before_rssi, before_snr))
                        end
                        target_time += @span_time
                        rssi_list.clear
                        snr_list.clear
                    end

                    if(loss_time == 43200) 
                        printf("This file 12 hour null data\n")
                        file.close()
                        log.close()
                        return exit
                    end
                    loss_time += 1
                end
            end
        end

        file.close()
        log.close()
    end
end

