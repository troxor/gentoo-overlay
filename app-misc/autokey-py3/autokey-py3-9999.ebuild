# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit distutils python

DESCRIPTION="A programm for automating tasks in Linux"
HOMEPAGE="https://github.com/guoci/autokey-py3"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/guoci/${PN}"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	SRC_URI="https://github.com/pkgcore/${PN}/releases/download/v${PV}/${P}.tar.gz"
fi

PYTHON_COMPAT=( python{3_4,3_5} )

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="qt4 gtk"
REQUIRED_USE="|| ( gtk qt4 )"

PYTHON_DEPEND='3'
DEPEND="dev-python/python3-xlib
	dev-python/dbus-python
	gnome-extra/zenity
	media-gfx/imagemagick[svg]
	dev-python/pyinotify
	x11-misc/wmctrl
	x11-misc/xautomation
	x11-themes/hicolor-icon-theme
	x11-apps/xwd
	gtk? ( =dev-python/pygobject-3*
		x11-libs/libnotify
		dev-python/pygtksourceview )
	qt4? ( kde-base/pykde4
	    dev-python/qscintilla-python )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${PV}"

src_install(){
	distutils_src_install
	doicon config/autokey-status-dark.svg config/autokey-status-light.svg config/autokey-status.svg config/autokey.svg config/autokey.png
	if use gtk ; then
		rm ${D}/usr/share/applications/autokey-qt.desktop
	fi
	if use qt4 ; then
		rm ${D}/usr/share/applications/autokey-gtk.desktop
	fi
}
