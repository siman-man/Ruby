require 'pp'

class Ap_Search
    def ap_search
        ap_list = `airport -s`
    end

    def show_ap_info(ap_list)
        ap_info = ap_list.split(/\n/)
        ap_info.each do |ap_list|
        end
    end
end

a = Ap_Search.new
a.ap_search
