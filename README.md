# homebrew-apisix
Apisix Homebrew Tap

## Basic Usage

Firstly add tap, just run `brew tap zhangw/apisix`

Install apisix-base (Openresty), just run `brew install apisix-base`

Use option *--keep-tmp* for keeping the original source codes (such as Nginx modules bundle) reserved during building, `brew install --keep-tmp apisix-base`

Install apisix (apisix-base and apisix itself), just run `brew install apisix`

Use option *-d -v* for the debugging installtaion, `brew install -d -v apisix | tee apisix_install_dignostic.log`

## For Chinese Users

Before installation, set the proxy could help fetching github related resources, such as pkgs, source codes.

```
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
```

## Roadmap

- brew bottole pkgs
- third party resty pkgs installed into apisix
- more versions of apisix, 2.15.1/3.0