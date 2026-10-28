source /tmp/gpui-native-env.sh
unset RUSTC_BOOTSTRAP RUSTFLAGS CARGO_ENCODED_RUSTFLAGS
export PKG_CONFIG=/nix/store/sn8r7j6q1js540y5briylnb62203zxq5-pkg-config-wrapper-0.29.2/bin/pkg-config
export PKG_CONFIG_PATH=/nix/store/99x1jg5622a0k9ch4pwnwaiqvaanlam7-alsa-lib-1.2.16-dev/lib/pkgconfig
export LD_LIBRARY_PATH=/nix/store/6v3x79khipmf0zbn2yivvx7n15jccv47-alsa-lib-1.2.16/lib:$LD_LIBRARY_PATH
export CARGO_BUILD_JOBS=1 CARGO_TARGET_DIR=/tmp/gpui-hummingbird-main-eos-target
