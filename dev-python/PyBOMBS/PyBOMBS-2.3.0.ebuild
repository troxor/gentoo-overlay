# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="A meta-package manager to install software from source"
HOMEPAGE="https://pypi.python.org/pypi/PyBOMBS"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="test"

RDEPEND="
	>=dev-python/chardet-2.2.1[${PYTHON_USEDEP}]
	dev-python/ndg-httpsclient[${PYTHON_USEDEP}]
	>=dev-python/py-1.4.30[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13[$(python_gen_usedep 'python*' pypy)]
	>=dev-python/urllib3-1.13.1-r1[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/PyYAML[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	"

RESTRICT="test"

PATCHES=(
)

#python_prepare_all() {
#	# use system chardet & urllib3
#	rm -r requests/packages/{chardet,urllib3} || die
#
#	distutils-r1_python_prepare_all
#}

#python_test() {
#	py.test -v || die
#}
