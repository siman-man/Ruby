# encoding: utf-8

class Q3
    def initialize
        @users = {"user1" => "pass1", "user2" => "pass2"}
    end
    def login(u, p)
        raise LoginServerErro if u == 'server_error'
        if @users[u] == p
            "ログイン完了"
        else 
            "ログイン失敗"
        end
    end

    def access(u, p)
        begin
            login(u, p)
        rescue LoginCertifyError => ce
            puts "パスワードが間違っています"
        rescue LoginUserUnknownError => ex
            puts "ユーザーが見つかりません"
        rescue LoginServerError => se
            puts "サーバに接続できません"
        end
    end
end
