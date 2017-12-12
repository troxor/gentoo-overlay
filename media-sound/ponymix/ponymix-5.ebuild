# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils multilib autotools

DESCRIPTION=""
HOMEPAGE="http://github.com/falconindy/ponymix/wiki"
SRC_URI="https://github.com/falconindy/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 x86-fbsd"
IUSE="zsh-completion"

RDEPEND=""
DEPEND="${RDEPEND}
	zsh-completion? ( app-shells/zsh )
"
RDEPEND="${RDEPEND}
"

RESTRICT="test"

DOCS="LICENSE README.md"

src_install() {
	default

	if use zsh-completion; then
		mv zsh-completion _ponymix
		insinto /usr/share/zsh/site-functions
		doins _ponymix
	fi
}

