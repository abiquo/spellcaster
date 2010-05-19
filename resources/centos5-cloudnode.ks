install
text

network --device eth0 --bootproto dhcp --hostname demo01

url --url http://mirror.bcn.abiquo.com/centos/5/os/x86_64
key --skip

lang en_US.UTF-8
langsupport --default=en_US.UTF-8 en_US.UTF-8
keyboard us
mouse none

zerombr yes
clearpart --all --drives=sda

part /boot --fstype ext2 --size=100
part pv.6 --size=22000 --ondisk=sda
part pv.17 --size=1000 --grow --ondisk=sda
volgroup systemvg pv.6
volgroup localvg --pesize=32768 pv.17
logvol / --fstype=ext3 --name=rootlv --vgname=systemvg --size=8000
logvol /tmp --fstype=ext3 --name=tmplv --vgname=systemvg --size=1000
logvol swap --fstype=swap --name=swaplv --vgname=systemvg --size=1024
logvol /var --fstype=ext3 --name=varlv --vgname=localvg --size=100000
logvol /opt --fstype=ext3 --name=optlv --vgname=localvg --size=5000

bootloader --location=mbr --driveorder=sda --append="rhgb quiet"
timezone Europe/Madrid
rootpw --iscrypted $1$TtUM5t1o$hGotzsHr9hsWM8NtNdGAP.
authconfig --enableshadow --enablemd5
selinux --disabled
reboot
firewall --disabled
skipx


repo --name="rpmforge" --baseurl="http://apt.sw.be/redhat/el5/en/x86_64/dag"

repo --name="rpmforge" --baseurl="http://download.opensuse.org/repositories/Openwsman/RHEL_5/"


%packages --resolvedeps --nobase

@core
mailx
postfix
gcc-c++
nfs-utils
ntp
dhclient
yum
openssh-clients
openssh-server
device-mapper-multipath
ntp
vconfig
man
man-pages
PyXML
vixie-cron
anacron
crontabs
wget
vim-enhanced
make
gcc
curl-devel
rsync
telnet
tcpdump
logrotate
which
automake
xorg-x11-fonts-base
xorg-x11-xauth
swig
subversion
unzip
cmake
libvirt-devel
libtool
SDL-devel
libxml2-devel
kernel-headers
gnutls-devel
cyrus-sasl-devel
pciutils-devel

#
# Useless stuff
#
%post
# Ajuste fino de la instalacion
echo >> /etc/motd
echo "You G0t Pwn3d" >> /etc/motd
echo >> /etc/motd

#
# Install ruby and gems
# POST STAGE 1
mkdir /tmp/install
pushd /tmp/install
wget http://packages.bcn.abiquo.com/ruby/ruby-enterprise-1.8.7-2.ep.x86_64.rpm
wget http://packages.bcn.abiquo.com/ruby/ruby-enterprise-rubygems-1.3.5-2.ep.x86_64.rpm
yum localinstall --nogpgcheck -y *.rpm
/usr/local/bin/gem install --no-ri --no-rdoc chef ohai sinatra haml >> log 2>&1
popd
