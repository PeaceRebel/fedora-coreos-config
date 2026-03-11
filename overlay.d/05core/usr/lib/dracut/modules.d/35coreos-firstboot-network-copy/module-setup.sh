check() {
    if [[ $IN_KDUMP == 1 ]]; then
        return 1
    fi
}

depends() {
    echo
}

install_and_enable_unit() {
    unit="$1"; shift
    target="$1"; shift
    inst_simple "$moddir/$unit" "$systemdsystemunitdir/$unit"
    # note we `|| exit 1` here so we error out if e.g. the units are missing
    # see https://github.com/coreos/fedora-coreos-config/issues/799
    systemctl -q --root="$initdir" add-requires "$target" "$unit" || exit 1
}

install() {

    inst_simple "$moddir/coreos-copy-firstboot-network.sh" \
        "/usr/sbin/coreos-copy-firstboot-network"
    install_and_enable_unit "coreos-copy-firstboot-network.service" \
        "ignition-complete.target"
}
