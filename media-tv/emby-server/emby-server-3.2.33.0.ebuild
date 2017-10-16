# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils user systemd git-r3 dotnet

DESCRIPTION="Emby Server (formerly known as MediaBrowser Server) is a software that indexes a lot of different kinds of media and allows for them to be retrieved and played through the DLNA protocol on any device capable of processing them."
HOMEPAGE="http://emby.media/"
KEYWORDS="-* ~arm ~amd64 ~x86"
SRC_URI="https://github.com/MediaBrowser/Emby/archive/${PV}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
IUSE="systemd"
RESTRICT="mirror test"

RDEPEND=">=dev-lang/mono-4.6.0
	>=media-video/ffmpeg-2[vpx]
	media-gfx/imagemagick[jpeg,jpeg2k,webp,png]
	!media-tv/mediabrowser-server
	>=dev-db/sqlite-3.0.0
	dev-dotnet/referenceassemblies-pcl
	app-misc/ca-certificates"
DEPEND="app-arch/unzip ${RDEPEND}"

INSTALL_DIR="/opt/${PN}"
DATA_DIR="/var/lib/${PN}"
STARTUP_LOG="/var/log/emby-server_start.log"
INIT_SCRIPT="${ROOT}/etc/init.d/${PN}"
SYSTEMD_UNIT="${ROOT}/usr/lib/systemd/system/${PN}.service"

# INSTALL
# #######################################################################################################

pkg_setup() {
	einfo "creating user for Emby"
	enewgroup emby
	enewuser emby -1 /bin/bash ${INSTALL_DIR} "emby"

	einfo "updating root certificates for mono certificate store"
        addwrite "/usr/share/.mono/keypairs"
	dotnet_pkg_setup
        cert-sync /etc/ssl/certs/ca-certificates.crt
}

# gentoo expects a specific subfolder in the working directory for the extracted source, so simply extracting won't work here
src_unpack() {
        unpack ${A}
        mv Emby-${PV} ${PN}-${PV}
}

src_prepare() {
	# the user can define the quality of the imagemagic himself, here we try to figure out the correct files to use in our configuration
	MAGICKWAND=$(ldconfig -p | grep MagickWand.*.so$ | cut -d" " -f4)
	MAGICKWAND=${MAGICKWAND##*/}
	einfo "adapting to imagemagick library to: ${MAGICKWAND}"
	sed -i -e "s/\"libMagickWand-6.Q8.so\"/\"${MAGICKWAND}\"/" MediaBrowser.Server.Mono/ImageMagickSharp.dll.config || die "could not update libMagickWand reference!"
}


src_compile() {
	xbuild /p:Configuration="Release Mono" /p:Platform="Any CPU" MediaBrowser.sln || die "building failed"
}

src_install() {
	einfo "preparing startup scripts"
	newinitd "${FILESDIR}"/emby-server.init_3  ${PN}

	# Install systemd service file
	local INIT_NAME="${PN}.service"
	local INIT="${FILESDIR}/${INIT_NAME}"
	systemd_newunit "${INIT}" "${INIT_NAME}"
	newconfd "${FILESDIR}"/emby-server.conf ${PN}

	einfo "preparing startup log file"
	dodir /var/log/
	touch ${D}${STARTUP_LOG}
	chown emby:emby ${D}${STARTUP_LOG}

	einfo "installing compiled files"
	diropts -oemby -gemby
	dodir ${INSTALL_DIR}
	cp -R ${S}/MediaBrowser.Server.Mono/bin/Release/* ${D}${INSTALL_DIR}/ || die "install failed, possibly compile did not succeed earlier?"
	chown emby:emby -R ${D}${INSTALL_DIR}

	einfo "prepare data directory"
	dodir ${DATA_DIR}
}

pkg_postinst() {
	einfo "All data generated and used by Emby can be found at ${DATA_DIR} after the first start."
	einfo ""
}

# UNINSTALL
# #######################################################################################################

pkg_prerm() {
	einfo "Stopping running instances of Emby Server"
	if [ -e "${INIT_SCRIPT}" ]; then
		${INIT_SCRIPT} stop
	fi
	if [ -e "${SYSTEMD_UNIT}" ]; then
		systemctl ${PN} stop
	fi
}
