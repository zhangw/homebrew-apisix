class ApisixMultiUpstreamModule < Formula
    desc "The Nginx multi upstream module."
    homepage "https://github.com/api7/ngx_multi_upstream_module"
    ngx_multi_upstream_module_ver = "1.1.1".freeze
    url "https://github.com/api7/ngx_multi_upstream_module/archive/refs/tags/#{ngx_multi_upstream_module_ver}.tar.gz"
    sha256 "2a2cf4bf3e137651ab0e93af9c2c7488578ec3cb7e387dcfa0df3677bdb9f3da"

    def install
        pkgshare.install Dir["*"] 
    end
end