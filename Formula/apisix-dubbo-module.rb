class ApisixDubboModule < Formula
    desc "The Nginx dubbo module."
    homepage "https://github.com/api7/mod_dubbo"
    mod_dubbo_ver = "1.0.2".freeze
    url "https://github.com/api7/mod_dubbo/archive/refs/tags/#{mod_dubbo_ver}.tar.gz"
    sha256 "1fb02fccb89a042ebdd2a0da26c050ea9a3807e75fdbf67e79da91eaea0e6953"
    
    def install
        pkgshare.install Dir["*"] 
    end
end