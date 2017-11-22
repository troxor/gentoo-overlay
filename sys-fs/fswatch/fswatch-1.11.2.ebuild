# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils multilib autotools

DESCRIPTION=""
HOMEPAGE="http://github.com/emcrisostomo/fswatch/wiki"
SRC_URI="http://github.com/emcrisostomo/fswatch/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="-doc"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
"
RDEPEND="${RDEPEND}
"

RESTRICT="test"

DOCS="AUTHORS AUTHORS.libfswatch ChangeLog CONTRIBUTING.md COPYING INSTALL NEWS README README.linux"


src_prepare() {

	eautoreconf
}


src_install() {
	default
}

