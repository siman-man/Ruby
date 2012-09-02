require 'open-uri'
require 'nokogiri'
require 'kconv'

class GetWimaxInfo
    def get_wimax_info
        url = ""
        page = Nokogiri::HTML(open(url))
        rssi = 0.0
        snr = 0.0
        modul = nil

        page.css('html body table tr.values').each do |value|
            data = value.text
            case data
            when /Received Signal Strength/
                rssi = data[24..28].to_f
            when /SNR/
                snr = data[3..6].to_f
            when /Modulation/
                modul = data[10..20]
            end
        end
        time = Time.now.strftime("%H:%M:%S")
        log = sprintf("%s,%5.2f,%5.2f,%s", time, rssi, snr, modul)
    end
end
