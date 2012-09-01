require 'open-uri'
require 'nokogiri'
require 'kconv'

module StateInfo
    def get
        url = "http://10.0.0.1/sig_params"
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
        result = sprintf("%s RSSI:%5.2f SNR:%5.2f Modulation:%s\n", time, rssi, snr, modul)
        log = sprintf("%s,%5.2f,%5.2f,%s\n", time, rssi, snr, modul)
    end
end

class WiMAX
    include StateInfo
end

