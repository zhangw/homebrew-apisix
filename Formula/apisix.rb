require 'etc'
$apisix_ver = "2.15.0".freeze
class Apisix < Formula
    desc "Apache APISIX is an open source, dynamic, scalable, and high-performance cloud native API gateway."
    homepage "https://apisix.apache.org"
    url "https://github.com/apache/apisix/archive/refs/tags/#{$apisix_ver}.tar.gz"
    sha256 "462f70e4491dd296bea14eb5bd2a481e00bcacfca6193791702f0546bc297b09"

    depends_on "zhangw/apisix/apisix-base"

    # TODO: luarocks 3.x required
    depends_on "luarocks"
    depends_on "lua@5.1"
    depends_on "wget"
    depends_on "curl"
    depends_on "git"
    depends_on "pcre"
    depends_on "openldap"

    resource "toolkit" do
        url "https://github.com/api7/test-toolkit/archive/refs/tags/v0.1.1.tar.gz"
        sha256 "a7d73c7622e11a19e9392f9da70b0ae33b9b0a003c819f9c258328ea66933571"
    end

    def caveats
        <<~EOS
          APISIX $apisix_ver was been installed on #{opt_pkgshare} .
        EOS
    end

    def install
        system "mkdir", "-p", "#{ENV["HOME"]}/.luarocks"
        system "luarocks", "config", "variables.LUA_DIR", "#{Formula["lua@5.1"].opt_prefix}"
        system "luarocks", "config", "lua_version", "5.1"
        system "luarocks", "config", "--local", "variables.OPENSSL_DIR", "#{Formula["openresty/brew/openresty-openssl111"].opt_prefix}"
        system "luarocks", "config", "--local", "variables.LDAP_DIR", "#{Formula["openldap"].opt_prefix}"
        system "luarocks", "install", "rockspec/apisix-#{$apisix_ver}-0.rockspec", "--tree=deps", "--only-deps", "--local", "PCRE_DIR=#{Formula["pcre"].opt_prefix}"
        
        pkgshare.install Dir["apisix", "t", "bin", "conf", "deps"]

        resources.each do |r|
            if r.name == "toolkit"
                r.stage do
                    (pkgshare/"t/toolkit").install Dir["*"]
                end
            end 
        end
    end

end