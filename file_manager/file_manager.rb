class FileManager
    def create_directory(name)
        Dir::mkdir(name)
    end

    def show_file_path(file)
        File.absolute_path(file) 
    end

    def show_file_list(path)
        file_list = Array.new
        Dir::glob("#{path}/*").each do |file|
            file_list << file unless file =~ /.*\..*~/
        end
        file_list
    end

    def get_file_stat(filename)
        stat = File.stat(filename)
    end
end
