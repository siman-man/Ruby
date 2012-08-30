require 'pp'

class Wireless
    # This function get an Access Point informations.
    def ap_search
        # aiport command
        ap_table = `airport -s`
        # split every access point.
        return ap_table
    end

    # This function get detail access point information 
    def get_ap_info(ap_table)
        ap_list = {} 
        if ap_table == nil
            return 0
        end
        ap_info = ap_table.split(/\n/)
        ap_info.each_with_index do |ap_data, index|
            detail_info = {}
            next if index < 1           # first line skip
            next if index > 20          # first line skip
            # divided every item.
            bssid = ap_data[33..49].strip
            detail_info[:SSID] = ap_data[0..31].strip
            detail_info[:RSSI] = ap_data[51..54].strip.to_f
            detail_info[:CHANNEL] = ap_data[56..62].strip
            ap_list[bssid] =  detail_info
        end
        return ap_list
    end
end
