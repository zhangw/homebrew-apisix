require 'etc'
class ApisixBase < Formula
    desc "Apache APISIX based upon Openresty, and also some patches would be applied."
    homepage "https://github.com/api7/apisix-build-tools"
    OPENRESTY_VERSION = "1.21.4.1".freeze
    revision 1
    url "https://openresty.org/download/openresty-#{OPENRESTY_VERSION}.tar.gz"
    sha256 "0c5093b64f7821e85065c99e5d4e6cc31820cfd7f37b9a0dec84209d87a2af99"
    # ngx_multi_upstream_module patch
    patch do
        url ""
        sha256 "980fcc6e845587232a3d5263dab4e2fd21b94ebf6603028ce9dcf43736292bba"
        #directory "ngx_multi_upstream_module-1.1.1"
        apply "openresty-#{OPENRESTY_VERSION}/bundle/nginx-1.21.4" "nginx-1.21.4.patch"
    end

    def install
        system "pwd"
    end
end
