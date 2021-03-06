# encoding: utf-8

class LogStore 
    def initialize(type)
        if(type == nil)
            puts "Please input 'type' and 'hostname'\n"
            puts "Example [ LogStore('client', 'localhost') ]\n"
            exit 1
        end
        @type   = type
        @year   = ""
        @month  = ""
        @day    = ""
    end

    def update_date(today)
        date    = today.split('/')
        year    = date[0]
        month   = date[1]
        day     = date[2]

        @year   = "#{year}"
        @month  = "#{year}#{month}"
        @day    = "#{year}#{month}#{day}"
    end

    def create_type_dir
        dir_name = "#{@type}_log"

        Dir.mkdir("#{dir_name}")
    end

    def check_type_dir
        dir_name = "#{@type}_log"

        Dir.exist?("#{dir_name}")
    end

    def create_year_dir
        dir_name = "#{@type}_log/#{@year}"

        Dir.mkdir("#{dir_name}") 
    end

    def check_year_dir
        dir_name = "#{@type}_log/#{@year}"

        Dir.exist?("#{dir_name}")
    end

    def create_month_dir
        dir_name = "#{@type}_log/#{@year}/#{@month}"

        Dir.mkdir("#{dir_name}") 
    end

    def check_month_dir
        dir_name = "#{@type}_log/#{@year}/#{@month}"

        Dir.exist?("#{dir_name}")
    end

    def create_day_dir
        dir_name = "#{@type}_log/#{@year}/#{@month}/#{@day}"

        Dir.mkdir("#{dir_name}")
    end

    def check_day_dir
        dir_name = "#{@type}_log/#{@year}/#{@month}/#{@day}"

        Dir.exist?("#{dir_name}")
    end

    def log_file_open(file_name)
        dir_name = "#{@type}_log/#{@year}/#{@month}/#{@day}"

        if(check_log_file(file_name))
            log = File.open("#{dir_name}/#{file_name}", "a")
        else
            log = File.open("#{dir_name}/#{file_name}", "w")
            log.write("TIME, RX_LEVEL, SNR, MODULATION\n")
        end
    end

    def check_log_file(file_name)
        begin 
            dir_name = "#{@type}_log/#{@year}/#{@month}/#{@day}"

            File.exist?("#{dir_name}/#{file_name}")
        rescue
            puts ex.message
        end
    end

    # today format is YYYY/MM/DD ex[ 2012/09/02 ]
    def dir_check(today)
        update_date(today)
        create_type_dir if !check_type_dir
        create_year_dir if !check_year_dir
        create_month_dir if !check_month_dir
        create_day_dir if !check_day_dir
    end
end
