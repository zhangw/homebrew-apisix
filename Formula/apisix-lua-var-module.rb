class ApisixLuaVarModule < Formula
    desc "Fetchs Nginx variable by Luajit with FFI way which is fast and cheap."
    homepage "https://github.com/api7/lua-var-nginx-module"
    lua_var_nginx_module_ver = "v0.5.3".freeze
    url "https://github.com/api7/lua-var-nginx-module/archive/refs/tags/#{lua_var_nginx_module_ver}.tar.gz"
    sha256 "66792871b21d9e81f1ec6f8416bc18878ab28db0fbaad41877a0569e6a5c1b20"
    
    def install
        pkgshare.install Dir["*"] 
    end
end