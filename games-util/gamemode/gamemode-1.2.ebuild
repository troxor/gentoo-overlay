# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

inherit meson

DESCRIPTION="Feral Gamemode for enhancing"
HOMEPAGE="https://github.com/FeralInteractive/gamemode"
SRC_URI="https://github.com/FeralInteractive/gamemode/releases/download/1.2/gamemode-1.2.tar.xz"
SRC_URI="https://github.com/FeralInteractive/gamemode/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

IUSE="systemd -examples"

DEPEND="virtual/pkgconfig"
RDEPEND="
	systemd? ( sys-apps/systemd )
	!systemd? ( sys-apps/dbus )
"

#DOCS=( AUTHORS ChangeLog.rst README.md doc/README.NFS doc/kernel.txt )

src_prepare() {
	default

}

src_configure() {
	local emesonargs=(
		-D with-systemd=$(usex systemd true false)
		-D with-systemd-user-unit-dir=$(usex systemd /etc/systemd/user)
		-D with-dbus-service-dir=$(usex systemd false true)
		-D with-examples=$(usex examples true false)
		-D with-daemon=true
	)

	meson_src_configure
}

multilib_src_compile() {
	eninja
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
}
