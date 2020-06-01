#!/usr/bin/env bash
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="openbor-fflns"
rp_module_desc="OpenBOR - Beat 'em Up Game Engine fflns mod"
rp_module_help="Place your pak files in $romdir/openbor"
rp_module_licence="BSD 3 https://raw.githubusercontent.com/DCurrent/openbor/master/LICENSE"
rp_module_section="exp"
rp_module_flags="!mali !x11"

function depends_openbor-fflns() {
    getDepends libsdl2-gfx-dev libvorbisidec-dev libvpx-dev libogg-dev libsdl2-gfx-1.0-0 libvorbisidec1
}

function sources_openbor-fflns() {
    gitPullOrClone "$md_build" https://github.com/gonzalomvp/openbor v6330-fflns_v10d-rpi
}

function build_openbor-fflns() {
    local params=()
    ! isPlatform "x11" && params+=(BUILD_PANDORA=1)
    cd engine
    make clean-all BUILD_PANDORA=1
    make "${params[@]}"
    md_ret_require="$md_build/engine/OpenBOR"
}

function install_openbor-fflns() {
    md_ret_files=(
       'engine/OpenBOR'
    )
}

function configure_openbor-fflns() {
    addEmulator 1 "${md_id}" "openbor" "pushd $md_inst; $md_inst/OpenBOR %ROM%; popd"
    addSystem "openbor" "OpenBOR" ".pak"
    mkRomDir "openbor"

    local dir
    for dir in ScreenShots Saves; do
        mkUserDir "$md_conf_root/openbor/$md_id/$dir"
        ln -snf "$md_conf_root/openbor/$md_id/$dir" "$md_inst/$dir"
    done

    ln -snf "$romdir/openbor" "$md_inst/Paks"
    ln -snf "/dev/shm" "$md_inst/Logs"
}
