class ApisixLuaVarModule < Formula
    desc "Fetchs Nginx variable by Luajit with FFI way which is fast and cheap."
    homepage "https://github.com/api7/lua-var-nginx-module"
    lua_var_nginx_module_ver = "v0.5.3".freeze
    url "https://github.com/api7/lua-var-nginx-module/archive/refs/tags/#{lua_var_nginx_module_ver}.tar.gz"
    sha256 ""
    
    def install
        pkgshare.install Dir["*"] 
    end
end