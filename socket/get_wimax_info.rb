require 'open-uri'
require 'nokogiri'
require 'kconv'

class GetWimaxInfo
    def initialize
        @url        = ""
        @rssi       = ""
        @snr        = ""
        @modulation = ""
    end

    def get_info(text)
        case text
        when /^Received Signal Strength/
            @rssi = text[24..28].strip
            if(@rssi =~ /^-[0-9]{1,2}\.[0-9]{1,2}$/)
                return @rssi.to_f
            else
                return "ERROR: Invalid RSSI value is included #{@rssi}"
            end
        when /^SNR/
            @snr = text[3..6].strip
            if(@snr.to_s =~ /^[0-9]{1,2}\.[0-9]{1,2}$/)
                return @snr.to_f
            else
                return "ERROR: Invalid SNR value is included #{@snr}"
            end
        when /^Modulation/
            @modulation = text[10..-1]
        else
        end
    end

    def get_wimax_info(time)
        page = Nokogiri::HTML(open(@url), nil, "utf-8")

        page.css('html body table tr.values').each do |item|
            get_info(item.text)
        end

        log = sprintf("%s,%5.2f,%5.2f,%s", time, @rssi.to_f, @snr.to_f, @modulation)
    end
end
