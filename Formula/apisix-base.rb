require 'etc'
class ApisixBase < Formula
    desc "Apache APISIX based upon Openresty, and also some patches would be applied."
    homepage "https://github.com/api7/apisix-build-tools"
    $openresty_ver = "1.21.4.1".freeze
    url "https://openresty.org/download/openresty-#{$openresty_ver}.tar.gz"
    sha256 "0c5093b64f7821e85065c99e5d4e6cc31820cfd7f37b9a0dec84209d87a2af99"
    
    depends_on "zhangw/apisix/apisix-dubbo-module"
    depends_on "zhangw/apisix/apisix-multi-upstream-module"
    depends_on "zhangw/apisix/apisix-ngx-module"
    depends_on "zhangw/apisix/apisix-wasm-module"
    depends_on "zhangw/apisix/apisix-lua-var-module"
    
    depends_on "openresty/brew/openresty-openssl111"
    depends_on "pcre"
    depends_on "zlib"

    skip_clean "site"
    skip_clean "pod"
    skip_clean "nginx"
    skip_clean "luajit"

    ngx_ver = "1.21.4".freeze
    # ngx_multi_upstream_module patch
    ngx_multi_upstream_module_ver = "1.1.1".freeze
    patch :p0 do
        url "https://github.com/api7/ngx_multi_upstream_module/archive/refs/tags/#{ngx_multi_upstream_module_ver}.tar.gz"
        sha256 "2a2cf4bf3e137651ab0e93af9c2c7488578ec3cb7e387dcfa0df3677bdb9f3da"
        directory "bundle/nginx-#{ngx_ver}"
        apply "nginx-#{ngx_ver}.patch"
    end

    # apisix_nginx_module patch 
    ## patch for nginx
    apisix_nginx_module_ver = "1.9.0".freeze
    patch :p0 do
        url "https://github.com/api7/apisix-nginx-module/archive/refs/tags/#{apisix_nginx_module_ver}.tar.gz"
        sha256 "a9792a5ab884b64ec305d6cb54fa1a4b7895c230ce7d372d4e76ea9bcdc5d496"
        directory "bundle/nginx-#{ngx_ver}"
        patches = ["patch/#{ngx_ver}/nginx-client_max_body_size.patch",
                   "patch/#{ngx_ver}/nginx-connection-original-dst.patch",
                   "patch/#{ngx_ver}/nginx-get_last_reopen_time.patch",
                   "patch/#{ngx_ver}/nginx-gzip.patch",
                   "patch/#{ngx_ver}/nginx-mirror.patch",
                   "patch/#{ngx_ver}/nginx-proxy_request_buffering.patch",
                   "patch/#{ngx_ver}/nginx-real_ip.patch",
                   "patch/#{ngx_ver}/nginx-tcp_over_tls.patch",
                   "patch/#{ngx_ver}/nginx-upstream_mtls.patch"]
        apply(*patches.compact)
    end 

    ## patch for lua-resty-core
    lua_resty_core_ver = "0.1.23".freeze
    patch :p0 do
        url "https://github.com/api7/apisix-nginx-module/archive/refs/tags/#{apisix_nginx_module_ver}.tar.gz"
        sha256 "a9792a5ab884b64ec305d6cb54fa1a4b7895c230ce7d372d4e76ea9bcdc5d496"
        directory "bundle/lua-resty-core-#{lua_resty_core_ver}"
        patches = ["patch/#{ngx_ver}/lua-resty-core-bugfix-Apple-Silicon-FFI-ABI-limitation-workaround.patch",
                   "patch/#{ngx_ver}/lua-resty-core-enable_keepalive.patch",
                   "patch/#{ngx_ver}/lua-resty-core-reject-in-handshake.patch",
                   "patch/#{ngx_ver}/lua-resty-core-shared_shdict.patch",
                   "patch/#{ngx_ver}/lua-resty-core-tlshandshake.patch"]
        apply(*patches.compact)
    end

    ## patch for ngx_lua
    ngx_lua_ver = "0.10.21".freeze
    patch :p0 do
        url "https://github.com/api7/apisix-nginx-module/archive/refs/tags/#{apisix_nginx_module_ver}.tar.gz"
        sha256 "a9792a5ab884b64ec305d6cb54fa1a4b7895c230ce7d372d4e76ea9bcdc5d496"
        directory "bundle/ngx_lua-#{ngx_lua_ver}"
        patches = ["patch/#{ngx_ver}/ngx_lua-bugfix-Apple-Silicon-FFI-ABI-limitation-workaround.patch",
                   "patch/#{ngx_ver}/ngx_lua-enable_keepalive.patch",
                   "patch/#{ngx_ver}/ngx_lua-reject-in-handshake.patch",
                   "patch/#{ngx_ver}/ngx_lua-request_header_set.patch",
                   "patch/#{ngx_ver}/ngx_lua-shared_shdict.patch",
                   "patch/#{ngx_ver}/ngx_lua-tlshandshake.patch"]
        apply(*patches.compact)
    end
    
    ## patch for ngx_stream_lua
    ngx_stream_lua_ver = "0.0.11".freeze
    patch :p0 do
        url "https://github.com/api7/apisix-nginx-module/archive/refs/tags/#{apisix_nginx_module_ver}.tar.gz"
        sha256 "a9792a5ab884b64ec305d6cb54fa1a4b7895c230ce7d372d4e76ea9bcdc5d496"
        directory "bundle/ngx_stream_lua-#{ngx_stream_lua_ver}"
        patches = ["patch/#{ngx_ver}/ngx_stream_lua-expose_request_struct.patch",
                   "patch/#{ngx_ver}/ngx_stream_lua-reject-in-handshake.patch",
                   "patch/#{ngx_ver}/ngx_stream_lua-shared_shdict.patch",
                   "patch/#{ngx_ver}/ngx_stream_lua-tlshandshake.patch",
                   "patch/#{ngx_ver}/ngx_stream_lua-xrpc.patch"]
        apply(*patches.compact)
    end
    
    def install 
        prefix_or = "#{prefix}/openresty"
        # Configure
        cc_opt = "-DAPISIX_BASE_VER=#{$openresty_ver} -DNGX_LUA_ABORT_AT_PANIC -I#{HOMEBREW_PREFIX}/include -I#{Formula["pcre"].opt_include} -I#{Formula["openresty/brew/openresty-openssl111"].opt_include} -I#{Formula["zlib"].opt_include} -I#{Formula["apisix-wasm-module"].pkgshare}/wasmtime-c-api/include"
        ld_opt = "-L#{HOMEBREW_PREFIX}/lib -L#{Formula["pcre"].opt_lib} -L#{Formula["openresty/brew/openresty-openssl111"].opt_lib} -L#{Formula["zlib"].opt_lib} -Wl,-rpath,#{Formula["apisix-wasm-module"].pkgshare}/wasmtime-c-api/lib"
        luajit_xcflags = "-DLUAJIT_NUMMODE=2 -DLUAJIT_ENABLE_LUA52COMPAT -fno-stack-check"
        
        args = %W[
            --prefix=#{prefix_or}
            --with-cc-opt=#{cc_opt}
            --with-ld-opt=#{ld_opt}
            --add-module=#{Formula["apisix-dubbo-module"].pkgshare}
            --add-module=#{Formula["apisix-multi-upstream-module"].pkgshare}
            --add-module=#{Formula["apisix-ngx-module"].pkgshare}
            --add-module=#{Formula["apisix-ngx-module"].pkgshare}/src/stream
            --add-module=#{Formula["apisix-ngx-module"].pkgshare}/src/meta
            --add-module=#{Formula["apisix-wasm-module"].pkgshare}
            --add-module=#{Formula["apisix-lua-var-module"].pkgshare}
            --with-poll_module 
            --with-pcre-jit
            --without-http_rds_json_module
            --without-http_rds_csv_module
            --without-lua_rds_parser
            --with-stream
            --with-stream_ssl_module
            --with-stream_ssl_preread_module
            --with-http_v2_module
            --without-mail_pop3_module
            --without-mail_imap_module
            --without-mail_smtp_module
            --with-http_stub_status_module
            --with-http_realip_module
            --with-http_addition_module
            --with-http_auth_request_module
            --with-http_secure_link_module
            --with-http_random_index_module
            --with-http_gzip_static_module
            --with-http_sub_module
            --with-http_dav_module
            --with-http_flv_module
            --with-http_mp4_module
            --with-http_gunzip_module
            --with-threads
            --with-compat
            --with-luajit-xcflags=#{luajit_xcflags}
            --pid-path=#{prefix_or}/nginx/logs/nginx.pid
            --lock-path=#{prefix_or}/nginx/logs/nginx.lock
            --conf-path=#{prefix_or}/nginx/conf/nginx.conf
            --http-log-path=#{prefix_or}/nginx/logs/access.log
            --error-log-path=#{prefix_or}/nginx/logs/error.log
            -j#{Etc.nprocessors}
        ]
        
        system "./configure", *args
        system "make"
        system "make", "install" 
    end

    def caveats
        prefix_or = "#{prefix}/openresty"
        <<~EOS
          You can find the configuration files for openresty under #{prefix_or}/nginx/conf .
          APISIX base openresty was been installed on #{prefix_or} .
        EOS
    end
    
    test do
        system "mkdir", "-p", "#{prefix_or}/nginx/logs"
        system "#{bin}/openresty", "-V"
    end
end
