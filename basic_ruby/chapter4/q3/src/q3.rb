class Q3
    def split_user_host(address)
        data = address.split(/@/)
        msg = Hash.new
        msg[:user] = data[0]
        msg[:host] = data[1]
        return msg
    end
end
