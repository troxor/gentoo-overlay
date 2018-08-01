# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit linux-info  meson

DESCRIPTION="Feral Gamemode for enhancing"
HOMEPAGE="https://github.com/FeralInteractive/gamemode"
SRC_URI="https://github.com/FeralInteractive/gamemode/releases/download/${PV}/${P}.tar.xz"

LICENSE="BSD"
SLOT="1"
KEYWORDS="~amd64 ~x86"

IUSE="systemd -examples +daemon"

DEPEND="virtual/pkgconfig"
RDEPEND="
	systemd? ( sys-apps/systemd )
	!systemd? ( sys-apps/dbus )
"

pkg_pretend() {
	CONFIG_CHECK="~CPU_FREQ"

	check_extra_config
}

src_configure() {

	local emesonargs=(
		-D with-systemd=$(usex systemd true false)
		-D with-examples=$(usex examples true false)
		-D with-daemon=$(usex daemon true false)
	)

	meson_src_configure
}

multilib_src_compile() {
	eninja
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
}

pkg_postinst() {
	einfo
	einfo "You should run systemctl --user daemon-reload"
	einfo
}
