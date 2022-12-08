class ApisixNgxModule < Formula
    desc "The Apisix ngx module."
    homepage "https://github.com/api7/apisix-nginx-module"
    apisix_nginx_module_ver = "1.9.0".freeze
    url "https://github.com/api7/apisix-nginx-module/archive/refs/tags/#{apisix_nginx_module_ver}.tar.gz"
    sha256 "a9792a5ab884b64ec305d6cb54fa1a4b7895c230ce7d372d4e76ea9bcdc5d496"
    
    def install
        pkgshare.install Dir["*"] 
    end
end