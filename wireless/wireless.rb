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
        ap_list = [] 
        if ap_table == nil
            return 0
        end
        ap_info = ap_table.split(/\n/)
        ap_info.each_with_index do |ap, index|
            detail_info = {}
            next if index < 1           # first line skip
            # divided every item.
            ap_data = ap.split()
            detail_info[:SSID] = ap_data[0]
            detail_info[:RSSI] = ap_data[2].to_f
            detail_info[:CHANNEL] = ap_data[3]
            ap_list << detail_info
        end
        return ap_list
    end
end
