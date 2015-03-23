#!/bin/bash

if [ $UID -ne "0" ];then
	echo "Run as root - sudo $0"
	exit 2
fi

LIBTORRENT="http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.4.tar.gz"
RTORRENT="http://libtorrent.rakshasa.no/downloads/rtorrent-0.9.4.tar.gz"

echo "Updating OS"
apt-get update && apt-get upgrade -y

echo "Installing packages"
apt-get install -y subversion build-essential automake libtool libcppunit-dev libcurl4-gnutls-dev libsigc++-2.0-dev unzip unrar-free curl libncurses5-dev libssl-dev

apt-get install -y nginx screen 

mkdir /html/
chown www-data. /html/

# XMLRPC
cd /tmp/
svn checkout http://xmlrpc-c.svn.sourceforge.net/svnroot/xmlrpc-c/stable xmlrpc-c
cd xmlrpc-c
./configure --disable-cplusplus
make
make install

# libtorrent
mkdir /tmp/lib
cd /tmp/lib
wget $LIBTORRENT
tar xzf *

cd libtorrent*
./autogen.sh
./configure
make 
make install

#rtorrent
mkdir /tmp/rtor/
cd /tmp/rtor/
wget $RTORRENT
tar xzf *
cd rtorrent*
./autogen.sh
./configure --with-xmlrpc-c
make
make install
ldconfig

# Directories
mkdir /home/andy/rtorrent
mkdir /home/andy/rtorrent/.session
mkdir /home/andy/rtorrent/watch
mkdir /home/andy/downloads

chown andy. /home/andy/rtorrent
chown andy. /home/andy/rtorrent/.session
chown andy. /home/andy/rtorrent/watch
chown andy. /home/andy/downloads

#rtorrent.rc
cat << EOF > /home/andy/.rtorrent.rc
directory = /home/andy/downloads/
session = /home/andy/rtorrent/.session/
schedule = watch_directory,5,5,load_start=/home/andy/rtorrent/watch/*.torrent
port_range = 55556-55560
scgi_port = 127.0.0.1:5000
use_udp_trackers = yes
encryption = allow_incoming,enable_retry,prefer_plaintext
upload_rate = 0
EOF

chown andy. /home/andy/.rtorrent.rc

#rutorrent
mkdir /tmp/rutor
cd /tmp/rutor
wget https://bintray.com/artifact/download/novik65/generic/rutorrent-3.6.tar.gz
tar xzf rutorrent*

mv rutorrent* /html/

wget https://bintray.com/artifact/download/novik65/generic/plugins-3.6.tar.gz
tar zxf plugins*
mv plugin* /html/rutorrent/

chown -R www-data. /html/*






