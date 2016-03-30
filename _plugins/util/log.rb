class Log
    def self.err(page, msg)
        puts self.to_msg(page, msg).red
    end

    def self.warn(page, msg)
        puts self.to_msg(page, msg).yellow
    end

    private

    def self.to_msg(page, msg)
        "#{page['path']}: #{msg}"
    end

end