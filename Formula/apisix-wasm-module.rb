class ApisixWasmModule < Formula
    desc "A Nginx module which tries to implement proxy wasm ABI in Nginx. The Wasm integration of Apache APISIX is powered by this module."
    homepage "https://github.com/api7/wasm-nginx-module"
    wasm_nginx_module_ver = "0.6.2".freeze
    url "https://github.com/api7/wasm-nginx-module/archive/refs/tags/#{wasm_nginx_module_ver}.tar.gz"
    sha256 "cf6e935b2b925eb0d89d2c174d4f50241361a6a1094fe061671e06de26312329"
    
    # details from here: https://github.com/api7/wasm-nginx-module/blob/main/install-wasmtime.sh
    # TODO: installation via source code not supported if libc is musl or under centos aarch64
    resource "wasmtime-c-api" do
        wasm_ver = "v0.38.1".freeze
        os = OS.mac? ? "macos" : "linux" 
        arch = Hardware::CPU.intel? ? "x86_64" : "aarch64"
        url "https://github.com/bytecodealliance/wasmtime/releases/download/#{wasm_ver}/wasmtime-#{wasm_ver}-#{arch}-#{os}-c-api.tar.xz" 
    end

    def install
        pkgshare.install Dir["*"]
        resources.each do |r|
            if r.name == "wasmtime-c-api"
                r.stage do
                    (pkgshare/"wasmtime-c-api/lib").install Dir["lib/*"]
                    (pkgshare/"wasmtime-c-api/include").install Dir["include/*"]
                end
            end 
        end
    end
end