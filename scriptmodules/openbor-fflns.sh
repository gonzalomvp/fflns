#!/usr/bin/env bash
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="openbor-fflns"
rp_module_desc="Final Fight LNS 3.0"
rp_module_help="Place Final Fight LNS.pak in $romdir/ports/openbor-fflns and then run Final Fight LNS 3.0 from ports section in emulationstation."
rp_module_licence="BSD 3 https://raw.githubusercontent.com/DCurrent/openbor/master/LICENSE"
rp_module_section="exp"
rp_module_flags="!mali !x11"

function depends_openbor-fflns() {
    getDepends libsdl2-gfx-dev libvorbisidec-dev libvpx-dev libogg-dev libsdl2-gfx-1.0-0 libvorbisidec1
}

function sources_openbor-fflns() {
    gitPullOrClone "$md_build" https://github.com/DCurrent/openbor v6330
}

function build_openbor-fflns() {
    local params=()
    ! isPlatform "x11" && params+=(BUILD_PANDORA=1)
    wget https://raw.githubusercontent.com/gonzalomvp/fflns/master/patches/openbor6330_lnsv08.patch
    patch -p0 -i ./openbor6330_lnsv08.patch
    cd engine
    wget https://raw.githubusercontent.com/crcerror/OpenBOR-Raspberry/master/patch/latest_build.diff
    patch -p0 -i ./latest_build.diff
    make clean-all BUILD_PANDORA=1
    make "${params[@]}"
    md_ret_require="$md_build/engine/OpenBOR"
    wget -q --show-progress "http://raw.githubusercontent.com/crcerror/OpenBOR-63xx-RetroPie-openbeta/master/libGL-binary/libGL.so.1.gz"
    gunzip -f libGL.so.1.gz
}

function install_openbor-fflns() {
    md_ret_files=(
       'engine/OpenBOR'
       'engine/libGL.so.1'
    )
}

function configure_openbor-fflns() {
    addPort "$md_id" "$md_id" "Final Fight LNS 3.0" "pushd $md_inst; $md_inst/OpenBOR $romdir/ports/$md_id/Final Fight LNS.pak; popd"
    mkRomDir "ports/$md_id"

    #Correcting file owner and attributes
    chown $(logname):$(logname) "$romdir/ports/Final Fight LNS 3.0.sh"
    chmod +x "$romdir/ports/Final Fight LNS 3.0.sh"

    local dir
    for dir in ScreenShots Saves; do
        mkUserDir "$md_conf_root/$md_id/$dir"
        ln -snf "$md_conf_root/$md_id/$dir" "$md_inst/$dir"
    done

    ln -snf "$romdir/ports/$md_id" "$md_inst/Paks"
    ln -snf "/dev/shm" "$md_inst/Logs"
}

