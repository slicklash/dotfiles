#!/bin/sh
set -e

#sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
#    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
#        libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
#            ruby-dev mercurial
#	lua53 liblua5.3-dev

SRC=~/code/vim

COMPILED_BY="slicklash <slicklash@gmail.com>"
PYTHON_VERSION="3.6"

FEAT=
FEAT="$FEAT --with-features=huge"
FEAT="$FEAT --enable-multibyte"
FEAT="$FEAT --with-python3-config-dir=/usr/lib/python$PYTHON_VERSION/config-$PYTHON_VERSIONm-$(dpkg-architecture -qDEB_HOST_MULTIARCH)"
FEAT="$FEAT --enable-luainterp"
#FEAT="$FEAT --with-lua-prefix=/usr/include/lua5.3"
FEAT="$FEAT --enable-python3interp"
FEAT="$FEAT --disable-netbeans"
FEAT="$FEAT --enable-cscope"
FEAT="$FEAT --enable-gpm"
FEAT="$FEAT --with-x"
FEAT="$FEAT --enable-xim"
FEAT="$FEAT --enable-gui=gtk2"
FEAT="$FEAT --enable-fail-if-missing"

CFLAGS="-g -I/usr/include/lua5.3"


test -d $SRC || {
    echo "No Vim sources found. Cloning ..." 1>&2
    git clone https://github.com/vim/vim/ $SRC 1>&2
}

cd $SRC
git pull
rm -f src/auto/config.cache
CFLAGS="$CFLAGS" ./configure $FEAT --with-compiledby="$COMPILED_BY" \
&& make VIMRUNTIMEDIR=/usr/local/share/vim/vim81 -j4 && uname -m > .arch || {
    echo "Consider" 1>&2
    echo "  sudo apt-get build-dep vim-gnome" 1>&2
    exit 1
}

cd $SRC
sudo make install clean
cd -
